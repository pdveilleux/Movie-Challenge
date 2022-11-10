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
                        VStack {
                            MoviePosterView(movie: movie)
                                .frame(width: 120, height: 180)
                                .onTapGesture {
                                    tapHandler(movie)
                                }
                            
                            if let voteAverage = movie.voteAverage {
                                Label("\(voteAverage.formatted(.number.precision(.significantDigits(2))))", systemImage: "star.fill")
                                    .labelStyle(.titleAndIcon)
                                    .font(.callout)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        } header: {
            HStack {
                Text("Top 5")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                Spacer()
            }
//            .background(Color.pink)
        }
//        .background(Color.yellow)
    }
}

//struct Top5View_Previews: PreviewProvider {
//    static var previews: some View {
//        Top5View(movies: Movie.previewTop5())
//    }
//}
