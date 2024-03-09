//
//  ContentView.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 24.01.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.scoreboard) private var scoreboard
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink {
                    CountriesView()
                } label: {
                    Label("Страны", systemImage: "globe")
                }
                NavigationLink {
                    ParticipantsView()
                } label: {
                    Label("Участники", systemImage: "person")
                }
                NavigationLink {
                    VotingView()
                } label: {
                    Label("Голосование", systemImage: "rectangle.stack")
                }
                NavigationLink {
                    OrderView()
                } label: {
                    Label("Порядок", systemImage: "list.clipboard")
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        openWindow(id: "voting")
                    }) {
                        Label("Запустить", systemImage: "play")
                    }
                }
                ToolbarItem {
                    Button(action: {
                        scoreboard.countries.removeAll()
                        scoreboard.participants.removeAll()
                        scoreboard.votes.removeAll()
                        scoreboard.order.removeAll()
                    }) {
                        Label("Очистить", systemImage: "trash")
                    }
                }
            }
        } detail: {
            
        }
    }
}

#Preview {
    ContentView()
}
