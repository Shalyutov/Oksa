//
//  VotingView.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 05.02.2024.
//

import SwiftUI
import SwiftData

struct VotingView: View {
    @Environment(\.scoreboard) private var scoreboard
    @State private var currentCountry: Country? = nil
    @State private var issuer : VoteIssuer = .Jury
    @State private var rating: [Country] = []
    @State private var isLoaded: Bool = false
    @State private var isSaved: Bool = false
    @State private var isReset: Bool = false
    
    private var marks = [12, 10, 8, 7, 6, 5, 4, 3, 2, 1]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Голосование")
                .font(.title2)
            Picker("Режим", selection: $issuer) {
                ForEach([VoteIssuer.Jury, VoteIssuer.Public], id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: issuer){
                getRating()
            }
            Picker ("Страна", selection: $currentCountry){
                Text("Выберите страну")
                    .tag(nil as Country?)
                ForEach(scoreboard.countries, id: \.self) { item in
                    Text(item.name)
                        .tag(item as Country?)
                }
            }
            .padding()
            .onChange(of: currentCountry){
                getRating()
            }
            
            if currentCountry != nil {
                HStack{
                    Text("Рейтинг")
                    if isSaved {
                        Image(systemName: "checkmark.seal")
                    }
                    else {
                        Image(systemName: "seal")
                    }
                    if isLoaded {
                        Image(systemName: "externaldrive.badge.checkmark")
                        Text("Загружен")
                    }
                    if isReset {
                        Image(systemName: "plus.square")
                        Text("Чист")
                    }
                }
                List {
                    ForEach(rating) { country in
                        HStack{
                            if let place = rating.firstIndex(of: country) {
                                if place < marks.count {
                                    let badgeView = Text("\(marks[place])")
                                            .monospacedDigit()
                                            .foregroundColor(isSaved ? .green : .blue)
                                            .bold()
                                    Text(country.name)
                                        .badge(badgeView)
                                }
                                else {
                                    Text(country.name)
                                }
                            }
                        }
                    }
                    .onMove { from, to in
                        withAnimation {
                            rating.move(fromOffsets: from, toOffset: to)
                            isSaved = false
                        }
                    }
                    
                }
                .onAppear(perform: getRating)
                HStack {
                    Button(action: saveRating){
                        Label("Сохранить рейтинг", systemImage: "checkmark")
                    }
                    Button(action: nextCountry){
                        Label("Следующая страна", systemImage: "arrow.forward")
                    }
                }
                
                Button(action: resetRating){
                    Label("Сброс", systemImage: "gobackward")
                }
            }
            else{
                Text("Выберите страну для голосования")
            }
        }
        .padding(16)
    }
    private func nextCountry() {
        if let current = scoreboard.countries.firstIndex(of: currentCountry ?? Country(name: "")) {
            let next = scoreboard.countries.index(after: current)
            if next >= 0 && next < scoreboard.countries.count {
                currentCountry = scoreboard.countries[next]
                getRating()
            }
        }
    }
    private func saveRating() {
        if let currentCountry {
            scoreboard.votes.removeAll(where: {vote in
                return vote.From == currentCountry && vote.Issuer == issuer
            })
            for place in 0..<min(marks.count, rating.count) {
                let vote = Vote(From: currentCountry, Value: marks[place], To: rating[place], Issuer: issuer)
                scoreboard.votes.append(vote)
            }
            isSaved = true
            isReset = false
            isLoaded = true
        }
    }
    private func getRating() {
        if let currentCountry {
            var votingRating = scoreboard.votes.filter { vote in
                return vote.From == currentCountry
                    && vote.Issuer == issuer
            }
            if votingRating.isEmpty {
                rating = scoreboard.countries.filter { country in
                    return country != currentCountry
                }
                isReset = true
                isSaved = false
                isLoaded = false
            }
            else {
                votingRating.sort(by: {lhs, rhs in
                    return lhs.Value > rhs.Value
                })
                rating.removeAll()
                for rate in votingRating {
                    rating.append(rate.To)
                }
                let difference = scoreboard.countries.filter { country in
                    return !rating.contains(country)
                        && country != currentCountry
                }
                rating.append(contentsOf: difference)
                isSaved = true
                isLoaded = true
                isReset = false
            }
        }
    }
    private func resetRating() {
        if let currentCountry {
            scoreboard.votes.removeAll(where: {vote in
                return vote.From == currentCountry && vote.Issuer == issuer
            })
            isReset = true
            isSaved = false
            isLoaded = false
        }
    }
}

#Preview {
    VotingView()
        .environment(Scoreboard())
}
