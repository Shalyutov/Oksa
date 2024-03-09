//
//  CountryEditor.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 31.01.2024.
//

import Foundation
import SwiftData
import SwiftUI

struct CountryEditor: View {
    @Environment(\.scoreboard) private var scoreboard
    @Environment(\.dismiss) private var dismiss
    
    let country: Country?
    
    private var title: String {
        country == nil ? "Новая страна" : "Редактирование страны"
    }
    
    @State private var name = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Название", text: $name)
            }
            .padding(16)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Сохранить") {
                    withAnimation {
                        save()
                        dismiss()
                    }
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Отменить", role: .cancel) {
                    dismiss()
                }
            }
        }
        .onAppear(){
            if let country {
                name = country.name
            }
        }
    }
    private func save(){
        if let country {
            country.name = name
        }
        else {
            let newCountry = Country(name: name)
            scoreboard.countries.append(newCountry)
        }
    }
}
