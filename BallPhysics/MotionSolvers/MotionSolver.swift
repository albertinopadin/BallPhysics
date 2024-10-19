//
//  MotionSolver.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/10/24.
//

import CoreGraphics

protocol MotionSolver {
    static func step(deltaTime: CGFloat, gravity: CGFloat, scale: CGFloat, balls: inout [Ball])
}
