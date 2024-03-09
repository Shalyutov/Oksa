//
//  PowerScoreApp.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 24.01.2024.
//

import SwiftUI
import SwiftData

@main
struct PowerScoreApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            //Country.self, Participant.self, Vote.self, VoteOrder.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var scoreboard = Scoreboard(template: true)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.scoreboard, scoreboard)
        }
        Window("Табло", id: "voting") {
            VotingSceneView()
                .environment(\.scoreboard, scoreboard)
        }
    }
}
