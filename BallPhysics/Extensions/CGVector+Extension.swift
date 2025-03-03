//
//  CGVector+Extension.swift
//  BallPhysics
//
//  Created by Albertino Padin on 10/11/24.
//

import CoreGraphics
import simd

extension CGVector {
    static func +=(lhs: inout CGVector, rhs: CGVector) {
        lhs = CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    static func -=(lhs: inout CGVector, rhs: CGVector) {
        lhs = CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    
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
    
    static func *(lhs: Int, rhs: CGVector) -> CGVector {
        return CGVector(dx: CGFloat(lhs) * rhs.dx, dy: CGFloat(lhs) * rhs.dy)
    }
    
    static func *(lhs: Double, rhs: CGVector) -> CGVector {
        return CGVector(dx: CGFloat(lhs) * rhs.dx, dy: CGFloat(lhs) * rhs.dy)
    }
    
    static func *(lhs: CGVector, rhs: Double) -> CGVector {
        return CGVector(dx: lhs.dx * CGFloat(rhs), dy: lhs.dy * CGFloat(rhs))
    }
    
    static func /(lhs: CGVector, rhs: Double) -> CGVector {
        return CGVector(dx: lhs.dx / CGFloat(rhs), dy: lhs.dy / CGFloat(rhs))
    }
    
    static prefix func -(v: CGVector) -> CGVector {
        return CGVector(dx: -v.dx, dy: -v.dy)
    }
    
    var magnitude: CGFloat {
        return sqrt((pow(self.dx, 2) + pow(self.dy, 2)))
    }
    
    func normalize(to aLength: CGFloat = 1.0) -> CGVector {
        let length = self.magnitude
        
        if length > aLength {
            return CGVector(dx: self.dx / length * aLength,
                            dy: self.dy / length * aLength)
        } else {
            return self
        }
    }
    
    func toSIMD() -> SIMD2<Float> {
        return [Float(self.dx), Float(self.dy)]
    }
}
