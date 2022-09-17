//
//  AppModel.swift
//  StickerMate
//
//  Created by Miká Kruschel on 17.09.22.
//

import CollectionConcurrencyKit
import FirebaseFirestore
import Foundation

@MainActor
class AppModel: ObservableObject {
    @Published private var currentUser: User?
    @Published private var profileSticker: Sticker?

    @Published private var collectedUsers: [Sticker]?
    @Published private var collectedEvents: [Event]?

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
    
    init() {
        Task(priority: .high) {
            _ = await getCurrentUserData()
        }
    }
    
    func getCurrentUserData() async -> User {
        currentUser = await userService.fetchCurrentUser()
        if currentUser == nil {
            let user = User(id: userId, username: "", biography: "", profileSticker: stickerService.defaultSticker, events: [], collectedUsers: [], collectedEvents: [])
            try! userService.createUser(user: user)
            currentUser = user
        }
        return currentUser!
    }
    
    func getScannedUser(_ userId: String) async -> User? {
        return await userService.fetchUser(id: userId)
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
    
    func updateUser(_ user: User) {
        do {
            try userService.updateUser(user)
            currentUser = user
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func updateSticker(_ sticker: Sticker) {
        do {
            try stickerService.updateSticker(sticker)
            profileSticker = sticker
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func getCollectedUsers() async -> [Sticker] {
        currentUser = await userService.fetchCurrentUser()
        return await currentUser?.collectedUsers.asyncCompactMap({ await stickerService.getStickerFromReference($0) }) ?? []
    }

    func getCollectedEvents() async -> [Event] {
        currentUser = await userService.fetchCurrentUser()
        return await (currentUser?.collectedEvents.asyncCompactMap({ await eventService.getEventFromReference($0) })) ?? []
    }
    
    func getStickerFromEvent(_ event: Event) async -> Sticker? {
        return await stickerService.getStickerFromReference(event.sticker)
    }
}
