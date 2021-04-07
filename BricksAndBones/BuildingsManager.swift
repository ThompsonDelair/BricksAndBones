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
    
    init(buildingSize: Int){
        self.buildingSize = buildingSize;
        
        var firstBuilding :Building = Building(posX:0, posY:0);
        //initialize buildings
        buildingArray = Array(repeating: Array(repeating: firstBuilding , count:buildingSize), count: buildingSize)
    }
    
    // check if the position is in the array
    func checkPosition(xPos:Int, yPos:Int) ->Bool{
        if(xPos >= 0 && yPos <= buildingSize-1 && yPos >= 0 && yPos <= buildingSize-1){
            
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
    func addBuilding(buildingName:String, xPos:Int, yPos:Int)->Int{
        if(checkPosition(xPos: xPos, yPos: yPos)){
            
            switch buildingName {
            case "Selfish":
                buildingArray[yPos][xPos] = SelfishBuilding(posX: xPos, posY: yPos)
                return buildingArray[yPos][xPos].selfValue;
            case "Loner":
                buildingArray[yPos][xPos] = LonerBuilding(posX: xPos, posY: yPos)
                //iterate over buildings in radius
                return calcAllBuildingsWithinRadius(centerBuilding: buildingArray[yPos][xPos])
            case "Leader":
                buildingArray[yPos][xPos] = LeaderBuilding(posX: xPos, posY: yPos)
                return calcAllBuildingsWithinRadius(centerBuilding: buildingArray[yPos][xPos])
            case "Empower":
                buildingArray[yPos][xPos] = EmpowerBuilding(posX: xPos, posY: yPos)
                return calcAllBuildingsWithinRadius(centerBuilding: buildingArray[yPos][xPos])
            case "Copy":
                return calcAllBuildingsWithinRadius(centerBuilding: buildingArray[yPos][xPos])
            case "Demolish":
                print("implement removal of rendered object first")
                //buildingArray[yPos][xPos] = DemolishBuilding(posX: xPos, posY: yPos)
                //demolishBuildings(xPos:xPos, yPos:yPos)
            default:
                print("Building doesn't exist")
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
        )
        {
            var columnCounts = 0;
            //top half including middle
            for row in stride(from: centerBuilding.radius, through: 0, by: -1){
                //for column in -columnCounts...columnCounts{
                for column in stride(from: -columnCounts, through: columnCounts, by: 1){
                    //print(row != 0)
                    //print(column != 0)
                    //print(type(of:column))
                    if( !(row == 0 && column == 0)){
                        let indexRow = centerBuilding.posY-row
                        let indexCol = centerBuilding.posX+column
                        if(checkPosition(xPos:indexCol, yPos: indexRow)){
                            if(buildingArray[indexRow][indexCol].active){
                                totalPoints += calculatePointsBetweenBuildings(thisBuilding: centerBuilding, otherBuilding: buildingArray[indexRow][indexCol])
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
                            totalPoints += calculatePointsBetweenBuildings(thisBuilding: centerBuilding, otherBuilding: buildingArray[indexRow][indexCol])
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
    func calculatePointsBetweenBuildings(thisBuilding:Building, otherBuilding:Building)->Int{
        //assuming both buildings exist
        switch thisBuilding.classification {
        case "Normal":
            //suports selfish, loner, leader
            return thisBuilding.relationValue + otherBuilding.influencedValue;
        case "Influencer":
            //supports both influencers
            var returnPoints = otherBuilding.influencedValue
            otherBuilding.influencedValue = otherBuilding.influencedValue + thisBuilding.relationValue;
            return returnPoints
        //case "Destroy":
        //destroy adjacent buildings and put thisbuilding down where clicked not here tho
        //return 0;
        default:
            return 0;
        }
        
        return 0;
    }
    
    func demolishBuildings(xPos:Int, yPos:Int){
        //left building
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
    
    func calcPointsFromPositions(thisBuildingXPos:Int, thisBuildingYPos:Int, otherBuildingXPos:Int, otherBuildingYPos:Int)->Int{
        return calculatePointsBetweenBuildings(thisBuilding: buildingArray[thisBuildingYPos][thisBuildingXPos], otherBuilding: buildingArray[otherBuildingYPos][otherBuildingXPos])
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

}
