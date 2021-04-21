//
//  BuildAnimation.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-11.
//

import Foundation

// this animation moves a model from point A to point B over a fixed duration
// moves using an exponentional ease-in for smooth movement

class MoveAnimation: GameObject{
    
    public var modelType: Int32;
    public var instanceID: Int32;
    var startTime: Float;
    public let duration: Float = 0.75;
    let startPos: GLKVector3;
    let endPos: GLKVector3;
        
    init(modelType: Int32,instanceID: Int32, startPos: GLKVector3, endPos: GLKVector3, startTime: Float) {
        self.modelType = modelType;
        self.instanceID = instanceID;
        self.startTime = startTime;
        self.startPos = startPos
        self.endPos = endPos
    }
    
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
        let currTime: Float = glesRenderer.currTime;
        var t: Float = Float((currTime - startTime) / duration)
        if(t > 1.0){
            t = 1.0
        }
        
        t = Utils.EaseInExpo(t: t);
        
        let pos = Utils.Vector3Lerp(a: startPos, b: endPos, t: t)
        
        glesRenderer.setInstancePos(modelType, instance: instanceID, pos: pos)
        
        // if t > 1, then the animation is over, signal to remove this gameobject
        // ( note that this gameobject is not a model, the model does not get removed )
        if(t >= 1.0){
            return 0
        } else {
            return 1;
        }        
    }
}
