//
//  StickerCard.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SwiftUI

struct StickerCard: View {
    @ObservedObject private var appModel = AppModel()
    
    @ScaledMetric private var creatorSectionHeight: CGFloat = 75
    private let innerPadding: CGFloat = 25
    private let userService = UserService()
    private let stickerService = StickerService()
    
    let event: Event
    @State private var sticker: Sticker? = nil
    @State private var title: String? = nil
    @State private var creator: User? = nil
    @State private var userSticker: Sticker? = nil

    var body: some View {
        VStack(spacing: 15) {
            if let image = sticker?.image {
                StickerBadge(image: image, isEvent: true)
                    .frame(width: 140, height: 140)
                    .glossEffect()
                    .padding(.top, 34)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 140, height: 140)
                    .padding(.top, 34)
            }
            Text(title ?? "Event").font(.title2.weight(.semibold))

            Spacer()
                .frame(height: 100)
            
            HStack {
                if let profilePic = userSticker?.image {
                    profilePic
                        .resizable()
                        .frame(width: creatorSectionHeight, height: creatorSectionHeight)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .frame(width: creatorSectionHeight, height: creatorSectionHeight)
                }
                VStack(alignment: .leading) {
                    Text(creator?.username ?? "Creator").font(.title3.weight(.semibold))
                    Text(creator?.biography ?? "The creator of this event.")
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(height: creatorSectionHeight)
        }
        .padding(innerPadding)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 25).fill(Color(uiColor: .systemBackground))
                .reverseMask(alignment: .bottom) {
                    let circleSize: CGFloat = 35
                    Circle().frame(width: circleSize, height: circleSize)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: -circleSize / 2, y: -creatorSectionHeight - innerPadding - (circleSize / 2))

                    Circle().frame(width: circleSize, height: circleSize)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .offset(x: circleSize / 2, y: -creatorSectionHeight - innerPadding - (circleSize / 2))
                }
                .shadow(radius: 7)
        }
        .task {
            guard let sticker = await  stickerService.getStickerFromReference(event.sticker) else { return }
            self.sticker = sticker
            guard let user = await userService.getUserFromReference(sticker.creator) else { return }
            self.creator = user
            let profile = await stickerService.getStickerFromReference(user.profileSticker)
            self.userSticker = profile
            self.title = event.title
        }
        .onReceive(appModel.objectWillChange) { _ in
            Task {
                guard let sticker = await  stickerService.getStickerFromReference(event.sticker) else { return }
                self.sticker = sticker
                guard let user = await userService.getUserFromReference(sticker.creator) else { return }
                self.creator = user
                let profile = await stickerService.getStickerFromReference(user.profileSticker)
                self.userSticker = profile
                self.title = event.title
            }
        }
    }
}

struct StickerCard_Previews: PreviewProvider {
    static var previews: some View {
//        StickerCard().padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color(uiColor: .systemGroupedBackground))
        Text("N/A")
    }
}
