//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
#ifndef ACLS_HELPERS
#define ACLS_HELPERS
    #include "UnityCG.cginc"
    #include "AutoLight.cginc"
    #include "Lighting.cginc"
    #include "UnityStandardBRDF.cginc"
    #pragma warning (error : 3206) // implicit truncation

    //// cites grappass, depthbuffer, blur, distortion
    // Amplify shader generator
    // https://forum.unity.com/threads/simple-optimized-blur-shader.185327/
    // https://blog.demofox.org/2015/08/19/gaussian-blur/
    // https://observablehq.com/@s4l4x/efficient-gaussian-blur-with-linear-sampling
    // https://www.edraflame.com/blog/custom-shader-depth-texture-sampling/
    // https://forum.unity.com/threads/reconstructing-world-space-position-from-depth-texture.1139599/
    // https://forum.unity.com/threads/accessing-depth-buffer-from-a-surface-shader.404380/
    // https://www.cyanilux.com/tutorials/depth/
    // UNITY_MATRIX_P._m11 matrix usage: liltoon,  https://forum.unity.com/threads/need-help-fixed-size-billboard.688054/
    // https://catlikecoding.com/unity/tutorials/flow/looking-through-water/
    // etc
    // screen blur sample counts
    // #define SCREEN_UV_BLUR_RATIO 0.0152 /// 0.00152 = 2 * 1 * tand(5 * 0.5 * 3.14 / 180) // https://docs.unity3d.com/Manual/FrustumSizeAtDistance.html
    #define BLUR_SAMPLE_RADIUS 6.0    // Control how many samples points around the pixel and Is expensive. Raise if you really want smoother blur.
    #define BLUR_SAMPLES BLUR_SAMPLE_RADIUS*2.0+1.0
    #define BLUR_SIGMA BLUR_SAMPLE_RADIUS * .25
    #define BLUR_SAMPLE_SPLITS 1 / BLUR_SAMPLE_RADIUS

    // generate kernels here: http://demofox.org/gauss.html
    static float blurKernel_11x11[] = {
        0.0000,	0.0000,	0.0000,	0.0001,	0.0003,	0.0003,	0.0003,	0.0001,	0.0000,	0.0000,	0.0000,
        0.0000,	0.0001,	0.0003,	0.0009,	0.0018,	0.0022,	0.0018,	0.0009,	0.0003,	0.0001,	0.0000,
        0.0000,	0.0003,	0.0014,	0.0042,	0.0080,	0.0099,	0.0080,	0.0042,	0.0014,	0.0003,	0.0000,
        0.0001,	0.0009,	0.0042,	0.0123,	0.0234,	0.0290,	0.0234,	0.0123,	0.0042,	0.0009,	0.0001,
        0.0003,	0.0018,	0.0080,	0.0234,	0.0445,	0.0551,	0.0445,	0.0234,	0.0080,	0.0018,	0.0003,
        0.0003,	0.0022,	0.0099,	0.0290,	0.0551,	0.0682,	0.0551,	0.0290,	0.0099,	0.0022,	0.0003,
        0.0003,	0.0018,	0.0080,	0.0234,	0.0445,	0.0551,	0.0445,	0.0234,	0.0080,	0.0018,	0.0003,
        0.0001,	0.0009,	0.0042,	0.0123,	0.0234,	0.0290,	0.0234,	0.0123,	0.0042,	0.0009,	0.0001,
        0.0000,	0.0003,	0.0014,	0.0042,	0.0080,	0.0099,	0.0080,	0.0042,	0.0014,	0.0003,	0.0000,
        0.0000,	0.0001,	0.0003,	0.0009,	0.0018,	0.0022,	0.0018,	0.0009,	0.0003,	0.0001,	0.0000,
        0.0000,	0.0000,	0.0000,	0.0001,	0.0003,	0.0003,	0.0003,	0.0001,	0.0000,	0.0000,	0.0000,};

    static float blurKernel_9x9[] = {
        0.0000,	0.0000,	0.0000,	0.0001,	0.0001,	0.0001,	0.0000,	0.0000,	0.0000,
        0.0000,	0.0000,	0.0004,	0.0014,	0.0023,	0.0014,	0.0004,	0.0000,	0.0000,
        0.0000,	0.0004,	0.0037,	0.0146,	0.0232,	0.0146,	0.0037,	0.0004,	0.0000,
        0.0001,	0.0014,	0.0146,	0.0584,	0.0926,	0.0584,	0.0146,	0.0014,	0.0001,
        0.0001,	0.0023,	0.0232,	0.0926,	0.1466,	0.0926,	0.0232,	0.0023,	0.0001,
        0.0001,	0.0014,	0.0146,	0.0584,	0.0926,	0.0584,	0.0146,	0.0014,	0.0001,
        0.0000,	0.0004,	0.0037,	0.0146,	0.0232,	0.0146,	0.0037,	0.0004,	0.0000,
        0.0000,	0.0000,	0.0004,	0.0014,	0.0023,	0.0014,	0.0004,	0.0000,	0.0000,
        0.0000,	0.0000,	0.0000,	0.0001,	0.0001,	0.0001,	0.0000,	0.0000,	0.0000,};

    static float blurKernel_13[]  = {0.0002,	0.0010,	0.0040,	0.0121,	0.0268,	0.0432,	0.0506,	0.0432,	0.0268,	0.0121,	0.0040,	0.0010,	0.0002,};
    static float blurKernel_11[]  = {0.0003,	0.0022,	0.0099,	0.0290,	0.0551,	0.0682,	0.0551,	0.0290,	0.0099,	0.0022,	0.0003,};
    static float blurKernel_9[]   = {0.0001,	0.0023,	0.0232,	0.0926,	0.1466,	0.0926,	0.0232,	0.0023,	0.0001,};

    // inventory
    uniform int _UseInventory;
    uniform float _InventoryStride;
    uniform float _InventoryItem01Animated;
    uniform float _InventoryItem02Animated;
    uniform float _InventoryItem03Animated;
    uniform float _InventoryItem04Animated;
    uniform float _InventoryItem05Animated;
    uniform float _InventoryItem06Animated;
    uniform float _InventoryItem07Animated;
    uniform float _InventoryItem08Animated;
    uniform float _InventoryItem09Animated;
    uniform float _InventoryItem10Animated;
    uniform float _InventoryItem11Animated;
    uniform float _InventoryItem12Animated;
    uniform float _InventoryItem13Animated;
    uniform float _InventoryItem14Animated;
    uniform float _InventoryItem15Animated;
    uniform float _InventoryItem16Animated;

    struct appdata {
        float4 vertex   : POSITION;
        float3 normal   : NORMAL;
        float4 tangent  : TANGENT;
        float2 uv0      : TEXCOORD0;
        float2 uv1      : TEXCOORD1;
        float2 uv2      : TEXCOORD2;
        float2 uv3      : TEXCOORD3;
        float4 color    : COLOR;
        uint vertexId   : SV_VertexID;
        float3 objFront : TEXCOORD4;
        float3 objRight : TEXCOORD5;
        UNITY_VERTEX_INPUT_INSTANCE_ID
    };

    struct emptyAppdata
    {
        float4 vertex : POSITION;
        float2 uv0      : TEXCOORD0;
        float2 uv1      : TEXCOORD1;
        float2 uv2      : TEXCOORD2;
        float2 uv3      : TEXCOORD3;
        UNITY_VERTEX_INPUT_INSTANCE_ID
    };

    struct depthAppdata
    {
        float4 vertex   : POSITION;
        float3 normal   : NORMAL;
        float2 uv0      : TEXCOORD0;
        float2 uv1      : TEXCOORD1;
        float2 uv2      : TEXCOORD2;
        float2 uv3      : TEXCOORD3;
        UNITY_VERTEX_INPUT_INSTANCE_ID
    };

    struct v2g
    {
        float4 pos      : SV_POSITION;
        float4 color    : COLOR0;
        float4 center   : TEXCOORD0;
        float3 worldPos : TEXCOORD1;
        float3 wNormal  : TEXCOORD2;
        float4 tangent  : TEXCOORD3;
        float3 biTangent   : TEXCOORD4;
        float3 vertexLighting    : TEXCOORD5;
        float3 dirGI        : TEXCOORD6;
        float4 uv01         : TEXCOORD7;
        float4 uv02         : TEXCOORD8;
        float4 screenPos    : TEXCOORD9;
        float3 vertTo0      : TEXCOORD10;
        float4 grabPos      : TEXCOORD11;
        UNITY_FOG_COORDS(12)
        UNITY_SHADOW_COORDS(13)
        // LIGHTING_COORDS(11,12)
        float eyeDepth : TEXCOORD14;
        float3 objFront : TEXCOORD15;
        float3 objRight : TEXCOORD16;
        UNITY_VERTEX_INPUT_INSTANCE_ID
        UNITY_VERTEX_OUTPUT_STEREO
    };

    //// test "_centroid" for MSAA workarounds
    struct g2f {
        float4 pos      : SV_POSITION;
        float4 color    : COLOR0;
        float4 center   : TEXCOORD0;
        float3 worldPos : TEXCOORD1;
        float3 wNormal  : TEXCOORD2;
        float4 tangent  : TEXCOORD3;
        float3 biTangent   : TEXCOORD4;
        float3 vertexLighting    : TEXCOORD5;
        float3 dirGI        : TEXCOORD6;
        float4 uv01         : TEXCOORD7;
        float4 uv02         : TEXCOORD8;
        //// ps1 uv dis-correction (Affine texture mapping)
        // noperspective float4 uv01         : TEXCOORD7;
        // noperspective float4 uv02         : TEXCOORD8;
        float4 screenPos    : TEXCOORD9;
        float3 vertTo0      : TEXCOORD10;
        float4 grabPos      : TEXCOORD11;
        UNITY_FOG_COORDS(12)
        UNITY_SHADOW_COORDS(13)
        // LIGHTING_COORDS(11,12)
        float eyeDepth : TEXCOORD14;
        float3 objFront : TEXCOORD15;
        float3 objRight : TEXCOORD16;
        UNITY_VERTEX_INPUT_INSTANCE_ID
        UNITY_VERTEX_OUTPUT_STEREO
    };

    struct emptyV2f
    {
        float4 vertex   : SV_POSITION;
        float4 uv01     : TEXCOORD0;
        float4 uv02     : TEXCOORD1;
        float3 normal   : NORMAL;
        UNITY_VERTEX_INPUT_INSTANCE_ID
        UNITY_VERTEX_OUTPUT_STEREO
    };

    struct depthV2f
    {
        float4 pos      : SV_POSITION;
        float4 uv01     : TEXCOORD0;
        float4 uv02     : TEXCOORD1;
        float3 worldPos : TEXCOORD2;
        float3 wNormal  : NORMAL;
        UNITY_SHADOW_COORDS(3)
        UNITY_VERTEX_INPUT_INSTANCE_ID
        UNITY_VERTEX_OUTPUT_STEREO
    };



    #include "./extra_includes/ACLS_PENADAPTOR.cginc"

    //// ERROR.mdl
    #if !defined(SCREEN_TEX_MACRO) && !defined(UNITY_COMMON_INCLUDED) // Avoid conflict with actual URP includes
    #define SCREEN_TEX_MACRO

    // From SRP Core D3D11.hlsl

    #define TEXTURE2D(textureName)                Texture2D textureName
    #define TEXTURE2D_ARRAY(textureName)          Texture2DArray textureName
    #define TEXTURECUBE(textureName)              TextureCube textureName
    #define TEXTURECUBE_ARRAY(textureName)        TextureCubeArray textureName
    #define TEXTURE3D(textureName)                Texture3D textureName

    #define TEXTURE2D_FLOAT(textureName)          TEXTURE2D(textureName)
    #define TEXTURE2D_ARRAY_FLOAT(textureName)    TEXTURE2D_ARRAY(textureName)
    #define TEXTURECUBE_FLOAT(textureName)        TEXTURECUBE(textureName)
    #define TEXTURECUBE_ARRAY_FLOAT(textureName)  TEXTURECUBE_ARRAY(textureName)
    #define TEXTURE3D_FLOAT(textureName)          TEXTURE3D(textureName)

    #define TEXTURE2D_HALF(textureName)           TEXTURE2D(textureName)
    #define TEXTURE2D_ARRAY_HALF(textureName)     TEXTURE2D_ARRAY(textureName)
    #define TEXTURECUBE_HALF(textureName)         TEXTURECUBE(textureName)
    #define TEXTURECUBE_ARRAY_HALF(textureName)   TEXTURECUBE_ARRAY(textureName)
    #define TEXTURE3D_HALF(textureName)           TEXTURE3D(textureName)

    #define TEXTURE2D_SHADOW(textureName)         TEXTURE2D(textureName)
    #define TEXTURE2D_ARRAY_SHADOW(textureName)   TEXTURE2D_ARRAY(textureName)
    #define TEXTURECUBE_SHADOW(textureName)       TEXTURECUBE(textureName)
    #define TEXTURECUBE_ARRAY_SHADOW(textureName) TEXTURECUBE_ARRAY(textureName)

    #define RW_TEXTURE2D(type, textureName)       RWTexture2D<type> textureName
    #define RW_TEXTURE2D_ARRAY(type, textureName) RWTexture2DArray<type> textureName
    #define RW_TEXTURE3D(type, textureName)       RWTexture3D<type> textureName

    #define SAMPLER(samplerName)                  SamplerState samplerName
    #define SAMPLER_CMP(samplerName)              SamplerComparisonState samplerName
    #define ASSIGN_SAMPLER(samplerName, samplerValue) samplerName = samplerValue

    #define TEXTURE2D_PARAM(textureName, samplerName)                 TEXTURE2D(textureName),         SAMPLER(samplerName)
    #define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)           TEXTURE2D_ARRAY(textureName),   SAMPLER(samplerName)
    #define TEXTURECUBE_PARAM(textureName, samplerName)               TEXTURECUBE(textureName),       SAMPLER(samplerName)
    #define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)         TEXTURECUBE_ARRAY(textureName), SAMPLER(samplerName)
    #define TEXTURE3D_PARAM(textureName, samplerName)                 TEXTURE3D(textureName),         SAMPLER(samplerName)

    #define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)          TEXTURE2D(textureName),         SAMPLER_CMP(samplerName)
    #define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)    TEXTURE2D_ARRAY(textureName),   SAMPLER_CMP(samplerName)
    #define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)        TEXTURECUBE(textureName),       SAMPLER_CMP(samplerName)
    #define TEXTURECUBE_ARRAY_SHADOW_PARAM(textureName, samplerName)  TEXTURECUBE_ARRAY(textureName), SAMPLER_CMP(samplerName)

    #define TEXTURE2D_ARGS(textureName, samplerName)                textureName, samplerName
    #define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          textureName, samplerName
    #define TEXTURECUBE_ARGS(textureName, samplerName)              textureName, samplerName
    #define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        textureName, samplerName
    #define TEXTURE3D_ARGS(textureName, samplerName)                textureName, samplerName

    #define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         textureName, samplerName
    #define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   textureName, samplerName
    #define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       textureName, samplerName
    #define TEXTURECUBE_ARRAY_SHADOW_ARGS(textureName, samplerName) textureName, samplerName

    #define PLATFORM_SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               textureName.Sample(samplerName, coord2)
    #define PLATFORM_SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      textureName.SampleLevel(samplerName, coord2, lod)
    #define PLATFORM_SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    textureName.SampleBias(samplerName, coord2, bias)
    #define PLATFORM_SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              textureName.SampleGrad(samplerName, coord2, dpdx, dpdy)
    #define PLATFORM_SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  textureName.Sample(samplerName, float3(coord2, index))
    #define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         textureName.SampleLevel(samplerName, float3(coord2, index), lod)
    #define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       textureName.SampleBias(samplerName, float3(coord2, index), bias)
    #define PLATFORM_SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) textureName.SampleGrad(samplerName, float3(coord2, index), dpdx, dpdy)
    #define PLATFORM_SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             textureName.Sample(samplerName, coord3)
    #define PLATFORM_SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    textureName.SampleLevel(samplerName, coord3, lod)
    #define PLATFORM_SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  textureName.SampleBias(samplerName, coord3, bias)
    #define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                textureName.Sample(samplerName, float4(coord3, index))
    #define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       textureName.SampleLevel(samplerName, float4(coord3, index), lod)
    #define PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     textureName.SampleBias(samplerName, float4(coord3, index), bias)
    #define PLATFORM_SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               textureName.Sample(samplerName, coord3)
    #define PLATFORM_SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      textureName.SampleLevel(samplerName, coord3, lod)

    #define SAMPLE_TEXTURE2D(textureName, samplerName, coord2)                               PLATFORM_SAMPLE_TEXTURE2D(textureName, samplerName, coord2)
    #define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)                      PLATFORM_SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)
    #define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)                    PLATFORM_SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)
    #define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)              PLATFORM_SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)
    #define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)                  PLATFORM_SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)
    #define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)         PLATFORM_SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod)
    #define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)       PLATFORM_SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias)
    #define SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy) PLATFORM_SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, index, dpdx, dpdy)
    #define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)                             PLATFORM_SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)
    #define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)                    PLATFORM_SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)
    #define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)                  PLATFORM_SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)
    #define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)                PLATFORM_SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)
    #define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)       PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod)
    #define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)     PLATFORM_SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias)
    #define SAMPLE_TEXTURE3D(textureName, samplerName, coord3)                               PLATFORM_SAMPLE_TEXTURE3D(textureName, samplerName, coord3)
    #define SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)                      PLATFORM_SAMPLE_TEXTURE3D_LOD(textureName, samplerName, coord3, lod)

    #define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3)                    textureName.SampleCmpLevelZero(samplerName, (coord3).xy, (coord3).z)
    #define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index)       textureName.SampleCmpLevelZero(samplerName, float3((coord3).xy, index), (coord3).z)
    #define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)                  textureName.SampleCmpLevelZero(samplerName, (coord4).xyz, (coord4).w)
    #define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index)     textureName.SampleCmpLevelZero(samplerName, float4((coord4).xyz, index), (coord4).w)

    #ifndef UNITY_CG_INCLUDED
        #define SAMPLE_DEPTH_TEXTURE(textureName, samplerName, coord2)          SAMPLE_TEXTURE2D(textureName, samplerName, coord2).r
        #define SAMPLE_DEPTH_TEXTURE_LOD(textureName, samplerName, coord2, lod) SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod).r
    #endif

    #define LOAD_TEXTURE2D(textureName, unCoord2)                                   textureName.Load(int3(unCoord2, 0))
    #define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)                          textureName.Load(int3(unCoord2, lod))
    #define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)                 textureName.Load(unCoord2, sampleIndex)
    #define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)                      textureName.Load(int4(unCoord2, index, 0))
    #define LOAD_TEXTURE2D_ARRAY_MSAA(textureName, unCoord2, index, sampleIndex)    textureName.Load(int3(unCoord2, index), sampleIndex)
    #define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod)             textureName.Load(int4(unCoord2, index, lod))
    #define LOAD_TEXTURE3D(textureName, unCoord3)                                   textureName.Load(int4(unCoord3, 0))
    #define LOAD_TEXTURE3D_LOD(textureName, unCoord3, lod)                          textureName.Load(int4(unCoord3, lod))

    #define GATHER_TEXTURE2D(textureName, samplerName, coord2)                textureName.Gather(samplerName, coord2)
    #define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)   textureName.Gather(samplerName, float3(coord2, index))
    #define GATHER_TEXTURECUBE(textureName, samplerName, coord3)              textureName.Gather(samplerName, coord3)
    #define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) textureName.Gather(samplerName, float4(coord3, index))
    #define GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)            textureName.GatherRed(samplerName, coord2)
    #define GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherGreen(samplerName, coord2)
    #define GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)           textureName.GatherBlue(samplerName, coord2)
    #define GATHER_ALPHA_TEXTURE2D(textureName, samplerName, coord2)          textureName.GatherAlpha(samplerName, coord2)

    // From URP Common.hlsl

    #if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)

        #define SLICE_ARRAY_INDEX   unity_StereoEyeIndex

        #define TEXTURE2D_X(textureName)                                        TEXTURE2D_ARRAY(textureName)
        #define TEXTURE2D_X_PARAM(textureName, samplerName)                     TEXTURE2D_ARRAY_PARAM(textureName, samplerName)
        #define TEXTURE2D_X_ARGS(textureName, samplerName)                      TEXTURE2D_ARRAY_ARGS(textureName, samplerName)
        #define TEXTURE2D_X_HALF(textureName)                                   TEXTURE2D_ARRAY_HALF(textureName)
        #define TEXTURE2D_X_FLOAT(textureName)                                  TEXTURE2D_ARRAY_FLOAT(textureName)
        #define RW_TEXTURE2D_X(type, textureName)                               RW_TEXTURE2D_ARRAY(type, textureName) //Addition, unity had no macro for handling UAV screen textures

        #define LOAD_TEXTURE2D_X(textureName, unCoord2)                         LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, SLICE_ARRAY_INDEX)
        #define LOAD_TEXTURE2D_X_LOD(textureName, unCoord2, lod)                LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, SLICE_ARRAY_INDEX, lod)
        
        #define SAMPLE_TEXTURE2D_X(textureName, samplerName, coord2)            SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, SLICE_ARRAY_INDEX)	
        #define SAMPLE_TEXTURE2D_X_LOD(textureName, samplerName, coord2, lod)   SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, SLICE_ARRAY_INDEX, lod)
        #define SAMPLE_TEXTURE2D_X_BIAS(textureName, samplerName, coord2, bias)			SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, SLICE_ARRAY_INDEX, bias)
        #define SAMPLE_TEXTURE2D_X_GRAD(textureName, samplerName, coord2, dpdx, dpdy)	SAMPLE_TEXTURE2D_ARRAY_GRAD(textureName, samplerName, coord2, SLICE_ARRAY_INDEX, dpdx, dpdy)
        
        #define GATHER_TEXTURE2D_X(textureName, samplerName, coord2)            GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, SLICE_ARRAY_INDEX)
        #define GATHER_RED_TEXTURE2D_X(textureName, samplerName, coord2)        GATHER_RED_TEXTURE2D(textureName, samplerName, float3(coord2, SLICE_ARRAY_INDEX))
        #define GATHER_GREEN_TEXTURE2D_X(textureName, samplerName, coord2)      GATHER_GREEN_TEXTURE2D(textureName, samplerName, float3(coord2, SLICE_ARRAY_INDEX))
        #define GATHER_BLUE_TEXTURE2D_X(textureName, samplerName, coord2)       GATHER_BLUE_TEXTURE2D(textureName, samplerName, float3(coord2, SLICE_ARRAY_INDEX))

    #else
        #define SLICE_ARRAY_INDEX       0

        #define TEXTURE2D_X(textureName)                                        TEXTURE2D(textureName)
        #define TEXTURE2D_X_PARAM(textureName, samplerName)                     TEXTURE2D_PARAM(textureName, samplerName)
        #define TEXTURE2D_X_ARGS(textureName, samplerName)                      TEXTURE2D_ARGS(textureName, samplerName)
        #define TEXTURE2D_X_HALF(textureName)                                   TEXTURE2D_HALF(textureName)
        #define TEXTURE2D_X_FLOAT(textureName)                                  TEXTURE2D_FLOAT(textureName)
        #define RW_TEXTURE2D_X(type, textureName)                               RW_TEXTURE2D(type, textureName) //Addition, unity had no macro for handling UAV screen textures

        #define LOAD_TEXTURE2D_X(textureName, unCoord2)                         LOAD_TEXTURE2D(textureName, unCoord2)
        #define LOAD_TEXTURE2D_X_LOD(textureName, unCoord2, lod)                LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)
        
        #define SAMPLE_TEXTURE2D_X(textureName, samplerName, coord2)            SAMPLE_TEXTURE2D(textureName, samplerName, coord2)
        #define SAMPLE_TEXTURE2D_X_LOD(textureName, samplerName, coord2, lod)   SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod)
        #define SAMPLE_TEXTURE2D_X_BIAS(textureName, samplerName, coord2, bias)			SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias)
        #define SAMPLE_TEXTURE2D_X_GRAD(textureName, samplerName, coord2, dpdx, dpdy)	SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, dpdx, dpdy)
        
        #define GATHER_TEXTURE2D_X(textureName, samplerName, coord2)            GATHER_TEXTURE2D(textureName, samplerName, coord2)
        #define GATHER_RED_TEXTURE2D_X(textureName, samplerName, coord2)        GATHER_RED_TEXTURE2D(textureName, samplerName, coord2)
        #define GATHER_GREEN_TEXTURE2D_X(textureName, samplerName, coord2)      GATHER_GREEN_TEXTURE2D(textureName, samplerName, coord2)
        #define GATHER_BLUE_TEXTURE2D_X(textureName, samplerName, coord2)       GATHER_BLUE_TEXTURE2D(textureName, samplerName, coord2)
    #endif
    #endif
    
    //// Error.mdl
    #if !defined(UNITY_DECLARE_DEPTH_TEXTURE_INCLUDED) && !defined(INCLUDE_DECLARE_DEPTH_TEXTURE_INCLUDED)
    #define INCLUDE_DECLARE_DEPTH_TEXTURE_INCLUDED
    // #include "ScreenTexMacro.hlsl"

    TEXTURE2D_X_FLOAT(_CameraDepthTexture);
    SAMPLER(sampler_CameraDepthTexture);

    float SampleSceneDepth(float2 uv)
    {
        return SAMPLE_TEXTURE2D_X(_CameraDepthTexture, sampler_CameraDepthTexture, (uv)).r;
        // return SAMPLE_TEXTURE2D_X(_CameraDepthTexture, sampler_CameraDepthTexture, UnityStereoTransformScreenSpaceTex(uv)).r;
    }

    float LoadSceneDepth(uint2 uv)
    {
        return LOAD_TEXTURE2D_X(_CameraDepthTexture, uv).r;
    }
    #endif

        // https://blog.demofox.org/2015/08/19/gaussian-blur/
        float Gaussian (float sigma, float x)
        {
            float limit = (-(x*x) / (2.0 * sigma*sigma));
            UNITY_BRANCH if (limit < -14.5) {return 0.0;} // lower than -14.57 causes a compile error
            return exp(limit);
        }

        float2 UVPick01(float4 uv01, float4 uv02, int pick)
        {
            // return (side) ? uv01.zw : uv01.xy;
            UNITY_BRANCH
            switch(pick)
            {
                default:return uv01.xy;
                case 0:return uv01.xy;
                case 1:return uv01.zw;
                case 2:return uv02.xy;
                case 3:return uv02.zw;
            }
        }
        float2 UVPick01(float4 uv01, float4 uv02)
        {
            return UVPick01(uv01, uv02, 0);
        }

        struct UV_DD { //// holds UV and derivatives for conservative tex lookups
            float2 uv;
            float2 dx;
            float2 dy;
        };

        //// get UV derivatives 
        UV_DD UVDD(float2 UV){
            UV_DD o;// = (UV_DD)0;
            o.uv    = UV;  
            o.dx    = ddx(UV);
            o.dy    = ddy(UV);
            return o;
        }

        //// https://godotengine.org/qa/41400/simple-texture-rotation-shader
        float2 rotateUV(float2 uv, float2 pivot, float rotation) {
            float cosA  = cos(rotation);
            float sinA  = sin(rotation);
            return mul( (uv - pivot), 
                        float2x2(cosA, -sinA, sinA, cosA)) 
                        + pivot;
        }
        ////
        float2 scaleUV(float2 uv, float2 pivot, float scale)
        {
            return (uv - pivot) * scale + pivot;
        }
        ////
        float2 scaleUV(float2 uv, float2 pivot, float scale, float2 ratioWH)
        {
            return (uv - pivot) * scale * ratioWH.xy + pivot;
        }

        //// modded UnityBuiltin3xTreeLibrary.cginc
        float ScreenDitherToAlphaCutout_ac(float2 uv)
        {
            //dither matrix reference: https://en.wikipedia.org/wiki/Ordered_dithering
            const float dither[64] = {
                0, 32, 8, 40, 2, 34, 10, 42,
                48, 16, 56, 24, 50, 18, 58, 26 ,
                12, 44, 4, 36, 14, 46, 6, 38 ,
                60, 28, 52, 20, 62, 30, 54, 22,
                3, 35, 11, 43, 1, 33, 9, 41,
                51, 19, 59, 27, 49, 17, 57, 25,
                15, 47, 7, 39, 13, 45, 5, 37,
                63, 31, 55, 23, 61, 29, 53, 21 };

            int xMat = int(uv.x) & 7;
            int yMat = int(uv.y) & 7;

            float limit = (dither[yMat * 8 + xMat] + 1.) / 64.0;
            return limit;
        }
        //// modded UnityBuiltin3xTreeLibrary.cginc
        float ScreenDitherToAlphaCutout_ac(float2 uv, float c0)
        {
            //dither matrix reference: https://en.wikipedia.org/wiki/Ordered_dithering
            const float dither[64] = {
                0, 32, 8, 40, 2, 34, 10, 42,
                48, 16, 56, 24, 50, 18, 58, 26 ,
                12, 44, 4, 36, 14, 46, 6, 38 ,
                60, 28, 52, 20, 62, 30, 54, 22,
                3, 35, 11, 43, 1, 33, 9, 41,
                51, 19, 59, 27, 49, 17, 57, 25,
                15, 47, 7, 39, 13, 45, 5, 37,
                63, 31, 55, 23, 61, 29, 53, 21 };

            int xMat = int(uv.x) & 7;
            int yMat = int(uv.y) & 7;

            float limit = (dither[yMat * 8 + xMat] + 11.0) / 64.0;
            //could also use saturate(step(0.995, c0) + limit*(c0));
            return step(limit, c0 + 0.01);
            // return limit;
        }
        //// UnityBuiltin3xTreeLibrary.cginc
        float ScreenDitherToAlpha_ac(float2 uv, float c0)
        {
            //dither matrix reference: https://en.wikipedia.org/wiki/Ordered_dithering
            const float dither[64] = {
                0, 32, 8, 40, 2, 34, 10, 42,
                48, 16, 56, 24, 50, 18, 58, 26 ,
                12, 44, 4, 36, 14, 46, 6, 38 ,
                60, 28, 52, 20, 62, 30, 54, 22,
                3, 35, 11, 43, 1, 33, 9, 41,
                51, 19, 59, 27, 49, 17, 57, 25,
                15, 47, 7, 39, 13, 45, 5, 37,
                63, 31, 55, 23, 61, 29, 53, 21 };

            int xMat = int(uv.x) & 7;
            int yMat = int(uv.y) & 7;

            float limit = (dither[yMat * 8 + xMat] + 11.0) / 64.0;
            //could also use saturate(step(0.995, c0) + limit*(c0));
            //original step(limit, c0 + 0.01);

            return lerp(limit*c0, 1.0, c0);
        }
        //// UnityBuiltin3xTreeLibrary.cginc
        float ComputeAlphaCoverage_ac(float4 screenPos, float fadeAmount)
        {
            float2 pixelPosition = screenPos.xy / (screenPos.w + 0.00001);
            pixelPosition *= _ScreenParams.xy;
            float coverage = ScreenDitherToAlpha_ac(pixelPosition, fadeAmount);
            return coverage;
        }

        //// My manual split of Unity's light attenuation (falloff mask) from shadow attenuation (shadow mask).
        //// These maks should honestly be seperated for the control & NPR usage it enables!
        //// Redefine UNITY_LIGHT_ATTENUATION without shadow multiply from AutoLight.cginc
        #ifdef POINT
        #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) \
            unityShadowCoord3 lightCoord    = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)).xyz; \
            fixed destName  = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
        #endif

        #ifdef SPOT
        #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) \
            unityShadowCoord4 lightCoord    = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)); \
            fixed destName  = (lightCoord.z > 0) * UnitySpotCookie(lightCoord) * UnitySpotAttenuate(lightCoord.xyz);
        #endif

        #ifdef DIRECTIONAL
        // #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) fixed destName = 1;
        #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) fixed destName = UNITY_SHADOW_ATTENUATION(input, worldPos);
        #endif

        #ifdef POINT_COOKIE
        #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) \
            unityShadowCoord3 lightCoord    = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)).xyz; \
            fixed destName  = tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL * texCUBE(_LightTexture0, lightCoord).w;
        #endif

        #ifdef DIRECTIONAL_COOKIE
        #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) \
            unityShadowCoord2 lightCoord    = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)).xy; \
            fixed destName  = tex2D(_LightTexture0, lightCoord).w;
        #endif

        //// Fancy shadeSH9 ringing correction 
        //// Method appears to be from:
        //// "Reconstructing Diffuse Lighting from Spherical Harmonic Data - Geomerics"
        //// this version from bakery.
        //// https://git.technolabs.com.br/ttravi/light-editor/blob/master/LightEditor/Assets/Bakery/shader/Bakery.cginc
        //// Other examples 
        //// https://github.com/kayru/Probulator/blob/master/Source/Probulator/SphericalHarmonics.h
        //// https://github.com/Xiexe/Unity-Lit-Shader-Templates/blob/68c695dc50ad18a754b1434f00366fd3a89fdc0f/XSShaderTemplates/Templates/Shared/LightingFunctions.cginc#L184
        float shEvaluateDiffuseL1Geomerics(float L0, float3 L1, float3 n)
        {
            // average energy
            float R0 = L0;

            // avg direction of incoming light
            float3 R1 = 0.5f * L1;

            // directional brightness
            float lenR1 = length(R1);

            // linear angle between normal and direction 0-1
            //float q = 0.5f * (1.0f + dot(R1 / lenR1, n));
            //float q = dot(R1 / lenR1, n) * 0.5 + 0.5;
            float q = dot(normalize(R1), n) * 0.5 + 0.5;

            // power for q
            // lerps from 1 (linear) to 3 (cubic) based on directionality
            float p = 1.0f + 2.0f * lenR1 / R0;

            // dynamic range constant
            // should vary between 4 (highly directional) and 0 (ambient)
            float a = (1.0f - lenR1 / R0) / (1.0f + lenR1 / R0);

            return R0 * (a + (1.0f - a) * (p + 1.0f) * pow(q, p));
        }
        
        //// ambient color
        float3 DecodeLightProbe_average(){
            return float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
        }

        //// (Unity)
        //// normal should be normalized, w=1.0
        half3 SHEvalLinearL0L1_ac (half4 normal)
        {
            half3 x;
            // Linear (L1) + constant (L0) polynomial terms
            x.r = dot(unity_SHAr,normal);
            x.g = dot(unity_SHAg,normal);
            x.b = dot(unity_SHAb,normal);
            return x;
        }
        // normal should be normalized, w=1.0
        half3 SHEvalLinearL2_ac (half4 normal)
        {
            half3 x1, x2;
            // 4 of the quadratic (L2) polynomials
            half4 vB = normal.xyzz * normal.yzzx;
            x1.r = dot(unity_SHBr,vB);
            x1.g = dot(unity_SHBg,vB);
            x1.b = dot(unity_SHBb,vB);

            // Final (5th) quadratic (L2) polynomial
            half vC = normal.x*normal.x - normal.y*normal.y;
            x2 = unity_SHC.rgb * vC;
            return x1 + x2;
        }
        //// get L1 by excluding the 4th index, which is L0
        half3 SHEvalDirectL1(half3 normal)
        {
            half3 L0;
            L0.r = dot(unity_SHAr.xyz,normal);
            L0.g = dot(unity_SHAg.xyz,normal);
            L0.b = dot(unity_SHAb.xyz,normal);
            return L0;
        }

        // normal should be normalized, w=1.0
        // output in active color space
        half3 ShadeSH9_ac (half4 normal)
        {
            // Linear + constant polynomial terms
            half3 res = SHEvalLinearL0L1_ac (normal);
            // Quadratic polynomials
            res += SHEvalLinearL2_ac (normal);
        #ifdef UNITY_COLORSPACE_GAMMA
            res = LinearToGammaSpace (res);
        #endif
            return res;
        }

        //// adaptive ringing corrected SH color
        //// see shEvaluateDiffuseL1Geomerics() for citation
        float3 shadeSH9LinearAndWhole(float4 worldNormal)
        {
            float3 indirectDiffuse;
            float3 L0 = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
            indirectDiffuse.r = shEvaluateDiffuseL1Geomerics(L0.r, unity_SHAr.xyz, worldNormal.xyz);
            indirectDiffuse.g = shEvaluateDiffuseL1Geomerics(L0.g, unity_SHAg.xyz, worldNormal.xyz);
            indirectDiffuse.b = shEvaluateDiffuseL1Geomerics(L0.b, unity_SHAb.xyz, worldNormal.xyz);
            //// want to add more detail but L2 also rings
            // float3 L2       = SHEvalLinearL2_ac(worldNormal);
            // indirectDiffuse += L2;
            return max(0, indirectDiffuse);
        }

        //// Samples light probes and best guess primary direction.
        //// Neitri's help.
        //// In-depth: Extracting dominant light from Spherical Harmonics 
        //// https://www.gamasutra.com/view/news/129689/Indepth_Extracting_dominant_light_from_Spherical_Harmonics.php
        //// "Stupid Spherical Harmonics (SH) Tricks"
        //// http://www.ppsloan.org/publications/StupidSH36.pdf
        float3 GIDominantDir()
        {
            // float3 GIsonar_dir_vec  = (.3 * unity_SHAr.xyz + .59 * unity_SHAg.xyz + .11 * unity_SHAb.xyz);
            float3 GIsonar_dir_vec  = 
                 (unity_ColorSpaceLuminance.r * unity_SHAr.xyz 
                + unity_ColorSpaceLuminance.g * unity_SHAg.xyz 
                + unity_ColorSpaceLuminance.b * unity_SHAb.xyz);
            // float3 GIsonar_dir_vec  = (unity_SHAr.xyz + unity_SHAg.xyz + unity_SHAb.xyz);
            // if ( dot( GIsonar_dir_vec, GIsonar_dir_vec) != 0)
            UNITY_FLATTEN
            if ( any(GIsonar_dir_vec))
            {
                GIsonar_dir_vec     = normalize(GIsonar_dir_vec);
            } else {
                GIsonar_dir_vec     = float3(0,0,0);
            }
            return GIsonar_dir_vec;
        }

        //// Almost get max possible intensity from indirect light.
        //// cite Arktoon
        //// Does not include unity_SHC term (incomplete L2)
        half3 GetSHLength ()
        {
            half3 x, x1;
            x.r     = length(unity_SHAr);
            x.g     = length(unity_SHAg);
            x.b     = length(unity_SHAb);
            x1.r    = length(unity_SHBr);
            x1.g    = length(unity_SHBg);
            x1.b    = length(unity_SHBb);
            return  x + x1;
        }

        // mix colors compromising between saturation peaks and intensity
        float3 mixColorsMaxAve(float3 a, float3 b)
        {
            // return min((a + b)*.5, max(a, b));
            float3 ave  = (a+b)*.5;
            return (max(a, b)+ave)*.5;
        }

        //// https://www.shadertoy.com/view/ldtXDj
        //// camera HDR off means self curving color is safe, as Standard's emission cheats by curving intensity
        //// suggestion from lox9973
        float3 ACESFilm( float3 x )
        {
            float a = 2.51;
            float b = 0.03;
            float c = 2.43;
            float d = 0.59;
            float e = 0.14;
            return clamp((x*(a*x+b))/(x*(c*x+d)+e), 0.0, 1.0);
        }
        //// alternative tonemap
        //// https://www.slideshare.net/ozlael/hable-john-uncharted2-hdr-lighting
        float3 Uncharted2Tonemap(float3 x)
        {
            float A = 0.15; // shoulder strength
            float B = 0.50; // linera strength
            float C = 0.10; // linear angle
            float D = 0.20; // toe strength
            float E = 0.02; // toe numerator
            float F = 0.30; // toe denominator
            float W = 11.2; // E/F = toe angle
            return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
        }

        // (Unity) Convert rgb to luminance
        // with rgb in linear space with sRGB primaries and D65 white point
        half LinearRgbToLuminance_ac(half3 linearRgb)
        {
            return dot(linearRgb, half3(0.2126729f,  0.7151522f, 0.0721750f));
        }

        // unity's modified version without the lambert tint darkening and hard distance clip.
        // vertTo0 - first VL position
        float3 softShade4PointLights_Atten (
            float4 lightPosX, float4 lightPosY, float4 lightPosZ,
            half4 unityLightColor[8],
            half4 unity4LightAtten0,
            float3 pos,
            float3 normal,
            out float3 vertTo0)
        {
            // to light vectors
            float4 toLightX = lightPosX - pos.x;
            float4 toLightY = lightPosY - pos.y;
            float4 toLightZ = lightPosZ - pos.z;
            vertTo0 = float3(toLightX[0], toLightY[0], toLightZ[0]);
            // return Shade4PointLights(lightPosX,lightPosY,lightPosZ
            // ,unityLightColor[0],unityLightColor[1],unityLightColor[2],unityLightColor[3]
            // ,unity4LightAtten0
            // ,pos, normal);
            if ( any(vertTo0) && (LinearRgbToLuminance_ac((unityLightColor[0].rgb)) > .01)){ //// black light check
                vertTo0 = normalize(vertTo0);
            } else {
                vertTo0 = float3(0,0,0);
            }
            // squared lengths
            float4 lengthSq = 0;
            lengthSq += toLightX * toLightX;
            lengthSq += toLightY * toLightY;
            lengthSq += toLightZ * toLightZ;
            // don't produce NaNs if some vertex position overlaps with the light
            lengthSq = max(lengthSq, 0.000001);
            // attenuation
            float4 disLimit = (lengthSq * unity4LightAtten0);
            disLimit        = ((disLimit) > 30) ? 1.#INF : disLimit;
            float4 atten    = saturate(1.0 / (1.0 + disLimit) - 0.04);

            float3 col = 0;
            col += unityLightColor[0].xyz * atten[0];
            col += unityLightColor[1].xyz * atten[1];
            col += unityLightColor[2].xyz * atten[2];
            col += unityLightColor[3].xyz * atten[3];
            return col;
        }

        //// vrchat shader community. Not sure exactly whom poked the mirror code to solve this.
        bool IsInMirror()
        {
            return (unity_CameraProjection[2][0] != 0.0f) || (unity_CameraProjection[2][1] != 0.0f);
        }
        
        ////
        float sqr(float x) {return x*x;}
        float2 sqr(float2 x) {return x*x;}

        //// Simplified box projection
        //// https://catlikecoding.com/unity/tutorials/rendering/part-8/
        float3 BoxProjection (
            float3 direction, float3 position,
            float4 cubemapPosition, float4 boxMin, float4 boxMax) 
        {
            UNITY_BRANCH
            if (cubemapPosition.w > 0) {
                float3 factors =
                    ((direction > 0 ? boxMax.xyz : boxMin.xyz) - position) / direction;
                float scalar = min(min(factors.x, factors.y), factors.z);
                direction = direction * scalar + (position - cubemapPosition.xyz);
            }
            return direction;
        }



        //// Edit so its in world space
        //// (UNITY - UnityClipSpaceShadowCasterPos() )
        float4 UnityWorldSpaceShadowCasterPos(float4 wPos, float3 normal)
        {
            if (unity_LightShadowBias.z != 0.0)
            {
                float3 wNormal = UnityObjectToWorldNormal(normal);
                float3 wLight = normalize(UnityWorldSpaceLightDir(wPos.xyz));

                float shadowCos = dot(wNormal, wLight);
                float shadowSine = sqrt(1-shadowCos*shadowCos);
                float normalBias = unity_LightShadowBias.z * shadowSine;

                wPos.xyz -= wNormal * normalBias;
            }

            return mul(UNITY_MATRIX_VP, wPos);
        }

        //// https://www.shadertoy.com/view/XlGcRh
        float2 hashwithoutsine22(float2 p)
        {
            float3 p3 = frac(float3(p.xyx) * float3(.1031, .1030, .0973));
            p3 += dot(p3, p3.yzx+33.33);
            return frac((p3.xx+p3.yz)*p3.zy);
        }

        //// https://www.shadertoy.com/view/4djSRW
        float hash12(float2 p)
        {
            float3 p3  = frac(float3(p.xyx) * .1031);
            p3 += dot(p3, p3.yzx + 33.33);
            return frac((p3.x + p3.y) * p3.z);
        }
        float hash13(float3 p3)
        {
            // p3 = frac(p3 * .1031);
            p3  = frac(p3 * 13);
            p3  += dot(p3, p3.yzx + 19.19);
            return frac((p3.x + p3.y) * p3.z);
        }
        

        float2 rand22( float2 p ) 
        {
            return frac(sin(float2(dot(p,float2(127.1,311.7)),dot(p,float2(269.5,183.3))))*43758.5453);
        }

        float rand12( float2 p ) 
        {
            return frac(sin(dot(p,float2(127.1,311.7)))*43758.5453);
        }

        float rand3(float3 co){
            return frac(sin(dot(co.xyz ,float3(12.9898,78.233,213.576))) * 43758.5453);
        }

        float3 hash3( float2 p )
        {
            float3 q = float3( dot(p,float2(127.1,311.7)), 
                        dot(p,float2(269.5,183.3)), 
                        dot(p,float2(419.2,371.9)) );
            return frac(sin(q)*43758.5453);
        }

        float2 hash23(float3 p3)
        {
            p3 = frac(p3 * float3(.1031, .1030, .0973));
            p3 += dot(p3, p3.yzx+33.33);
            return frac((p3.xx+p3.yz)*p3.zy);
        }

        //// VRChar shader group
        float3 worldCameraRawMatrix()
        {
            float3 worldCam;
            worldCam.x = unity_CameraToWorld[0][3];
            worldCam.y = unity_CameraToWorld[1][3];
            worldCam.z = unity_CameraToWorld[2][3];
            return worldCam;
        }
        //// SPS path is mean between the eyes
        float3 StereoWorldViewPos() {
            #if UNITY_SINGLE_PASS_STEREO
            float3 cameraPos    = 
                float3((unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1]) * .5); 
            #else
            float3 cameraPos    = _WorldSpaceCameraPos;
            #endif
            return cameraPos;
        }

        ////
        float3 StereoWorldViewDir( float3 worldPos) {
            float3 cameraPos    = StereoWorldViewPos();
            float3 worldViewDir = (cameraPos - worldPos);
            return worldViewDir;
        }

        ////
        float3 HSVToRGB( float3 c )
        {
            float4 K    = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
            float3 p    = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
            return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
        }

        ////
        float3 RGBToHSV(float3 c)
        {
            float4 K    = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            float4 p    = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
            float4 q    = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
            float d     = q.x - min( q.w, q.y );
            float e     = 1.0e-10;
            return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
        }

        //// x: x, m: threshold, n: f(x=0)=
        inline float AlmostIdentity( float x, float m, float n )
        {
            if( x>m ) return x;
            float a = 2.0*n - m;
            float b = 2.0*m - 3.0*n;
            float t = x/m;
            return (a*t + b)*t*t + n;
        }

        //// designed so 'b' Intensity is unclamped
        float3 Lerp3High2(float3 a, float3 b, float mix)
        {
            float3 a1 = a * saturate(1 - mix);
            float3 b1 = b * mix;
            return a1 + b1;
        }

        //// Trick for continous func ramps. Citing UTS2 for the common usage.
        float StepFeatherRemap(float normalization, float step, float feather, int offsetMode)
        {
            float stepOffset;
            UNITY_BRANCH 
            switch (offsetMode) {
                default: stepOffset = feather; break;
                case 0: stepOffset = feather; break;
                case 1: stepOffset = (feather * .5); break;
                case 2: stepOffset = 0; break;
            }
            float var   = normalization - step + stepOffset;
            var         = 0 + var / feather;
            return      saturate(var);
        }
        float StepFeatherRemap(float normalization, float step, float feather)
        {
            return StepFeatherRemap(normalization, step, feather, 0);
        }
        ////
        float StepFeatherRemapNoSat(float normalization, float step, float feather)
        {
            float var   = normalization - step + feather;
            var         = 0 + var / feather;
            return      (var);
        }
        //// float3 version
        float3 StepFeatherRemap3(float3 normalization, float step, float feather)
        {
            float3 var  = normalization - step + feather;
            var         = 1 + var / feather;
            var         = var / normalization;
            return      max(0,var);
        }

        ////
        float RemapRange(float value, float low1, float high1, float low2, float high2)
        {
            return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
        }
        ////
        float RemapRangeH01(float value, float low1, float high1)
        {
            return saturate((value - low1) / (high1 - low1));
        }
        ////
        float RemapRange01(float value, float low2, float high2)
        {
            return low2 + (value) * (high2 - low2);
        }

        //// pushes range -1 to +1 towards edge domain of -1 to +1
        //// n range 1 to +n 
        float curvePinch(float x, float n)
        {
            return sign(x) * (1-pow(1-abs(x), n));
        }

        //// https://iquilezles.org/articles/functions/
        float gain(float x, float k) 
        {
            const float a = 0.5*pow(2.0*((x<0.5)?x:1.0-x), k);
            return (x<0.5)?a:1.0-a;
        }

        //// 1.0 = line, > 1.0 arch, < 1.0 pinch
        float1 Pow2Recurve(float1 value, float1 scale)
        {
            return exp2(log2(value) * scale);
        }

        ////
        half ColStrength_ac(half3 specular) {
                return max(max(specular.r, specular.g), specular.b);
        }

        //// Diffuse/Spec Energy conservation. Specular setup
        inline half EnergyConservationBetweenDiffuseAndSpecular_ac(
            int notConserveMode, half3 specColor, out half oneMinusReflectivity)
        {
            oneMinusReflectivity    = max(0, 1 - ColStrength_ac(specColor)); /// > 1 HDR specColor
            UNITY_BRANCH
            if (notConserveMode)
            {
                return 1.0;
            } 
            else
            {
                return oneMinusReflectivity;
            }
        }

        //// get oneMinusReflectivity for Specular setup.
        //// Assumes spec color <= 1.0
        inline void EnergyConservationBetweenDiffuseAndSpecularOMR(half3 specColor, out half oneMinusReflectivity)
        {
            oneMinusReflectivity    = max(0, 1 - ColStrength_ac(specColor));
        }

        //// Unity
        inline half OneMinusReflectivityFromMetallic_ac(half metallic)
        {
            half oneMinusDielectricSpec = unity_ColorSpaceDielectricSpec.a;
            return oneMinusDielectricSpec - metallic * oneMinusDielectricSpec;
        }
        ////
        inline half DiffuseAndSpecularFromMetallic_ac (
            int notConserveMode, half3 albedo, half metallic, out half3 specColor, out half oneMinusReflectivity)
        {
            specColor = lerp (unity_ColorSpaceDielectricSpec.rgb, albedo, metallic);
            oneMinusReflectivity = OneMinusReflectivityFromMetallic_ac(metallic);
            if (notConserveMode)
            {
                return 1.0;
            }
            else
            {
                return oneMinusReflectivity;
            }
        }
        //// shiny reflections are always visible. Dim diffuse and raise the final output alpha.
        void PremultiplyAlpha_ac (inout float3 diffuse, inout float alpha, float oneMinusReflectivity) 
        {
            //// alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)
            diffuse *= alpha;
            // alpha   = lerp(alpha, 1, (1-oneMinusReflectivity));
            alpha = 1 - oneMinusReflectivity + alpha * oneMinusReflectivity;
            
        }

        ////
        inline half Pow4_ac (half x) { return x*x*x*x; }
        inline half4 Pow4_ac (half4 x) {return x*x*x*x; }
        inline half Pow5_ac (half x) {return x*x*x*x*x; }
        inline half4 Pow5_ac (half4 x) {return x*x*x*x*x; }

        //// (Unity) approximage Schlick with ^4 instead of ^5
        //// Lerps F0 to F90 as cosA decreases
        inline half3 FresnelLerpFast_ac (half3 F0, half3 F90, half cosA)
        {
            half t  = Pow4_ac(1 - cosA);
            return  lerp (F0, F90, t);
        }
        //// (Unity). CosA increasing converts color F0 to white.
        //// Modified to handle HDR specular.
        //// A deceptive name its more like "whiten"
        inline half3 FresnelTerm_ac (half3 F0, half cosA)
        {
            half t  = Pow5_ac(1 - cosA);        //// ala Schlick interpoliation
            half m  = ColStrength_ac(F0);
            return  F0 + (m-F0) * t;    //// HDR spec color limit
        }
        //// version that reuses specular reflectivity
        inline half3 FresnelTerm_ac (half3 F0, half cosA, half oneMinusReflectivity)
        {
            half t  = Pow5_ac(1 - cosA);        //// ala Schlick interpoliation
            half m  = 1-oneMinusReflectivity;
            return  F0 + (m-F0) * t;    //// HDR spec color limit
        }

        //// (Unity). Modifed as LOD max is not 6 as Unity assumed.
        half perceptualRoughnessToMipmapLevel_ac(half perceptualRoughness,half lodMax)
        {
            return (perceptualRoughness * lodMax);
        }

        //// (unity) Unity_GlossyEnvironment. Cubemap LOD roughness conversion
        half RoughnessMagicNumberUnityRecurve(float perceptualRoughness)
        {
            return  perceptualRoughness*(1.7 - 0.7*perceptualRoughness);
        }

        //// unity
        float SmoothnessToPerceptualRoughness_ac(float smoothness)
        {
            return (1 - smoothness);
        }

        float PerceptualRoughnessToRoughness_ac(float perceptualRoughness)
        {
            return perceptualRoughness * perceptualRoughness;
        }

        //// Unity
        inline half PerceptualRoughnessToSpecPower_ac (half perceptualRoughness)
        {
            half m = PerceptualRoughnessToRoughness_ac(perceptualRoughness);   // m is the true academic roughness.
            // half m = perceptualRoughness * perceptualRoughness;   // m is the true academic roughness.
            half sq = max(1e-4f, m*m);
            half n = (2.0 / sq) - 2.0;  // https://dl.dropboxusercontent.com/u/55891920/papers/mm_brdf.pdf
            n = max(n, 1e-4f);          // prevent possible cases of pow(0,0), which could happen when roughness is 1.0 and NdotH is zero
            return n;
        }
        ////
        inline half RoughnessToSpecPower_ac (half roughness)
        {
            half m = (roughness);
            half sq = max(1e-4f, m*m);
            half n = (2.0 / sq) - 2.0;
            n = max(n, 1e-4f);
            return n;
        }
        
        //// Mihoyo's 2017-2018 unity GDC presentation on their toon shading.
        float3 ShiftTangent(float3 dirTangent, float3 dirNormal, float shift)
        {
            // float rangeShift = (shift * 2) - 1;
            // float3 shiftedT = (dirNormal * rangeShift) + dirTangent;
            float3 shiftedT = (dirNormal * shift) + dirTangent;
            return normalize(shiftedT);
        }

        //// Mihoyo's 2017-2018 unity GDC presentation on their toon shading.
        //// my port been backlogged forever....when will i add this feature?
        float StrandSpecular(
            float3 dirTangent,  float3 dirHalf,
            float exponent)
        {
            float tdh       = dot(dirTangent, dirHalf);
            float sinTH     = sqrt(1. - tdh*tdh);
            float attenDir  = smoothstep(-1, 0, tdh);
            // float attenDir  = (RemapRange(tdh,-1., 0., 0., 1.));
            return attenDir * pow(sinTH, exponent);
        }

        //// https://www.jordanstevenstechart.com/physically-based-rendering
        float AshikhminShirleyGSF_ac (float NdotL, float NdotV, float LdotH){
            float Gs = NdotL*NdotV/(LdotH*max(NdotL,NdotV));
            return  (Gs);
        }
        ////
        float NeumannGeometricShadowingFunction_ac (float NdotL, float NdotV){
            float Gs = (NdotL*NdotV)/max(NdotL, NdotV);       
            return  (Gs);
        }
        ////
        float WardGeometricShadowingFunction_ac (float NdotL, float NdotV){
            float Gs = pow( NdotL * NdotV, 0.5);
            return  (Gs);
        }

        //// Anisotropic brdfs
        //// https://github.com/wdas/brdf/blob/main/src/brdfs/disney.brdf
        float GTR2_aniso_ac(float NdotH, float HdotX, float HdotY, float ax, float ay)
        {
            // return (1 * UNITY_INV_PI) / ((ax*ay * sqr( sqr(HdotX/ax) + sqr(HdotY/ay) + NdotH*NdotH )));
            return (1 * UNITY_INV_PI) / ((ax*ay * sqr( sqr(HdotX/ax) + sqr(HdotY/ay) + NdotH*NdotH )) + 1e-3f);
        }
        ////
        float smithG_GGX_aniso_ac(float NdotV, float VdotX, float VdotY, float ax, float ay)
        {
            // return 1 / ((NdotV + sqrt( sqr(VdotX*ax) + sqr(VdotY*ay) + sqr(NdotV) )));
            return 1 / ((NdotV + sqrt( sqr(VdotX*ax) + sqr(VdotY*ay) + sqr(NdotV) )) + 1e-5f);
        }

        //// https://www.jordanstevenstechart.com/physically-based-rendering
        float WardAnisotropicNormalDistribution(
                float anisotropic, float roughness, float NdotL,
                float NdotV, float NdotH, float HdotX, float HdotY){
            float aspect = sqrt(1.0h-anisotropic * 0.9h);
            float X = max(.001, sqr(roughness)/aspect) * 5;
            float Y = max(.001, sqr(roughness)*aspect) * 5;
            float exponent = -(sqr(HdotX/X) + sqr(HdotY/Y)) / sqr(NdotH);
            float Distribution = 1.0 * UNITY_INV_PI / (4.0 * X * Y * sqrt(NdotL * NdotV));
            Distribution *= exp(exponent);
            return Distribution;
        }



        //// https://www.jordanstevenstechart.com/physically-based-rendering
        //// KelemenGeometricShadowingFunction
        float KelemenGSF(float NdotL, float NdotV, float VdotH){
            float Gs    = (NdotL * NdotV) / (VdotH * VdotH); 
            return (Gs);
        }
        float AshikhminPremozeGSF(float NdotL, float NdotV)
        {
            float Gs    = (NdotL * NdotV)/(NdotL + NdotV - NdotL * NdotV);
            return  (Gs);
        }

        //// (Unity)
        inline float GGXTerm_ac (float NdotH, float roughness)
        {
            float a2    = roughness * roughness;
            float d     = (NdotH * a2 - NdotH) * NdotH + 1.0f;
            return      UNITY_INV_PI * a2 / (d * d + 1e-7f);
        }
        ////
        inline float GGXTermPeak_ac (float roughness)
        {
            return GGXTerm_ac(1.0, roughness);
        }

        
        //// Ref: http://jcgt.org/published/0003/02/03/paper.pdf
        inline float SmithJointGGXVisibilityTerm_ac(float NdotL, float NdotV, float roughness)
        {
            // Reorder code to be more optimal
            half a          = roughness;
            half a2         = a * a;

            half lambdaV    = NdotL * sqrt((-NdotV * a2 + NdotV) * NdotV + a2);
            half lambdaL    = NdotV * sqrt((-NdotL * a2 + NdotL) * NdotL + a2);

            // Simplify visibility term: (2.0f * NdotL * NdotV) /  ((4.0f * NdotL * NdotV) * (lambda_v + lambda_l + 1e-5f));
            return 0.5f / (lambdaV + lambdaL + 1e-5f);  // This function is not intended to be running on Mobile,
                                                // therefore epsilon is smaller than can be represented by half
            /*
            // Approximation of the above formulation (simplify the sqrt, not mathematically correct but close enough)
            float a         = roughness;
            float lambdaV   = NdotL * (NdotV * (1 - a) + a);
            float lambdaL   = NdotV * (NdotL * (1 - a) + a);
            return          0.5f / (lambdaV + lambdaL + 1e-5f);
            */
        }
        ////
        inline float SmithJointGGXVisibilityTermPeak_ac(float roughness)
        {
            return SmithJointGGXVisibilityTerm_ac(1., 1e-5f, roughness);
        }

        //// https://knarkowicz.wordpress.com/2018/01/04/cloth-shading/
        //// https://www.shadertoy.com/view/4tfBzn
        //// Sheen / Cloth / Velvet
        float CharlieD(float ndoth, float roughness)
        {
            float invR = 1. / (roughness);
            float cos2h = ndoth * ndoth;
            float sin2h = 1. - cos2h;
            // return (2. + invR) * pow(sin2h, invR * .5) / (2. * UNITY_PI);
            // return (2. + invR) * pow(sin2h, invR * .5)  * .5 * UNITY_INV_PI;
            return (2. + invR) * pow(sin2h, invR * .5);
            // return (2. + invR) * pow(sin2h, invR * .5)  * .5;
        }
        ////
        float L(float x, float r)
        {
            r = saturate(r);
            r = 1.0 - (1. - r) * (1. - r);

            float a = lerp( 25.3245,  21.5473, r);
            float b = lerp( 3.32435,  3.82987, r);
            float c = lerp( 0.16801,  0.19823, r);
            float d = lerp(-1.27393, -1.97760, r);
            float e = lerp(-4.85967, -4.32054, r);

            return a / (1. + b * pow(x, c)) + d * x + e;
        }
        ////
        float CharlieV(float ndotl, float ndotv, float roughness)
        {
            float visV = ndotv < .5 ? exp(L(ndotv, roughness)) : exp(2. * L(.5, roughness) - L(1. - ndotv, roughness));
            float visL = ndotl < .5 ? exp(L(ndotl, roughness)) : exp(2. * L(.5, roughness) - L(1. - ndotl, roughness));

            return 1. / ((1. + visV + visL) * (4. * ndotv * ndotl));
        }
        ////
        float AshikhminV(float ndotl, float ndotv)
        {
            return 1. / ((4. * (ndotl + ndotv - ndotl * ndotv)) + 1e-5f);
        }
        

        //// (Unity) Generic Smith-Schlick visibility term
        inline half SmithVisibilityTerm_ac (half NdotL, half NdotV, half k)
        {
            half gL = NdotL * (1-k) + k;
            half gV = NdotV * (1-k) + k;
            return 1.0 / (gL * gV + 1e-5f); // This function is not intended to be running on Mobile,
                                            // therefore epsilon is smaller than can be represented by half
        }

        //// (Unity)
        inline half SmithBeckmannVisibilityTerm_ac(half NdotL, half NdotV, half roughness)
        {
            half c = 0.797884560802865h; // c = sqrt(2 / Pi)
            half k = roughness * c;
            return SmithVisibilityTerm_ac (NdotL, NdotV, k) * 0.25f; // * 0.25 is the 1/4 of the visibility term
        }
        ////
        inline half SmithBeckmannVisibilityTermPeak_ac(half roughness)
        {
            return SmithBeckmannVisibilityTerm_ac(0, 0, roughness); // * 0.25 is the 1/4 of the visibility term
        }
        //// wip GSF for diffuse
        float GSF_Diff_ac (float NdotL, float NdotV, float LdotH)
        {
            // float Gs    = NdotL*NdotV/max(.00001,(LdotH*max(NdotL,NdotV)));
            float Gs    = NdotL*NdotV/max(.00001,(LdotH));
            // float Gs    = NdotL*NdotV/max(.00001,(LdotH));
            return      Gs;
        }
        //// WardGeometricShadowingFunction
        float WardGSF(float NdotL, float NdotV)
        {
            float Gs    = pow( NdotL * NdotV, 0.5);
            return      (Gs);
        }

        //// (Unity)
        half DisneyDiffuse_fuzz(half NdotV, half NdotL, half LdotH, half perceptualRoughness)
        {
            half fd90 = 0.5 + 2 * LdotH * LdotH * perceptualRoughness;
            // Two schlick fresnel term
            half lightScatter   = (0 + (fd90 - 1) * Pow5(1 - NdotL));
            half viewScatter    = (0 + (fd90 - 1) * Pow5(1 - NdotV));
            // half lightScatter   = (1 + (fd90 - 1) * Pow5(1 - NdotL));
            // half viewScatter    = (1 + (fd90 - 1) * Pow5(1 - NdotV));

            return lightScatter * viewScatter;
        }

        //// UDN normal map blending.
        //// https://blog.selfshadow.com/publications/blending-in-detail/
        float3 Blend_udn(float3 n1, float3 n2)
        {
            return normalize(float3(n1.xy + n2.xy, n1.z));
            // return normalize(n1*dot(n1, n2)/n1.z - n2);
        }
        float3 Blend_rnm(float4 n1, float4 n2)
        {
            float3 t = n1.xyz*float3( 2,  2, 2) + float3(-1, -1,  0);
            float3 u = n2.xyz*float3(-2, -2, 2) + float3( 1,  1, -1);
            float3 r = t*dot(t, u) - u*t.z;
            return normalize(r);
        }

        //// https://docs.unity3d.com/Packages/com.unity.shadergraph@6.9/manual/Normal-Strength-Node.html
        void Unity_NormalStrength_float_ac(float3 In, float strength, out float3 Out)
        {
            UNITY_BRANCH
            if (strength != 1.0)
            {
                Out = float3(In.rg * strength, lerp(1.0, In.b, abs(strength)));
            }
            else
            {
                Out = In;
            }
        }

        ////============================================================
        //// blend between to directions by %
        //// https://www.shadertoy.com/view/4sV3zt
        //// https://keithmaggio.wordpress.com/2011/02/15/math-magician-lerp-slerp-and-nlerp/
        float3 slerp(float3 start, float3 end, float percent)
        {
            float d     = dot(start, end);
            d           = clamp(d, -1.0, 1.0);
            float theta = acos(d)*percent;
            float3 RelativeVec  = normalize(end - start*d);
            return      ((start*cos(theta)) + (RelativeVec*sin(theta)));
        }

        //// https://www.neilmendoza.com/glsl-rotation-about-an-arbitrary-axis/
        float4x4 rotationMatrix(float3 axis, float angle)
        {
            axis = normalize(axis);
            float s = -sin(angle);
            float c = cos(angle);
            float oc = 1.0 - c;

            return float4x4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                    0.0,                                0.0,                                0.0,                                1.0);
        }

        //// get intensity ratio of color A on B, weighted by a Scale
        half RatioOfColors(half3 colorA, half3 colorB, half colorAMultiplier)
        {
            half cALum  = LinearRgbToLuminance_ac(colorA), cBLum = LinearRgbToLuminance_ac(colorB);
            half cDiff  = ((cALum * colorAMultiplier) - cBLum);
            half cSum   = cALum + cBLum;
            return saturate(cDiff / cSum);
        }

        //// https://github.com/cplotts/WPFSLBlendModeFx/blob/master/PhotoshopMathFP.hlsl
        // For all settings: 1.0 = 100% 0.5=50% 1.5 = 150%
        float3 ContrastSaturationBrightness(float3 color, float brt, float sat, float con)
        {
            // Increase or decrease theese values to adjust r, g and b color channels seperately
            const float AvgLumR = 0.5;
            const float AvgLumG = 0.5;
            const float AvgLumB = 0.5;
            
            const float3 LumCoeff = float3(0.2125, 0.7154, 0.0721);
            
            float3 AvgLumin = float3(AvgLumR, AvgLumG, AvgLumB);
            float3 brtColor = color * brt;
            float intensityf = dot(brtColor, LumCoeff);
            float3 intensity = float3(intensityf, intensityf, intensityf);
            float3 satColor = lerp(intensity, brtColor, sat);
            float3 conColor = lerp(AvgLumin, satColor, con);
            return conColor;
        }
        ////

        ////////////////
        ////////////////
        //// http://wiki.polycount.com/wiki/Blending_functions
        float3 Darken (float3 cBase, float3 cBlend)
        {
            float3 cNew;
            cNew.rgb = min(cBase.rgb, cBlend.rgb);
            return cNew;
        }
        
        float3 Multiply (float3 cBase, float3 cBlend)
        {
            return (cBase * cBlend);
        }

        float3 ColorBurn (float3 cBase, float3 cBlend)
        {
            return (1 - (1 - cBase) /  max(0.00001, cBlend));
        }

        float3 LinearBurn (float3 cBase, float3 cBlend)
        {
            return (cBase + cBlend - 1);
        }

        float3 Lighten (float3 cBase, float3 cBlend)
        {
            float3 cNew;
            cNew.rgb = max(cBase.rgb, cBlend.rgb);
            return cNew;
        }
        
        float3 Screen (float3 cBase, float3 cBlend)
        {
            return (1 - (1 - cBase) * (1 - cBlend));
        }

        float3 ColorDodge (float3 cBase, float3 cBlend)
        {
            return (cBase / max(0.00001, (1 - cBlend)));
        }

        float3 LinearDodge (float3 cBase, float3 cBlend)
        {
            return (cBase + cBlend);
        }

        ////
        float3 Overlay (float3 cBase, float3 cBlend)
        {
            float3 isLessOrEq = step(cBase, 0.5);
            float3 cNew = lerp(2*cBlend*cBase, 1 - (1 - 2*(cBase - .5))*(1 - cBlend), isLessOrEq);
            return cNew;
        }

        float3 SoftLight (float3 cBase, float3 cBlend)
        {
            float3 isLessOrEq = step(cBlend, 0.5);
            float3 cNew = lerp(1 - (1 - cBase)*(1 - 2*cBlend*cBase), cBase*(1 - (1 - cBase)*(1 - 2*cBlend)), isLessOrEq);
            return cNew;
        }

        float3 HardLight (float3 cBase, float3 cBlend)
        {
            float3 isLessOrEq = step(cBlend, .5);
            float3 cNew = lerp(1 - (1 - cBase)*(1 - 2*cBlend), 2*cBlend*cBase, isLessOrEq);
            return cNew;
        }
        
        float3 VividLight (float3 cBase, float3 cBlend)
        {
            float3 isLessOrEq = step(cBlend, .5);
            float3 cNew = lerp(1 - (1 - cBase)/(2*(cBlend - .5)), cBase/ max(0.00001, (1 - 2*cBlend)), isLessOrEq);
            return cNew;
        }

        float3 LinearLight (float3 cBase, float3 cBlend)
        {
            float3 isLessOrEq = step(cBlend, .5);
            float3 cNew = lerp(cBase + 2*(cBlend - .5), cBase + 2*cBlend - 1., isLessOrEq);
            return cNew;
        }

        float3 PinLight (float3 cBase, float3 cBlend)
        {
            float3 isLessOrEq = step(cBlend, .5);
            float3 cNew = lerp(max(cBase, 2*(cBlend - .5)), min(cBase, 2*cBlend), isLessOrEq);
            return cNew;
        }
        ////
        ////////////////
        ////////////////

        //// HSVI controller, shorthand control of HSV.
        half3 HSV_controllerToRGB(half3 hsv, half H, half S, half V)
        {
            return HSVToRGB(half3((hsv.x + H), saturate(hsv.y + S), saturate(hsv.z + V)));
        }
        //// converts RGB to HSV with a Saturated white by (I)ntensity
        half3 HSVI_controller(half3 rgb, half H, half S, half V, half I)
        {
            half3 hsv = RGBToHSV(saturate(rgb * I));
            return HSV_controllerToRGB(hsv, H, S, V);
        }
        ////
        half3 HSVI_controller(half3 hsv, half4 hsvi)
        {
            return HSVI_controller(hsv, hsvi.x,hsvi.y,hsvi.z,hsvi.w);
        }
        ////
        half3 HSVI_controllerHueHolder(half3 rgb, half3 hueSource, half S, half V)
        {
            half3 hsv = RGBToHSV(rgb);
            half3 hsvSource = RGBToHSV(hueSource);
            return HSVToRGB(half3(hsvSource.x, saturate(hsv.y + S*hsv.y), max(0,hsv.z + V)));
            // return HSVToRGB(half3(hsvSource.x, saturate(hsv.y + S), max(0,hsv.z + V)));
        }

        //// (catLikeCoding)
        float4 SetupDetail (float4 detailUV)
        {
            return detailUV * 2.0 - 1.0;
        }

        //// A Practical Extension to Microfacet Theory for the Modeling of Varying Iridescence
        //// https://belcour.github.io/blog/research/publication/2017/05/01/brdf-thin-film.html
        //// https://github.com/Xerxes1138/Iridescence/blob/master/Iridescence.shader
        ////
        // XYZ to CIE 1931 RGB color space (using neutral E illuminant)
        // const float3x3 XYZ_TO_RGB = { 2.3706743, -0.5138850,  0.0052982,
        //                              -0.9000405,  1.4253036, -0.0146949,
        //                              -0.4706338,  0.0885814,  1.0093968};
        #define XYZ_TO_RGB float3x3(2.3706743, -0.5138850, 0.0052982,-0.9000405, 1.4253036, -0.0146949, -0.4706338, 0.0885814, 1.0093968)

        // Depolarization functions for natural light
        float depol (float2 polV) { return (polV.x + polV.y) * .5; }
        float3 depolColor (float3 colS, float3 colP) { return (colS + colP) * .5; }

        // Fresnel equations for dielectric/dielectric interfaces.
        void fresnelDielectric( in float ct1, in float n1, in float n2,
                                out float2 R, out float2 phi) 
        {
            R = phi = 0.0;
            float st1  = (1 - ct1 * ct1); // Sinus theta1 'squared'
            float nr  = n1 / n2;

            if(sqr(nr) * st1 > 1)
            { // Total reflection

                float2 R = 1.0;
                float2 phi_float2 = float2( -sqr(nr) * sqrt(st1 - 1.0 / sqr(nr)) / ct1,
                                            -sqrt(st1 - 1.0 / sqr(nr)) / ct1);
                phi = 2.0 * atan( phi_float2);
            } 
            else 
            {   // Transmission & Reflection
                float ct2 = sqrt(1 - sqr(nr) * st1);
                float2 r = float2(  (n2 * ct1 - n1 * ct2) / (n2 * ct1 + n1 * ct2),
                                    (n1 * ct1 - n2 * ct2) / (n1 * ct1 + n2 * ct2));
                phi.x = (r.x < 0.0) ? UNITY_PI : 0.0;
                phi.y = (r.y < 0.0) ? UNITY_PI : 0.0;
                R = sqr(r);
            }
        }

        // Fresnel equations for dielectric/conductor interfaces.
        void fresnelConductor(in float ct1, in float n1, in float n2, in float k,
                            out float2 R, out float2 phi)
        {
            R = phi = 0.0;
            UNITY_BRANCH
            if (k == 0.0) 
            { // use dielectric formula to avoid numerical issues
                fresnelDielectric(ct1, n1, n2, R, phi);
                return;
            }

            float A = sqr(n2) * (1 - sqr(k)) - sqr(n1) * (1 - sqr(ct1));
            float B = sqrt( sqr(A) + sqr(2 * sqr(n2) * k) );
            float U = sqrt((A + B) / 2.0);
            float V = sqrt((B - A) / 2.0);

            R.y = (sqr(n1 * ct1 - U) + sqr(V)) / (sqr(n1 * ct1 + U) + sqr(V));
            float2 var_float2 =  float2((2 * n1 * V * ct1), (sqr(U) + sqr(V) - sqr(n1 * ct1)));
            phi.y = UNITY_PI + atan2( var_float2.x, var_float2.y);

            R.x = ( sqr(sqr(n2) * (1 - sqr(k)) * ct1 - n1 * U) + sqr(2 * sqr(n2) * k * ct1 - n1 * V) ) 
                    / ( sqr(sqr(n2) * (1 - sqr(k)) * ct1 + n1 * U) + sqr(2 * sqr(n2) * k * ct1 + n1 * V) );

            float2 var_float2_2 = float2((2 * n1 * sqr(n2) * ct1 * (2 * k * U - (1 - sqr(k)) * V)),
                                        (sqr(sqr(n2) * (1 + sqr(k)) * ct1) - sqr(n1) * (sqr(U) + sqr(V))));
            phi.x = atan2( var_float2_2.x, var_float2_2.y);
        }

        // Evaluation XYZ sensitivity curves in Fourier space
        float3 evalSensitivity(float opd, float shift) 
        {
            // Use Gaussian fits, given by 3 parameters: val, pos and var
            float phase = 2 * UNITY_PI * opd * 1.0e-6;
            float3 val = float3(5.4856e-13, 4.4201e-13, 5.2481e-13);
            float3 pos = float3(1.6810e+06, 1.7953e+06, 2.2084e+06);
            float3 var = float3(4.3278e+09, 9.3046e+09, 6.6121e+09);
            float3 xyz = val * sqrt(2 * UNITY_PI * var) * cos(pos * phase + shift) * exp(- var * phase * phase);
            xyz.x   += 9.7470e-14 * sqrt(2 * UNITY_PI * 4.5282e+09) * cos(2.2399e+06 * phase + shift) * exp(- 4.5282e+09 * phase * phase);
            return xyz / 1.0685e-7;
        }

        //// 
        float3 renderTFI(float4 mask1, float dotProduct, float dInc, float eta2, float eta3, float kapp3)
        {
            float4 iridescenceMask = mask1;
            float eta_2 = lerp(1.0, eta2, smoothstep(0.0, 0.03, (dInc * iridescenceMask.g)));
            float cosTheta1 = dotProduct;
            float cosTheta2 = sqrt(1.0 - sqr(1.0 / eta_2) * (1.0 - sqr(cosTheta1)));

            // First interface
            float2 R12, phi12;
            fresnelDielectric(cosTheta1, 1.0, eta_2, R12, phi12);
            float2 R21 = R12;
            float2 T121 = 1.0 - R12;
            float2 phi21 = UNITY_PI - phi12;

            // Second interface
            float2 R23, phi23;
            fresnelConductor(cosTheta2, eta_2, eta3, kapp3, R23, phi23);

            // Phase shift
            float OPD = dInc * cosTheta2;
            float2 phi2 = phi21 + phi23;

            // Compound terms
            float3 specColorIridescence = 0.0;
            float2 R123 = R12 * R23;
            float2 r123 = sqrt(R123);
            float2 Rs   = sqr(T121) * R23 / (1 - R123);

            // Reflectance term for m=0 (DC term amplitude)
            float2 C0 = R12 + Rs;
            float3 S0 = evalSensitivity(0.0, 0.0);
            specColorIridescence += depol(C0) * S0;

            // Reflectance term for m>0 (pairs of diracs)
            float2 Cm = Rs - T121;
            for (int m = 1; m <= 3; ++m)
            {
                Cm *= r123;
                float3 SmS = 2.0 * evalSensitivity(m * OPD, m * phi2.x);
                float3 SmP = 2.0 * evalSensitivity(m * OPD, m * phi2.y);
                specColorIridescence += depolColor(Cm.x * SmS, Cm.y * SmP);
            }

            // Convert back to RGB reflectance
            specColorIridescence = saturate(mul(specColorIridescence, XYZ_TO_RGB)); 
            return lerp((1.0), specColorIridescence, iridescenceMask.a);
        }

        ////
        float4 Decal (  float2 uv, float4 baseTexCol, Texture2D decalTex, SamplerState decalSam, float3 color,
                        float4 transforms, 
                        float2 pivotR, float rotate,
                        float2 pivotS, float scale, float2 ratioWH,
                        int blendMode, int usePremultiplyAlpha,
                        float cutoff, float blendAmount,
                        float4 boarder)
        {
            float2 decalUV  = uv;
            float4 bCol     = baseTexCol;
            decalUV         = float2(decalUV.x - transforms.x - decalUV.y * transforms.z,
                                    decalUV.y - transforms.y - decalUV.x * transforms.w);
            decalUV  = rotateUV(decalUV, pivotR.xy, radians(rotate));
            decalUV  = scaleUV(decalUV, pivotS.xy, scale, ratioWH.xy);
            float4 decalCol = decalTex.Sample(decalSam, decalUV);

            UNITY_BRANCH
            if (usePremultiplyAlpha)
            {
                decalCol.rgb    = decalCol.rgb * decalCol.a;
            
            }
            if ( decalCol.a < cutoff || decalUV.x < boarder.x || decalUV.x >= boarder.z || decalUV.y < boarder.y || decalUV.y >= boarder.w)
            {
                decalCol.a = 0;
            }
            if (decalCol.a == 0.0)//// break
            {
                return baseTexCol;
            }
            decalCol.a      = saturate(decalCol.a * blendAmount);

            UNITY_BRANCH
            if (blendMode == 0){//// replace
                bCol.rgb   = lerp( bCol.rgb, color * decalCol.rgb, decalCol.a);
            }
            else if (blendMode == 1)//// add
            {
                bCol.rgb = bCol.rgb + (color * decalCol.rgb * decalCol.a);
            }
            else if (blendMode == 2)//// mult
            {
                bCol.rgb = bCol.rgb * lerp(1.0,  color * decalCol.rgb, decalCol.a);
            }
            else//// detail (rgb)
            {
                bCol.rgb = lerp(bCol.rgb,
                                bCol.rgb * (unity_ColorSpaceDouble.rgb * color * decalCol.rgb),
                                decalCol.a);
            }
            return float4(bCol.rgb, bCol.a);
        }

        //// https://gitlab.com/s-ilent/SCSS
        //// Used with blessing by Silent
        inline float getInventoryMask(float2 in_texcoord)
        {
            // Initialise mask. This will cut things out.
            float inventoryMask = 0.0;
            // Which UV section are we in?
            uint itemID = floor((in_texcoord.x) / _InventoryStride);
            // If the item ID is zero or below, always render.
            // But if it's higher, check against toggles.

            inventoryMask += (itemID <= 0);
            inventoryMask += (itemID == 1) * _InventoryItem01Animated;
            inventoryMask += (itemID == 2) * _InventoryItem02Animated;
            inventoryMask += (itemID == 3) * _InventoryItem03Animated;
            inventoryMask += (itemID == 4) * _InventoryItem04Animated;
            inventoryMask += (itemID == 5) * _InventoryItem05Animated;
            inventoryMask += (itemID == 6) * _InventoryItem06Animated;
            inventoryMask += (itemID == 7) * _InventoryItem07Animated;
            inventoryMask += (itemID == 8) * _InventoryItem08Animated;
            inventoryMask += (itemID == 9) * _InventoryItem09Animated;
            inventoryMask += (itemID == 10) * _InventoryItem10Animated;
            inventoryMask += (itemID == 11) * _InventoryItem11Animated;
            inventoryMask += (itemID == 12) * _InventoryItem12Animated;
            inventoryMask += (itemID == 13) * _InventoryItem13Animated;
            inventoryMask += (itemID == 14) * _InventoryItem14Animated;
            inventoryMask += (itemID == 15) * _InventoryItem15Animated;
            inventoryMask += (itemID == 16) * _InventoryItem16Animated;

            // Higher than 17? Enabled by default
            inventoryMask += (itemID >= 17);

            return (inventoryMask);
            // return round(inventoryMask); // min case is 1.0 so nothing to round
        }

        

#endif