import SwiftUI
import ComposableArchitecture
import MovieAPI
import CachedAsyncImage

struct MovieDetail: ReducerProtocol {
    @Dependency(\.apiService) var apiService

    struct State: Equatable {
        var error: Error?
        var movie: Movie
        var viewPoster: Bool = false
    }
    
    enum Error {
        case unableToFetchMovie
    }
    
    enum Action: Equatable {
        case load
        case movieResponse(TaskResult<Movie>)
        case tapPoster
        case updatePoster(Bool)
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
            return .none
            
        case .movieResponse(.failure):
            state.error = .unableToFetchMovie
            return .none
            
        case .tapPoster:
            state.viewPoster = true
            return .none
            
        case let .updatePoster(showing):
            state.viewPoster = showing
            return .none
        }
    }
}

struct MovieDetailView: View {
    let store: StoreOf<MovieDetail>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // header
                    HeaderView(movie: viewStore.movie) {
                        viewStore.send(.tapPoster)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overview")
                            .font(.title2)
                            .bold()
                        
                        Text(viewStore.movie.overview)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Director")
                            .font(.title2)
                            .bold()
                        
                        if let director = viewStore.movie.director {
                            Text(director.name)
                                .bold()
                                .padding(.horizontal)
                        }
                    }
                    .frame(idealWidth: .infinity)
                    
                    CastView(cast: viewStore.movie.cast)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Genres")
                            .font(.title2)
                            .bold()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(viewStore.movie.genres, id: \.self) { genre in
                                Text(genre)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .frame(idealWidth: .infinity)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewStore.movie.title)
            .onAppear {
                viewStore.send(.load)
            }
            .sheet(isPresented: viewStore.binding(
                get: \.viewPoster,
                send: { .updatePoster($0) })) {
                    MoviePosterView(movie: viewStore.movie)
                }
        }
    }
}

extension MovieDetailView {
    struct HeaderView: View {
        let movie: Movie
        let posterTapHandler: () -> ()
        
        var body: some View {
            HStack(alignment: .bottom, spacing: 12) {
                MoviePosterView(movie: movie)
                    .frame(width: 160, height: 240)
                    .onTapGesture {
                        posterTapHandler()
                    }
                
                VStack(spacing: 4) {
                    Group {
                        Text(movie.title)
                            .font(.title)
                            .bold()
                        
                        if let date = movie.releaseDate {
                            Text(date.formatted(date: .long, time: .omitted))
                                .font(.callout)
                        }
                        
                        if let voteAverage = movie.voteAverage {
                            RatingLabel(rating: voteAverage)
                        }
                        
                        if let popularity = Popularity(popularity: movie.popularity) {
                            Text(popularity.rawValue)
                                .font(.callout)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    struct CastView: View {
        let cast: [Cast]
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Cast")
                    .font(.title2)
                    .bold()
                
                LazyVStack(alignment: .leading) {
                    ForEach(cast, id: \.order) { cast in
                        HStack {
                            CachedAsyncImage(url: URL(string: cast.profilePath ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Image(systemName: "person.fill")
                            }
                            .frame(width: 80, height: 120)
                            
                            VStack(alignment: .leading) {
                                Text(cast.name)
                                    .bold()
                                Text("Role: \(cast.character)")
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct MovieDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieDetailView()
//    }
//}
