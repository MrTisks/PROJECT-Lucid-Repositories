//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
#ifndef ACLS_CORE
#define ACLS_CORE
            ////
            #include "./ACLS_HELPERS.cginc"

            int _rimLightVersionMode;
            float _rimLightStep;
            // float _rimLightFeather;
            float _rimLightGain;
            float _rimLightStep_AP;
            // float _rimLightFeather_AP;
            float _rimLightGain_AP;
            float _rimLightPow;
            int _rimLightDirectionMode;
            float _rimLightDirectionStep;
            float _rimLightDirectionGain;
            // float _rimLightDirectionFeather;

            Texture2D _NormalMap;       uniform float4 _NormalMap_ST;
            Texture2D _ClippingMask;    uniform float4 _ClippingMask_ST;
            
            Texture2D _MainTex;         uniform float4 _MainTex_ST;
            Texture2D _1st_ShadeMap;    uniform float4 _1st_ShadeMap_ST;
            Texture2D _2nd_ShadeMap;    uniform float4 _2nd_ShadeMap_ST;
            Texture2D _albedoTexHSVIMask;    uniform float4 _albedoTexHSVIMask_ST;


            Texture2D _Set_1st_ShadePosition;   uniform float4 _Set_1st_ShadePosition_ST;
            Texture2D _Set_2nd_ShadePosition;   uniform float4 _Set_2nd_ShadePosition_ST;
            Texture2D _LightMap;                uniform float4 _LightMap_ST;

            Texture2D _crossOverMask;       uniform float4 _crossOverMask_ST;
            Texture2D _crossOverAlbedo;     uniform float4 _crossOverAlbedo_ST;

            Texture2D _HighColor_Tex;       uniform float4 _HighColor_Tex_ST;
            Texture2D _Set_HighColorMask;   uniform float4 _Set_HighColorMask_ST;

            Texture2D _MetallicGlossMap;    uniform float4 _MetallicGlossMap_ST;
            Texture2D _SpecGlossMap;        uniform float4 _SpecGlossMap_ST;
            
            Texture2D _IridescenceMask;    uniform float4 _IridescenceMask_ST;

            Texture2D _tangentShiftMask;    uniform float4 _tangentShiftMask_ST;

            Texture2D _GlossinessMap;       uniform float4 _GlossinessMap_ST;

            Texture2D _SSSThicknessMask;    uniform float4 _SSSThicknessMask_ST;
            
            Texture2D _Set_RimLightMask;    uniform float4 _Set_RimLightMask_ST;
            
            Texture2D _Set_MatcapMask;      uniform float4 _Set_MatcapMask_ST;
            Texture2D _MatCapTexAdd;        uniform float4 _MatCapTexAdd_ST;
            Texture2D _MatCapTexMult;       uniform float4 _MatCapTexMult_ST;
            Texture2D _MatCapTexEmis;       uniform float4 _MatCapTexEmis_ST;
            Texture2D _MatCapTexHardMult;   uniform float4 _MatCapTexHardMult_ST;
            Texture2D _NormalMapForMatCap;  uniform float4 _NormalMapForMatCap_ST;
            Texture2D _Set_MatcapMask_2;      uniform float4 _Set_MatcapMask_2_ST;
            Texture2D _MatCapTexAdd_2;        uniform float4 _MatCapTexAdd_2_ST;
            Texture2D _MatCapTexMult_2;       uniform float4 _MatCapTexMult_2_ST;
            Texture2D _MatCapTexEmis_2;       uniform float4 _MatCapTexEmis_2_ST;
            Texture2D _MatCapTexHardMult_2;   uniform float4 _MatCapTexHardMult_2_ST;
            
            Texture2D _AngelRing_Sampler; uniform float4 _AngelRing_Sampler_ST;

            Texture2D _driverTintTex;       uniform float4 _driverTintTex_ST;

            Texture2D _EmissionMap;         uniform float4 _EmissionMap_ST;
            Texture2D _Emissive_Tex;        uniform float4 _Emissive_Tex_ST;
            Texture2D _EmissionColorTex;    uniform float4 _EmissionColorTex_ST;
            Texture2D _EmissionColorTex2;   uniform float4 _EmissionColorTex2_ST;
            Texture2D _emissionHSVIMask;   uniform float4 _emissionHSVIMask_ST;
            
            TextureCube _CubemapFallback; uniform float4 _CubemapFallback_HDR;

            Texture2D _DetailMap;   uniform float4 _DetailMap_ST;
            Texture2D _DetailMask;  uniform float4 _DetailMask_ST;

            Texture2D _NormalMapDetail; uniform float4 _NormalMapDetail_ST;
            Texture2D _DetailNormalMask; uniform float4 _DetailNormalMask_ST;

            Texture2D _DynamicShadowMask; uniform float4 _DynamicShadowMask_ST; uniform float4 _DynamicShadowMask_TexelSize;

            sampler3D _DitherMaskLOD;

            //// sample sets: normals, albedo(shades/masks), AOs, matcap, emissionTex
            //// limit of 16
            SamplerState sampler_MainTex;
            SamplerState sampler_ClippingMask;
            SamplerState sampler_Set_1st_ShadePosition;
            SamplerState sampler_NormalMap;
            SamplerState sampler_NormalMapForMatCap;
            SamplerState sampler_MatCap_Trilinear_clamp;
            // SamplerState sampler_EmissionMap;
            // SamplerState sampler_EmissionColorTex;
            // SamplerState sampler_EmissionColorTex2;
            // SamplerState sampler_Emissive_Tex;
            SamplerState sampler_DetailMap;
            SamplerState sampler_CubemapFallback;
            SamplerState sampler_decal1;
            // SamplerState sampler_MainTex_trilinear_repeat;
            // SamplerState sampler_Set_1st_ShadePosition_trilinear_repeat;
            // SamplerState sampler_NormalMap_trilinear_repeat;
            // SamplerState sampler_MatCap_Trilinear_clamp;
            // SamplerState sampler_EmissionColorTex_trilinear_repeat;
            // SamplerState sampler_DetailMap_trilinear_repeat;
            // SamplerState sampler_CubemapFallback_trilinear_clamp;
            

            //// alpha
            uniform half _Clipping_Level;
            uniform half _Tweak_transparency;
            uniform int _Inverse_Clipping;
            uniform int _IsBaseMapAlphaAsClippingMask;
            uniform int _UseSpecAlpha;
            //// diffuse, toon ramp
            uniform int _useToonRampSystem;
            uniform float4 _Color;
            uniform float4 _BaseColor;
            uniform float4 _1st_ShadeColor;
            uniform float4 _2nd_ShadeColor;
            uniform int _Use_BaseAs1st;
            uniform int _Use_1stAs2nd;
            uniform half _BaseColor_Step;
            uniform half _ShadeColor_Step;
            uniform half _BaseShade_Feather;
            uniform half _1st2nd_Shades_Feather;
            uniform int _ToonRampFeather_n1_OffsetMode;
            uniform int _ToonRampFeather_n2_OffsetMode;
            uniform int _Diff_GSF_01;
            uniform float _DiffGSF_Offset;
            uniform float _DiffGSF_Feather;
            uniform int _useCrossOverRim;
            uniform int _crossOverUseToonShades;
            uniform half _crossOverPinch;
            uniform half _crossOverStep;
            uniform half _crossOverFeather;
            uniform half _crosspOverRimPow;
            uniform float4 _crossOverTint;
            uniform int _crossOverSourceTexSource;
            uniform int _useDiffuseAlbedoTexturesSet;
            uniform int _toonRampTexturesBlendMode;
            uniform int _DiffToonShadePriority;
            /// lighting texture
            uniform int _useShadePosition;
            uniform float _Set_1st_ShadePositionStrength;
            uniform float _Set_2nd_ShadePositionStrength;
            uniform int _UseLightMap;
            uniform float _lightMapBlur;
            uniform float _lightMapRemapL;
            uniform float _lightMapRemapH;
            uniform float _lightMapGain;
            uniform int _lightMapBlendMode;
            uniform int _lightMapBlendModeCrossOverRim;
            uniform int _lightMapSymmetry;
            uniform float _lightMapStrengthShadeRamp1;
            uniform float _lightMapStrengthShadeRamp2;
            uniform float _lightMapStrengthShadeRampCrossOverRim;
            //// spec
            uniform int _UseSpecularSystem;
            uniform int _WorkflowMode;
            uniform int _SpecOverride;
            uniform half _highColTexSource;
            uniform float4 _SpecularMaskHSV;
            uniform half _Tweak_HighColorMaskLevel;
            uniform int _invertHighColorMask;
            uniform half _HighColor_Power;
            uniform int _UseDiffuseEnergyConservation;
            uniform half _TweakHighColorOnShadow;
            uniform float _Metallicness;
            uniform float _Glossiness;
            //// TFI
            uniform int _useThinFilmIridescence;
            uniform float _Dinc;
            uniform float _eta2;
            uniform float _eta3;
            uniform float _kappa3;
            uniform int _rimLightUseTFICol;
            //// spec layering
            uniform int _specLayersCount;
            uniform float _specColorIntensity;
            uniform float _specMaskLayersPinch;
            uniform float _specMaskLayersOrder;
            uniform float4 _HighColor;
            uniform float4 _specLayerCol2;
            uniform float4 _specLayerCol3;
            uniform int _Is_SpecularToHighColor;
            uniform int _specType2;
            uniform int _specType3;
            uniform float _specLayerRoughExp1;
            uniform float _specLayerRoughExp2;
            uniform float _specLayerRoughExp3;
            uniform float _spaceLayerOffset1;
            uniform float _spaceLayerOffset2;
            uniform float _spaceLayerOffset3;
            uniform float _spaceLayerFeather1;
            uniform float _spaceLayerFeather2;
            uniform float _spaceLayerFeather3;
            uniform float _specLayerHalfAngleTilt2;//// note #1 must not rotate
            uniform float _specLayerHalfAngleTilt3;
            uniform float _specLayerHalfAngleRotate2;// //// note #1 must not rotate
            uniform float _specLayerHalfAngleRotate3;
            //// tangent control
            uniform int _anisotropicDirectionFlip;
            uniform float _anisotropicArry;
            uniform float _shiftTangentShiftScale1;//// unify scale to one setting
            uniform float _specTangentShift1;//// note tangent shift preserved for mask offset
            uniform float _specTangentShift2;
            uniform float _specTangentShift3;
            //// rim light
            uniform float _rimLightIntensity;
            uniform float4 _RimLightColor;
            uniform float4 _Ap_RimLightColor;
            uniform half _Tweak_RimLightMaskLevel;
            uniform int _invertRimLightMask;
            uniform int _useRimLightSystem;
            uniform int _RimLightSource;
            uniform half _RimLightMixMode;
            uniform int _LightDirection_MaskOn;
            uniform half _RimLightAreaOffset;
            uniform half _RimLight_Power;
            uniform half _Ap_RimLight_Power;
            uniform half _RimLight_InsideMask;
            uniform half _Tweak_LightDirection_MaskLevel;
            uniform int _EnvGrazeMix;
            uniform int _EnvGrazeRimMix;
            uniform float _rimAlbedoMix;
            uniform half _rimLightLightsourceType;
            uniform half _envOnRim;
            uniform float _envOnRimColorize;
            uniform int _rimLightUseNPRReduction;
            uniform int _useRimLightOverTone;
            uniform half4 _rimLightOverToneBlendColor1;
            uniform half4 _rimLightOverToneBlendColor2;
            uniform half _rimOverToneStep;
            uniform half _rimOverToneFeather;
            uniform half _rimOverTonePow;
            //// matcap
            uniform float4 _MatCapColAdd;
            uniform float4 _MatCapColMult;
            uniform float4 _MatCapColEmis;
            uniform float4 _MatCapColHardMult;
            uniform half _Is_NormalMapForMatCap;
            uniform float _BumpScaleMatcap;
            uniform int _MatCap;
            uniform int _MatCap2ndLayer;
            uniform half _Is_BlendAddToMatCap;
            uniform half _Tweak_MatCapUV;
            uniform half _Rotate_MatCapUV;
            uniform half _Rotate_NormalMapForMatCapUV;
            uniform half _Is_UseTweakMatCapOnShadow;
            uniform half _TweakMatCapOnShadow;
            uniform half _Tweak_MatcapMaskLevel;
            uniform int _matcapSmoothnessSource0;
            uniform int _matcapSmoothnessSource1;
            uniform int _matcapSmoothnessSource2;
            uniform int _matcapSmoothnessSource3;
            uniform half _BlurLevelMatcap0;
            uniform half _BlurLevelMatcap1;
            uniform half _BlurLevelMatcap2;
            uniform half _BlurLevelMatcap3;
            uniform int _CameraRolling_Stabilizer;
            uniform int _useMCHardMult;
            uniform half _McDiffAlbedoMix;
            uniform int _matcapSpecMaskSwitch;
            uniform int _matcapEmissMaskSwitch;
            uniform half _MatCapTexMultBlend;
            //// angel ring
            uniform int _AngelRing;
            uniform int _ARSampler_AlphaOn;
            uniform float4 _AngelRing_Color;
            uniform float _AR_OffsetU;
            uniform float _AR_OffsetV;
            uniform int _uvSet_AngelRing;
            //// emission
            uniform int _emissionUseStandardVars;
            uniform int _emissionUseMask;
            uniform int _emissionUseMaskDiffuseDimming;
            uniform float4 _EmissionColor;
            uniform float4 _Emissive_Color;
            uniform float4 _Emissive_Color2;
            uniform half _emissionProportionalLum;
            uniform int _emissiveUseMainTexA;
            uniform int _emisLightSourceType;
            uniform half _emissionMixTintDiffuseSlider;
            uniform int _emissionUse2ndTintRim;
            uniform half _emission2ndTintLow;
            uniform half _emission2ndTintHigh;
            uniform half _emission2ndTintPow;
            uniform int _useEmissionHSVI;
            uniform float4 _emissionHSVIController1;

            //// depth
            // uniform half _depthMaxScale;
            //// sss
            uniform int _useSSS;
            uniform int _useFakeSSS;
            // uniform int _useRealSSS;
            // uniform half _SSSDensityReal;
            // uniform half _SSSRim;
            uniform half _SSSLensFake;
            uniform half _SSSDensityFake;
            uniform half _SSSLens;
            uniform half _SSSDepthColL;
            uniform half _SSSDepthColH;
            uniform half3 _SSSColThin;
            uniform half3 _SSSColThick;
            // uniform half3 _SSSColRim;
            // uniform half _SSSRimMaskL;
            // uniform half _SSSRimMaskH;
            //// normalmap
            uniform int _Is_NormalMapToBase;
            uniform int _Is_NormalMapToHighColor;
            uniform int _Is_NormalMapToRimLight;
            uniform int _Is_NormaMapToEnv;
            uniform int _Is_NormaMapEnv;
            uniform float _DetailNormalMapScale01;
            uniform float _BumpScale;
            uniform float _DetailNormalMapScale;
            //// general lighting
            uniform int _eyeStereoViewDirMode;
            uniform int _useDistanceDarken;
            uniform float3 _backFaceColorTint;
            uniform half _shadowCastMin_black;
            uniform half _shadeShadowOffset1;
            uniform half _shadeShadowOffset2;
            uniform half _Is_UseTweakHighColorOnShadow;
            uniform half _Tweak_SystemShadowsLevel;
            uniform int _shadowUseCustomRampNDL;
            uniform half _shadowNDLStep;
            uniform half _shadowNDLFeather;
            uniform half _shadowMaskPinch;
            uniform int _shadowSplits;
            uniform int _ToonRampLightSourceType_Core;
            uniform half _diffuseIndirectDirectSimCoreMix;
            uniform int _ToonRampLightSourceType_Backwards;
            uniform half _diffuseIndirectDirectSimMix;
            uniform int _forceLightClamp;
            uniform float _directLightIntensity;
            uniform half _indirectAlbedoMaxAveScale;
            uniform half _indirectGIDirectionalMix;
            uniform int _indirectGIDirectionalUseNPR;
            uniform half _indirectGIBlur;
            uniform int _useAlbedoTexModding;
            uniform half4 _controllerAlbedoHSVI_1;
            uniform half4 _controllerAlbedoHSVI_2;
            uniform half4 _controllerAlbedoHSVI_3;
            //// reflection
            uniform int _useCubeMap;
            uniform int _rimLightSetPresetCubemap;
            uniform int _GlossinessMapMode;
            uniform int _ENVMmode;
            uniform half _ENVMix;
            uniform half _envRoughness; //// envSmoothness
            uniform int _CubemapFallbackMode;
            //// detail
            uniform half _DetailAlbedo;
            uniform half _DetailSmoothness;
            //// uv sets
            uniform int _uvSet_albedo;
            uniform int _uvSet_albedo1;
            uniform int _uvSet_albedo2;

            uniform int _uvSet_ShadePosition;
            uniform int _uvSet_LightMap;
            uniform int _uvSet_NormalMapDetail;
            uniform int _uvSet_NormalMapForMatCap;
            uniform int _uvSet_DetailMap;
            uniform int _uvSet_driverTintTex;
            uniform int _uvSet_EmissionColorTex;
            uniform int _uvSet_emissionMask;
            uniform int _uvSet_normalmap;
            uniform int _uvSet_specular;
            uniform int _uvSet_glossinessMap;
            uniform int _uvSet_detailMask;
            uniform int _uvSet_detailNormalMask;
            uniform int _uvSet_clippingMask;
            uniform int _uvSet_highColorMask;
            uniform int _uvSet_rimLightMask;
            uniform int _uvSet_matcapMask;
            uniform int _uvSet_grabPassMask;
            uniform int _uvSet_grabPassTintTex;
            uniform int _uvSet_distortionBumpMap;

            ////decals
            Texture2D _decal1;  uniform float4 _decal1_ST;
            uniform int _useDecal1;
            uniform int _uvSet_decal1;
            uniform float4 _decal1_transform;
            uniform float2 _decal1_pivotR;
            uniform float _decal1_rotate;
            uniform float2 _decal1_pivotS;
            uniform float _decal1_scale;
            uniform float2 _decal1_ratioWH;
            uniform int _decal1_blendMode;
            uniform int _decal1_usePremultiplyAlpha;
            uniform float _decal1_cutoff;
            uniform float4 _decal1_boarder;
            uniform float _decal1_blendAmount;
            uniform float4 _decal1_color;
            Texture2D _decal2;  uniform float4 _decal2_ST;
            uniform int _useDecal2;
            uniform int _uvSet_decal2;
            uniform float4 _decal2_transform;
            uniform float2 _decal2_pivotR;
            uniform float _decal2_rotate;
            uniform float2 _decal2_pivotS;
            uniform float _decal2_scale;
            uniform float2 _decal2_ratioWH;
            uniform int _decal2_blendMode;
            uniform int _decal2_usePremultiplyAlpha;
            uniform float _decal2_cutoff;
            uniform float4 _decal2_boarder;
            uniform float _decal2_blendAmount;
            uniform float4 _decal2_color;
            ////decals emission
            Texture2D _DecalEmission1;  uniform float4 _DecalEmission1_ST;
            uniform int _useDecalEmission1;
            uniform int _uvSet_DecalEmission1;
            uniform float4 _DecalEmission1_transform;
            uniform float2 _DecalEmission1_pivotR;
            uniform float _DecalEmission1_rotate;
            uniform float2 _DecalEmission1_pivotS;
            uniform float _DecalEmission1_scale;
            uniform float2 _DecalEmission1_ratioWH;
            uniform int _DecalEmission1_blendMode;
            uniform int _DecalEmission1_usePremultiplyAlpha;
            uniform float _DecalEmission1_cutoff;
            uniform float4 _DecalEmission1_boarder;
            uniform float _DecalEmission1_blendAmount;
            uniform float4 _DecalEmission1_color;

            //// grabpass effects
        #ifdef DepthDataContext
            // UNITY_DECLARE_SCREENSPACE_TEXTURE(_BackDepthTexture);
            // UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture); float4 _CameraDepthTexture_TexelSize;
        #endif // DepthDataContext
        #ifdef GrabPassDataContext
            TEXTURE2D_X(_ScreenGrabACL); float4 _ScreenGrabACL_TexelSize; float4 _ScreenGrabACL_HDR;
            SAMPLER(sampler_ScreenGrabACL);
            // TEXTURE2D_X(_GrabTexture); float4 _GrabTexture_TexelSize; float4 _GrabTexture_HDR;
            // SAMPLER(sampler_GrabTexture);
            // UNITY_DECLARE_SCREENSPACE_TEXTURE(_ScreenGrabACL); float4 _ScreenGrabACL_TexelSize; float4 _ScreenGrabACL_HDR;
            // UNITY_DECLARE_SCREENSPACE_TEXTURE(_GrabTexture); float4 _GrabTexture_TexelSize; float4 _GrabTexture_HDR;
            // UNITY_DECLARE_SCREENSPACE_TEXTURE(_HBlurACL); float4 _HBlurACL_TexelSize; float4 _HBlurACL_HDR;
            // UNITY_DECLARE_SCREENSPACE_TEXTURE(_blurFinalACL); float4 _blurFinalACL_TexelSize;
        #endif // GrabPassDataContext
            Texture2D _grabPassMask; float4 _grabPassMask_ST;
            Texture2D _grabPassTintTex; float4 _grabPassTintTex_ST;
            Texture2D _distortionBumpMap; float4 _distortionBumpMap_ST;
            float _grabPassMix;
            float _grabPassMixAlbedo;
            float4 _grabPassTint;
            float _depthBufferCutout;
            int _useGrabPassHardCut;
            int _useBlurDepth;
            int _useDepthEffects;
            float _blurWidth;
            float _depthPow;
            float _depthFactor;
            float _sigma;
            float _IOR;
            float _IORStrength;
            float _distortionBumpMapScale;
            int _grabPassOverBrightnessClamp;







