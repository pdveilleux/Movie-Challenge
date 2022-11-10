import Foundation

public struct Cast {
    public let profilePath: String?
    public let name: String
    public let character: String
    public let order: Int
}

extension Cast: Equatable {}
extension Cast: Hashable {}

extension Cast {
    init(cast: GetMovieQuery.Data.Movie.Cast) {
        profilePath = cast.profilePath
        name = cast.name
        character = cast.character
        order = cast.order
    }
}
