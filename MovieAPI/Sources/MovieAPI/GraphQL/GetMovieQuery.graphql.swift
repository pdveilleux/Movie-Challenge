// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GeneratedAPI

public class GetMovieQuery: GraphQLQuery {
  public static let operationName: String = "GetMovieQuery"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query GetMovieQuery($id: Int!) {
        movie(id: $id) {
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
          director {
            __typename
            id
            name
          }
          cast {
            __typename
            profilePath
            name
            character
            order
          }
        }
      }
      """
    ))

  public var id: Int

  public init(id: Int) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: GeneratedAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { GeneratedAPI.Objects.Query }
    public static var __selections: [Selection] { [
      .field("movie", Movie?.self, arguments: ["id": .variable("id")]),
    ] }

    public var movie: Movie? { __data["movie"] }

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
        .field("director", Director.self),
        .field("cast", [Cast].self),
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
      public var director: Director { __data["director"] }
      public var cast: [Cast] { __data["cast"] }

      /// Movie.Director
      ///
      /// Parent Type: `Director`
      public struct Director: GeneratedAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { GeneratedAPI.Objects.Director }
        public static var __selections: [Selection] { [
          .field("id", Int.self),
          .field("name", String.self),
        ] }

        public var id: Int { __data["id"] }
        public var name: String { __data["name"] }
      }

      /// Movie.Cast
      ///
      /// Parent Type: `Cast`
      public struct Cast: GeneratedAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { GeneratedAPI.Objects.Cast }
        public static var __selections: [Selection] { [
          .field("profilePath", String?.self),
          .field("name", String.self),
          .field("character", String.self),
          .field("order", Int.self),
        ] }

        public var profilePath: String? { __data["profilePath"] }
        public var name: String { __data["name"] }
        public var character: String { __data["character"] }
        public var order: Int { __data["order"] }
      }
    }
  }
}
