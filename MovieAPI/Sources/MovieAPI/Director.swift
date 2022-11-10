import Foundation

public struct Director {
    public let id: Int
    public let name: String
}

extension Director: Equatable {}
extension Director: Hashable {}

extension Director {
    init(director: GetMovieQuery.Data.Movie.Director) {
        id = director.id
        name = director.name
    }
}
