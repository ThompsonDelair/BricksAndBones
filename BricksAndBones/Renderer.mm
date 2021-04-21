//
//  Copyright © Borna Noureddin. All rights reserved.
//

#import "Renderer.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include <chrono>
#include "GLESRenderer.hpp"
#import "ObjLoader.hpp"

#import <AudioToolbox/AudioToolbox.h>


//===========================================================================
//  GL uniforms, attributes, etc.

// List of uniform values used in shaders
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_TEXTURE,
    UNIFORM_MODELVIEW_MATRIX,
    UNIFORM_COLOR_MOD,
    UNIFORM_FLASHLIGHT_POSITION,
    UNIFORM_DIFFUSE_LIGHT_POSITION,
    UNIFORM_SHININESS,
    UNIFORM_AMBIENT_COMPONENT,
    UNIFORM_DIFFUSE_COMPONENT,
    UNIFORM_SPECULAR_COMPONENT,
    UNIFORM_FOG_MIN_DIST,   // fragments closer than this distance will not be effected by fog
    UNIFORM_FOG_MAX_DIST,   // fragments further than this distance will be 100% fog
    UNIFORM_FOG_TYPE,       // 0 = none, 1 = linear, 2 = expo, 3 = expo2
    UNIFORM_FOG_DENSITY,    // value between 0 and 1 used for expo and expo2 fog
    UNIFORM_FOG_COLOR,      // color of fog
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// List of vertex attributes
enum
{
    ATTRIB_POSITION,
    ATTRIB_NORMAL,
    ATTRIB_TEXTURE_COORDINATE,
    NUM_ATTRIBUTES
};


const int startingInstanceMemory = 100;
//const int charCap = 100;

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

//===========================================================================
//  Class interface
@interface Renderer () {

    // iOS hooks
    GLKView *theView;
    
    // GL ES variables
    GLESRenderer glesRenderer;
    GLuint _program;
    
//    // GLES buffer IDs
//    GLuint _vertexArray;
//    GLuint _vertexBuffers[3];
//    GLuint _indexBuffer;
    
    NSString *textureNames2[NUM_MODEL_TYPES];
    NSString *modelNames2[NUM_MODEL_TYPES];
    
    // Model data
    struct ModelData modelTypes[NUM_MODEL_TYPES];
    struct ModelInstance *modelInstances[NUM_MODEL_TYPES];
    int modelInstanceMemorySize[NUM_MODEL_TYPES];
    //int modelInstanceCount[NUM_MODEL_TYPES];
    int inactiveIndex[NUM_MODEL_TYPES];

    
    
    //struct CharInstance charInstances[charCap];
    
    // Transformation matrices
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    GLKMatrix4 _modelViewMatrix;
    //GLKMatrix4 _viewMatrix;
    
    // Camera details
    //GLKVector3 cameraFocusPos;
    GLKVector3 cameraOffset;
    float cameraAngle;
    float cameraDist;
    
    //GLKMatrix4 projectionMatrix;
    
    // Shader data
    
    GLKVector4 baseColorMod;
    
    // Lighting parameters
    // ### Add lighting parameter variables here...
    GLKVector3 flashlightPosition;
    GLKVector3 diffuseLightPosition;
    GLKVector4 diffuseComponent;
    float shininess;
    GLKVector4 specularComponent;
    GLKVector4 ambientComponent;

    // fog parameters
    float fogDensity;
    int fogType;
    float minDist;
    float maxDist;
    GLKVector4 fogColor;
    
    // Model
    //float *vertices, *normals, *texCoords;
    //GLuint *indices, numIndices;

    
    // Misc UI variables
    std::chrono::time_point<std::chrono::steady_clock> lastTime;
    
    AVAudioPlayer *backgroundMusic;
    AVAudioPlayer *backgroundMusic2;
    AVAudioPlayer *backgroundMusic3;
    
    
}

@end

//===========================================================================
//  Class implementation
@implementation Renderer

@synthesize _viewMatrix;
@synthesize _projectionMatrix;
@synthesize cameraFocusPos;
@synthesize currTime;
@synthesize deltaTime;

