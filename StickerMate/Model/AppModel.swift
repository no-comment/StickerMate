//
//  AppModel.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import Foundation
import CollectionConcurrencyKit

@MainActor
class AppModel: ObservableObject {
    @Published private var currentUser: User?
    @Published private var profileSticker: Sticker?
    
    private let userService = UserService()
    private let stickerService = StickerService()
    private let eventService = EventService()
    
    var userId: String {
        let str = UserDefaults.standard.string(forKey: UserDefaultsKey.userId)
        if let str, !str.isEmpty { return str }
        let newId = UUID().uuidString
        UserDefaults.standard.setValue(newId, forKey: UserDefaultsKey.userId)
        return newId
    }
    
    init() {}
    
    func getCurrentUserData() async -> User {
        currentUser = await userService.fetchCurrentUser()
        if currentUser == nil {
            let user = User(id: userId, username: "", biography: "", profileSticker: stickerService.defaultSticker, events: [])
            try! userService.createUser(user: user)
            currentUser = user
        }
        return currentUser!
    }
    
    func getProfileSticker() async -> Sticker {
        if let profileSticker { return profileSticker }
        currentUser = await getCurrentUserData()
        profileSticker = await stickerService.getStickerFromReference(currentUser!.profileSticker)!
        return profileSticker!
    }
    
    func getEvents() async -> [Event] {
        currentUser = await userService.fetchCurrentUser()
        return await currentUser!.events.asyncCompactMap({ await eventService.getEventFromReference($0) })
    }
}
