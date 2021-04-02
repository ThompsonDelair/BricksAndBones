//
//  Copyright © Borna Noureddin. All rights reserved.
//

#ifndef Renderer_h
#define Renderer_h
#import <GLKit/GLKit.h>

typedef struct ModelData{
    // model
    float *vertices, *normals, *texCoords;
    GLuint *indices, numIndices, numVerts;
    
    // GLES buffer IDs
    GLuint vao;
    GLuint vbos[3];
    GLuint ebo;
        
    // GLES variables
    GLuint texture;
};

typedef struct ModelInstance{
    GLKVector3 position;
    GLKVector3 rotation;
    GLKVector3 scale;
    
    GLKMatrix4 modelMatrix;
    
//    void calculateModelMatrix(){
//        GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(rotation.x);
//        GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(rotation.y);
//        GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(rotation.z);
//        GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(scale.x, scale.y, scale.z);
//        GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
//
//        modelMatrix =
//             GLKMatrix4Multiply(translateMatrix,
//             GLKMatrix4Multiply(scaleMatrix,
//             GLKMatrix4Multiply(zRotationMatrix,
//             GLKMatrix4Multiply(yRotationMatrix,
//                                xRotationMatrix))));
//    }
};

@interface Renderer : NSObject

// Properties to interface with iOS UI code
//@property float rotAngle, xRot, yRot;
//@property float xPos, yPos, zPos;
//@property bool isRotating;
@property (readonly) GLKMatrix4 _viewMatrix;
//@property GLKMatrix4 _modelViewMatrix;
@property (readonly) GLKMatrix4 _projectionMatrix;



- (void)setup:(GLKView *)view;      // Set up GL using the current View
- (void)loadModels;                 // Load models (e.g., cube to rotate)
- (void)update;                     // Update GL
- (void)draw:(CGRect)drawRect;      // Make the GL draw calls
- (GLKMatrix4)calculateModelMatrix:(struct ModelInstance)inst;
- (int) createModelInstance:(int)type pos:(GLKVector3)position rot:(GLKVector3)rotation scale:(GLKVector3)scale;
//- (GLKVector3) screenPosToWorldPlane:(GLKVector2)screenPos;
//- (GLKVector2) worldPosToScreenPos:(GLKVector3)worldPos;
- (struct ModelInstance) getModelInstanceData:(int)type instance:(int)instance;
- (void) setInstancePos:(int)type instance:(int)instance pos:(GLKVector3)pos;

@end



#endif /* Renderer_h */