//=======================
// Initial setup of GL using iOS view
//=======================
- (void)setup:(GLKView *)view
{
    // Create GL context
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!view.context) {
        NSLog(@"Failed to create ES context");
    }

    modelNames2[TEST_CUBE_RED] = @"nothingRightNow.wut";
    
    modelNames2[ROOK] = @"path";
    modelNames2[PLANE] = @"path";
    modelNames2[MOD_CUBE] = @"path";
        
    textureNames2[TEST_CUBE_RED] = @"texRed.png";
    textureNames2[TEST_CUBE_BLUE] = @"texBlue.png";
    textureNames2[TEST_CUBE_GREEN] = @"texGreen.png";
    textureNames2[TEST_CUBE_PURP] = @"tex_4.png";
    textureNames2[TEST_CUBE_PINK] = @"tex_5.png";
    textureNames2[TEST_CUBE_YELL] = @"tex_6.png";
    textureNames2[TEST_CUBE_GRAD] = @"gradient.png";
    textureNames2[CUBE] = @"justWhite.png";
    textureNames2[PLANE] = @"texRed.png";
    textureNames2[ROOK] = @"stonewall.png";
    textureNames2[MILL] = @"basic_color_pallate_flipped.png";
    textureNames2[COPY_CUBE] = @"basic_color_pallate_flipped.png";
    textureNames2[POWDER_KEG] = @"basic_color_pallate_flipped.png";
    textureNames2[WIZARD_TOWER] = @"basic_color_pallate_flipped.png";
    textureNames2[CHURCH] = @"basic_color_pallate_flipped.png";
    textureNames2[BLACKSMITH] = @"basic_color_pallate_flipped.png";
    textureNames2[HOUSE] = @"basic_color_pallate_flipped.png";
    textureNames2[HUT] = @"basic_color_pallate_flipped.png";
    textureNames2[MILL_BLADE] = @"basic_color_pallate_flipped.png";
    textureNames2[CRYSTAL] = @"basic_color_pallate_flipped.png";
    textureNames2[GRASS] = @"grass.png";
    
    textureNames2[MOD_CUBE] = @"justWhite.png";
    textureNames2[MOD_SPHERE] = @"justWhite.png";
    textureNames2[MOD_TEXT_1] = @"1.png";
    textureNames2[MOD_TEXT_2] = @"2.png";
    textureNames2[MOD_TEXT_3] = @"3.png";
    textureNames2[MOD_TEXT_4] = @"4.png";
    textureNames2[MOD_TEXT_5] = @"5.png";
    textureNames2[MOD_TEXT_6] = @"6.png";
    textureNames2[MOD_TEXT_7] = @"7.png";
    textureNames2[MOD_TEXT_8] = @"8.png";
    textureNames2[MOD_TEXT_9] = @"9.png";
    textureNames2[MOD_TEXT_0] = @"0.png";
    textureNames2[MOD_TEXT_PLUS] = @"+.png";
    textureNames2[MOD_TEXT_MINUS] = @"minus.png";
        
    // Set up context
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    theView = view;
    [EAGLContext setCurrentContext:view.context];
    
    // Load in and set up shaders
    if (![self setupShaders])
        return;

    // Initialize GL color and other parameters
    glClearColor ( 0.0f, 0.0f, 0.0f, 0.0f );
    glEnable(GL_DEPTH_TEST);
    lastTime = std::chrono::steady_clock::now();
    
    _viewMatrix = GLKMatrix4MakeLookAt(0, 5, 0, 0, 0, 0, 0, 0, 1);
    
    cameraFocusPos = GLKVector3Make(0.0,0.0,0.0);
    
    cameraAngle = 60.0;
    cameraDist = -8.0;
    cameraOffset = GLKVector3Make(0.0, sinf(GLKMathDegreesToRadians(cameraAngle)), cosf(GLKMathDegreesToRadians(cameraAngle)));
    //cameraOffset = GLKVector3Make(0.0, cosf(cameraAngle), sin(cameraAngle));
    //printf("camera offset: %f, %f\n",cameraOffset.y,cameraOffset.z);
    cameraOffset = GLKVector3MultiplyScalar(cameraOffset, cameraDist);
    //printf("camera offset: %f, %f\n",cameraOffset.y,cameraOffset.z);
    
    //cameraOffset = GLKVector3Make(0.0, -3.0, -3.0);
    
    //printf("Number of model types is %d",NUM_MODEL_TYPES);
}


