import SwiftUI
import MovieAPI
import ComposableArchitecture

struct Top5View: View {
    let movies: [Movie]
    let viewStore: ViewStore<Home.State, Home.Action>

    var body: some View {
        Section("Top 5") {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(movies) { movie in
                        MoviePosterView(movie: movie, viewStore: viewStore)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
    }
}

//struct Top5View_Previews: PreviewProvider {
//    static var previews: some View {
//        Top5View(movies: Movie.previewTop5())
//    }
//}
