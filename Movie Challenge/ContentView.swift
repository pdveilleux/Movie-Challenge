//
//  ContentView.swift
//  Movie Challenge
//
//  Created by Patrick Veilleux on 11/8/22.
//

import SwiftUI
import MovieAPI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Network.shared.apollo.fetch(query: GetMoviesQuery()) { result in
                guard let data = try? result.get().data else { return }
                print(data.movies?.count)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
