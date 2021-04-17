//
//  Utils.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-11.
//

import Foundation

class Utils{
    
    public static func Vector3Lerp(a: GLKVector3,b: GLKVector3,t: Float)->GLKVector3{
        let diff: GLKVector3 = GLKVector3Subtract(b, a)
        let change: GLKVector3 = GLKVector3MultiplyScalar(diff, t)
        return GLKVector3Add(a, diff);
    }
    
}
