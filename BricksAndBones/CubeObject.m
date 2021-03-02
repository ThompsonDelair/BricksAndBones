//
//  CubeObject.m
//  BricksAndBones
//
//  Created by socas on 2021-03-01.
//

#import "CubeObject.h"
#define M_TAU (2*M_PI)

static BOOL initialized = NO;
static GLKVector3 vertices[8];
static GLKVector4 colors[8];
static GLKVector3 triangleVertices[36];
static GLKVector4 triangleColors[36];
static GLKBaseEffect *effect;

@implementation CubeObject
@synthesize position, rotation, scale;

- (id)init{
    self = [super init];
    if(self){
        position = GLKVector3Make(0,0,0);
        rotation = GLKVector3Make(0,0,0);
        scale = GLKVector3Make(1,1,1);
    }
    return self;
}
+ (void) initialize{
    if(!initialized){
        vertices[0] = GLKVector3Make(-1, -1, -1);
        vertices[1] = GLKVector3Make(1, -1, 1);
        vertices[2] = GLKVector3Make(1, 1, 1);
        vertices[3] = GLKVector3Make(-1, 1, 1);
        vertices[4] = GLKVector3Make(-1, -1, -1);
        vertices[5] = GLKVector3Make(1, -1, -1);
        vertices[6] = GLKVector3Make(1, 1, -1);
        vertices[7] = GLKVector3Make(-1, 1, -1);
        
        colors[0] = GLKVector4Make(1, 0, 0, 1);
        colors[1] = GLKVector4Make(1, 0, 0, 1);
        colors[2] = GLKVector4Make(1, 0, 0, 1);
        colors[3] = GLKVector4Make(1, 0, 0, 1);
        colors[4] = GLKVector4Make(1, 0, 0, 1);
        colors[5] = GLKVector4Make(1, 0, 0, 1);
        colors[6] = GLKVector4Make(1, 0, 0, 1);
        colors[7] = GLKVector4Make(1, 0, 0, 1);
    }
    
    int vertIndices[36] = {
        0,1,2,
        0,2,3,
        1,5,6,
        1,6,2,
        5,4,7,
        5,7,6,
        4,0,3,
        4,3,7,
        3,2,6,
        3,6,7,
        4,5,1,
        4,1,0,
    };
    
    for (int i=0; i<36; i++){
        triangleVertices[i] = vertices[vertIndices[i]];
        triangleColors[i] = colors[vertIndices[i]];
    }
    
    effect  = [[GLKBaseEffect alloc] init];
    
    initialized = YES;
}

- (void)draw
{
    GLKMatrix4 yRotMatrix = GLKMatrix4MakeYRotation(rotation.x);
    GLKMatrix4 xRotMatrix = GLKMatrix4MakeXRotation(rotation.y);
    GLKMatrix4 zRotMatrix = GLKMatrix4MakeXRotation(rotation.z);
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(scale.x, scale.y, scale.z);
    GLKMatrix4 transMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
    
    GLKMatrix4 modelMatrix =
                            GLKMatrix4Multiply(transMatrix,
                            GLKMatrix4Multiply(scaleMatrix,
                            GLKMatrix4Multiply(zRotMatrix,
                            GLKMatrix4Multiply(yRotMatrix,
                                               xRotMatrix))));
    
    
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0,0,3,0,0,0,0,1,0);
    
    
    effect.transform.modelviewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
    
    effect.transform.projectionMatrix = GLKMatrix4MakePerspective(0.125*M_TAU, 1, 2, -1);
    
    [effect prepareToDraw];
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribPosition, 4, GL_FLOAT, GL_FALSE, 0, triangleVertices);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, triangleColors);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}

@end
