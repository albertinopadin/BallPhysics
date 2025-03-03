//
//  ContentView.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/8/24.
//

import SwiftUI

let numBalls = 5
let ballSize: CGFloat = 15

var balls: [Ball] = {
    var bs = [Ball]()
    for _ in 0..<numBalls {
        let x = CGFloat.random(in: 0..<1200)
        let y = CGFloat.random(in: 10...100)
        let position = CGPoint(x: x, y: y)
        bs.append(Ball(mass: 1.0, position: position, radius: 10, color: colors.randomElement()!))
    }
    return bs
}()

var previousTime: UInt64 = 0

let screenSize = NSScreen.main!.frame

// This is very specific for my 16in Macbook:
let pointsPerInch: CGFloat = 113
let inchesPerMeter: CGFloat = 39.3701
let pointsPerMeter = pointsPerInch * inchesPerMeter

struct ContentView: View {
    @Environment(\.displayScale) var displayScale
    
    @StateObject var physicsWorld = PhysicsWorld2D(balls: balls,
                                                   updateType: .HeckerVerlet)
    @State var windowBounds: CGRect = .zero
    
    var body: some View {
//        SUIRendered2DView(physicsWorld: physicsWorld,
//                          windowBounds: windowBounds,
//                          displayScale: displayScale)
        
        CanvasRendered2DView(physicsWorld: physicsWorld,
                             windowBounds: windowBounds,
                             displayScale: displayScale)
    }
}

#Preview {
    ContentView()
}
