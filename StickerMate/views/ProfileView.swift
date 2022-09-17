//
//  ProfileView.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SFSafeSymbols
import SwiftUI

struct ProfileView: View {
    @State private var name = "John Appleseed"
    @State private var bio = "This short text describes who I am and what I do"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Button(action: {}) {
                    Circle().fill(.red).frame(width: 175, height: 175)
                        .overlay(alignment: .bottom) {
                            Text("Edit").foregroundColor(.white)
                                .padding(.vertical, 4)
                                .background(Color.black.opacity(0.6).frame(width: 175))
                        }
                        .clipShape(Circle())
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack {
                    TextField("Name", text: $name)
                    TextField("Bio", text: $bio, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
                }
                .textFieldStyle(BorderedTextField()).accentColor(.secondary)
                .padding(.bottom)
                
                Text("Your Favourite Stickers").font(.title3.weight(.semibold))
                
                MacView()
                
                VStack {
                    ForEach(["HackaTum 2021", "HackZurich 2021", "HackZurich 2022"], id: \.self) { name in
                        Button(action: {}) {
                            Text(name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                        // .tint(.accentColor)
                    }
                    Button(action: {}) {
                        Text("Add Sticker from Library")
                        // .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
                }
                
                Text("Your Events").font(.title3.weight(.semibold))
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 20)], alignment: .center, spacing: 20) {
                    NavigationLink {
                        CreateEventCard()
                            .padding()
                    } label: {
                        Image(systemSymbol: .plusSquareDashed)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .fontWeight(.thin)
                        
                    }
                    
                    ForEach(1 ..< 9) { _ in
                        Button(action: {}) {
                            StickerBadge(image: .init("sticker.example.profile.1"), isEvent: true)
                        }
                    }
                }
            }
            .padding(.vertical, 34)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
        }
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
        NavigationStack {
            ProfileView().border(.red)
        }
    }
}
