//
//  objloader.hpp
//  BricksAndBones
//
//  Created by socas on 2021-04-04.
//

#ifndef objloader_hpp
#define objloader_hpp

#include <stdio.h>
#include <vector>
#include <OpenGLES/ES3/gl.h>
#include "glm/vec2.hpp"
#include "glm/vec3.hpp"

class ObjLoader{
public:
    GLuint loadOBJ(
                   const char* path,
                   float scale,
                   GLfloat **vertices,
                   GLfloat **normals,
                   GLfloat **texCoords,
                   GLuint **indices,
                   GLuint *numVerts
                 );
};
#endif /* objloader_hpp */
