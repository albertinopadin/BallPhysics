//
//  IntegrationMethod.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/10/24.
//

import CoreGraphics

protocol IntegrationMethod {
    static func step(deltaTime: CGFloat, gravity: CGFloat, scale: CGFloat, balls: inout [Ball])
}
