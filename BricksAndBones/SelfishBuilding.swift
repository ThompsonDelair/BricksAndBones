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
        
        
        selfValue = 10;
        type = "Normal"
        classification = "Normal"
        relationValue = 0
        radius = 0
        influencedValue = 0
        active = true;
        buildingName = "Selfish"
    }
    
    
}
