//
//  Country.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 28.01.2024.
//

import Foundation
import SwiftData

@Model
final class Country{
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
