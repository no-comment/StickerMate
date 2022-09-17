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
    
    var body: some View {
        image
            .resizable()
    }
}

struct StickerBadge_Previews: PreviewProvider {
    static var previews: some View {
        StickerBadge(image: Image("sticker.profile.example.1"), isEvent: false)
    }
}
