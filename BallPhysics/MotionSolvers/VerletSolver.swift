//
//  VerletSolver.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/11/24.
//

import CoreGraphics

class VerletSolver: MotionSolver {
    static func step(deltaTime: CGFloat, gravity: CGFloat, scale: CGFloat, balls: inout [Ball]) {
        for i in 0..<balls.count {
            balls[i].acceleration = .zero
        }
        
        for i in 0..<balls.count {
            let ballPos = balls[i].position
            let ballVelo = balls[i].velocity
            let ballAcc = balls[i].acceleration
            
            let nBallPosEuler: CGPoint = ballPos + ballVelo * deltaTime
            let nBallPos: CGPoint = nBallPosEuler + 0.5 * ballAcc * (deltaTime * deltaTime)
            
            let veloDtHalf = ballVelo + 0.5 * ballAcc * deltaTime
            
            let newAcc = ballAcc + Self.applyForces(gravity: gravity, scale: scale)
            
            let nBallVelo = veloDtHalf + 0.5 * newAcc * deltaTime
            
            balls[i].position = nBallPos
            balls[i].velocity = nBallVelo
//            balls[i].acceleration = .zero
            balls[i].acceleration = newAcc
        }
    }
    
    static func applyForces(gravity: CGFloat, scale: CGFloat) -> CGVector {
        return CGVector(dx: 0, dy: gravity * scale)
    }
}
