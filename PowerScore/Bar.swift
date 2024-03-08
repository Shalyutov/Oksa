//
//  Bar.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 10.02.2024.
//

import SwiftUI

struct Bar : View {
    @State private var animateGradient = 1.3
    @State public var index : Int
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(colors: [.blue, .yellow, .blue], startPoint: UnitPoint(x: CGFloat(0), y: CGFloat(-0.3+animateGradient)), endPoint: UnitPoint(x: CGFloat(0), y: CGFloat(1.3+animateGradient)))
            )
            .frame(width: 60)
            .onAppear {
                withAnimation(.linear(duration: 3.0-Double(index)*0.0999).delay(Double(index)*0.1).repeatForever(autoreverses: false)){
                    animateGradient = -1.3
                }
            }
    }
}

#Preview {
    Bar(index: 0)
}
