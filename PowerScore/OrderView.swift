//
//  OrderView.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 06.02.2024.
//

import SwiftUI
import SwiftData

struct OrderView: View {
    @Environment(\.scoreboard) private var scoreboard
    @State private var order: [Country] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Порядок голосования стран")
                .font(.title2)
            Text("Жюри")
            List {
                ForEach(scoreboard.order, id: \.self) { country in
                    HStack{
                        CountryFlag(name: country.name)
                            .frame(height: 20)
                            .padding(4)
                        Text(country.name)
                            .font(.title3)
                            .padding(4)
                    }
                }
                .onMove(perform: { indices, newOffset in
                    withAnimation {
                        scoreboard.order.move(fromOffsets: indices, toOffset: newOffset)
                    }
                })
            }
            .onAppear(perform: {
                getOrder()
            })
            HStack{
                Button(action: {scoreboard.order.shuffle()}){
                    Label("Перемешать", systemImage: "shuffle")
                }
            }
            Button(action: resetOrder){
                Label("Сброс", systemImage: "gobackward")
            }
        }
        .padding()
    }
    private func getOrder() {
        if scoreboard.order.isEmpty {
            scoreboard.order = scoreboard.countries
        }
    }
    private func resetOrder() {
        scoreboard.order.removeAll()
        scoreboard.order = scoreboard.countries
    }
}

#Preview {
    OrderView()
        .environment(Scoreboard())
}
