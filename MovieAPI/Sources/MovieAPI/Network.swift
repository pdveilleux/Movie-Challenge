import Foundation
import Apollo

public class Network {
  public static let shared = Network()
  private static let apiEndpoint = "https://podium-fe-challenge-2021.netlify.app/.netlify/functions/graphql"

  public private(set) lazy var apollo = ApolloClient(url: URL(string: Self.apiEndpoint)!)
}
