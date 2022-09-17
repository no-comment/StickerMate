//
//  Sticker.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import FirebaseFirestore
import SwiftUI
import FirebaseFirestoreSwift

struct Sticker: Codable {
    @DocumentID var id: String?
    let imageData: String
    let creator: DocumentReference

    var image: Image? {
        let data = Data(imageData.utf8)
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
    }
}

struct StickerService {
    private let store = Firestore.firestore()

    func fetchStickersFromCreator(_ userId: String) async -> [Sticker]? {
        // FIXME: implement
        return nil
    }

    func fetchStickerById(_ userId: String) async -> Sticker? {
        // FIXME: implement
        return nil
    }
}
