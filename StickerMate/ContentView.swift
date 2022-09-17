//
//  ContentView.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import PageSheet
import SwiftUI

struct ContentView: View {
    private let userService = UserService()
    
    @State private var showProfile = false
    @State private var scanningCode = false
    
    @ObservedObject private var appModel = AppModel()
    
    @State private var profilePicture: Image?
    @State private var username: String?
    @State private var events: [Event]?
    
    @State private var collectedUsers: [Sticker]? = nil
    @State private var collectedEvents: [Event]? = nil
    
    @State private var showingUserSticker: Bool = false
    @State private var activeUserSticker: User? = nil
    @State private var showingEventSticker: Bool = false
    @State private var activeEvent: Event? = nil
    
    @State private var stickerImages: [Image] = []
    
    @State private var scannedUser: User?

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                profileSection
                    .padding(.top)
                MacView(stickers: stickerImages)
                if !(collectedUsers ?? []).isEmpty {
                    collectionSection
                }
                if !(collectedEvents ?? []).isEmpty {
                    eventsSection
                }
                if (collectedUsers ?? []).isEmpty && (collectedEvents ?? []).isEmpty {
                    Text("You don't have any Stickers yet.\nGo out hunting!")
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .background(backgroundGradient.ignoresSafeArea())
        .pageSheet(isPresented: $showProfile) {
            NavigationStack {
                ProfileView()
            }
            .sheetPreferences {
                .cornerRadius(40)
            }
            .environmentObject(appModel)
        }
        .customSheet(isPresented: $scanningCode) {
            if let scannedUser {
                ProfileCard(user: scannedUser)
                    .padding()
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                QrCodeScanner()
                    .padding()
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .customSheet(isPresented: $showingUserSticker, content: {
            if let activeUserSticker {
                ProfileCard(user: activeUserSticker)
                    .padding()
            }
        })
        .customSheet(isPresented: $showingEventSticker, content: {
            if let activeEvent {
                StickerCard(event: activeEvent)
                    .padding()
            }
        })
        .environmentObject(appModel)
        .onOpenURL { url in
            print("open url \(url.absoluteString)")
            guard url.scheme == "stickermate",
                  let userId = url.host,
                  !userId.isEmpty
            else { return }
            
            Task(priority: .userInitiated) {
                scannedUser = await appModel.getScannedUser(userId)
                guard let scannedUser else { return }
                scanningCode = true
                Task {
                    await appModel.collectUserStickers(scannedUser)
                }
            }
        }
        .task {
            let user = await appModel.getCurrentUserData()
            username = user.username
            profilePicture = await appModel.getProfileSticker().image
        }
        .task {
            let eventSticker = await appModel.getCollectedEvents().asyncCompactMap({ await appModel.getStickerFromEvent($0) })
            let userSticker = await appModel.getCollectedUsers()
            stickerImages = (eventSticker + userSticker).shuffled().compactMap({ $0.image })
        }
        .task {
            let events = await appModel.getCollectedEvents()
            self.collectedEvents = events
        }
        .task {
            let sticker = await appModel.getCollectedUsers()
            self.collectedUsers = sticker
        }
        .onReceive(appModel.objectWillChange, perform: { _ in
            Task {
                let user = await appModel.getCurrentUserData()
                username = user.username
                profilePicture = await appModel.getProfileSticker().image
                let eventSticker = await appModel.getCollectedEvents().asyncCompactMap({ await appModel.getStickerFromEvent($0) })
                let userSticker = await appModel.getCollectedUsers()
                stickerImages = (eventSticker + userSticker).shuffled().compactMap({ $0.image })
                let events = await appModel.getCollectedEvents()
                self.collectedEvents = events
                let sticker = await appModel.getCollectedUsers()
                self.collectedUsers = sticker
            }
        })
    }
    
    private var profileSection: some View {
        HStack(spacing: 20) {
            Button {
                self.showProfile.toggle()
            } label: {
                HStack {
                    (profilePicture ?? Image(systemSymbol: .personCircle))
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    Text(username ??? "Unknown Name")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .redacted(reason: username == nil ? .placeholder : [])
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
            }
            
            Button {
                self.scanningCode.toggle()
            } label: {
                Image(systemSymbol: .cameraViewfinder)
                    .font(.system(size: 34, weight: .regular))
                    .frame(width: 30, height: 30)
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
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
                if let collectedUsers {
                    ForEach(collectedUsers, id: \.id) { sticker in
                        Button(action: {
                            Task {
                                let userSticker = await userService.getUserFromReference(sticker.creator)
                                self.activeUserSticker = userSticker
                                self.showingUserSticker = true
                            }
                        }) {
                            StickerBadge(image: sticker.image ?? .init("sticker.example.profile.1"), isEvent: false)
                        }
                    }
                }
            }
        }
    }
    
    private var eventsSection: some View {
        VStack(alignment: .leading) {
            Text("Attended Events").font(.title3.weight(.semibold))
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 20)], alignment: .center, spacing: 20) {
                if let collectedEvents {
                    ForEach(collectedEvents, id: \.id) { event in
                        Button(action: {
                            self.activeEvent = event
                            self.showingEventSticker = true
                        }) {
                            EventBadge(event: event)
                        }
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
