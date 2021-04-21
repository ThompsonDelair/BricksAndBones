//
//  ParticleGroup.swift
//  BricksAndBones
//
//  Created by socas on 2021-04-08.
//

import Foundation

class ParticleGroup{
    var particles: [Particle] = [];
    var modelType: Int = 0;
    
    var start: Double = 0.0;
    var end: Double = 0.0;
    
    public func Update(){
        for particle in particles {
            // update particle
        }
    }
}

struct Particle{
    public var instID: Int32;
    public var moveDir: GLKVector2;
    public var speed: Float;
}
