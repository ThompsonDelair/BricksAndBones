//
//  ViewController.swift
//  BricksAndBones
//
//  Created by Thompson DeLair-Dobrovolny on 2021-02-20.
//

import GLKit


class ViewController: GLKViewController {
    private var context: EAGLContext?
    
    // element buffer object
    // keeps track of indicies that define triangles
    private var ebo = GLuint()
    
    // vertex buffer object
    // keeps track of vertex data (position,color)
    private var vbo = GLuint()
    
    // vertext array object
    // whenever you want to draw an object, you bind its VAO here
    private var vao = GLuint()
    
    private var effect = GLKBaseEffect()
    
    private var rotation: Float = 0.0
    
    private var buildType = 0
    
    private var typeLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    private var scoreLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    private var cameraLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    var CubeVerts : [[Float]] =
    [
        [-0.5, -0.5, -0.5],
        [-0.5, -0.5,  0.5],
        [0.5, -0.5,  0.5],
        [0.5, -0.5, -0.5],
        [-0.5,  0.5, -0.5],
        [-0.5,  0.5,  0.5],
        [0.5,  0.5,  0.5],
        [0.5,  0.5, -0.5],
        [-0.5, -0.5, -0.5],
        [-0.5,  0.5, -0.5],
        [0.5,  0.5, -0.5],
        [0.5, -0.5, -0.5],
        [-0.5, -0.5, 0.5],
        [-0.5,  0.5, 0.5],
        [0.5,  0.5, 0.5],
        [0.5, -0.5, 0.5],
        [-0.5, -0.5, -0.5],
        [-0.5, -0.5,  0.5],
        [-0.5,  0.5,  0.5],
        [-0.5,  0.5, -0.5],
        [0.5, -0.5, -0.5],
        [0.5, -0.5,  0.5],
        [0.5,  0.5,  0.5],
        [0.5,  0.5, -0.5],
    ];
    var CubeIndices : [GLubyte] =
    [
        0, 2, 1,
        0, 3, 2,
        4, 5, 6,
        4, 6, 7,
        8, 9, 10,
        8, 10, 11,
        12, 15, 14,
        12, 14, 13,
        16, 17, 18,
        16, 18, 19,
        20, 23, 22,
        20, 22, 21
    ];
    
    var VertDict: [String: [Vertex]] = [:];
    
    var IndexDict: [String: [GLubyte]] = [:];
    
    var TranslationDict: [String: Vertex] = [:];
    
    var CubeCounter: Int = 0;
    
    var Score: Int = 0;
    
    var gameGrid: Grid = Grid(unitSize: 2);
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // to do anything with OpenGL, you need to create an EAGLContext
        context = EAGLContext(api: .openGLES3)
        // specify that the rendering context is the one to use in the current thread
        EAGLContext.setCurrent(context);
        
        if let view = self.view as? GLKView, let context = context{
            //set the GLKView context
            view.context = context
            // set the current class as the GLKViewController's delegate
            delegate = self
        }
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        
        //print(VertDict["cube1"]![0].x);
        
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
        
        scoreLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        scoreLabel.textColor = .black
        scoreLabel.font = scoreLabel.font.withSize(20)
        scoreLabel.center = CGPoint(x:220, y:35)
        scoreLabel.textAlignment = .center
        self.view.addSubview(scoreLabel)
        

        loadNewCube()
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: self.view)
        let screenPos: GLKVector3 = GLKVector3Make(Float(touchPoint.x), Float(touchPoint.y), Float(0))
        
        let worldPos2 = ScreenPosToWorldPlane(mouseX: CGFloat(screenPos.x), mouseY: CGFloat(screenPos.y))
                
        if(worldPos2.hit == false){
            print("no hit for screen-to-world ray")
        }
        
        TranslationDict["cube\(CubeCounter-1)"] = Vertex(x: Float(worldPos2.hitPos.x), y: Float(worldPos2.hitPos.y), z: Float(0), r: 0, g: 0, b: 0, a: 0)
        
