//
//  Collision.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-05.
//

import GLKit

import Foundation

class Collision{
    
    static func CirclePolygonCollision(pos: GLKVector2,radius: Float,polygon: [GLKVector2])-> Bool{
        for i in 0 ... polygon.count{
            let pointA: GLKVector2 = polygon[i]
            let pointB: GLKVector2 = polygon[(i + 1) % polygon.count]
            let closestPoint: GLKVector2 = PointLineDistance(point: pos,lineA: pointA, lineB: pointB)
            let dist = GLKVector2Distance(closestPoint, pos)
            if(dist < radius){
                return true
            }
        }
        return false
    }
    
    static func PointLineDistance(point: GLKVector2, lineA: GLKVector2, lineB: GLKVector2)->GLKVector2{
        let ACx = point.x - lineA.x
        let ACy = point.y - lineA.y
        let ABx = lineB.x - lineA.x
        let ABy = lineB.y - lineA.y
        let dot = ACx * ABx + ACy * ABy
        let AB_magSqrd = ABx * ABx + ABy * ABy
        var linePerpendicularPercent: Float = -1.0
        if(AB_magSqrd != 0){
            linePerpendicularPercent = dot / AB_magSqrd
        }
        var closestPoint: GLKVector2 = GLKVector2Make(0, 0)
        if(linePerpendicularPercent <= 0){
            // the closest point to the line is point A
            closestPoint.x = lineA.x
            closestPoint.y = lineA.y
        } else if(linePerpendicularPercent >= 1){
            // the closest point to the line is point B
            closestPoint.x = lineB.x
            closestPoint.y = lineB.y
        } else {
            // the closest point to the line is the perpendicular intersection point
            closestPoint.x = lineA.x + linePerpendicularPercent * ABx
            closestPoint.y = lineA.y + linePerpendicularPercent * ABy
        }
        return closestPoint
    }
    
    
}
