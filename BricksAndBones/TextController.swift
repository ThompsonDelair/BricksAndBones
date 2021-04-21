//
//  TextController.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-21.
//

import Foundation

class TextController: GameObject{
    
    var instances: [TypeInstance] = [TypeInstance]()
    var texts: [MyText] = [MyText]()
    
    
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
        
//        for ti in instances{
//            //let dat: ModelInstance = glesRenderer.getModelInstanceData(ti.type, instance: ti.instanceID)
//            var pos: GLKVector3 = glesRenderer.getInstancePos(ti.type, instance: ti.instanceID)
//            //pos.x = -pos.x;
//            //pos.z = -pos.z;
//            let camPos: GLKVector3 = glesRenderer.getCameraPos();
//            let matrix: GLKMatrix4 = GLKMatrix4MakeLookAt(pos.x, pos.y, pos.z, camPos.x * -1, camPos.y, camPos.z * -1, 0, 1, 0);
//            glesRenderer.setInstanceMatrix(ti.type, instance: ti.instanceID, matrix: matrix)
//            
//        }
        
        
        return 1;
    }
    
    
    public func clearText(glesRenderer: Renderer){
        for inst in instances{
            glesRenderer.deactivateModelInstance(inst.type, id: inst.instanceID)
        }
        instances = [TypeInstance]()
    }
    
    public func addNewText(text: MyText, glesRenderer: Renderer){
        texts.append(text)
        
        var pos: GLKVector3 = text.pos
        
        for char in text.text{
            var ti: TypeInstance = TypeInstance()
            
            ti.type = Int32(MOD_TEXT_5.rawValue)
            ti.instanceID = glesRenderer.createModelInstance(ti.type, pos: text.pos, rot: GLKVector3Make(0,0,0), scale: text.scale)
            
            pos = GLKVector3Add(pos, GLKVector3Make(text.spacing, 0, 0))
            
            instances.append(ti)
        }
    }
}

struct MyText {
    public var text: String;
    public var pos: GLKVector3;
    public var spacing: Float;
    public var scale: GLKVector3;
}
