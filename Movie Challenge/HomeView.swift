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

struct Top5View: View {
    let movies: [Movie]
    
    var body: some View {
        Section("Top 5") {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(movies) { movie in
                        MoviePosterView(movie: movie)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct MoviePosterView: View {
    let movie: Movie
    
    var body: some View {
        AsyncImage(url: URL(string: movie.posterPath ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
        } placeholder: {
            ProgressView()
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: Home.State(), reducer: Home(apiService: APIService())))
    }
}

extension Home.State {
    static func testState() -> Home.State {
        .init(error: nil, top5Movies: [
            .init(id: 1, title: "Movie 1"),
            .init(id: 2, title: "Movie 2"),
            .init(id: 3, title: "Movie 3"),
            .init(id: 4, title: "Movie 4"),
            .init(id: 5, title: "Movie 5"),
        ])
    }
}
