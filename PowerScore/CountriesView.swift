//
//  CountryView.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 27.01.2024.
//

import SwiftUI
import SwiftData

struct CountriesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var countries: [Country]
    @State private var country : String = ""
    @State private var selected : Country?
    
    var body: some View {
        VStack {
            List(countries, selection: $selected) { country in
                Text(country.name)
            }
            
            HStack{
                TextField("", text: $country)
                Button(action: addCountry){
                    Label("Добавить", systemImage: "plus")
                }
                .labelStyle(.iconOnly)
            }
        }
        .padding(8)
    }
    private func addCountry(){
        withAnimation {
            let newCountry = Country(name: country)
            modelContext.insert(newCountry)
        }
    }
    private func deleteCountries(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(countries[index])
            }
        }
    }
}

#Preview {
    CountriesView()
        .modelContainer(for: Country.self, inMemory: true)
}