//// vert            
            g2f vert (appdata v) 
            {
                UNITY_SETUP_INSTANCE_ID(v);
                v2g o;
                // g2f o  = (g2f)0;
                UNITY_INITIALIZE_OUTPUT(v2g, o);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                AdaptorDPS(v);

                o.pos = UnityObjectToClipPos(v.vertex);


                //// ps1 vertex screen snapping
                // float2 grid = _ScreenParams.xy * 0.16;
                // float4 snapped = o.pos;
                // snapped.xyz = o.pos.xyz / o.pos.w;
                // snapped.xy = floor(grid * snapped.xy) / grid;  // This is actual grid
                // snapped.xyz *=  o.pos.w;
                // o.pos = snapped;

                o.uv01          = float4(v.uv0.xy, v.uv1.xy);
                o.uv02          = float4(v.uv2.xy, v.uv3.xy);
                o.worldPos      = mul( unity_ObjectToWorld, v.vertex).xyz;
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
                o.wNormal   = UnityObjectToWorldNormal( v.normal);
                o.tangent   = (float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w));
                o.biTangent = (cross( o.wNormal, o.tangent.xyz ) * v.tangent.w * unity_WorldTransformParams.w);
                o.screenPos = ComputeScreenPos(o.pos);
                o.color     = v.color;
                o.objFront  = UnityObjectToWorldDir(float3(0,0,1));
                o.objRight  = UnityObjectToWorldDir(float3(1,0,0));
	
                COMPUTE_EYEDEPTH(o.eyeDepth);
// #ifdef DepthDataContext
                o.grabPos = ComputeGrabScreenPos(o.pos);
// #endif // DepthDataContext

                // TRANSFER_VERTEX_TO_FRAGMENT(o);
                UNITY_TRANSFER_SHADOW(o, 0);  // o.uv1 used for lightmap variants (dont exist)
                UNITY_TRANSFER_FOG(o, o.pos);

#ifdef VERTEXLIGHT_ON
                o.vertexLighting    = softShade4PointLights_Atten(
                    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0
                    , unity_LightColor
                    , unity_4LightAtten0
                    , o.worldPos.xyz, o.wNormal, o.vertTo0);
#endif                    
#ifdef UNITY_PASS_FORWARDBASE
                o.dirGI       = GIDominantDir();
#endif
                return o;
            }

//// geom 
            //// cite: https://forum.unity.com/threads/is-it-possible-to-have-gpu-instancing-with-geometry-shader.898070/
            //// cite: Cubed shader
            [maxvertexcount(3)]
            void geom(triangle v2g i[3],
                inout TriangleStream<g2f> tristream)
            {
                for (int v = 0; v < 3; v++)
                {
                    UNITY_SETUP_INSTANCE_ID(i[v]);
                    g2f o;
                    UNITY_INITIALIZE_OUTPUT(g2f, o);
                    UNITY_TRANSFER_INSTANCE_ID(i[v], o);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                    
                    o.pos           = i[v].pos;
                    o.color         = i[v].color;
                    o.center        = i[v].center;
                    o.worldPos      = i[v].worldPos;

                    float3 worldviewPos     = StereoWorldViewPos();
                    float3 posDiff          = worldviewPos - i[v].worldPos.xyz;
                    float3 dirView          = normalize(posDiff);
                    float3 wNormalHard = normalize(cross(i[0].worldPos-i[1].worldPos, i[0].worldPos-i[2].worldPos));
                    float3 realNormal = i[v].wNormal;
                    float sign = 1;
                    if (dot(dirView, wNormalHard) < 0 ){ /// lazy backface check
                        sign = -sign;
                    }
                    o.wNormal       = lerp(wNormalHard, i[v].wNormal, saturate(saturate(dot(dirView, sign*realNormal))*2.+.75));
                    // o.wNormal       = wNormalHard; 
                    // o.wNormal       = i[v].wNormal;
                    // o.wNormal       = lerp( i[v].wNormal, lerp(wNormalHard, i[v].wNormal, saturate(dot(dirView, i[v].wNormal)+.75)), sin(_Time.y*3.15)*.5+.5);
                    ////
                    o.tangent       = i[v].tangent;
                    o.biTangent     = i[v].biTangent;
                    o.vertexLighting    = i[v].vertexLighting;
                    o.dirGI         = i[v].dirGI;
                    o.uv01          = i[v].uv01;
                    o.screenPos     = i[v].screenPos;
                    o.vertTo0       = i[v].vertTo0;
// #ifdef DepthDataContext
                    o.grabPos       = i[v].grabPos;
// #endif // DepthDataContext
                    UNITY_TRANSFER_SHADOW(o, 0);
                    UNITY_TRANSFER_FOG(o, o.pos);
                    
                    tristream.Append(o);
                }
                tristream.RestartStrip();
            }









//// frag
            float4 frag(
                // v2g i
                g2f i
                , bool frontFace : SV_IsFrontFace 
#ifdef UseAlphaDither //// cutout mode. dont use premultiplay block
                , out uint cov : SV_Coverage
#endif //// UseAlphaDither
            ) : SV_TARGET 
            {
                UNITY_SETUP_INSTANCE_ID(i);
                float4 debugVal = 0;
                bool isAmbientOnlyMap   = !(any(_LightColor0.rgb));
                bool isBackFace         = !frontFace;
                bool isMirror           = IsInMirror();
                UNITY_BRANCH if(isBackFace) {
                    i.wNormal = -i.wNormal;
                }
                float3 worldViewPos;
                if (_eyeStereoViewDirMode) // dir average between eye
                {
                    worldViewPos = (StereoWorldViewPos() + _WorldSpaceCameraPos.xyz) * .5;
                }
                else // dir per eye 
                {
                    worldViewPos = _WorldSpaceCameraPos;
                }
                float3 posDiff          = worldViewPos - i.worldPos.xyz;
                float viewDis           = length(posDiff);
                float3 dirView;
                UNITY_BRANCH if (unity_OrthoParams.w)//// mirror camera (ERROR.MDL)
                {
                    dirView = UNITY_MATRIX_V[2].xyz;
                }
                else
                {
                    dirView = normalize(posDiff);
                }
                //// screen pos
                float4 uvOriginal   = i.screenPos;
                float4 screenPos    = i.screenPos;
                float4 screenUV     = screenPos / (screenPos.w + 0.00001);
                //// screen uv
            #ifdef UNITY_SINGLE_PASS_STEREO
                screenUV.xy             *= float2(_ScreenParams.x * 2, _ScreenParams.y);
            #else
                screenUV.xy             *= _ScreenParams.xy;
            #endif
#ifdef DepthDataContext
                int haveDepth = 0;
            #ifdef SOFTPARTICLES_ON // linked with depth texture
                haveDepth = 1;
            #endif // SOFTPARTICLES_ON
                float surfaceDepth = i.eyeDepth; // depth to near clip
                //// note: disabled support of backface depth until solution found for combining with depth buffer and grabpass effects.
                // float frontDepth    = distance(i.worldPos.xyz, worldCameraRawMatrix().xyz); // depth from camera to surface (radial)
                // float4 depthMap     = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_BackDepthTexture, i.grabPos.xy/i.grabPos.w);
                // float backDepth     = depthMap.r;
                // float volDepth      = min(1.0, (backDepth - frontDepth) / (1. + _depthMaxScale));
                // volDepth            *= dot(dirView, UNITY_MATRIX_V[2].xyz); //// (Slerpy) screen edge depth correction
                float volDepth      = 1.0;
#else
                float4 depthMap     = 1.0;
                float volDepth      = 1.0;
#endif // DepthDataContext
                //// helper vars
                half mip,testw,testw2,testh,lodMax;
                mip = testw = testw2 = testh = lodMax = 0;
                
                

//// normal map
                UV_DD uv_normalMap              = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_normalmap), _NormalMap));
                UV_DD uv_normalMapDetail        = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_NormalMapDetail), _NormalMapDetail));
                UV_DD uv_normalMapDetailMask    = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_detailNormalMask), _DetailNormalMask));
                float3 normalMap                = UnpackScaleNormal(_NormalMap.SampleGrad( sampler_NormalMap, uv_normalMap.uv, uv_normalMap.dx, uv_normalMap.dy), _BumpScale);
                UNITY_BRANCH if (_DetailNormalMapScale01)
                {
                    float4 normalDetailMask = _DetailNormalMask.SampleGrad( sampler_MainTex, uv_normalMapDetailMask.uv, uv_normalMapDetailMask.dx, uv_normalMapDetailMask.dy);
                    float3 normalMapDetail  = UnpackScaleNormal( _NormalMapDetail.SampleGrad( sampler_NormalMap, uv_normalMapDetail.uv, uv_normalMapDetail.dx, uv_normalMapDetail.dy), _DetailNormalMapScale);
                    normalMap               = lerp( normalMap, BlendNormals(normalMap, normalMapDetail), (normalDetailMask.g * _DetailNormalMapScale01));
                }
                float3 dirTangent   = normalize(i.tangent.xyz);
                float3 dirBitangent = normalize(i.biTangent.xyz);
                i.wNormal           = normalize(i.wNormal); //// might need to be after 3x3 matrix
                float3x3 tangentTransformMatrix   = float3x3(dirTangent, dirBitangent, i.wNormal); //// might want not normalized 3 direction vectors
                float3 dirNormal            = normalize( mul( normalMap, tangentTransformMatrix ));
                // dirTangent          = normalize(dirTangent);
                // dirBitangent        = normalize(dirBitangent);

                // //// tangent from uv set
                //// https://irrlicht.sourceforge.io/forum/viewtopic.php?p=304294
                // float2 uvDD = UVPick01(i.uv01, i.uv02);
                // float3 denormTangent = ddx(uvDD.y)*ddy(i.worldPos.xyz)-ddx(i.worldPos.xyz)*ddy(uvDD.y);
                // float3 tangent = normalize(denormTangent-i.wNormal*dot(i.wNormal,denormTangent));
                // return float4(dot(dirView,tangent).xxx*.5+.5, 1);



//// albedo texure
                UV_DD uv_toon           = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_albedo), _MainTex));
                float4 mainTex          = _MainTex.SampleGrad( sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy);


//// decals
                UNITY_BRANCH
                if (_useDecal1)
                {
                    mainTex = Decal(    frac(UVPick01(i.uv01, i.uv02, _uvSet_decal1)), mainTex.rgba, _decal1, sampler_decal1, _decal1_color.rgb,
                                        _decal1_transform.xyzw,
                                        _decal1_pivotR.xy, _decal1_rotate,
                                        _decal1_pivotS.xy, _decal1_scale, _decal1_ratioWH.xy,
                                        _decal1_blendMode, _decal1_usePremultiplyAlpha,
                                        _decal1_cutoff, _decal1_blendAmount,
                                        _decal1_boarder);
                }
                UNITY_BRANCH
                if (_useDecal2)
                {
                    mainTex = Decal(    frac(UVPick01(i.uv01, i.uv02, _uvSet_decal2)), mainTex.rgba, _decal2, sampler_decal1, _decal2_color.rgb,
                                        _decal2_transform.xyzw,
                                        _decal2_pivotR.xy, _decal2_rotate,
                                        _decal2_pivotS.xy, _decal2_scale, _decal2_ratioWH.xy,
                                        _decal2_blendMode, _decal2_usePremultiplyAlpha,
                                        _decal2_cutoff, _decal2_blendAmount,
                                        _decal2_boarder);
                }

//// detail textures
                UV_DD uv_detalAlbedo    = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_DetailMap), _DetailMap));
                half4 detailMap         = _DetailMap.SampleGrad( sampler_DetailMap, uv_detalAlbedo.uv, uv_detalAlbedo.dx, uv_detalAlbedo.dy);///R albedo, B smoothness
                // half4 detailMap         = SetupDetail( _DetailMap.SampleGrad( sampler_DetailMap, uv_detalAlbedo.uv, uv_detalAlbedo.dx, uv_detalAlbedo.dy));///R albedo, B smoothness
                half4 detailMask         = _DetailMask.SampleGrad( sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy);
//// clip & alpha handling. Here so clip() may interrupt flow.
#ifndef NotAlpha
                float4 clipMask         = _ClippingMask.Sample(sampler_ClippingMask, TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_clippingMask), _ClippingMask));
                float useMainTexAlpha   = (_IsBaseMapAlphaAsClippingMask) ? mainTex.a : clipMask.r;
                float alpha             = (_Inverse_Clipping) ? (1.0 - useMainTexAlpha) : useMainTexAlpha;
                float clipTest          = (alpha - _Clipping_Level);
                clip(clipTest);

    #ifndef IsClip
                alpha           = saturate(alpha + _Tweak_transparency);
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


//// toon shade manual paint textures
                UV_DD uv_toon1           = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_albedo1), _1st_ShadeMap));
                UV_DD uv_toon2           = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_albedo2), _2nd_ShadeMap));
                float4 coreAlbedoTex        = _1st_ShadeMap.SampleGrad(sampler_MainTex, uv_toon1.uv, uv_toon1.dx, uv_toon1.dy);
                float4 backwardAlbedoTex    = _2nd_ShadeMap.SampleGrad(sampler_MainTex, uv_toon2.uv, uv_toon2.dx, uv_toon2.dy);
                //// assign manual albedo ramp colors by textures
                float4 shadeAlbedoTex1 = mainTex;
                float4 shadeAlbedoTex2 = mainTex;
                float4 shadeAlbedoTex3 = mainTex;
                UNITY_BRANCH
                if (_useDiffuseAlbedoTexturesSet) //// _useDiffuseAlbedoTexturesSet
                {
                    UNITY_BRANCH
                    switch (_Use_BaseAs1st){
                        default:
                        case 0: shadeAlbedoTex2 = coreAlbedoTex; break;
                        case 1: shadeAlbedoTex2 = mainTex; break;
                        case 2: shadeAlbedoTex2 = backwardAlbedoTex; break;
                    }
                    UNITY_BRANCH
                    switch (_Use_1stAs2nd){
                        default:
                        case 0: shadeAlbedoTex3 = backwardAlbedoTex; break;
                        case 1: shadeAlbedoTex3 = coreAlbedoTex; break;
                        case 2: shadeAlbedoTex3 = mainTex; break;
                    }
                }
                //// manipulate albedo textures HSVI
                UNITY_BRANCH if (_useAlbedoTexModding){
                    float4 albedoTexHSVIMask = _albedoTexHSVIMask.SampleGrad( sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy);
                    shadeAlbedoTex1.rgb = lerp(shadeAlbedoTex1.rgb, HSVI_controller(shadeAlbedoTex1.rgb, _controllerAlbedoHSVI_1), albedoTexHSVIMask.g);
                    shadeAlbedoTex2.rgb = lerp(shadeAlbedoTex2.rgb, HSVI_controller(shadeAlbedoTex2.rgb, _controllerAlbedoHSVI_2), albedoTexHSVIMask.g);
                    shadeAlbedoTex3.rgb = lerp(shadeAlbedoTex3.rgb, HSVI_controller(shadeAlbedoTex3.rgb, _controllerAlbedoHSVI_3), albedoTexHSVIMask.g);
                }



//// early light dir pass. Had a use.
#ifdef UNITY_PASS_FORWARDBASE
                float3 dirLight   = _WorldSpaceLightPos0.xyz;
