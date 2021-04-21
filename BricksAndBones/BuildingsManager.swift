//
//  BuildingsManager.swift
//  BricksAndBones
//
//  Created by Erik Ho on 2021-04-06.
//

import Foundation

//
class BuildingsManager{
    
    private var buildingArray=[[Building]]()
    private var buildingSize:Int;
    private var previewBuilding:Building;
    
    init(buildingSize: Int){
        self.buildingSize = buildingSize;
        
        var firstBuilding :Building = Building(posX:0, posY:0);
        //initialize buildings
        buildingArray = Array(repeating: Array(repeating: firstBuilding , count:buildingSize), count: buildingSize)
        previewBuilding = Building(posX:0,posY:0)
    }
    
    // check if the position is in the array
    func checkPosition(xPos:Int, yPos:Int) ->Bool{
        if(xPos >= 0 && xPos <= buildingSize-1 && yPos >= 0 && yPos <= buildingSize-1){
            
            return true;
        }
        //print(String(yPos) + " " + String(xPos))
        //print("Not within bounds of the array. Please check that it is within 0 and buildingSize")
        return false;
    }
    
    //call this to check if you can activate the copy cube
    func checkActive(xPos:Int, yPos:Int)->Bool{
        return buildingArray[yPos][xPos].active;
    }
    
    //call to add building to array
    //returns score from placing building down
    func addBuilding(buildingName:String, xPos:Int, yPos:Int, modelType:Int, modelID:Int)->Int{
        if(checkPosition(xPos: xPos, yPos: yPos)){
            
            switch buildingName {
            case "Selfish":
                buildingArray[yPos][xPos] = SelfishBuilding(posX: xPos, posY: yPos, modelBuildType: modelType, modelInstanceID: modelID)
                return buildingArray[yPos][xPos].selfValue;
            case "Loner":
                buildingArray[yPos][xPos] = LonerBuilding(posX: xPos, posY: yPos, modelBuildType: modelType, modelInstanceID: modelID)
                //iterate over buildings in radius
                return calcAllBuildingsWithinRadius(centerBuilding: buildingArray[yPos][xPos])
            case "Leader":
                buildingArray[yPos][xPos] = LeaderBuilding(posX: xPos, posY: yPos, modelBuildType: modelType, modelInstanceID: modelID)
                return calcAllBuildingsWithinRadius(centerBuilding: buildingArray[yPos][xPos])
            case "Empower":
                buildingArray[yPos][xPos] = EmpowerBuilding(posX: xPos, posY: yPos, modelBuildType: modelType, modelInstanceID: modelID)
                return calcAllBuildingsWithinRadius(centerBuilding: buildingArray[yPos][xPos])
            case "Debuff":
                buildingArray[yPos][xPos] = DebuffBuilding(posX: xPos, posY: yPos, modelBuildType: modelType, modelInstanceID: modelID);
                return calcAllBuildingsWithinRadius(centerBuilding: buildingArray[yPos][xPos])
            
            case "Copy":
                if(buildingArray[yPos][xPos].active){
                    return calcAllBuildingsWithinRadius(centerBuilding: buildingArray[yPos][xPos])
                }else{
                    print("there is no building here to activate")
                    return 0;
                }
                buildingArray[yPos][xPos] = CopyBuilding(posX: xPos, posY: yPos, modelBuildType: modelType,
                                                         modelInstanceID: modelID)
                return calcAllBuildingsWithinRadius(centerBuilding: buildingArray[yPos][xPos])
            default:
                print(String(buildingName) + " Building doesn't exist")
                return 0
            }
        }
        return 0
    }
    
    func calcAllBuildingsWithinRadius(centerBuilding:Building)->Int{
        if(centerBuilding.radius <= 0){
            print("radius was 0")
            return 0;
        }
        var totalPoints = 0
        if(centerBuilding.buildingName == "Loner"
            || centerBuilding.buildingName == "Leader"
            || centerBuilding.buildingName == "Empower"
            || centerBuilding.buildingName == "Debuff"
            || centerBuilding.buildingName == "Copy"
        )
        {
            var columnCounts = 0;
            //top half including middle
            for row in stride(from: centerBuilding.radius, through: 0, by: -1){
                //for column in -columnCounts...columnCounts{
                for column in stride(from: -columnCounts, through: columnCounts, by: 1){
                    if( !(row == 0 && column == 0)){
                        let indexRow = centerBuilding.posY-row
                        let indexCol = centerBuilding.posX+column
                        if(checkPosition(xPos:indexCol, yPos: indexRow)){
                            if(buildingArray[indexRow][indexCol].active){
                                totalPoints += calculatePointsBetweenBuildings(thisBuilding: centerBuilding, otherBuilding: buildingArray[indexRow][indexCol], isPreview: false)
                            }
                            
                            //print(String(indexRow) + " " + String(indexCol))
                        }
                    }
                }
                columnCounts+=1;
            }
            //bottom half excluding center row
            columnCounts = 0;
            for row in stride(from:centerBuilding.radius, to: 0, by: -1){
                for column in -columnCounts...columnCounts{
                    var indexRow = centerBuilding.posY+row
                    var indexCol = centerBuilding.posX+column
                    if(checkPosition(xPos:indexCol, yPos: indexRow)){
                        if(buildingArray[indexRow][indexCol].active){
                            totalPoints += calculatePointsBetweenBuildings(thisBuilding: centerBuilding, otherBuilding: buildingArray[indexRow][indexCol], isPreview: false)
                        }
                       
                        //print(String(indexRow) + " " + String(indexCol))
                    }
                }
                columnCounts+=1;
            }
        }
        return totalPoints + centerBuilding.selfValue
    }
    
