import SwiftUI
import ComposableArchitecture
import MovieAPI

struct MovieDetail: ReducerProtocol {
    @Dependency(\.apiService) var apiService

    struct State: Equatable {
        var error: Error?
        var movie: Movie
    }
    
    enum Error {
        case unableToFetchMovie
    }
    
    enum Action: Equatable {
        case load
        case movieResponse(TaskResult<Movie>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .load:
            let movie = state.movie
            return .task {
                await .movieResponse(
                    TaskResult {
                        try await apiService.getMovie(id: movie.id)
                    }
                )
            }
        
        case let .movieResponse(.success(movie)):
            state.movie = movie
            print("movie: \(movie.overview)")
            return .none
            
        case .movieResponse(.failure):
            state.error = .unableToFetchMovie
            print("error")
            return .none
        }
    }
}

struct MovieDetailView: View {
    let store: StoreOf<MovieDetail>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack {
                    // header
                    HStack(alignment: .bottom) {
                        MoviePosterView(movie: viewStore.movie)
                            .frame(width: 160, height: 240)
                            .onTapGesture {
                                // show poster sheet
                            }
                        
                        VStack {
                            Group {
                                Text(viewStore.movie.title)
                                    .font(.title)
                                    .bold()
                                
                                if let date = viewStore.movie.releaseDate {
                                    Text(date.formatted(date: .long, time: .omitted))
                                        .font(.callout)
                                }
                                
                                if let voteAverage = viewStore.movie.voteAverage {
                                    RatingLabel(rating: voteAverage)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal)
                    }
                    
                    Text(viewStore.movie.overview)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewStore.movie.title)
            .onAppear {
                viewStore.send(.load)
            }
        }
    }
}

//struct MovieDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieDetailView()
//    }
//}
