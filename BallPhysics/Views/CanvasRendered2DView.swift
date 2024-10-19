//
//  CanvasRendered2DView.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/19/24.
//

import SwiftUI

struct CanvasRendered2DView: View {
    @StateObject var physicsWorld: PhysicsWorld2D
    @State var windowBounds: CGRect = .zero
    var displayScale: CGFloat = 1.0
    
    var body: some View {
        GroupBox {
            GeometryReader { geometry in
                TimelineView(.animation) { timelineContext in
                    Canvas(opaque: true, colorMode: .linear, rendersAsynchronously: false) { context, size in
                        for ball in physicsWorld.balls {
                            let ballRect = CGRect(x: ball.position.x - ball.radius / 2,
                                                  y: ball.position.y - ball.radius / 2,
                                                  width: ball.radius * 2,
                                                  height: ball.radius * 2)
                            let path = Circle().path(in: ballRect)
                            context.fill(path, with: .color(ball.color))
                        }
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
