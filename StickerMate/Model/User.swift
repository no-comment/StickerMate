//
//  User.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct User: Codable {
    let id: String?
    let username: String
    let biography: String
    let profileSticker: Sticker
    let events: [Event]
}

struct UserService {
    private let store = Firestore.firestore()

    func fetchUser(id: String) async -> User? {
        let doc = store.collection("Users").document(id)
        return await withCheckedContinuation { continuation in
            doc.getDocument(as: User.self) { result in
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

    func fetchCurrentUser() async -> User? {
        guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKey.userId) else {
            UserDefaults.standard.set(UUID().uuidString, forKey: UserDefaultsKey.userId)
            return nil
        }
        return await fetchUser(id: userId)
    }
}
