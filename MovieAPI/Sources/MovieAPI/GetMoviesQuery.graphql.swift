// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GeneratedAPI

public class GetMoviesQuery: GraphQLQuery {
  public static let operationName: String = "GetMoviesQuery"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query GetMoviesQuery {
        movies {
          __typename
          title
        }
      }
      """
    ))

  public init() {}

  public struct Data: GeneratedAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { GeneratedAPI.Objects.Query }
    public static var __selections: [Selection] { [
      .field("movies", [Movie?]?.self),
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
        .field("title", String.self),
      ] }

      public var title: String { __data["title"] }
    }
  }
}
