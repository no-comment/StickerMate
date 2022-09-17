//
//  CustomSheet.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import SwiftUI

struct CustomSheet<Content: View>: View {
    private let content: Content
    @Binding private var binding: Bool

    init(item: Binding<Bool>, content: Content) {
        self._binding = item
        self.content = content
    }
    
    var body: some View {
        if binding {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        binding = false
                    }
                content
            }
        }
    }
}

struct CustomSheetModifier<CustomContent: View>: ViewModifier {
    private let customContent: CustomContent
    private let binding: Binding<Bool>
    
    init(binding: Binding<Bool>, content: CustomContent) {
        self.binding = binding
        self.customContent = content
    }
    
    func body(content: Content) -> some View {
            content
            .overlay {
                CustomSheet(item: binding, content: customContent)
            }
    }
}

extension View {
    func customSheet(_ isPresented: Binding<Bool>, @ViewBuilder content: () -> some View) -> some View {
        modifier(CustomSheetModifier(binding: isPresented, content: content()))
    }
}

struct CustomSheet_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .customSheet(.constant(true)) {
                ProfileCard()
                    .padding()
            }
    }
}
