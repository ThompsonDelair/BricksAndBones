//
//  Building.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation


class Building{
    
    var posX, posY:Int; // position of building in grid
    
    
    var selfValue:Int; // value for placing this down
    var type:String; // Normal, Medieval, Tribal, Alternate
    var classification:String; // normal, buffer/debuffer/, replace, destroy
    var relationValue:Int; // value gain or loss
    var radius:Int; //detection radius
    var influencedValue:Int;
    
    init(posX:Int, posY:Int){
        self.posX = posX;
        self.posY = posY;
        
        selfValue = 1;
        type = "Normal"
        classification = "Normal"
        relationValue = 0
        radius = 1
        influencedValue = 0
    }
    
  
    
}
