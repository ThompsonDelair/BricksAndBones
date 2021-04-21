//
//  ViewController.swift
//  BricksAndBones
//
//  Created by Thompson DeLair-Dobrovolny on 2021-02-20.
//

import GLKit

class ViewController: GLKViewController {
        
    private var context: EAGLContext?

    private var glesRenderer: Renderer!
    
    private var rotation: Float = 0.0

    private var typeLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    private var scoreLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    private var buildingsLeftLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:200, height: 21))
    private var scoreThresholdLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:200, height: 21))
    private var cameraLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    private var highScoreButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
    
    var score: Int = 0;
    
    var defaults = UserDefaults.standard;
    var highScore1: Int = 0;
    var highScore2: Int = 0;
    var highScore3: Int = 0;

    var gameGrid: Grid = Grid(unitSize: 2);
    var testManager = BuildingsManager(buildingSize: 10)
    
    var cursorType: Int32 = 1;
    var cursorInstanceId: Int32 = 0;
    
    var previewType: Int32 = 0;
    var previewID: Int32 = 0;
    
    private var currBuildType: Int32 = 0
    private let buildTypes: Int32 = 7
    
    var panStartScreen: CGPoint = CGPoint();
    var panX: CGFloat = 0.0
    var panY: CGFloat = 0.0
    var panTrack: GLKVector3 = GLKVector3Make(0, 0, 0);

    let cameraSpeed: CGFloat = 0.04;
    
    var buildingsLeft:Int = 0;
    let scoreThreshold:[Int] = [100, 250, 500, 1000, 2500];
    let buildingsEachLevel:[Int]=[5, 5, 6, 10, 10];
    var currentLevel:Int = 0;

    //var lastTime: Double = 0.0;
    
    var gameObjects: [GameObject] = []
        
    private var customView: UIView!
   
    let textController: TextController = TextController();
    //var buildingArray

    override func viewDidLoad() {
        super.viewDidLoad();
        // grab highscores
        //defaults.set(100, forKey: "HighScore1");
        //defaults.set(100, forKey: "HighScore2");
        //defaults.set(100, forKey: "HighScore3");
        // to do anything with OpenGL, you need to create an EAGLContext
        context = EAGLContext(api: .openGLES3)
        // specify that the rendering context is the one to use in the current thread
        EAGLContext.setCurrent(context);
        
        if let view = self.view as? GLKView, let context = context {
            view.context = context
            delegate = self as! GLKViewControllerDelegate
            glesRenderer = Renderer()
            glesRenderer.setup(view)
            glesRenderer.loadModels()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        view.addGestureRecognizer(pan)
        UpdateTypeText()

        typeLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        typeLabel.textColor = .black
        typeLabel.font = typeLabel.font.withSize(20)
        typeLabel.center = CGPoint(x:60, y:35)
        typeLabel.textAlignment = .center
        self.view.addSubview(typeLabel)
        
        buildingsLeftLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        buildingsLeftLabel.textColor = .black
        buildingsLeftLabel.font = typeLabel.font.withSize(15)
        buildingsLeftLabel.center = CGPoint(x:60, y:55)
        buildingsLeftLabel.textAlignment = .center
        self.view.addSubview(buildingsLeftLabel)
        
        scoreLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        scoreLabel.textColor = .black
        scoreLabel.font = scoreLabel.font.withSize(20)
        scoreLabel.center = CGPoint(x:220, y:35)
        scoreLabel.textAlignment = .center
        self.view.addSubview(scoreLabel)
        
        highScoreButton.backgroundColor = .green
        highScoreButton.setTitle("High Scores", for: .normal)
        highScoreButton.addTarget(self, action: #selector(loadViewIntoController), for: .touchUpInside)
        highScoreButton.center = CGPoint(x:220, y:500)
        highScoreButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(highScoreButton)
        
        //cursorType = 1;

        cursorInstanceId = glesRenderer.createModelInstance(Int32(cursorType),pos:GLKVector3Make(0, 0, 0),rot:GLKVector3Make(0, 0, 0),scale:GLKVector3Make(0.3, 0.3, 0.3))
        
        glesRenderer.createModelInstance(Int32(8),pos:GLKVector3Make(5, -1, 5),rot:GLKVector3Make(0, 0, 0),scale:GLKVector3Make(10, 1, 10))

        scoreThresholdLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        scoreThresholdLabel.textColor = .black
        scoreThresholdLabel.font = scoreLabel.font.withSize(15)
        scoreThresholdLabel.center = CGPoint(x:220, y:55)
        scoreThresholdLabel.textAlignment = .center
        self.view.addSubview(scoreThresholdLabel)
        
        cursorType = 1;
      
//        glesRenderer.createModelInstance(Int32(TEST_CUBE_GRAD.rawValue),pos:GLKVector3Make(5, -1, 5),rot:GLKVector3Make(0, 0, 0),scale:GLKVector3Make(10, 1, 10))
      
        initBuildingSelection()

        //print(testBuilding.selfValue)               
       
        //print("width" + String(UIScreen.main.bounds.size.width.description));
        //print("height" + String(UIScreen.main.bounds.size.height.description));
        //lastTime = CACurrentMediaTime();

        //plays background music on start
        glesRenderer.playBackgroundMusic();
        
        buildingsLeft = buildingsEachLevel[currentLevel];
        buildingsLeftLabel.text = "Left: " + String(buildingsLeft);
        
        scoreThresholdLabel.text = "Next: " +  String(scoreThreshold[currentLevel]);
        
        gameObjects.append(textController)
        
        
        let ps: ParticleSystem = ParticleSystem(rootPos: GLKVector3Make(0, 0, 0), modelType: Int(MOD_SPHERE.rawValue), color: GLKVector4Make(1.0, 0.66, 0, 1.0), count: 1 )
        ps.interval = 0.5
        ps.colorEnd = GLKVector4Make(1.0,1.0,1.0,0.2)
        ps.dirMin = GLKVector3Make(-0.2,0.9,-0.2)
        ps.dirMax = GLKVector3Make(0.2,1.0,0.2)
        ps.distMoved = 2.5
        ps.duration = 4
        gameObjects.append(ps)
        
    }
    
    func previewPoints(buildingName:String, xPos:Int, yPos:Int){
        
        textController.clearText(glesRenderer: glesRenderer)
        
        var columnCounts = 0;
        //top half including middle
        testManager.setPreviewBuilding(buildingName: buildingName, xPos: xPos, yPos: yPos)
        let radius = testManager.getRadiusFromPreview()
        for row in stride(from: radius, through: 0, by: -1){
            //for column in -columnCounts...columnCounts{
            for column in stride(from: -columnCounts, through: columnCounts, by: 1){
                //print(row != 0)
                //print(column != 0)
                //print(type(of:column))

                if(!(row == 0 && column == 0)){//dont check current buildings
                let indexRow = xPos-row
                let indexCol = yPos+column
                    if(testManager.checkPosition(xPos:indexCol, yPos: indexRow)){
                        if(testManager.getActive(thisBuildingXPos: indexRow, thisBuildingYPos: indexCol)){
                            var pointsToDisplay = testManager.calcPointsFromPreview(otherBuildingXPos:indexRow, otherBuildingYPos:indexCol)
                            //add display code here
                         
                            if(pointsToDisplay != 0){
                                let lx: Float = Float(indexRow) + 0.5
                                let lz: Float = Float(indexCol) + 0.5
                                let color: GLKVector4;
                                
                                if(pointsToDisplay > 0){
                                    color = GLKVector4Make(0.8, 1.0, 0.8, 1.0)
                                } else {
                                    color = GLKVector4Make(1.0, 0.8, 0.8, 1.0)
                                }
                                
                                var txt: MyText = MyText(
                                    text: String(pointsToDisplay), pos: GLKVector3Make(Float(lx),1.25,Float(lz)), spacing: 0.5, scale: GLKVector3Make(0.5, 1, 1), color: color
                                )
                               
                                textController.addNewText(text: txt, glesRenderer: glesRenderer)
                            }

    
                            //let screenPos: GLKVector2 = WorldPosToScreenPos(worldPos: GLKVector3Make(Float(lx),0,Float(lz)))
                            
                            //displayLabel(locX: CGFloat(screenPos.x), locY: CGFloat(screenPos.y * -1), text: "+" + String(pointsToDisplay), color: UIColor.cyan)

                        }
                    }
                }
            }
            columnCounts+=1;
        }
        //bottom half excluding center row
        columnCounts = 0;
        for row in stride(from:radius, to: 0, by: -1){
            for column in -columnCounts...columnCounts{
                let indexRow = xPos+row
                let indexCol = yPos+column
                if(testManager.checkPosition(xPos:indexCol, yPos: indexRow)){ // check other building if it is in grid
                    if(testManager.getActive(thisBuildingXPos: indexRow, thisBuildingYPos: indexCol)){ //check other building if it is an active building
                        var pointsToDisplay = testManager.calcPointsFromPreview(otherBuildingXPos:indexRow, otherBuildingYPos:indexCol)
                        //add display code here
                        
                        if(pointsToDisplay != 0){
                            let lx: Float = Float(indexRow) + 0.5
                            let lz: Float = Float(indexCol) + 0.5
                            let color: GLKVector4;
                            
                            if(pointsToDisplay > 0){
                                color = GLKVector4Make(0.8, 1.0, 0.8, 1.0)
                            } else {
                                color = GLKVector4Make(1.0, 0.8, 0.8, 1.0)
                            }
                            
                            var txt: MyText = MyText(
                                text: String(pointsToDisplay), pos: GLKVector3Make(Float(lx),1.25,Float(lz)), spacing: 0.5, scale: GLKVector3Make(0.5, 1, 1), color: color
                            )
                            

                           
                            textController.addNewText(text: txt, glesRenderer: glesRenderer)
                        }
                        
                        
                        //let screenPos: GLKVector2 = WorldPosToScreenPos(worldPos: GLKVector3Make(Float(lx),0,Float(lz)))
                        
                        //displayLabel(locX: CGFloat(screenPos.x), locY: CGFloat(screenPos.y * -1), text: "+" + String(pointsToDisplay), color: UIColor.cyan)
                    }
                    //print(String(indexRow) + " " + String(indexCol))
                }
            }
            columnCounts+=1;
        }
        
        var pointsToDisplaySelf = testManager.calcPointsFromPosition(thisBuildingXPos:xPos, thisBuildingYPos:yPos)
        //add display code here
        if(pointsToDisplaySelf != 0){
            let lx: Float = Float(xPos) + 0.5
            let lz: Float = Float(yPos) + 0.5
            let color: GLKVector4;
            
            if(pointsToDisplaySelf > 0){
                color = GLKVector4Make(0.8, 1.0, 0.8, 1.0)
            } else {
                color = GLKVector4Make(1.0, 0.8, 0.8, 1.0)
            }
            
            var txt: MyText = MyText(
                text: String(pointsToDisplaySelf), pos: GLKVector3Make(Float(lx),1.25,Float(lz)), spacing: 0.5, scale: GLKVector3Make(0.5, 1, 1), color: color
            )
            textController.addNewText(text: txt, glesRenderer: glesRenderer)
        }
        //let screenPos: GLKVector2 = WorldPosToScreenPos(worldPos: GLKVector3Make(Float(lx),0,Float(lz)))
        
        //displayLabel(locX: CGFloat(screenPos.x), locY: CGFloat(screenPos.y * -1), text: "+" + String(pointsToDisplaySelf), color: UIColor.cyan)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        
        if(sender.state == UIGestureRecognizer.State.ended){
           
            var x: Float = Float(Int(glesRenderer.cameraFocusPos.x))
            var z: Float = Float(Int(glesRenderer.cameraFocusPos.z))
            let gridPosX: Int = Int(x * -1)
            let gridPosY: Int = Int(z * -1)
            x = x * -1 + 0.5
            z = z * -1 + 0.5
            
            if(!testManager.checkActive(xPos: gridPosX, yPos: gridPosY)){


                var buildingName: String = buildingNameFromInt(i: Int(currBuildType))
                                
                let buildPos = GLKVector3Make(x, 0, z)
                let animPos = GLKVector3Add(buildPos, GLKVector3Make(0, 1, 0))
                
                let anim: BuildAnimation2 = BuildAnimation2(modelType: previewType, instanceID: previewID, startPos: animPos, endPos: buildPos, startTime: glesRenderer.currTime)
                gameObjects.append(anim)
              
                build(buildingName: buildingName, posX: gridPosX, posY: gridPosY);

                checkLevelState();
                
            } else {
                print("building already active at: " + String(gridPosX) + ", " + String(gridPosY) + "?")
            }
        }
    }
    

    func build(buildingName: String, posX: Int, posY: Int){

        glesRenderer.playSoundFile("boop");
        
        previewPoints(buildingName: buildingName, xPos: posX, yPos: posY)
                
        // previewType and previewID identify the model instance for this building
        var points: Int = testManager.addBuilding(buildingName: buildingName, xPos: posX, yPos: posY, modelType: Int(previewType), modelID: Int(previewID))
        if(buildingName == "Demolish"){
            //check if buildings are active and on the grid
            removeNearbyBuildings(posX: posX, posY: posY)
            //unrender buildings
            //glesRenderer.deactivateModelInstance(<#T##type: Int32##Int32#>, id: <#T##Int32#>)
        }
        print("points gained: " + String(points))
        score += points;
        
        
        scoreLabel.text = "Score:" + String(score)
        
        print("built " + String(currBuildType) + " at: " + String(posX) + ", " + String(posY))
        nextBuilding()
        initBuildingSelection()
    }
    
    func removeNearbyBuildings(posX: Int, posY:Int){
        //check left
        if(testManager.checkPosition(xPos: posX-1, yPos: posY) && testManager.checkActive(xPos: posX-1, yPos: posY)){
            glesRenderer.deactivateModelInstance(testManager.getModelType(posX: posX-1, posY: posY),
                                                 id: testManager.getModelID(posX: posX-1, posY: posY))
        }
    }
    
    func checkLevelState(){
        buildingsLeft-=1;
        buildingsLeftLabel.text = "Left: " + String(buildingsLeft)
        if(score > scoreThreshold[currentLevel]){
            
            currentLevel+=1;
            buildingsLeft = buildingsEachLevel[currentLevel];
            buildingsLeftLabel.text = "Left: " + String(buildingsLeft)
            
            scoreThresholdLabel.text = "Next: " + String(scoreThreshold[currentLevel])
            
        }
        if(buildingsLeft < 0){
            //end game
            print("game ended");
            if (score > highScore1){
                highScore1 = score
                defaults.set(highScore1, forKey: "HighScore1")
            }else if (score > highScore2){
                highScore2 = score
                defaults.set(highScore2, forKey: "HighScore2")
            }else if (score > highScore3){
                highScore3 = score
                defaults.set(highScore3, forKey: "HighScore3")
            }
            loadViewIntoController()        }
        
    }
    
    func buildingNameFromInt( i: Int)->String{
        if(i == 0){
            return "Selfish"
        } else if (i == 1){
            return "Loner"
        } else if (i == 2){
            return "Leader"
        } else if (i == 3){
            return "Empower"
        } else if (i == 4){
            return "Copy"
        } else if (i == 5){
            return "Demolish"
        } else if (i == 6){
            return "Debuff"
        }
        return "?"
    }
        
    @objc func handlePan(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        
        if(sender.state == UIGestureRecognizer.State.began){
            //let worldPos = ScreenPosToWorldPlane(mouseX: translation.x, mouseY: translation.y);
            //panTrack = worldPos.hitPos;
            panStartScreen = translation;
//            panX = translation.x;
//            panY = translation.y;
        } else if (sender.state == UIGestureRecognizer.State.ended){
            
        } else {
 
            let x = (panStartScreen.x - translation.x) * cameraSpeed * -1.0
            let z = (panStartScreen.y - translation.y) * cameraSpeed * -1.0
            
            positionBuildPreview()
            
            var xi: Float = Float(Int(glesRenderer.cameraFocusPos.x))
            var zi: Float = Float(Int(glesRenderer.cameraFocusPos.z))
            let gridPosX: Int = Int(xi * -1)
            let gridPosY: Int = Int(zi * -1)
            //print("grid pos x, y: " + String(gridPosX) + ", " + String(gridPosY));
           
            
            previewPoints(buildingName: buildingNameFromInt(i: Int(currBuildType)), xPos: gridPosX, yPos: gridPosY)
            
            panStartScreen = translation
            glesRenderer.moveCamera(GLKVector3Make(Float(x), Float(0.0), Float(z)))
            //panStartScreen = translation
            //let cursorPos = GLKVector3Make(glesre)
            var pos: GLKVector3 = glesRenderer.cameraFocusPos
            pos = GLKVector3MultiplyScalar(pos, -1)
            glesRenderer.setInstancePos(Int32(cursorType), instance: Int32(cursorInstanceId), pos: pos)

        }
    }
    
    func nextBuilding(){
        
        glesRenderer.setInstanceColor(previewType, instance: previewID, color: GLKVector4Make(1.0,1.0,1.0,1.0))
        glesRenderer.setInstanceScale(previewType, instance: previewID, scale: GLKVector3Make(0.25,0.25,0.25))
        
        currBuildType+=1
        currBuildType %= buildTypes
        
        UpdateTypeText()
        
    }
    
    func initBuildingSelection(){
        previewID = glesRenderer.createModelInstance(Int32(currBuildType),pos:GLKVector3Make(0,0,0),rot:GLKVector3Make(0, 0, 0),scale:GLKVector3Make(0.25, 0.25, 0.25))
        previewType = currBuildType
        positionBuildPreview()
        glesRenderer.setInstanceColor(previewType, instance: previewID, color: GLKVector4Make(1.0,1.0,1.0,0.35))
        glesRenderer.setInstanceScale(previewType, instance: previewID, scale: GLKVector3Make(0.25,0.25,0.25))
    }
    
    func positionBuildPreview(){
        var x: Float = Float(Int(glesRenderer.cameraFocusPos.x))
        var z: Float = Float(Int(glesRenderer.cameraFocusPos.z))
        let gridPosX: Int = Int(x * -1)
        let gridPosY: Int = Int(z * -1)
        x = x * -1 + 0.5
        z = z * -1 + 0.5
        
        let gridPos: GLKVector3 = GLKVector3Make(x, 0, z)
        
        glesRenderer.setInstancePos(Int32(previewType), instance: Int32(previewID), pos: gridPos)
    }
    
    
    
    func UpdateTypeText(){
        if(currBuildType == 0){
            typeLabel.text = "Selfish";
        } else if (currBuildType == 1){
            typeLabel.text = "Loner";
        } else if (currBuildType == 2){
            typeLabel.text = "Leader";
        } else if (currBuildType == 3){
            typeLabel.text = "Empower";
        } else if (currBuildType == 4){
            typeLabel.text = "Copy";
        } else if (currBuildType == 5){
            typeLabel.text = "Demolish"
        } else if (currBuildType == 6){
            typeLabel.text = "Debuff"
        }
    }

    
    func WorldPosToScreenPos(worldPos: GLKVector3) -> GLKVector2{
        let clipPos = GLKMatrix4MultiplyVector4(
            glesRenderer._projectionMatrix,
            GLKMatrix4MultiplyVector4(glesRenderer._viewMatrix, GLKVector4MakeWithVector3(worldPos, 1)));
        
        let normPos = GLKVector3DivideScalar(GLKVector3Make(clipPos.x, clipPos.y, clipPos.z), clipPos.w);
        let screen = UIScreen.main.bounds
        let screenSize = GLKVector2Make(Float(screen.width), Float(screen.height))
        let screenOffset = GLKVector2Make(0, Float(-screen.height))
        var screenPos = GLKVector2Make((normPos.x + 1.0)/2.0, (normPos.y + 1.0)/2.0);
        screenPos = GLKVector2Multiply(screenPos, screenSize)
        screenPos = GLKVector2Add(screenPos, screenOffset)
        return screenPos
    }
    
    func ScreenPosToWorldPlane(mouseX: CGFloat, mouseY: CGFloat) -> WorldPosReturn {
        //let screenPos = GLKVector2Make(Float(mouseX),Float(mouseY))
        //print("ray cast from screen position: "+NSStringFromGLKVector2(screenPos))
        // the direction of our ray
        let rayDirection = ScreenPosToWorldRay(mouseX: mouseX, mouseY: mouseY)
        
        //print("Ray dir: "+NSStringFromGLKVector3(rayDirection))
        
        // the origin of our ray is the camera position
        let cameraPos = GLKMatrix4GetColumn(glesRenderer._viewMatrix, 2)
        let rayOrigin = GLKVector3Make(0,5,0)
        //print("ray cast from camera position: "+NSStringFromGLKVector3(rayOrigin))
        //PrintModeViewMatrix()
        
        let planeNormal = GLKVector3Make(0,1,0)
        let planePoint = GLKVector3Make(0,0,0)
        var hitReturn = WorldPosReturn(hit: false, hitPos: GLKVector3Make(0,0,0))
        
        // ray doesnt intersect plane
        if(GLKVector3DotProduct(planeNormal, rayDirection) == 0){
            hitReturn.hit = false
            return hitReturn
        }
        
        let t: Float = (GLKVector3DotProduct(planeNormal, planePoint) - GLKVector3DotProduct(planeNormal, rayOrigin)) / GLKVector3DotProduct(planeNormal, rayDirection)
        var hitPos = GLKVector3MultiplyScalar(rayDirection, t)
        hitPos = GLKVector3Add(hitPos, rayOrigin)
        hitReturn.hitPos = hitPos
        hitReturn.hit = true
        
        return hitReturn
    }
    
    struct WorldPosReturn {
        var hit: Bool
        var hitPos: GLKVector3
    }
    
    func ScreenPosToWorldRay(mouseX: CGFloat, mouseY: CGFloat) ->GLKVector3{
        let screen = UIScreen.main.bounds
        let width = screen.width
        let height = screen.height
        let x = (2.0 * mouseX) / width - 1.0
        let y = 1.0 - (2.0 * mouseY) / height
        let z = 1.0
        let ray_nds: GLKVector3 = GLKVector3Make(Float(x), Float(y), Float(z)) // nds = normalized device coordinate space
        let ray_clip: GLKVector4 = GLKVector4Make(Float(ray_nds.x),Float(ray_nds.y),-1.0,1.0)
        
        let isInvertible: UnsafeMutablePointer<Bool> = UnsafeMutablePointer<Bool>.allocate(capacity: 1)

        let proj = GLKMatrix4Multiply(glesRenderer._projectionMatrix, GLKMatrix4Identity)
        let proj_invert: GLKMatrix4 = GLKMatrix4Invert(proj, isInvertible)

        if(isInvertible.pointee == false){
            print("projection matrix not invertible")
        }
        
        var ray_cameraSpace: GLKVector4  = GLKMatrix4MultiplyVector4(proj_invert, ray_clip)
        ray_cameraSpace = GLKVector4Make(ray_cameraSpace.x, ray_cameraSpace.y, -1.0, 0)
        
        let view_invert = GLKMatrix4Invert(glesRenderer._viewMatrix,isInvertible)
        var ray_worldSpace = GLKMatrix4MultiplyVector4(view_invert, ray_cameraSpace)
        
        if(isInvertible.pointee == false){
            print("model view matrix not invertible")
        }
        
        ray_worldSpace = GLKVector4Normalize(ray_worldSpace)
        let rayVector3 = GLKVector3Make(ray_worldSpace.x * -1,ray_worldSpace.y * -1,ray_worldSpace.z * -1)
        
        isInvertible.deallocate()
        
        return rayVector3
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect){
        glesRenderer.draw(rect);
    }
    
    // Function that creates a label at a certain location. Removes the label after a specified amount of time
    func displayLabel(locX: CGFloat, locY: CGFloat, text: String, color: UIColor) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = color
        label.font = label.font.withSize(20)
        label.center = CGPoint(x:locX, y:locY)
        label.textAlignment = .center
        label.text = text
        self.view.addSubview(label)
        
        //let log: String = "making label at: " + String(Float(locX))  + ", " + String(Float(locY))
        //print(log)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            label.removeFromSuperview()
        }
    }

    func PrintModeViewMatrix(){
        print("modelViewMatrix:")
        for num in 0...3 {
            let row = GLKMatrix4GetRow(glesRenderer._viewMatrix, Int32(num))
            print(NSStringFromGLKVector4(row))
        }
    }
    
    // Dismisses the popup view
    @objc func dismissView() {
        customView.isHidden = true
    }
    
    // Loads the view to appear on the screen. Used for Highscore
    @objc func loadViewIntoController() {
        // grab all the highscores
        highScore1 = defaults.integer(forKey: "HighScore1")
        highScore2 = defaults.integer(forKey: "HighScore2")
        highScore3 = defaults.integer(forKey: "HighScore3")
        
        // loads
        let highScoreFrame = CGRect(x:0,y:0, width: view.frame.width, height: view.frame.height)
        customView = UIView(frame: highScoreFrame)
        customView.backgroundColor = .white
        customView.isHidden = false
        view.addSubview(customView)
                
        let closeButtonFrame = CGRect(x: 0, y: 0, width: 80, height: 30)
        let closeButton = UIButton(frame: closeButtonFrame)
        closeButton.center = CGPoint(x: 220, y:500)
        closeButton.backgroundColor = .blue
        closeButton.setTitle("Close", for: .normal)
        customView.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        title.font = UIFont.preferredFont(forTextStyle: .footnote)
        title.font = title.font.withSize(30)
        title.center = CGPoint(x:160, y:50)
        title.textAlignment = .center
        title.text = "High Scores"
        customView.addSubview(title)
        
        let score1 = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        score1.font = UIFont.preferredFont(forTextStyle: .footnote)
        score1.font = score1.font.withSize(21)
        score1.center = CGPoint(x:160, y:150)
        score1.textAlignment = .center
        score1.text = "1st Place: " + String(highScore1)
        customView.addSubview(score1)
        
        let score2 = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        score2.font = UIFont.preferredFont(forTextStyle: .footnote)
        score2.font = score2.font.withSize(21)
        score2.center = CGPoint(x:160, y:200)
        score2.textAlignment = .center
        score2.text = "2nd Place: " + String(highScore2)
        customView.addSubview(score2)
        
        let score3 = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        score3.font = UIFont.preferredFont(forTextStyle: .footnote)
        score3.font = score3.font.withSize(21)
        score3.center = CGPoint(x:160, y:250)
        score3.textAlignment = .center
        score3.text = "3rd Place: " + String(highScore3)
        customView.addSubview(score3)
        
        let personal = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        personal.font = UIFont.preferredFont(forTextStyle: .footnote)
        personal.font = personal.font.withSize(21)
        personal.center = CGPoint(x:160, y:350)
        personal.textAlignment = .center
        personal.text = "Your Score: " + String(score)
        customView.addSubview(personal)
    }

}

extension ViewController: GLKViewControllerDelegate{
    
    func glkViewControllerUpdate(_ controller: GLKViewController){
        
        let currTime = glesRenderer.currTime;
        let elapsedTime: Float = glesRenderer.deltaTime;
        
        glesRenderer.update();
        
        if(gameObjects.count > 0){
            
            for i in stride(from: gameObjects.count, to: 0, by: -1)
            {
                let realI: Int = i - 1;
                let updateReturn: Int = gameObjects[realI].update(glesRenderer: glesRenderer, viewController: self)
                if(updateReturn == 0){
                    gameObjects.remove(at: realI)
                }
            }
        }

        
        //lastTime = CACurrentMediaTime();
        
        
    }
}

extension Array{
    func size() -> Int{
        return MemoryLayout<Element>.stride * self.count
    }
}

struct WorldBoundUI{
    var worldPos: GLKVector3
    var label: UILabel
}

