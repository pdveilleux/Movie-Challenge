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
    
    public func getMoviesForGenre(genre: String) async throws -> [Movie] {
        try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: GetMoviesForGenreQuery(genre: genre)) { result in
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
    
    public func getGenres() async throws -> [String] {
        try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: GetGenresQuery()) { result in
                do {
                    let genres = try result.get().data?.genres
                    guard let genres else { throw APIError.noData }
                    continuation.resume(returning: genres)
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
