//
//  ProfileView.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Circle().frame(width: 175, height: 175)
                    .padding(.top, 34)
                    .padding(.bottom)

                VStack {
                    TextField("Name", text: .constant("John Appleseed"))
                    TextField("Bio", text: .constant("This short text describes who I am and what I do"))
                        .lineLimit(5, reservesSpace: true)
                }.textFieldStyle(.roundedBorder)
                
                Color.red
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().border(.red)
    }
}
