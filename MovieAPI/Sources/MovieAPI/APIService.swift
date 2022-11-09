import Foundation
import Apollo
import GeneratedAPI

public class APIService {
    let client: ApolloClient
    
    public init(client: ApolloClient = Network.shared.apollo) {
        self.client = client
    }
    
    public func getTop5Movies() async throws -> [Movie] {
        try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: GetTop5MoviesQuery()) { result in
                do {
                    let movies = try result.get().data?.movies?.compactMap { Movie(movie: $0) }
                    continuation.resume(returning: movies ?? [])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func getMovie(id: Int) async throws -> Movie {
        try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: GetMovieQuery(id: id)) { result in
                do {
                    let data = try result.get().data?.movie
                    guard let data else { throw APIError.noData }
                    continuation.resume(returning: Movie(movie: data))
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension APIService {
    enum APIError: Error {
        case noData
    }
}

public struct Movie {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let genres: [String]
    public let director: Director?
    
    public init(id: Int, title: String, posterPath: String? = nil, genres: [String] = [], director: Director? = nil) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.genres = genres
        self.director = director
    }
}

public struct Director {
    public let id: Int
    public let name: String
}

extension Movie {
    init?(movie: GetTop5MoviesQuery.Data.Movie?) {
        guard let movie else { return nil }
        id = movie.id
        title = movie.title
        posterPath = movie.posterPath
        genres = movie.genres
        director = nil
    }
}

extension Movie {
    init(movie: GetMovieQuery.Data.Movie) {
        id = movie.id
        title = movie.title
        posterPath = movie.posterPath
        genres = movie.genres
        director = nil
    }
}

extension Movie: Equatable {}
extension Movie: Hashable {}

extension Director: Equatable {}
extension Director: Hashable {}
