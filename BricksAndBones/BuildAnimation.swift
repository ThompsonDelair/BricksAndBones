//
//  BuildAnimation.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-11.
//

import Foundation

class BuildAnimation: GameObject{
    
    public var modelType: Int32;
    public var instanceID: Int32;
    var starTime: Double;
    let duration = 1.0;
    let startPos: GLKVector3;
    let endPos: GLKVector3;
    
    init(modelType: Int32,instanceID: Int32, startPos: GLKVector3, endPos: GLKVector3) {
        self.modelType = modelType;
        self.instanceID = instanceID;
        starTime = CACurrentMediaTime();
        self.startPos = startPos
        self.endPos = endPos
    }
    
    override func update(deltaTime: Float, glesRenderer: Renderer) -> Int{
        let currTime: Double = CACurrentMediaTime()
        let elapsedTime = currTime - starTime
        var t: Float = Float(elapsedTime / duration)
        if(t > 1.0){
            t = 1.0
        }
        
        let pos = Utils.Vector3Lerp(a: startPos, b: endPos, t: t)
        
        glesRenderer.setInstancePos(modelType, instance: instanceID, pos: pos)
        
        if(t >= 1.0){
            return 0
        } else {
            return 1;
        }        
    }
}
