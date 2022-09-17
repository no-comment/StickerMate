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
    @DocumentID var id: String?
    let username: String
    let biography: String
    let profileSticker: DocumentReference
    let events: [DocumentReference]
}

struct UserService {
    private let store = Firestore.firestore()

    func fetchUser(id: String) async -> User? {
        let doc = store.collection("Users").document(id)
        return await getUserFromReference(doc)
    }

    func fetchCurrentUser() async -> User? {
        guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKey.userId) else {
            UserDefaults.standard.set(UUID().uuidString, forKey: UserDefaultsKey.userId)
            return nil
        }
        return await fetchUser(id: userId)
    }

    func createUser(user: User) throws {
        // TODO: potential bug
        guard let userId = user.id else { return }
        try store.collection("Users").document(userId).setData(from: user, merge: false)
        print("created user: \(userId)")
    }

    func getReference(_ user: User) -> DocumentReference? {
        guard let id = user.id else { return nil }
        return store.collection("Users").document(id)
    }

    func getUserFromReference(_ ref: DocumentReference) async -> User? {
        return await withCheckedContinuation { continuation in
            ref.getDocument(as: User.self) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
//                    assertionFailure(failure.localizedDescription)
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
