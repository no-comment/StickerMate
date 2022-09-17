//
//  MacView.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SwiftUI

struct MacView: View {
    private let size: [CGFloat] = [
        45,
        40,
        55,
        35,
        40,
        40,
        35,
        50,
        40,
        50,
    ]
    private let offset: [CGSize] = [
        CGSize(width: -110, height: -110),
        CGSize(width: 130, height: 70),
        CGSize(width: 90, height: -75),
        CGSize(width: 10, height: -65),
        CGSize(width: -90, height: 55),
        CGSize(width: -120, height: 20),
        CGSize(width: -140, height: 45),
        CGSize(width: 10, height: 75),
        CGSize(width: 120, height: 8),
        CGSize(width: -60, height: -74),
    ]
    private let rotation: [Double] = [
        -15,
         6,
         12,
         -4,
         -10,
         12,
         -4,
         6,
         -12,
         9,
    ]
    
    let stickers: [Image]
        
    var body: some View {
        macBook
            .overlay {
                ZStack {
                    ForEach(0..<10) { i in
                        if let sticker = stickers[safe: i] {
                            sticker
                                .resizable()
                                .frame(width: size[safe: i] ?? 40, height: size[safe: i] ?? 40)
                                .cornerRadius(8)
                                .offset(x: offset[safe: i]?.width ?? 40 , y: offset[safe: i]?.height ?? 40)
                                .rotationEffect(.degrees(rotation[safe: i] ?? 0))
                        }
                    }
                }
            }
    }
    
    private var macBook: some View {
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
        MacView(stickers: [
            Image("sticker.example.event.1"),
            Image("sticker.example.event.2"),
            Image("sticker.example.event.3"),
            Image("sticker.example.event.4"),
            Image("sticker.example.event.5"),
            Image("sticker.example.event.1"),
            Image("sticker.example.event.2"),
            Image("sticker.example.event.3"),
            Image("sticker.example.event.4"),
            Image("sticker.example.event.5"),
        ])
        .padding()
    }
}
