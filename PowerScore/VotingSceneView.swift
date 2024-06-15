//
//  VotingSceneView.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 07.02.2024.
//

import SwiftUI
import SwiftData
import AVFoundation

struct VotingSceneView: View {
    @Environment(\.scoreboard) private var scoreboard
    @State private var keepers : [ScoreKeeper] = []
    @State private var publicOrder : [Country] = []
    @State private var current : Int = 0
    @State private var isMainMarkGiven : Bool = false
    @State private var isRemainMarkGiven : Bool = false
    @State private var voting : VoteIssuer = .Jury
    static var player: AVAudioPlayer!
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let rows = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            HStack(spacing: 0){
                ForEach(1..<20) {index in
                    Bar(index: index)
                }
            }
            VStack {
                if keepers.count > 13 && keepers.count < 27 {
                    HStack{
                        LazyHGrid(rows: rows) {
                            ForEach(keepers) { keeper in
                                ScorePanel(keeper: keeper, isNationVisible: scoreboard.isNationVisible)
                            }
                        }
                        .frame(height: 600)
                        HStack{
                            Text("jijx")
                        }
                        .frame(width: 300)
                    }
                    
                    
                }
                else {
                    HStack{
                        LazyVGrid(columns: [GridItem(.flexible())]) {
                            ForEach(keepers, id: \.id) { keeper in
                                ScorePanel(keeper: keeper, isNationVisible: scoreboard.isNationVisible)
                            }
                        }
                        HStack{
                        }
                        .frame(width: 300)
                    }
                }
                if (scoreboard.isNationVisible){
                    if current >= 0 && current < scoreboard.order.count && voting == .Jury {
                        Text("Сейчас голосует \(scoreboard.order[current].name)")
                            .font(.custom("AvantGardeCTT", size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(16)
                    }
                    else if current >= 0 && current < scoreboard.order.count && voting == .Public {
                        Text("\(publicOrder[current].name) получает баллы от телезрителей")
                            .font(.custom("AvantGardeCTT", size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(16)
                    }
                }
                
            }
            .onAppear {
                if !scoreboard.participants.isEmpty {
                    setupKeepers()
                    if scoreboard.order.isEmpty{
                        scoreboard.order = scoreboard.countries
                    }
                }
            }
            .padding(100)
            .toolbar {
                ToolbarItem {
                    Button (action: {
                        if voting == .Jury {
                            juryVote()
                        }
                        else if voting == .Public {
                            publicVote()
                        }
                    }) {
                        Label("Продолжить", systemImage: "arrow.forward")
                    }
                }
                ToolbarItem{
                    Button (action: {
                        current = 0;
                        if !scoreboard.participants.isEmpty {
                            setupKeepers()
                        }
                    }) {
                        Label("Сброс", systemImage: "gobackward")
                    }
                }
            }
        }
    }
    
    private func setupKeepers() {
        current = 0
        voting = .Jury
        keepers.removeAll()
        for participant in scoreboard.participants {
            let keeper = ScoreKeeper(Participant: participant, Score: 0)
            keepers.append(keeper)
        }
        playSound(name: "37")
    }
    private func juryVote() {
        if current < scoreboard.order.count {
            let orderCountry = scoreboard.order[current]
            var marks = scoreboard.votes.filter { Vote in
                return Vote.From == orderCountry
                && Vote.Issuer == .Jury
            }
            marks.sort(by: {lhs, rhs in
                return lhs.Value < rhs.Value
            })
            if isMainMarkGiven && isRemainMarkGiven {
                isMainMarkGiven = false
                isRemainMarkGiven = false
                current += 1
                playSound(name: "37")
            }
            else if isRemainMarkGiven && !isMainMarkGiven {
                let keeper = keepers.first(where: { keeper in
                    return keeper.Participant.Country == marks.last?.To
                })
                keeper!.FromJury += Double(marks.last!.Value)
                playSound(name: "28")
                isMainMarkGiven = true
                updateKeepers()
            }
            else if !isRemainMarkGiven && !isMainMarkGiven {
                for mark in marks.filter({ _mark in
                    return _mark != marks.last!
                }) {
                    let keeper = keepers.first(where: { keeper in
                        return keeper.Participant.Country == mark.To
                    })
                    keeper!.FromJury += Double(mark.Value)
                }
                playSound(name: "0B")
                isRemainMarkGiven = true
                updateKeepers()
            }
        }
        else {
            voting = .Public
            current -= 1
            playSound(name: "37")
            for keeper in keepers {
                publicOrder.append(keeper.Participant.Country)
            }
        }
    }
    private func publicVote() {
        if current >= 0 && current < keepers.count {
            let orderCountry = publicOrder[current]
            let marks = scoreboard.votes.filter { Vote in
                return Vote.To == orderCountry
                && Vote.Issuer == .Public
            }
            var sum = 0
            for mark in marks {
                sum += mark.Value
            }
            let keeper = keepers.first(where: { keeper in
                return keeper.Participant.Country == orderCountry
            })
            keeper!.FromPublic = Double(sum)
            current -= 1
            playSound(name: "6D")
            updateKeepers()
        }
    }
    private func playSound(name: String) {
        let path = Bundle.main.path(forResource: name, ofType: "wav")
        let url = URL(fileURLWithPath: path ?? "")
        do {
            VotingSceneView.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: "wav")
            VotingSceneView.player.prepareToPlay()
            VotingSceneView.player.play()
        }
        catch {
            print("Ошибка воспроизведения")
        }
    }
    private func updateKeepers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            withAnimation {
                keepers.sort(by: {lhs, rhs in return lhs.Score > rhs.Score})
            }
            playSound(name: "5A")
        })
    }
}

#Preview {
    VotingSceneView()
        .environment(Scoreboard(template: true))
}
