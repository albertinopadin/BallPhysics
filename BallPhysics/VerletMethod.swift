//
//  VerletMethod.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/11/24.
//

import CoreGraphics
import MetalKit

class VerletMethod: IntegrationMethod {
    static func updateGravity(deltaTime: CGFloat, gravity: CGFloat, bounds: CGRect, balls: inout [Ball]) {
        for i in 0..<balls.count {
            let prevBallPos = balls[i].position
            let prevBallVelo = balls[i].velocity
            let prevBallAcc = balls[i].acceleration
            
            let ballPos = CGPoint(x: prevBallPos.x + prevBallVelo.dx * deltaTime + prevBallAcc.dx * (deltaTime * deltaTime * 0.5),
                                  y: prevBallPos.y + prevBallVelo.dy * deltaTime + prevBallAcc.dy * (deltaTime * deltaTime * 0.5))
            
            let ballAcc = CGVector(dx: prevBallAcc.dx,
                                   dy: prevBallAcc.dy + gravity)
            
            let ballVelo = CGVector(dx: prevBallVelo.dx + (prevBallAcc.dx + ballAcc.dx)*(deltaTime*0.5),
                                    dy: prevBallVelo.dy + (prevBallAcc.dy + ballAcc.dy)*(deltaTime*0.5))
            
            balls[i].setPosition(ballPos)
            balls[i].setVelocity(ballVelo)
            balls[i].setAcceleration(ballAcc)
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
                        let biAcc = bi.acceleration - collisionVector
                        let bjAcc = bj.acceleration + collisionVector
                        let biVelo = bi.velocity + (bi.acceleration + biAcc)*(deltaTime * 0.5)
                        let bjVelo = bj.velocity + (bj.acceleration + bjAcc)*(deltaTime * 0.5)
                        let biPos = CGPoint(x: bi.position.x + biVelo.dx * deltaTime + biAcc.dx * (deltaTime * deltaTime * 0.5),
                                            y: bi.position.y + biVelo.dy * deltaTime + biAcc.dy * (deltaTime * deltaTime * 0.5))
                        let bjPos = CGPoint(x: bj.position.x + bjVelo.dx * deltaTime + bjAcc.dx * (deltaTime * deltaTime * 0.5),
                                            y: bj.position.y + bjVelo.dy * deltaTime + bjAcc.dy * (deltaTime * deltaTime * 0.5))
                        
                        balls[i].setPosition(biPos)
                        balls[i].setVelocity(biVelo)
                        balls[i].setAcceleration(biAcc)
                        
                        balls[j].setPosition(bjPos)
                        balls[j].setVelocity(bjVelo)
                        balls[i].setAcceleration(bjAcc)
                    }
                }
            }
        }
    }
}
