//
//  GameObject.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-11.
//

import Foundation

// base class for gameobjects that run an updated behavior over time

class GameObject{
    
    // if this function returns zero, the viewcontroller removes the gameobject from the game
    func update(glesRenderer: Renderer, viewController: ViewController) -> Int{
        return 1;
    }
}
