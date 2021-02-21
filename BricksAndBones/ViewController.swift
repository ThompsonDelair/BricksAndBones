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
    
    var Indices: [GLubyte] = [
        0,1,2,
        2,3,0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGL()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect){
        glClearColor(0, 0, 0, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        // binds and compiles shaders for us
        effect.prepareToDraw()
        
        glBindVertexArrayOES(vao)
        glDrawElements(GLenum(GL_TRIANGLES),        // tells OpenGL what you want to draw (we wanna draw triangles)
                       GLsizei(Indices.count),          // tells OpenGL how many vertices you want to draw
                       GLenum(GL_UNSIGNED_BYTE),          // specifies the type of values contained in each index
                       nil)                                 // specifies offset within a buffer
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

}

extension ViewController: GLKViewControllerDelegate{
    func glkViewControllerUpdate(_ controller: GLKViewController){
        // calculates aspect ratop of the GLKview
        let aspect = fabsf(Float(view.bounds.size.width)/Float(view.bounds.size.height))
        // creates a perspective matrix (fov?, apsect, near plane, far plane)
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0),aspect,4.0,10.0)
        // sets the projection matrix on the effect's transform property
        effect.transform.projectionMatrix = projectionMatrix
        
        // translation
        var modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -6.0)
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
