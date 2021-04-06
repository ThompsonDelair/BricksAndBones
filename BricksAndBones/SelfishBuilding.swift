//
//  SelfishBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

class SelfishBuilding : Building {
    
    override init(posX:Int, posY:Int){
        super.init(posX: posX, posY: posY)
        
       pointProps = pointDictionary(selfValue: 1, type: "Normal", classification: "Normal", relationValue: 0);
    }
}
