//
//  Grid.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-03-02.
//

import Foundation

class Grid{
    
    //the length/width of the grid box
    var unitSize: Int;
   
    
    init(unitSize: Int){
        self.unitSize = unitSize;
    }
    
    func snapToGrid(x: Float, y: Float) -> (Int, Int){
        var newX = round(x)
        var newY = round(y)
        //print(" unitSize: \(unitSize)")
        
        var boundsX = getBounds(value: newX)
        var boundsY = getBounds(value: newY)
        
        
        var snappedX = roundToBounds(lowerBound:boundsX.0, upperBound:boundsX.1, value:x)
        var snappedY = roundToBounds(lowerBound:boundsY.0, upperBound:boundsY.1, value:y)
        
        return (Int(snappedX), Int(snappedY))
    }
    
    func snapToGrid(tuple:(Float, Float))->(Int, Int){
        return snapToGrid(x:tuple.0, y:tuple.1)
    }
    
    func roundToBounds(lowerBound: Float, upperBound: Float, value: Float) -> Float{
        
        var midpoint = (lowerBound + upperBound)/2;
        
        if( value >= midpoint){
            return upperBound
        } else {
            return lowerBound
        }
        
    }
    
    func getBounds(value: Float) -> (Float, Float){
        
        
        var lowerBoundMultiple = floor(value/Float(unitSize))
        var lowerBound = lowerBoundMultiple * Float(unitSize)
        var upperBound = lowerBound + Float(unitSize)
        
        return (lowerBound, upperBound)
    }
}
