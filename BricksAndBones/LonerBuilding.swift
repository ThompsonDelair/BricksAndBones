//
//  LonerBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

//building that earns points for itself but loses points for nearby buildings
class LonerBuilding : Building {
    
    override init(posX:Int, posY:Int, modelBuildType:Int, modelInstanceID:Int){
        super.init(posX: posX, posY: posY,
                   modelBuildType: modelBuildType, modelInstanceID: modelInstanceID)
        
        buildingName = "Loner"
        selfValue = 20
        type = "Normal"
        classification = "Normal"
        relationValue = -5
        radius = 3
        influencedValue = 0
        active = true
    }
}
