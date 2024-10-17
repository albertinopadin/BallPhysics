//
//  Ball.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/8/24.
//

// Could just as easily be called 'Entity'

import SwiftUI

struct Ball: Hashable {
    public let id = UUID().uuidString
    
    public var mass: CGFloat
    public var position: CGPoint
    public var velocity: CGVector
    public var acceleration: CGVector
    public var radius: CGFloat
    public var color: Color
    public var restitution: CGFloat
    
    init(mass: CGFloat = 1.0,
         restitution: CGFloat = 0.95,
         position: CGPoint = .zero,
         velocity: CGVector = .zero,
         acceleration: CGVector = .zero,
         radius: CGFloat = .zero,
         color: Color = .blue) {
        self.mass = mass
        self.restitution = restitution
        self.position = position
        self.velocity = velocity
        self.acceleration = acceleration
        self.radius = radius
        self.color = color
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func ==(lhs: Ball, rhs: Ball) -> Bool {
        return lhs.id == rhs.id
    }
}
