//
//  ScoreKeeper.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 07.02.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Observable class ScoreKeeper : Equatable, Identifiable, Hashable {
    static func == (lhs: ScoreKeeper, rhs: ScoreKeeper) -> Bool {
        return lhs.Country == rhs.Country 
        && lhs.Score == rhs.Score
        && lhs.id == rhs.id
    }
    
    public var Country : Country
    public var Score : Double
    public var FromJury : Double = 0
    public var FromPublic : Double = -1
    
    var id: UUID
    
    init(Participant: Country, Score: Double) {
        self.Country = Participant
        self.Score = Score
        self.id = UUID()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Country)
        hasher.combine(Score)
        hasher.combine(id)
    }
}
