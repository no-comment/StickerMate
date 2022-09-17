//
//  StickerCard.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SwiftUI

struct StickerCard: View {
    var body: some View {
        VStack(spacing: 15) {
            RoundedRectangle(cornerRadius: 30).frame(width: 140, height: 140)
                .padding(.top, 34)
            Text("Hack Zurich 2022").font(.title2.weight(.semibold))
            Text("This short text describes the Event and what happened")
                .foregroundColor(.secondary)
            Spacer().frame(height: 75)
            
//            RoundedRectangle(cornerRadius: 15).frame(height: 200)
        }
        .padding(34)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 25).fill(Color(uiColor: .systemBackground))
//                .reverseMask(alignment: .top) {
//                    Capsule().frame(width: 95, height: 15).padding()
//                }
                .shadow(radius: 7)
        }
    }
}

struct StickerCard_Previews: PreviewProvider {
    static var previews: some View {
        StickerCard().padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGroupedBackground))
    }
}
