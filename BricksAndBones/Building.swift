//
//  Building.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation


struct pointDictionary{
    var selfValue:Int;
    var type:String; // Normal, Medieval, Tribal, Alternate
    var classification:String; // normal, buffer/debuffer/, replace, destroy
    var relationValue:Int;
}

class Building{
    
    var posX, posY:Int;
    var score:Int;
    
    var pointProps:pointDictionary;
    
    init(posX:Int, posY:Int){
        self.posX = posX;
        self.posY = posY;
        score = 0;
        
        pointProps = pointDictionary(selfValue: 1, type: "Normal", classification: "Normal", relationValue: 0);
    }
    
    func  getSelfValue() -> Int
    {
        return pointProps.selfValue;
    }
    
    
}
