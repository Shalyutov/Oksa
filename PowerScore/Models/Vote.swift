//
//  Vote.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 24.01.2024.
//

import Foundation
import SwiftData

@Observable final class Vote : Identifiable, Equatable, Hashable {
    public var From : Country
    public var Value : Int
    public var To : Country
    public var Issuer : VoteIssuer
    
    init(From: Country, Value: Int, To: Country, Issuer: VoteIssuer) {
        self.From = From
        self.Value = Value
        self.To = To
        self.Issuer = Issuer
    }
    
    static func == (lhs: Vote, rhs: Vote) -> Bool {
        return lhs.From == rhs.From
        && lhs.To == rhs.To
        && lhs.Value == rhs.Value
        && lhs.Issuer == rhs.Issuer
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(From)
        hasher.combine(Value)
        hasher.combine(To)
        hasher.combine(Issuer)
    }
}

enum VoteIssuer : String {
    case Jury = "Жюри"
    case Public = "Зрители"
}
