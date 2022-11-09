import MovieAPI
import SwiftUI

extension Movie: Identifiable {}

extension Movie {
    static func preview() -> Movie {
        .init(
            id: 508442,
            title: "Soul",
            posterPath: "https://image.tmdb.org/t/p/w300_and_h450_bestv2/hm58Jw4Lw8OIeECIq5qyPYhAeRJ.jpg",
            genres: [
                "Family",
                "Animation",
                "Comedy",
                "Drama",
                "Music",
                "Fantasy"
              ],
            director: nil
        )
    }
    
    static func previewTop5() -> [Movie] {
        [
            .preview(),
            .init(id: 2, title: "Movie 2"),
            .init(id: 3, title: "Movie 3"),
            .init(id: 4, title: "Movie 4"),
            .init(id: 5, title: "Movie 5"),
        ]
    }
}