//=======================
// Load and set up shaders
//=======================
- (bool)setupShaders
{
    // Load shaders
    char *vShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"Shader.vsh"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"Shader.vsh"] pathExtension]] cStringUsingEncoding:1]);
    char *fShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"Shader.fsh"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"Shader.fsh"] pathExtension]] cStringUsingEncoding:1]);
    _program = glesRenderer.LoadProgram(vShaderStr, fShaderStr);
    if (_program == 0)
        return false;
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, ATTRIB_POSITION, "position");
    glBindAttribLocation(_program, ATTRIB_NORMAL, "normal");
    glBindAttribLocation(_program, ATTRIB_TEXTURE_COORDINATE, "texCoordIn");
    
    // Link shader program
    _program = glesRenderer.LinkProgram(_program);

    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    uniforms[UNIFORM_MODELVIEW_MATRIX] = glGetUniformLocation(_program, "modelViewMatrix");
    uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(_program, "texSampler");
    // ### Add lighting uniform locations here...
    uniforms[UNIFORM_FLASHLIGHT_POSITION] = glGetUniformLocation(_program, "flashlightPosition");
    uniforms[UNIFORM_DIFFUSE_LIGHT_POSITION] = glGetUniformLocation(_program, "diffuseLightPosition");
    uniforms[UNIFORM_SHININESS] = glGetUniformLocation(_program, "shininess");
    uniforms[UNIFORM_AMBIENT_COMPONENT] = glGetUniformLocation(_program, "ambientComponent");
    uniforms[UNIFORM_DIFFUSE_COMPONENT] = glGetUniformLocation(_program, "diffuseComponent");
    uniforms[UNIFORM_SPECULAR_COMPONENT] = glGetUniformLocation(_program, "specularComponent");
    
    uniforms[UNIFORM_COLOR_MOD] = glGetUniformLocation(_program, "colorMod");
    
    // fog uniforms added here
    uniforms[UNIFORM_FOG_TYPE] = glGetUniformLocation(_program, "fogType");
    uniforms[UNIFORM_FOG_COLOR] = glGetUniformLocation(_program, "fogColor");
    uniforms[UNIFORM_FOG_MIN_DIST] = glGetUniformLocation(_program, "minDist");
    uniforms[UNIFORM_FOG_MAX_DIST] = glGetUniformLocation(_program, "maxDist");
    uniforms[UNIFORM_FOG_DENSITY] = glGetUniformLocation(_program, "fogDensity");

    baseColorMod = GLKVector4Make(1.0,1.0,1.0,1.0);
    
    // Set up lighting parameters
    // ### Set default lighting parameter values here...
    flashlightPosition = GLKVector3Make(0.0, 0.0, 1.0);
    diffuseLightPosition = GLKVector3Make(0.0, 1.0, 0.0);
    diffuseComponent = GLKVector4Make(0.8, 0.1, 0.1, 1.0);
    shininess = 200.0;
    specularComponent = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    ambientComponent = GLKVector4Make(0.5, 0.5, 0.5, 1.0);
    
    // set up fog parameters
    minDist = 1.0;
    maxDist = 100.0;
    fogType = 1;
    fogDensity = 0;
    fogColor = GLKVector4Make(0.0, 1.0, 1.0, 0.0);

    return true;
}


