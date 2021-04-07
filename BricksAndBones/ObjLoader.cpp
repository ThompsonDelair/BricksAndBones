//
//  objloader.cpp
//  BricksAndBones
//
//  Created by socas on 2021-04-04.
//

#include "objloader.hpp"
#include <stdio.h>
#include <stdlib.h>
#include <string>

#include <fstream>
#include <iostream>

GLuint ObjLoader::loadOBJ(
                          const char* path,
                          float scale,
                          GLfloat **vertices,
                          GLfloat **normals,
                          GLfloat **texCoords,
                          GLuint **indices,
                          GLuint *numVerts
                        ){
    //std::vector<GLuint> vertexIndices, uvIndices, normalIndices;
    GLuint vertexIndices[] = {};
    GLfloat temp_vertices[] = {};
    GLfloat temp_uvs[] = {};
    GLfloat temp_normals[] = {};
    int numVertIndex = 0;
    int numVert = 0;
    int numUV = 0;
    int numNormal = 0;
    
    
    FILE * file = fopen(path, "r");
    if(file == NULL){
        perror("Failed to open the file.\n");
        return 0;
    }
    int counter = 0;
    while(1){
        char lineHeader[128];
        int res = fscanf(file, "%s", lineHeader);
        if(res == EOF){
            printf("Exiting while loop");
            break;
        }
            
        if(strcmp(lineHeader, "v") == 0){
            glm::vec3 vertex;
            fscanf(file, "%f %f %f\n", &vertex.x, &vertex.y, &vertex.z);
            printf("NUMVERT: %d", numVert);
            temp_vertices[numVert] = vertex.x;
            temp_vertices[numVert+1] = vertex.y;
            temp_vertices[numVert+2] = vertex.z;
            printf("\n%f %f %f\n", temp_vertices[numVert], temp_vertices[numVert+1], temp_vertices[numVert+2]);
            numVert++;
        }else if(strcmp(lineHeader, "vt") == 0){
            glm::vec2 uv;
            fscanf(file, "%f %f\n", &uv.x, &uv.y);
            temp_uvs[numUV*3] = uv.x;
            temp_uvs[numUV*3+1] = uv.y;
            printf("\n%f %f\n", temp_uvs[numUV], temp_uvs[numUV+1]);
            numUV++;
        }else if(strcmp(lineHeader, "vn") == 0){
            glm::vec3 normal;
            fscanf(file, "%f %f %f\n", &normal.x, &normal.y, &normal.z);
            temp_normals[numNormal*3] = normal.x;
            temp_normals[numNormal*3+1] = normal.y;
            temp_normals[numNormal*3+2] = normal.z;
            printf("\n%f %f %f\n", temp_normals[numNormal], temp_normals[numNormal+1], temp_normals[numNormal+2]);
            numNormal++;
        }else if(strcmp(lineHeader, "f") == 0){
            unsigned int vertexIndex[3], uvIndex[3], normalIndex[3];
            int matches = fscanf(file, "%d/%d/%d %d/%d/%d %d/%d/%d\n", &vertexIndex[0], &uvIndex[0], &normalIndex[0], &vertexIndex[1], &uvIndex[1], &normalIndex[1], &vertexIndex[2], &uvIndex[2], &normalIndex[2]);
            if(matches != 9){
                printf("This parser is incapable of reading this file. %d\n", matches);
                return 0;
            }
            vertexIndices[numVertIndex*3] = vertexIndex[0];
            vertexIndices[numVertIndex*3+1] = vertexIndex[1];
            vertexIndices[numVertIndex*3+2] = vertexIndex[2];
            numVertIndex++;
            /*
            vertexIndices.push_back(vertexIndex[0]);
            vertexIndices.push_back(vertexIndex[1]);
            vertexIndices.push_back(vertexIndex[2]);
             */
            /*
            uvIndices.push_back(uvIndex[0]);
            uvIndices.push_back(uvIndex[1]);
            uvIndices.push_back(uvIndex[2]);
            normalIndices.push_back(normalIndex[0]);
            normalIndices.push_back(normalIndex[1]);
            normalIndices.push_back(normalIndex[2]);
            */
        }
    }
    
    // Allocate memory for buffers
    if ( vertices != NULL )
    {
        *vertices = (GLfloat *)malloc ( sizeof(GLfloat) * 3 * numVert);
        memcpy ( *vertices, temp_vertices, sizeof ( temp_vertices ) );
        
        for ( unsigned int i = 0; i < numVert; i++ )
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
        printf("count: %d size: %d\n", i, vertexIndices.size());
        
        tempVertIndexArr[i] = vertexIndices[i];
    }*/
    //printf("Size of tempvertindexarr: %d", sizeof(tempVertIndexArr));
    
    *numVerts = numVert;
    printf("\n%d\n", numVertIndex);
    *indices = (GLuint *)malloc ( sizeof ( GLuint ) * numVertIndex);
    std::memcpy(*indices, vertexIndices, sizeof(vertexIndices));
    
    printf("made it to the end");
    return numVertIndex;
}
