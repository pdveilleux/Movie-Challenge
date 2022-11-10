import SwiftUI
import ComposableArchitecture

struct GenresGridView: View {
    let genres: [String]
    
    let columns: [GridItem] = [
        .init(.flexible()), .init(.flexible()), .init(.flexible())
    ]
    let colors: [SwiftUI.Color] = [
        .red, .orange, .green, .blue, .indigo, .purple, .pink
    ]
    
    var body: some View {
        Section {
            LazyVGrid(columns: columns) {
                ForEach(Array(genres.enumerated()), id: \.element) { index, genre in
                    NavigationLink {
                        MoviesListView(
                            store: Store(
                                initialState: .init(
                                    filter: .init(genre: genre)),
                                reducer: MoviesList()
                            )
                        )
                    } label: {
                        Text(genre)
                            .font(.callout)
                            .bold()
                            .multilineTextAlignment(.center)
                            .frame(width: 112, height: 64, alignment: .center)
                            .background(colors[index % colors.count])
                            .cornerRadius(16)
                    }
                    .tint(.white)
                }
            }
            .padding(.horizontal)
        } header: {
            HStack {
                Text("Genres")
                    .font(.title2)
                    .bold()
                    .padding()
                Spacer()
            }
        }
    }
}

struct GenresGridView_Previews: PreviewProvider {
    static var previews: some View {
        GenresGridView(genres: ["Action", "Adventure", "Animation"])
    }
}
