//
//  PhysicsWorld2D.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/8/24.
//

import CoreGraphics
import Foundation

public typealias float2 = SIMD2<Float>

extension CGVector {
    static func -(lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    
    static func +(lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    static func *(lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx * rhs.dx, dy: lhs.dy * rhs.dy)
    }
    
    static func *(lhs: CGVector, rhs: Int) -> CGVector {
        return CGVector(dx: lhs.dx * CGFloat(rhs), dy: lhs.dy * CGFloat(rhs))
    }
    
    static func *(lhs: CGVector, rhs: Double) -> CGVector {
        return CGVector(dx: lhs.dx * CGFloat(rhs), dy: lhs.dy * CGFloat(rhs))
    }
    
    static prefix func -(v: CGVector) -> CGVector {
        return CGVector(dx: -v.dx, dy: -v.dy)
    }
}

class PhysicsWorld2D: ObservableObject {
    public static let gravity: CGFloat = 9.8  // Down direction is Positive
    
    @Published var balls: [Ball]
    
    init(balls: [Ball]) {
        self.balls = balls
    }
    
    public func update(deltaTime: CGFloat, bounds: CGRect) {
        updateGravity(deltaTime: deltaTime, bounds: bounds)
        updateCollisions(deltaTime: deltaTime, bounds: bounds)
        dampen(deltaTime: deltaTime)
    }
    
    private func updateGravity(deltaTime: CGFloat, bounds: CGRect) {
        for i in 0..<balls.count {
            var ballVelo = CGVector(dx: balls[i].velocity.dx,
                                    dy: balls[i].velocity.dy + Self.gravity)
            
            var ballPos = CGPoint(x: balls[i].position.x + ballVelo.dx * deltaTime,
                                  y: balls[i].position.y + ballVelo.dy * deltaTime)
            
            if ballPos.y >= bounds.height || ballPos.y <= 0 {
                ballVelo.dy *= -1
                ballPos.y = ballPos.y >= bounds.height ? bounds.height : 0
            }
            
            balls[i].setVelocity(ballVelo)
            balls[i].setPosition(ballPos)
        }
    }
    
    private func updateCollisions(deltaTime: CGFloat, bounds: CGRect) {
        for i in 0..<balls.count {
            for j in 0..<balls.count {
                if i != j {
                    let bi = balls[i]
                    let bj = balls[j]
                    
                    if getDistance(bi.position, bj.position) <= bi.radius + bj.radius {
                        let collisionVector = getCollisionVector(bi.position, bj.position)
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
            if getMagnitude(balls[i].velocity) > 500 {
                balls[i].setVelocity(balls[i].velocity * 0.8)
            }
        }
    }
    
    private func getDistance(_ pointA: CGPoint, _ pointB: CGPoint) -> CGFloat {
        let dx = pointA.x - pointB.x
        let dy = pointA.y - pointB.y
        return sqrt((pow(dx, 2) + pow(dy, 2)))
    }
    
    private func getCollisionVector(_ pointA: CGPoint, _ pointB: CGPoint) -> CGVector {
        let dx = pointA.x - pointB.x
        let dy = pointA.y - pointB.y
        return CGVector(dx: dx, dy: dy)
    }
    
    private func getMagnitude(_ v: CGVector) -> CGFloat {
        return sqrt((pow(v.dx, 2) + pow(v.dy, 2)))
    }
}
