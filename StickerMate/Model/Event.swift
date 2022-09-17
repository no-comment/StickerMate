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
        // FIXME: implement
        return nil
    }
}
