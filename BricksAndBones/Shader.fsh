//
//  Copyright © Borna Noureddin. All rights reserved.
//

#version 300 es
precision highp float;

in vec3 eyeNormal;
in vec4 eyePos;
in vec2 texCoordOut;
out vec4 fragColor;

uniform sampler2D texSampler;

// ### Set up lighting parameters as uniforms
uniform vec3 flashlightPosition;
uniform vec3 diffuseLightPosition;
uniform vec4 diffuseComponent;
uniform float shininess;
uniform vec4 specularComponent;
uniform vec4 ambientComponent;
uniform vec4 colorMod;

// fog parameters
uniform int fogType;
uniform float minDist;
uniform float maxDist;
uniform float density;
uniform vec4 fogColor;

// euler's number
const float e = 2.71828;

// returns a value betweeen 0 and 1
// d is the fragment's distance to camera
float linearFog(float d){
    // fog formula found at docs.microsoft.com/en-us/windows/win32/direct3d9/fog-formula
    // no code was copied, code written from interpretation of formula
    if(d > maxDist)
        return 1.0;
    if(d < minDist)
        return 0.0;
    return (d - minDist) / (maxDist - minDist);
}

// returns value between 0 and 1
// d is the fragment's distance to camera
float expoFog(float d){
    // fog formula found at docs.microsoft.com/en-us/windows/win32/direct3d9/fog-formula
    // no code was copied, code written from interpretation of formula
       
    return 1.0 - 1.0 / pow(e,d * density);
}
// returns value between 0 and 1
// d is the fragment's distance to camera
float expoFog2(float d){
    // fog formula found at docs.microsoft.com/en-us/windows/win32/direct3d9/fog-formula
    // no code was copied, code written from interpretation of formula
    
    return 1.0 - 1.0 / pow(e,pow(d * density,2.0));
}

void main()
{
    // ### Calculate phong model using lighting parameters and interpolated values from vertex shader
    vec4 ambient = ambientComponent;

    vec3 N = normalize(eyeNormal);
    float nDotVP = max(0.0, dot(N, normalize(diffuseLightPosition)));
    vec4 diffuse = diffuseComponent * nDotVP;

    vec3 E = normalize(-eyePos.xyz);
    vec3 L = normalize(flashlightPosition - eyePos.xyz);
    vec3 H = normalize(L+E);
    float Ks = pow(max(dot(N, H), 0.0), shininess);
    vec4 specular = Ks*specularComponent;
    if( dot(L, N) < 0.0 ) {
        specular = vec4(0.0, 0.0, 0.0, 1.0);
    }

    // caculate fog based off fog type
    float f;
    float d = length(eyePos.xyz);
    if(fogType == 0){
        f = 0.0;
    } else if(fogType == 1){
        f = linearFog(d);
    } else if(fogType == 2){
        f = expoFog(d);
    } else if(fogType == 3){
        f = expoFog2(d);
    }

    vec4 texColor = texture(texSampler, texCoordOut);
    vec4 baseColor = texColor * colorMod;
    baseColor.a = colorMod.a;
    
    // ### Modify this next line to modulate texture with calculated phong shader values
    fragColor = (ambient + diffuse + specular) * baseColor;
    
    // lerp between color with no fog, and total fog color using f
    fragColor = mix(fragColor,fogColor,f);
        
    fragColor.a = 1.0;
}