//=======================
// Load model(s)
//=======================
- (void)loadModels
{
    for(int i = 0; i < NUM_MODEL_TYPES;i++){
        modelInstances[i] = new ModelInstance[startingInstanceMemory];
        modelInstanceMemorySize[i] = startingInstanceMemory;
        inactiveIndex[i] = 0;
        
        for(int j = 0; j < modelInstanceMemorySize[i];j++){
            modelInstances[i][j].active = false;
        }
        
        //modelInstanceCount[i] = 0;
        ModelData m;
        
        // Create VAOs
        glGenVertexArrays(1, &(m.vao));
        glBindVertexArray(m.vao);

        // Create VBOs
        glGenBuffers(NUM_ATTRIBUTES, m.vbos);   // One buffer for each attribute
        glGenBuffers(1, &m.ebo);                 // Index buffer

        // Generate vertex attribute values from model
        //int numVerts;
        
        ObjLoader thisOBJ;
        
        if(i == ROOK){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/rook.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == MILL){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/mill.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == COPY_CUBE){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/err_cube.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == POWDER_KEG){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/powderkeg.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == WIZARD_TOWER){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/wizard tower.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == CHURCH){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/church.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == BLACKSMITH){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/blacksmith.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == HOUSE){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/house.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == HUT){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/hut.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == GRASS){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/plane.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == MILL_BLADE){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/mill_blade.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == CRYSTAL){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/crystal.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == PLANE){
            m.numIndices = thisOBJ.loadOBJ("/Users/socas/Documents/GitHub/BricksAndBones/BricksAndBones/Models/plane.obj", 1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }else if(i == MOD_TEXT_0 || i == MOD_TEXT_1 || i == MOD_TEXT_2|| i == MOD_TEXT_3|| i == MOD_TEXT_4|| i == MOD_TEXT_5|| i == MOD_TEXT_6|| i == MOD_TEXT_7|| i == MOD_TEXT_8|| i == MOD_TEXT_9|| i == MOD_TEXT_MINUS|| i == MOD_TEXT_PLUS ){
            m.numIndices = glesRenderer.GenPlane(1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        } else if(i == MOD_SPHERE){
            m.numIndices = glesRenderer.GenSphere(8, 0.5, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        } else {
            m.numIndices = glesRenderer.GenCube(1.0f, &m.vertices, &m.normals, &m.texCoords, &m.indices, &m.numVerts);
        }
        
        // Set up VBOs...
        
        // Position
        glBindBuffer(GL_ARRAY_BUFFER, m.vbos[0]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*3*m.numVerts, m.vertices, GL_STATIC_DRAW);
        glEnableVertexAttribArray(ATTRIB_POSITION);
        glVertexAttribPointer(ATTRIB_POSITION, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), BUFFER_OFFSET(0));
        
        // Normal vector
        glBindBuffer(GL_ARRAY_BUFFER, m.vbos[1]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*3*m.numVerts, m.normals, GL_STATIC_DRAW);
        glEnableVertexAttribArray(ATTRIB_NORMAL);
        glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), BUFFER_OFFSET(0));
        
        // Texture coordinate
        glBindBuffer(GL_ARRAY_BUFFER, m.vbos[2]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*3*m.numVerts, m.texCoords, GL_STATIC_DRAW);
        glEnableVertexAttribArray(ATTRIB_TEXTURE_COORDINATE);
        glVertexAttribPointer(ATTRIB_TEXTURE_COORDINATE, 2, GL_FLOAT, GL_FALSE, 2*sizeof(float), BUFFER_OFFSET(0));
                
        // Set up index buffer
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m.ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(int)*m.numIndices, m.indices, GL_STATIC_DRAW);
        
        NSString *texName = textureNames2[i];
        //NSLog(texName);
        m.texture = [self setupTexture:texName];
        
        modelTypes[i] = m;
        
        // Reset VAO
        glBindVertexArray(0);
    }
    
    glUniform1i(uniforms[UNIFORM_TEXTURE], 0);
    glActiveTexture(GL_TEXTURE0);
//    for(int x = -5; x < 5;x++){
//        for(int z = -5; z < 5;z++){
//            [self createModelInstance:2 pos:GLKVector3Make(x, 0, z) rot:GLKVector3Make(0, 0, 0) scale:GLKVector3Make(0.5, 0.5, 0.5) ];
//        }
//    }
    
}


//=======================
// Load in and set up texture image (adapted from Ray Wenderlich)
//=======================
- (GLuint)setupTexture:(NSString *)fileName
{
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte *spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

//=======================
// Clean up code before deallocating renderer object
//=======================
- (void)dealloc
{
    // Delete GL buffers
    for(int i = 0; i < NUM_MODEL_TYPES;i++){
        
        glDeleteBuffers(3, modelTypes[i].vbos);
        glDeleteBuffers(1, &modelTypes[i].ebo);
        glDeleteVertexArrays(1, &modelTypes[i].vao);
        
        // Delete vertices buffers
        if (modelTypes[i].vertices)
            free(modelTypes[i].vertices);
        if (modelTypes[i].indices)
            free(modelTypes[i].indices);
        if (modelTypes[i].normals)
            free(modelTypes[i].normals);
        if (modelTypes[i].texCoords)
            free(modelTypes[i].texCoords);
    }
    
    free(textureNames2);
    free(modelNames2);
    
     // Delete shader program
     if (_program) {
         glDeleteProgram(_program);
         _program = 0;
     }
}


//=======================
// Update each frame
//=======================
- (void)update
{
    // Calculate elapsed time
    auto currentTime = std::chrono::steady_clock::now();
    auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - lastTime).count();
    lastTime = currentTime;
    deltaTime = elapsedTime / 1000.0;
    currTime += deltaTime;
}

