//
//  Item.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 24.01.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
