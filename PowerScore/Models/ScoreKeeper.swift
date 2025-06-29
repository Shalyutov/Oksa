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
        return lhs.Participant == rhs.Participant
        && lhs.Score == rhs.Score
        && lhs.id == rhs.id
    }
    
    public var Participant : Participant
    public var Score : Double = 0.0
    public var FromJury : Double = 0
    public var FromPublic : Double = -1
    
    var id: UUID
    
    init(Participant: Participant, Score: Double) {
        self.Participant = Participant
        self.Score = Score
        self.id = UUID()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Participant)
        hasher.combine(Score)
        hasher.combine(id)
    }
}
