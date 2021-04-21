//
//  Copyright © Borna Noureddin. All rights reserved.
//

#ifndef Renderer_h
#define Renderer_h
#import <GLKit/GLKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "InstanceClass.h"

#import "BricksAndBones-Bridging-Header.h"


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
    GLKVector4 color;
    GLKMatrix4 matrix;
    bool active;
};

typedef struct CharInstance{
    GLKVector3 position;
    GLKVector3 rotation;
    GLKVector3 scale;
    GLKVector4 color;
    int modelType;
    bool active;
};

typedef struct TypeInstance{
    int type;
    int instanceID;
};



@interface Renderer : NSObject

// Properties to interface with iOS UI code
//@property float rotAngle, xRot, yRot;
//@property float xPos, yPos, zPos;
//@property bool isRotating;
@property (readonly) GLKMatrix4 _viewMatrix;
//@property GLKMatrix4 _modelViewMatrix;
@property (readonly) GLKMatrix4 _projectionMatrix;
@property (readonly) GLKVector3 cameraFocusPos;
@property (readonly) float deltaTime;
@property (readonly) float currTime;

- (void)setup:(GLKView *)view;      // Set up GL using the current View
- (void)loadModels;                 // Load models (e.g., cube to rotate)
- (void)update;                     // Update GL
- (void)draw:(CGRect)drawRect;      // Make the GL draw calls
- (GLKMatrix4)calculateModelMatrix:(struct ModelInstance)inst;
- (int) createModelInstance:(int)type pos:(GLKVector3)position rot:(GLKVector3)rotation scale:(GLKVector3)scale;
//- (GLKVector3) screenPosToWorldPlane:(GLKVector2)screenPos;
//- (GLKVector2) worldPosToScreenPos:(GLKVector3)worldPos;
//- (struct ModelInstance) getModelInstanceData:(int)type instance:(int)instance;
- (GLKVector3) getInstancePos:(int)type instance:(int)instance;
- (GLKVector3) getInstanceRot:(int)type instance:(int)instance;
- (void) setInstanceMatrix:(int)type instance:(int)instance matrix:(GLKMatrix4)matrix;
- (void) setInstancePos:(int)type instance:(int)instance pos:(GLKVector3)pos;
- (void) setInstanceScale:(int)type instance:(int)instance scale:(GLKVector3)scale;
- (void) setInstanceRotation:(int)type instance:(int)instance rotation:(GLKVector3)rotation;
- (void) setInstanceColor:(int)type instance:(int)instance color:(GLKVector4)color;
- (void) moveCamera:(GLKVector3)move;
- (void) playSoundFile:(NSString*)fileName;
- (void) playBackgroundMusic;
- (void) deactivateModelInstance:(int)type ID:(int)instanceID;
//- (void) clearChars;
//- (void) addNewChar:(struct CharInstance)c;
- (GLKVector3) getCameraPos;

@end

#endif /* Renderer_h */
