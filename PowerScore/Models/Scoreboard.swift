//
//  Scoreboard.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 08.03.2024.
//

import Foundation
import SwiftUI

@Observable class Scoreboard {
    public var countries : [Country]
    public var participants : [Participant]
    public var votes : [Vote]
    public var order : [Country]
    
    init() {
        self.countries = []
        self.participants = []
        self.votes = []
        self.order = []
    }
    init(template: Bool){
        self.countries = []
        self.participants = []
        self.votes = []
        self.order = []
        if template {
            let countries = ["Россия", "Китай", "Бразилия", "Турция", "Сербия", "ЮАР", "Казахстан", "Узбекистан", "Таджикистан", "Украина", "Беларусь", "Бельгия", "Нидерланды", "Франция", "Великобритания", "Дания", "Германия", "Швеция", "Польша"]
            let marks = [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
            for country in countries {
                let _country = Country(name: country)
                self.countries.append(_country)
                let participant = Participant(Number: 0, Song: "", Performer: "", Country: _country)
                self.participants.append(participant)
                
                var index = 0
                for item in countries.filter({__country in return __country != country}) {
                    if index >= marks.count {
                        break
                    }
                    let voteJury = Vote(From: _country, Value: marks[index], To: Country(name: item), Issuer: .Jury)
                    let votePublic = Vote(From: _country, Value: marks[index], To: Country(name: item), Issuer: .Public)
                    self.votes.append(voteJury)
                    self.votes.append(votePublic)
                    index += 1
                }
                
            }
        }
    }
    init(countries: [Country], participants: [Participant], votes: [Vote], order: [Country]) {
        self.countries = countries
        self.participants = participants
        self.votes = votes
        self.order = order
    }
    
    public func deleteCountry(country: Country) {
        participants.removeAll(where: { participant in
            return participant.Country == country
        })
        votes.removeAll(where: { vote in
            return vote.From == country
                || vote.To == country
        })
        order.removeAll(where: { _order in
            return _order == country
        })
        countries.removeAll(where: { _country in
            return _country == country
        })
    }
    
    public func deleteParticipant(participant: Participant) {
        votes.removeAll(where: { vote in
            return vote.From == participant.Country
                || vote.To == participant.Country
        })
        order.removeAll(where: { _order in
            return _order == participant.Country
        })
        participants.removeAll(where: { _participant in
            return _participant == participant
        })
    }
}

extension EnvironmentValues {
    var scoreboard: Scoreboard {
        get { self[ScoreboardKey.self] }
        set { self[ScoreboardKey.self] = newValue }
    }
}

private struct ScoreboardKey: EnvironmentKey {
    static var defaultValue: Scoreboard = Scoreboard()
}
