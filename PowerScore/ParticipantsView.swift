//
//  ParticipantsView.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 05.02.2024.
//

import SwiftUI
import SwiftData

struct ParticipantsView: View {
    @Environment(\.scoreboard) private var scoreboard
    @State private var isEditing = false
    @State private var selection : Participant?
    
    var body: some View {
        VStack {
            List(selection: $selection) {
                ForEach(scoreboard.participants, id: \.self) { participant in
                    HStack{
                        CountryFlag(name: participant.Country.name)
                            .frame(height: 30)
                            .padding(4)
                        VStack(alignment: .leading) {
                            Text(participant.Performer)
                                .font(.title3)
                            Text(participant.Song)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    withAnimation {
                        for index in indexSet {
                            scoreboard.deleteParticipant(participant: scoreboard.participants[index])
                        }
                    }
                })
            }
            .sheet(isPresented: $isEditing){
                if let selection{
                    ParticipantEditor(participant: selection)
                }
                else {
                    ParticipantEditor(participant: nil)
                }
            }
            .toolbar{
                Button(action: addParticipant){
                    Label("Добавить", systemImage: "plus")
                }
                if selection != nil {
                    Button(action: {isEditing = true}){
                        Label("Изменить", systemImage: "pencil")
                    }
                    Button(action: deleteParticipant){
                        Label("Удалить", systemImage: "trash")
                    }
                }
            }
            
        }
        .padding(8)
    }
    private func addParticipant(){
        selection = nil
        isEditing = true
    }
    private func deleteParticipant(){
        withAnimation {
            if selection != nil {
                let participantToDelete = scoreboard.participants.first(where: {participant in participant.Performer == selection?.Performer})
                selection = nil
                scoreboard.deleteParticipant(participant: participantToDelete!)
            }
        }
    }
}

#Preview {
    ParticipantsView()
        .environment(Scoreboard())
}
