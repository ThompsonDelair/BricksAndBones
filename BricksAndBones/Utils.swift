//
//  Utils.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-11.
//

import Foundation

// A few useful utility scripts

class Utils{
    
    public static func Vector3Lerp(a: GLKVector3,b: GLKVector3,t: Float)->GLKVector3{
        let diff: GLKVector3 = GLKVector3Subtract(b, a)
        let change: GLKVector3 = GLKVector3MultiplyScalar(diff, t)
        let result = GLKVector3Add(a, change)
        return result;
    }
    
    public static func Vector4Lerp(a: GLKVector4, b: GLKVector4, t: Float)->GLKVector4{
        let diff: GLKVector4 = GLKVector4Subtract(b, a)
        let change: GLKVector4 = GLKVector4MultiplyScalar(diff, t)
        let result = GLKVector4Add(a, change)
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
    
    public static func EaseOutExpo(t: Float)->Float{
        if(t == 1){
            return 1;
        }
        return 1 - powf(2, -10 * t);        
    }
    
    public static func inOutQuart(t: Float)->Float{
        if(t < 0.5){
            return 8 * t * t * t * t
        }
        return 1 - powf(-2 * t + 2, 4) / 2
    }
}
