//
//  ContentView.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import PageSheet
import SwiftUI

struct ContentView: View {
    @State private var showProfile = false
    @State private var scanningCode = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                profileSection
                MacView()
                collectionSection
                eventsSection
            }
            .padding(.horizontal)
        }
        .background(backgroundGradient.ignoresSafeArea())
        .pageSheet(isPresented: $showProfile) {
            ProfileView()
                .sheetPreferences {
                    .cornerRadius(40)
                }
        }
        .customSheet(isPresented: $scanningCode) {
            QrCodeScanner()
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }

    private var profileSection: some View {
        HStack {
            Button {
                self.showProfile.toggle()
            } label: {
                HStack {
                    Image("sticker.example.profile.2")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    Text("John Appleseed")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
            }

            Button {
                self.scanningCode.toggle()
            } label: {
                Image(systemSymbol: .cameraViewfinder)
                    .font(.system(size: 40, weight: .medium))
                    .frame(width: 40, height: 40)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
            }
        }
        .buttonStyle(.plain)
    }

    private var collectionSection: some View {
        VStack(alignment: .leading) {
            Text("Collected Stickers").font(.title3.weight(.semibold))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 20)], alignment: .center, spacing: 20) {
                ForEach(1 ..< 7) { _ in
                    Button(action: {}) {
                        StickerBadge(image: .init("sticker.example.profile.1"), isEvent: false)
                    }
                }
            }
        }
    }

    private var eventsSection: some View {
        VStack(alignment: .leading) {
            Text("Attended Events").font(.title3.weight(.semibold))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 20)], alignment: .center, spacing: 20) {
                ForEach(1 ..< 7) { _ in
                    Button(action: {}) {
                        StickerBadge(image: .init("sticker.example.profile.2"), isEvent: true)
                    }
                }
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
