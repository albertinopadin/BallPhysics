//
//  CGPoint+Extension.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/17/24.
//

import CoreGraphics

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    static func +=(lhs: inout CGPoint, rhs: CGVector) {
        lhs = CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    static func -=(lhs: inout CGPoint, rhs: CGVector) {
        lhs = CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }
}
