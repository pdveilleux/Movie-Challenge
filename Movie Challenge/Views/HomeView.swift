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

enum Route: Hashable {
    case movie(Movie)
    case genre(String)
    case browse
}

struct Home: ReducerProtocol {
    @Dependency(\.apiService) var apiService
    
    struct State: Equatable {
        var navPath: [Route] = [] {
            didSet {
                print("navPath changed")
            }
        }
        var error: Error?
        var top5Movies: [Movie] = []
        var genres: [String] = []
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
        case browse
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
            
        case .browse:
            state.navPath.append(.browse)
            return .none

        case let .updatePath(route):
            print("Update path \(route)")
            state.navPath = route
            return .none
        }
    }
}

struct HomeView: View {
    let store: StoreOf<Home>
    var hasIgnoredFirstNavDest = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(get: \.navPath, send: { .updatePath($0) })) {
                ScrollView {
                    VStack {
                        Top5View(movies: viewStore.top5Movies)
                        
                        Section {
                            HStack {
                                Button {
                                    // Handled by NavigationLink
                                } label: {
                                    NavigationLink {
                                        MoviesListView(
                                            store: Store(
                                                initialState: .init(),
                                                reducer: MoviesList()
                                            )
                                        )
                                    } label: {
                                        Label("Browse", systemImage: "magnifyingglass")
                                            .labelStyle(.titleOnly)
                                    }
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                                .tint(.green)
                                .buttonBorderShape(.capsule)
                                .padding(.horizontal)
                                
                                Spacer()
                            }
                            
                        } header: {
                            HStack {
                                Text("Catalog")
                                    .font(.title2)
                                    .bold()
                                    .padding()
                                Spacer()
                            }
                        }
                        
                        GenresGridView(genres: viewStore.genres)
                    }
                }
                .navigationTitle("Movies")
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
