//
//  Building.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation


class Building{
    
    var posX, posY:Int; // position of building in grid
    
    var buildingName:String;
    var selfValue:Int; // value for placing this down
    var type:String; // Normal, Medieval, Tribal, Alternate
    var classification:String; // normal, buffer/debuffer/, replace, destroy
    var relationValue:Int; // value gain or loss
    var radius:Int; //detection radius
    var influencedValue:Int; // value influenced by empower/debuff buildings
    var active:Bool; // determines if the building is real/to be rendered
    var modelBuildType:Int;
    var modelInstanceID:Int;
    
    
    init(posX:Int, posY:Int, modelBuildType:Int, modelInstanceID:Int){
        self.posX = posX;
        self.posY = posY;
        self.modelBuildType = modelBuildType;
        self.modelInstanceID = modelInstanceID;
        
        buildingName = "Building";
        selfValue = 1;
        type = "Normal"
        classification = "Normal"
        relationValue = 0
        radius = 1
        influencedValue = 0
        active = false;
    }
    
    convenience init(posX:Int, posY:Int){
        self.init(posX: posX, posY: posY, modelBuildType:1, modelInstanceID:1);
    }
    
  
    
}
