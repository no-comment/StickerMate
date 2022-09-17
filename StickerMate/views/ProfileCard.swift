//
//  ProfileCard.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SwiftUI

struct ProfileCard: View {
    @EnvironmentObject private var appModel: AppModel

    let user: User
    private let innerPadding: CGFloat = 25
    
    @State private var profileSticker: Image?

    var body: some View {
        VStack(spacing: 15) {
            StickerBadge(image: Image(systemSymbol: .personCircle), isEvent: false)
                .frame(width: 140, height: 140)
                .padding(.top, 34)
            Text(user.username ??? "Unknown Name").font(.title2.weight(.semibold))
            if let bio = user.biography {
                Text(bio)
                    .foregroundColor(.secondary)
            }
            Spacer().frame(height: 15)
            // TODO: add stickers
            MacView(stickers: [])
        }
        .padding(innerPadding)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 25).fill(Color(uiColor: .systemBackground))
                .reverseMask(alignment: .top) {
                    Capsule().frame(width: 95, height: 15).padding()
                }
                .shadow(radius: 7)
        }
        .task {
            profileSticker = await StickerService().getStickerFromReference(user.profileSticker)?.image
        }
    }
}

//struct ProfileCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileCard(user: .init(id: "jkfhishd", username: "John Appleseed", biography: "Twitter und so", profileSticker: , events: []))
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color(uiColor: .systemGroupedBackground))
//    }
//}