//=======================
// Draw calls for each frame
//=======================
- (void)draw:(CGRect)drawRect;
{
    // Clear window
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    float aspect = fabsf(theView.bounds.size.width / theView.bounds.size.height);
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 1.0, 1000.0);;
    [self updateViewMatrix];
    
    // select shader
    glUseProgram(_program);
    
    // transparency for shader
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // non-instanced shader stuff
    
    glUniform4fv(uniforms[UNIFORM_COLOR_MOD],1,baseColorMod.v);
    
    // ### Set values for lighting parameter uniforms here...
    glUniform3fv(uniforms[UNIFORM_FLASHLIGHT_POSITION], 1, flashlightPosition.v);
    glUniform3fv(uniforms[UNIFORM_DIFFUSE_LIGHT_POSITION], 1, diffuseLightPosition.v);
    glUniform4fv(uniforms[UNIFORM_DIFFUSE_COMPONENT], 1, diffuseComponent.v);
    glUniform1f(uniforms[UNIFORM_SHININESS], shininess);
    glUniform4fv(uniforms[UNIFORM_SPECULAR_COMPONENT], 1, specularComponent.v);
    glUniform4fv(uniforms[UNIFORM_AMBIENT_COMPONENT], 1, ambientComponent.v);
    
    // set values for fog parameters uniforms
    glUniform1f(uniforms[UNIFORM_FOG_DENSITY], fogDensity);
    glUniform1f(uniforms[UNIFORM_FOG_MIN_DIST], minDist);
    glUniform1f(uniforms[UNIFORM_FOG_MAX_DIST], maxDist);
    glUniform1i(uniforms[UNIFORM_FOG_TYPE], fogType);
    glUniform4fv(uniforms[UNIFORM_FOG_COLOR], 1, fogColor.v);
    
    
    // draw from draw from model instances
    for(int i = 0; i < NUM_MODEL_TYPES;i++){
        
        // select VAO
        glBindVertexArray(modelTypes[i].vao);
        // select EBO
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, modelTypes[i].ebo);
        // select texture
        glBindTexture(GL_TEXTURE_2D, modelTypes[i].texture);
        
        for(int j = 0; j < modelInstanceMemorySize[i];j++){
            
            if(!modelInstances[i][j].active){
                continue;
            }
            
            //_modelViewMatrix = GLKMatrix4Multiply(_viewMatrix, [self calculateModelMatrix:modelInstances[i][j]]);
            _modelViewMatrix = GLKMatrix4Multiply(_viewMatrix, modelInstances[i][j].matrix);
            _modelViewProjectionMatrix = GLKMatrix4Multiply(_projectionMatrix, _modelViewMatrix);
            _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(_modelViewMatrix), NULL);
            
            // instance shader stuff
            glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
            glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEW_MATRIX], 1, 0, _modelViewMatrix.m);
            glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
            glUniform4fv(uniforms[UNIFORM_COLOR_MOD],1,modelInstances[i][j].color.v);
            
            glDrawElements(GL_TRIANGLES, modelTypes[i].numIndices, GL_UNSIGNED_INT, 0);
        }
    }
    
    // draw from char list
//    for(int i = 0; i < charCap;i++){
//
//        CharInstance c = charInstances[i];
//
//        if(c.active == false)
//            continue;
//
//        int t = c.modelType;
//        // select VAO
//        glBindVertexArray(modelTypes[t].vao);
//        // select EBO
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, modelTypes[t].ebo);
//        // select texture
//        glBindTexture(GL_TEXTURE_2D, modelTypes[t].texture);
//
//        // calculate model matrix
//        GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(c.rotation.x);
//        GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(c.rotation.y);
//        GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(c.rotation.z);
//        GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(c.scale.x, c.scale.y, c.scale.z);
//        GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(c.position.x, c.position.y, c.position.z);
//
//        GLKMatrix4 modelMatrix =
//                     GLKMatrix4Multiply(translateMatrix,
//                     GLKMatrix4Multiply(scaleMatrix,
//                     GLKMatrix4Multiply(zRotationMatrix,
//                     GLKMatrix4Multiply(yRotationMatrix,
//                                        xRotationMatrix))));
//
//        _modelViewMatrix = GLKMatrix4Multiply(_viewMatrix, modelMatrix);
//        _modelViewProjectionMatrix = GLKMatrix4Multiply(_projectionMatrix, _modelViewMatrix);
//        _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(_modelViewMatrix), NULL);
//
//        // instance shader stuff
//        glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
//        glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEW_MATRIX], 1, 0, _modelViewMatrix.m);
//        glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
//
//        glDrawElements(GL_TRIANGLES, modelTypes[t].numIndices, GL_UNSIGNED_INT, 0);
//    }
}

