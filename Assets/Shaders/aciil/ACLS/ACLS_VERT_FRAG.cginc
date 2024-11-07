//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
#ifndef ACLS_VERT_FRAG
#define ACLS_VERT_FRAG
    #include "./ACLS_HELPERS.cginc"

//// global properties
    Texture2D _MainTex; uniform float4 _MainTex_ST;
    sampler2D _DepthZoneMask; uniform float4 _DepthZoneMask_ST;
    SamplerState sampler_MainTex;
    uniform float4 _Color;
    uniform int _useAlphaDepthWrite;
#ifdef OutlinesContext
    uniform int _useOutline;
    uniform int _fillOutlineDepth;
#endif // OutlinesContext
// #ifndef NotAlpha
    uniform Texture2D _ClippingMask; uniform float4 _ClippingMask_ST;
    SamplerState sampler_ClippingMask;
    uniform half _Clipping_Level;
    uniform half _Tweak_transparency;
    uniform int _Inverse_Clipping;
    uniform int _IsBaseMapAlphaAsClippingMask;

    uniform int _uvSet_albedo;
    uniform int _uvSet_clippingMask;

    // uniform int _DetachShadowClipping;
    // uniform half _Clipping_Level_Shadow;
// #endif

//// simple depth write
    emptyV2f emptyVert (emptyAppdata v)
    {
        UNITY_SETUP_INSTANCE_ID(v);
        emptyV2f o;
        UNITY_INITIALIZE_OUTPUT(emptyV2f, o);
        UNITY_TRANSFER_INSTANCE_ID(v, o);
        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
        
        o.uv01      = float4(v.uv0, v.uv1);
        o.uv02      = float4(v.uv2, v.uv3);
    #ifdef OutlinesContext
        UNITY_BRANCH
        if (!(_useOutline && _fillOutlineDepth))
        {
            o.vertex = 1.0;
            return o;
        }
    #endif // 
    #ifdef AlphaDepthContext // Alpha Context
        UNITY_BRANCH
        if (!(_useAlphaDepthWrite))
        {
            o.vertex = 1.0;
            return o;
        }
    #endif // 
    
        o.vertex = UnityObjectToClipPos(v.vertex);
        return o;
    }

    fixed4 emptyFrag (emptyV2f i) : SV_Target
    {
        UNITY_SETUP_INSTANCE_ID(i);
        //// alpha
        UV_DD uv_toon           = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_albedo), _MainTex));
        float4 mainTex          = _MainTex.SampleGrad( sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy);
        float4 clipMask         = _ClippingMask.Sample(sampler_ClippingMask, TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_clippingMask), _ClippingMask));
        float useMainTexAlpha   = (_IsBaseMapAlphaAsClippingMask) ? mainTex.a : clipMask.r;
        float alpha             = (_Inverse_Clipping) ? (1.0 - useMainTexAlpha) : useMainTexAlpha;
        // float clipTest          = (_DetachShadowClipping) ? _Clipping_Level_Shadow : _Clipping_Level;
        // clip(alpha - _Clipping_Level);
        clip(alpha - 0.95); //// bad magic number of oblique
        return 0;
    }
////

//// depth start
    depthV2f depthVert (depthAppdata v)
    {
        UNITY_SETUP_INSTANCE_ID(v);
        depthV2f o;
        UNITY_INITIALIZE_OUTPUT(depthV2f, o);
        UNITY_TRANSFER_INSTANCE_ID(v, o);
        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

        // o.uv01 = float4(TRANSFORM_TEX(v.uv, _MainTex).xy, 0, 0);
        o.uv01      = float4(v.uv0, v.uv1);
        o.uv02      = float4(v.uv2, v.uv3);
        o.pos       = UnityObjectToClipPos(v.vertex);
        o.wNormal   = UnityObjectToWorldNormal(v.normal);
        UNITY_TRANSFER_SHADOW(o, 0);
        // TRANSFER_SHADOW(o)
        o.worldPos = mul(UNITY_MATRIX_M, v.vertex).xyz;
        return o;
    }

    fixed4 depthFrag (depthV2f i) : COLOR
    {
        UNITY_SETUP_INSTANCE_ID(i);
        i.wNormal       = normalize(i.wNormal);
        float3 dirView  = normalize(_WorldSpaceCameraPos - i.worldPos.xyz);

    // #ifdef DIRECTIONAL
        UNITY_LIGHT_ATTENUATION_NOSHADOW(lightAtten, i, i.worldPos.xyz);
        half1 shadowAtten = lightAtten;
    // #else
    //     UNITY_LIGHT_ATTENUATION_NOSHADOW(lightAtten, i, i.worldPos.xyz);
    //     half shadowAtten = UNITY_SHADOW_ATTENUATION(i, i.worldPos.xyz);
    // #endif

        float1 ndv              = 1 - abs(dot(dirView, i.wNormal));
        fixed4 depthZoneMask    = tex2D(_DepthZoneMask, UVPick01(i.uv01, i.uv02, 0));
        clip((1-depthZoneMask.r) - 0.5);
        float1 depth    = distance(i.worldPos, worldCameraRawMatrix().xyz);
        return fixed4(depth, ndv, 0, 0);
        // return fixed4(depth, ndv, shadowAtten, 0);
    }
////
#endif // ACLS_VERT_FRAG