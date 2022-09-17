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

    @State private var showingOverlay = false

    init(item: Binding<Bool>, content: Content) {
        self._binding = item
        self.content = content
    }

    var body: some View {
        ZStack {
            Color.black.opacity(binding ? 0.3 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    binding = false
                    showingOverlay = false
                }
                .onChange(of: binding, perform: { newValue in
                    guard newValue else { return }
                    withAnimation {
                        showingOverlay = true
                    }
                })

            if showingOverlay {
                content
                    .transition(.asymmetric(insertion: .opacity.combined(with: .offset(y: 50)), removal: .opacity))
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                CustomSheet(item: binding, content: customContent)
            }
    }
}

extension View {
    func customSheet(isPresented: Binding<Bool>, @ViewBuilder content: () -> some View) -> some View {
        modifier(CustomSheetModifier(binding: isPresented, content: content()))
    }
}

private struct Preview: View {
    @State private var shows = false
    var body: some View {
        Button("Show") {
            withAnimation {
                shows.toggle()
            }
        }
        .customSheet(isPresented: $shows) {
            StickerCard()
                .padding()
        }
    }
}

struct CustomSheet_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}
