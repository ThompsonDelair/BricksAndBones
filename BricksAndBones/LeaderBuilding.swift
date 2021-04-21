//
//  LeaderBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

//earns points for nearby buildings
class LeaderBuilding : Building {
    
    override init(posX:Int, posY:Int, modelBuildType:Int, modelInstanceID:Int){
        super.init(posX: posX, posY: posY,
                   modelBuildType: modelBuildType, modelInstanceID: modelInstanceID)
        
        buildingName = "Leader"
        selfValue = 0
        type = "Normal"
        classification = "Normal"
        relationValue = 5
        radius = 3
        influencedValue = 0
        active = true;
    }
}
