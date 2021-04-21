//
//  DebuffBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation


//grants a debuff to nearby buildings that makes them grant less points
class DebuffBuilding : Building {
    
    override init(posX:Int, posY:Int, modelBuildType:Int, modelInstanceID:Int){
        super.init(posX: posX, posY: posY, modelBuildType: modelBuildType, modelInstanceID: modelInstanceID)
        
        buildingName = "Debuff"
        selfValue = 10
        type = "Normal"
        classification = "Influencer"
        relationValue = -2
        radius = 2
        influencedValue = 0
        active = true;
    }
}
