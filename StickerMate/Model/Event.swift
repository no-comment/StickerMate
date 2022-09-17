//
//  Event.swift
//  StickerMate
//
//  Created by Cameron Shemilt on 17.09.22.
//

import Foundation

struct Event: Codable {
    let id: String?
    let sticker: Sticker
    let startDate: Date
    let endDate: Date
}
