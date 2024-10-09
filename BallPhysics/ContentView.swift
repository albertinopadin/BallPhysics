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

var timesPrintedBounds: Int = 0

struct ContentView: View {
    @StateObject var physicsWorld = PhysicsWorld2D(balls: balls)
    @State var windowBounds: CGRect = .zero
    
    var body: some View {
        GroupBox {
            GeometryReader { geometry in
                ZStack {
                    ForEach(physicsWorld.balls, id: \.self) { ball in
                        Circle()
                            .fill(.blue)
                            .frame(width: 10, height: 10)
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
            .background(.white)
            .border(.red)
            .padding(5)
        }
    }
}

#Preview {
    ContentView()
}
