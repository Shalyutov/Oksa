//
//  Participant.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 24.01.2024.
//

import Foundation
import SwiftData

@Observable final class Participant : Equatable, Hashable {
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        return lhs.Country == rhs.Country
        && lhs.Performer == rhs.Performer
        && lhs.Song == rhs.Song
        && lhs.Number == rhs.Number
    }
    
    public var Number : Int
    public var Song : String
    public var Performer : String
    public var Country : Country
    
    init(Number: Int, Song: String, Performer: String, Country: Country) {
        self.Number = Number
        self.Song = Song
        self.Performer = Performer
        self.Country = Country
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Number)
        hasher.combine(Song)
        hasher.combine(Performer)
        hasher.combine(Country)
    }
}
