import SwiftUI
import MovieAPI
import ComposableArchitecture

extension APIService: DependencyKey {
    public static var liveValue: MovieAPI.APIService = APIService()
}

extension DependencyValues {
    var apiService: APIService {
        get { self[APIService.self] }
        set { self[APIService.self] = newValue }
    }
}

struct Home: ReducerProtocol {
    @Dependency(\.apiService) var apiService
    
    struct State: Equatable {
        var navPath: [Route] = []
        var error: Error?
        var top5Movies: [Movie] = []
        var genres: [String] = []
    }
    
    enum Route: Hashable {
        case movie(Movie)
        case genre(String)
    }
    
    enum Error {
        case unableToFetchMovies
        case unableToFetchGenres
    }

    enum Action: Equatable {
        case loadTop5
        case top5Response(TaskResult<[Movie]>)
        case loadGenres
        case genresResponse(TaskResult<[String]>)
        case viewMovie(Movie)
        case viewGenre(String)
        case updatePath([Route])
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loadTop5:
            return .task {
                await .top5Response(
                    TaskResult {
                        try await apiService.getTop5Movies()
                    }
                )
            }
            
        case let .top5Response(.success(movies)):
            state.top5Movies = movies
            return .none
            
        case .top5Response(.failure):
            state.error = .unableToFetchMovies
            return .none
            
        case .loadGenres:
            return .task {
                await .genresResponse(
                    TaskResult {
                        try await apiService.getGenres()
                    }
                )
            }
        
        case let .genresResponse(.success(genres)):
            state.genres = genres.sorted(by: <)
            return .none
        
        case .genresResponse(.failure):
            state.error = .unableToFetchGenres
            return .none
        
        case let .viewMovie(movie):
            state.navPath.append(.movie(movie))
            return .none
            
        case let .viewGenre(genre):
            state.navPath.append(.genre(genre))
            return .none

        case let .updatePath(route):
            state.navPath = route
            return .none
        }
    }
}

struct HomeView: View {
    let store: StoreOf<Home>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(get: \.navPath, send: { .updatePath($0) })) {
                ScrollView {
                    VStack {
                        Top5View(movies: viewStore.top5Movies) {
                            viewStore.send(.viewMovie($0))
                        }
                        
                        GenresGridView(genres: viewStore.genres) {
                            viewStore.send(.viewGenre($0))
                        }
                    }
                }
                .navigationTitle("Movies")
                .navigationDestination(for: Home.Route.self) { route in
                    switch route {
                    case let .movie(movie):
                        MovieDetailView(
                            store: Store(
                                initialState: MovieDetail.State(movie: movie),
                                reducer: MovieDetail()))
                        
                    case let .genre(genre):
                        MoviesListView(
                            store: Store(
                                initialState: MoviesList.State(genre: genre),
                                reducer: MoviesList()))
                    }
                }
            }
            .onAppear {
                viewStore.send(.loadTop5)
                viewStore.send(.loadGenres)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: Home.State(), reducer: Home()))
    }
}
