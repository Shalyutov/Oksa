//
//  CountryView.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 27.01.2024.
//

import SwiftUI
import SwiftData

struct CountriesView: View {
    @Environment(\.scoreboard) private var scoreboard
    @State private var isEditing = false
    @State private var selection : Country? = nil
    
    var body: some View {
        VStack {
            List(selection: $selection) {
                ForEach(scoreboard.countries, id: \.self) { country in
                    HStack{
                        CountryFlag(name: country.name)
                            .frame(height: 20)
                            .padding(4)
                        Text(country.name)
                            .font(.title3)
                            .padding(4)
                    }
                }
            }
            .sheet(isPresented: $isEditing){
                if let selection{
                    CountryEditor(country: selection)
                }
                else {
                    CountryEditor(country: nil)
                }
            }
            .toolbar{
                Button(action: addTemplate){
                    Label("Шаблон", systemImage: "wand.and.stars")
                }
                Button(action: addCountry){
                    Label("Добавить", systemImage: "plus")
                }
                if selection != nil {
                    Button(action: {isEditing = true}){
                        Label("Изменить", systemImage: "pencil")
                    }
                    Button(action: deleteCountry){
                        Label("Удалить", systemImage: "trash")
                    }
                }
            }
            
        }
        .padding(8)
    }
    private func addCountry(){
        selection = nil
        isEditing = true
    }
    private func addTemplate(){
        let countries = ["Россия", "Китай", "Бразилия", "Турция", "Сербия", "ЮАР", "Казахстан", "Узбекистан", "Таджикистан", "Украина", "Беларусь", "Бельгия", "Нидерланды", "Франция", "Великобритания", "Дания", "Германия", "Швеция", "Польша"]
        let marks = [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
        for country in countries {
            let _country = Country(name: country)
            scoreboard.countries.append(_country)
            let participant = Participant(Number: 0, Song: "", Performer: "", Country: _country)
            scoreboard.participants.append(participant)
            
            var index = 0
            for item in countries.filter({__country in return __country != country}) {
                if index >= marks.count {
                    break
                }
                let voteJury = Vote(From: _country, Value: marks[index], To: Country(name: item), Issuer: .Jury)
                let votePublic = Vote(From: _country, Value: marks[index], To: Country(name: item), Issuer: .Public)
                scoreboard.votes.append(voteJury)
                scoreboard.votes.append(votePublic)
                index += 1
            }
            
        }
    }
    private func deleteCountry(){
        withAnimation {
            if selection != nil {
                let deletingCountry = scoreboard.countries.first(where: {country in country.name == selection?.name})
                selection = nil
                scoreboard.deleteCountry(country: deletingCountry!)
            }
        }
    }
}

#Preview {
    CountriesView()
        .environment(Scoreboard())
}
