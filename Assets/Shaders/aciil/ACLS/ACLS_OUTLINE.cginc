// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
            #include "./ACLS_HELPERS.cginc"

            uniform sampler2D _Outline_Sampler; uniform float4 _Outline_Sampler_ST;
            uniform Texture2D _MainTex;         uniform float4 _MainTex_ST;
            uniform Texture2D _OutlineTex;      uniform float4 _OutlineTex_ST;
            uniform Texture2D _outlineEmissionTint; uniform float4 _outlineEmissionTint_ST;
            uniform Texture2D _outlineEmissionMask; uniform float4 _outlineEmissionMask_ST;
            
            uniform int _uvSet_EmissionColorTex;
            uniform int _uvSet_albedo;

            SamplerState sampler_MainTex;
            SamplerState sampler_OutlineTex;
            SamplerState sampler_outlineEmissionTint;
            SamplerState sampler_outlineEmissionMask;

            uniform int _useOutline;
            uniform half _shadowCastMin_black;
            uniform float4 _Color;
            uniform float4 _Outline_Color;

            uniform int _outline_mode;
            uniform half _Outline_Width;
            uniform half _Farthest_Distance;
            uniform half _Nearest_Distance;
            uniform half _Is_BlendBaseColor;
            uniform half _Offset_Z;
            uniform int _Is_OutlineTex;

            uniform half _indirectAlbedoMaxAveScale;
            uniform half _indirectGIDirectionalMix;
            uniform half _indirectGIDirectionalUseNPR;
            uniform half _indirectGIBlur;
            uniform half _directLightIntensity;
            uniform half _forceLightClamp;
            uniform int _useDistanceDarken;

            uniform int _useAlbedoTexModding;
            uniform half4 _controllerAlbedoHSVI_1;

            uniform float4 _outlineEmissionColor;
            uniform half _outlineEmissiveProportionalLum;
            uniform int _outlineEmissionUseMask;

#ifndef NotAlpha
            uniform Texture2D _ClippingMask; uniform float4 _ClippingMask_ST;
            SamplerState sampler_ClippingMask;
            
            uniform int _uvSet_clippingMask;

            uniform half _Clipping_Level;
            uniform half _Tweak_transparency;
            uniform int _Inverse_Clipping;
            uniform int _IsBaseMapAlphaAsClippingMask;
            uniform int _seperateOutlineAlphaTweak;
            uniform half _Tweak_transparencyOutlines;
#endif



            struct v2f {
                float4 pos          : SV_POSITION;
                float4 worldPos     : TEXCOORD0;
                float4 center       : TEXCOORD1;
                float4 uv01         : TEXCOORD2;
                float4 uv02         : TEXCOORD3;
                float3 wNormal      : TEXCOORD4;
                float3 dirGI        : TEXCOORD5;
                float4 screenPos    : TEXCOORD6;
                UNITY_SHADOW_COORDS(7)
                // LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(8)
                half3 vertexLighting    : TEXCOORD9;
                float outlineThick      : TEXCOORD10;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };



