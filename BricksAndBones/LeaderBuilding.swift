//
//  LeaderBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

class LeaderBuilding : Building {
    
    override init(posX:Int, posY:Int){
        super.init(posX: posX, posY: posY)
        
        selfValue = 0;
        type = "Normal"
        classification = "Normal"
        relationValue = 5
        radius = 4
        influencedValue = 0
    }
}
