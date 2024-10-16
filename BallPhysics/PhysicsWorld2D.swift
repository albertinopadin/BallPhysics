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
    public static let restitution: CGFloat = 0.80
    
    @Published var counter: UInt64 = 0
    
//    @Published var balls: [Ball]
    var balls: [Ball]
    
//    let physics: IntegrationMethod.Type = EulerMethod.self
    let physics: IntegrationMethod.Type = VerletMethod.self
    
    var totalTime: CGFloat = 0
    var gotOneSec: Bool = false
    
    init(balls: [Ball]) {
        self.balls = balls
    }
    
    public func update(deltaTime: CGFloat, bounds: CGRect, scale: CGFloat) {
        physics.step(deltaTime: deltaTime, gravity: Self.gravity, scale: scale, balls: &balls)
        checkBallsInBoundary(bounds: bounds)
        counter += 1
    }
    
    private func checkBallsInBoundary(bounds: CGRect) {
        for i in 0..<balls.count {
            let ballPos = balls[i].position
            let ballRadius = balls[i].radius
            
            if ((ballPos.y + ballRadius) >= bounds.height && balls[i].velocity.dy > 0) ||
                ((ballPos.y + ballRadius) <= 0 && balls[i].velocity.dy <= 0) {
                balls[i].setAcceleration(CGVector(dx: balls[i].acceleration.dx,
                                                  dy: 0))
                balls[i].setVelocity(CGVector(dx: balls[i].velocity.dx,
                                              dy: -balls[i].velocity.dy * Self.restitution))
                balls[i].setPosition(CGPoint(x: ballPos.x,
                                             y: ballPos.y + ballRadius >= bounds.height ? bounds.height - ballRadius : ballRadius))
            }
            
            if (ballPos.x + ballRadius >= bounds.width && balls[i].velocity.dx > 0) ||
                (ballPos.x - ballRadius <= 0 && balls[i].velocity.dx <= 0) {
                balls[i].setAcceleration(CGVector(dx: 0,
                                                  dy: balls[i].acceleration.dy))
                balls[i].setVelocity(CGVector(dx: -balls[i].velocity.dx * Self.restitution,
                                              dy: balls[i].velocity.dy))
                balls[i].setPosition(CGPoint(x: ballPos.x + ballRadius >= bounds.width ? bounds.width - ballRadius : ballRadius,
                                             y: ballPos.y))
            }
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
    
    static func collided(ballA: Ball, ballB: Ball) -> Bool {
        return Self.getDistance(ballA.position, ballB.position) <= (ballA.radius + ballB.radius)
    }
    
    static func getAvgBallVelocity(balls: [Ball]) -> CGFloat {
        return balls.reduce(0, { $0 + $1.velocity.dy }) / CGFloat(balls.count)
    }
}
