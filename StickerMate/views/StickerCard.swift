//
//  StickerCard.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SwiftUI

struct StickerCard: View {
    @ScaledMetric private var creatorSectionHeight: CGFloat = 75
    
    private let innerPadding: CGFloat = 25

    var body: some View {
        VStack(spacing: 15) {
            RoundedRectangle(cornerRadius: 30).frame(width: 140, height: 140)
                .padding(.top, 34)
            Text("Hack Zurich 2022").font(.title2.weight(.semibold))
            Text("This short text describes the Event and what happened")
                .foregroundColor(.secondary)

            Spacer().frame(height: 100)

            HStack {
                Circle().frame(width: creatorSectionHeight, height: creatorSectionHeight)
                VStack(alignment: .leading) {
                    Text("John Appleseed").font(.title3.weight(.semibold))
                    Text("This short text describes who I am and what I do")
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
    }
}

struct StickerCard_Previews: PreviewProvider {
    static var previews: some View {
        StickerCard().padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGroupedBackground))
    }
}
