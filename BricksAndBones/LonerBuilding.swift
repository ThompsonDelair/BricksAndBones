//
//  LonerBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

class LonerBuilding : Building {
    
    override init(posX:Int, posY:Int){
        super.init(posX: posX, posY: posY)
        
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
