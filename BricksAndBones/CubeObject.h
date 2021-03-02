//
//  Header.h
//  BricksAndBones
//
//  Created by socas on 2021-03-01.
//

#ifndef Header_h
#define Header_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface CubeObject : NSObject{
    GLKVector3 position, rotation, scale;
}
@property GLKVector3 position, rotation, scale;
- (void)draw;
@end

#endif /* Header_h */
