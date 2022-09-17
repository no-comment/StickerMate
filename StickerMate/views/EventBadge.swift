//
//  EventBadge.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import SwiftUI

struct EventBadge: View {
    private let stickerService = StickerService()
    let event: Event
    @State private var sticker: Sticker? = nil
        
    var body: some View {
        VStack {
            if let img = sticker?.image {
                StickerBadge(image: img, isEvent: true)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .aspectRatio(1, contentMode: .fill)
            }
        }
        .task {
            let res = await stickerService.getStickerFromReference(event.sticker)
            sticker = res
        }
    }
}
