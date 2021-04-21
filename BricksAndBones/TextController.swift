//
//  TextController.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-21.
//

import Foundation

// a game object used to render 3D score text
// currently only support numbers

class TextController: GameObject{
    
    var instances: [TypeInstance] = [TypeInstance]()
    var texts: [MyText] = [MyText]()
        
    override func update(glesRenderer: Renderer,viewController: ViewController) -> Int{
        // this object wil live forever
        // originally it was planned to have this gameobject update the text canvases to look at the camera, but an attempted implementation was not successful
        return 1;
    }
    
    // clear all text data
    public func clearText(glesRenderer: Renderer){
        for inst in instances{
            glesRenderer.deactivateModelInstance(inst.type, id: inst.instanceID)
        }
        instances = [TypeInstance]()
    }
    
    // add a new text item
    // creates the relevant letter canvas models per string character
    public func addNewText(text: MyText, glesRenderer: Renderer){
        texts.append(text)
        
        var pos: GLKVector3 = text.pos
        
        let offset: GLKVector3 = GLKVector3Make(Float(text.text.count  - 1) * text.spacing * -0.5, 0, 0)
        pos = GLKVector3Add(pos, offset)
        
        var i: Int = 0;
        
        for char in text.text{
            var ti: TypeInstance = TypeInstance()
            
            if(char == "1"){
                ti.type = Int32(MOD_TEXT_1.rawValue)
            } else if(char == "0"){
                ti.type = Int32(MOD_TEXT_0.rawValue)
            } else if(char == "-"){
                ti.type = Int32(MOD_TEXT_MINUS.rawValue)
            } else if(char == "2"){
                ti.type = Int32(MOD_TEXT_2.rawValue)
            } else if(char == "3"){
                ti.type = Int32(MOD_TEXT_3.rawValue)
            }else if(char == "4"){
                ti.type = Int32(MOD_TEXT_4.rawValue)
            }else if(char == "5"){
                ti.type = Int32(MOD_TEXT_5.rawValue)
            }else if(char == "6"){
                ti.type = Int32(MOD_TEXT_6.rawValue)
            }else if(char == "7"){
                ti.type = Int32(MOD_TEXT_7.rawValue)
            }else if(char == "8"){
                ti.type = Int32(MOD_TEXT_8.rawValue)
            }else if(char == "9"){
                ti.type = Int32(MOD_TEXT_9.rawValue)
            }else {
                ti.type = Int32(MOD_TEXT_0.rawValue)
            }
  
            ti.instanceID = glesRenderer.createModelInstance(ti.type, pos: pos, rot: GLKVector3Make(0,0,0), scale: text.scale)
            
            glesRenderer.setInstanceColor(ti.type, instance: ti.instanceID, color: text.color)
            
            instances.append(ti)
            i += 1
        }
    }
}

struct MyText {
    public var text: String;
    public var pos: GLKVector3;
    public var spacing: Float;
    public var scale: GLKVector3;
    public var color: GLKVector4;
}
