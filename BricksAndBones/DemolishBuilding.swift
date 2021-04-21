//
//  DemolishBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

class DemolishBuilding : Building {
    
    override init(posX:Int, posY:Int, modelBuildType:Int, modelInstanceID:Int){
        super.init(posX: posX, posY: posY, modelBuildType: modelBuildType, modelInstanceID: modelInstanceID)
        
        buildingName = "Demolish"
        selfValue = 0
        type = "Normal"
        classification = "Destroy"
        relationValue = 0
        radius = 1
        influencedValue = 0
        active = true;
    }
}
