import SwiftUI
import MovieAPI
import ComposableArchitecture

struct Top5View: View {
    let movies: [Movie]
    let tapHandler: (Movie) -> ()

    var body: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(movies) { movie in
                        MoviePosterView(movie: movie)
                            .onTapGesture {
                                tapHandler(movie)
                            }
                    }
                }
                .padding()
            }
            .background(Color.red)
            .scrollIndicators(.hidden)
        } header: {
            HStack {
                Text("Top 5")
                    .font(.title2)
                    .bold()
                    .padding()
                Spacer()
            }
            
        }
    }
}

//struct Top5View_Previews: PreviewProvider {
//    static var previews: some View {
//        Top5View(movies: Movie.previewTop5())
//    }
//}
