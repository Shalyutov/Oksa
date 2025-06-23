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
        let marks = [15, 11, 9, 7, 5, 3, 1]
        let countries = [
            Country(name: "Jury A"),
            Country(name: "Jury B"),
            Country(name: "Jury C"),
            Country(name: "Jury D"),
            Country(name: "Jury E"),
            Country(name: "Jury F"),
            Country(name: "Jury G"),
            Country(name: "Jury H"),
            Country(name: "Jury I"),
            Country(name: "Jury J"),
        ]
        let participants = [
            Participant(Number: 0, Song: "Heaven Hates Me", Performer: "Gregory Dillon", Country: countries[0]),
            Participant(Number: 1, Song: "Show Me What Love Is", Performer: "Erik Segerstedt", Country: countries[1]),
            Participant(Number: 2, Song: "Unforgettable", Performer: "Marcus & Martinus", Country: countries[2]),
            Participant(Number: 3, Song: "Home Without a Heart", Performer: "Blanks", Country: countries[3]),
            Participant(Number: 4, Song: "Drunk Groove", Performer: "MARUV & BOOSIN", Country: countries[4]),
            Participant(Number: 5, Song: "Homay", Performer: "AY YOLA", Country: countries[5]),
            Participant(Number: 6, Song: "Revolution", Performer: "Måns Zermerlow", Country: countries[6]),
            Participant(Number: 7, Song: "San Francisco Boy", Performer: "Hooja & Käärijä", Country: countries[7]),
            Participant(Number: 8, Song: "Baller", Performer: "Abor & Tynna", Country: countries[8]),
            Participant(Number: 9, Song: "140", Performer: "IOWA", Country: countries[9])
        ]
        var votes : [Vote] = []
        let juries : [[Int]] = [
            [10, 9, 6, 1, 3, 7, 2],
            [9, 7, 8, 5, 2, 1, 4],
            [7, 8, 4, 5, 9, 6, 3],
            [7, 1, 2, 4, 6, 9, 10],
            [7, 1, 3, 10, 5, 6, 4],
            [2, 1, 7, 5, 3, 9, 10],
            [1, 10, 5, 8, 6, 7, 2],
            [4, 5, 8, 9, 2, 3, 10],
            [5, 10, 9, 2, 1 ,4, 8],
            [5, 2, 10, 1, 4, 8, 9],
        ]
        
        var j = 0
        for jury in juries {
            var r = 0
            for rate in jury {
                votes.append(Vote(From: countries[j], Value: marks[r], To: participants[rate-1].Country, Issuer: VoteIssuer.Jury))
                r += 1
            }
            j += 1
        }
        
        let publicVotes : [Int] = [10, 20, 30, 40, 250, 80, 100, 200, 100, 20]
        var index : Int = 0
        for participant in participants {
            votes.append(Vote(From: countries[0], Value: publicVotes[index], To: participant.Country, Issuer: VoteIssuer.Public))
            index += 1
        }
        
        return Scoreboard(countries: countries,
                          participants: participants,
                          votes: votes,
                          order: countries,
                          marks: marks,
                          isNationVisible: false)
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
