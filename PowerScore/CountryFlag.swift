//
//  CountryFlag.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 05.02.2024.
//

import SwiftUI

struct CountryFlag: View {
    @State public var name : String
    var body: some View {
        let flags : [String: String] = ["Россия" : "Russia"]
        if let resolve = flags[name] {
            Image(resolve)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        else {
            Image(systemName: "flag")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview("Россия") {
    CountryFlag(name: "Россия")
}
#Preview("Нет флага") {
    CountryFlag(name: "")
}
