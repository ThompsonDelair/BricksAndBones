//
//  StarburstParticle.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-21.
//

import Foundation

class StarburstParticle : Particle{
    
    var midPointHeight: GLKVector3 = GLKVector3Make(0, 1, 0);
    
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
   
        var t:Float = (glesRenderer.currTime - startTime) / duration
        
        if(t > 1.0){
            t = 1.0
        }
        
        t = Utils.EaseInQuart(t: t)
        
        let l_color: GLKVector4 = Utils.Vector4Lerp(a: startColor, b: endColor, t: t)
        glesRenderer.setInstanceColor(type, instance: instanceID, color: l_color)
        
        var midPoint: GLKVector3 = GLKVector3Subtract(endPos, position);
        midPoint = GLKVector3DivideScalar(midPoint, 2)
        midPoint = GLKVector3Add(midPoint, midPointHeight)
        midPoint = GLKVector3Add(midPoint, position)
        let l_posA: GLKVector3 = Utils.Vector3Lerp(a: position, b: midPoint, t: t)
        let l_posB: GLKVector3 = Utils.Vector3Lerp(a: midPoint, b: endPos, t: t)
        let l_posC: GLKVector3 = Utils.Vector3Lerp(a: l_posA, b: l_posB, t: t)
        glesRenderer.setInstancePos(type, instance: instanceID, pos: l_posC)
        
        let l_size: GLKVector3 = Utils.Vector3Lerp(a: startSize, b: endSize, t: t)
        glesRenderer.setInstanceScale(type, instance: instanceID, scale: l_size)
        
        if(t == 1.0){
            glesRenderer.deactivateModelInstance(type, id: instanceID)
            return 0
        }
        
        return 1
    }
}
