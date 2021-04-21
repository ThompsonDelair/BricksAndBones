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


bool is_near(float v1, float v2){
    return fabs(v1-v2) < 0.01f;
}

bool getSimilarVertexIndex(
                           glm::vec3 & in_vertex,
                           glm::vec2 & in_uv,
                           glm::vec3 & in_normal,
                           std::vector<glm::vec3> & out_vertices,
                           std::vector<glm::vec2> & out_uvs,
                           std::vector<glm::vec3> & out_normals,
                           unsigned short & result){
    for(unsigned int i=0; i<out_vertices.size(); i++){
        if(
           is_near(in_vertex.x, out_vertices[i].x) &&
           is_near(in_vertex.y, out_vertices[i].y) &&
           is_near(in_vertex.z, out_vertices[i].z) &&
           is_near(in_uv.x, out_uvs[i].x) &&
           is_near(in_uv.y, out_uvs[i].y) &&
           is_near(in_normal.x, out_normals[i].x) &&
           is_near(in_normal.y, out_normals[i].y) &&
           is_near(in_normal.z, out_normals[i].z)
           ){
            result = i;
            return true;
        }
    }
    return false;
}

void indexVBO(
              std::vector<glm::vec3> & in_vertices,
              std::vector<glm::vec2> & in_uvs,
              std::vector<glm::vec3> & in_normals,
              std::vector<unsigned short> & out_indices,
              std::vector<glm::vec3> & out_vertices,
              std::vector<glm::vec2> & out_uvs,
              std::vector<glm::vec3> & out_normals
              ){
    for ( unsigned int i=0; i<in_vertices.size(); i++){
        unsigned short index;
        bool found = getSimilarVertexIndex(in_vertices[i], in_uvs[i], in_normals[i], out_vertices, out_uvs, out_normals, index);
        
        if(found){
            out_indices.push_back(index);
        }else{
            out_vertices.push_back(in_vertices[i]);
            out_uvs.push_back(in_uvs[i]);
            out_normals.push_back(in_normals[i]);
            out_indices.push_back((unsigned short) out_vertices.size() - 1);
        }
    }
}

GLuint ObjLoader::loadOBJ(
                          const char* path,
                          float scale,
                          GLfloat **vertices,
                          GLfloat **normals,
                          GLfloat **texCoords,
                          GLuint **indices,
                          GLuint *numVerts
                        ){
    std::vector<unsigned int> vertexIndices, uvIndices, normalIndices;
    //GLuint vertexIndices[] = {};
    
    std::vector<glm::vec3> vertVect;
    std::vector<glm::vec2> uvVect;
    std::vector<glm::vec3> normalVect;
    
    FILE * file = fopen(path, "r");
    if(file == NULL){
        perror("Failed to open the file.\n");
        return 0;
    }
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
                fclose(file);
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
        }else{
            char endlineBuffer[1000];
            fgets(endlineBuffer, 1000, file);
        }
    }
    
    /*
    GLfloat temp_vertices[vertexIndices.size()*3];
    GLfloat temp_uvs[uvIndices.size()*2];
    GLfloat temp_normals[normalIndices.size()*3];
    GLuint i = 0;
    for(i=0; i<vertexIndices.size(); i++){
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
     */
    std::vector<glm::vec3> temp_vertices;
    std::vector<glm::vec2> temp_uvs;
    std::vector<glm::vec3> temp_normals;
    
    for(unsigned int i=0; i<vertexIndices.size(); i++){
        unsigned int vertexIndex = vertexIndices[i];
        unsigned int uvIndex = uvIndices[i];
        unsigned int normalIndex = normalIndices[i];
        
        glm::vec3 vertex = vertVect[vertexIndex-1];
        glm::vec2 uv = uvVect[uvIndex-1];
        glm::vec3 normal = normalVect[normalIndex-1];
        
        temp_vertices.push_back(vertex);
        temp_uvs.push_back(uv);
        temp_normals.push_back(normal);
    }
    
    std::vector<unsigned short> tempIndices;
    std::vector<glm::vec3> indexed_vertices;
    std::vector<glm::vec2> indexed_uvs;
    std::vector<glm::vec3> indexed_normals;
    indexVBO(temp_vertices, temp_uvs, temp_normals, tempIndices, indexed_vertices, indexed_uvs, indexed_normals);
    
    GLfloat out_vertices[10000] = { };
    GLfloat out_uvs[10000] = { };
    GLfloat out_normals[10000] = { };
    GLuint out_indices[10000] = { };
    
    for(unsigned int i=0; i<indexed_vertices.size(); i++){
        out_vertices[(i*3)] = indexed_vertices[i].x;
        out_vertices[(i*3)+1] = indexed_vertices[i].y;
        out_vertices[(i*3)+2] = indexed_vertices[i].z;
        out_uvs[(i*2)] = indexed_uvs[i].x;
        out_uvs[(i*2)+1] = indexed_uvs[i].y;
        out_normals[(i*3)] = indexed_normals[i].x;
        out_normals[(i*3)+1] = indexed_normals[i].y;
        out_normals[(i*3)+2] = indexed_normals[i].z;
    }
    for(unsigned int i=0; i<tempIndices.size(); i++){
        out_indices[i] = tempIndices[i];
    }
    
    // Allocate memory for buffers
    if ( vertices != NULL )
    {
        *vertices = (GLfloat *)malloc ( sizeof(GLfloat) * 3 * indexed_vertices.size());
        memcpy ( *vertices, out_vertices, sizeof(GLfloat) * 3 * indexed_vertices.size() );
        
        for ( unsigned int i = 0; i < indexed_vertices.size(); i++ )
        {
            ( *vertices ) [i] *= scale;
        }
    }
    
    if ( texCoords != NULL )
    {
        *texCoords = (GLfloat *)malloc ( sizeof ( GLfloat ) * 2 * indexed_vertices.size() );
        memcpy ( *texCoords, out_uvs, sizeof ( GLfloat ) * 2 * indexed_vertices.size() ) ;
    }
    
    if ( normals != NULL )
    {
        *normals = (GLfloat *)malloc ( sizeof ( GLfloat ) * 3 * indexed_vertices.size() );
        memcpy ( *normals, out_normals, sizeof ( GLfloat ) * 3 * indexed_vertices.size() );
    }
    
    *numVerts = indexed_vertices.size();
    *indices = (GLuint *)malloc ( sizeof ( GLuint ) * tempIndices.size());
    std::memcpy(*indices, out_indices, sizeof(GLuint) * tempIndices.size());
    fclose(file);
    printf("\nmade it to the end");
    return vertexIndices.size();
}
