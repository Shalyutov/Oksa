//
//  VotingSceneView.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 07.02.2024.
//

import SwiftUI
import SwiftData
import AVFoundation

class VoteRes {
    var id : Int = 0
    var votes : Int = 0
    init(id: Int, votes: Int) {
        self.id = id
        self.votes = votes
    }
}

struct VotingSceneView: View {
    @Environment(\.scoreboard) private var scoreboard
    @State private var keepers : [ScoreKeeper] = []
    @State private var publicOrder : [Country] = []
    @State private var current : Int = 0
    @State private var isMainMarkGiven : Bool = false
    @State private var isRemainMarkGiven : Bool = false
    @State private var voting : VoteIssuer = .Jury
    @State private var isWin : Bool = false
    static var player: AVAudioPlayer!
    
    @State private var isVotingPopover: Bool = false
    
    @State var resu : [Int] = []
    @State var resul : [Int] = []
    
    
    
    func getRows() -> [GridItem] {
        var rows : [GridItem] = []
        for _ in 0..<14 {
            rows.append(GridItem(.flexible()))
        }
        return rows
    }
    
    func startVoting() {
        let url = NSURL(string: "https://netsword.tech/api/open") //Remember to put ATS exception if the URL is not https
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("LGUJTFJHTFFIKJHOUiuhfeo84938749tu4oi5g3hr8fybe8fn90g948urtguhjkrgdekjfgreth", forHTTPHeaderField: "AUTH") //Optional
        request.httpMethod = "POST"
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)

        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if error == nil {
            }
        }
        dataTask.resume()
    }
    func stopVoting() {
        let url = NSURL(string: "https://netsword.tech/api/close") //Remember to put ATS exception if the URL is not https
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("LGUJTFJHTFFIKJHOUiuhfeo84938749tu4oi5g3hr8fybe8fn90g948urtguhjkrgdekjfgreth", forHTTPHeaderField: "AUTH") //Optional
        request.httpMethod = "POST"
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)

        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if error == nil {
            }
        }
        dataTask.resume()
    }
    
    func televoting() { //todo исправить на прод netsword.tech
        let url = NSURL(string: "https://netsword.tech/api/results") //Remember to put ATS exception if the URL is not https
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("LGUJTFJHTFFIKJHOUiuhfeo84938749tu4oi5g3hr8fybe8fn90g948urtguhjkrgdekjfgreth", forHTTPHeaderField: "AUTH") //Optional
        request.httpMethod = "GET"
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)


        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            resul.removeAll()
            resu.removeAll()
            scoreboard.votes.removeAll(where: {v in return v.Issuer == .Public})
            if error == nil {

                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                var i = 0
                var sum = 0
                
                for item in json as! [[String:Any]] {
                    let val = Int(item["Votes"] as! Int64)
                    resul.append(i)
                    resu.append(val)
                    sum += val
                    i+=1
                }
                i = 0
                for part in scoreboard.participants {
                    let val = sum == 0 ? 0 : Int(ceil((Double(resu[i]) / Double(sum)) * Double(600)))
                    
                    scoreboard.votes.append(Vote(From: scoreboard.countries[0], Value: val, To: part.Country, Issuer: .Public))
                    i+=1
                }
                isVotingPopover = true
            }
        }
        dataTask.resume()
    }
    
    func getHint() -> String {
        switch voting {
        case .Jury:
            let target = scoreboard.votes.first(where: {$0.Issuer == voting && $0.From == scoreboard.order[current] && $0.Value == scoreboard.marks.first})?.To
            let song = scoreboard.participants.first(where: {$0.Country == target})?.Song
            let hint = "\n" + (isRemainMarkGiven ? (scoreboard.marks.first?.description ?? "=") + " баллов\n" + (song ?? "-") : "\nбаллы")
            if isMainMarkGiven {
                if (current < scoreboard.order.count-1){
                    return "Следующее жюри \n" + scoreboard.order[current+1].name
                }
                else {
                    return "Телеголосование"
                }
            }
            else {
                return "Жюри\n\n" + scoreboard.order[current].name + "\n" + hint
            }
            
        case .Public:
            if current >= 0 {
                let target = publicOrder[current]
                let vote = scoreboard.votes.first(where: {$0.Issuer == voting && $0.To == target})?.Value
                let song = scoreboard.participants.first(where: {$0.Country == target})?.Song
                
                var diff = ""
                
                if current == 0 {
                    diff = "\nРазница\n" + String(format: "%.0f", (keepers[0].Score - keepers.first(where: {k in return k.Participant.Country == target})!.Score)) + " баллов"
                }
                
                return "Телеголосование:\n\n" + (vote?.description ?? "?") + " баллов \n\n" + (song ?? "-") + diff
            }
            else {
                return "Победитель\n" + (keepers.count > 0 ? keepers[0].Participant.Song : "-")
            }
        }
    }
    
    var popover: some View {
        VStack{
            ForEach($resul, id: \.self){ i in
                    HStack{
                        Text(scoreboard.participants[i.wrappedValue].Performer).font(.system(size: 9))
                        Spacer()
                        if (i.wrappedValue < resu.count){
                            Text(resu[i.wrappedValue].description).font(.system(size: 12))
                        }
                    }
                }
            let sum = resu.reduce(0, +)
            Text("Всего голосов: \(sum)").font(.system(size: 24))
            
        }.padding(8)
    }
    
    var body: some View {
        HStack{
            ZStack{
                HStack(spacing: 0){
                    if isWin {
                        ForEach(0..<12) {index in
                            Bar(index: index, win: true)
                        }
                        ForEach(0..<12) {index in
                            Bar(index: 12-index, win: true)
                        }
                    }
                    else {
                        ForEach(0..<12) {index in
                            Bar(index: index, win: false)
                        }
                        ForEach(0..<12) {index in
                            Bar(index: 12-index, win: false)
                        }
                    }
                }.opacity(0.58)
                VStack {
                    if keepers.count > 13 && keepers.count < 27 {
                        HStack{
                            LazyHGrid(rows: getRows()) {
                                ForEach(keepers) { keeper in
                                    ScorePanel(keeper: keeper, isNationVisible: scoreboard.isNationVisible)
                                }
                            }
                            .frame(height: 600)
                            HStack{
                                Text("")
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
                }
                .padding(100)
            }
            VStack{
                Text(getHint())
                    .font(.system(size: 28))
                    .bold()
                    .padding(8)
                popover.frame(width: 290)
                    .padding(8)
                Button (action: {
                    televoting()
                }) {
                    Label("Голосование", systemImage: "square.and.arrow.down")
                        .font(.system(size: 16))
                        .padding(8)
                }
                .padding(8)
                Button (action: {
                    startVoting()
                }) {
                    Label("Старт", systemImage: "play")
                        .font(.system(size: 16))
                        .padding(8)
                }
                .padding(8)
                Button (action: {
                    stopVoting()
                }) {
                    Label("Стоп", systemImage: "stop")
                        .font(.system(size: 16))
                        .padding(8)
                }
                .padding(8)
            }
            
        }
            .toolbar {
                ToolbarItem {
                    Button (action: {
                        if keepers.isEmpty {
                            return
                        }
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
                ToolbarItem {
                    Text("Сброс")
                }
                ToolbarItem{
                    Button (action: {
                        if !keepers.isEmpty {
                            keepers.removeAll()
                            return
                        }
                        if !scoreboard.participants.isEmpty {
                            setupKeepers()
                            if scoreboard.order.isEmpty{
                                scoreboard.order = scoreboard.countries
                            }
                        }
                    }) {
                        Label("Сброс", systemImage: "gobackward")
                    }
                }
            }
        
    }
    
    private func setupKeepers() {
        current = 0
        voting = .Jury
        isMainMarkGiven = false;
        isRemainMarkGiven = false;
        keepers.removeAll()
        for participant in scoreboard.participants {
            let keeper = ScoreKeeper(Participant: participant, Score: 0)
            keepers.append(keeper)
        }
        playSound(name: "start")
        isWin = false
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
                //playSound(name: "37")
            }
            else if isRemainMarkGiven && !isMainMarkGiven {
                let keeper = keepers.first(where: { keeper in
                    return keeper.Participant.Country == marks.last?.To
                })
                keeper!.FromJury += Double(marks.last!.Value)
                playSound(name: "highmark")
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
                playSound(name: "mark2")
                isRemainMarkGiven = true
                updateKeepers()
            }
        }
        if current == scoreboard.order.count {
            voting = .Public
            current -= 1
            playSound(name: "to_televote")
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
            if (sum < 100) {
                playSound(name: "score2")
            }
            else {
                playSound(name: "highscore")
            }
            updateKeepers()
        }
        //todo
        if current == -1 {
            playSound(name: "win")
            isWin = true;
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
        let keeperBefore = keepers[0];
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            playSound(name: "sort")
            withAnimation {
                keepers.sort(by: {lhs, rhs in return lhs.Score > rhs.Score})
            }
            if voting == .Public && keeperBefore != keepers[0] {
                playSound(name: "leader");
            }
        })
        
    }
}

#Preview {
    VotingSceneView()
        .environment(Scoreboard(template: true))
}
