import SwiftUI
import Combine
import MovieAPI
import ComposableArchitecture

struct Home: ReducerProtocol {
    let apiService: APIService
    
    struct State: Equatable {
        var error: Error?
        var top5Movies: [Movie] = []
    }
    
    enum Error {
        case unableToFetchMovies
    }

    enum Action: Equatable {
        case loadTop5
        case top5Response(TaskResult<[Movie]>)
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
        }
    }
}

struct HomeView: View {
    let store: StoreOf<Home>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    VStack {
                        Top5View(movies: viewStore.top5Movies)
                    }
                }
                .navigationTitle("Movies")
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
