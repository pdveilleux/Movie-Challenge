import SwiftUI
import ComposableArchitecture
import MovieAPI

struct RootView: View {
    var body: some View {
        TabView {
            HomeView(
                store: Store(
                    initialState: Home.State(),
                    reducer: Home(apiService: APIService())
                )
            )
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "film")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
