//
//  ContentView.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/8/24.
//

import SwiftUI

var balls: [Ball] = {
    var bs = [Ball]()
    for _ in 0..<50 {
        let x = CGFloat.random(in: 0..<500)
        let y: CGFloat = .zero
        let position = CGPoint(x: x, y: y)
        bs.append(Ball(position: position, radius: 10))
    }
    return bs
}()

struct ContentView: View {
    @StateObject var physicsWorld = PhysicsWorld2D(balls: balls)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(physicsWorld.balls, id: \.self) { ball in
                    Circle()
                        .fill(.blue)
                        .frame(width: 10)
                        .position(ball.position)
                }
            }
            .padding()
            .onAppear() {
                let boundsSize = geometry.size
                Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { dt in
                    physicsWorld.update(deltaTime: dt.timeInterval,
                                        bounds: CGRect(origin: .zero,
                                                       size: boundsSize))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
