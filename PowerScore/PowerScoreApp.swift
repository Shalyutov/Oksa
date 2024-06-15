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

    @State private var scoreboard = Scoreboard.Aurora()
    
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
