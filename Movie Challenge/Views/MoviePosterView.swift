import SwiftUI
import MovieAPI
import ComposableArchitecture
import CachedAsyncImage

struct MoviePosterView: View {
    let movie: Movie
    
    var body: some View {
        CachedAsyncImage(url: URL(string: movie.posterPath ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Text(movie.title)
                .font(.callout)
                .multilineTextAlignment(.center)
        }
    }
}

//struct MoviePosterView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviePosterView(movie: .preview())
//    }
//}