#elif UNITY_PASS_FORWARDADD
                float3 dirLight   = normalize( lerp( _WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.worldPos.xyz, _WorldSpaceLightPos0.w));
#endif
                UNITY_BRANCH if (!(any(_LightColor0.rgb))) // black dynamic lights, likely for triggering depth buffer
                {
                    dirLight = float3(0,0,0);
                }

//// main light direction with weighted factors of light types
#ifdef UNITY_PASS_FORWARDBASE
                float3 viewLightDirection   = normalize( UNITY_MATRIX_V[2].xyz + UNITY_MATRIX_V[1].xyz); // [1] = camera y upward, [2] = camera z forward
                //// experiment for weighted angles.
                // dirLight                    = dot(1, lightDirect) * _WorldSpaceLightPos0.xyz + dot(1, lightIndirectColAve) * (i.dirGI)  + dot(1, vertexLit) * (i.vertTo0) + (.0001 * viewLightDirection);
                dirLight                    = 100*(dirLight) + .01*(i.dirGI) + (i.vertTo0) + .0001*(viewLightDirection);
                dirLight                    = normalize(dirLight);
                // return float4(((.5*dot(dirLight, i.wNormal)+.5)).xxx, 1);
#elif UNITY_PASS_FORWARDADD
#endif
                UNITY_BRANCH if (isBackFace) //// treat backfaces towards light
                {
                    dirLight    = -dirLight;
                }

//// dot() set. Organized extensive input values per effect, per normal map
                ////
                float3 dirNormalToonRamp        = _Is_NormalMapToBase       ? dirNormal : i.wNormal;
                float3 dirNormalSpecular        = _Is_NormalMapToHighColor  ? dirNormal : i.wNormal;
                float3 dirNormalEnv             = _Is_NormaMapToEnv         ? dirNormal : i.wNormal;
                float3 dirNormalRimLight        = _Is_NormalMapToRimLight   ? dirNormal : i.wNormal;
                float3 dirHalf                  = normalize(dirLight + dirView);
                float ldh_Norm_Full             = dot(dirLight, dirHalf);
                float ldh_Norm_Cap              = saturate(ldh_Norm_Full);
                float vdh_Norm_Full             = dot(dirView, dirHalf);
                //// normal toon
                struct Dot_Diff { float ndl; float ndv; float ldhS; float ldh;};
                Dot_Diff dDiff;
                dDiff.ndl   = dot(dirNormalToonRamp, dirLight)*.5+.5;
                dDiff.ndv   = dot(dirNormalToonRamp, dirView);
                dDiff.ldhS  = ldh_Norm_Full*.5+.5;
                // dDiff.ldh   = saturate(ldh_Norm_Full);
                //// normal spec
                struct Dot_Spec { float ndhS; float ndh; float ndlS; float ndl; float ndv; float vdh; float ldh;};
                float spec_ndh  = dot(dirNormalSpecular, dirHalf);
                float spec_ndl  = dot(dirNormalSpecular, dirLight);
                Dot_Spec dSpec;
                dSpec.ndhS      = spec_ndh *.5+.5;
                dSpec.ndh       = saturate(spec_ndh);
                dSpec.ndlS      = spec_ndl *.5+.5;
                dSpec.ndl       = saturate(spec_ndl);
                dSpec.ndv       = saturate(dot(dirNormalSpecular, dirView));
                dSpec.vdh       = saturate(vdh_Norm_Full);
                dSpec.ldh       = ldh_Norm_Cap;
                //// normal env
                struct Dot_Env {float ndv; float ldh; float3 dirViewReflection;};
                Dot_Env dEnv;
                dEnv.ndv                = saturate(dot(dirNormalEnv, dirView));
                dEnv.ldh                = ldh_Norm_Cap;
                dEnv.dirViewReflection  = reflect(-dirView, dirNormalEnv);
                //// normal rimLight
                struct Dot_RimLight {float ndv; float ndlS;};
                Dot_RimLight dRimLight;
                dRimLight.ndv   =  ( dot(dirNormalRimLight, dirView) + (.5*smoothstep(.1, 0, viewDis)));//// needs [-1,1]
                dRimLight.ndlS  = dot(dirNormalRimLight, dirLight)*.5+.5;
                //// emission
                struct Dot_Emission {float ndv;};
                Dot_Emission dEmiss;
                dEmiss.ndv      = dot(i.wNormal, dirView);



//// Light attenuation (falloff and shadows), used for mixing in shadows and effects that react to shadow
            //// experiment
            /*
                fixed shadowAttenuationRaw = 0;
            #if defined(SHADOWS_SCREEN)
                screenPos.xy        = screenPos.xy / screenPos.w;
                shadowAttenuationRaw  =(tex2Dlod(_ShadowMapTexture, float4(screenPos.xy, .5, 0)).r);
            
                // shadowAttenuationRaw   =
                //     ( tex2Dlod(_ShadowMapTexture, float4(0.25, 0.25, 0, 0.5)).r)
                //     + ( tex2Dlod(_ShadowMapTexture, float4(0.25, 0.75, 0, 0.5)).r)
                //     + ( tex2Dlod(_ShadowMapTexture, float4(0.5, 0.5, 0, 0.5)).r)
                //     + ( tex2Dlod(_ShadowMapTexture, float4(0.75, 0.25, 0, 0.5)).r)
                //     + ( tex2Dlod(_ShadowMapTexture, float4(0.75, 0.75, 0, 0.5)).r);
                // shadowAttenuationRaw   *= 0.2;
            #endif
                return float4(shadowAttenuationRaw.xxx,1);
            */
            #ifdef DIRECTIONAL
                //// directional lights handle UNITY_LIGHT_ATTENUATION() differently. I want to split attenuation and shadows, but both concepts fuse in directional lights
                // UNITY_LIGHT_ATTENUATION(lightAtten, i, i.worldPos.xyz);
                UNITY_LIGHT_ATTENUATION_NOSHADOW(lightAtten, i, i.worldPos.xyz);
                if (isAmbientOnlyMap) /// lightAtten is undefined in scenes without directional lights. Using this raw is unstable so we correct when missing the shadow data.
                {
                    lightAtten = 1;
                }
                half shadowAtten = lightAtten;

            #else
                UNITY_LIGHT_ATTENUATION_NOSHADOW(lightAtten, i, i.worldPos.xyz);
                half shadowAtten = UNITY_SHADOW_ATTENUATION(i, i.worldPos.xyz);
            #endif
                if (_shadowUseCustomRampNDL) //// nDl shadow
                {
                    half nDlSha = dot(dirNormalToonRamp, dirLight) * .5 + .5;                    
                    nDlSha      = StepFeatherRemap(nDlSha, _shadowNDLStep, _shadowNDLFeather);
                    shadowAtten = (shadowAtten * nDlSha);
                    // shadowAtten = min(shadowAtten, nDlSha);
                }
                if (_shadowMaskPinch)
                {
                    shadowAtten = saturate(RemapRange(shadowAtten, 0, 1 - _shadowMaskPinch, 0, 1));
                }
                if (_shadowSplits)
                {
                    shadowAtten = round(shadowAtten * _shadowSplits) / _shadowSplits; 
                }
                
                //// setup shadow darkness control
                shadowAtten = RemapRange(shadowAtten, max(0, _LightShadowData.x - .001), 1, 0, 1);//// floor shadow to 0.0, to normalize
                half shadowMaskNormalized = shadowAtten;
                half shadowRemoval = 0;
                UNITY_BRANCH
                if ( (_shadowCastMin_black) || !(_DynamicShadowMask_TexelSize.z <16)) 
                {
                    half dynamicShadowMask = _DynamicShadowMask.SampleGrad(sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy).g;
                    shadowRemoval = max(_shadowCastMin_black, dynamicShadowMask);
                }
                // shadowAtten = shadowAtten + shadowRemoval;
                shadowAtten = 1 - ((1-shadowAtten) * (1-shadowRemoval));
                shadowAtten = saturate(RemapRange(shadowAtten, 0, 1, _LightShadowData.x + .001, 1));//// then return 0.0 to floor



//// collect scene light sources. sLight
#ifdef UNITY_PASS_FORWARDBASE
                //// prepare cubemap albedo support lighting
                half3 refGIcol  = shadeSH9LinearAndWhole(float4(normalize(i.wNormal + dEnv.dirViewReflection),1)); //// gi light at a weird angle
                half3 colGIGray = LinearRgbToLuminance_ac(refGIcol);
                //// get vertex lighting
                half3 vertexLit = i.vertexLighting;
                //// build indirect light source
                half3 lightIndirectColAve   = DecodeLightProbe_average();   //// L0 Average light
                half3 lightIndirectColL1    = max(0, SHEvalDirectL1(normalize(i.dirGI)));    //// L1 raw. Add to L0 as max color of GI
                half3 lightIndirectColStatic = 0, lightIndirectColDir = 0;
                ////
                half3 stackIndirectMaxL0L1 = lightIndirectColL1 + lightIndirectColAve;
                half ratioCols = RatioOfColors(stackIndirectMaxL0L1, lightIndirectColAve, _indirectAlbedoMaxAveScale);
                lightIndirectColStatic = lerp(stackIndirectMaxL0L1, lightIndirectColAve, ratioCols);
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
                //// build direct light source
                half3 lightDirect   = _LightColor0.rgb;
                half3 lightIndirectSource  = (lightIndirectCol);
                //// build direct light
                half3 lightDirectSource = 0;
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
                // float3 lightDirectSource    = (mixColorsMaxAve(lightIndirectColL1, lightDirect) + vertexLit) * _directLightIntensity;

#elif UNITY_PASS_FORWARDADD
                float3 lightDirect      = _LightColor0.rgb;
                lightDirect             *= lightAtten;
                //// out light source by types
                float3 lightDirectSource    = lightDirect * _directLightIntensity;
                float3 lightIndirectSource  = 0;
                half3 lightIndirectColStatic  = 0;
#endif

                //// over-brightness adjestment
                const float intensityTrigger = 1.0;
                UNITY_BRANCH if (_forceLightClamp)
                {
                    // float intensityLight = LinearRgbToLuminance_ac(lightIndirectColStatic.rgb);
                    float lightIndirectSourceIntensity = LinearRgbToLuminance_ac(lightIndirectColStatic);
                    if (lightIndirectSourceIntensity > intensityTrigger) { lightIndirectSource /= lightIndirectSourceIntensity; }
                    float lightDirectSourceIntensity = LinearRgbToLuminance_ac(lightDirectSource);
                    if (lightDirectSourceIntensity > intensityTrigger) { lightDirectSource /= lightDirectSourceIntensity; }

                    // lightIndirectSourceIntensity = LinearRgbToLuminance_ac(lightIndirectSource);
                    // lightDirectSourceIntensity = LinearRgbToLuminance_ac(lightDirectSource);
                    if ((lightDirectSourceIntensity + lightIndirectSourceIntensity) > (intensityTrigger))
                    {
                        lightDirectSource = lightDirectSource * max(0.1, (intensityTrigger - lightIndirectSourceIntensity * .65));
                    }
                }


//// simple light systems reused. slsys
                half3 lightSimpleSystem = (lightDirectSource * shadowAtten) + lightIndirectSource;
                lightDirect             = lightDirectSource.rgb;
                // lightDirect             = _LightColor0.rgb;
#ifdef UNITY_PASS_FORWARDBASE
                half3 cubeMapAveAlbedo  = ((lightDirect * _LightShadowData.x * .5) + lightDirect ) * .5 + lightIndirectSource;
                half lightAverageLum    = LinearRgbToLuminance_ac(cubeMapAveAlbedo);
#elif UNITY_PASS_FORWARDADD
                half3 cubeMapAveAlbedo  = ((lightDirect * _LightShadowData.x * .5) + lightDirect) * .5 * lightAtten;
                half lightAverageLum    = LinearRgbToLuminance_ac(cubeMapAveAlbedo);
#endif


/// LightMap
                float lightMapBias_1 = .5;
                float lightMapBias_2 = .5;
                float lightMapBias_Spec = 1;
                float lightMapBias_crossOverRim = .5;
                float4 lightMap      = 0.5;
                UNITY_BRANCH
                if (_UseLightMap)
                {
                    UV_DD uv_lightMap = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_LightMap), _LightMap));
                    float objectFrontDot = dot(dirLight, i.objFront);
                    float objectRightDot = dot(dirLight, i.objRight);
                    UNITY_BRANCH
                    if (_lightMapSymmetry)
                    {
                        if ((objectRightDot >= 0))
                        {
                            uv_lightMap.uv.x = 1 - uv_lightMap.uv.x;
                        }
                    }
                    float lightMapLodMax = 0;
                    _LightMap.GetDimensions(mip,testw2,testh,lightMapLodMax);
                    lightMap    = _LightMap.SampleLevel(sampler_MainTex, uv_lightMap.uv, (lightMapLodMax * _lightMapBlur));

                    //// enum mode 2. Use vertex color red
                    UNITY_BRANCH
                    if (_UseLightMap > 1) { //// use vertex color 
                        lightMap.g *= i.color.r;
                    }
                    lightMap.g = saturate(RemapRange(lightMap.g, 0, 1, _lightMapRemapL, _lightMapRemapH));// relevel texture range
                    lightMap.g = saturate(gain( (lightMap.g), _lightMapGain) );// recurve core volume leaving center and edges same
                    UNITY_BRANCH
                    if (_lightMapSymmetry)
                    {
                        float nullWeight = .5;
                        if (_lightMapBlendMode) {nullWeight = 1;}
                        float obDF = objectFrontDot*.5+.5;
                        float obDB = 1-obDF;
                        lightMap.g = lerp(lightMap.g, nullWeight, pow(1 - (1-obDF) * (1-obDB), 2)); // weakin mask
                    }

                    //// bright side mix
                    lightMapBias_1 = lightMap.g;
                    //// dark side mix
                    lightMapBias_2 = lightMap.g;
                    //// specular hDl. Needs own curve control for half dot bias
                    lightMapBias_Spec = lightMap.g;
                    ////
                    lightMapBias_crossOverRim = lightMap.g;
                }

//// toon ramp, prepare ramp masks
                //// Normalized values: 1 represents brighter, 0 darker
                //// toon ramp AO masks. These down ramp as to "force shadow"
                float shadowTex_1 = 1;
                float shadowTex_2 = 1;
                UNITY_BRANCH if (_useShadePosition)
                {
                    UV_DD uv_ShadePosition  = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_ShadePosition), _MainTex));
                    shadowTex_1 = _Set_1st_ShadePosition.SampleGrad(sampler_Set_1st_ShadePosition, uv_ShadePosition.uv, uv_ShadePosition.dx, uv_ShadePosition.dy).g;
                    shadowTex_2 = _Set_2nd_ShadePosition.SampleGrad(sampler_Set_1st_ShadePosition, uv_ShadePosition.uv, uv_ShadePosition.dx, uv_ShadePosition.dy).g;
                    shadowTex_1 = saturate(_Set_1st_ShadePositionStrength * (shadowTex_1 - 1) + 1);// shadowTex_1 = lerp(1, shadowTex_1, _Set_1st_ShadePositionStrength);
                    shadowTex_2 = saturate(_Set_2nd_ShadePositionStrength * (shadowTex_2 - 1) + 1);
                }

                //// Assist for shadow mask
                float shadeRamp_n1 = dDiff.ndl;//// ndl Core area
                float shadeRamp_n2 = dDiff.ndl;//// ndl Backward area
                //// light mask setup. N dol L modified by ****. 50% gray mean natural influence.
                half step_core      = _BaseColor_Step;
                half step_backward  = _ShadeColor_Step;
                half feather_BaseShade     = _BaseShade_Feather;
                half feather_1st2ndShades = _1st2nd_Shades_Feather;
                half offsetMode_ToonRampFeather_n1_ = _ToonRampFeather_n1_OffsetMode;
                half offsetMode_ToonRampFeather_n2_ = _ToonRampFeather_n2_OffsetMode;
                if (!(_useToonRampSystem)) //// remove toon ramp. Optimizer script will purge half the code. Optimizer does not like writing over properties
                {
                    step_core = 0.0;
                    step_backward = 0.0;
                    feather_BaseShade = 1.0;
                    feather_1st2ndShades = 1.0;
                    offsetMode_ToonRampFeather_n1_ = 0;
                    offsetMode_ToonRampFeather_n2_ = 0;
                }
                UNITY_BRANCH if (_UseLightMap)
                {
                    if (_lightMapBlendMode) // darken
                    { 
                        shadeRamp_n1 = shadeRamp_n1 * ((lightMapBias_1 - 1) * (_lightMapStrengthShadeRamp1 * 2) + 1);
                        shadeRamp_n2 = shadeRamp_n2 * ((lightMapBias_2 - 1) * (_lightMapStrengthShadeRamp2 * 2) + 1);                        
                    } 
                    else // bias
                    {
                        float lightMapStrengthShadeRamp1Scale = _lightMapStrengthShadeRamp1 * 2;
                        float lightMapStrengthShadeRamp2Scale = _lightMapStrengthShadeRamp2 * 2;
                        float lightMapBias_1_range = lightMapBias_1 * 2 - 1;
                        float lightMapBias_2_range = lightMapBias_2 * 2 - 1;
                        //// note, can go out of [0,1] range
                        shadeRamp_n1 = lerp( shadeRamp_n1, lerp(shadeRamp_n1, lightMapBias_1, pow(abs(lightMapBias_1_range), 2) * (lightMapStrengthShadeRamp1Scale) ) + (lightMapBias_1_range), (lightMapStrengthShadeRamp1Scale));
                        shadeRamp_n2 = lerp( shadeRamp_n2, lerp(shadeRamp_n2, lightMapBias_2, pow(abs(lightMapBias_2_range), 2) * (lightMapStrengthShadeRamp2Scale) ) + (lightMapBias_2_range), (lightMapStrengthShadeRamp2Scale));
                        // shadeRamp_n1 = lerp(shadeRamp_n1, lightMapBias_1, _lightMapStrengthShadeRamp1);
                        // shadeRamp_n2 = lerp(shadeRamp_n2, lightMapBias_2, _lightMapStrengthShadeRamp2);
                    }
                }
                //// d.shadow shifting //// note, can move ramp to negative range
                half dsMask = (1 - shadowMaskNormalized) * 2;
                shadeRamp_n1 -= (_shadeShadowOffset1 * dsMask); 
                shadeRamp_n2 -= (_shadeShadowOffset2 * dsMask);

                float sR_n1_stepOffset;
                UNITY_BRANCH 
                switch (offsetMode_ToonRampFeather_n1_) {
                    default: sR_n1_stepOffset = feather_BaseShade; break;
                    case 0: sR_n1_stepOffset = feather_BaseShade; break;
                    case 1: sR_n1_stepOffset = (feather_BaseShade * .5); break;
                    case 2: sR_n1_stepOffset = 0; break;
                }
                shadeRamp_n1    = saturate(shadeRamp_n1 + sR_n1_stepOffset - step_core);
                shadeRamp_n1    = shadowTex_1 * shadeRamp_n1 / (feather_BaseShade);
                ////
                float sR_n2_stepOffset;
                UNITY_BRANCH
                switch (offsetMode_ToonRampFeather_n2_) {
                    default: sR_n2_stepOffset = feather_1st2ndShades; break;
                    case 0: sR_n2_stepOffset = feather_1st2ndShades; break;
                    case 1: sR_n2_stepOffset = (feather_1st2ndShades * .5); break;
                    case 2: sR_n2_stepOffset = 0; break;
                }
                shadeRamp_n2    = saturate(shadeRamp_n2 + sR_n2_stepOffset - step_backward);
                shadeRamp_n2    = shadowTex_2 * shadeRamp_n2 / ( feather_1st2ndShades );
                //// final saturate bc many affects can push it out of range
                shadeRamp_n1    = saturate(shadeRamp_n1);
                shadeRamp_n2    = saturate(shadeRamp_n2);



