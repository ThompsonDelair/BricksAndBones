//
//  objloader.cpp
//  BricksAndBones
//
//  Created by socas on 2021-04-04.
//

#include "objloader.hpp"
#include <stdio.h>
#include <string>

GLuint ObjLoader::loadOBJ(
                          const char* path,
                          float scale,
                          GLfloat **vertices,
                          GLfloat **normals,
                          GLfloat **texCoords,
                          GLuint **indices,
                          GLuint *numVerts
                        ){
    std::vector<GLuint> vertexIndices, uvIndices, normalIndices;
    GLuint temp_vertices[] = {};
    GLuint numVert = 0;
    GLuint temp_uvs[] = {};
    GLuint numUV = 0;
    GLuint temp_normals[] = {};
    GLuint numNormal = 0;
    
    FILE *file = fopen(path, "r");
    if(file == NULL){
        printf("Failed to open the file.\n");
        return 0;
    }
    while(1){
        char lineHeader[128];
        int res = fscanf(file, "%s", lineHeader);
        if(res == EOF)
            break;
        if(strcmp(lineHeader, "v") == 0){
            glm::vec3 vertex;
            fscanf(file, "%f %f %f\n", &vertex.x, &vertex.y, &vertex.z);
            numVert = sizeof(temp_vertices) / sizeof(*temp_vertices);
            temp_vertices[numVert] = vertex.x;
            temp_vertices[numVert+1] = vertex.y;
            temp_vertices[numVert+2] = vertex.z;
        }else if(strcmp(lineHeader, "vt") == 0){
            glm::vec2 uv;
            fscanf(file, "%f %f\n", &uv.x, &uv.y);
            numUV = sizeof(temp_uvs) / sizeof(*temp_uvs);
            temp_uvs[numUV] = uv.x;
            temp_uvs[numUV+1] = uv.y;
        }else if(strcmp(lineHeader, "vn") == 0){
            glm::vec3 normal;
            fscanf(file, "%f %f %f\n", &normal.x, &normal.y, &normal.z);
            numNormal = sizeof(temp_normals) / sizeof(*temp_normals);
            temp_normals[numNormal] = normal.x;
            temp_normals[numNormal+1] = normal.y;
            temp_normals[numNormal+2] = normal.z;
        }else if(strcmp(lineHeader, "f") == 0){
            std::string vert1, vert2, vert3;
            unsigned int vertexIndex[3], uvIndex[3], normalIndex[3];
            
            int matches = fscanf(file, "%d%d%d, %d%d%d %d%d%d\n", &vertexIndex[0], &uvIndex[0], &normalIndex[0], &vertexIndex[1], &uvIndex[1], &normalIndex[1], &vertexIndex[2], &uvIndex[2], &normalIndex[2]);
            
            if(matches != 9){
                printf("This parser is incapable of reading this file.\n");
                return 0;
            }
            vertexIndices.push_back(vertexIndex[0]);
            vertexIndices.push_back(vertexIndex[1]);
            vertexIndices.push_back(vertexIndex[2]);
            uvIndices.push_back(uvIndex[0]);
            uvIndices.push_back(uvIndex[1]);
            uvIndices.push_back(uvIndex[2]);
            normalIndices.push_back(normalIndex[0]);
            normalIndices.push_back(normalIndex[1]);
            normalIndices.push_back(normalIndex[2]);
        }
    }
    /*
    GLfloat modelVerts[] = {};
    for(unsigned int i=0; i<vertexIndices.size(); i+=3){
        unsigned int vertexIndex = vertexIndices[i];
        modelVerts[i] = temp_vertices[vertexIndex-1].x;
        modelVerts[i+1] = temp_vertices[vertexIndex-1].y;
        modelVerts[i+2] = temp_vertices[vertexIndex-1].z;
    }
     */
    // Allocate memory for buffers
    if ( vertices != NULL )
    {
        *vertices = (GLfloat *)malloc ( sizeof ( GLfloat ) * 3 * numVert);
        memcpy ( *vertices, temp_vertices, sizeof ( temp_vertices ) );
        
        for ( unsigned int i = 0; i < numVert * 3; i++ )
        {
            ( *vertices ) [i] *= scale;
        }
    }
    
    if ( normals != NULL )
    {
        *normals = (GLfloat *)malloc ( sizeof ( GLfloat ) * 3 * numNormal );
        memcpy ( *normals, temp_normals, sizeof ( temp_normals ) );
    }
    
    if ( texCoords != NULL )
    {
        *texCoords = (GLfloat *)malloc ( sizeof ( GLfloat ) * 2 * numUV );
        memcpy ( *texCoords, temp_uvs, sizeof ( temp_uvs ) ) ;
    }
    
    /*
    for(unsigned int i=0; i<vertexIndices.size(); i++){
        unsigned int vertexIndex = vertexIndices[i];
        glm::vec3 vertex = temp_vertices[vertexIndex-1];
        out_vertices.push_back(vertex);
    }
    
    for(unsigned int i=0; i<uvIndices.size(); i++){
        unsigned int uvIndex = uvIndices[i];
        glm::vec2 uv = temp_uvs[uvIndex-1];
        out_uvs.push_back(uv);
    }
    
    for(unsigned int i=0; i<normalIndices.size(); i++){
        unsigned int normalIndex = normalIndices[i];
        glm::vec3 normal = temp_normals[normalIndex-1];
        out_normals.push_back(normal);
    }
     */
    
    GLuint tempVertArr[] = {};
    
    for(unsigned int i=0; i<vertexIndices.size(); i++){
        tempVertArr[i] = vertexIndices[i];
    }
    
    *numVerts = numVert;
    *indices = (GLuint *)malloc ( sizeof ( GLuint ) * vertexIndices.size() );
    std::memcpy(*indices, tempVertArr, sizeof(tempVertArr));
    
    return vertexIndices.size();
}