- (GLKMatrix4) calculateModelMatrix:(struct ModelInstance)inst{
    GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(inst.rotation.x);
    GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(inst.rotation.y);
    GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(inst.rotation.z);
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(inst.scale.x, inst.scale.y, inst.scale.z);
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(inst.position.x, inst.position.y, inst.position.z);

    return
         GLKMatrix4Multiply(translateMatrix,
         GLKMatrix4Multiply(scaleMatrix,
         GLKMatrix4Multiply(zRotationMatrix,
         GLKMatrix4Multiply(yRotationMatrix,
                            xRotationMatrix))));
}

//- (void) updateModelMatrix:(struct ModelInstance*)inst{
//    GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(inst->rotation.x);
//    GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(inst->rotation.y);
//    GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(inst->rotation.z);
//    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(inst->scale.x, inst->scale.y, inst->scale.z);
//    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(inst->position.x, inst->position.y, inst->position.z);
//
//    inst->matrix =
//         GLKMatrix4Multiply(translateMatrix,
//         GLKMatrix4Multiply(scaleMatrix,
//         GLKMatrix4Multiply(zRotationMatrix,
//         GLKMatrix4Multiply(yRotationMatrix,
//                            xRotationMatrix))));
//}

- (int) getNewInstanceIndex:(int)type{
    for(int i = 0; i < modelInstanceMemorySize[type];i++){
        if(modelInstances[type][i].active == false){
            //inactiveIndex[type] = i + 1;
            return i;
        }
    }
    
//    if(inactiveIndex[type] < modelInstanceMemorySize[type]){
//        [NSException raise:@"inactiveIndex incorrect" format:@"for type %d",type];
//    }
    
    int oldMemSize = modelInstanceMemorySize[type];

    int newSize = modelInstanceMemorySize[type] * 2;
    modelInstanceMemorySize[type] = newSize;
    ModelInstance newArr[newSize];
    for(int i = 0; i < oldMemSize;i++){
        ModelInstance mi = modelInstances[type][i];
        newArr[i] = mi;
    }
    for(int i = oldMemSize; i < newSize;i++){
        modelInstances[type][i].active = false;
    }
    //ModelInstance *oldArr = modelInstances[type];
    //free(oldArr);
    modelInstances[type] = newArr;

    //int index = inactiveIndex[type];
    //inactiveIndex[type] += 1;
    return oldMemSize;
}

- (void) deactivateModelInstance:(int)type ID:(int)instanceID{
    modelInstances[type][instanceID].active = false;
    if(instanceID < inactiveIndex[type]){
        inactiveIndex[type] = instanceID;
    }
}

- (int) createModelInstance:(int)type pos:(GLKVector3)position rot:(GLKVector3)rotation scale:(GLKVector3)scale{

    int index = [self getNewInstanceIndex:type];
    
    ModelInstance inst;
    inst.position = position;
    inst.rotation = rotation;
    inst.scale = scale;
    inst.active = true;
    inst.color = GLKVector4Make(1.0,1.0,1.0,1.0);
    inst.matrix = [self calculateModelMatrix:inst];
    //GLKMatrix4 matrix = [self calculateModelMatrix:inst];
    //inst.matrix = [self calculateModelMatrix:inst];
    modelInstances[type][index] = inst;
    
    //modelInstanceCount[type] = count + 1;
    //printf("got to end of func\n");
    return index;
}

- (ModelInstance) getModelInstanceData:(int)type instance:(int)instance{
    return modelInstances[type][instance];
}

- (GLKVector3) getInstancePos:(int)type instance:(int)instance{
    return  modelInstances[type][instance].position;
}

- (GLKVector3) getInstanceRot:(int)type instance:(int)instance{
    return  modelInstances[type][instance].rotation;
}

