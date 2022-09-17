//
//  GlossEffect.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import SwiftUI

struct GlossEffect: ViewModifier {
    private let duration: CGFloat = 14
    private let size: CGFloat = 140
    private let offset: CGFloat = 50
    @State private var rad: Double = 0
    @State private var rotate: Bool = false
    
    var sinus: CGFloat {
        sin(rad)
    }
    
    func body(content: Content) -> some View {
            content
                .overlay {
                    Circle()
                        .fill(
                            RadialGradient(colors: [.white.opacity(0.2), .clear],
                                           center: .center,
                                           startRadius: 1,
                                           endRadius: size/1.5)
                        )
                        .frame(width: 2*size, height: 2*size)
                        .offset(y: size/3)
                        .rotationEffect(.radians(rad))
                        .rotationEffect(.degrees(225))
                }
                .clipShape(Rectangle())
                .rotation3DEffect(.degrees(rotate ?  10 : -10), axis: (x: 1, y: 0, z:  0))
                .animation(.timingCurve(0.45, 0.45, 1, 1, duration: duration/2).repeatForever(autoreverses: true), value: rotate)
                .rotation3DEffect(.degrees(rotate ? 10 : -10), axis: (x: 0, y: 1, z:  0))
                .animation(.timingCurve(0.45, 0.45, 1, 1, duration: duration/2).repeatForever(autoreverses: true).delay(duration/4), value: rotate)
                .shadow(color: .gray, radius: 20, x: sinus * offset, y: sin(rad) * offset)
                .onAppear {
                    withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                        rad = 2 * (Double.pi)
                    }
                    rotate.toggle()
                }
    }
}

extension View {
    func glossEffect() -> some View {
        modifier(GlossEffect())
    }
}

struct Glosseffect_Previews: PreviewProvider {
    static var previews: some View {
//        LazyVGrid(columns: [.init(.adaptive(minimum: 100))]) {
//            StickerBadge(image: Image("sticker.example.event.1"), isEvent: true)
//                .glossEffect()
//            StickerBadge(image: Image("sticker.example.profile.2"), isEvent: false)
//                .glossEffect()
//                .shadow(radius: 5)
//        }
        StickerBadge(image: Image("sticker.example.event.1"), isEvent: true)
            .frame(width: 140)
            .glossEffect()
        .padding()
    }
}
