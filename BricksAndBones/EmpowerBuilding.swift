//
//  EmpowerBuilding.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-05.
//

import Foundation

class EmpowerBuilding : Building {
    
    override init(posX:Int, posY:Int){
        super.init(posX: posX, posY: posY)
        
        selfValue = 1;
        type = "Normal"
        classification = "Influencer"
        relationValue = 2
        radius = 2
        influencedValue = 0
    }
}
