//
//  ScorePanel.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 07.02.2024.
//

import SwiftUI

struct ScorePanel: View {
    @State public var keeper : ScoreKeeper
    var body: some View {
        HStack {
            CountryFlag(name: keeper.Participant.Country!.name)
                .frame(height: 30)
            Text("Hello, World!")
            Spacer()
            Text("\(keeper.Score)")
        }
        .padding(4)
        
    }
}

#Preview {
    ScorePanel(keeper: ScoreKeeper(Participant: Participant(Number: 1, Song: "", Performer: "", Country: Country(name: "Россия")), Score: 100))
}
