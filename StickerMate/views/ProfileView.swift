//
//  ProfileView.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SFSafeSymbols
import SwiftUI
import CoreImage.CIFilterBuiltins

struct ProfileView: View {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State private var imageData: Data? = nil
    @State private var name = "John Appleseed"
    @State private var bio = "This short text describes who I am and what I do"
    @State private var showingQRCode: Bool = false
    
    init() {
        
    }
    
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
                        Image(uiImage: generateQRCode(from: "Hello"))
                                .resizable()
                                .interpolation(.none)
                                .frame(width: 180, height: 180)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
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
        .buttonStyle(.plain)
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                print("yay")
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
        NavigationStack {
            ProfileView()
        }
    }
}