//// vert            
            v2f vert (appdata v) {
                UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                AdaptorDPS(v);
                o.uv01          = float4(v.uv0.xy, v.uv1.xy);
                o.uv02          = float4(v.uv2.xy, v.uv3.xy);
                o.worldPos      = mul( unity_ObjectToWorld, v.vertex);
                o.center        = mul( unity_ObjectToWorld, float4(0,0,0,1));
                //// inventory
                UNITY_BRANCH if (_UseInventory)
                {
                    float inventoryMask = getInventoryMask(v.uv0.xy);
                    UNITY_BRANCH if (!(inventoryMask))
                    {
                        o.pos.z = 1e+9;
                        o.worldPos = 0;
                        o.center = 1e+9;
                        v.vertex = 1e+9;
                        return o;
                    }
                }
                o.wNormal       = UnityObjectToWorldNormal( v.normal);
                if (!(_useOutline))//// remove outlines
                {
                    o.pos = 1e+9;
                    return o;
                }
                float3 worldviewPos     = _WorldSpaceCameraPos;
                // float3 worldviewPos     = StereoWorldViewPos(); //// wrong stereo for offline offset
                float outlineControlTex = tex2Dlod(_Outline_Sampler, float4(TRANSFORM_TEX( UVPick01(o.uv01, o.uv02), _Outline_Sampler), 0, 0)).r;
                o.outlineThick          = outlineControlTex;
                //// https://answers.unity.com/questions/770838/how-can-i-extract-the-fov-information-from-the-pro.html
                const float Rad2Deg = 2 * 180 / UNITY_PI / 90;
                float fovAspect = atan(1.0f / unity_CameraProjection._m11) * Rad2Deg;
                float outlineWidth      = saturate( RemapRange( (distance(o.worldPos.xyz, worldviewPos.xyz)),
                                                _Farthest_Distance, _Nearest_Distance, 0, 1));
                outlineWidth            *= outlineControlTex * _Outline_Width * 0.001;
                outlineWidth            *= fovAspect;
                float3 posDiff          = worldviewPos.xyz - o.worldPos.xyz;
                float3 dirView;
                if (unity_OrthoParams.w)//// mirror camera (hint from ERROR.MDL)
                {
                    dirView = UNITY_MATRIX_V[2].xyz;
                }
                else
                {
                    dirView = normalize(posDiff);
                }
                float4 viewDirectionVP  = mul( UNITY_MATRIX_VP, float4( dirView.xyz, 1));
                float4 posWorldHull     = o.worldPos;
                float3 objectScale      = float3(length(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x)),
                                            length(float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y)),
                                            length(float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z)));
                posWorldHull            = float4(posWorldHull.xyz + o.wNormal * objectScale * outlineWidth , 1);
                // posWorldHull            = float4(posWorldHull.xyz + o.wNormal * outlineWidth, 1);

                UNITY_TRANSFER_FOG(o, o.pos);
                UNITY_TRANSFER_FOG(o, UnityWorldToClipPos(posWorldHull.xyz));
                posWorldHull.xyz    = posWorldHull.xyz + dirView * _Offset_Z;
                o.pos               = UnityWorldToClipPos(posWorldHull.xyz);
                o.screenPos         = ComputeScreenPos(o.pos);
#ifdef VERTEXLIGHT_ON
                float3 vertTo0;
                o.vertexLighting    = softShade4PointLights_Atten(
                    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0
                    , unity_LightColor
                    , unity_4LightAtten0
                    , o.worldPos.xyz, o.wNormal, vertTo0);
#endif
#ifdef UNITY_PASS_FORWARDBASE
                o.dirGI = GIDominantDir();
#endif
                return o;
            } 






