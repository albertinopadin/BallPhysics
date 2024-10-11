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
    
    public var position: CGPoint
    public var velocity: CGVector
    public var acceleration: CGVector
    public var radius: CGFloat
    
    init(position: CGPoint = .zero, velocity: CGVector = .zero, acceleration: CGVector = .zero, radius: CGFloat = .zero) {
        self.position = position
        self.velocity = velocity
        self.acceleration = acceleration
        self.radius = radius
    }
    
    mutating func setPosition(_ position: CGPoint) {
        self.position = position
    }
    
    mutating func setVelocity(_ velocity: CGVector) {
        self.velocity = velocity
    }
    
    mutating func setAcceleration(_ acceleration: CGVector) {
        self.acceleration = acceleration
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func ==(lhs: Ball, rhs: Ball) -> Bool {
        return lhs.id == rhs.id
    }
}
