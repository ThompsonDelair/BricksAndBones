//
//  Particle.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-20.
//

import Foundation

// a game object that animates a single model move and change color and shape over time
// deactivates model when duration completes

class Particle: GameObject{
 
    public var moveDist: Float;
    public var moveDir: GLKVector3;
    public var position: GLKVector3;
    public var endPos: GLKVector3
    
    public var type: Int32;
    public var instanceID: Int32;
    
    public var startTime: Float;
    
    public var duration: Float;
    
    public var startColor: GLKVector4;
    public var endColor: GLKVector4;
    
    public var startSize: GLKVector3;
    public var endSize: GLKVector3;
    
    init(pos:GLKVector3, moveSpeed: Float, moveDir: GLKVector3, type: Int32, instanceID: Int32, startTime: Float){
        position = pos;
        self.moveDir = GLKVector3Normalize(moveDir);
        self.moveDist = moveSpeed;
        self.type = type;
        self.instanceID = instanceID;
        self.startTime = startTime;
        //self.startTime = startTime;
        duration = 2
        startColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0)
        endColor = GLKVector4Make(1.0,1.0,1.0,1.0)
        
        startSize = GLKVector3Make(1.0,1.0,1.0)
        endSize = GLKVector3Make(1.0,1.0,1.0)
        
        let change: GLKVector3 = GLKVector3MultiplyScalar(moveDir, moveSpeed)
        endPos = GLKVector3Add(change, position)
    }
    
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
   
        var t:Float = (glesRenderer.currTime - startTime) / duration
        
        if(t > 1.0){
            t = 1.0
        }
        
        t = Utils.EaseOutExpo(t: t)
        
        let l_color: GLKVector4 = Utils.Vector4Lerp(a: startColor, b: endColor, t: t)
        glesRenderer.setInstanceColor(type, instance: instanceID, color: l_color)
        
        let l_pos: GLKVector3 = Utils.Vector3Lerp(a: position, b: endPos, t: t)
        glesRenderer.setInstancePos(type, instance: instanceID, pos: l_pos)
        
        let l_size: GLKVector3 = Utils.Vector3Lerp(a: startSize, b: endSize, t: t)
        glesRenderer.setInstanceScale(type, instance: instanceID, scale: l_size)
        
        // if t == 1, we have compelted the duration of this particle's lifespan
        // it returned 0 to signal for itself to be removed from game
        // and signals for the model to be deactivated
        if(t == 1.0){
            glesRenderer.deactivateModelInstance(type, id: instanceID)
            return 0
        }
        
        return 1
    }
}
