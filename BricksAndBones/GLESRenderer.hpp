//
//  Copyright © Borna Noureddin. All rights reserved.
//

#ifndef GLESRenderer_hpp
#define GLESRenderer_hpp

#include <stdlib.h>

#include <OpenGLES/ES3/gl.h>

class GLESRenderer
{
public:
    char *LoadShaderFile(const char *shaderFileName);
    GLuint LoadShader(GLenum type, const char *shaderSrc);
    GLuint LoadProgram(const char *vertShaderSrc, const char *fragShaderSrc);
    GLuint LinkProgram(GLuint programObject);

    int GenCube(float scale, GLfloat **vertices, GLfloat **normals,
                GLfloat **texCoords, GLuint **indices, GLuint *numVerts);
    int GenSphere(int numSlices, float radius, GLfloat **vertices, GLfloat **normals,
                  GLfloat **texCoords, GLuint **indices, GLuint *numVerts);
    int GenPlane(float scale, GLfloat **vertices, GLfloat **normals,
                               GLfloat **texCoords, GLuint **indices, GLuint *numVerts);
private:
    GLuint vertexShader, fragmentShader;

};

#endif /* GLESRenderer_hpp */
