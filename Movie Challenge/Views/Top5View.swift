import SwiftUI
import MovieAPI

struct Top5View: View {
    let movies: [Movie]
    
    var body: some View {
        Section("Top 5") {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(movies) { movie in
                        MoviePosterView(movie: movie)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct Top5View_Previews: PreviewProvider {
    static var previews: some View {
        Top5View(movies: Movie.previewTop5())
    }
}
