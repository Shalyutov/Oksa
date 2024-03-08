//
//  VotingView.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 05.02.2024.
//

import SwiftUI
import SwiftData

struct VotingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var participants: [Participant]
    @Query private var countries: [Country]
    @State private var currentCountry: Country? = nil
    @State private var rating: [Country] = []
    private var marks = [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Голосование")
                .font(.title2)
            Picker ("Страна", selection: $currentCountry){
                Text("Выберите страну")
                    .tag(nil as Country?)
                ForEach(countries, id: \.self) { item in
                    Text(item.name)
                        .tag(item as Country?)
                }
            }
            
            if currentCountry != nil {
                Text("Рейтинг")
                List {
                    ForEach(rating.filter{country in return country.name != currentCountry?.name ?? ""}){country in
                        HStack{
                            let place = rating.filter{country in return country.name != currentCountry?.name ?? ""}.firstIndex(of: country)
                            if place != nil{
                                let badgeView = Text("\(marks[place!])")
                                        .monospacedDigit()
                                        .foregroundColor(.blue)
                                        .bold()
                                Text(country.name)
                                    .badge(badgeView)
                            }
                            else {
                                Text(country.name)
                            }
                        }
                    }
                    .onMove { from, to in
                        rating.move(fromOffsets: from, toOffset: to)
                    }
                }.onAppear(perform: {
                    rating = countries
                })
                
            }
            else{
                Text("Выберите страну для голосования")
            }
        }
        .padding(16)
    }
}

#Preview {
    VotingView()
        .modelContainer(for: [Participant.self, Country.self], inMemory: true)
}
