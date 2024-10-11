//
//  EulerMethod.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/10/24.
//

//import Foundation
import CoreGraphics

final class EulerMethod: IntegrationMethod {
    public static func updateGravity(deltaTime: CGFloat, gravity: CGFloat, bounds: CGRect, balls: inout [Ball]) {
        for i in 0..<balls.count {
            let ballVelo = CGVector(dx: balls[i].velocity.dx,
                                    dy: balls[i].velocity.dy + gravity)
            
            let ballPos = CGPoint(x: balls[i].position.x + ballVelo.dx * deltaTime,
                                  y: balls[i].position.y + ballVelo.dy * deltaTime)
            
            balls[i].setVelocity(ballVelo)
            balls[i].setPosition(ballPos)
        }
    }
    
    static func updateCollisions(deltaTime: CGFloat, bounds: CGRect, balls: inout [Ball]) {
        for i in 0..<balls.count {
            for j in 0..<balls.count {
                if i != j {
                    let bi = balls[i]
                    let bj = balls[j]
                    
                    if PhysicsWorld2D.getDistance(bi.position, bj.position) <= bi.radius + bj.radius {
                        let collisionVector = PhysicsWorld2D.getCollisionVector(bi.position, bj.position)
                        let biVelo = bi.velocity - collisionVector
                        let bjVelo = bj.velocity + collisionVector
//                        let biVelo = bi.velocity - collisionVector * 10
//                        let bjVelo = bj.velocity + collisionVector * 10
//                        let biVelo = bi.velocity - collisionVector * 2
//                        let bjVelo = bj.velocity + collisionVector * 2
                        let biPos = CGPoint(x: bi.position.x + biVelo.dx * deltaTime,
                                            y: bi.position.y + biVelo.dy * deltaTime)
                        let bjPos = CGPoint(x: bj.position.x + bjVelo.dx * deltaTime,
                                            y: bj.position.y + bjVelo.dy * deltaTime)
                        
                        balls[i].setVelocity(biVelo)
                        balls[i].setPosition(biPos)
                        
                        balls[j].setVelocity(bjVelo)
                        balls[j].setPosition(bjPos)
                    }
                }
            }
        }
    }
}
