//
//  ProfileView.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import CoreImage.CIFilterBuiltins
import SFSafeSymbols
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appModel: AppModel

    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State private var imageData: Data? = nil
    @State private var name = ""
    @State private var bio = ""
    @State private var showingQRCode: Bool = false
    @State private var addNewEvent: Bool = false
    
    @State private var showEventDetail: Bool = false
    @State private var selectedEvent: Event? = nil
    
    @State private var myEvents: [Event]? = nil
    @State private var images: [Image] = []
    @State private var events: [Event] = []

    init() {}
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack(spacing: 30) {
                    if !showingQRCode {
                        ImagePicker(data: $imageData) {
                            if let imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 175, height: 175)
                                    .overlay(alignment: .bottom) {
                                        Text("Edit").foregroundColor(.white)
                                            .padding(.vertical, 4)
                                            .background(Color.black.opacity(0.6).frame(width: 175))
                                    }
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .frame(width: 175, height: 175)
                                    .foregroundColor(.secondary.opacity(0.1))
                                    .overlay {
                                        Image(systemSymbol: .photo)
                                            .font(.system(size: 50))
                                    }
                            }
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    Button {
                        withAnimation {
                            self.showingQRCode.toggle()
                        }
                    } label: {
                        Image(systemSymbol: showingQRCode ? .personFill : .qrcode)
                            .background {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.secondary.opacity(0.1))
                            }
                    }
                    
                    if showingQRCode {
                        Image(uiImage: generateQRCode(from: "stickermate://\(appModel.userId)"))
                            .resizable()
                            .interpolation(.none)
                            .frame(width: 180, height: 180)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack {
                    TextField("Name", text: $name).onSubmit({ save() })
                    TextField("Bio", text: $bio, axis: .vertical)
                        .onSubmit({ save() })
                        .lineLimit(5, reservesSpace: true)
                }
                .scrollDismissesKeyboard(.interactively)
                .textFieldStyle(BorderedTextField()).accentColor(.secondary)
                .padding(.bottom)
                
                Text("Your Collected Stickers").font(.title3.weight(.semibold))
                
                MacView(stickers: images)
                    
//                VStack {
//                    ForEach(["HackaTum 2021", "HackZurich 2021", "HackZurich 2022"], id: \.self) { name in
//                        Button(action: {}) {
//                            Text(name)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                        }
//                        .buttonStyle(.bordered)
//                        // .tint(.accentColor)
//                    }
//                    Button(action: {}) {
//                        Text("Add Sticker from Library")
//                        // .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .buttonStyle(.bordered)
//                    .tint(.accentColor)
//                }
                
                Text("Your Events").font(.title3.weight(.semibold))
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 20)], alignment: .center, spacing: 20) {
                    Button {
                        self.addNewEvent.toggle()
                    } label: {
                        Image(systemSymbol: .plusSquareDashed)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .fontWeight(.thin)
                    }

                    if let myEvents {
                        ForEach(myEvents, id: \.id) { event in
                            Button(action: {
                                self.selectedEvent = event
                                self.showEventDetail.toggle()
                            }) {
                                EventBadge(event: event)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 34)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: imageData, perform: { _ in
            save()
        })
        .task {
            let user = await appModel.getCurrentUserData()
            name = user.username
            bio = user.biography
        }
        .task {
            let profileSticker = await appModel.getProfileSticker()
            if profileSticker.image != nil {
                imageData = Data(base64Encoded: profileSticker.imageData, options: .ignoreUnknownCharacters)
            }
        }
        .task {
            let eventSticker = await appModel.getCollectedEvents().asyncCompactMap({ await appModel.getStickerFromEvent($0) })
            let userSticker = await appModel.getCollectedUsers()
            images = (eventSticker + userSticker).shuffled().compactMap({ $0.image })
        }
        .task {
            let usersEvents = await appModel.getEvents()
            self.myEvents = usersEvents
        }
        .onReceive(appModel.objectWillChange, perform: { _ in
            Task {
                let user = await appModel.getCurrentUserData()
                name = user.username
                bio = user.biography
            }
            Task {
                let profileSticker = await appModel.getProfileSticker()
                if profileSticker.image != nil {
                    imageData = Data(base64Encoded: profileSticker.imageData, options: .ignoreUnknownCharacters)
                }
            }
            Task {
                let eventSticker = await appModel.getCollectedEvents().asyncCompactMap({ await appModel.getStickerFromEvent($0) })
                let userSticker = await appModel.getCollectedUsers()
                images = (eventSticker + userSticker).shuffled().compactMap({ $0.image })
            }
            Task {
                let usersEvents = await appModel.getEvents()
                self.myEvents = usersEvents
            }
        })
        .buttonStyle(.plain)
        .customSheet(isPresented: $addNewEvent) {
            CreateEventCard(showSheet: $addNewEvent)
                .padding()
        }
        .customSheet(isPresented: $showEventDetail) {
            if let selectedEvent {
                StickerCard(event: selectedEvent)
                    .padding()
            }
        }
    }
    
    private func save() {
        Task {
            let currentUser = await appModel.getCurrentUserData()
            let updatedUser = User(id: currentUser.id, username: name, biography: bio, profileSticker: currentUser.profileSticker, events: currentUser.events, collectedUsers: currentUser.collectedUsers, collectedEvents: currentUser.collectedEvents)
            appModel.updateUser(updatedUser)
            
            let currentProfileSticker = await appModel.getProfileSticker()
            appModel.updateSticker(Sticker(id: currentProfileSticker.id, imageData: imageData?.base64EncodedString() ?? currentProfileSticker.imageData, creator: currentProfileSticker.creator))
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct BorderedTextField: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(14)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
