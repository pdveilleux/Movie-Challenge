import SwiftUI
import MovieAPI
import ComposableArchitecture

struct Top5View: View {
    let movies: [Movie]

    var body: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(movies) { movie in
                        NavigationLink(
                            destination: MovieDetailView(store: Store(initialState: .init(movie: movie), reducer: MovieDetail()))
                        ) {
                            VStack {
                                MoviePosterView(movie: movie)
                                    .frame(width: 120, height: 180)
                                
                                if let voteAverage = movie.voteAverage {
                                    Label("\(voteAverage.formatted(.number.precision(.significantDigits(2))))", systemImage: "star.fill")
                                        .labelStyle(.titleAndIcon)
                                        .font(.callout)
                                }
                            }
                        }
                        .tint(.white)
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
        }
    }
}

//struct Top5View_Previews: PreviewProvider {
//    static var previews: some View {
//        Top5View(movies: Movie.previewTop5())
//    }
//}
