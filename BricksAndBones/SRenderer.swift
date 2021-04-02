//
//  Renderer.swift
//  BricksAndBones
//
//  Created by socas on 2021-03-31.
//

import GLKit

struct ModelType{
    public var vertices : [[Float]], normals : [[Float]], textCoords : [[Float]]
    public var numIndices: Int
    
    public var indices: [GLubyte]
    
    // element buffer object
    // keeps track of indicies that define triangles
    public var ebo = GLuint()
    
    // vertex buffer object
    // keeps track of vertex data (position,color)
    public var vbo = GLuint()
    
    // vertex array object
    // whenever you want to draw an object, you bind its VAO here
    public var vao = GLuint()
    
    public var texture: Int
}

struct ModelInstance{
    public var position: GLKVector3
    public var rotation: GLKVector3
    public var scale: GLKVector3
    public var modelType: Int
}



class SRenderer {
    
    private var context: EAGLContext?
    private var effect = GLKBaseEffect()
    
    var modelTypes: [ModelType] = []
    var modelInstances: [[ModelInstance]] = []
        
    var CubeVerts : [[Float]] =
    [
        [-0.5, -0.5, -0.5, 1.0,1.0,1.0,1.0],
        [-0.5, -0.5,  0.5, 1.0,1.0,1.0,1.0],
        [0.5, -0.5,  0.5, 1.0,1.0,1.0,1.0],
        [0.5, -0.5, -0.5, 1.0,1.0,1.0,1.0],
        [-0.5,  0.5, -0.5, 1.0,1.0,1.0,1.0],
        [-0.5,  0.5,  0.5, 1.0,1.0,1.0,1.0],
        [0.5,  0.5,  0.5, 1.0,1.0,1.0,1.0],
        [0.5,  0.5, -0.5, 1.0,1.0,1.0,1.0],
        [-0.5, -0.5, -0.5, 1.0,1.0,1.0,1.0],
        [-0.5,  0.5, -0.5, 1.0,1.0,1.0,1.0],
        [0.5,  0.5, -0.5, 1.0,1.0,1.0,1.0],
        [0.5, -0.5, -0.5, 1.0,1.0,1.0,1.0],
        [-0.5, -0.5, 0.5, 1.0,1.0,1.0,1.0],
        [-0.5,  0.5, 0.5, 1.0,1.0,1.0,1.0],
        [0.5,  0.5, 0.5, 1.0,1.0,1.0,1.0],
        [0.5, -0.5, 0.5, 1.0,1.0,1.0,1.0],
        [-0.5, -0.5, -0.5, 1.0,1.0,1.0,1.0],
        [-0.5, -0.5,  0.5, 1.0,1.0,1.0,1.0],
        [-0.5,  0.5,  0.5, 1.0,1.0,1.0,1.0],
        [-0.5,  0.5, -0.5, 1.0,1.0,1.0,1.0],
        [0.5, -0.5, -0.5, 1.0,1.0,1.0,1.0],
        [0.5, -0.5,  0.5, 1.0,1.0,1.0,1.0],
        [0.5,  0.5,  0.5, 1.0,1.0,1.0,1.0],
        [0.5,  0.5, -0.5, 1.0,1.0,1.0,1.0],
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
    
//    var VertDict: [String: [Vertex]] = [:];
//
//    var IndexDict: [String: [GLubyte]] = [:];
//
//    var TranslationDict: [String: Vertex] = [:];
    
    init() {

    }
    
    func setup(view: GLKView){
        
        // to do anything with OpenGL, you need to create an EAGLContext
        context = EAGLContext(api: .openGLES3)
        // specify that the rendering context is the one to use in the current thread
        EAGLContext.setCurrent(context);
        view.context = context!
//        if let view = self.view as? GLKView{
//            //set the GLKView context
//
//            // set the current class as the GLKViewController's delegate
//            //delegate = self
//        }
        
        loadModels()
        modelInstances.append([])
        makeTestInstances()
    }
    
    func makeTestInstances(){
        for x in -1 ... 1{
            //for z in -10 ... 10{
                for y in -1 ... 1{
                    var inst: ModelInstance = ModelInstance(
                        position: GLKVector3Make(Float(x),Float(y),0),
                        rotation: GLKVector3Make(0,0,0),
                        scale: GLKVector3Make(1.0, 1.0, 1.0),
                        modelType: 0)
                    modelInstances[0].append(inst)
                }
            //}
        }
    }
    
    func loadModels(){
        
        for i in 0 ... 0{
        
            print("loaded model")
            
            // should have a foreach loop here?
            // for each model type
            var type: ModelType = ModelType(vertices: CubeVerts, normals: [], textCoords: [], numIndices: CubeIndices.count, indices: CubeIndices, texture: 0)
            
//            type.vertices = CubeVerts
//            type.indices = CubeIndices
            
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
            glGenVertexArraysOES(1, &type.vao)
            // tell OpenGL to bind the VAO and that upcoming calls to configure vertex attribute pointers should be stored in this VAO
            glBindVertexArrayOES(type.vao)
                       
            
            glGenBuffers(1, &type.vbo)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), type.vbo)
            glBufferData(GLenum(GL_ARRAY_BUFFER),   // indicates to what buffer we are passing data
                         type.vertices.size(),               // specify the size, in bytes, of the data
                         type.vertices,                      // the data we are going to use
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
            
            glGenBuffers(1, &type.ebo)
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), type.ebo)
            glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
                         type.indices.size(),
                         type.indices,
                         GLenum(GL_STATIC_DRAW))
            
            glBindVertexArrayOES(0)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
            
            modelTypes.append(type)
            
        }
    }
    
    func draw(_ view: GLKView, drawIn rect: CGRect){
        
        glClearColor(1, 0, 0, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        /*
        for c in Cubes{
            c.draw();
        }
        */
        
        var viewMatrix: GLKMatrix4 = GLKMatrix4MakeLookAt(
            0, 0, -3,
            0, 0, 3,
            0, 1, 0)
        
        //viewMatrix = GLKMatrix4MakeTranslation(0, 0, -4)
        
        let aspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
        effect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 4.0, 1000.0)
        

        
        for i in 0 ... modelTypes.count - 1 {
            
            effect.prepareToDraw()
            
            let type = modelTypes[i]
            // select vao
            glBindVertexArrayOES(type.vao)
            // select ebo
            
            
            
            for inst in modelInstances[i]{
                let xRot = GLKMatrix4MakeXRotation(inst.rotation.x)
                let yRot = GLKMatrix4MakeXRotation(inst.rotation.y)
                let zRot = GLKMatrix4MakeXRotation(inst.rotation.z)
                let scale = GLKMatrix4MakeScale(inst.scale.x, inst.scale.y, inst.scale.z)
                let pos = GLKMatrix4MakeTranslation(inst.position.x, inst.position.y, inst.position.z)
                
                let modelMatrix =
                    GLKMatrix4Multiply(pos,
                    GLKMatrix4Multiply(scale,
                    GLKMatrix4Multiply(zRot,
                    GLKMatrix4Multiply(yRot, xRot))))
                //effect.prepareToDraw()
                let modelViewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix)
                effect.transform.modelviewMatrix = modelViewMatrix
                //effect.transform.normalMatrix = GLKMatrix3InvertAndTranspose(modelViewMatrix, NULL)
                

                glDrawElements(GLenum(GL_TRIANGLES),        // tells OpenGL what you want to draw (we wanna draw triangles)
                               GLsizei(type.numIndices),          // tells OpenGL how many vertices you want to draw
                               GLenum(GL_UNSIGNED_BYTE),          // specifies the type of values contained in each index
                               nil)
                glBindVertexArrayOES(0)
                
            }
        }
        glBindVertexArrayOES(0)
//        var i: GLint = 0;
//        while(i < CubeCounter){
//            setupGL_Arg(name: "cube\(i)")
//            // binds and compiles shaders for us
//            effect.prepareToDraw()
//            glBindVertexArrayOES(vao)
//            glDrawElements(GLenum(GL_TRIANGLES),        // tells OpenGL what you want to draw (we wanna draw triangles)
//                           GLsizei(IndexDict["cube\(i)", default:[]].count),          // tells OpenGL how many vertices you want to draw
//                           GLenum(GL_UNSIGNED_BYTE),          // specifies the type of values contained in each index
//                           nil)
//            i += 1;
//        }
    }
}
