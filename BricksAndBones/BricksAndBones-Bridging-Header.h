//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "Renderer.h"

#ifndef MyEnum
#define MyEnum
typedef enum : NSUInteger {
    TEST_CUBE_RED,
    TEST_CUBE_BLUE,
    TEST_CUBE_GREEN,
    TEST_CUBE_PURP,
    TEST_CUBE_PINK,
    TEST_CUBE_YELL,
    TEST_CUBE_GRAD,
    NUM_MODEL_TYPES
} ModelTypes;

#endif /* Renderer_h */
