//
//  SUIRendered2DView.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/19/24.
//

import SwiftUI

struct SUIRendered2DView: View {
    @StateObject var physicsWorld: PhysicsWorld2D
    @State var windowBounds: CGRect = .zero
    var displayScale: CGFloat = 1.0
    
    var body: some View {
        GroupBox {
            GeometryReader { geometry in
                ZStack {
                    BallView(physicsWorld: physicsWorld, colorOnSpeed: false)
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