- (void) setInstanceMatrix:(int)type instance:(int)instance matrix:(GLKMatrix4)matrix{
    modelInstances[type][instance].matrix = matrix;
}

- (void) setInstancePos:(int)type instance:(int)instance pos:(GLKVector3)pos{
    modelInstances[type][instance].position = pos;
    modelInstances[type][instance].matrix = [self calculateModelMatrix:modelInstances[type][instance]];
}

- (void) setInstanceScale:(int)type instance:(int)instance scale:(GLKVector3)scale{
    modelInstances[type][instance].scale = scale;
    modelInstances[type][instance].matrix = [self calculateModelMatrix:modelInstances[type][instance]];
}

- (void) setInstanceRotation:(int)type instance:(int)instance rotation:(GLKVector3)rotation{
    modelInstances[type][instance].rotation = rotation;
    modelInstances[type][instance].matrix = [self calculateModelMatrix:modelInstances[type][instance]];
}

- (void) setInstanceColor:(int)type instance:(int)instance color:(GLKVector4)color{
    modelInstances[type][instance].color = color;
}

- (GLKVector3) getCameraPos{
    return GLKVector3Add(cameraFocusPos, cameraOffset);
}

- (void) updateViewMatrix{
   
    _viewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(cameraAngle),1.0, 0.0, 0.0);
    _viewMatrix = GLKMatrix4Translate(_viewMatrix, cameraFocusPos.x, cameraFocusPos.y, cameraFocusPos.z);
    _viewMatrix = GLKMatrix4Translate(_viewMatrix, cameraOffset.x, cameraOffset.y, cameraOffset.z);
}

- (void) moveCamera:(GLKVector3)move{
    cameraFocusPos = GLKVector3Add(cameraFocusPos, move);
    if(cameraFocusPos.x > 0){
        cameraFocusPos.x = 0;
    } else if (cameraFocusPos.x < -9){
        cameraFocusPos.x = -9;
    }
    if(cameraFocusPos.z > 0){
        cameraFocusPos.z = 0;
    } else if (cameraFocusPos.z < -9){
        cameraFocusPos.z = -9;
    }
}

// Plays a oneshot of the sound file. Passes the filename as a string to search for.

- (void) playSoundFile:(NSString*)fileName {
    SystemSoundID soundID;
    NSString *soundFile = [[NSBundle mainBundle]
                           pathForResource:fileName ofType:@"mp3" inDirectory:@"Sounds"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)
                                     [NSURL fileURLWithPath:soundFile], & soundID);
    AudioServicesPlaySystemSound(soundID);
}

// Plays the background music and loops it.
- (void) playBackgroundMusic {
    NSString *musicFile = [[NSBundle mainBundle] pathForResource:@"skyBG" ofType:@"mp3" inDirectory:@"Sounds"];
    NSURL *url = [NSURL URLWithString:musicFile];
    backgroundMusic = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    backgroundMusic.numberOfLoops = -1;
    backgroundMusic.volume = 0.7;
    [backgroundMusic play];
    
    NSString *musicFile2 = [[NSBundle mainBundle] pathForResource:@"waterfall" ofType:@"mp3" inDirectory:@"Sounds"];
    NSURL *url2 = [NSURL URLWithString:musicFile2];
    backgroundMusic2 = [[AVAudioPlayer alloc]initWithContentsOfURL:url2 error:nil];
    
    backgroundMusic2.numberOfLoops = -1;
    backgroundMusic2.volume = 0.1;
    [backgroundMusic2 play];
    
    
    NSString *musicFile3 = [[NSBundle mainBundle] pathForResource:@"bird" ofType:@"mp3" inDirectory:@"Sounds"];
    NSURL *url3 = [NSURL URLWithString:musicFile3];
    backgroundMusic3 = [[AVAudioPlayer alloc]initWithContentsOfURL:url3 error:nil];
    
    backgroundMusic3.numberOfLoops = -1;
    backgroundMusic3.volume = 0.3;
    [backgroundMusic3 play];
}

//- (void) clearChars{
//    for(int i = 0; i < charCap;i++){
//        charInstances[i].active = false;
//    }
//}
//
//- (void) addNewChar:(CharInstance)c{
//    for(int i = 0; i < charCap;i++){
//        if(charInstances[i].active == false){
//            charInstances[i] = c;
//            charInstances[i].active = true;
//        }
//    }
//}

@end

