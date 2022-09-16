//
//  ProfileCard.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SwiftUI

struct ProfileCard: View {
    var body: some View {
        VStack(spacing: 15) {
            Circle().frame(width: 140, height: 140)
                .padding(.top, 34)
            Text("John Appleseed").font(.title2.weight(.semibold))
            Text("This short text describes who I am and what I do")
                .foregroundColor(.secondary)
            Spacer().frame(height: 15)
            RoundedRectangle(cornerRadius: 15).frame(height: 200)
        }
        .padding(34)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 25).fill(Color(uiColor: .systemBackground))
                .reverseMask(alignment: .top) {
                    Capsule().frame(width: 95, height: 15).padding()
                }
                .shadow(radius: 7)
        }
    }
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard()
            .padding()
            .background(Color(uiColor: .systemGroupedBackground))
    }
}
