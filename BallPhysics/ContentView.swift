//
//  ContentView.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/8/24.
//

import SwiftUI

let numBalls = 50
let ballSize: CGFloat = 15

var balls: [Ball] = {
    var bs = [Ball]()
    for _ in 0..<numBalls {
        let x = CGFloat.random(in: 0..<500)
        let y: CGFloat = 1.0
        let position = CGPoint(x: x, y: y)
        bs.append(Ball(position: position, radius: 10))
    }
    return bs
}()

var timesPrintedBounds: Int = 0

struct ContentView: View {
    @StateObject var physicsWorld = PhysicsWorld2D(balls: balls)
    @State var windowBounds: CGRect = .zero
    
    var body: some View {
        GroupBox {
            GeometryReader { geometry in
                ZStack {
                    ForEach(physicsWorld.balls, id: \.self) { ball in
                        let ballVelo = (ball.velocity.normalize(to: 1000).magnitude / 1000)
                        Circle()
                            .fill(Color(hue: ballVelo, saturation: 1.0, brightness: 1.0, opacity: 1.0))
                            .frame(width: ballSize, height: ballSize)
                            .position(ball.position)
                    }
                }
                .onChange(of: geometry.size) { oldSize, newSize in
                    print("Window size changed, old: \(oldSize), new: \(newSize)")
                    windowBounds.size = newSize
                }
                .onAppear() {
                    if windowBounds == .zero {
                        windowBounds = CGRect(origin: .zero, size: geometry.size)
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { dt in
                        if timesPrintedBounds < 2 {
                            print("Bounds: \(windowBounds)")
                            timesPrintedBounds += 1
                        }
                        physicsWorld.update(deltaTime: dt.timeInterval,
                                            bounds: windowBounds)
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
