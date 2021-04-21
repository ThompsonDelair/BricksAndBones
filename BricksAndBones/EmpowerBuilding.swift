//
//  EmpowerBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

//Increases the influenced values on buildings nearby
class EmpowerBuilding : Building {
    
    override init(posX:Int, posY:Int, modelBuildType:Int, modelInstanceID:Int){
        super.init(posX: posX, posY: posY,
                   modelBuildType:modelBuildType, modelInstanceID: modelInstanceID)
        
        buildingName = "Empower"
        selfValue = 0
        type = "Normal"
        classification = "Influencer"
        relationValue = 4
        radius = 2
        influencedValue = 0
        active = true;
    }
}
