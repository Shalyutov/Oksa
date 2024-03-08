//
//  ScoreKeeper.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 07.02.2024.
//

import Foundation

class ScoreKeeper {
    public var Participant : Participant
    public var Score : Int
    
    init(Participant: Participant, Score: Int) {
        self.Participant = Participant
        self.Score = Score
    }
}
