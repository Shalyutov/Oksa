//
//  ParticipantEditor.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 05.02.2024.
//

import Foundation
import SwiftData
import SwiftUI

struct ParticipantEditor: View {
    @Environment(\.scoreboard) private var scoreboard
    @Environment(\.dismiss) private var dismiss
    @State private var country : Country?
    @State private var performer = ""
    @State private var number = 0
    @State private var song = ""
    let participant: Participant?
    
    private var title: String {
        country == nil ? "Новый участник" : "Редактирование участника"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Picker ("Страна", selection: $country){
                    Text("Выберите страну").tag(nil as Country?)
                    ForEach(scoreboard.countries.filter({ _country in
                        return !scoreboard.participants.contains { _participant in
                            return _participant.Country == _country
                        }
                    }), id: \.self) { item in
                        Text(item.name).tag(item as Country?)
                    }
                }
                TextField("Номер", value: $number, formatter: NumberFormatter())
                TextField("Имя", text: $performer)
                TextField("Песня", text: $song)
            }
            .padding(16)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Сохранить") {
                    withAnimation {
                        save()
                        dismiss()
                    }
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Отменить", role: .cancel) {
                    dismiss()
                }
            }
        }
        .onAppear(){
            if let participant {
                performer = participant.Performer
                number = participant.Number
                country = participant.Country
                song = participant.Song
            }
        }
    }
    private func save(){
        if let participant {
            participant.Performer = performer
            participant.Number = number
            participant.Country = country!
            participant.Song = song
        }
        else {
            if let country {
                let newParticipant = Participant(Number: number, Song: song, Performer: performer, Country: country)
                scoreboard.participants.append(newParticipant)
            }
        }
    }
}
