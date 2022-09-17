//
//  GlossEffect.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import SwiftUI

struct GlossEffect: ViewModifier {
    @State private var x: CGFloat = 0
    @State private var yOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            let size = geo.size.width

            content
                .overlay {
                    Circle()
                        .fill(
                            RadialGradient(colors: [.red, .clear],
                                           center: .center,
                                           startRadius: 1,
                                           endRadius: size)
                        )
                        .frame(width: 2*size, height: 2*size)
                        .offset(y: geo.size.width/3)
                        .rotationEffect(.radians(x))
                }
                .onAppear {
                    withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
                        x = 2 * (.pi)
                    }
                }
            
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
        StickerBadge(image: Image("sticker.example.profile.1"), isEvent: false)
            .glossEffect()
            .frame(width: 100, height: 100)
    }
}