//        var worldPos = ScreenPosToWorldPos(screenPos: screenPos)
//
//        var snappedPosition = gameGrid.snapToGrid(x: worldPos.x, y: worldPos.y)
//
//        ScorePoints(worldPos: worldPos)
//
//        buildType += 1
//        buildType %= 3
//        UpdateTypeText()
//
//        loadNewCube()
//
//        TranslationDict["cube\(CubeCounter-1)"] = Vertex(x: Float(snappedPosition.0), y: Float(snappedPosition.1), z: Float(0), r: 0, g: 0, b: 0, a: 0)
        
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
    }
    
    func ScreenPosToWorldPos(screenPos: GLKVector3) -> GLKVector3 {
        var worldPos: GLKVector3 = GLKVector3Make(screenPos.x, screenPos.y, 0)
        
       
        worldPos.x /= 23.5
        worldPos.y /= 23.5
        
        worldPos.x -= 6.5
        worldPos.y -= 11.75
        worldPos.y *= -1
        
        return worldPos

    }
    
    func WorldPosToScreenPos(worldPos: GLKVector3) -> GLKVector3 {
        var screenPos: GLKVector3 = GLKVector3Make(worldPos.x, worldPos.y, 0)
        
        screenPos.y *= -1
        
        screenPos.x += 6.5
        screenPos.y += 11.75
        
        screenPos.x *= 23.5
        screenPos.y *= 23.5
        
        return screenPos
    }
    
    func UpdateTypeText(){
        if(buildType == 0){
            typeLabel.text = "selfish cube";
        } else if (buildType == 1){
            typeLabel.text = "normal cube";
        } else if (buildType == 2){
            typeLabel.text = "friendly cube";
        }
    }
    
    func ScorePoints(worldPos: GLKVector3){

        let snapCenter = gameGrid.snapToGrid(x: worldPos.x, y: worldPos.y)
        
        if(buildType == 0){
            
            if(CubeCounter != 0){
                for index in 0...CubeCounter-1{
                    let vert: Vertex = TranslationDict["cube\(index)"] ?? Vertex(x: 0, y: 0, z: 0, r: 0, g: 0, b: 0, a: 0)
                    let otherSnap = gameGrid.snapToGrid(x: vert.x, y: vert.y)
                    let xDiff = snapCenter.0 - otherSnap.0
                    let yDiff = snapCenter.1 - otherSnap.1
                    if(abs(xDiff) < 3 && abs(yDiff) < 3){
                        let worldPos: GLKVector3 = GLKVector3Make(Float(otherSnap.0),Float(otherSnap.1),0)
                        let screenPos = WorldPosToScreenPos(worldPos: worldPos)
                        displayLabel(locX: CGFloat(screenPos.x),locY: CGFloat(screenPos.y),text:"-5",color: .red)
                        Score -= 5
                    }
                }
            }
            let myWorldPos: GLKVector3 = GLKVector3Make(Float(snapCenter.0),Float(snapCenter.1),0)
            let myScreenPos = WorldPosToScreenPos(worldPos: myWorldPos)
            displayLabel(locX: CGFloat(myScreenPos.x),locY: CGFloat(myScreenPos.y),text:"+30",color: .green)
            Score += 30
        } else if(buildType == 1){
            let myWorldPos: GLKVector3 = GLKVector3Make(Float(snapCenter.0),Float(snapCenter.1),0)
            let myScreenPos = WorldPosToScreenPos(worldPos: myWorldPos)
            displayLabel(locX: CGFloat(myScreenPos.x),locY: CGFloat(myScreenPos.y),text:"+10",color: .green)
            Score += 10
        } else if(buildType == 2){
            
            if(CubeCounter != 0){
                for index in 0...CubeCounter-1{
                    let vert: Vertex = TranslationDict["cube\(index)"] ?? Vertex(x: 0, y: 0, z: 0, r: 0, g: 0, b: 0, a: 0)
                    let otherSnap = gameGrid.snapToGrid(x: vert.x, y: vert.y)
                    let xDiff = snapCenter.0 - otherSnap.0
                    let yDiff = snapCenter.1 - otherSnap.1
                    if(abs(xDiff) < 3 && abs(yDiff) < 3){
                        let worldPos: GLKVector3 = GLKVector3Make(Float(otherSnap.0),Float(otherSnap.1),0)
                        let screenPos = WorldPosToScreenPos(worldPos: worldPos)
                        displayLabel(locX: CGFloat(screenPos.x),locY: CGFloat(screenPos.y),text:"+10",color: .green)
                        Score += 10
                    }
                }
            }
        }
        

        scoreLabel.text = "Score: \(Score)"
        
    }
    
    func ScreenPosToWorldPlane(mouseX: CGFloat, mouseY: CGFloat) -> WorldPosReturn {
        let screenPos = GLKVector2Make(Float(mouseX),Float(mouseY))
        print("ray cast from screen position: "+NSStringFromGLKVector2(screenPos))
        // the direction of our ray
        let rayDirection = ScreenPosToWorldRay(mouseX: mouseX, mouseY: mouseY)
        // the origin of our ray is the camera position
        let cameraPos = GLKMatrix4GetColumn(effect.transform.modelviewMatrix, 3)
        let rayOrigin = GLKVector3Make(cameraPos.x,cameraPos.y,cameraPos.z)
        print("ray cast from camera position: "+NSStringFromGLKVector3(rayOrigin))

        
        let planeNormal = GLKVector3Make(0,0,1)
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
    
    func ScreenPosToWorldRay2(mouseX: CGFloat, mouseY: CGFloat) -> GLKVector3{
        let screen = view.bounds
        let width = screen.width
        let height = screen.height
        let x = (2.0 * mouseX) / width - 1.0
        let y = 1.0 - (2.0 * mouseY) / height
        let z = 1.0
        let screenPos: GLKVector4 = GLKVector4Make(Float(x),Float(y),Float(z),1)
        
        var viewProj = GLKMatrix4Multiply(effect.transform.modelviewMatrix, effect.transform.projectionMatrix)
        //viewProj = GLKMatrix4Multiply(viewProj)
        //effect.transform.
        let isInvertible: UnsafeMutablePointer<Bool> = UnsafeMutablePointer<Bool>.allocate(capacity: 1)
        let viewProjInverse = GLKMatrix4Invert(viewProj, isInvertible)
        
        if(isInvertible.pointee == false){
            print("cannot invert viewProjection matrix")
        }
        isInvertible.deallocate()
        
        var worldRay4 = GLKMatrix4MultiplyVector4(viewProjInverse, screenPos)
        worldRay4.w = 1.0 / worldRay4.w
        
        var worldRay3 = GLKVector3Make(
            Float(worldRay4.x * worldRay4.w),
            Float(worldRay4.y * worldRay4.w),
            Float(worldRay4.z * worldRay4.w))
        
        worldRay3 = GLKVector3Normalize(worldRay3)
        
        return worldRay3
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
        
        let aspect = fabsf(Float(view.bounds.size.width)/Float(view.bounds.size.height))
        var proj = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0),aspect,1,40)
        proj = GLKMatrix4Multiply(proj, GLKMatrix4Identity)
        let proj_invert: GLKMatrix4 = GLKMatrix4Invert(proj, isInvertible)

        if(isInvertible.pointee == false){
            print("projection matrix not invertible")
        }
        
        var ray_cameraSpace: GLKVector4  = GLKMatrix4MultiplyVector4(proj_invert, ray_clip)
        ray_cameraSpace = GLKVector4Make(ray_cameraSpace.x, ray_cameraSpace.y, -1.0, 0)
        
        let view_invert = GLKMatrix4Invert(effect.transform.modelviewMatrix,isInvertible)
        var ray_worldSpace = GLKMatrix4MultiplyVector4(view_invert, ray_cameraSpace)
        
        if(isInvertible.pointee == false){
            print("model view matrix not invertible")
        }
        
        ray_worldSpace = GLKVector4Normalize(ray_worldSpace)
        let rayVector3 = GLKVector3Make(ray_worldSpace.x * -1,ray_worldSpace.y * -1,ray_worldSpace.z)
        
        isInvertible.deallocate()
        
        return rayVector3
    }
    
    func loadNewCube(){
        for vert in CubeVerts{
            VertDict["cube\(CubeCounter)", default: []].append(Vertex(x: vert[0], y:vert[1], z:vert[2], r: 0.7, g: 0.7, b: 0.7, a: 1))
        }
        for indicies in CubeIndices{
            IndexDict["cube\(CubeCounter)", default:[]].append(indicies)
        }
        TranslationDict["cube\(CubeCounter)"] = Vertex(x: Float(CubeCounter * 2), y: Float(CubeCounter * 2), z: Float(CubeCounter * 2), r: 0, g: 0, b: 0, a: 0)
        CubeCounter += 1;
    }
    
    func loadModels(){
        if let path = Bundle.main.path(forResource: "rook", ofType: "obj"){
            do{
                let data = try String(contentsOfFile: path, encoding:.utf8)
                let myStrings = data.components(separatedBy: .newlines)
                //print(myStrings.joined(separator: "\n "))
                for v in myStrings{
                    let myVertData = v.components(separatedBy: .whitespaces)
                    
                    if myVertData[0] == "v"{
                        print("Data: \(myVertData[0]) \((myVertData[1] as NSString).floatValue) \((myVertData[2] as NSString).floatValue) \(myVertData[3])");
                        VertDict["rook", default:[]].append(Vertex(x: (myVertData[1] as NSString).floatValue as GLfloat,y: (myVertData[2] as NSString).floatValue as GLfloat,z: (myVertData[3] as NSString).floatValue as GLfloat,r: 0.0 ,g: 1.0 ,b: 0.0 ,a: 1.0))
                    }
                }
                //print("Rook data: \(VertDict["rook"]![0])")
            }
            catch{
                print(error)
            }
        }
        
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect){
        
        glClearColor(0.85, 0.85, 0.85, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        /*
        for c in Cubes{
            c.draw();
        }
        */
        var i: GLint = 0;
        while(i < CubeCounter){
            setupGL_Arg(name: "cube\(i)")
            // binds and compiles shaders for us
            effect.prepareToDraw()
            glBindVertexArrayOES(vao)
            glDrawElements(GLenum(GL_TRIANGLES),        // tells OpenGL what you want to draw (we wanna draw triangles)
                           GLsizei(IndexDict["cube\(i)", default:[]].count),          // tells OpenGL how many vertices you want to draw
                           GLenum(GL_UNSIGNED_BYTE),          // specifies the type of values contained in each index
                           nil)
            i += 1;
        }
    }
    private func TranslateVerts(inputVert: [Vertex], inputTranslation: Vertex) -> [Vertex]{
        var outputVert :[Vertex] = inputVert;
        
        var i : Int = 0;
        while(i < outputVert.count){
            outputVert[i].x += inputTranslation.x;
            outputVert[i].y += inputTranslation.y;
            outputVert[i].z += inputTranslation.z;
            i += 1;
        }
        
        return outputVert;
    }
    
    private func setupGL_Arg(name : String){
        // specify how to read colors from vertex data structures
        let vertexAttribColor  = GLuint(GLKVertexAttrib.color.rawValue)
        // specify how to read position from vertex data struture
        let vertexAttribPosition = GLuint(GLKVertexAttrib.position.rawValue)
        // specify the size, in bytes, of vertex item
        let vertexSize = MemoryLayout<Vertex>.stride
        // memory offset of variables corresponding to vertex color
        let colorOffset = MemoryLayout<GLfloat>.stride * 3
        // convert offset into the required type
        let colorOffsetPointer = UnsafeRawPointer(bitPattern: colorOffset)
        
        // ask OpenGL to generate a new VAO
        glGenVertexArraysOES(1, &vao)
        // tell OpenGL to bind the VAO and that upcoming calls to configure vertex attribute pointers should be stored in this VAO
        glBindVertexArrayOES(vao)
        
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER),   // indicates to what buffer we are passing data
                     VertDict[name, default: []].size(),               // specify the size, in bytes, of the data
                     TranslateVerts(inputVert: VertDict[name, default: []], inputTranslation: TranslationDict[name]!),                      // the data we are going to use
                     GLenum(GL_STATIC_DRAW))        // tell OpenGL how we want the GPU to manage the data
                    // !! in this tutorial the data we are passing to the graphics card will rarely change, if at all
                    // !!   this allows OpenGL to optimize for this scenario
        
        glEnableVertexAttribArray(vertexAttribPosition)
        glVertexAttribPointer(vertexAttribPosition,             // specifies the attribute name to set
                              3,                                    // specifies how many values are present for each vertex (3 position floats, 4 color floats)
                              GLenum(GL_FLOAT),                     // specifies the type of each value
                              GLboolean(UInt8(GL_FALSE)),             // specify if you want the data to be normalized
                              GLsizei(vertexSize),                      // the size of the data structure containing the per-vertext data when its in an array
                              nil)                   // offset of the position data
        
        glEnableVertexAttribArray(vertexAttribColor)
        glVertexAttribPointer(vertexAttribColor,
                              4,
                              GLenum(GL_FLOAT),
                              GLboolean(UInt8(GL_FALSE)),
                              GLsizei(vertexSize),
                              colorOffsetPointer)
        
        glGenBuffers(1, &ebo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
                     IndexDict[name, default: []].size(),
                     IndexDict[name, default: []],
                     GLenum(GL_STATIC_DRAW))
        
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    
    private func tearDownGL(){
        CVEAGLContext.setCurrent(context)
        
        glDeleteBuffers(1, &vao)
        glDeleteBuffers(1, &vbo)
        glDeleteBuffers(1, &ebo)
        
        EAGLContext.setCurrent(nil)
        
        context = nil
    }
    
    deinit{
        tearDownGL()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            label.removeFromSuperview()
        }
    }
    
    /*func drawButton() {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Score", for: .normal)
        //button.addTarget(self, action: #selector(scoreAction), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    @objc func scoreAction(sender: UIButton!) {
        //displayLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = event?.allTouches?.first {
            let loc:CGPoint = touch.location(in: touch.view)
            displayLabel(locX:loc.x, locY:loc.y)
        }
    }
 */

    func PrintModeViewMatrix(){
        print("modelViewMatrix:")
        for num in 0...3 {
            let row = GLKMatrix4GetRow(effect.transform.modelviewMatrix, Int32(num))
            print(NSStringFromGLKVector4(row))
        }
    }
    
    func MakeCameraLabel(locX: CGFloat, locY: CGFloat){
        cameraLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        cameraLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        cameraLabel.font = cameraLabel.font.withSize(20)
        cameraLabel.textColor = .black
        cameraLabel.center = CGPoint(x:locX, y:locY)
        cameraLabel.textAlignment = .center
        
        var text = ""
        
        for num in 0...3 {
            let row = GLKMatrix4GetRow(effect.transform.modelviewMatrix, Int32(num))
            text += NSStringFromGLKVector4(row) + "\n"
            print("loop " + String(num))
        }
        
        print(text)
        
        cameraLabel.text = text
        
        self.view.addSubview(cameraLabel)
    }
    
    func UpdateCameraLabel(){
        
    }
}


extension ViewController: GLKViewControllerDelegate{
    
    func glkViewControllerUpdate(_ controller: GLKViewController){
        // calculates aspect ratop of the GLKview
        let aspect = fabsf(Float(view.bounds.size.width)/Float(view.bounds.size.height))
        // creates a perspective matrix (fov?, apsect, near plane, far plane)
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0),aspect,0,1000.0)
        // sets the projection matrix on the effect's transform property
        effect.transform.projectionMatrix = projectionMatrix
        
        // translation
        var modelViewMatrix = GLKMatrix4MakeTranslation(0, 0, -20.0)
        // set the model view matrix on the effect's transform property
        effect.transform.modelviewMatrix = modelViewMatrix
        
        //PrintModeViewMatrix()
    }
}



extension Array{
    func size() -> Int{
        return MemoryLayout<Element>.stride * self.count
    }
}
