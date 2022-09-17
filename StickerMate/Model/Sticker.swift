//
//  Sticker.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

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
        let query = store.collection("Stickers").whereField("creator", isEqualTo: userId)
        let snapshot = try? await query.getDocuments()
        return snapshot?.documents.compactMap({ snap in
            try? snap.data(as: Sticker.self)
        })
    }

    func fetchStickerById(_ userId: String) async -> Sticker? {
        let doc = store.collection("Stickers").document(userId)
        return await withCheckedContinuation { continuation in
            doc.getDocument(as: Sticker.self) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    assertionFailure(failure.localizedDescription)
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