//// Diffusion. Albedo setup
                //// Albedo variable remap zone of pain.
                // get albedo samples
                half3 albedoCol_1;
                half3 albedoCol_2;
                half3 albedoCol_3;
                if (_toonRampTexturesBlendMode && _useDiffuseAlbedoTexturesSet) //// toon ramp tint derive mode
                {   //// multiply
                    albedoCol_1     = shadeAlbedoTex1.rgb;
                    albedoCol_2     = shadeAlbedoTex1.rgb * shadeAlbedoTex2.rgb;
                    albedoCol_3     = shadeAlbedoTex1.rgb * shadeAlbedoTex3.rgb;
                } else
                {   //// replace
                    albedoCol_1     = shadeAlbedoTex1.rgb;
                    albedoCol_2     = shadeAlbedoTex2.rgb;
                    albedoCol_3     = shadeAlbedoTex3.rgb;
                }
                //
                half3 shadeCol_1    = _BaseColor.rgb * _Color.rgb;
                half3 shadeCol_2    = _1st_ShadeColor.rgb * _Color.rgb;
                half3 shadeCol_3    = _2nd_ShadeColor.rgb * _Color.rgb;



//// Diffusion. Ramp shading and surface albedo and light albedo mixer
                //// mix scene lighting per region
                // float shadeDynamicShadowRegions[2] = {shadowAtten, shadowAtten};
                half3 lightDirectSim = (lightDirectSource * shadowAtten) + lightIndirectSource;
                half3 lightIndirectSimCore = lerp(lightIndirectSource, lightDirectSim, _diffuseIndirectDirectSimCoreMix);
                half3 lightIndirectSimBackwards = lerp(lightIndirectSource, lightDirectSim, _diffuseIndirectDirectSimMix);
                shadeCol_1 *= lightDirectSim;
                UNITY_BRANCH
                if (_ToonRampLightSourceType_Core)
                {
                    shadeCol_2 *= lightIndirectSimCore;
                } else
                {
                    shadeCol_2 *= lightDirectSim;
                }
                UNITY_BRANCH
                if (_ToonRampLightSourceType_Backwards) //// diffuse lighting: backface area is part of shadow thus indirect light only
                {
                    shadeCol_3 *= lightIndirectSimBackwards;
                } else //// diffuse lighting: surface uses entire albedo
                {
                    shadeCol_3 *= lightDirectSim;
                }

                //// mix textures
                half3 toonMix_bright_albedo = lerp(albedoCol_2, albedoCol_1, shadeRamp_n1);
                half3 toonMix_dark_albedo   = lerp(albedoCol_3, albedoCol_2, shadeRamp_n2);
                //// mix ramp
                half3 toonMix_bright_tint    = lerp(shadeCol_2, shadeCol_1, shadeRamp_n1);
                half3 toonMix_dark_tint      = lerp(shadeCol_3, shadeCol_2, shadeRamp_n2);
                //// GSF effect. Light direction warps blending of front/core & core/backward areas.
                half pivotBlendSideShades = 0;
                UNITY_BRANCH
                if (_Diff_GSF_01)
                {
                    pivotBlendSideShades = GSF_Diff_ac(dDiff.ndl, saturate(dDiff.ndv), dDiff.ldhS);
                    pivotBlendSideShades = StepFeatherRemap(pivotBlendSideShades, _DiffGSF_Offset, _DiffGSF_Feather);
                }
                else
                {
                    UNITY_BRANCH
                    if (_DiffToonShadePriority)
                    {
                        pivotBlendSideShades = max(shadeRamp_n1, shadeRamp_n2);//// Areas, Core covers Back
                    }
                    else
                    {
                        pivotBlendSideShades = min(shadeRamp_n1, shadeRamp_n2);//// Areas, Back covers Core
                    }
                }
                //// complete diffuse mix
                half3 shadeColor_albedo = lerp(toonMix_dark_albedo, toonMix_bright_albedo, pivotBlendSideShades);//// textures
                half3 shadeColor_shade  = lerp(toonMix_dark_tint, toonMix_bright_tint, pivotBlendSideShades);//// ramp
                UNITY_BRANCH
                if (_useCrossOverRim)
                {
                    half bdDFlipper    = dot((reflect(-dirView, dirNormalToonRamp)), -dirLight)*.5+.5;
                    bdDFlipper         = saturate(RemapRange(bdDFlipper,0+_crossOverPinch,1-_crossOverPinch,0,1));
                    float shadeRamp_CrossOverRim = .5 - dDiff.ndv * .5;
                    UNITY_BRANCH if (_UseLightMap)
                    {
                        if (_lightMapBlendModeCrossOverRim) // darken
                        {
                            shadeRamp_CrossOverRim =  1 - (1 - shadeRamp_CrossOverRim) * (( (lightMapBias_crossOverRim) - 1) * (_lightMapStrengthShadeRampCrossOverRim * 2) + 1);
                        }
                        else // bias
                        {
                            float lightMapStrengthShadeRampCrossOverRimScale = _lightMapStrengthShadeRampCrossOverRim * 2;
                            float lightMapBias_crossOverRimNegate = 1 - lightMapBias_crossOverRim;
                            float lightMapBias_crossOverRimNegateRange = lightMapBias_crossOverRimNegate * 2 - 1;
                            shadeRamp_CrossOverRim = lerp( shadeRamp_CrossOverRim, lerp(shadeRamp_CrossOverRim, lightMapBias_crossOverRimNegate, pow(abs(lightMapBias_crossOverRimNegateRange), 2) * (lightMapStrengthShadeRampCrossOverRimScale) ) + (lightMapBias_crossOverRimNegateRange), (lightMapStrengthShadeRampCrossOverRimScale));
                        }
                    }
                    float crossOverMask = _crossOverMask.SampleGrad(sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy).g;
                    half bdCrossoverDot = crossOverMask * (1-Pow2Recurve(1-StepFeatherRemap( (shadeRamp_CrossOverRim), _crossOverStep, _crossOverFeather), _crosspOverRimPow));
                    // debugVal = float4(shadeRamp_CrossOverRim,0,0,1);
                    // half bdCrossoverDot = crossOverMask * (1-Pow2Recurve(1-StepFeatherRemap( (.5 - dDiff.ndv * .5), _crossOverStep, _crossOverFeather), _crosspOverRimPow));
                    // half bdCrossoverDot = crossOverMask * (pow(StepFeatherRemap(.5-dDiff.ndv*.5,_crossOverStep,_crossOverFeather), exp2( lerp(3,0,_crosspOverRimPow))));

                    float3 bd_albedoTex;
                    UNITY_BRANCH
                    switch (_crossOverSourceTexSource){
                        default:
                        case 0:
                            float4 crossCoverTex = _crossOverAlbedo.SampleGrad(sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy);
                            bd_albedoTex = crossCoverTex.rgb; 
                            break;
                        case 1: bd_albedoTex = albedoCol_1.rgb; break;
                        case 2: bd_albedoTex = albedoCol_2.rgb; break;
                        case 3: bd_albedoTex = albedoCol_3.rgb; break;
                        // case 1: bd_albedoTex = shadeAlbedoTex1.rgb; break;
                        // case 2: bd_albedoTex = coreAlbedoTex.rgb; break;
                        // case 3: bd_albedoTex = backwardAlbedoTex.rgb; break;
                    }
                    half3 shadeColMix2 = _BaseColor.rgb * _Color.rgb;
                    half3 shadeColMix3 = shadeColMix2;
                    UNITY_BRANCH if (_crossOverUseToonShades)   //// rebuild toon ramp system
                    {
                        shadeColMix2 = _1st_ShadeColor.rgb * _Color.rgb;;
                        shadeColMix3 = _2nd_ShadeColor.rgb * _Color.rgb;;
                    }
                    //// lighting context mix
                    UNITY_BRANCH if (_ToonRampLightSourceType_Core) 
                    {
                        shadeColMix2 *= lightIndirectSimCore;
                    } else 
                    {
                        shadeColMix2 *= lightDirectSim;
                    }
                    UNITY_BRANCH if (_ToonRampLightSourceType_Backwards)
                    {
                        shadeColMix3 *= lightIndirectSimBackwards;
                    } else 
                    {
                        shadeColMix3 *= lightDirectSim;
                    }
                    half3 toonMix_BD_albedo = lerp(shadeColor_albedo, bd_albedoTex, bdCrossoverDot);
                    half3 toonMix_BD_Shade  = lerp(shadeColMix2, shadeColMix3, bdDFlipper) * _crossOverTint.rgb;
                    half3 shadeColor_darkRim_albedo = lerp(shadeColor_shade, toonMix_BD_Shade, bdCrossoverDot);
                    shadeColor_albedo   = toonMix_BD_albedo;
                    shadeColor_shade    = shadeColor_darkRim_albedo;
                }
                UNITY_BRANCH
                if (_DetailAlbedo)
                {
                    shadeColor_albedo = lerp(shadeColor_albedo, (shadeColor_albedo * detailMap.rgb * unity_ColorSpaceDouble.xyz), detailMask.rrr * _DetailAlbedo);
                }
                // return float4(shadeColor,1);





#ifdef GrabPassDataContext
//// grabpass use
                //// distortion and blur V
                UV_DD uv_grabPassMask = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_grabPassMask), _grabPassMask));
                float4 grabPassMask = _grabPassMask.SampleGrad( sampler_MainTex, uv_grabPassMask.uv, uv_grabPassMask.dx, uv_grabPassMask.dy); // r:mix, b:distortion, a:blur
                float3 dirNormalDistortion = i.wNormal;
                if (_distortionBumpMapScale != 0.0)
                {
                    UV_DD uv_distortionBumpMap = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_distortionBumpMap), _distortionBumpMap));
                    float3 distortionBumpMap = UnpackScaleNormal(_distortionBumpMap.SampleGrad( sampler_NormalMap, uv_distortionBumpMap.uv, uv_distortionBumpMap.dx, uv_distortionBumpMap.dy), _distortionBumpMapScale);
                    dirNormalDistortion = normalize(mul( distortionBumpMap, tangentTransformMatrix));
                }
                //// distortion depth
                float depthVolume = 1;
                float2 grabRefractOffset = 0;
                UNITY_BRANCH if ((_useBlurDepth)) //// logic check as depth effects cannot combine with distortion effects
                {
                    UNITY_BRANCH if (_useDepthEffects * haveDepth * !(isMirror)) //// control situation we are alphaTest Queue and material hits its own depth, from being lower than transparency queue
                    {
                        float backgroundDepth = LinearEyeDepth(SampleSceneDepth((i.screenPos.xy / i.screenPos.w)).r);
                        // float backgroundDepth = LinearEyeDepth(UNITY_SAMPLE_SCREENSPACE_TEXTURE(_CameraDepthTexture, (i.screenPos.xy / i.screenPos.w)).r);
                        // float backFaceDepth = (tex2D(_BackDepthTexture, (i.screenPos.xy/i.screenPos.w)).a);
                        // backgroundDepth = min(backgroundDepth, backFaceDepth);
                        float depthRaw = backgroundDepth - surfaceDepth;
                        depthVolume = saturate(depthRaw);
                        depthVolume = saturate(((pow(depthVolume, _depthPow))) * _depthFactor);      
                        // return float4(depthVolume,0,0,1);
                        // debugVal = float4(surfaceDepth, backgroundDepth, depthRaw, 1);
                    }
                    
                }
                else //// perforn non-depth supported distortion effects
                {
                    float2 distortionScreenPos = i.screenPos.xy/i.screenPos.w;
                    //// amplify version
                    // float3 dirNormalClip = mul(UNITY_MATRIX_V, float4(dirNormalDistortion, 0.0));
                    // float2 offset = dirNormalClip.xy;
                    // i.screenPos.xy = i.screenPos.xy + offset * _IORStrength * grabPassMask.b * ( 1.0 - dot( dirNormalDistortion, dirView ) ) / ( i.screenPos.z + 1.0 ); // Amplify 
                    //// refraction version
                    float3 dirRefractW = refract((dirView), (dirNormalDistortion), 1/_IOR);
                    // float3 dirRefractW = refract((UNITY_MATRIX_V[2].xyz ), (dirNormalDistortion), 1/_IOR);
                    float3 dirRefractClip = mul(UNITY_MATRIX_V, float4(dirRefractW.xyz, 0.0)).xyz;
                    float2 refractOffset = -dirRefractClip.xy * -dirRefractClip.z;
                    // float2 refractOffset = (dirRefractClip.xy * dot(float3(0,0,-1), dirRefractClip.xyz) - dirRefractClip.xy); // applied matcap skew correction trick
                    // float3 dirViewInViewSpace = mul(UNITY_MATRIX_V, float4(UNITY_MATRIX_V[2].xyz, 0.0)).xyz;
                    // float2 refractOffset = (dirRefractClip.xy * dot(dirViewInViewSpace.xyz, dirRefractClip.xyz) / -dirViewInViewSpace.z - dirRefractClip.xy);
                    // debugVal = float4((dirRefractW).xyz, 1);

                    ////
                    grabRefractOffset = refractOffset * _IORStrength * grabPassMask.b;
                    grabRefractOffset *= min(1, surfaceDepth * 2);
                    // grabRefractOffset = refractOffset * _IORStrength * grabPassMask.b/* * dot( dirNormalDistortion, dirView )*/ * ( surfaceDepth );
                    // grabRefractOffset = refractOffset * _IORStrength * grabPassMask.b * (1 - dot( dirNormalDistortion, dirView ) ) / ( surfaceDepth + 1.0 );
                    // grabRefractOffset = refractOffset * _IORStrength * grabPassMask.b/* * dot( dirNormalDistortion, dirView )*/ * ( surfaceDepth );


                    /*
                    // distotion screen with side mirroring
                    float2 remapScreenPos = grabRefractOffset.xy + distortionScreenPos.xy;
                    // debugVal = float4(remapScreenPos.xy,0,1);
                    float2 distortionScreenPosNormalized;
                    // reremap to stereo
                #ifdef UNITY_SINGLE_PASS_STEREO
                    if (unity_StereoEyeIndex) // 1 = right eye
                    {
                        distortionScreenPosNormalized.x = RemapRange(remapScreenPos.x, .5,1, 0,1);
                    }
                    else
                    {
                        distortionScreenPosNormalized.x = RemapRange(remapScreenPos.x, 0,.5, 0,1);
                    }
                #else // UNITY_SINGLE_PASS_STEREO
                    distortionScreenPosNormalized.x = RemapRange(remapScreenPos.x, 0,1, -1,1);
                #endif // UNITY_SINGLE_PASS_STEREO
                    distortionScreenPosNormalized.y = RemapRange(remapScreenPos.y, 0,1, -1,1);
                    // edge mirroring
                    // x
                    if (distortionScreenPosNormalized.x < 0 )
                    {
                        distortionScreenPosNormalized.x = abs(distortionScreenPosNormalized.x);
                    }
                    else if (distortionScreenPosNormalized.x > 1 )
                    {
                        distortionScreenPosNormalized.x = 1 - (distortionScreenPosNormalized.x - 1);
                    }
                    // y
                    if (distortionScreenPosNormalized.y < 0 )
                    {
                        distortionScreenPosNormalized.y = abs(distortionScreenPosNormalized.y);
                    }
                    else if (distortionScreenPosNormalized.y > 1 )
                    {
                        distortionScreenPosNormalized.y = 1 - (distortionScreenPosNormalized.y - 1);
                    }
                    // remape to whole screen
                #ifdef UNITY_SINGLE_PASS_STEREO
                    if (unity_StereoEyeIndex) // 1 = right eye
                    {
                        remapScreenPos.x = RemapRange(remapScreenPos.x,0,1, .5,1);
                    }
                    else
                    {
                        remapScreenPos.x = RemapRange(remapScreenPos.x, 0,1, 0,.5);
                    }
                #else // UNITY_SINGLE_PASS_STEREO
                    remapScreenPos.x = RemapRange(remapScreenPos.x, 0,1,  0,1);
                #endif // UNITY_SINGLE_PASS_STEREO
                    remapScreenPos.y = RemapRange(remapScreenPos.y, 0,1,  0,1);
                    // debugVal = float4(remapScreenPos.xy,0,1);
                    grabRefractOffset = remapScreenPos.xy - distortionScreenPos.xy;
                    /*

                    /*
                    // screen mask circle
                    float2 remapScreenPos = grabRefractOffset.xy + distortionScreenPos.xy;
                    float2 remappedScreenDistortion = remapScreenPos;
                    float2 distortionScreenPosNormalized;
                #ifdef UNITY_SINGLE_PASS_STEREO
                    if (unity_StereoEyeIndex) // 1 = right eye
                    {
                        distortionScreenPosNormalized.x = RemapRange(remapScreenPos.x, .5,1, -1,1);
                    }
                    else
                    {
                        distortionScreenPosNormalized.x = RemapRange(remapScreenPos.x, 0,.5, -1,1);
                    }
                #else // UNITY_SINGLE_PASS_STEREO
                    distortionScreenPosNormalized.x = RemapRange(remapScreenPos.x, 0,1, -1,1);
                #endif // UNITY_SINGLE_PASS_STEREO
                    distortionScreenPosNormalized.y = RemapRange(remapScreenPos.y, 0,1, -1,1);
                    // circle mask
                    float rDistance = distance(float2(0,0), distortionScreenPosNormalized);
                    // mirror far distance
                    float lensRadius = 1;
                    float rDistanceFixed = (rDistance > lensRadius) ? max(0, lensRadius - abs(lensRadius - rDistance)) : 1;
                    distortionScreenPosNormalized = distortionScreenPosNormalized * rDistanceFixed;
                    // debugVal = float4(rDistanceFixed.xxx,1);
                    grabRefractOffset = grabRefractOffset * max(0,rDistanceFixed);
                    */
                
                /*
                    // screen mask edge uv
                #ifdef UNITY_SINGLE_PASS_STEREO
                    // unity_StereoEyeIndex
                    distortionScreenPos.x = frac(2 * distortionScreenPos.x);
                #endif
                    float2 distortionScreenMask = (1 - pow( ( (abs(distortionScreenPos - .5) * 2)), 1));
                    // float2 distortionScreenMask = (1 - pow( (grabRefractOffset + (abs(distortionScreenPos - .5) * 2)), 2));
                    distortionScreenMask.x = distortionScreenMask.x * distortionScreenMask.y;
                    grabRefractOffset = grabRefractOffset.xy * saturate(distortionScreenMask.x);                    
                    // screen mask edge uv
                */                  
                    
                    
                }
                depthVolume = depthVolume * min(1, surfaceDepth);