    //calculates points
    func calculatePointsBetweenBuildings(thisBuilding:Building, otherBuilding:Building, isPreview:Bool)->Int{
        //assuming both buildings exist
        switch thisBuilding.classification {
        case "Normal":
            //suports selfish, loner, leader
            return thisBuilding.relationValue + otherBuilding.influencedValue;
        case "Influencer":
            //supports both influencers
            //print("This is an influencer")
            var returnPoints = otherBuilding.influencedValue
            if(!isPreview){
                otherBuilding.influencedValue = otherBuilding.influencedValue + thisBuilding.relationValue;
            }
            return returnPoints
        case "Absorb":
            if(!isPreview){
                thisBuilding.influencedValue+=otherBuilding.influencedValue;
            }
            return otherBuilding.influencedValue;
        default:
            print("classification doesnt exist")
            return 0;
        }
        
        return 0;
    }
    
    
    
    func demolishBuildings(xPos:Int, yPos:Int){
        //left buildinga
        if(checkPosition(xPos: xPos-1, yPos: yPos)){
            buildingArray[xPos-1][yPos] = Building(posX: xPos, posY: yPos)
        }
        //right building
        if(checkPosition(xPos: xPos+1, yPos: yPos)){
            buildingArray[xPos+1][yPos] = Building(posX: xPos, posY: yPos)
        }
        //above building
        if(checkPosition(xPos: xPos, yPos: yPos+1)){
            buildingArray[xPos][yPos+1] = Building(posX: xPos, posY: yPos)
        }
        //below building
        if(checkPosition(xPos: xPos, yPos: yPos-1)){
            buildingArray[xPos][yPos-1] = Building(posX: xPos, posY: yPos)
        }
    }
    
    func getModelID(posX:Int, posY:Int)->Int32{
        return Int32(buildingArray[posY][posX].modelInstanceID);
    }
    
    func getModelType(posX:Int, posY:Int)->Int32{
        return Int32(buildingArray[posY][posX].modelBuildType);
    }
    
    func calcPointsFromPreview(otherBuildingXPos:Int, otherBuildingYPos:Int)->Int{
        return calculatePointsBetweenBuildings(thisBuilding:previewBuilding, otherBuilding: buildingArray[otherBuildingYPos][otherBuildingXPos], isPreview:true)
    }
    
    func calcPointsFromPosition(thisBuildingXPos:Int, thisBuildingYPos:Int)->Int{
        return buildingArray[thisBuildingYPos][thisBuildingXPos].selfValue;
    }
    
    func getRadius(thisBuildingXPos:Int, thisBuildingYPos:Int)->Int{
        return buildingArray[thisBuildingYPos][thisBuildingXPos].radius;
    }
    
    func getActive(thisBuildingXPos:Int, thisBuildingYPos:Int)->Bool{
        return buildingArray[thisBuildingYPos][thisBuildingXPos].active;
    }
    
    func getRadiusFromPreview()->Int{
        return previewBuilding.radius
    }
    
    func setPreviewBuilding(buildingName:String, xPos:Int, yPos:Int)
    {
        switch buildingName {
        case "Selfish":
            previewBuilding = SelfishBuilding(posX: xPos, posY: yPos)
        case "Loner":
            previewBuilding = LonerBuilding(posX: xPos, posY: yPos)
        case "Leader":
            previewBuilding = LeaderBuilding(posX: xPos, posY: yPos)
        case "Empower":
            previewBuilding = EmpowerBuilding(posX: xPos, posY: yPos)
        case "Debuff":
            previewBuilding = DebuffBuilding(posX: xPos, posY: yPos)
        case "Copy":
            previewBuilding = CopyBuilding(posX: xPos, posY: yPos)
        default:
            print("building doesnt exist")
        }
    }

}
