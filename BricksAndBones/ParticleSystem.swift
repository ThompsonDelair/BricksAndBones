//
//  ParticleSystem.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-19.
//

import Foundation

class ParticleSystem: GameObject{
    
    let vectorZero: GLKVector3 = GLKVector3Make(0, 0, 0)
    
    public var posStartMin: GLKVector3;
    public var posStartMax: GLKVector3;
    public var rootPos: GLKVector3;
    
    public var velocityStartMin: GLKVector3;
    public var velocityStartMax: GLKVector3;
    
    public var modelType: Int;
    public var color: GLKVector4;
    public var colorVariation: Float;
    
    public var count: Int;
    
    init(rootPos: GLKVector3, modelType: Int, color: GLKVector4, count: Int) {
        posStartMin = vectorZero;
        posStartMax = vectorZero;
        self.rootPos = rootPos;
        velocityStartMin = vectorZero;
        velocityStartMax = vectorZero;
        colorVariation = 0.3;
        self.modelType = modelType;
        self.color = color;
        self.count = count;
    }
    
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
     
        for i in 0...count{
            
        }
        
        return 1;
    }
}