#endif // DepthDataContext



//// grabpass color samples and blur
                float4 colorGrabPassEffects = 0;
#ifdef GrabPassDataContext

    #ifdef UNITY_PASS_FORWARDBASE
                float aspect = 1;
                float4 colSum = 0;
                float weightSum = 0;
                float blurOffsetSource = depthVolume * _blurWidth * grabPassMask.a * abs(UNITY_MATRIX_P._m11*.5) * 1;
                // float blurOffsetSource = depthVolume * _blurWidth * grabPassMask.a * abs(UNITY_MATRIX_P._m11*.5) * BLUR_SAMPLE_SPLITS;
                UNITY_BRANCH if (blurOffsetSource)
                {
                    //// https://www.shadertoy.com/view/Xltfzj
                    static float radialDirections = 10.0;
                    static float radialQuality = 4.0;
                    for( float radialSlice = 0.0; radialSlice < radialDirections; radialSlice += UNITY_TWO_PI / radialDirections)
                    {
                        for(float radialRadiusIndex = 1.0 / radialQuality; radialRadiusIndex <= 1.0; radialRadiusIndex += 1.0 / radialQuality)
                        {
                            float2 radialOffset = float2(cos(radialSlice),sin(radialSlice)) * blurOffsetSource * pow(radialRadiusIndex,1.5);
                            radialOffset.x *= _ScreenGrabACL_TexelSize.x * _ScreenGrabACL_TexelSize.w; // h / w
                    //     }
                    // }
                    // [loop] for (float idy = 0; idy < BLUR_SAMPLES; idy++)
                    // {
                        // [loop] for (float idx = 0; idx < BLUR_SAMPLES; idx++)
                        // {
                        // [loop] for (float sampleI = 0; sampleI < 24; sampleI++)
                        // {
                        //     float timeMod = fmod(_Time.y,10);
                        //     float2 randXY = rand22(float2(i.screenPos.x + sampleI * 2, i.screenPos.y + sampleI));
                        //     // float2 randXY = hashwithoutsine22(float2(i.screenPos.x + sampleI * 2, i.screenPos.y + sampleI));
                        //     // float2 randXY = rand22(float2(i.screenPos.x + sampleI, i.screenPos.y + timeMod));
                        //     float sampleIndexX = randXY.x * 2 - 1;
                        //     float sampleIndexY = randXY.y * 2 - 1;
                        //     float blurOffsetX = blurOffsetSource * sampleIndexX;
                        //     float blurOffsetY = blurOffsetSource * sampleIndexY;
                            
                            // float blurOffsetX = blurOffsetSource * (idx - BLUR_SAMPLE_RADIUS);
                            // blurOffsetX *= _ScreenGrabACL_TexelSize.x * _ScreenGrabACL_TexelSize.w; // h / w
                            // float blurOffsetY = blurOffsetSource * (idy - BLUR_SAMPLE_RADIUS);

                            float4 scnPos = float4( grabRefractOffset + i.screenPos.xy + radialOffset, i.screenPos.z, i.screenPos.w);
                            // float4 scnPos = float4( grabRefractOffset + float2(i.screenPos.x, i.screenPos.y + blurOffsetY), i.screenPos.z, i.screenPos.w);
                            // scnPos.xy /= scnPos.w;
                            // scnPos.xy = floor(scnPos.xy * _GrabTexture_TexelSize.zw * 2) / (_GrabTexture_TexelSize.zw * 2) + _GrabTexture_TexelSize.xy * .5;
                            // scnPos.xy *= scnPos.w;
                            // float4 scnPos = float4( grabRefractOffset + float2(i.screenPos.x + blurOffsetX, i.screenPos.y + blurOffsetY), i.screenPos.z, i.screenPos.w);
                            float badDepthScale = 1;
                            UNITY_BRANCH if (_useDepthEffects * haveDepth * !(isMirror)) //// control situation we are alphaTest Queue and material can hit its own depth being lower than transparency queue
                            {
                                float tempBackgroundDepth = LinearEyeDepth(SampleSceneDepth((scnPos.xy / i.screenPos.w)).r);
                                // float tempBackgroundDepth = LinearEyeDepth(UNITY_SAMPLE_SCREENSPACE_TEXTURE(_CameraDepthTexture, (scnPos.xy / i.screenPos.w)).r);
                                float tempDepthVolume = (tempBackgroundDepth - surfaceDepth);
                                if (tempDepthVolume < 0) // object in front, cannot logically sample
                                {
                                    badDepthScale = 0.001;
                                }
                            }
                            // float weight = blurKernel_13[idy]  * badDepthScale; // expensive
                            // float weight = Gaussian(_sigma * BLUR_SIGMA, (idy - BLUR_SAMPLE_RADIUS)) * badDepthScale; // expensive
                            // float idxDistance = sqrt(sqr(idx - BLUR_SAMPLE_RADIUS) + sqr(idy - BLUR_SAMPLE_RADIUS));
                            // float weight = Gaussian(_sigma * BLUR_SIGMA, (idxDistance)) * badDepthScale; // expensive
                            // float weight = blurKernel_11x11[idx % 11 + idy * 11] * badDepthScale; // pre-computed 2d matrix, 5 radius, 11 diameter
                            // float weight = blurKernel_9x9[idx % 9 + idy * 9] * badDepthScale; // pre-computed 2d matrix, 4 radius, 9 diameter
                            // float weight = Gaussian(_sigma * 1, (radialRadiusIndex)) * badDepthScale; // expensive
                            float weight = 1.0 * badDepthScale;
                            colSum += SAMPLE_TEXTURE2D_X_LOD(_ScreenGrabACL, sampler_ScreenGrabACL, scnPos.xy / scnPos.w, 0) * weight;
                            // colSum += SAMPLE_TEXTURE2D_X_LOD(_GrabTexture, sampler_GrabTexture, scnPos.xy / scnPos.w, 0) * weight;
                            // colSum += UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture, scnPos.xy / scnPos.w) * weight;
                            // colSum += UNITY_SAMPLE_SCREENSPACE_TEXTURE(_ScreenGrabACL, scnPos.xy / scnPos.w) * weight;
                            weightSum += weight;
                        }
                    }                   
                    colSum /= (weightSum+0.0001);
                    // float getSkyboxBrightness = LinearRgbToLuminance_ac( DecodeHDR(colSum, _HBlurACL_HDR));
                    float getSkyboxBrightness = LinearRgbToLuminance_ac( colSum.rgb);
                    if (_grabPassOverBrightnessClamp && (getSkyboxBrightness > 1.0) ) { colSum /= getSkyboxBrightness; }//// alphaTest queue Skybox overbright protection

                }
                else
                {
                    float4 scnPos = float4( grabRefractOffset + float2(i.screenPos.x, i.screenPos.y), i.screenPos.z, i.screenPos.w);
                    colSum = SAMPLE_TEXTURE2D_X_LOD(_ScreenGrabACL, sampler_ScreenGrabACL, scnPos.xy/scnPos.w, 0);
                    // colSum = SAMPLE_TEXTURE2D_X_LOD(_GrabTexture, sampler_GrabTexture, scnPos.xy/scnPos.w, 0);
                    // colSum = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture, scnPos.xy/scnPos.w);
                    // colSum = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_ScreenGrabACL, scnPos.xy/scnPos.w);
                }
                UV_DD uv_grabPassTintTex = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_grabPassTintTex), _grabPassTintTex));
                float3 grabPassTintTex = _grabPassTintTex.SampleGrad( sampler_MainTex, uv_grabPassTintTex.uv, uv_grabPassTintTex.dx, uv_grabPassTintTex.dy).rgb; // r:mix, b:distortion, a:blur
                colorGrabPassEffects.rgb = colSum.rgb * _grabPassTint.rgb * grabPassTintTex.rgb;
                UNITY_BRANCH if (_grabPassMixAlbedo)
                {
                    colorGrabPassEffects.rgb *= lerp(1, shadeColor_albedo.rgb, _grabPassMixAlbedo);
                }
                // debugVal = colorGrabPassEffects * _grabPassTint.rgb;
                // float4 getGrabPass = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_blurFinalACL, i.screenPos.xy / i.screenPos.w);
                // debugVal = getGrabPass * float4(1,.8,.8,1);
                
    #endif // UNITY_PASS_FORWARDBASE

#endif // DepthDataContext

//// SSS Sub Surface Scattering
                //// https://www.alanzucconi.com/2017/08/30/fast-subsurface-scattering-1/
                //// https://prideout.net/blog/old/blog/index.html@p=51.html
                //// https://github.com/HhotateA/FakeSSS_UnityShader
                half3 SSScol = 0.;
                float SSSmask = 0.;
                half3 colSSS = 0.;
                if (_useSSS)
                {
                    float SSSnDv = 1.;
                    float SSSdepth = 1.;
                    if (isBackFace){SSSdepth = 0.;}
                    float SSSThicknessMask = _SSSThicknessMask.SampleGrad( sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy).g;
                    SSSdepth *= SSSThicknessMask;
                    UNITY_BRANCH
                    if (_useFakeSSS)
                    {
                        float d_volumeCheap = (dot(dirView, -normalize(dirLight + dirNormalToonRamp * _SSSLensFake)))*.5+.5;
                        d_volumeCheap = Pow2Recurve((d_volumeCheap), _SSSDensityFake);
                        SSSdepth *= d_volumeCheap;
                    }
                #ifdef DepthDataContext
                    //// note: removed Backface Depth support until solution found for combining with depth buffer and grabpass effects.
                    // UNITY_BRANCH
                    // if ((volDepth > 0.0) && (_useRealSSS))
                    // {
                    //     //// depth;
                    //     float SSSRealDepth = (1 - volDepth); /// must not be negative
                    //     SSSRealDepth = Pow2Recurve((SSSRealDepth), _SSSDensityReal);

                    //     SSSdepth *= SSSRealDepth;
                    // }
                    // //// color albedo
                    // //// rim
                    // SSSnDv = depthMap.g; /// stores rim dot
                    // SSSnDv = Pow2Recurve((1 - SSSnDv), _SSSRim);
                    // float SSSRimMask        = RemapRangeH01((SSSnDv), _SSSRimMaskH, _SSSRimMaskL);
                    // half3 SSScolorMixRim    = lerp(_SSSColThin.rgb, _SSSColRim.rgb, SSSRimMask);
                    half3 SSScolorMixRim    = _SSSColThin.rgb;
                #else
                    half3 SSScolorMixRim    = _SSSColThin.rgb;
                #endif // DepthDataContext
                    float SSScolDepth       = RemapRangeH01(SSSdepth, _SSSDepthColL, _SSSDepthColH);
                    half3 SSScolorMixDepth  = lerp((_SSSColThick.rgb * _SSSColThin.rgb), SSScolorMixRim, SSScolDepth);
                    half3 SSScolorMix       = SSScolorMixDepth;
                    //// light albedo
                    //// lens
                    float SSSldh            = saturate(dot(dirView, -normalize(dirLight + dirNormalToonRamp * _SSSLens)));
                    float3 dirSSSIndirect   = -normalize(dirView + dirNormalToonRamp * _SSSLens);
                    half3 SSSdirectLightAve = ((lightDirectSource * _LightShadowData.x * .5) + lightDirectSource ) * .5;
    #ifdef UNITY_PASS_FORWARDBASE
                    half3 SSSGICol = ShadeSH9_ac(float4(dirSSSIndirect,1));
                    UNITY_BRANCH if (_forceLightClamp)
                    {
                        float SSSGICOlLintensity = LinearRgbToLuminance_ac(SSSGICol);
                        if (SSSGICOlLintensity > intensityTrigger) { SSSGICol /= SSSGICOlLintensity; }
                    }
                    half3 lightSSS = (SSSGICol + (SSSldh * SSSdirectLightAve));
    #elif UNITY_PASS_FORWARDADD
                    half3 lightSSS = ((SSSldh * SSSdirectLightAve));
    #endif 
                    //// mix
                    colSSS = SSScolorMix * lightSSS * SSSdepth;
                }





//// specular setup control
                //// global specular effects mask
                UV_DD uv_specularMask   = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_highColorMask), _Set_HighColorMask));
                float4 specularMask     = _Set_HighColorMask.SampleGrad( sampler_MainTex, uv_specularMask.uv, uv_specularMask.dx, uv_specularMask.dy);
                UNITY_BRANCH
                if (_invertHighColorMask){specularMask.g = 1-specularMask.g;}
                float aoSpecularM       = saturate(specularMask.g + _Tweak_HighColorMaskLevel);
                //// specular workflow
                UV_DD uv_specular       = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_specular), _HighColor_Tex));
                float4 highColorTex     = _HighColor_Tex.SampleGrad( sampler_MainTex, uv_specular.uv, uv_specular.dx, uv_specular.dy);
                float4 metallicTex      = _MetallicGlossMap.SampleGrad( sampler_MainTex, uv_specular.uv, uv_specular.dx, uv_specular.dy);
                float4 specGlossTex     = _SpecGlossMap.SampleGrad( sampler_MainTex, uv_specular.uv, uv_specular.dx, uv_specular.dy);
                //// gloss map (affects reflection only)
                float4 glossinessTex    = _GlossinessMap.SampleGrad( sampler_MainTex, uv_specular.uv, uv_specular.dx, uv_specular.dy);

////BRDF workflows
                //// prepare shine & gloss
                float3 specularSrcCol = 1.0;
                half4 sg4 = 1.0;
                half2 mg2 = 1.0;
                float diffuseScale = 1.0;
                float smoothness = 1.0;
                UNITY_BRANCH
                if (_WorkflowMode == 0)//// specular
                {
                    sg4.rgb = highColorTex.rgb;
                    sg4.a   = highColorTex.a * _Glossiness;
                    specularSrcCol  = sg4.rgb;
                    smoothness      = sg4.a;
                }
                else if (_WorkflowMode == 1)//// metallic
                {
                    mg2[0]  = metallicTex.r * _Metallicness;
                    mg2[1]  = metallicTex.a * _Glossiness;
                    specularSrcCol = highColorTex.rgb;
                    smoothness  = mg2[1];
                }
                else//// AutoDesk/roughness
                {
                    mg2[0] = metallicTex.r * _Metallicness;
                    mg2[1] = (1.0 - specGlossTex.r) * (_Glossiness);
                    specularSrcCol = highColorTex.rgb;
                    smoothness  = mg2[1];
                }

                //// specular workflow. Tint the specular mask and mix energy.
                specularSrcCol  *= _SpecColor.rgb;        

                UNITY_BRANCH
                if (_highColTexSource)//// mixing main texture
                {
                    half3 tempCol       = lerp(1, shadeColor_albedo, _highColTexSource);//// want 1.0 mix for countering extreme dark 0.0 RGBs
                    half3 AlbedoHSVI    = HSVI_controller(tempCol, _SpecularMaskHSV.x, _SpecularMaskHSV.y, _SpecularMaskHSV.z, _SpecularMaskHSV.w);
                    specularSrcCol      *= lerp(1, AlbedoHSVI, _highColTexSource);
                }

                half3 specOverrideColor = shadeColor_albedo;
                UNITY_BRANCH
                if (_SpecOverride)//// impart specular workflow's color into metallic color mixing
                {
                    specOverrideColor = specularSrcCol;
                }
                



                //// mix diffuse/specular by workflow
                float oneMinusReflectivity  = 1;
                UNITY_BRANCH
                if (_WorkflowMode == 0)//// spec gloss
                {
                    diffuseScale = EnergyConservationBetweenDiffuseAndSpecular_ac(_UseDiffuseEnergyConservation, specularSrcCol, oneMinusReflectivity);
                }
                else if (_WorkflowMode == 1)//// metallic
                {
                    diffuseScale = DiffuseAndSpecularFromMetallic_ac(_UseDiffuseEnergyConservation, specOverrideColor, mg2[0], specularSrcCol, oneMinusReflectivity);
                    // diffuseScale = DiffuseAndSpecularFromMetallic_ac(_UseDiffuseEnergyConservation, shadeColor_albedo, mg2[0], specularSrcCol, oneMinusReflectivity);
                }
                else//// AutoDesk
                {
                    diffuseScale = DiffuseAndSpecularFromMetallic_ac(_UseDiffuseEnergyConservation, specOverrideColor, mg2[0], specularSrcCol, oneMinusReflectivity);
                }



