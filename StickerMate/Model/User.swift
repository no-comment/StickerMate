//
//  User.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import Foundation

struct User: Codable {
    let id: String?
    let username: String
    let biography: String
    let profileSticker: Sticker
    let events: [Event]
}
