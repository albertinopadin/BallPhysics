//
//  EulerMethod.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/10/24.
//

import CoreGraphics

final class EulerMethod: IntegrationMethod {
    static func step(deltaTime: CGFloat, gravity: CGFloat, scale: CGFloat, balls: inout [Ball]) {
        Self.applyGravity(deltaTime: deltaTime, gravity: gravity, scale: scale, balls: &balls)
        Self.resolveCollisions(deltaTime: deltaTime, scale: scale, balls: &balls)
        Self.moveObjects(deltaTime: deltaTime, balls: &balls)
    }
    
    public static func applyGravity(deltaTime: CGFloat, gravity: CGFloat, scale: CGFloat, balls: inout [Ball]) {
        for i in 0..<balls.count {
            let ballVelo = CGVector(dx: balls[i].velocity.dx,
                                    dy: balls[i].velocity.dy + scale * gravity * deltaTime)
            
            balls[i].velocity = ballVelo
        }
    }
    
    static func resolveCollisions(deltaTime: CGFloat, scale: CGFloat, balls: inout [Ball]) {
        for i in 0..<balls.count {
            for j in 0..<balls.count {
                if i != j {
                    let bi = balls[i]
                    let bj = balls[j]
                    
                    if PhysicsWorld2D.collided(ballA: bi, ballB: bj) {
                        let collisionVector = PhysicsWorld2D.getCollisionVector(bi.position, bj.position)
                        let biVelo = bi.velocity + collisionVector * (scale / CGFloat(100))
                        let bjVelo = bj.velocity - collisionVector * (scale / CGFloat(100))
                        
                        balls[i].velocity = biVelo
                        balls[j].velocity = bjVelo
                    }
                }
            }
        }
    }
    
    static func moveObjects(deltaTime: CGFloat, balls: inout [Ball]) {
        for i in 0..<balls.count {
            let ballPos = CGPoint(x: balls[i].position.x + balls[i].velocity.dx * deltaTime,
                                  y: balls[i].position.y + balls[i].velocity.dy * deltaTime)
            
            balls[i].position = ballPos
        }
    }
}
