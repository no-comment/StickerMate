//
//  Event.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import FirebaseFirestore
import Foundation
import FirebaseFirestoreSwift

struct Event: Codable {
    @DocumentID var id: String?
    let sticker: DocumentReference
    let title: String
    let startDate: Date
    let endDate: Date
}

struct EventService {
    private let store = Firestore.firestore()

    func fetchEventForSticker(_ stickerId: String) async -> Event? {
        let doc = store.collection("Events").document(stickerId)
        return await referenceToEvent(doc)
    }
    
    func referenceToEvent(_ ref: DocumentReference) async -> Event? {
        return await withCheckedContinuation { continuation in
            ref.getDocument(as: Event.self) { result in
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
