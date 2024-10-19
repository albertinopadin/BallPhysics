//
//  BallView.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/17/24.
//

import SwiftUI

struct BallView: View {
    @StateObject var physicsWorld: PhysicsWorld2D
    var colorOnSpeed: Bool = false
    
    var body: some View {
        ForEach(physicsWorld.balls, id: \.self) { ball in
            if colorOnSpeed {
                let ballVelo = (ball.velocity.normalize(to: 1000).magnitude / 1000)
                Circle()
                    .fill(Color(hue: ballVelo, saturation: 1.0, brightness: 1.0, opacity: 1.0))
                    .frame(width: ballSize, height: ballSize)
                    .position(ball.position)
            } else {
                Circle()
                    .fill(ball.color)
                    .frame(width: ballSize, height: ballSize)
                    .position(ball.position)
            }
        }
    }
}
