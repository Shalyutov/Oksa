//
//  Country.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 28.01.2024.
//

import Foundation
import SwiftUI

@Observable class Country : Equatable, Hashable, Identifiable{
    public var name: String
    
    init(name: String) {
        self.name = name
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
