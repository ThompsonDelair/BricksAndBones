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
    
    
    var Vertices = [
        Vertex(x: 1, y: -1, z: 0, r: 1, g: 0, b: 0, a: 1),
        Vertex(x: 1, y: 1, z: 0, r: 0, g: 1, b: 0, a: 1),
        Vertex(x: -1, y: 1, z: 0, r: 0, g: 0, b: 1, a: 1),
        Vertex(x: -1, y: -1, z: 0, r: 0, g: 0, b: 0, a: 1)
    ]
    
    var VertDict: [String: [Vertex]] = [:];
    
    var IndexDict: [String: [GLubyte]] = [:];
    
    var Indices: [GLubyte] = [
        0,1,2,
        2,3,0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //loadModels()
        loadCubes()
        //setupGL()
        //setupGL_Arg(name: "cube1")
        //setupGL_Arg(name: "cube2")
        //setupGL_Arg(name: "cube2")
        print("did load")
        
        drawButton()
    }
    
    func loadCubes(){
        /*
        var CubeVerts = [
            Vertex(x: 1, y: -1, z: 1, r: 1, g: 0, b: 0, a: 1),
            Vertex(x: 1, y: 1, z: 1, r: 0, g: 1, b: 0, a: 1),
            Vertex(x: -1, y: 1, z: 1, r: 0, g: 0, b: 1, a: 1),
            Vertex(x: -1, y: -1, z: 1, r: 0, g: 0, b: 0, a: 1),
            Vertex(x: 1, y: -1, z: -1, r: 1, g: 0, b: 0, a: 1),
            Vertex(x: 1, y: 1, z: -1, r: 0, g: 1, b: 0, a: 1),
            Vertex(x: -1, y: 1, z: -1, r: 0, g: 0, b: 1, a: 1),
            Vertex(x: -1, y: -1, z: -1, r: 0, g: 0, b: 0, a: 1)
        ]*/
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
        
        for vert in CubeVerts{
            VertDict["cube1", default: []].append(Vertex(x: vert[0]-2, y:vert[1]-2, z:vert[2]-2, r: 1, g: 0, b: 1, a: 1))
            VertDict["cube2", default: []].append(Vertex(x: vert[0], y:vert[1], z:vert[2], r: 1, g: 0, b: 0, a: 1))
        }
        
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
        
        for indicies in CubeIndices{
            IndexDict["cube1", default:[]].append(indicies)
            IndexDict["cube2", default:[]].append(indicies)
        }
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
        setupGL_Arg(name: "cube1")
        // binds and compiles shaders for us
        effect.prepareToDraw()
        glBindVertexArrayOES(vao)
        glDrawElements(GLenum(GL_TRIANGLES),        // tells OpenGL what you want to draw (we wanna draw triangles)
                       GLsizei(IndexDict["cube1", default:[]].count),          // tells OpenGL how many vertices you want to draw
                       GLenum(GL_UNSIGNED_BYTE),          // specifies the type of values contained in each index
                       nil)                           // specifies offset within a buffer
        
        setupGL_Arg(name: "cube2")
        effect.prepareToDraw()
        glBindVertexArrayOES(vao)
        glDrawElements(GLenum(GL_TRIANGLES),        // tells OpenGL what you want to draw (we wanna draw triangles)
                       GLsizei(IndexDict["cube1", default:[]].count),          // tells OpenGL how many vertices you want to draw
                       GLenum(GL_UNSIGNED_BYTE),          // specifies the type of values contained in each index
                       nil)
    }
    private func setupGL(){
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
                     VertDict["cube1", default: []].size(),               // specify the size, in bytes, of the data
                     VertDict["cube1"],                      // the data we are going to use
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
                     IndexDict["cube1", default: []].size(),
                     IndexDict["cube1", default: []],
                     GLenum(GL_STATIC_DRAW))
        
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
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
                     VertDict[name],                      // the data we are going to use
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
    /*
    private func setupGL(){
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
                     Vertices.size(),               // specify the size, in bytes, of the data
                     Vertices,                      // the data we are going to use
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
                     Indices.size(),
                     Indices,
                     GLenum(GL_STATIC_DRAW))
        
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
 */
    
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
    func displayLabel(locX: CGFloat, locY: CGFloat) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        label.font = label.font.withSize(20)
        label.center = CGPoint(x:locX, y:locY)
        label.textAlignment = .center
        label.text = "+100"
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

}

extension ViewController: GLKViewControllerDelegate{
    func glkViewControllerUpdate(_ controller: GLKViewController){
        // calculates aspect ratop of the GLKview
        let aspect = fabsf(Float(view.bounds.size.width)/Float(view.bounds.size.height))
        // creates a perspective matrix (fov?, apsect, near plane, far plane)
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0),aspect,4.0,100.0)
        // sets the projection matrix on the effect's transform property
        effect.transform.projectionMatrix = projectionMatrix
        
        // translation
        var modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -20.0)
        // rotation
        rotation += 90 * Float(timeSinceLastUpdate)
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(rotation),0,0,1)
        // set the model view matrix on the effect's transform property
        effect.transform.modelviewMatrix = modelViewMatrix
        
    }
}

extension Array{
    func size() -> Int{
        return MemoryLayout<Element>.stride * self.count
    }
}
