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
        let result = GLKVector3Add(a, change)
        return result;
    }
    
    public static func EaseInQuart(t: Float)->Float{
        return t * t * t * t;
    }
    
    public static func EaseInExpo(t: Float)->Float{
        if(t == 0){
            return 0;
        }
        return powf(2, 10 * t - 10);
    }
}
