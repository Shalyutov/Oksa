//
//  Bar.swift
//  PowerScore
//
//  Created by Андрей Шалютов on 10.02.2024.
//

import SwiftUI

struct Bar : View {
    @State private var animateGradient = 4.0
    @State public var index : Int
    @State public var win : Bool = false
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: win ? [.indigo, .yellow, .indigo] : [.indigo, .purple, .indigo],
                    startPoint: UnitPoint(x: CGFloat(0),
                                          y: CGFloat(-0.3*Double(index)+animateGradient)),
                    endPoint: UnitPoint(x: CGFloat(0),
                                        y: CGFloat(1.3+animateGradient)))
            )
            .frame(width: 50)
            .onAppear {
                withAnimation(
                    .linear(duration: 5.0)
                    .repeatForever(autoreverses: false)){
                    animateGradient = -2-0.3*Double(index)
                }
            }
    }
}

#Preview {
    HStack(spacing: 0){
        Bar(index: 1)
        Bar(index: 2)
        Bar(index: 3)
        Bar(index: 4)
        Bar(index: 3)
        Bar(index: 2)
        Bar(index: 1)
    }
}
