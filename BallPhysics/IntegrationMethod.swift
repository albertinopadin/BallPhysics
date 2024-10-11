//
//  IntegrationMethod.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/10/24.
//

import CoreGraphics

protocol IntegrationMethod {
    static func updateGravity(deltaTime: CGFloat, gravity: CGFloat, bounds: CGRect, balls: inout [Ball])
    static func updateCollisions(deltaTime: CGFloat, bounds: CGRect, balls: inout [Ball])
}
