//
//  Participant.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 24.01.2024.
//

import Foundation
import SwiftData

@Model
final class Participant {
    public var Number : Int
    public var Song : String
    public var Performer : String
    @Attribute(.unique) public var Country : Country?
    
    init(Number: Int, Song: String, Performer: String, Country: Country) {
        self.Number = Number
        self.Song = Song
        self.Performer = Performer
        self.Country = Country
    }
}
