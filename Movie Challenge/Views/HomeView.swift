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
        }
    }
}

struct HomeView: View {
    let store: StoreOf<Home>
    var hasIgnoredFirstNavDest = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack() {
                ScrollView {
                    VStack {
                        Top5View(movies: viewStore.top5Movies)
                        
                        CatalogSectionView()
                        
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

struct CatalogSectionView: View {
    var body: some View {
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: Home.State(), reducer: Home()))
    }
}
