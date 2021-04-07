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
    std::vector<GLuint> vertexIndices, uvIndices, normalIndices;
    //GLuint vertexIndices[] = {};
    
    std::vector<glm::vec3> vertVect;
    std::vector<glm::vec2> uvVect;
    std::vector<glm::vec3> normalVect;
    
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
            vertVect.push_back(vertex);
            
        }else if(strcmp(lineHeader, "vt") == 0){
            glm::vec2 uv;
            fscanf(file, "%f %f\n", &uv.x, &uv.y);
            uvVect.push_back(uv);
        }else if(strcmp(lineHeader, "vn") == 0){
            glm::vec3 normal;
            fscanf(file, "%f %f %f\n", &normal.x, &normal.y, &normal.z);
            normalVect.push_back(normal);
        }else if(strcmp(lineHeader, "f") == 0){
            unsigned int vertexIndex[3], uvIndex[3], normalIndex[3];
            int matches = fscanf(file, "%d/%d/%d %d/%d/%d %d/%d/%d\n", &vertexIndex[0], &uvIndex[0], &normalIndex[0], &vertexIndex[1], &uvIndex[1], &normalIndex[1], &vertexIndex[2], &uvIndex[2], &normalIndex[2]);
            if(matches != 9){
                printf("This parser is incapable of reading this file. %d\n", matches);
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
    
    GLfloat temp_vertices[vertexIndices.size()*3];
    GLfloat temp_uvs[uvIndices.size()*2];
    GLfloat temp_normals[normalIndices.size()*3];
    
    for(unsigned int i=0; i<vertexIndices.size(); i++){
        GLuint curI = vertexIndices[i]-1;
        temp_vertices[(i*3)] = vertVect[curI].x;
        temp_vertices[(i*3)+1] = vertVect[curI].y;
        temp_vertices[(i*3)+2] = vertVect[curI].z;
        printf("\n-->%d: %f %f %f", curI+1, temp_vertices[(i*3)],temp_vertices[(i*3)+1],temp_vertices[(i*3)+2]);
        
        curI = uvIndices[i]-1;
        temp_uvs[(i*2)] = uvVect[curI].x;
        temp_uvs[(i*2)+1] = uvVect[curI].y;
        printf("\n->>%d: %f %f", curI+1, temp_uvs[(i*2)],temp_uvs[(i*2)+1]);
        
        curI = normalIndices[i]-1;
        temp_normals[(i*3)] = normalVect[curI].x;
        temp_normals[(i*3)+1] = normalVect[curI].y;
        temp_normals[(i*3)+2] = normalVect[curI].z;
        printf("%f", normalVect[curI].z);
        printf("\n>>>%d: %f %f %f", curI+1, temp_normals[(i*3)],temp_normals[(i*3)+1],temp_normals[(i*3)+2]);
    }
    /*
    for(unsigned int i=0; i<uvIndices.size(); i++){
        GLuint curI = uvIndices[i];
        temp_uvs[(i*2)] = uvVect[curI].x;
        temp_uvs[(i*2)+1] = uvVect[curI].y;
        printf("\n->>%d: %f %f", curI, temp_uvs[(i*2)],temp_uvs[(i*2)+1]);
    }
    for(unsigned int i=0; i<normalIndices.size(); i++){
        GLuint curI = normalIndices[i];
        temp_normals[(i*3)] = normalVect[curI].x;
        temp_normals[(i*3)+1] = normalVect[curI].y;
        temp_normals[(i*3)+2] = normalVect[curI].z;
        printf("\n>>>%d: %f %f %f", curI, temp_normals[(i*3)],temp_normals[(i*3)+1],temp_normals[(i*3)+2]);
    }
     */
    
    /*
    for(unsigned int i=0; i<vertVect.size(); i++){
        temp_vertices[i*3] = vertVect[i].x;
        temp_vertices[(i*3)+1] = vertVect[i].y;
        temp_vertices[(i*3)+2] = vertVect[i].z;
    }
    
    for(unsigned int i=0; i<uvVect.size(); i++){
        temp_uvs[i*2] = uvVect[i].x;
        temp_uvs[(i*2)+1] = uvVect[i].y;
    }
    
    for(unsigned int i=0; i<normalVect.size(); i++){
        temp_normals[i*3] = normalVect[i].x;
        temp_normals[(i*3)+1] = normalVect[i].y;
        temp_normals[(i*3)+2] = normalVect[i].z;
    }
     */
    
    // Allocate memory for buffers
    if ( vertices != NULL )
    {
        *vertices = (GLfloat *)malloc ( sizeof(GLfloat) * 3 * vertVect.size());
        memcpy ( *vertices, temp_vertices, sizeof ( temp_vertices ) );
        
        for ( unsigned int i = 0; i < vertVect.size(); i++ )
        {
            ( *vertices ) [i] *= scale;
        }
    }
    
    if ( normals != NULL )
    {
        *normals = (GLfloat *)malloc ( sizeof ( GLfloat ) * 3 * normalVect.size() );
        memcpy ( *normals, temp_normals, sizeof ( temp_normals ) );
    }
    
    if ( texCoords != NULL )
    {
        *texCoords = (GLfloat *)malloc ( sizeof ( GLfloat ) * 2 * uvVect.size() );
        memcpy ( *texCoords, temp_uvs, sizeof ( temp_uvs ) ) ;
    }
    
    
    /*
    for(unsigned int i=0; i<vertexIndices.size(); i++){
        printf("count: %d size: %d\n", i, vertexIndices.size());
        
        tempVertIndexArr[i] = vertexIndices[i];
    }*/
    //printf("Size of tempvertindexarr: %d", sizeof(tempVertIndexArr));
    
    GLuint vertexIndexArr[vertexIndices.size()];
    for(unsigned int i=0; i < vertexIndices.size(); i++){
        vertexIndexArr[i] = vertexIndices[i];
    }
    
    *numVerts = vertexIndices.size()*3;
    printf("\nVertex indices count: %lu", vertexIndices.size());
    *indices = (GLuint *)malloc ( sizeof ( GLuint ) * vertexIndices.size());
    
    std::memcpy(*indices, vertexIndexArr, sizeof(vertexIndexArr));
    
    printf("\nmade it to the end");
    return vertexIndices.size();
}
