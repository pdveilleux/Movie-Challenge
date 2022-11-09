import SwiftUI
import Combine
import MovieAPI
import ComposableArchitecture

struct Home: ReducerProtocol {
    let apiService: APIService
    
    struct State: Equatable {
        var navPath: [Route] = []
        var error: Error?
        var top5Movies: [Movie] = []
    }
    
    enum Route: Hashable {
        case movie(Movie)
        case genre(String)
    }
    
    enum Error {
        case unableToFetchMovies
    }

    enum Action: Equatable {
        case loadTop5
        case top5Response(TaskResult<[Movie]>)
        case viewMovie(Movie)
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
            
        case let .viewMovie(movie):
            state.navPath.append(.movie(movie))
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
                        Top5View(movies: viewStore.top5Movies, viewStore: viewStore)
                    }
                }
                .navigationTitle("Movies")
                .navigationDestination(for: Home.Route.self) { route in
                    switch route {
                    case let .movie(movie):
                        Text(movie.title)
                        
                    case let .genre(genre):
                        Text(genre)
                    }
                }
            }
            .onAppear {
                viewStore.send(.loadTop5)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: Home.State(), reducer: Home(apiService: APIService())))
    }
}
