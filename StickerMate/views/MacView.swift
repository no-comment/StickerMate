//
//  MacView.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SwiftUI

struct MacView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.9149723649, green: 0.9299026728, blue: 0.9296407104, alpha: 1)), Color(#colorLiteral(red: 0.5924945474, green: 0.5924944878, blue: 0.5924944282, alpha: 1))], startPoint: .top, endPoint: .bottom))
            .innerShadow(using: RoundedRectangle(cornerRadius: 16), angle: .radians(.pi), color: .white.opacity(0.5), width: 5, blur: 3)
            .overlay(alignment: .center, content: {
                logo
            })
            .aspectRatio(14.3 / 10, contentMode: .fit)
            .background(RoundedRectangle(cornerRadius: 16).fill().shadow(color: .black, radius: 1, x: 0, y: 4.5).padding(3))
    }

    private var logo: some View {
        Image("apple-logo")
            .resizable()
            .scaledToFit()
            .frame(width: 45)
    }
}

struct MacView_Previews: PreviewProvider {
    static var previews: some View {
        MacView()
            .border(.red)
            .padding()
    }
}
