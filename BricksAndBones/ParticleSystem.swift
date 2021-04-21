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
    
    public var velocityStartMin: GLKVector3;
    public var velocityStartMax: GLKVector3;
    
    public var modelType: Int;
    public var color: GLKVector4;
    public var colorVariation: Float;
    
    public var sizeStart: GLKVector3;
    public var sizeEnd: GLKVector3;
    
    public var colorEnd: GLKVector4;
    
    public var count: Int;
    
    init(rootPos: GLKVector3, modelType: Int, color: GLKVector4, count: Int) {
        posStartMin = vectorZero;
        posStartMax = vectorZero;
        self.rootPos = rootPos;
        velocityStartMin = vectorZero;
        velocityStartMax = vectorZero;
        colorVariation = 0.3;
        self.modelType = modelType;
        self.color = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
        self.colorEnd = color;
        self.count = count;
        self.sizeStart = GLKVector3Make(1.0, 1.0, 1.0)
        self.sizeEnd = GLKVector3Make(1.0, 1.0, 1.0)
        
    }
    
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
     
        for i in 0...count{
            
            var x: Float = Float.random(in: velocityStartMin.x...velocityStartMax.x)
            var z: Float = Float.random(in: velocityStartMin.z...velocityStartMax.z)
            var y: Float = Float.random(in: velocityStartMin.y...velocityStartMax.y)
                        
            let dir: GLKVector3 = GLKVector3Make(x, y, z)
            
            let pos: GLKVector3 = rootPos
            
            let instanceID = glesRenderer.createModelInstance(Int32(modelType), pos: pos, rot: vectorOne, scale: GLKVector3Make(0.3, 0.3, 0.3))
            
            let p: Particle = Particle(pos: pos, moveSpeed: 1.25, moveDir: dir, type: Int32(Int(MOD_SPHERE.rawValue)), instanceID: Int32(instanceID), startTime: glesRenderer.currTime);
            
            p.startColor = color
            p.endColor = colorEnd
            
            p.startSize = sizeStart
            p.endSize = sizeEnd
            
            viewController.gameObjects.append(p)
            
        }
        
        return 0;
    }
}
