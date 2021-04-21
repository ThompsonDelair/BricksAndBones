//
//  ParticleSystem.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-19.
//

import Foundation

class ParticleSystem: GameObject{
    
    let vectorZero: GLKVector3 = GLKVector3Make(0, 0, 0)
    let vectorOne: GLKVector3 = GLKVector3Make(1, 1, 1)
    
    public var posStartMin: GLKVector3;
    public var posStartMax: GLKVector3;
    public var rootPos: GLKVector3;
    
    public var dirMin: GLKVector3;
    public var dirMax: GLKVector3;
    
    public var modelType: Int;
    public var color: GLKVector4;
    public var colorVariation: Float;
    
    public var sizeStart: GLKVector3;
    public var sizeEnd: GLKVector3;
    
    public var colorEnd: GLKVector4;
        
    public var count: Int;
    public var interval: Float;
    public var lastTime: Float;
    
    public var distMoved: Float;
    public var duration: Float;
    
    init(rootPos: GLKVector3, modelType: Int, color: GLKVector4, count: Int) {
        posStartMin = vectorZero;
        posStartMax = vectorZero;
        self.rootPos = rootPos;
        dirMin = vectorZero;
        dirMax = vectorZero;
        colorVariation = 0.3;
        self.modelType = modelType;
        self.color = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
        self.colorEnd = color;
        self.count = count;
        self.sizeStart = GLKVector3Make(1.0, 1.0, 1.0)
        self.sizeEnd = GLKVector3Make(1.0, 1.0, 1.0)
        self.interval = -1
        self.lastTime = 0;
        distMoved = 1
        duration = 2
    }
    
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
     
        if(interval <= 0 || glesRenderer.currTime - lastTime > interval){
            for i in 0...count{
                
                var x: Float = Float.random(in: dirMin.x...dirMax.x)
                var z: Float = Float.random(in: dirMin.z...dirMax.z)
                var y: Float = Float.random(in: dirMin.y...dirMax.y)
                            
                let dir: GLKVector3 = GLKVector3Make(x, y, z)
                
                let pos: GLKVector3 = rootPos
                
                let instanceID = glesRenderer.createModelInstance(Int32(modelType), pos: pos, rot: vectorOne, scale: sizeStart)
                
                let p: Particle = Particle(pos: pos, moveSpeed: distMoved, moveDir: dir, type: Int32(modelType), instanceID: Int32(instanceID), startTime: glesRenderer.currTime);
                
                p.startColor = color
                p.endColor = colorEnd
                
                p.startSize = sizeStart
                p.endSize = sizeEnd
                p.duration = duration
                
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
