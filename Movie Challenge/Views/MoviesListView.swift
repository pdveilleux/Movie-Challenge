import SwiftUI
import MovieAPI
import ComposableArchitecture

struct MoviesList: ReducerProtocol {
    @Dependency(\.apiService) var apiService
    
    struct State: Equatable {
        var error: Error?
        var genre: String
        var updateTrigger = false
        var movies: [Movie] = []
    }
    
    enum Error {
        case unableToFetchMovies
    }
    
    enum Action: Equatable {
        case load
        case moviesResponse(TaskResult<[Movie]>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .load:
            let genre = state.genre
            return .task {
                await .moviesResponse(
                    TaskResult {
                        try await apiService.getMoviesForGenre(genre: genre)
                    }
                )
            }
            
        case let .moviesResponse(.success(movies)):
            state.movies = movies
            state.updateTrigger.toggle()
            print("Loaded movies for genre \(movies.count)")
            return .none
            
        case .moviesResponse(.failure):
            state.error = .unableToFetchMovies
            return .none
        }
    }
}

struct MoviesListView: View {
    let store: StoreOf<MoviesList>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List(viewStore.movies) { movie in
                HStack(alignment: .top) {
                    MoviePosterView(movie: movie)
                        .frame(width: 120, height: 180)
                    
                    VStack {
                        Group {
                            Text(movie.title)
                                .font(.title3)
                                .bold()
                            
                            if let date = movie.releaseDate {
                                Text(date.formatted(date: .long, time: .omitted))
                                    .font(.callout)
                            }
                            
                            if let voteAverage = movie.voteAverage {
                                RatingLabel(rating: voteAverage)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .navigationTitle(viewStore.genre)
            .onAppear {
                viewStore.send(.load)
            }
        }
    }
}

//struct MoviesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviesListView()
//    }
//}
