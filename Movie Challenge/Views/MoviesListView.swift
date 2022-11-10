import SwiftUI
import MovieAPI
import ComposableArchitecture

struct MoviesList: ReducerProtocol {
    @Dependency(\.apiService) var apiService
    
    struct State: Equatable {
        var navPath: [Route] = []
        var error: Error?
        var filter: Filter = .init()
        var sort: Sort = .popularity(.descending) {
            didSet {
                
            }
        }
        var updateTrigger = false
        var movies: [Movie] = []
        
        var title: String {
            if let genre = filter.genre {
                return genre
            } else {
                return "All Movies"
            }
        }
    }
    
    enum Sort: Equatable, Hashable {
        case popularity(Order)
        case rating(Order)
        case title(Order)
        case releaseDate(Order)
    }
    
    enum Order: Equatable {
        case ascending
        case descending
        
        func sort<T: Comparable>(_ first: T, _ second: T) -> Bool {
            switch self {
            case .ascending:
                return first < second
                
            case .descending:
                return first > second
            }
        }
    }
    
    struct Filter: Equatable {
        var genre: String?
    }
    
    enum Route: Hashable {
        case movie(Movie)
    }
    
    enum Error {
        case unableToFetchMovies
    }
    
    enum Action: Equatable {
        case load
        case moviesResponse(TaskResult<[Movie]>)
        case viewMovie(Movie)
        case updatePath([Route])
        case sort(Sort)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .load:
            let filter = state.filter
            return .task {
                await .moviesResponse(
                    TaskResult {
                        try await apiService.getMoviesForGenre(genre: filter.genre)
                    }
                )
            }
            
        case let .moviesResponse(.success(movies)):
            state.movies = movies
            state.updateTrigger.toggle()
            return .none
            
        case .moviesResponse(.failure):
            state.error = .unableToFetchMovies
            return .none
            
        case let .viewMovie(movie):
            state.navPath.append(.movie(movie))
            return .none

        case let .updatePath(route):
            state.navPath = route
            return .none

        case let .sort(sort):
            state.sort = sort
            state.movies.sort {
                switch sort {
                case let .popularity(order):
                    return order.sort($0.popularity ?? 0, $1.popularity ?? 0)
                    
                case let .rating(order):
                    return order.sort($0.voteAverage ?? 0, $1.voteAverage ?? 0)
                    
                case let .title(order):
                    return order.sort($0.title, $1.title)
                    
                case let .releaseDate(order):
                    return order.sort($0.releaseDate ?? .distantPast, $1.releaseDate ?? .distantPast)
                }
            }
            return .none
        }
    }
}

struct MoviesListView: View {
    let store: StoreOf<MoviesList>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List(viewStore.movies) { movie in
                NavigationLink(
                    destination: MovieDetailView(store: Store(initialState: .init(movie: movie), reducer: MovieDetail()))
                ) {
                    HStack(alignment: .top) {
                        MoviePosterView(movie: movie)
                            .frame(width: 120, height: 180)
                        
                        VStack(spacing: 4) {
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewStore.title)
            .toolbar {
                sortButton(viewStore: viewStore)
            }
            .onAppear {
                viewStore.send(.load)
            }
        }
    }
    
    func sortButton(viewStore: ViewStore<MoviesList.State, MoviesList.Action>) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Picker(selection: viewStore.binding(get: \.sort, send: { .sort($0) })) {
                    Text("Popularity").tag(MoviesList.Sort.popularity(.descending))
                    Text("Rating").tag(MoviesList.Sort.rating(.descending))
                    Text("Title").tag(MoviesList.Sort.title(.ascending))
                    Text("Recently Released").tag(MoviesList.Sort.releaseDate(.descending))
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }
}

enum Popularity: String {
    case extremelyPopular = "Extremely Popular"
    case veryPopular = "Very Popular"
    case moderatelyPopular = "Moderately Popular"
    case notVeryPopular = "Not Very Popular"
    case notPopular = "Not Popular"
    
    init?(popularity: Double?) {
        guard let popularity else { return nil }
        switch popularity {
        case ...150: self = .notPopular
        case 150..<250: self = .notVeryPopular
        case 250..<550: self = .moderatelyPopular
        case 550..<1000: self = .veryPopular
        case 1000...: self = .extremelyPopular
        default: return nil
        }
    }
}

//struct MoviesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviesListView()
//    }
//}
