//
//  CopyBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

class CopyBuilding : Building {
    
    override init(posX:Int, posY:Int){
        super.init(posX: posX, posY: posY)
        
        selfValue = 1;
        type = "Normal"
        classification = "Replace"
        relationValue = 0
        radius = 0
        influencedValue = 0
    }
}
