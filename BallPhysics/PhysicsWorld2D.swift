//
//  PhysicsWorld2D.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/8/24.
//

import Foundation
import CoreGraphics

public typealias float2 = SIMD2<Float>

class PhysicsWorld2D: ObservableObject {
    public static let gravity: CGFloat = 9.8  // Down direction is Positive
    
    @Published var balls: [Ball]
    
//    let physics = EulerMethod.self
    let physics = VerletMethod.self
    
    init(balls: [Ball]) {
        self.balls = balls
    }
    
    public func update(deltaTime: CGFloat, bounds: CGRect) {
        physics.updateGravity(deltaTime: deltaTime, gravity: Self.gravity, bounds: bounds, balls: &balls)
        physics.updateCollisions(deltaTime: deltaTime, bounds: bounds, balls: &balls)
        dampen(deltaTime: deltaTime)
        checkBallsInBoundary(bounds: bounds)
    }
    
    private func checkBallsInBoundary(bounds: CGRect) {
        for i in 0..<balls.count {
            if (balls[i].position.y >= bounds.height && balls[i].velocity.dy > 0) ||
                (balls[i].position.y <= 0 && balls[i].velocity.dy <= 0) {
                balls[i].setVelocity(CGVector(dx: balls[i].velocity.dx,
                                              dy: -balls[i].velocity.dy))
                balls[i].setPosition(CGPoint(x: balls[i].position.x,
                                             y: balls[i].position.y >= bounds.height ? bounds.height : 0))
            }
            
            if (balls[i].position.x >= bounds.width && balls[i].velocity.dx > 0) ||
                (balls[i].position.x <= 0 && balls[i].velocity.dx <= 0) {
                balls[i].setVelocity(CGVector(dx: -balls[i].velocity.dx,
                                              dy: balls[i].velocity.dy))
                balls[i].setPosition(CGPoint(x: balls[i].position.x >= bounds.width ? bounds.width : 0,
                                             y: balls[i].position.y))
            }
        }
    }
    
    private func dampen(deltaTime: CGFloat) {
        for i in 0..<balls.count {
//            if Self.getMagnitude(balls[i].velocity) > 500 {
//                balls[i].setVelocity(balls[i].velocity * 0.9)
//            }
            
            balls[i].setAcceleration(balls[i].acceleration * 0.99)
            
//            balls[i].setAcceleration(CGVector(dx: balls[i].acceleration.dx,
//                                              dy: balls[i].acceleration.dy + Self.gravity))
            
//            if balls[i].velocity.dy < 0 {
//                balls[i].setVelocity(balls[i].velocity * 0.99)
//            }
            
//            if balls[i].acceleration.dy < 0 {
//                balls[i].setAcceleration(balls[i].acceleration * 0.5)
//            }
            
//            balls[i].setAcceleration(CGVector(dx: balls[i].acceleration.dx,
//                                              dy: balls[i].acceleration.dy - 0.01))
        }
    }
    
    static func getDistance(_ pointA: CGPoint, _ pointB: CGPoint) -> CGFloat {
        let dx = pointA.x - pointB.x
        let dy = pointA.y - pointB.y
        return sqrt((pow(dx, 2) + pow(dy, 2)))
    }
    
    static func getCollisionVector(_ pointA: CGPoint, _ pointB: CGPoint) -> CGVector {
        let dx = pointA.x - pointB.x
        let dy = pointA.y - pointB.y
        return CGVector(dx: dx, dy: dy)
    }
}
