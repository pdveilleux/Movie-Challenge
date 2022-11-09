import SwiftUI
import MovieAPI

struct MoviePosterView: View {
    let movie: Movie
    
    var body: some View {
        AsyncImage(url: URL(string: movie.posterPath ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160)
        } placeholder: {
            ProgressView()
        }

    }
}

struct MoviePosterView_Previews: PreviewProvider {
    static var previews: some View {
        MoviePosterView(movie: .preview())
    }
}
