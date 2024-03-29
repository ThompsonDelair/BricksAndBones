//
//  File.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-21.
//

import Foundation

// this gameobject will continuously rotate its target over time for all eternity

class Rotator : GameObject{
    
    public var type:Int;
    public var id:Int;
    public var rotate: GLKVector3;
    public var speed: Float;
    
    init(type:Int, id:Int, rotate: GLKVector3, speed: Float){
        self.type = type;
        self.id = id;
        self.rotate = rotate;
        self.speed = speed;
    }
    
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
        
        let baseRot = glesRenderer.getInstanceRot(Int32(type), instance: Int32(id))
        let change = GLKVector3MultiplyScalar(rotate, speed * glesRenderer.deltaTime)
                
        glesRenderer.setInstanceRotation(Int32(type), instance: Int32(id), rotation: GLKVector3Add(baseRot, change));
        
        return 1
    }
    
}
