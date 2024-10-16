//
//  VerletMethod.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/11/24.
//

import CoreGraphics

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
}

class VerletMethod: IntegrationMethod {
    static func step(deltaTime: CGFloat, gravity: CGFloat, scale: CGFloat, balls: inout [Ball]) {
        for i in 0..<balls.count {
            balls[i].setAcceleration(.zero)
        }
        
        Self.resolveCollisions(deltaTime: deltaTime, scale: scale, balls: &balls)
        
        for i in 0..<balls.count {
            let ballPos = balls[i].position
            let ballVelo = balls[i].velocity
            let ballAcc = balls[i].acceleration
            
            let nBallPosEuler: CGPoint = ballPos + ballVelo * deltaTime
            let nBallPos: CGPoint = nBallPosEuler + 0.5 * ballAcc * (deltaTime * deltaTime)
            
            let veloDtHalf = ballVelo + 0.5 * ballAcc * deltaTime
            
            let newAcc = ballAcc + Self.applyForces(gravity: gravity, scale: scale)
            
            let nBallVelo = veloDtHalf + 0.5 * newAcc * deltaTime
            
            
            balls[i].setPosition(nBallPos)
            balls[i].setVelocity(nBallVelo)
            balls[i].setAcceleration(.zero)
        }
    }
    
    static func applyForces(gravity: CGFloat, scale: CGFloat) -> CGVector {
        return CGVector(dx: 0, dy: gravity * scale)
    }
    
    static func resolveCollisions(deltaTime: CGFloat, scale: CGFloat, balls: inout [Ball]) {
        for i in 0..<balls.count {
            for j in 0..<balls.count {
                if i != j {
                    let bi = balls[i]
                    let bj = balls[j]
                    
                    if PhysicsWorld2D.collided(ballA: bi, ballB: bj) {
                        let collisionVector = PhysicsWorld2D.getCollisionVector(bi.position, bj.position)
//                        let biAcc = bi.acceleration + collisionVector * (scale / CGFloat(10))
//                        let bjAcc = bj.acceleration - collisionVector * (scale / CGFloat(10))
                        let biAcc = bi.acceleration + collisionVector * scale * bi.restitution
                        let bjAcc = bj.acceleration - collisionVector * scale * bj.restitution
                        
                        balls[i].setAcceleration(biAcc)
                        balls[j].setAcceleration(bjAcc)
                    }
                }
            }
        }
    }
}
