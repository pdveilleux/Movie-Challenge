// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GeneratedAPI

public class GetGenresQuery: GraphQLQuery {
  public static let operationName: String = "GetGenresQuery"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query GetGenresQuery {
        genres
      }
      """
    ))

  public init() {}

  public struct Data: GeneratedAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { GeneratedAPI.Objects.Query }
    public static var __selections: [Selection] { [
      .field("genres", [String].self),
    ] }

    public var genres: [String] { __data["genres"] }
  }
}
