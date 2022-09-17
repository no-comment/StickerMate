//
//  CreateEventCard.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import SwiftUI

struct CreateEventCard: View {
    private let innerPadding: CGFloat = 25
    
    @State private var title: String = ""
    @State private var imageData: Data? = nil
    @State private var startDate: Date = Date.now
    @State private var endDate: Date = Date.now
    
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            ticket
            
            Button {
                // TODO: Create new Event
                self.showSheet = false
            } label: {
                Text("Create Event")
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.headline)
            }

        }
    }
    
    private var ticket: some View {
        VStack(spacing: 15) {
            Text("New Event")
                .font(.title2.weight(.semibold))
                .padding(.bottom, 10)
            
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 140, height: 140)
                    .cornerRadius(20)
                    .glossEffect()
            } else {
                ImagePicker(data: $imageData) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 140, height: 140)
                        .foregroundColor(.secondary)
                        .overlay {
                            Image(systemSymbol: .photo)
                                .font(.system(size: 50))
                        }
                }
            }
            
            TextField("Event Title", text: $title)
                .padding(.top, 25)
            
            Text("During what timeframe do you want the event to run?")
                .foregroundColor(.secondary)
            
            HStack {
                DatePicker(selection: $startDate, displayedComponents: .date) { EmptyView() }
                    .padding(.trailing, 10)
                
                Capsule()
                    .frame(width: 18, height: 4)
                    .foregroundColor(.gray)
                
                DatePicker(selection: $endDate, displayedComponents: .date) { EmptyView() }
                    .padding(.trailing, 10)
            }
        }
        .padding(innerPadding)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .textFieldStyle(BorderedTextField()).accentColor(.secondary)
        .scrollDismissesKeyboard(.interactively)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(uiColor: .systemBackground))
                .reverseMask(alignment: .top) {
                    maskContent
                        .offset(y: -4)
                }
                .reverseMask(alignment: .bottom) {
                    maskContent
                        .offset(y: 4)
                }
                .shadow(radius: 7)
        }
    }
    
    private var maskContent: some View {
        HStack(spacing: 5) {
            ForEach(0..<28) { _ in
                Circle()
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct CreateEventCard_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventCard(showSheet: .constant(true))
            .padding()
    }
}
