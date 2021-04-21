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
            return 0
        } else {
            return 1;
        }
    }
}
