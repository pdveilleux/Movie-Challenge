import SwiftUI
import MovieAPI
import ComposableArchitecture

struct MoviePosterView: View {
    let movie: Movie
    let viewStore: ViewStore<Home.State, Home.Action>
    
    var body: some View {
        AsyncImage(url: URL(string: movie.posterPath ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Text(movie.title)
                .font(.callout)
                .multilineTextAlignment(.center)
        }
        .frame(width: 120, height: 180)
        .onTapGesture {
            viewStore.send(.viewMovie(movie))
        }

    }
}

//struct MoviePosterView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviePosterView(movie: .preview())
//    }
//}