//// frag
            float4 frag(
                v2f i,
#ifdef UseAlphaDither //// cutout mode. dont use premultiplay block
                out uint cov : SV_Coverage,
#endif //// UseAlphaDither
                bool frontFace : SV_IsFrontFace) : SV_Target{
                UNITY_SETUP_INSTANCE_ID(i);
                if (!(_useOutline))//// remove outlines
                {
                    #ifdef UseAlphaDither //// null coverage
                    cov = 0;
                    #endif //// UseAlphaDither
                    clip(-1);
                }
                bool isAmbientOnlyMap   = !(any(_LightColor0.rgb));
                bool isBackFace         = !frontFace;
                //// screen pos
                float4 screenPos        = i.screenPos;
                float4 screenUV         = screenPos / (screenPos.w + 0.00001);
            #ifdef UNITY_SINGLE_PASS_STEREO
                screenUV.xy             *= float2(_ScreenParams.x * 2, _ScreenParams.y);
            #else
                screenUV.xy             *= _ScreenParams.xy;
            #endif



//// dynamic shadow
//// found dynamic shadows dont work in the spatiality of outline hulls. This is used for something else.
                half shadowAtten    = 1;
            #ifdef DIRECTIONAL
                half lightAtten     = 1;
            #else
                UNITY_LIGHT_ATTENUATION_NOSHADOW(lightAtten, i, i.worldPos.xyz);
            #endif



//// world light albedo
#ifdef UNITY_PASS_FORWARDBASE
                //// get vertex lighting
                half3 vertexLit = i.vertexLighting;
                //// build indirect light source
                half3 lightIndirectColAve   = DecodeLightProbe_average();   //// L0 Average light
                half3 lightIndirectColL1    = max(0, SHEvalDirectL1(normalize(i.dirGI)));    //// L1 raw. Add to L0 as max color of GI
                half3 lightIndirectColStatic = 0, lightIndirectColDir = 0;
                // if ((_indirectGIDirectionalMix) < 1)
                if (true)
                {
                    half3 stackIndirectMaxL0L1 = lightIndirectColL1 + lightIndirectColAve;
                    half ratioCols = RatioOfColors(stackIndirectMaxL0L1, lightIndirectColAve, _indirectAlbedoMaxAveScale);
                    lightIndirectColStatic  = lerp(stackIndirectMaxL0L1, lightIndirectColAve, ratioCols);
                }
                half3 lightIndirectCol = lightIndirectColStatic;
                if (_indirectGIDirectionalMix > 0)
                {
                    float3 giNormal = float3(0,1,0);
                    UNITY_BRANCH
                    if (_indirectGIDirectionalUseNPR)   { giNormal = normalize(i.worldPos.xyz - i.center.xyz); }
                    else                                { giNormal = i.wNormal; }
                    float4 indirectGIDirectionBlur = float4(giNormal, (_indirectGIBlur) );
                    lightIndirectColDir = max(0, ShadeSH9_ac(indirectGIDirectionBlur)) / (indirectGIDirectionBlur.w);
                    // float3 lightIndirectColAngle = shadeSH9LinearAndWhole(float4(i.wNormal,1));  //// not blur adaptable without intense math
                    lightIndirectCol  = lerp(lightIndirectColStatic, lightIndirectColDir, _indirectGIDirectionalMix);
                }

                //// build direct, indirect
                half3 lightDirect           = _LightColor0.rgb;
                half3 lightIndirectSource   = (lightIndirectCol);
                half3 lightDirectSource     = 0;
                if (isAmbientOnlyMap) //// this setup sucks for preserving Direct light effects
                {
                    if (any(lightIndirectColL1)) //// L1 in pure ambient maps is black. Recover by spliting indirect energy.
                    {
                        lightDirectSource   = lightIndirectColL1;
                    }
                    else
                    {
                        lightDirectSource   = lightIndirectColAve * .3;//// deliberately not 100% sum
                        lightIndirectSource = lightIndirectColAve * .6;
                    }
                }
                else
                {
                    lightDirectSource = lightDirect;
                }
                lightDirectSource = (lightDirectSource + vertexLit * .7) * _directLightIntensity;
                lightIndirectSource += vertexLit * .2;

#elif UNITY_PASS_FORWARDADD
                float3 lightDirect      = _LightColor0.rgb;
                lightDirect             *= lightAtten;
                //// out light source by types
                float3 lightDirectSource    = lightDirect * _directLightIntensity;
                float3 lightIndirectSource  = 0;
                float3 lightIndirectColStatic = 0;
#endif

                //// over-brightness adjestment
                const float intensityTrigger = 1.0;
                UNITY_BRANCH if (_forceLightClamp)
                {
                    // float intensityLight = LinearRgbToLuminance_ac(lightIndirectSource);
                    float lightIndirectSourceIntensity = LinearRgbToLuminance_ac(lightIndirectColStatic);
                    if (lightIndirectSourceIntensity > intensityTrigger) { lightIndirectSource /= lightIndirectSourceIntensity; }
                    float lightDirectSourceIntensity = LinearRgbToLuminance_ac(lightDirectSource);
                    if (lightDirectSourceIntensity > intensityTrigger) { lightDirectSource /= lightDirectSourceIntensity; }

                    // lightIndirectSourceIntensity = LinearRgbToLuminance_ac(lightIndirectSource.rgb);
                    // lightDirectSourceIntensity = LinearRgbToLuminance_ac(lightDirectSource);
                    if (lightDirectSourceIntensity + lightIndirectSourceIntensity > intensityTrigger)
                    {
                        lightDirectSource = lightDirectSource * max(0.1, (intensityTrigger - lightIndirectSourceIntensity * .65));
                    }
                }

//// simple light systems reused
                // half3 lightSimpleSystem = (lightDirectSource * shadowAtten) + lightIndirectSource;
                lightDirect             = lightDirectSource.rgb;
                // lightDirect             = _LightColor0.rgb;
#ifdef UNITY_PASS_FORWARDBASE
                half3 cubeMapAveAlbedo  = ((lightDirect * max(_shadowCastMin_black,_LightShadowData.x) * .5) + lightDirect ) * .5 + lightIndirectSource;
                half lightAverageLum    = LinearRgbToLuminance_ac(cubeMapAveAlbedo);
#elif UNITY_PASS_FORWARDADD
                half3 cubeMapAveAlbedo  = ((lightDirect * max(_shadowCastMin_black,_LightShadowData.x) * .5) + lightDirect) * .5 * lightAtten;
                half lightAverageLum    = LinearRgbToLuminance_ac(cubeMapAveAlbedo);
#endif

                //// maintex
                UV_DD uv_toon           = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_albedo), _MainTex));
                float4 mainTex          = _MainTex.SampleGrad(sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy);



//// clip & alpha handling. Here so clip() may interrupt flow.
                if (!(i.outlineThick)) //// a black mask means nothing
                {
                    clip(-1);
                }
