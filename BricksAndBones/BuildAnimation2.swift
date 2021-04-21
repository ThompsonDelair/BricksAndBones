//
//  BuildAnimation2.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-19.
//

import Foundation

class BuildAnimation2: MoveAnimation{
    
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
        let currTime: Float = glesRenderer.currTime;
        //let elapsedTime: Float = glesRenderer.deltaTime;
        var t: Float = Float((currTime - startTime) / duration)
        if(t > 1.0){
            t = 1.0
        }
        
        t = Utils.EaseInExpo(t: t);
        
        let pos = Utils.Vector3Lerp(a: startPos, b: endPos, t: t)
        
        glesRenderer.setInstancePos(modelType, instance: instanceID, pos: pos)
        
        if(t >= 1.0){
            
            let color = GLKVector4Make(1.0,1.0,1.0,1.0)
            
            let ps: ParticleSystem = ParticleSystem(rootPos: endPos, modelType: Int(MOD_SPHERE.rawValue), color: color, count: 10)
            ps.velocityStartMin = GLKVector3Make(-1.0, 0.1, -1.0)
            ps.velocityStartMax = GLKVector3Make(1.0, 0.3, 1.0)
            ps.sizeStart = GLKVector3Make(0.2, 0.2, 0.2)
            ps.sizeEnd = GLKVector3Make(0.7, 0.7, 0.7)
            ps.color = GLKVector4Make(1.0, 1.0, 1.0, 1.0)
            ps.colorEnd = GLKVector4Make(1.0,1.0,1.0,0.0)
            viewController.gameObjects.append(ps)
            
            return 0
        } else {
            return 1;
        }
    }
}
