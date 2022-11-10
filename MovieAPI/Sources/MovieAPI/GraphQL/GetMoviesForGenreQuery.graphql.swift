// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GeneratedAPI

public class GetMoviesForGenreQuery: GraphQLQuery {
  public static let operationName: String = "GetMoviesForGenreQuery"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query GetMoviesForGenreQuery($genre: String) {
        movies(orderBy: "popularity", sort: DESC, genre: $genre) {
          __typename
          id
          title
          genres
          voteAverage
          voteCount
          releaseDate
          runtime
          posterPath
          overview
          popularity
        }
      }
      """
    ))

  public var genre: GraphQLNullable<String>

  public init(genre: GraphQLNullable<String>) {
    self.genre = genre
  }

  public var __variables: Variables? { ["genre": genre] }

  public struct Data: GeneratedAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { GeneratedAPI.Objects.Query }
    public static var __selections: [Selection] { [
      .field("movies", [Movie?]?.self, arguments: [
        "orderBy": "popularity",
        "sort": "DESC",
        "genre": .variable("genre")
      ]),
    ] }

    public var movies: [Movie?]? { __data["movies"] }

    /// Movie
    ///
    /// Parent Type: `Movie`
    public struct Movie: GeneratedAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { GeneratedAPI.Objects.Movie }
      public static var __selections: [Selection] { [
        .field("id", Int.self),
        .field("title", String.self),
        .field("genres", [String].self),
        .field("voteAverage", Double.self),
        .field("voteCount", Int.self),
        .field("releaseDate", String.self),
        .field("runtime", Int.self),
        .field("posterPath", String?.self),
        .field("overview", String.self),
        .field("popularity", Double.self),
      ] }

      public var id: Int { __data["id"] }
      public var title: String { __data["title"] }
      public var genres: [String] { __data["genres"] }
      public var voteAverage: Double { __data["voteAverage"] }
      public var voteCount: Int { __data["voteCount"] }
      public var releaseDate: String { __data["releaseDate"] }
      public var runtime: Int { __data["runtime"] }
      public var posterPath: String? { __data["posterPath"] }
      public var overview: String { __data["overview"] }
      public var popularity: Double { __data["popularity"] }
    }
  }
}