#ifndef NotAlpha
                half4 clipMask         = _ClippingMask.Sample(sampler_ClippingMask, TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_clippingMask), _ClippingMask));
                half useMainTexAlpha   = (_IsBaseMapAlphaAsClippingMask) ? mainTex.a : clipMask.r;
                half alpha             = (_Inverse_Clipping) ? (1.0 - useMainTexAlpha) : useMainTexAlpha;

                half clipTest          = (alpha - _Clipping_Level);
                clip(clipTest);

    #ifndef IsClip
                half alphaTweak = (_seperateOutlineAlphaTweak) ? _Tweak_transparencyOutlines : _Tweak_transparency;
                alpha           = saturate(alpha + alphaTweak);
        #ifdef UseAlphaDither
                uint sampleCount = GetRenderTargetSampleCount();
                // dither pattern with some a2c blending.
                //// Custom Alpha-to-coverage by Dj Lukis.LT. Impliments manual coverage mask for MSAA
                //// https://github.com/lukis101/VRCUnityStuffs/blob/master/Shaders/DJL/A2C-Custom.shader
                //// http://developer.amd.com/wordpress/media/2012/10/GDC11_DX11inBF3.pdf
                //// https://forum.unity.com/threads/stochastic-transparency.831115/ (praise Bglous)
                //// Silent and Xiexe.
                float dither    = ScreenDitherToAlphaCutout_ac(screenUV.xy);
                alpha           = (alpha * sampleCount) + 1. - dither; //// define exact floats, not doing so miss-interrupts (uint) conversion.
                cov             = (1u << (uint)(alpha)) - 1u; //// fill bitmask to covered count
                alpha           = 1;
        #endif //// UseAlphaDither
                alpha           = saturate(alpha);
    #else //// IsClip
                alpha           = 1;
    #endif //// IsClip
#else //// NotAlpha
                float alpha     = 1;
#endif //// NotAlpha



//// albedo mixer
                //// manipulate albedo textures HSVI
                if (_useAlbedoTexModding){
                    mainTex.rgb = HSVI_controller(mainTex.rgb, _controllerAlbedoHSVI_1).rgb;
                }
                //// grab outline albedo tex
                float4 outlineTex   = _OutlineTex.SampleGrad(sampler_OutlineTex, uv_toon.uv, uv_toon.dx, uv_toon.dy);
                // float4 outlineTex   = tex2D( _OutlineTex, TRANSFORM_TEX(  UVPick01(i.uv01, i.uv02), _OutlineTex));
                float3 outlineColor = _Outline_Color.rgb;
                UNITY_BRANCH
                if (_Is_BlendBaseColor)
                {
                    outlineColor    *= mainTex.rgb;
                }
                UNITY_BRANCH
                if (_Is_OutlineTex)
                {
                    outlineColor    *= outlineTex.rgb;
                }

                //// mix light albedo
                outlineColor    *= cubeMapAveAlbedo;

                //// distance darken
                UNITY_BRANCH if (_useDistanceDarken) {
                    outlineColor.rgb *= sqr(saturate((distance(i.worldPos.xyz, StereoWorldViewPos().xyz) + .02) * 5));
                    // outlineColor.rgb *= smoothstep(0, .1, saturate((distance(i.worldPos.xyz, StereoWorldViewPos().xyz) - .0) * 1));
                }



//// emission
                UV_DD uv_EmissionCol_1  = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_EmissionColorTex), _outlineEmissionTint));
                float4 emissionTex1     = _outlineEmissionTint.SampleGrad( sampler_outlineEmissionTint, uv_EmissionCol_1.uv, uv_EmissionCol_1.dx, uv_EmissionCol_1.dy);

                //// prepare tint
                half3 emissionMix   = _outlineEmissionColor.rgb * emissionTex1.rgb * emissionTex1.a;;

                UNITY_BRANCH
                if (_outlineEmissionUseMask)//// use mask
                {
                    UV_DD uv_EmissionMask = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_EmissionColorTex), _outlineEmissionMask));
                    half emissiveMask = _outlineEmissionMask.SampleGrad( sampler_outlineEmissionMask, uv_EmissionMask.uv, uv_EmissionMask.dx, uv_EmissionMask.dy).g;
                    emissionMix *= emissiveMask;
                }

                //// prepare energy/light
                half emissionLums = max(1., _outlineEmissiveProportionalLum * lightAverageLum);
                //// emission mix all
                emissionMix *= emissionLums;

//// mix emission
#ifdef UNITY_PASS_FORWARDBASE
                outlineColor.rgb += emissionMix;
#endif // UNITY_PASS_FORWARDBASE

                UNITY_APPLY_FOG( i.fogCoord, outlineColor);
                float4 outlineColorA = float4(outlineColor, alpha);
                return outlineColorA;
            }