import Foundation

struct MovieDateFormatter {
    static func formatDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
}

public struct Movie {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let genres: [String]
    public let director: Director?
    public let releaseDate: Date?
    public let voteAverage: Double?
    public let voteCount: Int?
    public let overview: String
    public let popularity: Double?
    public let cast: [Cast]
    
    public init(id: Int, title: String, posterPath: String? = nil, genres: [String] = [], director: Director? = nil, releaseDate: Date? = nil, voteAverage: Double? = nil, voteCount: Int? = nil, overview: String = "", popularity: Double? = nil, cast: [Cast] = []) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.genres = genres
        self.director = director
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.overview = overview
        self.popularity = popularity
        self.cast = cast
    }
}

extension Movie {
    init?(movie: GetTop5MoviesQuery.Data.Movie?) {
        guard let movie else { return nil }
        id = movie.id
        title = movie.title
        posterPath = movie.posterPath
        genres = movie.genres
        director = nil
        releaseDate = MovieDateFormatter.formatDate(from: movie.releaseDate)
        voteAverage = movie.voteAverage
        voteCount = movie.voteCount
        overview = movie.overview
        popularity = nil
        cast = []
    }
}

extension Movie {
    init(movie: GetMovieQuery.Data.Movie) {
        id = movie.id
        title = movie.title
        posterPath = movie.posterPath
        genres = movie.genres
        director = Director(director: movie.director)
        releaseDate = MovieDateFormatter.formatDate(from: movie.releaseDate)
        voteAverage = movie.voteAverage
        voteCount = movie.voteCount
        overview = movie.overview
        popularity = movie.popularity
        cast = movie.cast.map { Cast(cast: $0) }
    }
}

extension Movie {
    init?(movie: GetMoviesForGenreQuery.Data.Movie?) {
        guard let movie else { return nil }
        id = movie.id
        title = movie.title
        posterPath = movie.posterPath
        genres = movie.genres
        director = nil
        releaseDate = MovieDateFormatter.formatDate(from: movie.releaseDate)
        voteAverage = movie.voteAverage
        voteCount = movie.voteCount
        overview = movie.overview
        popularity = movie.popularity
        cast = []
    }
}

extension Movie: Equatable {}
extension Movie: Hashable {}
