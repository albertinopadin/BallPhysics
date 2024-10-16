//
//  ContentView.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/8/24.
//

import SwiftUI

let colors: [Color] = [
    .accentColor,
    .blue,
    .black,
    .brown,
    .cyan,
    .gray,
    .green,
    .indigo,
    .mint,
    .orange,
    .pink,
    .purple,
    .primary,
    .red,
    .secondary,
    .teal,
    .white,
    .yellow
]

let numBalls = 10
let ballSize: CGFloat = 15

var balls: [Ball] = {
    var bs = [Ball]()
    for _ in 0..<numBalls {
        let x = CGFloat.random(in: 0..<500)
        let y = CGFloat.random(in: 20...100)
        let position = CGPoint(x: x, y: y)
        bs.append(Ball(position: position, radius: 10, color: colors.randomElement()!))
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
    
    @StateObject var physicsWorld = PhysicsWorld2D(balls: balls)
    @State var windowBounds: CGRect = .zero
    
    var body: some View {
        GroupBox {
            GeometryReader { geometry in
                ZStack {
//                    ForEach(physicsWorld.balls, id: \.self) { ball in
//                        let ballVelo = (ball.velocity.normalize(to: 1000).magnitude / 1000)
//                        Circle()
//                            .fill(Color(hue: ballVelo, saturation: 1.0, brightness: 1.0, opacity: 1.0))
//                            .frame(width: ballSize, height: ballSize)
//                            .position(ball.position)
//                    }
                    
                    ForEach(physicsWorld.balls, id: \.self) { ball in
                        Circle()
                            .fill(ball.color)
                            .frame(width: ballSize, height: ballSize)
                            .position(ball.position)
                    }
                }
                .onChange(of: geometry.size) { oldSize, newSize in
                    print("Window size changed, old: \(oldSize), new: \(newSize)")
                    windowBounds.size = newSize
                    print("Display Scale: \(displayScale)")
                    print("Screen Size: \(screenSize)")
                    print("Points per meter: \(pointsPerMeter)")
                }
                .onAppear() {
                    if windowBounds == .zero {
                        windowBounds = CGRect(origin: .zero, size: geometry.size)
                    }
                    
                    previousTime = DispatchTime.now().uptimeNanoseconds
                    
                    Timer.scheduledTimer(withTimeInterval: 0.008, repeats: true) { timer in
                        let currentTime = DispatchTime.now().uptimeNanoseconds
                        let deltaTime = Double(currentTime - previousTime) / 1e9
                        previousTime = currentTime
                        physicsWorld.update(deltaTime: deltaTime,
                                            bounds: windowBounds,
                                            scale: pointsPerMeter * 0.1)
                    }
                }
            }
            .background(Color.gray)
            .border(.red)
            .padding(5)
        }
    }
}

#Preview {
    ContentView()
}
