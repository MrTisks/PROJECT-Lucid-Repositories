//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
Shader "ACiiL/toon/ACLS_Toon_Cutout_GrabPass" {
    CGINCLUDE
    #pragma skip_variants DYNAMICLIGHTMAP_ON LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING DIRLIGHTMAP_COMBINED SHADOWS_SHADOWMASK
    #include "UnityCG.cginc"
    #include "AutoLight.cginc"
    #include "Lighting.cginc"
    // #define NotAlpha
    #define IsClip
    #define DepthDataContext
    #define ScreenDepthDataContext
    #define GrabPassDataContext
    #include "./ACLS_HELPERS.cginc"
    ENDCG

    Properties {
        //// grabpass effects
        _grabPassMix("_grabPassMix",Range(0,1)) = .5
        _depthBufferCutout("_depthBufferCutout",Range(0,1.001)) = 1.001
        [ToggleUI] _useGrabPassHardCut("_useGrabPassHardCut", int) = 0
        [ToggleUI] _grabPassOverBrightnessClamp("_grabPassOverBrightnessClamp", int) = 0
        _grabPassMask("_grabPassMask", 2D) = "white" {}
        _grabPassTint("_grabPassTint", Color) = (1,1,1,1)
        _grabPassTintTex("_grabPassTintTex", 2D) = "white" {}
        _grabPassMixAlbedo("_grabPassMixAlbedo",Range(0,1)) = 0
        _depthFactor("depth Factor",Range(0,8)) = 1.0
        _depthPow("depth Pow", Range(1,8)) = 1.0
        [Enum(Use Refraction Effect,0,Use Depth Blur Effect,1)] _useBlurDepth("_useBlurDepth", int) = 0
        [ToggleUI] _useDepthEffects("_useDepthEffects", int) = 0
        [Normal] _distortionBumpMap("_distortionBumpMap", 2D) = "bump" {}
        _distortionBumpMapScale ("_distortionBumpMapScale", Float) = 1
        _IORStrength("_IOR Thickness", Range(-0.1, .1)) = 0.1
        _IOR("_IOR",Range(1,5)) = 1.5
        _blurWidth("_blurWidth", Range(0, .05)) = .025
        _sigma("_sigma",Range(0.25,2)) = 1
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_grabPassMask("_uvSet_grabPassMask", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_grabPassTintTex("_uvSet_grabPassTintTex", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_distortionBumpMap("_uvSet_distortionBumpMap", int) = 0
        
        [ShaderOptimizerLockButton] _ShaderOptimizerEnabled ("", Int) = 0
        [Enum(OFF,0,FRONT,1,BACK,2)] _CullMode("Cull Mode", int)    = 2  //OFF/FRONT/BACK
        [HDR] _backFaceColorTint("Backface Color Tint",Color)   = (1,1,1,1)
        // [ToggleUI] _TestToggle ("Test toggle",Int)  = 0

        // [Header(Toon ramp)]
        _MainTex("Main Tex", 2D) = "white" {}
        [ToggleUI] _useToonRampSystem("_useToonRampSystem", Int) = 1
        [ToggleUI] _useDiffuseAlbedoTexturesSet("_useDiffuseAlbedoTexturesSet", Int) = 0
        [Enum(Swap As,0,Multiply Over,1)] _toonRampTexturesBlendMode("_toonRampTexturesBlendMode", Int) = 0
        [Enum(Self,0,MainTex,1,Backward,2)] _Use_BaseAs1st("1st shade source", Int) = 0
        [NoScaleOffset] _1st_ShadeMap("--1st shade Tex", 2D) = "white" {}
        [Enum(Self,0,Core,1,MainTex,2)] _Use_1stAs2nd("2nd shade source", Int) = 0
        [NoScaleOffset] _2nd_ShadeMap("--2nd shade Tex", 2D) = "white" {}
        _Color("Base color", Color) = (1,1,1,1)
        _BaseColor("--Foward color", Color) = (1,1,1,1)
        _1st_ShadeColor("--Core color", Color) = (0.97,0.97,0.97,1)
        _2nd_ShadeColor("--Back color", Color) = (0.95,0.95,0.95,1)
        _BaseColor_Step("Step: forward ", Range(0, 1)) = 0.55
        _BaseShade_Feather("--Feather: forward", Range(0.001, 1)) = 0.001
        _ShadeColor_Step("Step: back", Range(0, 1)) = 0.5
        _1st2nd_Shades_Feather("--Feather: back", Range(0.001, 1)) = 0.001
        [Enum(Backward,0,Core,1)] _DiffToonShadePriority("_DiffToonShadePriority", Int) = 0
        [Enum(Back,0,Middle,1,Front,2)] _ToonRampFeather_n1_OffsetMode("_ToonRampFeather_n1_OffsetMode", Int) = 0
        [Enum(Back,0,Middle,1,Front,2)] _ToonRampFeather_n2_OffsetMode("_ToonRampFeather_n2_OffsetMode", Int) = 0
        [Enum(All Light,0,Natural Indirect,1)] _ToonRampLightSourceType_Core("Toon ramp Core light source type:",Int) = 0
        _diffuseIndirectDirectSimCoreMix("Core (In)Direct Mix", Range(0, 1)) = 1
        [Enum(All Light,0,Natural Indirect,1)] _ToonRampLightSourceType_Backwards("Toon ramp Backface light source type:",Int) = 0
        _diffuseIndirectDirectSimMix("Backward (In)Direct Mix", Range(0, 1)) = 0
        // _Set_SystemShadowsToBase("shadows mix core tone mix",Range(0,1)) = 0
        // [Space(18)]
        [ToggleUI] _Diff_GSF_01("Toon ramp GSF effect", Int) = 0
        _DiffGSF_Offset("--Offset",Range(0,2)) = 1
        _DiffGSF_Feather("--Feather",Range(0.01,2)) = 0.2
        //
        [ToggleUI] _useCrossOverRim("_useCrossOverRim", Int) = 0
        [ToggleUI] _crossOverUseToonShades("_crossOverUseToonShades", Int) = 1
        _crossOverMask("_crossOverMask", 2D) = "white" {}
        _crossOverAlbedo("_crossOverAlbedo", 2D) = "white" {}
        _crossOverStep("_crossOverStep", Range(0,1)) = .5
        _crossOverFeather("_crossOverFeather", Range(0.001,1)) = .5
        _crosspOverRimPow("_crosspOverRimPow", Range(0.1,32)) = 1
        _crossOverPinch("_crossOverPinch", Range(0.1,.45)) = .1
        [HDR] _crossOverTint("_crossOverTint", Color) = (1,1,1,1)
        [Enum(Self,0,MainTex,1,Core,2,Backward,3)] _crossOverSourceTexSource("_crossOverSourceTexSource", Int) = 1
        [ToggleUI] _useAlbedoTexModding("_useAlbedoTexModding", Int) = 0
        [NoScaleOffset] _albedoTexHSVIMask("_albedoTexHSVIMask", 2D) = "white" {}
        _controllerAlbedoHSVI_1("_controllerAlbedoHSVI_1", Float) = (0,0,0,1)
        _controllerAlbedoHSVI_2("_controllerAlbedoHSVI_2", Float) = (0,0,0,1)
        _controllerAlbedoHSVI_3("_controllerAlbedoHSVI_3", Float) = (0,0,0,1)

        // [Header(Specular Shine)]
        [ToggleUI] _UseSpecularSystem("Use specular effects",Int)  = 0
        [Enum(Specular,0,Metallic,1,Roughness,2)] _WorkflowMode("_WorkflowMode", Int ) = 0
        [Enum(Off,0,On,1)] _SpecOverride("_SpecOverride", Int ) = 0
        [Enum(On,0,Off,1)] _UseDiffuseEnergyConservation("Energy conservation", Int ) = 1
        _SpecColor("Specular Primary Color",Color)    = (1,1,1,1)
        _Glossiness("Smoothness",Range(0,1))    = .3
        _Metallicness("_Metallicness",Range(0,1))    = 1
        _HighColor_Tex("--Specular Setup Tex: (RGB):Tint, (A):Smoothness", 2D)  = "white" {}
        _MetallicGlossMap("_MetallicGlossMap", 2D)  = "white" {}
        _SpecGlossMap("_SpecGlossMap", 2D)          = "white" {}
        _highColTexSource("----Multiply with albedo", Range(0,1))   = 0
        _SpecularMaskHSV("--Adjest (H)ue (S)sat (V)alue (I)ntensity",Vector) = (0,0,0,1)
        _TweakHighColorOnShadow("Spec shadow mask", Range(0, 1))    = 0.5
        //// specular layer system
        [Enum( _ 1, 1, _ 2, 2, _ 3, 3)]_specLayersCount("Layers:", Int) = 1
        _specColorIntensity("_specIntensity",Range(0.31830988618,10)) = 1
        _specMaskLayersPinch("_specMaskLayersPinch",Range(0,1)) = 0
        _specMaskLayersOrder("_specMaskLayersOrder",Range(0,1)) = 0
        _HighColor("Color 1", Color)  = (1,1,1,1)
        _specLayerCol2("Color 2", Color) = (1,1,1,1)
        _specLayerCol3("Color 3", Color) = (1,1,1,1)
        [Enum(Sharp,0,Toony NPR,1,Unity PBR,2, Hair NPR, 3, Anistropic PBR, 4, Sheen NPR, 5)] _Is_SpecularToHighColor("Type 1", Int ) = 1//// _specType1
        [Enum(Sharp,0,Toony NPR,1,Unity PBR,2, Hair NPR, 3, Anistropic PBR, 4, Sheen NPR, 5)] _specType2("Type 2", Int ) = 1
        [Enum(Sharp,0,Toony NPR,1,Unity PBR,2, Hair NPR, 3, Anistropic PBR, 4, Sheen NPR, 5)] _specType3("Type 3", Int ) = 1
        _specLayerRoughExp1("Smooth Recurve 1",Range(.25,1)) = 1
        _specLayerRoughExp2("Smooth Recurve 2",Range(.25,1)) = 1
        _specLayerRoughExp3("Smooth Recurve 3",Range(.25,1)) = 1
        _spaceLayerOffset1("Offset 1",Range(0,1)) = 0
        _spaceLayerOffset2("Offset 2",Range(0,1)) = 0
        _spaceLayerOffset3("Offset 3",Range(0,1)) = 0
        _spaceLayerFeather1("Smoothen 1",Range(0.01,1)) = 1
        _spaceLayerFeather2("Smoothen 2",Range(0.01,1)) = 1
        _spaceLayerFeather3("Smoothen 3",Range(0.01,1)) = 1
        _specLayerHalfAngleTilt2("Shine Tilt 2",Range(0,1)) = .5
        _specLayerHalfAngleTilt3("Shine Tilt 3",Range(0,1)) = .5
        _specLayerHalfAngleRotate2("Shine Rotate 2",Range(-1,1)) = 0
        _specLayerHalfAngleRotate3("Shine Rotate 3",Range(-1,1)) = 0
        //// anisotropic controls
        [ToggleUI] _anisotropicDirectionFlip("Anisotropic Direction Flip",Int) = 0
        _tangentShiftMask("Tangent Shift Mask(g)",2D) = "linearGrey"{}////linearGrey
        _shiftTangentShiftScale1("Shift Scale",Range(-1,1)) = 0.2
        _anisotropicArry("Anisotropic Strength",Range(0,1)) = 1
        _specTangentShift1("Tangent Shift 1",Range(-1,1)) = 0
        _specTangentShift2("Tangent Shift 2",Range(-1,1)) = 0
        _specTangentShift3("Tangent Shift 3",Range(-1,1)) = 0

        // [Header(Reflection)]
        [ToggleUI] _useCubeMap("_useCubeMap",Int) = 0
        [Enum(Off,0,Mask,1,Replace,2)] _GlossinessMapMode("_GlossinessMapMode",Int) = 0
        _GlossinessMap("_GlossinessMap",2D) = "white" {}
        [Enum(Standard,1,Override,2)] _ENVMmode("Reflection Setup:",Int) = 1
        _ENVMix("--Reflection mix",Range(0,1))                                              = 1
        _envRoughness("--Reflection smoothness", Range(0, 1))                               = 0.5
        [Enum(Off,0,Smart,1,Always,2)] _CubemapFallbackMode("Fallback mix mode:",Int)      = 0
        [NoScaleOffset] _CubemapFallback("--Fallback Cubemap",Cube)                         = "black" {}
        // [Space(18)]
        [Enum(Off,0,On,1)] _EnvGrazeMix("Graze Natural mix",Int)                            = 0
        [Enum(Off,0,On,1)] _EnvGrazeRimMix("Graze RimLights Mask mix",Int)                  = 0
        _envOnRim("Mask on rimLights", Range(0,1))                                          = 0.0
        _envOnRimColorize("--Colorize rim lights", Range(0,1))                              = 1
        _rimLightLightsourceType("_rimLightLightsourceType", Range(0,1)) = 0
        [ToggleUI] _rimLightSetPresetCubemap("_rimLightSetPresetCubemap",Int) = 0

        // [Header(Rimlights)]
        [ToggleUI] _useRimLightSystem("RimLight blend",Int) = 0
        [ToggleUI] _rimLightUseNPRReduction("_rimLightUseNPRReduction",Int) = 0
        _rimLightIntensity("_rimLightIntensity",Range(0.31830988618,2)) = 0.31830988618
        _rimAlbedoMix("Mix Albedo",Range(0,1)) = 0
        [Enum(Diffuse Tex,0,Specular Tex,1)] _RimLightSource("--Source albedo",Int) = 0
        _RimLightColor("Color: RimLight",Color) = (1,1,1,1)
        _Ap_RimLightColor("Color: Ap RimLight",Color) = (0.5,0.5,0.5,1)
        // rim old
        _RimLight_Power("Power: RimLight",Range(0, 1)) = 0.5
        _RimLight_InsideMask("Mask: Inside rimLight",Range(0.00001, 1)) = 0.00001
        _RimLightAreaOffset("--Offset: RimLight",Range(-1, 1)) = 0
        [ToggleUI] _LightDirection_MaskOn("Use light direction",Int) = 0
        _Tweak_LightDirection_MaskLevel("--Mask: Light direction",Range(0, 1)) = 0
        _Ap_RimLight_Power("Power: Ap RimLight",Range(0, 1)) = 1
        // rim new
        [Enum(Modern,1,Legacy,0)] _rimLightVersionMode("_rimLightVersionMode", int) = 1
        _rimLightGain("_rimLightGain",Range(1, 64)) = 4
        _rimLightStep("_rimLightStep",Range(0, .5)) = 0.5
        [ToggleUI] _rimLightDirectionMode("_rimLightDirectionMode", Int) = 0
        _rimLightDirectionGain("_rimLightDirectionGain",Range(1, 64)) = 4
        _rimLightDirectionStep("_rimLightDirectionStep",Range(0, 1)) = .5
        _rimLightGain_AP("_rimLightGain_AP",Range(1, 64)) = 4
        // rim overtone
        [ToggleUI] _useRimLightOverTone("_useRimLightOverTone", Int) = 0
        _rimOverToneStep("_rimOverToneStep", Range(0,1)) = .5
        _rimOverToneFeather("_rimOverToneFeather", Range(0,1)) = 1
        _rimOverTonePow("_rimOverTonePow", Range(0.001,64)) = 1
        [HDR] _rimLightOverToneBlendColor1("_rimLightOverToneBlendColor1", Color) = (1,1,1,1)
        [HDR] _rimLightOverToneBlendColor2("_rimLightOverToneBlendColor2", Color) = (.5,.5,.5)

        // [Header(Matcap)]
        [ToggleUI] _MatCap("Use MatCap", Int ) = 0
        [ToggleUI] _useMCHardMult("_useMCHardMult", Int ) = 0
        _MatCapTexMultBlend("_MatCapTexMultBlend",Range(0,1)) = 1
        [HDR] _MatCapColHardMult ("Multiply color", Color) = (1,1,1,1)
        [NoScaleOffset] _MatCapTexHardMult ("Multiply matcap", 2D) = "white" {}
        [HDR] _MatCapColMult ("Diffuse color", Color) = (1,1,1,1)
        [NoScaleOffset] _MatCapTexMult ("Diffuse matcap", 2D) = "black" {}
        [HDR] _MatCapColAdd ("Specular color", Color) = (1,1,1,1)
        [NoScaleOffset] _MatCapTexAdd ("Specular matcap", 2D) = "black" {}
        [HDR] _MatCapColEmis ("Emissive color", Color) = (0,0,0,1)
        [NoScaleOffset] _MatCapTexEmis ("Emissive matcap", 2D) = "black" {}
        [ToggleUI] _Is_NormalMapForMatCap("Use matcap normalMap ", Int) = 0
        [Normal] _NormalMapForMatCap("--MatCap normalMap", 2D) = "bump" {}
        //// Angel Ring
        [ToggleUI] _AngelRing ("_AngelRing", Int) = 0
        _AngelRing_Sampler ("_AngelRing_Sampler", 2D) = "black" {}
        _AngelRing_Color ("_AngelRing_Color", Color) = (1,1,1,1)
        _AR_OffsetU ("_AR_OffsetU", Range(0, 0.5)) = 0
        _AR_OffsetV ("_AR_OffsetV", Range(0, 1)) = 0.3
        [ToggleUI] _ARSampler_AlphaOn ("_ARSampler_AlphaOn", Int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_AngelRing("_uvSet_AngelRing", int) = 1
        // [Space(9)]
        _Tweak_MatCapUV("Zoom matCap", Range(-0.5, 0.5)) = 0
        _Rotate_MatCapUV("Rotate matCap", Range(-1, 1)) = 0
        _Rotate_NormalMapForMatCapUV("Rotate normalMap matCap", Range(-1, 1)) = 0
        _BumpScaleMatcap("_BumpScaleMatcap", Float) = 1.0
        _TweakMatCapOnShadow("Specular shadow mask", Range(0, 1)) = 0
        _Set_MatcapMask("Diffuse matcap mask (G)", 2D)  = "white" {}
        _Tweak_MatcapMaskLevel("--Tweak mask", Range(-1, 1)) = 0
        _McDiffAlbedoMix("MC diff albedo mix", Range(0,1)) = 0
        [Enum(Self,0,Smoothness,1)] _matcapSmoothnessSource0("_matcapSmoothnessSource0", Int) = 0
        [Enum(Self,0,Smoothness,1)] _matcapSmoothnessSource1("_matcapSmoothnessSource1", Int) = 0
        [Enum(Self,0,Smoothness,1)] _matcapSmoothnessSource2("_matcapSmoothnessSource2", Int) = 0
        [Enum(Self,0,Smoothness,1)] _matcapSmoothnessSource3("_matcapSmoothnessSource3", Int) = 0
        _BlurLevelMatcap0("_BlurLevelMatcap0", Range(0,1)) = 1
        _BlurLevelMatcap1("_BlurLevelMatcap1", Range(0,1)) = 1
        _BlurLevelMatcap2("_BlurLevelMatcap2", Range(0,1)) = 1
        _BlurLevelMatcap3("_BlurLevelMatcap3", Range(0,1)) = 1
        [ToggleUI] _CameraRolling_Stabilizer("_CameraRolling_Stabilizer", Int) = 1
        [Enum(SpecMask,0,MCMask,1)] _matcapSpecMaskSwitch("_matcapSpecMaskSwitch", Int) = 1
        [Enum(EmissionMasks,0,MCMask,1)] _matcapEmissMaskSwitch("_matcapEmissMaskSwitch", Int) = 1
        [ToggleUI] _MatCap2ndLayer("_MatCap2ndLayer", Int ) = 0
        _Set_MatcapMask_2("matcap 2nd layer mask", 2D)  = "white" {}
        [NoScaleOffset] _MatCapTexMult_2 ("Diffuse matcap 2", 2D) = "black" {}
        [NoScaleOffset] _MatCapTexHardMult_2 ("Multiply matcap 2", 2D) = "white" {}
        [NoScaleOffset] _MatCapTexAdd_2 ("Specular matcap 2", 2D) = "black" {}
        [NoScaleOffset] _MatCapTexEmis_2 ("Emissive matcap 2", 2D) = "black" {}

        // [Header(Subsurface)]
        [ToggleUI] _useSSS("_useSSS", Int) = 0
        _SSSThicknessMask("_SSSThicknessMask", 2D) = "white" {}
        _SSSColThin("_SSSColThin", Color) = (1,1,1)
        _SSSColThick("_SSSColThick", Color) = (1,1,1)
        _SSSDepthColL("_SSSDepthColL", Range(0,1)) = 0
        _SSSDepthColH("_SSSDepthColH", Range(0,1)) = 1
        ////
        [ToggleUI] _useFakeSSS("_useFakeSSS", Int) = 0
        _SSSDensityFake("_SSSDensityFake", Range(0.0001,32)) = 1
        _SSSLensFake("_SSSLensFake", Range(0.5,1)) = .5
        ////
        _SSSLens("_SSSLens", Range(0,1)) = 0
        ////
        // [ToggleUI] _useRealSSS("_useRealSSS", Int) = 0
        // _depthMaxScale("_depthMaxScale", Range(0,30)) = 0
        // _SSSDensityReal("_SSSDensityReal", Range(1,256)) = 8
        // _SSSRim("_SSSRim",Range(0.0001,16)) = 0.0001
        ////
        // _SSSColRim("_SSSColRim", Color) = (0,0,0)
        // _SSSRimMaskL("_SSSRimL", Range(0,1)) = 0
        // _SSSRimMaskH("_SSSRimH", Range(0,1)) = 1
        
        // [Header(Emission)]
        _driverTintTex("_driverTintTex", 2D) = "white" {}
        [Enum(UTS2,0,Standard,1)] _emissionUseStandardVars("_emissionUseStandardVars", Int ) = 0
        _EmissionMap("_EmissionMap(RGBA)", 2D) = "white" {}
        [HDR] _EmissionColor("_EmissionColor", Color) = (0,0,0,1)
        [ToggleUI] _emissionUseMask("_emissionUseMask", Int ) = 0
        _Emissive_Tex("Emissive mask (G)", 2D) = "white" {}
        [Enum(MainTex,0,Core,1,Backward,2)] _emisLightSourceType("_emisLightSourceType", Int) = 0
        _emissionMixTintDiffuseSlider("_emissionMixTintDiffuseSlider", Range(0,1)) = 0
        [HDR] _Emissive_Color("Emissive color", Color) = (0,0,0,1)
        _EmissionColorTex("Emissive color (RGB)", 2D) = "white" {}
        [ToggleUI] _emissionUse2ndTintRim("_emissionUse2ndTintRim", Int) = 0
        [HDR] _Emissive_Color2("Emissive color2", Color) = (0,0,0,1)
        _EmissionColorTex2("Emissive color 2 (RGB)", 2D) = "white" {}
        _emission2ndTintLow ("_emission2ndTintLow", Range(0, 1)) = 0.5
        _emission2ndTintHigh ("_emission2ndTintHigh", Range(0, 1)) = 1
        _emission2ndTintPow ("_emission2ndTintPow", Range(0.0001, 256.0)) = 1
        [ToggleUI] _emissiveUseMainTexA("Emissive Use MainTex A",Int) = 0
        // [ToggleUI] _emissiveUseMainTexCol("Emissive Use MainTex Color",Int) = 0
        _emissionUseMaskDiffuseDimming("_emissionUseMaskDiffuseDimming", Range(0,1)) = 0
        _emissionProportionalLum ("_emissionProportionalLum", Range(0, 2)) = 0
        [ToggleUI] _useEmissionHSVI("_useEmissionHSVI", Int) = 0
        _emissionHSVIMask("_emissionHSVIMask",2D) = "white" {}
        _emissionHSVIController1("_emissionHSVIController1", Float) = (0,0,0,1)

        // [Header(Lighting Behaviour)]
        [Enum(Per Eye,0,Between Eyes,1)] _eyeStereoViewDirMode("_eyeStereoViewDirMode",Int) = 0
        [ToggleUI] _useDistanceDarken("_useDistanceDarken",Int) = 0
        _directLightIntensity("Direct light intensity",Range(0,1)) = 1
        _indirectAlbedoMaxAveScale("Indirect albedo maxAve Scale",Range(0.5,2)) = 1.5
        _indirectGIDirectionalMix("Indirect GI dir mix",Range(0,1)) = 0
        [ToggleUI] _indirectGIDirectionalUseNPR("_indirectGIDirectionalUseNPR",Int) = 0
        _indirectGIBlur("Indirect GI blur",Range(.5,4)) = 1
        [Enum(HDR,0,Limit,1)] _forceLightClamp("Force scene Lights Clamp",Int) = 1
        [Enum(Real ADD,0,Safe MAX,4)] _BlendOp("Additional lights blending", Int) = 0
        _shadowCastMin_black("Dynamic Shadow Removal",Range(0.0,1.0)) = 0.65
        [NoScaleOffset] _DynamicShadowMask("Dynamic Shadow mask",2D)         = "black" {}
        [ToggleUI] _shadowUseCustomRampNDL("_shadowUseCustomRampNDL",Int) = 0
        _shadowNDLStep("_shadowNDLStep",Range(0,1)) = 1
        _shadowNDLFeather("_shadowNDLFeather",Range(0,1)) = 0.5
        _shadowMaskPinch("_shadowMaskPinch",Range(0,.9)) = 0
        [IntRange] _shadowSplits("_shadowMaskPinch",Range(0,10)) = 0
        _shadeShadowOffset1("_shadeShadowOffset1",Range(0,1)) = 0
        _shadeShadowOffset2("_shadeShadowOffset2",Range(0,1)) = 0

        // [Header(Light Map Shift Masks)]
        [ToggleUI] _useShadePosition("_useShadePosition",Int) = 0
        [NoScaleOffset] _Set_1st_ShadePosition("Forward Toon Shadows (G)", 2D) = "white" {}
        [NoScaleOffset] _Set_2nd_ShadePosition("Backward Toon Shadow (G)", 2D) = "white" {}
        _Set_1st_ShadePositionStrength("_Set_1st_ShadePositionStrength",range(0,4)) = 1
        _Set_2nd_ShadePositionStrength("_Set_2nd_ShadePositionStrength",range(0,4)) = 1
        [Enum(Off,0,On,1,Use Vertex Color Red,2)] _UseLightMap("Light Map mode", Int) = 0
        _lightMapBlur("_lightMapBlur",range(0,1)) = 0
        _LightMap("Light map mask (G)", 2D) = "linearGrey" {}
        _lightMapRemapL("_lightMapRemapL",range(-.1,.5)) = 0
        _lightMapRemapH("_lightMapRemapH",range(.5,1.1)) = 1
        _lightMapGain("_lightMapGain",range(0.125,8)) = 1
        [Enum(Bias,0,Darken,1)] _lightMapBlendMode("_lightMapBlendMode", Int) = 0
        [Enum(Symmetric,0,Asymmetric,1)] _lightMapSymmetry("_lightMapSymmetry", Int) = 0
        _lightMapStrengthShadeRamp1("_lightMapStrengthShadeRamp1",range(0,.5)) = 0.5
        _lightMapStrengthShadeRamp2("_lightMapStrengthShadeRamp2",range(0,.5)) = 0.5
        [Enum(Bias,0,Darken,1)] _lightMapBlendModeCrossOverRim("_lightMapBlendModeCrossOverRim", Int) = 1
        _lightMapStrengthShadeRampCrossOverRim("_lightMapStrengthShadeRampCrossOverRim",range(0,.5)) = 0
        
        // [Header(Ambient Occlusion Maps)]
        _Set_HighColorMask("Specular Mask (G)", 2D)                     = "white" {}
        [ToggleUI] _invertHighColorMask("_invertHighColorMask",Int) = 0
        _Tweak_HighColorMaskLevel("--Tweak Mask", Range(-1, 1))         = 0
        _Set_RimLightMask("RimLight Mask (G)", 2D)                      = "white" {}
        [ToggleUI] _invertRimLightMask("_invertRimLightMask",Int) = 0
        _Tweak_RimLightMaskLevel("--Tweak Mask", Range(-1, 1))          = 0

        // [Header(Normal map)]
        [Normal] _NormalMap("NormalMap", 2D)                                 = "bump" {}
        _DetailNormalMapScale01("--Detail scale", Range(0,1))       = 0
        [Normal] _NormalMapDetail("----Detail Normal map", 2d)               = "bump" {}
        _DetailNormalMask("----Detail Mask (G)", 2d)                = "white" {}
        [ToggleUI] _Is_NormalMapToBase ("On Toon",Int)             = 1
        [ToggleUI] _Is_NormalMapToHighColor("On High Color",Int)   = 1
        [ToggleUI] _Is_NormalMapToRimLight("On Rims",Int)          = 1
        [ToggleUI] _Is_NormaMapToEnv("On Reflection",Int)          = 1
        _BumpScale("_BumpScale", Float) = 1.0
        _DetailNormalMapScale("_DetailNormalMapScale", Float) = 1.0
        // detail masks
        _DetailMap("_DetailMap",2D) = "grey" {}
        _DetailMask("_DetailMask",2D) = "white" {}
        _DetailAlbedo("_DetailAlbedo", Range(0, 1)) = 0
        _DetailSmoothness("_DetailSmoothness", Range(0, 1)) = 0
        // Thin Film Iridescence
        [ToggleUI] _useThinFilmIridescence("_useThinFilmIridescence", Int) = 0
        _IridescenceMask("_IridescenceMask", 2D) = "white" {}
        _Dinc("_Dinc", Range(0.001,10)) = 1
        _eta2("_eta2", Range(1.001,5)) = 1.2
        _eta3("_eta3", Range(1.001,5)) = 2.0
        _kappa3("_kappa3", Range(0.00,5)) = 1
        [ToggleUI] _rimLightUseTFICol("_rimLightUseTFICol", Int) = 0
        //// decal 1
        [ToggleUI] _useDecal1("_useDecal1",Int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_decal1("_uvSet_decal1",int) = 0
        _decal1("_decal1",2D) = "black" {}
        _decal1_color("_decal1_color", Color) = (1,1,1,1)
        [Enum(replace,0,add,1,mult,2,detail,3)] _decal1_blendMode("_decal1_blendMode",Int) = 2
        _decal1_transform("_decal1_transform",Vector) = (0,0,0,0)
        _decal1_pivotR("_decal1_pivotR",Float) = (0.5,0.5,-1,-1)
        _decal1_rotate("_decal1_rotate",Float) = 0
        _decal1_pivotS("_decal1_pivotS",Float) = (0.5,0.5,-1,-1)
        _decal1_scale("_decal1_scale",Float) = 1
        _decal1_ratioWH("_decal1_ratioWH",Float) = (1,1,-1,-1)
        _decal1_cutoff("_decal1_cutoff",Range(0,1)) = 0
        _decal1_boarder("_decal1_boarder",Vector) = (0,0,1,1)
        _decal1_blendAmount("_decal1_blendAmount",Range(0,2)) = 1
        [ToggleUI] _decal1_usePremultiplyAlpha("_decal2_usePremultiplyAlpha",Int) = 0
        //// decal 2
        [ToggleUI] _useDecal2("_useDecal2",Int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_decal2("_uvSet_decal2",int) = 0
        _decal2("_decal2",2D) = "black" {}
        _decal2_color("_decal2_color", Color) = (1,1,1,1)
        [Enum(replace,0,add,1,mult,2,detail,3)] _decal2_blendMode("_decal2_blendMode",Int) = 2
        _decal2_transform("_decal2_transform",Vector) = (0,0,0,0)
        _decal2_pivotR("_decal2_pivotR",Float) = (0.5,0.5,-1,-1)
        _decal2_rotate("_decal2_rotate",Float) = 0
        _decal2_pivotS("_decal2_pivotS",Float) = (0.5,0.5,-1,-1)
        _decal2_scale("_decal2_scale",Float) = 1
        _decal2_ratioWH("_decal2_ratioWH",Float) = (1,1,-1,-1)
        _decal2_cutoff("_decal2_cutoff",Range(0,1)) = 0
        _decal2_boarder("_decal2_boarder",Vector) = (0,0,1,1)
        _decal2_blendAmount("_decal2_blendAmount",Range(0,2)) = 1
        [ToggleUI] _decal2_usePremultiplyAlpha("_decal2_usePremultiplyAlpha",Int) = 0
        //// decal emission
        [ToggleUI] _useDecalEmission1("_useDecalEmission1",Int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_DecalEmission1("_uvSet_DecalEmission1",int) = 0
        _DecalEmission1("_DecalEmission1",2D) = "black" {}
        [HDR] _DecalEmission1_color("_DecalEmission1_color", Color) = (1,1,1,1)
        [Enum(replace,0,add,1,mult,2,detail,3)] _DecalEmission1_blendMode("_DecalEmission1_blendMode",Int) = 2
        _DecalEmission1_transform("_DecalEmission1_transform",Vector) = (0,0,0,0)
        _DecalEmission1_pivotR("_DecalEmission1_pivotR",Float) = (0.5,0.5,-1,-1)
        _DecalEmission1_rotate("_DecalEmission1_rotate",Float) = 0
        _DecalEmission1_pivotS("_DecalEmission1_pivotS",Float) = (0.5,0.5,-1,-1)
        _DecalEmission1_scale("_DecalEmission1_scale",Float) = 1
        _DecalEmission1_ratioWH("_DecalEmission1_ratioWH",Float) = (1,1,-1,-1)
        _DecalEmission1_cutoff("_DecalEmission1_cutoff",Range(0,1)) = 0
        _DecalEmission1_boarder("_DecalEmission1_boarder",Vector) = (0,0,1,1)
        _DecalEmission1_blendAmount("_DecalEmission1_blendAmount",Range(0,2)) = 1
        [ToggleUI] _DecalEmission1_usePremultiplyAlpha("_DecalEmission1_usePremultiplyAlpha",Int) = 0
        // uv sets
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_ShadePosition("_uvSet_ShadePosition", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_LightMap("_uvSet_LightMap", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_NormalMapDetail("_uvSet_NormalMapDetail", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_NormalMapForMatCap("_uvSet_NormalMapForMatCap", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_DetailMap("_uvSet_DetailMap", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_driverTintTex("_uvSet_driverTintTex", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_EmissionColorTex("_uvSet_EmissionColorTex", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_emissionMask("_uvSet_emissionMask", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_albedo("_uvSet_albedo", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_albedo1("_uvSet_albedo1", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_albedo2("_uvSet_albedo2", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_specular("_uvSet_specular", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_normalmap("_uvSet_normalmap", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_detailNormalMask("_uvSet_detailNormalMask", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_highColorMask("_uvSet_highColorMask", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_rimLightMask("_uvSet_rimLightMask", int) = 0
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_matcapMask("_uvSet_matcapMask", int) = 0
        // [Header(Alpha mask)]
        [Enum(Off,0,On,1)] _ZWrite("Z Write Depth sorting (Recommend off)",Int)     = 1
        [Enum(Off,0,On,1)] _useAlphaDepthWrite("_useAlphaDepthWrite",Int) = 0
        [Enum(Clipping Mask,0,Main Texture,1)] _IsBaseMapAlphaAsClippingMask("Alpha mask source",Int)   = 1
        _ClippingMask("--Clipping mask (G)",2D)                                     = "white" {}
        [ToggleUI] _Inverse_Clipping("Inverse clipping",Int)                       = 0
        _Clipping_Level("Clipping level",Range(0, 1))                               = 0.5
        _Tweak_transparency("--Tweak transparency",Range(-1, 1))                    = 0
        [Enum(alpha,0,reflect,1)] _UseSpecAlpha("Specular Alpha opacity",Int)       = 0
        [ToggleUI] _DetachShadowClipping("Separate Shadow Clipping Level",Int)     = 0
        _Clipping_Level_Shadow("--Shadow Clip",Range(0, 1))                         = 1
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)] _uvSet_clippingMask("_uvSet_clippingMask", int) = 0
        // [Space(198)]
        // [Space(18)]
        // [Header(Stencil Helpers. Requires Queue Order Edits)]
        _Stencil("Stencil ID [0;255]", Range(0,255))                                        = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp("--Comparison", Int)     = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilOp("--Pass", Int)                   = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilFail("--Fail", Int)                 = 0
        ////
        //// Animated
        //// [ToggleUI] _useRimLightOverTone("_useRimLightOverTone", Int) = 0
        //// Diffuse
        [ToggleUI]_ColorAnimated("_ColorAnimated", Int) = 0
        [ToggleUI]_controllerAlbedoHSVI_1Animated("_controllerAlbedoHSVI_1", Int) = 0
        [ToggleUI]_controllerAlbedoHSVI_2Animated("_controllerAlbedoHSVI_2", Int) = 0
        [ToggleUI]_controllerAlbedoHSVI_3Animated("_controllerAlbedoHSVI_3", Int) = 0
        //// Specular
        [ToggleUI]_SpecColorAnimated("_SpecColor", Int) = 0
        [ToggleUI]_GlossinessAnimated("Smoothness", Int) = 0
        [ToggleUI]_SpecularMaskHSVAnimated("_SpecularMaskHSV", Int) = 0
        //// Cubemap
        [ToggleUI]_CubemapFallbackModeAnimated("_CubemapFallbackMode", Int) = 0
        //// Emission
        [ToggleUI]_emissionHSVIController1Animated("_emissionHSVIController1", Int) = 0
        //// Decals
        [ToggleUI]_decal1_blendAmountAnimated("_decal1_blendAmountAnimated", Int) = 0
        [ToggleUI]_decal2_blendAmountAnimated("_decal2_blendAmountAnimated", Int) = 0
        //// Decals Emission
        [ToggleUI]_DecalEmission1_blendAmountAnimated("_DecalEmission1_blendAmountAnimated", Int) = 0
        //// General Lighting
        [ToggleUI]_shadowCastMin_blackAnimated("_shadowCastMin_black", Int) = 0
        [ToggleUI]_directLightIntensityAnimated("_directLightIntensityAnimated", Int) = 0
        [ToggleUI]_indirectAlbedoMaxAveScaleAnimated("_indirectAlbedoMaxAveScale", Int) = 0
        [ToggleUI]_useDistanceDarkenAnimated("_useDistanceDarkenAnimated", Int) = 0
        [ToggleUI]_forceLightClampAnimated("_forceLightClampAnimated", Int) = 0
        //// alpha
        [ToggleUI]_Tweak_transparencyAnimated("_Tweak_transparencyAnimated", Int) = 0
        //// Inventory 
        [ToggleUI]_UseInventory("Use Inventory", Float) = 0.0
		_InventoryStride("Inventory Stride", Int) = 1
		[ToggleUI]_InventoryItem01Animated("Toggle Item 1", Float) = 1.0
		[ToggleUI]_InventoryItem02Animated("Toggle Item 2", Float) = 1.0
		[ToggleUI]_InventoryItem03Animated("Toggle Item 3", Float) = 1.0
		[ToggleUI]_InventoryItem04Animated("Toggle Item 4", Float) = 1.0
		[ToggleUI]_InventoryItem05Animated("Toggle Item 5", Float) = 1.0
		[ToggleUI]_InventoryItem06Animated("Toggle Item 6", Float) = 1.0
		[ToggleUI]_InventoryItem07Animated("Toggle Item 7", Float) = 1.0
		[ToggleUI]_InventoryItem08Animated("Toggle Item 8", Float) = 1.0
		[ToggleUI]_InventoryItem09Animated("Toggle Item 9", Float) = 1.0
		[ToggleUI]_InventoryItem10Animated("Toggle Item 10", Float) = 1.0
		[ToggleUI]_InventoryItem11Animated("Toggle Item 11", Float) = 1.0
		[ToggleUI]_InventoryItem12Animated("Toggle Item 12", Float) = 1.0
		[ToggleUI]_InventoryItem13Animated("Toggle Item 13", Float) = 1.0
		[ToggleUI]_InventoryItem14Animated("Toggle Item 14", Float) = 1.0
		[ToggleUI]_InventoryItem15Animated("Toggle Item 15", Float) = 1.0
		[ToggleUI]_InventoryItem16Animated("Toggle Item 16", Float) = 1.0
    }





    SubShader {
        Tags {
            "Queue"="AlphaTest+51"
            // "Queue"="AlphaTest+50"
            "IgnoreProjector"="True" 
            "RenderType"="Opaque" 
        }


        //// get current screen
        GrabPass {              
            "_ScreenGrabACL"       
            Tags { "LightMode" = "Always" }
        }

        // Pass {  //// depth backface pass
        //     Name "DEPTH_BACKFACE"
        //     Tags {
        //         "LightMode"="ForwardBase"
        //     }
        //     Stencil
        //     {
        //         Ref 421
        //         Comp Equal
        //     }
        //     Cull Front
        //     ZWrite On
        //     ZTest GEqual //// ???

        //     CGPROGRAM
        //     #pragma target 5.0
        //     #pragma vertex depthVert
        //     #pragma fragment depthFrag
        //     #pragma multi_compile_fwdbase
        //     #pragma multi_compile_instancing
        //     #pragma multi_compile_fog
        //     #pragma multi_compile UNITY_PASS_FORWARDBASE
        //     #include "ACLS_VERT_FRAG.cginc"
        //     ENDCG
        // }

        // GrabPass{"_BackDepthTexture"}        
            
        //// Horizontal blur
        //// citation in HELPERS file

        // Pass {
        //     Tags { "LightMode" = "Always" }
        //     ZWrite Off
        //     CGPROGRAM
        //     #pragma target 5.0
        //     #pragma vertex vert
        //     #pragma fragment frag
        //     #pragma fragmentoption ARB_precision_hint_fastest
        //     #pragma multi_compile _ SOFTPARTICLES_ON
        //     #include "UnityCG.cginc"
            
        //     struct appDataGrabPassH {
        //         float4 vertex : POSITION;
        //         float3 normal : NORMAL;
        //         float4 tangent : TANGENT;
        //         // float2 texcoord: TEXCOORD0;
        //         float2 uv0      : TEXCOORD0;
        //         float2 uv1      : TEXCOORD1;
        //         float2 uv2      : TEXCOORD2;
        //         float2 uv3      : TEXCOORD3;
        //         UNITY_VERTEX_INPUT_INSTANCE_ID
        //     };
            
        //     struct v2fGrabPassH {
        //         float4 pos : SV_POSITION;
        //         float4 uvgrab : TEXCOORD0;
        //         float4 screenPos : TEXCOORD1;
        //         float eyeDepth : TEXCOORD2;
        //         float3 wNormal : TEXCOORD3;
        //         float3 worldPos : TEXCOORD4;
        //         float4 uv01 : TEXCOORD5;
        //         float4 uv02 : TEXCOORD6;
        //         UNITY_VERTEX_INPUT_INSTANCE_ID
        //         UNITY_VERTEX_OUTPUT_STEREO
        //     };
            
        //     // sampler2D _GrabTexture;
        //     TEXTURE2D_X(_ScreenGrabACL); float4 _ScreenGrabACL_TexelSize; float4 _ScreenGrabACL_HDR;
        //     SAMPLER(sampler_ScreenGrabACL);
        //     // UNITY_DECLARE_SCREENSPACE_TEXTURE(_ScreenGrabACL); float4 _ScreenGrabACL_TexelSize;
        //     // UNITY_DECLARE_SCREENSPACE_TEXTURE(_BackDepthTexture); float4 _BackDepthTexture_TexelSize;
        //     // UNITY_DECLARE_SCREENSPACE_TEXTURE(_ScreenDistortion); float4 _ScreenDistortion_TexelSize;
        //     // UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture); float4 _CameraDepthTexture_TexelSize;
        //     int _useBlurDepth;
        //     int _useDepthEffects;
        //     float _blurWidth;
        //     float _depthPow;
        //     float _depthFactor;
        //     float _sigma;
        //     float _IOR;
        //     float _IORStrength;
        //     int _uvSet_grabPassMask;
        //     Texture2D _grabPassMask; float4 _grabPassMask_ST;
        //     float _DistortionBumpMapScale;
        //     fixed4 _Color;

        //     uniform Texture2D _MainTex; uniform float4 _MainTex_ST;
        //     uniform Texture2D _ClippingMask; uniform float4 _ClippingMask_ST;
        //     uniform sampler2D _Outline_Sampler; uniform float4 _Outline_Sampler_ST;
        //     SamplerState sampler_MainTex;
        //     SamplerState sampler_ClippingMask;
        //     uniform int _uvSet_albedo;
        //     uniform int _uvSet_clippingMask;
        //     uniform int _DetachShadowClipping;
        //     uniform half _Tweak_transparency;
        //     uniform half _Clipping_Level;
        //     uniform half _Clipping_Level_Shadow;
        //     uniform int _Inverse_Clipping;
        //     uniform int _IsBaseMapAlphaAsClippingMask;
        //     uniform int _grabPassOverBrightnessClamp;

        //     v2fGrabPassH vert (appDataGrabPassH v) {
        //         UNITY_SETUP_INSTANCE_ID(v);
        //         v2fGrabPassH o;
        //         UNITY_INITIALIZE_OUTPUT(v2fGrabPassH, o);
        //         UNITY_TRANSFER_INSTANCE_ID(v, o);
        //         UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
        //         o.uv01 = float4(v.uv0.xy, v.uv1.xy);
        //         o.uv02 = float4(v.uv2.xy, v.uv3.xy);
        //         o.worldPos = mul( unity_ObjectToWorld, v.vertex).xyz;
        //         o.wNormal = UnityObjectToWorldNormal(v.normal);
        //         o.pos = UnityObjectToClipPos(v.vertex);
        //         o.screenPos = ComputeGrabScreenPos(o.pos);
        //         COMPUTE_EYEDEPTH(o.eyeDepth);
        //         return o;
        //     }
            
        //     half4 frag( v2fGrabPassH i ) : COLOR {
        //         UNITY_SETUP_INSTANCE_ID(i);
        //         // float aspect = _ScreenGrabACL_TexelSize.x * _ScreenGrabACL_TexelSize.w; // h / w
        //         float3 worldviewPos = _WorldSpaceCameraPos;
        //         float3 posDiff      = worldviewPos - i.worldPos.xyz;
        //         float3 dirView;
        //         UNITY_BRANCH if (unity_OrthoParams.w)//// mirror camera (ERROR.MDL)
        //         {
        //             dirView = UNITY_MATRIX_V[2].xyz;
        //         }
        //         else
        //         {
        //             dirView = normalize(posDiff);
        //         }
        //         i.wNormal           = normalize(i.wNormal);


        //         //// alpha
        //     #ifndef NotAlpha
        //         UV_DD uv_toon           = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_albedo), _MainTex));
        //         float4 mainTex          = _MainTex.SampleGrad(sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy);
        //         float4 clippingMaskTex  = _ClippingMask.Sample(sampler_ClippingMask, TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_clippingMask), _ClippingMask));
        //         float useMainTexAlpha   = (_IsBaseMapAlphaAsClippingMask) ? mainTex.a : clippingMaskTex.r;
        //         float alpha             = (_Inverse_Clipping) ? (1.0 - useMainTexAlpha) : useMainTexAlpha;
        //         float clipTest          = (_DetachShadowClipping) ? _Clipping_Level_Shadow : _Clipping_Level;
        //         clip(alpha - clipTest);
        //         clipTest                = saturate(alpha + _Tweak_transparency);
        //         clip(clipTest);
        //     #endif //// NotAlpha
        //         UV_DD uv_grabPassMask = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_grabPassMask), _grabPassMask));
        //         float4 grabPassMask     = _grabPassMask.SampleGrad( sampler_MainTex, uv_grabPassMask.uv, uv_grabPassMask.dx, uv_grabPassMask.dy); // r:mix, b:distortion, a:blur
        //         //// screen uv
        //         float4 uvOriginal = i.screenPos;
        //         //// depth
        //         bool isMirror   = IsInMirror();
        //         float depthVolume = 1;
        //         float haveDepth = 0;
        //         float surfaceDepth = i.eyeDepth;
        //     #ifdef SOFTPARTICLES_ON // linked with depth texture
        //         haveDepth = 1;
        //     #endif // SOFTPARTICLES_ON
                
        //         UNITY_BRANCH if ((_useBlurDepth)) //// logic check as depth effects cannot combine with distortion effects
        //         {
        //             UNITY_BRANCH if (_useDepthEffects * haveDepth * !(isMirror)) //// control situation we are alphaTest Queue and material hits its own depth, from being lower than transparency queue
        //             {
        //                 float backgroundDepth = LinearEyeDepth(SampleSceneDepth((i.screenPos.xy / i.screenPos.w)).r);
        //                 // float backgroundDepth = LinearEyeDepth(UNITY_SAMPLE_SCREENSPACE_TEXTURE(_CameraDepthTexture, (i.screenPos.xy / i.screenPos.w)).r);
        //                 // float backFaceDepth = (tex2D(_BackDepthTexture, (i.screenPos.xy/i.screenPos.w)).a);
        //                 // backgroundDepth = min(backgroundDepth, backFaceDepth);
        //                 float depthRaw = backgroundDepth - surfaceDepth;
        //                 depthVolume = saturate(depthRaw);
        //                 depthVolume = saturate(((pow(depthVolume, _depthPow))) * _depthFactor);      
        //                 // return float4(depthVolume,0,0,1);
        //                 // debugVal = float4(surfaceDepth, backgroundDepth, depthRaw, 1);
        //             }
                    
        //         }
        //         depthVolume = depthVolume * min(1, surfaceDepth);
        //         float4 colSum = 0;
        //         float weightSum = 0;
        //         // float blurOffsetSource = depthVolume * _blurWidth * grabPassMask.a * abs(UNITY_MATRIX_P._m11*.5) * 1;
        //         float blurOffsetSource = depthVolume * _blurWidth * grabPassMask.a * abs(UNITY_MATRIX_P._m11*.5) * BLUR_SAMPLE_SPLITS;
        //         UNITY_BRANCH if (blurOffsetSource)
        //         {
        //             // [loop] for (float idy = 0; idy < BLUR_SAMPLES; idy++)
        //             // {
        //                 [loop] for (float idx = 0; idx < BLUR_SAMPLES; idx++)
        //                 {
        //                 // [loop] for (float sampleI = 0; sampleI < 24; sampleI++)
        //                 // {
        //                 //     float timeMod = fmod(_Time.y,10);
        //                 //     float2 randXY = rand22(float2(i.screenPos.x + sampleI * 2, i.screenPos.y + sampleI));
        //                 //     // float2 randXY = hashwithoutsine22(float2(i.screenPos.x + sampleI * 2, i.screenPos.y + sampleI));
        //                 //     // float2 randXY = rand22(float2(i.screenPos.x + sampleI, i.screenPos.y + timeMod));
        //                 //     float sampleIndexX = randXY.x * 2 - 1;
        //                 //     float sampleIndexY = randXY.y * 2 - 1;
        //                 //     float blurOffsetX = blurOffsetSource * sampleIndexX;
        //                 //     float blurOffsetY = blurOffsetSource * sampleIndexY;
                            
        //                     float blurOffsetX = blurOffsetSource * (idx - BLUR_SAMPLE_RADIUS);
        //                     blurOffsetX *= _ScreenGrabACL_TexelSize.x * _ScreenGrabACL_TexelSize.w; // h / w
        //                     float4 scnPos = float4( float2(i.screenPos.x + blurOffsetX, i.screenPos.y), i.screenPos.z, i.screenPos.w);
        //                     // scnPos.xy /= scnPos.w;
        //                     // scnPos.xy = floor(scnPos.xy * _ScreenGrabACL_TexelSize.zw * 2) / (_ScreenGrabACL_TexelSize.zw * 2) + _ScreenGrabACL_TexelSize.xy * .5;
        //                     // scnPos.xy *= scnPos.w;
        //                     float badDepthScale = 1;
        //                     UNITY_BRANCH if (_useDepthEffects * haveDepth * !(isMirror)) //// control situation we are alphaTest Queue and material can hit its own depth being lower than transparency queue
        //                     {
        //                         float tempBackgroundDepth = LinearEyeDepth(SampleSceneDepth((i.screenPos.xy / i.screenPos.w)).r);
        //                         // float tempBackgroundDepth = LinearEyeDepth(UNITY_SAMPLE_SCREENSPACE_TEXTURE(_CameraDepthTexture, (i.screenPos.xy / i.screenPos.w)).r);
        //                         float tempDepthVolume = (tempBackgroundDepth - surfaceDepth);
        //                         if (tempDepthVolume < 0) // object in front, cannot logically sample
        //                         {
        //                             badDepthScale = 0.001;
        //                         }
        //                     }
        //                     // float weight = blurKernel_13[idx] * badDepthScale; // expensive
        //                     float weight = Gaussian(_sigma * BLUR_SIGMA, (idx - BLUR_SAMPLE_RADIUS)) * badDepthScale; // expensive
        //                     // float weight = blurKernel_11x11[idx % 11 + idy * 11] * badDepthScale; // pre-computed 2d matrix, 5 radius, 11 diameter
        //                     // float weight = blurKernel_9x9[idx % 9 + idy * 9] * badDepthScale; // pre-computed 2d matrix, 4 radius, 9 diameter
        //                     weightSum += weight;
        //                     colSum += SAMPLE_TEXTURE2D_X_LOD(_ScreenGrabACL, sampler_ScreenGrabACL, scnPos.xy / scnPos.w, 0) * weight;
        //                     // colSum += UNITY_SAMPLE_SCREENSPACE_TEXTURE(_ScreenGrabACL, scnPos.xy / scnPos.w) * weight;
        //                 }
        //             // }                   
        //             colSum /= (weightSum+0.0001);
        //             // float getSkyboxBrightness = LinearRgbToLuminance_ac( DecodeHDR(colSum, _HBlurACL_HDR));
        //             // float getSkyboxBrightness = LinearRgbToLuminance_ac( colSum.rgb);
        //             // if (_grabPassOverBrightnessClamp && (getSkyboxBrightness > 1.0) ) { colSum /= getSkyboxBrightness; }//// alphaTest queue Skybox overbright protection

        //         }
        //         else
        //         {
        //             float4 scnPos = float4( float2(i.screenPos.x, i.screenPos.y), i.screenPos.z, i.screenPos.w);
        //             colSum = SAMPLE_TEXTURE2D_X_LOD(_ScreenGrabACL, sampler_ScreenGrabACL, scnPos.xy/scnPos.w, 0);
        //             // colSum = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_ScreenGrabACL, scnPos.xy/scnPos.w);
        //         }
        //         return colSum;
        //     }
        //     ENDCG
        // }
 


        // // grab horizonal blur
        // GrabPass {                 
        //     // "_HBlurACL"                 
        //     Tags { "LightMode" = "Always" }
        // }



        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One Zero
            Cull[_CullMode]
            ZWrite [_ZWrite]

            Stencil
            {
                Ref [_Stencil]
                Comp [_StencilComp]
                Pass [_StencilOp]
                Fail [_StencilFail]
            }

            CGPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            // #pragma geometry geom
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_instancing
            #pragma multi_compile_fog
            #pragma multi_compile _ SOFTPARTICLES_ON
            #pragma multi_compile UNITY_PASS_FORWARDBASE
            // #pragma multi_compile _ UNITY_HDR_ON
            #include "ACLS_CORE.cginc"
            ENDCG
        }



        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            BlendOp[_BlendOp]
            Cull[_CullMode]
            ZWrite off

            Stencil
            {
                Ref [_Stencil]
                Comp [_StencilComp]
                Pass [_StencilOp]
                Fail [_StencilFail]
            }

            CGPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            // #pragma geometry geom
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_instancing
            #pragma multi_compile_fog
            #pragma multi_compile _ SOFTPARTICLES_ON
            #pragma multi_compile UNITY_PASS_FORWARDADD
            // #pragma multi_compile _ UNITY_HDR_ON
            #include "ACLS_CORE.cginc"
            ENDCG
        }



        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1 ,1
            // Cull Front
            Cull [_CullMode]
            ZWrite On ZTest LEqual
            
            CGPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            #include "ACLS_SHADOWCASTER.cginc"
            ENDCG
        }
    }
    FallBack "Legacy Shaders/VertexLit"
    CustomEditor "ACLSInspector"
}
