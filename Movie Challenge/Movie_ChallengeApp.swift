import SwiftUI
import MovieAPI
import ComposableArchitecture

@main
struct Movie_ChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(store: Store(initialState: Home.State(), reducer: Home(apiService: APIService())))
        }
    }
}
