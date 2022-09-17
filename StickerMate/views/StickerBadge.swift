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
            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
            .border(.red)
    }
}

struct StickerBadge_Previews: PreviewProvider {
    static var previews: some View {
        StickerBadge(image: Image("sticker.example.profile.1"), isEvent: false)
    }
}
