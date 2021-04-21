//
//  StarburstSystem.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-21.
//

import Foundation

class StarburstSystem : ParticleSystem{
    
    var midPoint: GLKVector3 = GLKVector3Make(0, 1, 0);
    
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
     
        if(interval <= 0 || glesRenderer.currTime - lastTime > interval){
            for i in 0...count{
                
                var x: Float = Float.random(in: dirMin.x...dirMax.x)
                var z: Float = Float.random(in: dirMin.z...dirMax.z)
                var y: Float = Float.random(in: dirMin.y...dirMax.y)
                            
                let dir: GLKVector3 = GLKVector3Make(x, y, z)
                
                let pos: GLKVector3 = rootPos
                
                let instanceID = glesRenderer.createModelInstance(Int32(modelType), pos: pos, rot: vectorOne, scale: sizeStart)
                
                let p: StarburstParticle = StarburstParticle(pos: pos, moveSpeed: distMoved, moveDir: dir, type: Int32(modelType), instanceID: Int32(instanceID), startTime: glesRenderer.currTime);
                
                p.startColor = color
                p.endColor = colorEnd
                
                p.startSize = sizeStart
                p.endSize = sizeEnd
                p.duration = duration
                p.midPointHeight = midPoint
                viewController.gameObjects.append(p)
                
            }
            lastTime = glesRenderer.currTime
        }
        
        if(interval <= 0){
            return 0
        }
         
        return 1;
    }
}