//// thin film iridescence
//// https://belcour.github.io/blog/research/publication/2017/05/01/brdf-thin-film.html
//// https://github.com/Xerxes1138/Iridescence/blob/master/Iridescence.shader
                float3 IridescenceCol_ndh = 1.0;
                float3 IridescenceCol_ndv = 1.0;
                UNITY_BRANCH
                if (_useThinFilmIridescence)
                {
                    float4 iridescenceMask = _IridescenceMask.SampleGrad(sampler_MainTex, uv_specularMask.uv, uv_specularMask.dx, uv_specularMask.dy);
                    IridescenceCol_ndh = UNITY_PI * renderTFI(iridescenceMask, dot( dirNormalSpecular, normalize(dirNormalSpecular + dirLight)) * 2 - 1, _Dinc, _eta2, _eta3, _kappa3);

                    #ifdef UNITY_PASS_FORWARDBASE
                    IridescenceCol_ndv = UNITY_PI * renderTFI(iridescenceMask, saturate(dot(dirNormalSpecular, dirView)), _Dinc, _eta2, _eta3, _kappa3);
                    #endif
                }


                //// specular off/on affects
                //// rim light helpers. For the Code optimizer (my code cannot change uniforms)
                int envGrazeMix_      = _EnvGrazeMix;
                int envGrazeRimMix_   = _EnvGrazeRimMix;
                UNITY_BRANCH
                if (!(_UseSpecularSystem))//// forgive this lazy switch
                {
                    specularSrcCol = envGrazeMix_ = envGrazeRimMix_ = 0;
                    oneMinusReflectivity = 1;
                    diffuseScale = 1;
                    // smoothness = 0.0; //// dont affect cubemap fernel(?)
                }

                //// prepare shine lobe components
                float perceptualRoughness = 1 - smoothness;
                
                //// prepare reflection components
                float3 glossColor       = specularSrcCol;
                float smoothnessGloss   = smoothness;
                float oneMinusReflectivityGloss = oneMinusReflectivity;
                UNITY_BRANCH
                if (_GlossinessMapMode == 1)//// gloss scales reflection
                {
                    glossColor      *= glossinessTex.rgb;
                    smoothnessGloss = saturate(smoothnessGloss + (glossinessTex.a * 2 - 1));//// spread from 50% grey
                    EnergyConservationBetweenDiffuseAndSpecular_ac(true, glossColor, oneMinusReflectivityGloss);
                }
                else if (_GlossinessMapMode == 2) //// gloss is reflection
                {
                    glossColor      = glossinessTex.rgb;
                    smoothnessGloss = glossinessTex.a;
                    EnergyConservationBetweenDiffuseAndSpecular_ac(true, glossColor, oneMinusReflectivityGloss);
                }
                //// rim graze intensity
                float grazingTerm       = saturate(smoothnessGloss + (1 - oneMinusReflectivityGloss)); //// graze intensity [0,1]
                //// env intensity by roughness
                float perceptualRoughnessGloss  = 1 - smoothnessGloss;
                float roughnessReflection       = 0;//// cubemap, matcap
                float surfaceReduction          = 0;//// cubemap
                float roughnessPR               = 0;//// cubemap, rimlight

                //// cubemap preset for Rim Light
                int useCubeMap = _useCubeMap;
                float eNVMix = _ENVMix;
                if (_rimLightSetPresetCubemap)
                {
                    useCubeMap = 1.0;
                    eNVMix = 0.0;
                }
                UNITY_BRANCH
                if (_ENVMmode == 1)//// standard
                {
                    float envSmoothness = saturate(1-perceptualRoughnessGloss + (2 * _envRoughness - 1)); //// wrong name (its smoothness)
                    roughnessReflection = RoughnessMagicNumberUnityRecurve(1 - envSmoothness);
                    roughnessPR = PerceptualRoughnessToRoughness_ac(perceptualRoughnessGloss);
                    surfaceReduction = eNVMix / (roughnessPR * roughnessPR + 1.0);
                }
                else if (_ENVMmode == 2)//// override
                {
                    float envSmoothness = _envRoughness; //// wrong name (its smoothness)
                    // float envSmoothness = saturate(1-perceptualRoughnessGloss + (2 * _envRoughness - 1)); //// wrong name (its smoothness)
                    roughnessReflection = RoughnessMagicNumberUnityRecurve(1 - envSmoothness);
                    roughnessPR = PerceptualRoughnessToRoughness_ac(perceptualRoughnessGloss);
                    surfaceReduction = eNVMix / (roughnessPR * roughnessPR + 1.0);
                }






//// matcap math
                float4 matcapMask   = float4(0.,1.,0.,0.); //// diff/mult/spec/emis
                float matcapShaMask = 1;
                half3 mcMixAdd     = 0;
                half3 mcMixMult    = 1;
                half3 mcMixEmis    = 0;
                half3 mcMixHardMult = 1;
                half3 mcARCol      = 0;
                float mcARTexAlpha = 1;
                UNITY_BRANCH
                if (_MatCap)
                {
                    float matcapRotStablizer = 0;
                    if (_CameraRolling_Stabilizer)
                    {
                        // (UTS2 v.2.0.6) : CameraRolling Stabilizer Simplified by ACiiL
                        float3 cameraRightAxis  = UNITY_MATRIX_V[0].xyz;//// UNITY_MATRIX_V camera matrix is powerful.
                        float3 cameraFrontAxis  = UNITY_MATRIX_V[2].xyz;//// get cam [0]:right and [2]:forward vectors
                        float3 upAxis           = float3(0, 1, 0);      //// get world upward (camera matrix is world)
                        //// get cross of cam forward to world/object(???) up
                        float3 crossRightAxisMag = normalize( cross(cameraFrontAxis, upAxis));////
                        UNITY_BRANCH if(isMirror)//// mirror is a lie as we fake the UV twist
                        {
                            crossRightAxisMag   *= -1;
                            _Rotate_MatCapUV    *= -1;
                        }
                        //// cam roll secret sauce
                        float cameraRollCosTheta    = dot(crossRightAxisMag, cameraRightAxis);//// wait
                        float cameraRollRad         = acos(clamp(cameraRollCosTheta, -1, 1)); //// what
                        matcapRotStablizer          = cameraRollRad; //// oh actual CosTheta usage
                        UNITY_BRANCH if (cameraRightAxis.y > 0)//// camera axis sign affects roll symmetry
                        {
                            matcapRotStablizer *= -1.0;
                        }
                        //// now add that rad to the UV roll formula
                    }
                    //// normalmap rotate
                    float2 rot_MatCapNmUV       = rotateUV( UVPick01(i.uv01, i.uv02, _uvSet_NormalMapForMatCap), float2(0.5,0.5), (_Rotate_NormalMapForMatCapUV * UNITY_PI));
                    //// normal map
                    UV_DD uv_matcap_nm          = UVDD( TRANSFORM_TEX( rot_MatCapNmUV, _NormalMapForMatCap));
                    float4 normalMapForMatCap   = _NormalMapForMatCap.SampleGrad( sampler_NormalMapForMatCap, uv_matcap_nm.uv, uv_matcap_nm.dx, uv_matcap_nm.dy);
                    float3 matCapNormalMapTex   = UnpackScaleNormal( normalMapForMatCap, _BumpScaleMatcap);
                    //// v.2.0.5: MatCap with camera skew correction. @kanihira
                    float3 dirNormalMatcap      = (_Is_NormalMapForMatCap) ? mul( matCapNormalMapTex, tangentTransformMatrix) : i.wNormal;
                    ////
                    float3 viewNormal                   = mul( UNITY_MATRIX_V, float4(dirNormalMatcap,0)).xyz;
                    float3 normalBlendMatcapUVDetail    = viewNormal.xyz * float3(-1,-1,1);//// normal mapped dir view
                    float3 normalBlendMatcapUVBase      = (mul( UNITY_MATRIX_V, float4(dirView,0) ).xyz * float3(-1,-1,1)) + float3(0,0,1);//// pure dir view
                    float3 noSknewViewNormal            = (normalBlendMatcapUVBase * dot(normalBlendMatcapUVBase, normalBlendMatcapUVDetail) / normalBlendMatcapUVBase.z) - normalBlendMatcapUVDetail;
                    float2 viewNormalAsMatCapUV         = ((noSknewViewNormal).xy * 0.5) + 0.5;
                    //// matcap uv transforms
                    float2 scl_MatCapUV         = scaleUV(viewNormalAsMatCapUV, float2(0.5,0.5), -2 * _Tweak_MatCapUV + 1);
                    float2 rot_MatCapUV         = rotateUV(scl_MatCapUV, float2(0.5,0.5),  (_Rotate_MatCapUV * UNITY_PI) + matcapRotStablizer);
                    //// get blur
                    float mcLodMax0, mcLodMax1, mcLodMax2, mcLodMax3;
                    mcLodMax0 = 0; mcLodMax1 = 0; mcLodMax2 = 0; mcLodMax3 = 0; 
                    _MatCapTexAdd.GetDimensions(mip,testw2,testh,mcLodMax0);
                    _MatCapTexMult.GetDimensions(mip,testw2,testh,mcLodMax1);
                    _MatCapTexEmis.GetDimensions(mip,testw2,testh,mcLodMax2);
                    _MatCapTexHardMult.GetDimensions(mip,testw2,testh,mcLodMax3);
                    
                    //// UV to texture
                    half mcNaturalRoughness = RoughnessMagicNumberUnityRecurve(perceptualRoughnessGloss);
                    half mcBlur0 = (_matcapSmoothnessSource0) ? mcNaturalRoughness : 1 - _BlurLevelMatcap0;
                    half mcBlur1 = (_matcapSmoothnessSource1) ? mcNaturalRoughness : 1 - _BlurLevelMatcap1;
                    half mcBlur2 = (_matcapSmoothnessSource2) ? mcNaturalRoughness : 1 - _BlurLevelMatcap2;
                    half mcBlur3 = (_matcapSmoothnessSource3) ? mcNaturalRoughness : 1 - _BlurLevelMatcap3;
                    float2 matcapUV             = TRANSFORM_TEX(rot_MatCapUV, _MatCapTexAdd);
                    float4 matCapTexAdd         = _MatCapTexAdd .SampleLevel(sampler_MatCap_Trilinear_clamp, matcapUV, perceptualRoughnessToMipmapLevel_ac(mcBlur0,mcLodMax0));
                    float4 matCapTexMult        = _MatCapTexMult.SampleLevel(sampler_MatCap_Trilinear_clamp, matcapUV, perceptualRoughnessToMipmapLevel_ac(mcBlur1,mcLodMax1));
                    float4 matCapTexEmis        = _MatCapTexEmis.SampleLevel(sampler_MatCap_Trilinear_clamp, matcapUV, perceptualRoughnessToMipmapLevel_ac(mcBlur2,mcLodMax2));
                    float4 matCapTexHardMult    = _MatCapTexHardMult.SampleLevel(sampler_MatCap_Trilinear_clamp, matcapUV, perceptualRoughnessToMipmapLevel_ac(mcBlur3,mcLodMax3));
                    UNITY_BRANCH
                    if (_MatCap2ndLayer)
                    { 
                        float mcLodMax0, mcLodMax1, mcLodMax2, mcLodMax3;
                        mcLodMax0 = 0; mcLodMax1 = 0; mcLodMax2 = 0; mcLodMax3 = 0; 
                        _MatCapTexAdd_2.GetDimensions(mip,testw2,testh,mcLodMax0);
                        _MatCapTexMult_2.GetDimensions(mip,testw2,testh,mcLodMax1);
                        _MatCapTexEmis_2.GetDimensions(mip,testw2,testh,mcLodMax2);
                        _MatCapTexHardMult_2.GetDimensions(mip,testw2,testh,mcLodMax3);
                        float4 matCapTexAdd_2         = _MatCapTexAdd_2.SampleLevel(sampler_MatCap_Trilinear_clamp, matcapUV, perceptualRoughnessToMipmapLevel_ac(mcBlur0,mcLodMax0));
                        float4 matCapTexMult_2        = _MatCapTexMult_2.SampleLevel(sampler_MatCap_Trilinear_clamp, matcapUV, perceptualRoughnessToMipmapLevel_ac(mcBlur1,mcLodMax1));
                        float4 matCapTexEmis_2        = _MatCapTexEmis_2.SampleLevel(sampler_MatCap_Trilinear_clamp, matcapUV, perceptualRoughnessToMipmapLevel_ac(mcBlur2,mcLodMax2));
                        float4 matCapTexHardMult_2    = _MatCapTexHardMult_2.SampleLevel(sampler_MatCap_Trilinear_clamp, matcapUV, perceptualRoughnessToMipmapLevel_ac(mcBlur3,mcLodMax3));
                        UV_DD uv_mc2LayerMask   = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_matcapMask), _Set_MatcapMask_2));
                        float4 mc2ndLayerMask   = _Set_MatcapMask_2.SampleGrad( sampler_MainTex, uv_mc2LayerMask.uv, uv_mc2LayerMask.dx, uv_mc2LayerMask.dy);
                        matCapTexMult       = lerp(matCapTexMult, matCapTexMult_2, mc2ndLayerMask.r);
                        matCapTexAdd        = lerp(matCapTexAdd, matCapTexAdd_2, mc2ndLayerMask.b);
                        matCapTexEmis       = lerp(matCapTexEmis, matCapTexEmis_2, mc2ndLayerMask.a);
                        matCapTexHardMult   = lerp(matCapTexHardMult, matCapTexHardMult_2, mc2ndLayerMask.g);
                    }
                    ////
                    mcMixAdd        = matCapTexAdd.rgb * matCapTexAdd.a;
                    mcMixMult       = matCapTexMult.rgb * matCapTexMult.a;
                    mcMixEmis       = matCapTexEmis.rgb * matCapTexEmis.a;
                    mcMixHardMult   = matCapTexHardMult.rgb * matCapTexHardMult.a;
                    UNITY_BRANCH
                    if (_TweakMatCapOnShadow)//// slider > 0
                    {
                        matcapShaMask       = lerp(1, shadowMaskNormalized, _TweakMatCapOnShadow);
                    }
                    UV_DD uv_mcMask         = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_matcapMask), _Set_MatcapMask));
                    float4 matcapMaskTex    = _Set_MatcapMask.SampleGrad( sampler_MainTex, uv_mcMask.uv, uv_mcMask.dx, uv_mcMask.dy);
                    matcapMask      = matcapMaskTex;
                    matcapMask.rgba   = saturate(matcapMaskTex.rgba * (_Tweak_MatcapMaskLevel + 1).xxxx);
                    // matcapMask.rg   *= saturate(matcapMaskTex.rg + _Tweak_MatcapMaskLevel.xx);


                                            
                    //// UTS2 Angel Ring 
                    UNITY_BRANCH if (_AngelRing)
                    { 
                        float3 mcARNormalView   = noSknewViewNormal;
                        // float3 mcARNormalView   = mul(UNITY_MATRIX_V, i.wNormal).xyz;
                        mcARNormalView      = lerp( float3(mcARNormalView.xy, 0), float3(0,0,1), _AR_OffsetU);//// U scale
                        // mcARNormalView      = lerp( float3(mcARNormalView.xy, 0), float3(0,0,1), _AR_OffsetU);//// U scale
                        float2 mcAR_UV      = mcARNormalView.xy * 0.5 + float2(0.5,0.5);//// switch to matcap UV coords
                        mcAR_UV             = rotateUV(mcAR_UV, float2(0.5,0.5), (_Rotate_MatCapUV * UNITY_PI) + matcapRotStablizer);
                        float mcAR_UV_VerticalTangent   = lerp( UVPick01(i.uv01, i.uv02, _uvSet_AngelRing).y, mcAR_UV.y, _AR_OffsetV);//// expand uv set selection
                        mcAR_UV             = float2(mcAR_UV.x, mcAR_UV_VerticalTangent);
                        UV_DD uv_angelRing  = UVDD( TRANSFORM_TEX(mcAR_UV, _AngelRing_Sampler));
                        float4 angelRingTex = _AngelRing_Sampler.SampleGrad( sampler_MatCap_Trilinear_clamp, uv_angelRing.uv, uv_angelRing.dx, uv_angelRing.dy);
                        mcARCol             = angelRingTex.rgb * _AngelRing_Color.rgb;/// * cubeMapAveAlbedo;
                        UNITY_BRANCH if (_ARSampler_AlphaOn)//// used to mask AR, and reduce diffuse for color replacement (NYI)
                        {
                            mcARTexAlpha    = angelRingTex.a;
                            mcARCol         *= mcARTexAlpha;
                        }
                    }
                }


//// Specular. High Color. spec math.
                float3 highColorTotalCol = specularSrcCol;
