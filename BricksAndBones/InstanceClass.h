//
//  InstanceClass.h
//  BricksAndBones
//
//  Created by socas on 2021-04-21.
//

#ifndef InstanceClass_h
#define InstanceClass_h

#import <GLKit/GLKit.h>
@interface InstanceClass : NSObject{
    @public
    GLKVector3 position;
    GLKVector3 rotation;
    GLKVector3 scale;
    GLKVector4 color;
    GLKMatrix4 matrix;
    bool active;
}
@end

@implementation InstanceClass



@end

#endif /* InstanceClass_h */
