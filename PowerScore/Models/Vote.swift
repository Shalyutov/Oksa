//
//  Vote.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 24.01.2024.
//

import Foundation
import SwiftData

@Model
final class Vote {
    var Participant : Participant
    var Value : UInt
    var Country : String
    var Issuer : VoteIssuer
    
    init(Participant: Participant, Value: UInt, Country: String, Issuer: VoteIssuer) {
        self.Participant = Participant
        self.Value = Value
        self.Country = Country
        self.Issuer = Issuer
    }
}

enum VoteIssuer : Codable {
    case Jury
    case Public
}