//// Specular. High Color. spec math
#define SPEC_LAYERS_COUNT_LIMIT 3
                int speclayerCount = max(0, min(_specLayersCount, SPEC_LAYERS_COUNT_LIMIT));
                float3 specTotalCol = 0;
                float3 specColorLayers[SPEC_LAYERS_COUNT_LIMIT] = {_HighColor.rgb, _specLayerCol2.rgb, _specLayerCol3.rgb};
                float specLobMaskLayers[SPEC_LAYERS_COUNT_LIMIT] = {0, 0, 0};
                float specLobeLayersNormalizedMaxs[SPEC_LAYERS_COUNT_LIMIT] = {0, 0, 0};
                float3 specHalfAngles[SPEC_LAYERS_COUNT_LIMIT] = {0,0,0, 0,0,0, 0,0,0};
                float specHalfDots[SPEC_LAYERS_COUNT_LIMIT] = {0,0,0};
                int c = 0;
                UNITY_BRANCH
                if ((dSpec.ndl < 0) || (dSpec.ndv < 0)) //// impossible dot setups
                {
                } 
                else
                {
                    int specModeArry[SPEC_LAYERS_COUNT_LIMIT] = {_Is_SpecularToHighColor, _specType2, _specType3};
                    float specControlExp[SPEC_LAYERS_COUNT_LIMIT] = {_specLayerRoughExp1, _specLayerRoughExp2, _specLayerRoughExp3};
                    float specLayersStep[SPEC_LAYERS_COUNT_LIMIT] = {_spaceLayerOffset1, _spaceLayerOffset2, _spaceLayerOffset3};
                    float specLayersFeather[SPEC_LAYERS_COUNT_LIMIT] = {_spaceLayerFeather1, _spaceLayerFeather2, _spaceLayerFeather3};
                    float specHalfAngleRatios[SPEC_LAYERS_COUNT_LIMIT] = {0.5, _specLayerHalfAngleTilt2, _specLayerHalfAngleTilt3};//// 1: no affect
                    float specHalfAngleRotate[SPEC_LAYERS_COUNT_LIMIT - 1] = {_specLayerHalfAngleRotate2, _specLayerHalfAngleRotate3};//// note the bad index correction below. Skipping [0]
                    float specTangentShift[SPEC_LAYERS_COUNT_LIMIT] = {_specTangentShift1, _specTangentShift2, _specTangentShift3,};
                    float specTangentScale = _shiftTangentShiftScale1;
                    float3 specTangentAngle = {dirTangent};
                    float3 specBitangentAngle = {dirBitangent};
                    float3 tempVec3 = {0,0,0};
                    [unroll] for (c=0; c < speclayerCount; c++) {specHalfAngles[c] = normalize(lerp(dirLight,  dirView, lerp(.5, specHalfAngleRatios[c], (dSpec.ndl * .5 * perceptualRoughness)))); }
                    [unroll] for (c=1; c < speclayerCount; c++) {specHalfAngles[c] = mul( rotationMatrix(dirHalf, UNITY_PI * specHalfAngleRotate[c - 1]), float4(specHalfAngles[c],1)).xyz; }///dont affect first lobe
                    [unroll] for (c=0; c < speclayerCount; c++) {specHalfDots[c] = saturate( dot(dirNormalSpecular, specHalfAngles[c])); }
                    // UNITY_BRANCH if (_UseLightMap) // needs rework
                    // {
                    //     //make hdl abstract, hdl whitens with decimal powers and pinches with >1 numbers. Pivot the mask at 50% grey where 50% means 1
                    //     float _lightMapSpecPowWidth = 8;
                    //     float powerY = (lightMapBias_Spec < .5) ? lerp(_lightMapSpecPowWidth,1,(lightMapBias_Spec)*2) : lerp(1,1/_lightMapSpecPowWidth,(lightMapBias_Spec-.5)*2);
                    //     [unroll] for (c=0; c < speclayerCount; c++) {specHalfDots[c] = pow(specHalfDots[c], powerY);}
                    //     debugVal = float4(specHalfDots[0].x,lightMapBias_Spec,0,1);
                    // }

                    float roughness         = PerceptualRoughnessToRoughness_ac(perceptualRoughness);
                    roughness               = max(roughness, 0.002);
                    UV_DD uv_tangentShift   = UVDD( TRANSFORM_TEX(  UVPick01(i.uv01, i.uv02, _uvSet_specular), _tangentShiftMask));
                    float4 tangentShiftMask = _tangentShiftMask.SampleGrad(sampler_MainTex, uv_tangentShift.uv, uv_tangentShift.dx, uv_tangentShift.dy);
                    tangentShiftMask.g = (tangentShiftMask.g * 2 - 1);
                    UNITY_BRANCH
                    if(_anisotropicDirectionFlip)
                    {
                        tempVec3 = specTangentAngle;
                        specTangentAngle = specBitangentAngle;
                        specBitangentAngle = tempVec3;
                    }
                    [unroll]
                    for (int specIndex = 0; specIndex < speclayerCount; specIndex++)
                    { //// work each spec layer
                        UNITY_BRANCH
                        if (specModeArry[specIndex] > 4) //// cloth
                        {
                            // specLobeLayersNormalizedMaxs[specIndex] = GGXTermPeak_ac(roughness) * SmithJointGGXVisibilityTermPeak_ac(roughness) * 10;
                            float roughnessMod  = pow(max(0.05, roughness), specControlExp[specIndex]);
                            float spec_NDF      = CharlieD(specHalfDots[specIndex], roughnessMod);
                            float spec_GSF      = AshikhminV(dSpec.ndl, dSpec.ndv);
                            // float spec_GSF      = CharlieV(dSpec.ndl, dSpec.ndv, roughnessMod);
                            // float spec_GSF      = SmithJointGGXVisibilityTerm_ac(dSpec.ndl, dSpec.ndv, roughnessMod);
                            specLobMaskLayers[specIndex]    = (spec_NDF * spec_GSF);
                            specLobMaskLayers[specIndex]    *= dSpec.ndl;
                            specLobMaskLayers[specIndex]    *= _specColorIntensity * UNITY_PI;
                            specLobMaskLayers[specIndex]    = max(0, specLobMaskLayers[specIndex]);
                        }
                        else if (specModeArry[specIndex] > 3) //// pbr anisotropic. 
                        {
                            float3 specBitangentAngleST = ShiftTangent(specBitangentAngle, dirNormalSpecular, (tangentShiftMask.g) * specTangentScale - specTangentShift[specIndex]);
                            float hdx = dot(specHalfAngles[specIndex], specTangentAngle);
                            float hdy = dot(specHalfAngles[specIndex], specBitangentAngleST);
                            
                            float ldx = dot(dirLight, specTangentAngle);
                            float ldy = dot(dirLight, specBitangentAngleST);
                            float vdx = dot(dirView, specTangentAngle);
                            float vdy = dot(dirView, specBitangentAngleST);
                            float aspect = sqrt(1 - _anisotropicArry * .9);
                            float roughnessMod = (pow((roughness), specControlExp[specIndex]));
                            float ax = max(.001, (roughnessMod) / aspect);
                            float ay = max(.001, (roughnessMod) * aspect);
                            // specLobeLayersNormalizedMaxs[specIndex] = GTR2_anisoPeak_ac(ax, ay) * smithG_GGX_anisoPeak_ac(ax, ay);
                            float dS = GTR2_aniso_ac(specHalfDots[specIndex], hdx, hdy, ax, ay);
                            float gS;
                            gS = smithG_GGX_aniso_ac(dSpec.ndl, ldx, ldx, ax, ay);
                            gS *= smithG_GGX_aniso_ac(dSpec.ndv, vdx, vdy, ax, ay);
                            specLobMaskLayers[specIndex] = dS * gS;
                            specLobMaskLayers[specIndex] *= dSpec.ndl;                      
                            specLobMaskLayers[specIndex] *= UNITY_PI;                  

                        }
                        else if (specModeArry[specIndex] > 2) //// strand spec
                        {
                            float3 specBitangentAngleST = ShiftTangent(specBitangentAngle, dirNormalSpecular, (tangentShiftMask.g) * specTangentScale - specTangentShift[specIndex]);
                            float roughnessMod = pow(roughness, specControlExp[specIndex]);
                            float NDF = StrandSpecular(specBitangentAngleST, specHalfAngles[specIndex],  RoughnessToSpecPower_ac(roughnessMod));
                            // float NDF = StrandSpecular(specBitangentAngleST, specHalfAngles[specIndex],  exp2( lerp(9, 1, roughnessMod)));
                            float GSF = WardGeometricShadowingFunction_ac (dSpec.ndl, dSpec.ndv);
                            specLobMaskLayers[specIndex] = NDF;
                            specLobeLayersNormalizedMaxs[specIndex] = 1.;
                            float specMaskNormalize         = specLobMaskLayers[specIndex] / specLobeLayersNormalizedMaxs[specIndex];
                            float specFeaturePinch          = (1 - specLayersFeather[specIndex]) * .5;
                            specMaskNormalize               = saturate(RemapRange(specMaskNormalize,
                                                                            0. + specFeaturePinch + specLayersStep[specIndex],
                                                                            1. - specFeaturePinch + specLayersStep[specIndex], 0., 1.));
                            specLobMaskLayers[specIndex] = specMaskNormalize * specLobeLayersNormalizedMaxs[specIndex];
                            specLobMaskLayers[specIndex] *= GSF;
                            specLobMaskLayers[specIndex] *= dSpec.ndl;
                            specLobMaskLayers[specIndex] *= _specColorIntensity * UNITY_PI;
                        }
                        else if (specModeArry[specIndex] > 1) //// unity
                        {
                            // specLobeLayersNormalizedMaxs[specIndex] = GGXTermPeak_ac(roughness) * SmithJointGGXVisibilityTermPeak_ac(roughness) * 10;
                            float roughnessMod  = pow(roughness, specControlExp[specIndex]);
                            float spec_NDF      = GGXTerm_ac(specHalfDots[specIndex], roughnessMod);
                            float spec_GSF      = SmithJointGGXVisibilityTerm_ac(dSpec.ndl, dSpec.ndv, roughnessMod);
                            specLobMaskLayers[specIndex]    = (spec_NDF * spec_GSF);
                            specLobMaskLayers[specIndex]    *= dSpec.ndl;
                            specLobMaskLayers[specIndex]    *= UNITY_PI;
                            specLobMaskLayers[specIndex]    = max(0, specLobMaskLayers[specIndex]);
                        }
                        else if (specModeArry[specIndex] > 0) //// controllable smooth
                        {

                            specLobeLayersNormalizedMaxs[specIndex] = 1;
                            float roughnessMod = pow(roughness, specControlExp[specIndex]);
                            specLobMaskLayers[specIndex]    = pow(specHalfDots[specIndex], RoughnessToSpecPower_ac(roughnessMod));
                            specLobMaskLayers[specIndex]    *= KelemenGSF(dSpec.ndl, dSpec.ndv, dSpec.vdh);
                            float specMaskNormalize         = specLobMaskLayers[specIndex] / specLobeLayersNormalizedMaxs[specIndex];

                            float specFeaturePinch          = (1 - specLayersFeather[specIndex]) * .5;
                            specMaskNormalize               = saturate(RemapRange(specMaskNormalize,
                                                                            0. + specFeaturePinch + specLayersStep[specIndex],
                                                                            1. - specFeaturePinch + specLayersStep[specIndex], 0., 1.));
                            // float specLobeIntensity         = sin((UNITY_HALF_PI * specLayersIntensity[specIndex]));
                            // specMaskNormalize               *= specLobeIntensity;

                            specLobMaskLayers[specIndex]    = specMaskNormalize * specLobeLayersNormalizedMaxs[specIndex];
                            specLobMaskLayers[specIndex]    *= dSpec.ndl;
                            specLobMaskLayers[specIndex]    *= _specColorIntensity * UNITY_PI;
                        }
                        else  //// sharp
                        { 
                            float roughnessMod = pow(roughness, specControlExp[specIndex]);
                            specLobMaskLayers[specIndex]    = step( 1 - (roughnessMod * roughnessMod), dSpec.ndhS * KelemenGSF(dSpec.ndl, dSpec.ndv, dSpec.vdh));
                            specLobMaskLayers[specIndex]    *= _specColorIntensity * UNITY_PI;
                        }
                    }
                    
                    UNITY_BRANCH
                    if (_TweakHighColorOnShadow) //// slider > 0
                    {
                        float highColorInShadow = lerp(1, shadowMaskNormalized, _TweakHighColorOnShadow);
                        [unroll]
                        for (int s = 0; s < speclayerCount; s++)
                        {
                            specLobMaskLayers[s] *= highColorInShadow;
                        }
                    }
                }
                //// mix lobs, system intended to mix +1 spec's lobes
                float3 specColorPrev = 1.0;
                float specLayerMaxWeight = 0;
                float specColorLayersPeak = 0;
                float3 specColorLayersSum = 0;
                [unroll] 
                for (c = 0; c < speclayerCount; c++)
                {
                    specLayerMaxWeight = max(specLayerMaxWeight, specLobMaskLayers[c]);
                }
                // layer blend crushing
                specLayerMaxWeight = max(0, specLayerMaxWeight - specLayerMaxWeight * (1 - _specMaskLayersPinch));
                float specWeightsCorrected[SPEC_LAYERS_COUNT_LIMIT];
                [unroll] 
                for (c = 0; c < speclayerCount; c++)
                {
                    specLobMaskLayers[c] = max(0, specLobMaskLayers[c] - specLayerMaxWeight);
                }
                [unroll] 
                //// layer order overriding
                float specLobMaskLayersPrev = specLobMaskLayers[0];
                float specLobeUnionMask = 0;
                [unroll] 
                for (c = 0; c < speclayerCount; c++)
                {
                    //// masking rules: use subtraction for replace, ortherwise its additive.
                    specLobMaskLayers[c] = max(0, specLobMaskLayers[c] - specLobeUnionMask);
                    specLobeUnionMask = (max(specLobeUnionMask, specLobMaskLayers[c] * (_specMaskLayersOrder)));
                }
                [unroll] 
                for (c = 0; c < speclayerCount; c++)
                {
                    specColorLayersSum += specColorLayers[c];
                }
                float3 specColors = 0;
                [unroll] 
                for (c = 0; c < speclayerCount; c++)
                {
                    specColors += specColorLayers[c] * specLobMaskLayers[c];
                }
                //// normalize colors
                float specColorLayersSumIntensity = LinearRgbToLuminance_ac(specColorLayersSum);
                UNITY_BRANCH
                if (specColorLayersSumIntensity > 1.0)
                {
                    specColors /= specColorLayersSumIntensity;
                }
                specColors *= IridescenceCol_ndh;






//// Env Reflection
                float3 colEnv           = 0;
                float3 envOntoRimSetup  = 0;
                half envRimMask = 0;
                // half mipC,testw,testw2,testh,lodMax;
                mip = testw = testw2 = testh = lodMax = 0;
                UNITY_BRANCH
                if (useCubeMap)
                {
                    float envLOD;
                    float3 reflDir0 = BoxProjection(dEnv.dirViewReflection.xyz, i.worldPos.xyz, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);

                    //// sample cubemaps
                    UNITY_BRANCH
                    if (_CubemapFallbackMode < 2) //// not override cubemap. solve real cubemaps
                    {
                        unity_SpecCube0.GetDimensions(mip,testw,testw,lodMax);
                        envLOD              = perceptualRoughnessToMipmapLevel_ac(roughnessReflection, lodMax);
                        float4 refColor0    = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflDir0, envLOD);
                        refColor0.rgb       = DecodeHDR(refColor0, unity_SpecCube0_HDR);
                        colEnv              = refColor0.rgb;
                        UNITY_BRANCH
                        if (unity_SpecCube0_BoxMin.w < 0.9999)//// 2nd blend cubemap
                        {
                            unity_SpecCube1.GetDimensions(mip,testw2,testh,lodMax);
                            envLOD              = perceptualRoughnessToMipmapLevel_ac(roughnessReflection, lodMax);
                            float3 reflDir1     = BoxProjection(dEnv.dirViewReflection, i.worldPos, unity_SpecCube1_ProbePosition, unity_SpecCube1_BoxMin, unity_SpecCube1_BoxMax);
                            float4 refColor1    = UNITY_SAMPLE_TEXCUBE_SAMPLER_LOD(unity_SpecCube1, unity_SpecCube0, reflDir1, envLOD);
                            refColor1.rgb       = DecodeHDR(refColor1, unity_SpecCube1_HDR);
                            colEnv              = lerp(refColor1.rgb, refColor0.rgb, unity_SpecCube0_BoxMin.w);
                        }
                    }
                    UNITY_BRANCH
                    if (_CubemapFallbackMode) //// not off
                    {
                        UNITY_BRANCH
                        if ( (_CubemapFallbackMode > 1) || (testw < 16)) //// mode forced or smart. Conditionals cannot short-circit
                        {
                            _CubemapFallback.GetDimensions(mip,testw,testh,lodMax);
                            envLOD              = perceptualRoughnessToMipmapLevel_ac(roughnessReflection, lodMax);
                            // envLOD              = perceptualRoughnessToMipmapLevel(roughnessReflection);
                            float4 colEnvBkup   = _CubemapFallback.SampleLevel(sampler_CubemapFallback, reflDir0, envLOD);
                            colEnvBkup.rgb      = DecodeHDR(colEnvBkup, _CubemapFallback_HDR);
                            colEnv.rgb          = colEnvBkup.rgb * cubeMapAveAlbedo.rgb;//// fallback albedo light mix
                        }
                    }
                    //// natural grazing rim mask
                    UNITY_BRANCH if (envGrazeMix_)
                    {
                        envRimMask = Pow4_ac(1 - dEnv.ndv);
                    }
                    envOntoRimSetup = colEnv.rgb;
                }




//// rim light
                half rimLightMask1 = 0;
                half rimLightMask2 = 0;
                half3 rimLightCol1 = 0;
                half3 rimLightCol2 = 0;
                UV_DD uv_rimLight = UVDD( TRANSFORM_TEX(  UVPick01(i.uv01, i.uv02, _uvSet_rimLightMask), _Set_RimLightMask));
                UNITY_BRANCH
                if (_useRimLightSystem)
                {
                    half rimLightMaskTex = _Set_RimLightMask.SampleGrad( sampler_MainTex, uv_rimLight.uv, uv_rimLight.dx, uv_rimLight.dy).g;
                    UNITY_BRANCH
                    if (_invertRimLightMask){rimLightMaskTex = 1 - rimLightMaskTex;}
                    half rimLightTexMask = saturate(rimLightMaskTex + _Tweak_RimLightMaskLevel);
                    UNITY_BRANCH 
                    if (_rimLightVersionMode) // (_rimLightVersionMode)
                    {
                        //// new rim
                        float rimArea_ndv = (.5 - dRimLight.ndv * .5);
                        float rimArea = saturate((gain(saturate(rimArea_ndv - _rimLightStep + .5), _rimLightGain)));
                        UNITY_BRANCH
                        if (_rimLightDirectionMode)
                        {
                            float rimArea2 = saturate((gain(saturate(rimArea_ndv - _rimLightStep + .5), _rimLightGain_AP)));
                            // float rimArea2 = saturate((gain(saturate(rimArea_ndv - _rimLightStep + (_rimLightFeather * .5)), _rimLightGain_AP)) / _rimLightFeather);
                            //// direction masking
                            float rimDirection_ndv = 1 - dRimLight.ndv;
                            float rimDirection = (dot(dirLight, dirNormalRimLight) * .5 + .5) * rimDirection_ndv;
                            rimDirection = (gain(StepFeatherRemap( saturate(rimDirection), _rimLightDirectionStep, 1, 1), _rimLightDirectionGain));
                            // rimDirection = (gain(StepFeatherRemap( saturate(rimDirection), _rimLightDirectionStep, _rimLightDirectionFeather, 1), _rimLightDirectionGain));
                            float rimDirection2 = (dot(-dirLight, dirNormalRimLight) * .5 + .5) * rimDirection_ndv;
                            rimDirection2 = (gain(StepFeatherRemap( saturate(rimDirection2), _rimLightDirectionStep, 1, 1), _rimLightDirectionGain));
                            // rimDirection2 = (gain(StepFeatherRemap( saturate(rimDirection2), _rimLightDirectionStep, _rimLightDirectionFeather, 1), _rimLightDirectionGain));
                            rimArea = rimArea * rimDirection;
                            rimArea2 = rimArea2 * rimDirection2;
                            rimLightMask1 = rimArea;
                            rimLightMask2 = rimArea2;
                        }
                        else
                        {
                            rimLightMask1 = rimArea;
                            rimLightMask2 = 0;
                        }
                    }
                    else
                    {
                        // old rim
                        half rimArea1 = StepFeatherRemap((1.0 - (dRimLight.ndv)), -_RimLightAreaOffset + 1, 1 - _RimLight_InsideMask);
                        half rimlightMaskSetup1 = pow(rimArea1, exp2( lerp(3, 0, _RimLight_Power)));
                        UNITY_BRANCH
                        if (_LightDirection_MaskOn)
                        {
                            half rimlightMaskSetup2 = pow(rimArea1, exp2( lerp(3, 0, _Ap_RimLight_Power)));
                            half vdl                = (dot(UNITY_MATRIX_V[2].xyz, dirNormalRimLight) * .1 + .1); /// camera z forward vector
                            half nDl                = dot(dirLight,dirNormalRimLight)*.5+.5;
                            half rimlightMaskToward = (1 - nDl) + _Tweak_LightDirection_MaskLevel;
                            half rimLightMaskAway   = (nDl) + _Tweak_LightDirection_MaskLevel;
                            rimLightMask1           = saturate(rimlightMaskSetup1 - rimlightMaskToward - vdl);
                            rimLightMask2           = saturate(rimlightMaskSetup2 - rimLightMaskAway - vdl);
                        } 
                        else
                        {
                            rimLightMask1   = rimlightMaskSetup1;
                            rimLightMask2   = 0;
                        }
                    }
                    ////
                    rimLightMask1   *= rimLightTexMask;
                    rimLightMask2   *= rimLightTexMask;
                    //// colors input
                    half3 rimTexAlbedo = 1;
                    UNITY_BRANCH
                    if (_rimAlbedoMix)
                    {
                        UNITY_BRANCH
                        switch(_RimLightSource) {
                            default:
                            case 0: rimTexAlbedo = shadeColor_albedo; break;
                            case 1: rimTexAlbedo = specularSrcCol; break;
                        }
                        rimTexAlbedo = lerp(1, rimTexAlbedo, _rimAlbedoMix);
                    }
                    //// needs complete rework, overTone color does not blend wih rimTexAlbedo. 
                    rimLightCol1 = _RimLightColor.rgb * rimTexAlbedo.rgb;
                    rimLightCol2 = _Ap_RimLightColor.rgb * rimTexAlbedo.rgb;
                    UNITY_BRANCH
                    if (_useRimLightOverTone)
                    {
                        float rimArea_overTone = (Pow2Recurve(StepFeatherRemap( (.5 - dRimLight.ndv * .5), _rimOverToneStep, _rimOverToneFeather, 0), _rimOverTonePow));
                        // float rimArea_overTone = (1-Pow2Recurve(1-StepFeatherRemap( (.5 - dRimLight.ndv * .5), _rimOverToneStep, _rimOverToneFeather, 0), _rimOverTonePow));
                        half rimEdgeBoundary1   = rimArea_overTone;//// edge color
                        half rimEdgeBoundary2   = rimArea_overTone;//// edge color
                        rimLightCol1            = lerp(rimLightCol1.rgb, _rimLightOverToneBlendColor1.rgb,  rimEdgeBoundary1);
                        rimLightCol2            = lerp(rimLightCol2.rgb, _rimLightOverToneBlendColor2.rgb,  rimEdgeBoundary2);
                    }
                }



