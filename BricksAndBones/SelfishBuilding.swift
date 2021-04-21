//
//  SelfishBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

//building that earns points for itself
class SelfishBuilding : Building {
    
    override init(posX:Int, posY:Int, modelBuildType:Int, modelInstanceID:Int){
        super.init(posX: posX, posY: posY,
                   modelBuildType: modelBuildType, modelInstanceID: modelInstanceID)
        
        
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
