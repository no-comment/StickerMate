//
//  ContentView.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SwiftUI
import PageSheet

struct ContentView: View {
    @State private var shows = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("Open") { shows.toggle() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundGradient.ignoresSafeArea())
        .pageSheet(isPresented: $shows) {
            ProfileView()
                .sheetPreferences {
                    .cornerRadius(40)
                }
        }
    }

    private var backgroundGradient: some View {
        AngularGradient(gradient: Gradient(colors: [.orange, .purple, .cyan, .orange]), center: .center)
            .blur(radius: 50)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .mask({
                Circle().fill(RadialGradient(
                    gradient: Gradient(colors: [.white, .clear]),
                    center: .center,
                    startRadius: 1,
                    endRadius: 300
                ))
            })
            .offset(x: 100, y: -200)
            .overlay(Material.regular)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
