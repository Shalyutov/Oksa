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
    public var isNationVisible : Bool
    public var marks : [Int]
    
    init() {
        self.countries = []
        self.participants = []
        self.votes = []
        self.order = []
        self.marks = []
        self.isNationVisible = false
    }
    init(template: Bool){
        self.countries = []
        self.participants = []
        self.votes = []
        self.order = []
        self.marks = []
        self.isNationVisible = true
        if template {
            let countries = ["Россия", "Китай", "Бразилия", "Турция", "Сербия", "ЮАР", "Казахстан", "Узбекистан", "Таджикистан", "Украина", "Беларусь", "Бельгия", "Нидерланды", "Франция", "Великобритания", "Дания", "Германия", "Швеция", "Польша"]
            marks = [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
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
    init(countries: [Country], participants: [Participant], votes: [Vote], order: [Country], marks: [Int], isNationVisible: Bool) {
        self.countries = countries
        self.participants = participants
        self.votes = votes
        self.order = order
        self.marks = marks
        self.isNationVisible = isNationVisible
    }
    public static func Aurora() -> Scoreboard {
        let marks = [15, 12, 10, 8, 6, 4, 2]
        let countries = [Country(name: "Андрей"), Country(name: "Максим"), Country(name: "Алексей"), Country(name: "Jury A"), Country(name: "Jury B"), Country(name: "Jury C"), Country(name: "Jury D"), Country(name: "Jury E")]
        let participants = [
            Participant(Number: 0, Song: "Happy That You Find Me", Performer: "Danny Saucedo", Country: countries[0]),
            Participant(Number: 1, Song: "Sinceramente", Performer: "Annalisa", Country: countries[3]),
            Participant(Number: 2, Song: "I Don't Wanna Wait", Performer: "OneRepublic & David Guetta", Country: countries[4]),
            Participant(Number: 3, Song: "(It Goes Like) Nanana", Performer: "Peggy Gou", Country: countries[2]),
            Participant(Number: 4, Song: "Ева", Performer: "Винтаж", Country: countries[1]),
            Participant(Number: 5, Song: "Sweaters", Performer: "Blanks", Country: countries[5]),
            Participant(Number: 6, Song: "Hold Me Closer", Performer: "Cornelia Jacobs", Country: countries[6]),
            Participant(Number: 7, Song: "Damdiggida", Performer: "KEiiNO", Country: countries[7])
            ]
        var votes : [Vote] = []
        let juries : [[Int]] = [
            [1, 4, 3, 6, 5, 7, 2], //Андрей
            [3, 2, 5, 0, 7, 6, 1], //Максим
            [4, 6, 5, 1, 2, 0, 7], //A
            [3, 4, 2, 0, 7, 6, 5], //B
            [0, 6, 1, 4, 3, 5, 7], //C
            [1, 6, 4, 3, 0, 2, 7], //D
            [4, 3, 5, 7, 1, 2, 0], //E
            [3, 2, 0, 1, 4, 5, 6]  //F
        ]
        
        var j = 0
        for jury in juries {
            var r = 0
            for rate in jury {
                votes.append(Vote(From: countries[j], Value: marks[r], To: participants[rate].Country, Issuer: VoteIssuer.Jury))
                r += 1
            }
            j += 1
        }
        
        votes.append(Vote(From: countries[2], Value: 6, To: participants[0].Country, Issuer: VoteIssuer.Public))
        votes.append(Vote(From: countries[2], Value: 73, To: participants[1].Country, Issuer: VoteIssuer.Public))
        votes.append(Vote(From: countries[2], Value: 1, To: participants[2].Country, Issuer: VoteIssuer.Public))
        votes.append(Vote(From: countries[2], Value: 122, To: participants[3].Country, Issuer: VoteIssuer.Public))
        votes.append(Vote(From: countries[2], Value: 228, To: participants[4].Country, Issuer: VoteIssuer.Public))
        votes.append(Vote(From: countries[2], Value: 7, To: participants[5].Country, Issuer: VoteIssuer.Public))
        votes.append(Vote(From: countries[2], Value: 9, To: participants[6].Country, Issuer: VoteIssuer.Public))
        votes.append(Vote(From: countries[2], Value: 6, To: participants[7].Country, Issuer: VoteIssuer.Public))
        return Scoreboard(countries: countries, participants: participants, votes: votes, order: countries, marks: marks, isNationVisible: false)
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
