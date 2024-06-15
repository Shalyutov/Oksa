//
//  ScorePanel.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 07.02.2024.
//

import SwiftUI
import AnimateNumberText

struct ScorePanel: View {
    @State public var keeper : ScoreKeeper
    @State private var animateGradient = -2.0
    @State private var translation = 50
    @State private var opacity = 1.0
    @State private var pointsTranslation = 120.0
    @State private var color : Color = .white
    @State private var mark : Double = 0.0
    @State public var isNationVisible : Bool
    @State public var max : Double = 15
    
    private func getTitle() -> String {
        if (isNationVisible) {
            return keeper.Participant.Country.name
        }
        else {
            return keeper.Participant.Song
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(background())
                .onAppear {
                    animateGradient = -2.0
                    withAnimation(.linear(duration: 2.0)) {
                        animateGradient = 2
                    }
                }
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            HStack {
                if (isNationVisible){
                    CountryFlag(name: keeper.Participant.Country.name)
                        .frame(height: 40)
                }
                Text(getTitle())
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    .font(.custom("AvantGardeCTT", size: 20))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .offset(x: 0, y: CGFloat(translation))
                    .padding(8)
                    .opacity(opacity)
                    .onAppear{
                        opacity = 0.0
                        withAnimation(.easeOut(duration: 0.5)) {
                            translation = 0
                            opacity = 1.0
                        }
                    }
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(mark == max && !keeper.FromJury.isZero ? .yellow : .cyan)
                    Text("\(Int(mark))")
                        .font(.custom("AvantGardeCTT", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(8)
                }
                .offset(x: pointsTranslation)
                .frame(maxWidth: 50)
                AnimateNumberText(font: .custom("AvantGardeCTT", size: 20), weight: .bold, value: $keeper.Score, textColor: $color)
                    .offset(x: 0, y: CGFloat(translation))
                    .opacity(opacity)
                    .frame(width: 50)
            }
            
        }
        .frame(width: 430, height: 40)
        .clipped()
        .onChange(of: keeper.FromJury){ old, new in
            if new == 0 {
                return
            }
            mark = new - old
            pointsTranslation = 120.0
            withAnimation(.easeInOut(duration: 0.5)){
                pointsTranslation = 0.0
            }
            withAnimation(.easeInOut(duration: 0.5).delay(4.0)){
                pointsTranslation = 120.0
            }
            withAnimation(.linear(duration: 1.0).delay(2.0)){
                keeper.Score += mark
            }
            withAnimation(.linear(duration: 1.0).delay(7.0)){
                keeper.FromJury = 0
            }
            animateGradient = -2.0
            withAnimation(.linear(duration: 2.0)) {
                animateGradient = 2
            }
        }
        .onChange(of: keeper.FromPublic){ old, new in
            mark = new
            pointsTranslation = 120.0
            withAnimation(.easeInOut(duration: 0.5)){
                pointsTranslation = 0.0
            }
            withAnimation(.easeInOut(duration: 0.5).delay(4.0)){
                pointsTranslation = 120.0
            }
            withAnimation(.linear(duration: 1.0).delay(2.0)){
                keeper.Score += mark
            }
            animateGradient = -2.0
            withAnimation(.linear(duration: 2.0)) {
                animateGradient = 2
            }
        }
        
    }
    private func background() -> LinearGradient {
        if keeper.FromPublic < 0 {
            if keeper.FromJury >= 0 {
                if keeper.FromJury == max {
                    return LinearGradient(colors: [.yellow], startPoint: UnitPoint(x: CGFloat(-1.0+animateGradient), y: 0), endPoint: UnitPoint(x: CGFloat(2.0+animateGradient), y: 0))
                }
                else {
                    return LinearGradient(colors: [.indigo, .cyan,  .blue, .mint, .clear], startPoint: UnitPoint(x: CGFloat(-1.0+animateGradient), y: 0), endPoint: UnitPoint(x: CGFloat(2.0+animateGradient), y: 0))
                }
            }
            else {
                return LinearGradient(colors: [.indigo, .cyan,  .blue, .mint, .clear], startPoint: UnitPoint(x: CGFloat(-1.0+animateGradient), y: 0), endPoint: UnitPoint(x: CGFloat(2.0+animateGradient), y: 0))
            }
        }
        else {
            return LinearGradient(colors: [.cyan,  .blue], startPoint: UnitPoint(x: CGFloat(-1.0+animateGradient), y: 0), endPoint: UnitPoint(x: CGFloat(1.0+animateGradient), y: 0))
        }
    }
}

#Preview {
    ScorePanel(keeper: 
                ScoreKeeper(
                    Participant:
                        Participant(
                            Number: 0,
                            Song: "Песня",
                            Performer: "String",
                            Country: Country(name: "Россия")), Score: 100), 
               isNationVisible: false)
}
