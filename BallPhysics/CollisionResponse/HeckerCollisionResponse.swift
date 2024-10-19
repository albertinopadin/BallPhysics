//
//  HeckerCollisionResponse.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/17/24.
//

// From https://www.chrishecker.com/images/e/e7/Gdmphys3.pdf
// and: https://www.youtube.com/watch?v=vQO_hPOE-1Y

import CoreGraphics
import simd

let X_AXIS: float2 = [1, 0]
let Y_AXIS: float2 = [0, 1]

final class HeckerCollisionResponse {
    static func resolveCollisions(deltaTime: CGFloat, scale: CGFloat, balls: inout [Ball]) {
        for a in 0..<balls.count {
            for b in 0..<balls.count {
                if a != b {
                    let ballA = balls[a]
                    let ballB = balls[b]
                    
                    if PhysicsWorld2D.collided(ballA: ballA, ballB: ballB) {
                        let collisionVector = PhysicsWorld2D.getCollisionVector(ballA.position, ballB.position)
                        
                        let penetrationMagnitude = ballA.radius + ballB.radius - collisionVector.magnitude
                        let collisionNormal = collisionVector.normalize()
                        balls[a].position += collisionNormal * (penetrationMagnitude / 2)
                        balls[b].position -= collisionNormal * (penetrationMagnitude / 2)
                        
                        let relativeVelo = ballA.velocity - ballB.velocity
                        let e = min(ballA.restitution, ballB.restitution)
                        var j = -(1 + e) * CGFloat(dot(relativeVelo.toSIMD(), collisionNormal.toSIMD()))
                        j /= ((1.0 / ballA.mass) + (1.0 / ballB.mass))
                        
                        let ballADeltaVelo = j / ballA.mass * collisionNormal
                        let ballBDeltaVelo = j / ballB.mass * collisionNormal
                        
                        balls[a].velocity += ballADeltaVelo.magnitude > 1.0 ? ballADeltaVelo : .zero
                        balls[b].velocity -= ballBDeltaVelo.magnitude > 1.0 ? ballBDeltaVelo : .zero
                    }
                }
            }
        }
    }
    
    static func resolveBoundary(bounds: CGRect, boundRestitution: CGFloat, balls: inout [Ball]) {
        for i in 0..<balls.count {
            let ballPos = balls[i].position
            let ballRadius = balls[i].radius
            let ballRestitution = balls[i].restitution
            let ballVelo = balls[i].velocity
            let ballMass = balls[i].mass
            
            let hitFloor: Bool = ballPos.y + ballRadius >= bounds.height
            let hitCeiling: Bool = ballPos.y - ballRadius <= 0
            
            let hitRightWall: Bool = ballPos.x + ballRadius >= bounds.width
            let hitLeftWall: Bool = ballPos.x - ballRadius <= 0
            
            if (hitFloor && balls[i].velocity.dy > 0) || (hitCeiling  && balls[i].velocity.dy <= 0) {
                balls[i].acceleration = CGVector(dx: balls[i].acceleration.dx,
                                                 dy: 0)
                
                let boundVector = hitFloor ? Y_AXIS : -Y_AXIS
                let e = min(ballRestitution, boundRestitution)
                var j = -(1 + e) * CGFloat(dot(ballVelo.toSIMD(), boundVector))
                j /= (1.0 / ballMass)
                let newVelo = j / ballMass * CGVector(dx: CGFloat(boundVector.x), dy: CGFloat(boundVector.y))
                balls[i].velocity += newVelo
                
                balls[i].position = CGPoint(x: ballPos.x,
                                            y: ballPos.y + ballRadius >= bounds.height ? bounds.height - ballRadius : ballRadius)
            }
            
            if (hitRightWall && balls[i].velocity.dx > 0) || (hitLeftWall && balls[i].velocity.dx <= 0) {
                balls[i].acceleration = CGVector(dx: 0,
                                                 dy: balls[i].acceleration.dy)
                
                
                let boundVector = hitRightWall ? -X_AXIS : X_AXIS
                let e = min(ballRestitution, boundRestitution)
                var j = -(1 + e) * CGFloat(dot(ballVelo.toSIMD(), boundVector))
                j /= (1.0 / ballMass)
                let newVelo = j / ballMass * CGVector(dx: CGFloat(boundVector.x), dy: CGFloat(boundVector.y))
                balls[i].velocity += newVelo
                
                balls[i].position = CGPoint(x: ballPos.x + ballRadius >= bounds.width ? bounds.width - ballRadius : ballRadius,
                                            y: ballPos.y)
                
            }
        }
    }
}