//// Emission   // crosses into diffuse effect
#ifdef UNITY_PASS_FORWARDBASE
                half3 emissionTint1;
                UV_DD uv_EmissionCol_1;
                float4 emissionTex1;
                UNITY_BRANCH
                if (_emissionUseStandardVars) // use Standard's variables for vrchat fallback support (note: vrchat does not actually support this fallback :^) )
                {
                    uv_EmissionCol_1    = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_EmissionColorTex), _EmissionMap));
                    emissionTex1        = _EmissionMap.SampleGrad( sampler_MainTex, uv_EmissionCol_1.uv, uv_EmissionCol_1.dx, uv_EmissionCol_1.dy);
                    emissionTint1       = _EmissionColor.rgb;
                }
                else // use UTS2's variables
                {
                    uv_EmissionCol_1    = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_EmissionColorTex), _Emissive_Tex));
                    emissionTex1        = _Emissive_Tex.SampleGrad( sampler_MainTex, uv_EmissionCol_1.uv, uv_EmissionCol_1.dx, uv_EmissionCol_1.dy);
                    emissionTint1       = _Emissive_Color.rgb;
                }
                //// prepare tint driver (for extram custom render textures that animate)
                UV_DD uv_driverTintTex  = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_driverTintTex), _driverTintTex));
                float3 driverTintTex    = _driverTintTex.SampleGrad( sampler_MainTex, uv_driverTintTex.uv, uv_driverTintTex.dx, uv_driverTintTex.dy).rgb;
                //// prepare tint
                emissionTint1           *= emissionTex1.rgb * emissionTex1.a;
                half3 emissionTintChain = emissionTint1;
                UNITY_BRANCH 
                if (_emissionUse2ndTintRim) //// mix 2nd tint rim
                {
                    UV_DD uv_EmissionCol_2  = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_EmissionColorTex), _EmissionColorTex2));
                    float4 emissionTex2     = _EmissionColorTex2.SampleGrad( sampler_MainTex, uv_EmissionCol_2.uv, uv_EmissionCol_2.dx, uv_EmissionCol_2.dy);
                    half3 emissionTint2 = _Emissive_Color2.rgb * emissionTex2.rgb * emissionTex2.a;
                    half emisRimMask    = RemapRangeH01((dEmiss.ndv*.5+.5), _emission2ndTintLow, _emission2ndTintHigh);
                    emisRimMask         = 1 - Pow2Recurve((1 - emisRimMask), _emission2ndTintPow);
                    emissionTintChain   = lerp(emissionTint2, emissionTintChain, emisRimMask);
                }

                UNITY_BRANCH if (_emissionMixTintDiffuseSlider)
                { //// tint uses diffuse color
                    half3 diffuseTintAlbedo = 1;
                    UNITY_BRANCH
                    if (_emissionMixTintDiffuseSlider)
                    {
                        UNITY_BRANCH
                        switch(_emisLightSourceType) {
                            default:
                            case 0: diffuseTintAlbedo = shadeAlbedoTex1.rgb; break;
                            case 1: diffuseTintAlbedo = shadeAlbedoTex2.rgb; break;
                            case 2: diffuseTintAlbedo = shadeAlbedoTex3.rgb; break;
                        }
                    }
                    emissionTintChain = lerp(emissionTintChain, emissionTintChain * diffuseTintAlbedo, _emissionMixTintDiffuseSlider);
                }
                //// decal emission
                UNITY_BRANCH
                if (_useDecalEmission1)
                {
                    emissionTintChain.rgb = Decal(    frac(UVPick01(i.uv01, i.uv02, _uvSet_DecalEmission1)), float4(emissionTintChain.rgb, 1), _DecalEmission1, sampler_MainTex, _DecalEmission1_color.rgb,
						_DecalEmission1_transform.xyzw,
						_DecalEmission1_pivotR.xy, _DecalEmission1_rotate,
						_DecalEmission1_pivotS.xy, _DecalEmission1_scale, _DecalEmission1_ratioWH.xy,
						_DecalEmission1_blendMode, _DecalEmission1_usePremultiplyAlpha,
						_DecalEmission1_cutoff, _DecalEmission1_blendAmount,
						_DecalEmission1_boarder).rgb;
                }
                UNITY_BRANCH if (_useEmissionHSVI)
                {
                    float4 emissionHSVIMask = _emissionHSVIMask.SampleGrad( sampler_MainTex, uv_EmissionCol_1.uv, uv_EmissionCol_1.dx, uv_EmissionCol_1.dy);
                    emissionTintChain = lerp(emissionTintChain, HSVI_controller(emissionTintChain, _emissionHSVIController1), emissionHSVIMask.g);
                }
                UNITY_BRANCH
                if (_MatCap){ //// matcap emission
                    half mcMask; if (_matcapEmissMaskSwitch == 1) {mcMask = matcapMask.a;} else {mcMask = 1;}
                    emissionTintChain = max(emissionTintChain, mcMixEmis * _MatCapColEmis.rgb * mcMask);
                }
                //// mix all
                half emissionLums = max(1., _emissionProportionalLum * lightAverageLum);
                half3 emissionMix = emissionTintChain * driverTintTex * emissionLums;
                //// prepare masks
                half emissionMask   = 0;
                UNITY_BRANCH if (_emissionUseMask) //// use mask (my legacy gives it a bad name of "_EmissionColorTex" which was roled as tint mask)
                { 
                    UV_DD uv_emissiveMask  = UVDD(TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_emissionMask), _EmissionColorTex));
                    emissionMask    = _EmissionColorTex.SampleGrad( sampler_MainTex, uv_emissiveMask.uv, uv_emissiveMask.dx, uv_emissiveMask.dy).g;
                    UNITY_BRANCH if (_emissiveUseMainTexA)//// because some games store emission mask in main texture alpha
                    {
                        emissionMask = shadeAlbedoTex1.a;
                    }
                    emissionMix     = emissionMix * emissionMask;
                    //// dim diffuse by emission mask area
                    UNITY_BRANCH if (_emissionUseMaskDiffuseDimming) 
                    { 
                        shadeColor_albedo = shadeColor_albedo * (1 - emissionMask * _emissionUseMaskDiffuseDimming);
                    }
                }
#endif //// UNITY_PASS_FORWARDBASE


////////////////////////////////////////////////////////////////
//// The Mix zone. Blend everything. In intent all effects are prepared. Requires masks and color sets.
                float4 fragColor    = 0;
                float3 colDiffuse   = 0;
                float3 colSpecular  = 0;
                float3 colFernel    = 0;
                float3 colGrabPass  = 0;
                float3 colReflect   = 0;
                float3 colSubsurface = 0;
                float3 colEmission  = 0;

//// base diffuse
                half3 shadeAlbedoMix = shadeColor_albedo;
                half3 shadeColor = shadeColor_albedo * shadeColor_shade;//// mix ramp
                UNITY_BRANCH
                if (_MatCap && _useMCHardMult) //// mix multiply matcap
                {
                    float mcHardBlend = matcapMask.g * _MatCapTexMultBlend;
                    shadeColor *= lerp(1, (mcMixHardMult * _MatCapColHardMult.rgb), mcHardBlend);
                }
                UNITY_BRANCH if
                (_MatCap) //// mix diffuse matcap
                {
                    float3 diffMixMC = 1;
                    if (_McDiffAlbedoMix)
                    {
                        diffMixMC = lerp(1, shadeColor_albedo, _McDiffAlbedoMix);
                    }
                    shadeColor += (diffMixMC * lightSimpleSystem * mcMixMult.rgb * _MatCapColMult.rgb * matcapMask.r);
                }
                colDiffuse = shadeColor;

//// rim light
                float3 rimMixer = 0; //// get effects
                UNITY_BRANCH if (_useRimLightSystem)
                {
                    rimMixer += rimLightCol1 * rimLightMask1;
                    rimMixer += rimLightCol2 * rimLightMask2;
                }
                colFernel = rimMixer;
                if (_rimLightUseTFICol) { colFernel *= IridescenceCol_ndv; }

                half3 colFernelLight = 1;
                if (true) //// fake function incapsulation
                {
                    #ifdef UNITY_PASS_FORWARDADD
                    envOntoRimSetup = envOntoRimSetup * lightAtten; //// ADD pass lights falloff * cubemap makes no sense, but falloff is needed for my rim light gimmiks
                    #endif
                    colFernelLight = lerp(cubeMapAveAlbedo, envOntoRimSetup, _envOnRim); //// get cubemap setup
                    colFernelLight = lerp(LinearRgbToLuminance_ac(colFernelLight), colFernelLight, _envOnRimColorize); //// cubemap color
                    colFernelLight = lerp(lightSimpleSystem, colFernelLight, _rimLightLightsourceType); //// select light system
                }
                colFernel *= colFernelLight * _rimLightIntensity * UNITY_PI;
                ////
                UNITY_BRANCH if (_rimLightUseNPRReduction)
                { 
                    float surfaceReductionRimLight = 1 / (roughnessPR * roughnessPR + 1.0);
                    colFernel *= surfaceReductionRimLight * grazingTerm;
                }



//// specularity shine lobes
                colSpecular = aoSpecularM;
                colSpecular *= FresnelTerm_ac(highColorTotalCol * specColors, dSpec.ldh);
                colSpecular *= (lightDirectSource);



//// reflection
                float3 envColMixCore = glossColor;
#ifdef UNITY_PASS_FORWARDBASE
                UNITY_BRANCH
                if (_ENVMmode > 0) //// using env
                {
                    //// reflection and fernel
                    float envGrazeMask;
                    UNITY_BRANCH if (envGrazeRimMix_)
                        { envGrazeMask = max(rimLightMask1.x, rimLightMask2.x); } 
                    else 
                        { envGrazeMask = envRimMask; }
                    // float envGrazeMask      = max( (envRimMask), ((envGrazeRimMix_) ? max(rimLightMask1, rimLightMask2) : 0)); //// mix rim types
                    // float grazingTerm       = saturate(smoothnessGloss + (1 - oneMinusReflectivityGloss)); //// graze intensity [0,1]
                    float envColMixGraze = grazingTerm.x * (1 + colGIGray.x); //// light source hybrid of reflection and indirect: [0,1] * [1,n]. colGIGray is BASE only
                    float3 envColMix    = lerp(envColMixCore, envColMixGraze.xxx, envGrazeMask); //// graze effect. Source light.
                    colReflect          = colEnv;
                    
                    colReflect          *= surfaceReduction * aoSpecularM;
                    colReflect          *= envColMix;
                    colReflect          *= IridescenceCol_ndv * UNITY_PI;
                }
#endif //// UNITY_PASS_FORWARDBASE
                UNITY_BRANCH if (_MatCap){//// spec matcap
                    half3 mcSpecSourceLight = cubeMapAveAlbedo;
                    half mcMask; UNITY_BRANCH if (_matcapSpecMaskSwitch==1) {mcMask = matcapMask.b;} else {mcMask = aoSpecularM;}
                    colReflect += (mcMixAdd * _MatCapColAdd.rgb * mcSpecSourceLight) * (matcapShaMask * mcMask);
                }
                UNITY_BRANCH if (_AngelRing)
                {
                    colReflect += mcARCol * cubeMapAveAlbedo;
                }



//// energy conservation on diffuse AND grabpass mixing
                float3 colDiffuseTerms      = (colDiffuse);

//// grabpass
                float grabPassFinalMix = 0;
            #ifdef ScreenDepthDataContext
                float grabpassCutMix    = _useGrabPassHardCut ? (((1 - grabPassMask.r) - _depthBufferCutout) < 0) : (grabPassMask.r);
                grabPassFinalMix        = grabpassCutMix * (grabpassCutMix * _grabPassMix);

                colGrabPass             = colorGrabPassEffects.rgb * grabPassFinalMix;
                // colDiffuseTerms         = lerp(colDiffuseTerms, colorGrabPassEffects.rgb, grabpassCutMix * _grabPassMix);
//// blend grabPass
                fragColor.rgb += max(0, colGrabPass);
            #endif // ScreenDepthDataContext

//// distance darken
                float distanceDarkenScale = 1;
                UNITY_BRANCH if (_useDistanceDarken) 
                {
                    distanceDarkenScale = sqr(saturate((distance(i.worldPos.xyz, StereoWorldViewPos().xyz) + .02) * 5));
                }

//// specular mix            
                float3 colSpecularTerms = colSpecular + colFernel + colReflect;
                colSpecularTerms        *= distanceDarkenScale;

//// diffuse dimming factors
                colDiffuseTerms         *= min(diffuseScale, 1 - grabPassFinalMix);
                colDiffuseTerms         *= distanceDarkenScale;

//// specular blending with premultiply alpha
#if !defined(NotAlpha) && !defined(UseAlphaDither) //// cutout mode. dont use premultiplay block
                UNITY_BRANCH
                if (_UseSpecAlpha)
                {
                    PremultiplyAlpha_ac(colDiffuseTerms/* inout */, alpha/* inout */, 1);
                    fragColor.rgb   += colDiffuseTerms + colSpecularTerms;
                    fragColor.a     = alpha;
                }
                else 
                {
                    float3 fuseCol  = colDiffuseTerms + colSpecularTerms;
                    fuseCol         *= alpha;
                    fragColor.rgb   += fuseCol;
                    fragColor.a     = alpha;
                }
#else //// NotAlpha
                fragColor.rgb   = colDiffuseTerms + colSpecularTerms;
                fragColor.a     = alpha;
#endif //// NotAlpha
                fragColor.rgb   = max(0, fragColor.rgb);


//// SSS
                colSubsurface = colSSS;
                fragColor.rgb += colSubsurface;


//// blend emission
#ifdef UNITY_PASS_FORWARDBASE
                colEmission     = emissionMix;
                fragColor.rgb   += colEmission;
#endif // UNITY_PASS_FORWARDBASE

                //// backface tint
                UNITY_BRANCH if (isBackFace){
                    fragColor.rgb *= _backFaceColorTint.rgb;
                }

            #ifdef UNITY_PASS_FORWARDADD
                UNITY_APPLY_FOG_COLOR(i.fogCoord,fragColor, half4(0,0,0,0));
                fragColor.rgb = fragColor.rgb * (.5 * (1+alpha));//// poor solution of layering alpha becoming too bright compromised with additive lights becoming dark
            #else
                UNITY_APPLY_FOG_COLOR(i.fogCoord, fragColor, unity_FogColor * alpha);
            #endif

                /*
                //// anti aliasing derivative (lite). Only works on self. unfortinatly i needed it to work with outlines and the world contrast
                float fragColorLum = LinearRgbToLuminance_ac(LinearRgbToLuminance_ac(fragColor.rgb));
                float fragColorDerivativeX = ddx(fragColorLum);
                float fragColorDerivativeY = ddy(fragColorLum);
                float fgDL = length(fragColorDerivativeX - fragColorDerivativeY);
                // fragColor.rgb = fgDL;
                // fragColor.rgb = smoothstep(-1, 1, fgDL).xxx;
                fragColor.rgb = lerp(1.5, 0.5, smoothstep(-1, 1, fgDL)).xxx;
                // fragColor.rgb = fragColor.rgb * lerp(1.5, 0.5, smoothstep(-1, 1, fgDL));
                // float3 fragColor2 = fragColor.rgb * lerp(1.5, 0.5, smoothstep(-1, 1, fgDL));
                // fragColor.rgb = (_SinTime.w > .75) ?  fragColor2.rgb :  fragColor.rgb;
                */

                //// debug
                // return lerp(float4(debugVal.xyz,1), fragColor, 0.000001);

                //// texture Sampler object keep gimmik for the assembler being wrong removing it. Cursed code.
                float sampleSum = 0;
                float sampleDimWidth = 0;
                float sampleDimHeight = 0;
                _MainTex.GetDimensions(sampleDimWidth, sampleDimHeight);
                sampleSum += sampleDimWidth;
                _NormalMap.GetDimensions(sampleDimWidth, sampleDimHeight);
                sampleSum += sampleDimWidth;
                _MatCapTexAdd.GetDimensions(sampleDimWidth, sampleDimHeight);
                sampleSum += sampleDimWidth;
                if (sampleSum) // choice doesnt matter. The journey was the goal
                {
                    return fragColor;
                }
                else
                {
                    return fragColor;
                }
                // return fragColor;
            }
#endif //// ACLS_CORE