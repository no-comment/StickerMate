//
//  StickerBadge.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import SwiftUI

struct StickerBadge: View {
    let image: Image
    let isEvent: Bool
    
    init(image: Image, isEvent: Bool) {
        self.image = image
        self.isEvent = isEvent
    }
    
    var body: some View {
        if isEvent {
            imageView
                .clipShape(RoundedRectangle(cornerRadius: 20))
        } else {
            imageView
                .clipShape(Circle())
        }
    }
    
    var imageView: some View {
        image
            .resizable()
            .aspectRatio(1, contentMode: .fit)
    }
}

struct StickerBadge_Previews: PreviewProvider {
    static var previews: some View {
        StickerBadge(image: Image("sticker.example.profile.2"), isEvent: true)
            .frame(width: 100)
    }
}
