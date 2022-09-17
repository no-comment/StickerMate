//
//  MacView.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SwiftUI

struct MacView: View {
    var body: some View {
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: scaleValue(16, geo: geo))
                .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.9149723649, green: 0.9299026728, blue: 0.9296407104, alpha: 1)), Color(#colorLiteral(red: 0.5924945474, green: 0.5924944878, blue: 0.5924944282, alpha: 1))], startPoint: .top, endPoint: .bottom))
                .innerShadow(using: RoundedRectangle(cornerRadius: scaleValue(16, geo: geo)), angle: .radians(.pi), color: .white.opacity(0.5), width: scaleValue(5, geo: geo), blur: scaleValue(3, geo: geo))
                .overlay(alignment: .center, content: {
                    Image("apple-logo")
                        .resizable()
                        .scaledToFit()
                    .frame(width: scaleValue(45, geo: geo))
                })
                .aspectRatio(14.3 / 10, contentMode: .fit)
                .background(RoundedRectangle(cornerRadius: scaleValue(16, geo: geo)).fill().shadow(color: .black, radius: scaleValue(1, geo: geo), x: 0, y: scaleValue(4.5, geo: geo)).padding(scaleValue(3, geo: geo)))
        }
        .aspectRatio(14.3 / 10, contentMode: .fit)
    }

    func scaleValue(_ value: CGFloat, geo: GeometryProxy) -> CGFloat {
        return value * geo.size.width / 350
    }
}

struct MacView_Previews: PreviewProvider {
    static var previews: some View {
        MacView()
//            .scaleEffect(0.4)
//            .border(.red)
//            .frame(width: 100)
            .padding()
    }
}
