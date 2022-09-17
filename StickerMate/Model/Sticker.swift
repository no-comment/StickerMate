//
//  Sticker.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct Sticker: Codable, Equatable {
    @DocumentID var id: String?
    let imageData: String
    let creator: DocumentReference

    var image: Image? {
        guard let data = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters),
              let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
    }
}

struct StickerService {
    private let store = Firestore.firestore()

    var defaultSticker: DocumentReference {
        store.collection("Stickers").document("7HoKy7VY2RdAIolxKyAL")
    }

    func fetchStickersFromCreator(_ userId: String) async -> [Sticker]? {
        let query = store.collection("Stickers").whereField("creator", isEqualTo: userId)
        let snapshot = try? await query.getDocuments()
        return snapshot?.documents.compactMap({ snap in
            try? snap.data(as: Sticker.self)
        })
    }

    func fetchStickerById(_ userId: String) async -> Sticker? {
        let doc = store.collection("Stickers").document(userId)
        return await getStickerFromReference(doc)
    }

    func createSticker(sticker: Sticker) throws {
        // TODO: potential bug
        guard let id = sticker.id else { return }
        try store.collection("Stickers").document(id).setData(from: sticker, merge: false)
    }

    func getReference(_ sticker: Sticker) -> DocumentReference? {
        guard let id = sticker.id else { return nil }
        return store.collection("Stickers").document(id)
    }

    func getStickerFromReference(_ ref: DocumentReference) async -> Sticker? {
        return await withCheckedContinuation { continuation in
            ref.getDocument(as: Sticker.self) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    // assertionFailure(failure.localizedDescription)
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    func updateSticker(_ sticker: Sticker) throws {
        guard let id = sticker.id else { return }
        try store.collection("Stickers").document(id).setData(from: sticker, merge: true)
        print("Updated sticker: \(id)")
    }
}
