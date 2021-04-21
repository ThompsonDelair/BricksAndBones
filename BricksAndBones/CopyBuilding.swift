//
//  CopyBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

class CopyBuilding : Building {
    
    override init(posX:Int, posY:Int, modelBuildType:Int, modelInstanceID:Int){
        super.init(posX: posX, posY: posY,
                   modelBuildType: modelBuildType, modelInstanceID: modelInstanceID)
        
        buildingName = "Copy"
        selfValue = 5
        type = "Normal"
        classification = "Absorb"
        relationValue = 0
        radius = 0
        influencedValue = 0
        active = true;
    }
}
