using UnityEditor;
using UnityEngine;
// using System.Collections;
// using System.Collections.Generic;
// using System.Linq;
// using System;
using System.Reflection;
using ACiiL;

// Base prepared by Morioh for me.
// This code is based off synqark's arktoon-shaders and Xiexe. 
// Citation to "https://github.com/synqark", "https://github.com/synqark/arktoon-shaders", https://gitlab.com/xMorioh/moriohs-toon-shader.
public class ACLSInspector : ShaderGUI
{
    BindingFlags bindingFlags = BindingFlags.Public |
                                BindingFlags.NonPublic |
                                BindingFlags.Instance |
                                BindingFlags.Static;



    MaterialProperty _ShaderOptimizerEnabled = null;
    // Cull
    MaterialProperty _CullMode = null;
    MaterialProperty _backFaceColorTint = null;
    // Toon ramp
    MaterialProperty _useToonRampSystem = null;
    MaterialProperty _useDiffuseAlbedoTexturesSet = null;
    MaterialProperty _toonRampTexturesBlendMode = null;
    MaterialProperty _Use_BaseAs1st = null;
    MaterialProperty _1st_ShadeMap = null;
    MaterialProperty _Use_1stAs2nd = null;
    MaterialProperty _2nd_ShadeMap = null;
    MaterialProperty _MainTex = null;
    MaterialProperty _Color = null;
    MaterialProperty _BaseColor = null;
    MaterialProperty _1st_ShadeColor = null;
    MaterialProperty _2nd_ShadeColor = null;
    MaterialProperty _BaseColor_Step = null;
    MaterialProperty _BaseShade_Feather = null;
    MaterialProperty _ShadeColor_Step = null;
    MaterialProperty _1st2nd_Shades_Feather = null;
    MaterialProperty _DiffToonShadePriority = null;
    MaterialProperty _ToonRampFeather_n1_OffsetMode = null;
    MaterialProperty _ToonRampFeather_n2_OffsetMode = null;
    MaterialProperty _ToonRampLightSourceType_Core = null;
    MaterialProperty _diffuseIndirectDirectSimCoreMix = null;
    MaterialProperty _ToonRampLightSourceType_Backwards = null;
    MaterialProperty _diffuseIndirectDirectSimMix = null;
    MaterialProperty _Diff_GSF_01 = null;
    MaterialProperty _DiffGSF_Offset = null;
    MaterialProperty _DiffGSF_Feather = null;
    MaterialProperty _useCrossOverRim = null;
    MaterialProperty _crossOverUseToonShades = null;
    MaterialProperty _crossOverMask = null;
    MaterialProperty _crossOverAlbedo = null;
    MaterialProperty _crossOverPinch = null;
    MaterialProperty _crossOverStep = null;
    MaterialProperty _crossOverFeather = null;
    MaterialProperty _crosspOverRimPow = null;
    MaterialProperty _crossOverTint = null;
    MaterialProperty _crossOverSourceTexSource = null;
    // Specular Shine
    MaterialProperty _UseSpecularSystem = null;
    MaterialProperty _WorkflowMode = null;
    MaterialProperty _SpecOverride = null;
    MaterialProperty _UseDiffuseEnergyConservation = null;
    MaterialProperty _SpecColor = null;
    MaterialProperty _Glossiness = null;
    MaterialProperty _Metallicness = null;
    MaterialProperty _HighColor_Tex = null;
    MaterialProperty _MetallicGlossMap = null;
    MaterialProperty _SpecGlossMap = null;
    MaterialProperty _highColTexSource = null;
    MaterialProperty _SpecularMaskHSV = null;
    MaterialProperty _TweakHighColorOnShadow = null;
    //// Iridescence
    MaterialProperty _useThinFilmIridescence = null;
    MaterialProperty _IridescenceMask = null;
    MaterialProperty _Dinc = null;
    MaterialProperty _eta2 = null;
    MaterialProperty _eta3 = null;
    MaterialProperty _kappa3 = null;
    MaterialProperty _rimLightUseTFICol = null;
    //// specular layers
    MaterialProperty _specColorIntensity = null;
    MaterialProperty _specMaskLayersPinch = null;
    MaterialProperty _specMaskLayersOrder = null;
    MaterialProperty _specLayersCount = null;
    MaterialProperty _HighColor = null;
    MaterialProperty _specLayerCol2 = null;
    MaterialProperty _specLayerCol3 = null;
    MaterialProperty _Is_SpecularToHighColor = null;
    MaterialProperty _specType2 = null;
    MaterialProperty _specType3 = null;
    MaterialProperty _specLayerRoughExp1 = null;
    MaterialProperty _specLayerRoughExp2 = null;
    MaterialProperty _specLayerRoughExp3 = null;
    MaterialProperty _spaceLayerFeather1 = null;
    MaterialProperty _spaceLayerFeather2 = null;
    MaterialProperty _spaceLayerFeather3 = null;
    MaterialProperty _spaceLayerOffset1 = null;
    MaterialProperty _spaceLayerOffset2 = null;
    MaterialProperty _spaceLayerOffset3 = null;
    MaterialProperty _specLayerHalfAngleTilt2 = null;
    MaterialProperty _specLayerHalfAngleTilt3 = null;
    MaterialProperty _specLayerHalfAngleRotate2 = null;//// note #1 must not rotate
    MaterialProperty _specLayerHalfAngleRotate3 = null;
    //// anisotropic. Tangent
    MaterialProperty _anisotropicDirectionFlip = null;
    MaterialProperty _anisotropicArry = null;
    MaterialProperty _tangentShiftMask = null;
    MaterialProperty _shiftTangentShiftScale1 = null;//// unify scale to one setting
    MaterialProperty _specTangentShift1 = null;
    MaterialProperty _specTangentShift2 = null;
    MaterialProperty _specTangentShift3 = null;
    // Reflection
    MaterialProperty _useCubeMap = null;
    MaterialProperty _GlossinessMapMode = null;
    MaterialProperty _GlossinessMap = null;
    MaterialProperty _ENVMmode = null;
    MaterialProperty _ENVMix = null;
    MaterialProperty _envRoughness = null;
    MaterialProperty _CubemapFallbackMode = null;
    MaterialProperty _CubemapFallback = null;
    MaterialProperty _EnvGrazeMix = null;
    MaterialProperty _EnvGrazeRimMix = null;
    MaterialProperty _envOnRim = null;
    MaterialProperty _envOnRimColorize = null;
    // Rimlights
    // MaterialProperty _useRimLightSystem = null;
    MaterialProperty _rimLightIntensity = null;
    MaterialProperty _useRimLightSystem = null;
    MaterialProperty _rimLightUseNPRReduction = null;
    MaterialProperty _rimAlbedoMix = null;
    MaterialProperty _RimLightSource = null;
    MaterialProperty _RimLightColor = null;
    MaterialProperty _Ap_RimLightColor = null;
    MaterialProperty _RimLight_Power = null;
    MaterialProperty _Ap_RimLight_Power = null;
    MaterialProperty _RimLight_InsideMask = null;
    MaterialProperty _RimLightAreaOffset = null;
    MaterialProperty _LightDirection_MaskOn = null;
    MaterialProperty _Tweak_LightDirection_MaskLevel = null;
    MaterialProperty _rimLightLightsourceType = null;
    MaterialProperty _useRimLightOverTone = null;
    MaterialProperty _rimOverToneStep = null;
    MaterialProperty _rimOverToneFeather = null;
    MaterialProperty _rimOverTonePow = null;
    MaterialProperty _rimLightOverToneBlendColor1 = null;
    MaterialProperty _rimLightOverToneBlendColor2 = null;

    MaterialProperty _rimLightVersionMode = null;
    MaterialProperty _rimLightGain = null;
    MaterialProperty _rimLightStep = null;
    MaterialProperty _rimLightDirectionMode = null;
    MaterialProperty _rimLightDirectionGain = null;
    MaterialProperty _rimLightDirectionStep = null;
    MaterialProperty _rimLightGain_AP = null;



    MaterialProperty _rimLightSetPresetCubemap = null;
    // Matcap
    MaterialProperty _MatCap = null;
    MaterialProperty _MatCapColMult = null;
    MaterialProperty _MatCapTexMult = null;
    MaterialProperty _MatCapColAdd = null;
    MaterialProperty _MatCapTexAdd = null;
    MaterialProperty _MatCapColEmis = null;
    MaterialProperty _MatCapTexEmis = null;
    MaterialProperty _useMCHardMult = null;
    MaterialProperty _MatCapTexMultBlend = null;
    MaterialProperty _MatCapColHardMult = null;
    MaterialProperty _MatCapTexHardMult = null;
    MaterialProperty _Is_NormalMapForMatCap = null;
    MaterialProperty _NormalMapForMatCap = null;
    MaterialProperty _BumpScaleMatcap = null;
    MaterialProperty _Tweak_MatCapUV = null;
    MaterialProperty _Rotate_MatCapUV = null;
    MaterialProperty _Rotate_NormalMapForMatCapUV = null;
    MaterialProperty _TweakMatCapOnShadow = null;
    MaterialProperty _Set_MatcapMask = null;
    MaterialProperty _Tweak_MatcapMaskLevel = null;
    MaterialProperty _McDiffAlbedoMix = null;
    MaterialProperty _BlurLevelMatcap0 = null;
    MaterialProperty _BlurLevelMatcap1 = null;
    MaterialProperty _BlurLevelMatcap2 = null;
    MaterialProperty _BlurLevelMatcap3 = null;
    MaterialProperty _matcapSmoothnessSource0 = null;
    MaterialProperty _matcapSmoothnessSource1 = null;
    MaterialProperty _matcapSmoothnessSource2 = null;
    MaterialProperty _matcapSmoothnessSource3 = null;
    MaterialProperty _CameraRolling_Stabilizer = null;
    MaterialProperty _matcapSpecMaskSwitch = null;
    MaterialProperty _matcapEmissMaskSwitch = null;
    MaterialProperty _MatCap2ndLayer = null;
    MaterialProperty _Set_MatcapMask_2 = null;
    MaterialProperty _MatCapTexAdd_2 = null;
    MaterialProperty _MatCapTexMult_2 = null;
    MaterialProperty _MatCapTexEmis_2 = null;
    MaterialProperty _MatCapTexHardMult_2 = null;

    //// angel ring
    MaterialProperty _AngelRing = null;
    MaterialProperty _AngelRing_Sampler = null;
    MaterialProperty _AngelRing_Color = null;
    MaterialProperty _AR_OffsetU = null;
    MaterialProperty _AR_OffsetV = null;
    MaterialProperty _ARSampler_AlphaOn = null;
    MaterialProperty _uvSet_AngelRing = null;
    // Subsurface
    // MaterialProperty _depthMaxScale = null;
    MaterialProperty _useSSS = null;
    MaterialProperty _useFakeSSS = null;
    MaterialProperty _SSSThicknessMask = null;
    MaterialProperty _SSSLensFake = null;
    MaterialProperty _SSSDensityFake = null;
    MaterialProperty _SSSLens = null;
    MaterialProperty _SSSDepthColL = null;
    MaterialProperty _SSSDepthColH = null;
    MaterialProperty _SSSColThin = null;
    MaterialProperty _SSSColThick = null;
    // MaterialProperty _useRealSSS = null;
    // MaterialProperty _SSSDensityReal = null;
    // MaterialProperty _SSSRim = null;
    // MaterialProperty _SSSColRim = null;
    // MaterialProperty _SSSRimMaskL= null;
    // MaterialProperty _SSSRimMaskH = null;
    // Emission
    MaterialProperty _driverTintTex = null;
    MaterialProperty _EmissionColor = null;
    MaterialProperty _Emissive_Color = null;
    MaterialProperty _Emissive_Color2 = null;
    MaterialProperty _EmissionMap = null;
    MaterialProperty _Emissive_Tex = null;
    MaterialProperty _EmissionColorTex = null; /// legency name, is the "mask" texture
    MaterialProperty _EmissionColorTex2 = null;
    MaterialProperty _emissiveUseMainTexA = null;
    MaterialProperty _emissionUseStandardVars = null;
    MaterialProperty _emissionUseMask = null;
    MaterialProperty _emissionUseMaskDiffuseDimming = null;
    MaterialProperty _emisLightSourceType = null;
    MaterialProperty _emissionMixTintDiffuseSlider = null;
    MaterialProperty _emissionProportionalLum = null;
    MaterialProperty _emissionUse2ndTintRim = null;
    MaterialProperty _emission2ndTintLow = null;
    MaterialProperty _emission2ndTintHigh = null;
    MaterialProperty _emission2ndTintPow = null;
    MaterialProperty _useEmissionHSVI = null;
    MaterialProperty _emissionHSVIMask = null;
    MaterialProperty _emissionHSVIController1 = null;

    // Lighting Behaviour
    MaterialProperty _eyeStereoViewDirMode = null;
    MaterialProperty _useDistanceDarken = null;
    MaterialProperty _directLightIntensity = null;
    MaterialProperty _indirectAlbedoMaxAveScale = null;
    MaterialProperty _forceLightClamp = null;
    MaterialProperty _BlendOp = null;
    MaterialProperty _shadowCastMin_black = null;
    MaterialProperty _DynamicShadowMask = null;
    MaterialProperty _shadowUseCustomRampNDL = null;
    MaterialProperty _shadowNDLStep = null;
    MaterialProperty _shadowNDLFeather = null;
    MaterialProperty _shadowMaskPinch = null;
    MaterialProperty _shadowSplits = null;
    MaterialProperty _shadeShadowOffset1 = null;
    MaterialProperty _shadeShadowOffset2 = null;

    MaterialProperty _indirectGIDirectionalMix = null;
    MaterialProperty _indirectGIDirectionalUseNPR = null;
    MaterialProperty _indirectGIBlur = null;
    // Light Map Shift Masks
    MaterialProperty _Set_1st_ShadePosition = null;
    MaterialProperty _Set_2nd_ShadePosition = null;
    MaterialProperty _Set_1st_ShadePositionStrength = null;
    MaterialProperty _Set_2nd_ShadePositionStrength = null;
    MaterialProperty _UseLightMap = null;
    MaterialProperty _lightMapBlur = null;
    MaterialProperty _LightMap = null;
    MaterialProperty _lightMapRemapL = null;
    MaterialProperty _lightMapRemapH = null;
    MaterialProperty _lightMapGain = null;
    MaterialProperty _lightMapBlendMode = null;
    MaterialProperty _lightMapSymmetry = null;
    MaterialProperty _lightMapStrengthShadeRamp1 = null;
    MaterialProperty _lightMapStrengthShadeRamp2 = null;
    MaterialProperty _lightMapBlendModeCrossOverRim = null;
    MaterialProperty _lightMapStrengthShadeRampCrossOverRim = null;
    // Ambient Occlusion Maps
    MaterialProperty _Set_HighColorMask = null;
    MaterialProperty _invertHighColorMask = null;
    MaterialProperty _Tweak_HighColorMaskLevel = null;
    MaterialProperty _Set_RimLightMask = null;
    MaterialProperty _invertRimLightMask = null;
    MaterialProperty _Tweak_RimLightMaskLevel = null;
    // Normal map
    MaterialProperty _NormalMap = null;
    MaterialProperty _BumpScale = null;
    MaterialProperty _DetailNormalMapScale = null;
    MaterialProperty _DetailNormalMapScale01 = null;
    MaterialProperty _NormalMapDetail = null;
    MaterialProperty _DetailNormalMask = null;
    MaterialProperty _Is_NormalMapToBase = null;
    MaterialProperty _Is_NormalMapToHighColor = null;
    MaterialProperty _Is_NormalMapToRimLight = null;
    MaterialProperty _Is_NormaMapToEnv = null;
    // Alpha mask
    MaterialProperty _ZWrite = null;
    MaterialProperty _useAlphaDepthWrite = null;
    MaterialProperty _IsBaseMapAlphaAsClippingMask = null;
    MaterialProperty _ClippingMask = null;
    MaterialProperty _Inverse_Clipping = null;
    MaterialProperty _Clipping_Level = null;
    MaterialProperty _Tweak_transparency = null;
    MaterialProperty _UseSpecAlpha = null;
    MaterialProperty _DetachShadowClipping = null;
    MaterialProperty _Clipping_Level_Shadow = null;
    // Outline
    MaterialProperty _useOutline = null;
    MaterialProperty _OutlineTex = null;
    MaterialProperty _Outline_Sampler = null;
    MaterialProperty _Outline_Color = null;
    MaterialProperty _fillOutlineDepth = null;
    MaterialProperty _Is_BlendBaseColor = null;
    MaterialProperty _Is_OutlineTex = null;
    MaterialProperty _Outline_Width = null;
    MaterialProperty _Nearest_Distance = null;
    MaterialProperty _Farthest_Distance = null;
    MaterialProperty _Offset_Z = null;
    MaterialProperty _seperateOutlineAlphaTweak = null;
    MaterialProperty _Tweak_transparencyOutlines = null;

    MaterialProperty _outlineEmissionColor = null;
    MaterialProperty _outlineEmissionTint = null;
    MaterialProperty _outlineEmissionUseMask = null;
    MaterialProperty _outlineEmissionMask = null;
    MaterialProperty _outlineEmissiveProportionalLum = null;
    // Stencil Helpers. Requires Queue Order Edits
    MaterialProperty _Stencil = null;
    MaterialProperty _StencilComp = null;
    MaterialProperty _StencilOp = null;
    MaterialProperty _StencilFail = null;
    //
    MaterialProperty _DetailMap = null;
    MaterialProperty _DetailMask = null;
    MaterialProperty _DetailAlbedo = null;
    // MaterialProperty _DetailSmoothness = null;
    //
    MaterialProperty _useShadePosition = null;
    MaterialProperty _uvSet_ShadePosition = null;
    MaterialProperty _uvSet_ShadePosition1 = null;
    MaterialProperty _uvSet_ShadePosition2 = null;
    MaterialProperty _uvSet_LightMap = null;
    MaterialProperty _uvSet_NormalMapDetail = null;
    MaterialProperty _uvSet_NormalMapForMatCap = null;
    MaterialProperty _uvSet_DetailMap = null;
    MaterialProperty _uvSet_driverTintTex = null;
    MaterialProperty _uvSet_EmissionColorTex = null;
    MaterialProperty _uvSet_emissionMask = null;
    MaterialProperty _uvSet_albedo = null;
    MaterialProperty _uvSet_albedo1 = null;
    MaterialProperty _uvSet_albedo2 = null;
    MaterialProperty _uvSet_specular = null;
    MaterialProperty _uvSet_normalmap = null;
    MaterialProperty _uvSet_detailNormalMask = null;
    MaterialProperty _uvSet_highColorMask = null;
    MaterialProperty _uvSet_rimLightMask = null;
    MaterialProperty _uvSet_matcapMask = null;
    MaterialProperty _uvSet_clippingMask = null;
    MaterialProperty _uvSet_grabPassMask = null;
    MaterialProperty _uvSet_grabPassTintTex = null;
    MaterialProperty _uvSet_distortionBumpMap = null;

    //
    MaterialProperty _useAlbedoTexModding = null;
    MaterialProperty _albedoTexHSVIMask = null;
    MaterialProperty _controllerAlbedoHSVI_1 = null;
    MaterialProperty _controllerAlbedoHSVI_2 = null;
    MaterialProperty _controllerAlbedoHSVI_3 = null;
    //
    MaterialProperty _PenetratorEnabled = null;
    MaterialProperty _squeeze = null;
    MaterialProperty _SqueezeDist = null;
    MaterialProperty _BulgeOffset = null;
    MaterialProperty _BulgePower = null;
    MaterialProperty _Length = null;
    MaterialProperty _EntranceStiffness = null;
    MaterialProperty _Curvature = null;
    MaterialProperty _ReCurvature = null;
    MaterialProperty _WriggleSpeed = null;
    MaterialProperty _Wriggle = null;
    MaterialProperty _OrificeChannel = null;
    //
    // MaterialProperty _ReplaceAnimatedParameters = null;
    MaterialProperty _ColorAnimated = null;
    MaterialProperty _controllerAlbedoHSVI_1Animated = null;
    MaterialProperty _controllerAlbedoHSVI_2Animated = null;
    MaterialProperty _controllerAlbedoHSVI_3Animated = null;
    MaterialProperty _SpecColorAnimated = null;
    MaterialProperty _GlossinessAnimated = null;
    MaterialProperty _SpecularMaskHSVAnimated = null;
    MaterialProperty _CubemapFallbackModeAnimated = null;
    MaterialProperty _emissionHSVIController1Animated = null;
    MaterialProperty _shadowCastMin_blackAnimated = null;
    MaterialProperty _directLightIntensityAnimated = null;
    MaterialProperty _indirectAlbedoMaxAveScaleAnimated = null;
    MaterialProperty _useDistanceDarkenAnimated = null;
    MaterialProperty _forceLightClampAnimated = null;
    MaterialProperty _decal1_blendAmountAnimated = null;
    MaterialProperty _decal2_blendAmountAnimated = null;
    MaterialProperty _DecalEmission1_blendAmountAnimated = null;
    MaterialProperty _Tweak_transparencyAnimated = null;
    MaterialProperty _outlineEmissionColorAnimated = null;
    // decal 1
    MaterialProperty _useDecal1 = null;
    MaterialProperty _uvSet_decal1 = null;
    MaterialProperty _decal1 = null;
    MaterialProperty _decal1_color = null;
    MaterialProperty _decal1_blendAmount = null;
    MaterialProperty _decal1_transform = null;
    MaterialProperty _decal1_rotate = null;
    MaterialProperty _decal1_scale = null;
    MaterialProperty _decal1_ratioWH = null;
    MaterialProperty _decal1_blendMode = null;
    MaterialProperty _decal1_usePremultiplyAlpha = null;
    MaterialProperty _decal1_cutoff = null;
    MaterialProperty _decal1_boarder = null;
    MaterialProperty _decal1_pivotR = null;
    MaterialProperty _decal1_pivotS = null;
    // decal 2
    MaterialProperty _useDecal2 = null;
    MaterialProperty _uvSet_decal2 = null;
    MaterialProperty _decal2 = null;
    MaterialProperty _decal2_color = null;
    MaterialProperty _decal2_blendAmount = null;
    MaterialProperty _decal2_transform = null;
    MaterialProperty _decal2_rotate = null;
    MaterialProperty _decal2_scale = null;
    MaterialProperty _decal2_ratioWH = null;
    MaterialProperty _decal2_blendMode = null;
    MaterialProperty _decal2_usePremultiplyAlpha = null;
    MaterialProperty _decal2_cutoff = null;
    MaterialProperty _decal2_boarder = null;
    MaterialProperty _decal2_pivotR = null;
    MaterialProperty _decal2_pivotS = null;
        // decal emission
    MaterialProperty _useDecalEmission1 = null;
    MaterialProperty _uvSet_DecalEmission1 = null;
    MaterialProperty _DecalEmission1 = null;
    MaterialProperty _DecalEmission1_color = null;
    MaterialProperty _DecalEmission1_blendAmount = null;
    MaterialProperty _DecalEmission1_transform = null;
    MaterialProperty _DecalEmission1_rotate = null;
    MaterialProperty _DecalEmission1_scale = null;
    MaterialProperty _DecalEmission1_ratioWH = null;
    MaterialProperty _DecalEmission1_blendMode = null;
    MaterialProperty _DecalEmission1_usePremultiplyAlpha = null;
    MaterialProperty _DecalEmission1_cutoff = null;
    MaterialProperty _DecalEmission1_boarder = null;
    MaterialProperty _DecalEmission1_pivotR = null;
    MaterialProperty _DecalEmission1_pivotS = null;
    // grabpass effects
    MaterialProperty _grabPassMix = null;
    MaterialProperty _depthBufferCutout = null;
    MaterialProperty _useGrabPassHardCut = null;
    MaterialProperty _grabPassMask = null;
    MaterialProperty _grabPassTint = null;
    MaterialProperty _grabPassTintTex = null;
    MaterialProperty _grabPassMixAlbedo = null;
    MaterialProperty _useDepthEffects = null;
    MaterialProperty _depthFactor = null;
    MaterialProperty _depthPow = null;
    MaterialProperty _useBlurDepth = null;
    MaterialProperty _blurWidth = null;
    MaterialProperty _sigma = null;
    MaterialProperty _distortionBumpMap = null;
    MaterialProperty _distortionBumpMapScale = null;
    MaterialProperty _IORStrength = null;
    MaterialProperty _IOR = null;
    MaterialProperty _grabPassOverBrightnessClamp = null;
    // inventory
    MaterialProperty _UseInventory = null;
    MaterialProperty _InventoryStride = null;
    MaterialProperty _InventoryItem01Animated = null;
    MaterialProperty _InventoryItem02Animated = null;
    MaterialProperty _InventoryItem03Animated = null;
    MaterialProperty _InventoryItem04Animated = null;
    MaterialProperty _InventoryItem05Animated = null;
    MaterialProperty _InventoryItem06Animated = null;
    MaterialProperty _InventoryItem07Animated = null;
    MaterialProperty _InventoryItem08Animated = null;
    MaterialProperty _InventoryItem09Animated = null;
    MaterialProperty _InventoryItem10Animated = null;
    MaterialProperty _InventoryItem11Animated = null;
    MaterialProperty _InventoryItem12Animated = null;
    MaterialProperty _InventoryItem13Animated = null;
    MaterialProperty _InventoryItem14Animated = null;
    MaterialProperty _InventoryItem15Animated = null;
    MaterialProperty _InventoryItem16Animated = null;

    //
    static bool showBasics = false;
    static bool showToonramp = false;
    static bool showSpecularShine = false;
    static bool showSpecularLayering = false;
    static bool showTFI = false;
    static bool showAnisotropic = false;
    static bool showReflection = false;
    static bool showRimlights = false;
    static bool showMatcap = false;
    static bool showMCAR = false;
    static bool showEmission = false;
    static bool showSSS = false;
    static bool showLightingBehaviour = false;
    static bool showLightMapShiftMasks = false;
    static bool showNormalmap = false;
    static bool showDetailTextures = false;
    static bool showDetailMask = false;
    static bool showDecal = false;
    static bool showAlphamask = false;
    static bool showStencilHelpers = false;
    static bool showOutline = false;
    static bool showOutlineEmission = false;
    static bool showPen = false;
    static bool showAnimatable = false;
    static bool showInventory = false;
    static bool showGrabPassEffects = false;

    static bool showExtraAlbedoTextures = false;
    static bool showToonRampHSVI = false;
    static bool showSpecWorkF = false;
    static bool showMetalRoughWorkF = false;
    static bool showRimlightOvertone = false;
    static bool showEmission2nd = false;
    static bool showDecalEmission = false;
    static bool showMatcap2ndLayer = false;

    static bool showToonAreaBlends = false;
    static bool showToonLightBehaviours = false;

    static bool showRimLightNew = false;
    static bool showRimLightLegacy = false;

    //
    bool iscutout = false;
    bool iscutoutAlpha = false;
    bool isDither = false;
    bool isOutline = false;
    // bool isDepth = false;
    bool isGrabPass = false;
    bool isPen = false;

    //Vector2 scrollPos;
    //UnityEngine.Rect rect;
    //Vector4 storeVec4;
    //GUIContent[] contents = { new GUIContent("foo"), new GUIContent("bar") };
    //float[] cfloats = { 1f, 2f };

    public void BoxGUIBegin(GUIStyle guiStyle)
    {
        EditorGUILayout.BeginHorizontal(); EditorGUILayout.Space(15, false); EditorGUILayout.BeginVertical(guiStyle);
    }

    public void BoxGUIEnd()
    {
        EditorGUILayout.EndVertical(); EditorGUILayout.EndHorizontal(); //EditorGUILayout.Space(12, false);
    }

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {

        
        GUIStyle guiBox = new GUIStyle("sv_iconselector_back");
        guiBox.padding.left = 6;
        guiBox.padding.bottom = 6;
        guiBox.margin.bottom = 3;

        // float whatThis = (float)(EditorGUI.GetField("kIndentPerLevel").GetRawConstantValue()); 
        // Debug.Log("blah " + whatThis);
        Material material = materialEditor.target as Material;
        Shader shader = material.shader;

        // GUI.backgroundColor = Color.yellow;
        //rect = EditorGUILayout.GetControlRect(true, EditorGUIUtility.singleLineHeight * 2);
        //rect = GUILayoutUtility.GetRect(50, 50);
        //GUI.Box(new Rect(rect.x, rect.y, 50, rect.height), "A BOX");
        //GUI.Box(new Rect(0,0, 50, 50), new GUIContent("blah"));
        //_useDecal1.name;

        iscutout = shader.name.Contains("Cutout");
        iscutoutAlpha = shader.name.Contains("AlphaTransparent");
        isDither = shader.name.Contains("Dither");
        isOutline = shader.name.Contains("Outline");
        // isDepth = shader.name.Contains("Depth");
        isGrabPass = shader.name.Contains("GrabPass");
        isPen = shader.name.Contains("Pen");
        
        //
        foreach (var property in GetType().GetFields(bindingFlags)) 
        {                                                           
            if (property.FieldType == typeof(MaterialProperty))
            {
                try{ property.SetValue(this, FindProperty(property.Name, props)); } catch { /*Is it really a problem if it doesn't exist?*/ }
            }
        }

        //
        EditorGUI.BeginChangeCheck();
        {
            //// test area
            //EditorGUI.Vector4Field(GUILayoutUtility.GetRect(50, 50), new GUIContent("Blah","toolTip"), new Vector4(1, 2, 3, 4));
            //rect = GUILayoutUtility.GetRect(50, 50);
            //GUI.Box(rect, _useDecal1.floatValue.ToString());
            //EditorGUI.MultiFloatField(GUILayoutUtility.GetRect(50, 50), new GUIContent("blah"), contents, cfloats);           
            //float[] cfloats = { _BaseColor_Step.floatValue, _ShadeColor_Step.floatValue };
            //EditorGUI.MultiFloatField(GUILayoutUtility.GetRect(50, 50), new GUIContent("blah"), contents, cfloats);
            //rect = GUILayoutUtility.GetRect(50, 50);
            //materialEditor.ShaderProperty(rect, _BaseColor_Step,new GUIContent("step 1"));
            //rect.y += 25;
            //materialEditor.ShaderProperty(rect, _ShadeColor_Step, new GUIContent("step 2"));

            //// vector 4 experiment. doesnt write values correctly.
            //UnityEngine.Rect rectFloatField = GUILayoutUtility.GetRect(EditorGUIUtility.labelWidth, EditorGUIUtility.singleLineHeight + 2);
            //EditorGUI.LabelField(rectFloatField, "HSVI control:  H:");
            //storeVec4 = _SpecularMaskHSV.vectorValue;
            //rectFloatField.width = 32;
            //rectFloatField.x += 32 * 3;
            //storeVec4.x = EditorGUI.FloatField(rectFloatField, storeVec4.x);
            //rectFloatField.x += 40;
            //EditorGUI.LabelField(rectFloatField, "S:");
            //rectFloatField.x += 16;
            //storeVec4.y = EditorGUI.FloatField(rectFloatField, storeVec4.y);
            //rectFloatField.x += 40;
            //EditorGUI.LabelField(rectFloatField, "V:");
            //rectFloatField.x += 16;
            //storeVec4.z = EditorGUI.FloatField(rectFloatField, storeVec4.z);
            //rectFloatField.x += 40;
            //EditorGUI.LabelField(rectFloatField, "I:");
            //rectFloatField.x += 16;
            //storeVec4.w = EditorGUI.FloatField(rectFloatField, storeVec4.w);
            //materialEditor.SetVector("_SpecularMaskHSV", storeVec4);

            //// experiment, doent read value, doesnt make room for fields
            //storeVec4 = _SpecularMaskHSV.vectorValue;
            //EditorGUILayout.BeginHorizontal();
            //EditorGUILayout.FloatField("H", storeVec4.x, GUILayout.MinWidth(1), GUILayout.MaxWidth(32), GUILayout.ExpandWidth(false));
            //EditorGUILayout.FloatField("S", storeVec4.y, GUILayout.MinWidth(1), GUILayout.MaxWidth(32), GUILayout.ExpandWidth(false));
            //EditorGUILayout.FloatField("V", storeVec4.z, GUILayout.MinWidth(1), GUILayout.MaxWidth(32), GUILayout.ExpandWidth(false));
            //EditorGUILayout.FloatField("I", storeVec4.w, GUILayout.MinWidth(1), GUILayout.MaxWidth(32), GUILayout.ExpandWidth(false));
            //materialEditor.SetVector("_SpecularMaskHSV", storeVec4);
            //EditorGUILayout.EndHorizontal();

            ACLStyles.ShurikenHeaderCentered(ACLStyles.ver);
            ACLStyles.PartingLine();
            if (_ShaderOptimizerEnabled.floatValue == 0)
            {
                // EditorGUI.BeginDisabledGroup(true);
                EditorGUILayout.HelpBox("PLEASE LOCK SHADER BEFORE UPLOAD FOR BEST GPU PERFORMANCE.", MessageType.Error, true);
            }
            ShaderOptimizerButton(_ShaderOptimizerEnabled, materialEditor);
            // materialEditor.ShaderProperty(_ShaderOptimizerEnabled, new GUIContent("Lock Material", ""));
            ACLStyles.PartingLine();
            if (_ShaderOptimizerEnabled.floatValue == 1)
            {
                // EditorGUI.BeginDisabledGroup(true);
                EditorGUILayout.HelpBox("WARNING: SHADER IS LOCKED BY THE LOCK BUTTON AND BAKED IN.\nONLY ENABLED-ANIMATABLE PROPERTIES WILL RESPOND.", MessageType.Warning, true);
            }

            if (isGrabPass)
            {
                EditorGUILayout.HelpBox("Caution: GrabPass Effect shaders have a heavy performance impact for being applied as a material.\nPlease avoid Using GrabPass shaders for performance critical user spaces.", MessageType.Info, true);
            }

            //// test area
            //// gui referances
            // EditorGUILayout.GetControlRect()
            // EditorGUILayout.LabelField("New value----------------------------------------------------------------------");
            // EditorGUILayout.HelpBox("BLAH BLAH BLAH BLAH", MessageType.None, true);
            // testInt = EditorGUILayout.IntField(testInt);
            // showBasics = EditorGUILayout.Foldout(showBasics, "show basics");

            //EditorGUILayout.BeginHorizontal();
            //EditorGUILayout.EndHorizontal();

            //scrollPos = EditorGUILayout.BeginScrollView(scrollPos, false, true, GUILayout.Width(ACLStyles.GetViewWidth()), GUILayout.Height(400));
            //EditorGUILayout.EndScrollView();

            //ACLStyles.GUILine(10);

            // BoxGUIBegin(guiBox);
            // EditorGUILayout.LabelField("New value");
            // BoxGUIBegin(guiBox);
            // EditorGUILayout.LabelField("New value");
            // EditorGUILayout.LabelField("New value");
            // BoxGUIEnd();
            // BoxGUIBegin(guiBox);
            // EditorGUILayout.LabelField("New value");
            // EditorGUILayout.LabelField("New value");
            // BoxGUIEnd();
            // BoxGUIBegin(guiBox);
            // EditorGUILayout.LabelField("New value");
            // BoxGUIBegin(guiBox);
            // EditorGUILayout.LabelField("New value");
            // EditorGUILayout.LabelField("New value");
            // BoxGUIEnd();
            // EditorGUILayout.LabelField("New value");
            // BoxGUIEnd();
            // EditorGUILayout.LabelField("New value");
            // BoxGUIEnd();

            showBasics = ACLStyles.ShurikenFoldout("Basic Settings", showBasics);
            if (showBasics)
            {
                BoxGUIBegin(guiBox);
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Basic Settings:");
                materialEditor.TexturePropertySingleLine(new GUIContent("Main Texture (Ramp Forward Source)", "Main texture. As Forward Area intended for surface most towards light and the visual effect of being in direct light."), _MainTex, _Color, _uvSet_albedo);
                // materialEditor.TexturePropertySingleLine(new GUIContent("Emission Tint (RGB)", "Source glow color."), _Emissive_Tex, _Emissive_Color);
                materialEditor.ShaderProperty(_UseSpecularSystem, new GUIContent("Use Specular Effects", "Makes visible Direct Light and Cubemap effects.\nWhat is happening is off forces Primary Specular Color black as well as other shine factors off, well still processing roughness."));
                materialEditor.TexturePropertySingleLine(new GUIContent("Specular Mask(RGB). Smoothness(A)", "You must know how \"specular setup\" works. (RGB) intensity means more metallic, lower color saturation means more metallic (reflects without tint from surface). (A) is Smoothness value."), _HighColor_Tex, _SpecColor, _uvSet_specular);
                materialEditor.ShaderProperty(_Glossiness, new GUIContent("Smoothness", "Follows Standard. Higher reflects the world more perfectly. Affects Shine lobe and Cubemap."));
                materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map", ""), _NormalMap, _uvSet_normalmap);
                EditorGUILayout.LabelField("");
                materialEditor.ShaderProperty(_CullMode, new GUIContent("Cull Mode", "Culling backward/forward/no faces"));
                materialEditor.ShaderProperty(_shadowCastMin_black, new GUIContent("Dynamic Shadows Removal", "Counters undesirable hard dynamic shadow constrasts for NPR styles in maps with strong direct:ambient light contrasts.\nModifies direct light dynamic shadows behaviour: Each Directional/Point/Spot light in the scene has its own shadow settings and this slider at 1.0 \"brightens\" shadows away.\nUse 0.0 for intended PBR."));
                materialEditor.ShaderProperty(_indirectAlbedoMaxAveScale, new GUIContent("Static GI Max:Ave", "Affect overall brightness in ambient lit maps.\nHow overall Indirect light is sampled by object, abstracted to two sources \"Max\" or \"Average\" color, is used on Diffuse (Toon Ramping).\n1: Use Max color with Average intelligently.\n>1:Strongly switch to Average color as Max color scales brighter, which matches a few NPR shaders behaviour and darkness."));
                // ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_useToonRampSystem, new GUIContent("Use Toon Ramp:", ""));
                // materialEditor.ShaderProperty(_UseSpecularSystem, new GUIContent("Enable Specular Effects", "Makes visible Direct Light and Cubemap effects.\nWhat is happening is off forces Primary Specular Color black as well as other shine factors off, well still processing roughness."));
                materialEditor.ShaderProperty(_useRimLightSystem, new GUIContent("Use Rim Lights:", ""));
                // materialEditor.ShaderProperty(_MatCap, new GUIContent("Use Matcaps", "Uses all or none. (Currently this to simplify solving 3 unique matcap systems and hit performance)"));
                if (isOutline) {
                    materialEditor.ShaderProperty(_useOutline, new GUIContent("Use Outlines:", ""));
                }
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }

            // ACLStyles.PartingLine();
            //  EditorGUILayout.LabelField("- -");
            showToonramp = ACLStyles.ShurikenFoldout("Diffuse/Albedo (Toon Ramp Effects)", showToonramp);
            if (showToonramp)
            {
                BoxGUIBegin(guiBox);
                // materialEditor.TexturePropertySingleLine(new GUIContent("Main Tex", ""), _MainTex, _UVBLAH);
                // materialEditor.TextureProperty(_MainTex, "bleh", true);
                // materialEditor.TexturePropertyTwoLines(new GUIContent("Main Tex", "Words 1"), _MainTex, _UVBLAH, new GUIContent("_BAR", "words 2"), _BAR);
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Albedo Textures:");
                materialEditor.TexturePropertySingleLine(new GUIContent("Main Texture (Ramp Forward Source)", "Main texture. As Forward Area intended for surface most towards light and the visual effect of being in direct light."), _MainTex, _uvSet_albedo);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_MainTex);
                EditorGUI.indentLevel--;
                // ACLStyles.PartingLine();
                showExtraAlbedoTextures = ACLStyles.ShurikenFoldout("Extra Texture Sources:", showExtraAlbedoTextures, EditorGUI.indentLevel);
                if (showExtraAlbedoTextures)
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_useDiffuseAlbedoTexturesSet, new GUIContent("Use Extra Textures:", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_toonRampTexturesBlendMode, new GUIContent("Texture Mix Mode:", "Swap As: Replaces Area's texture with These.\nThese Textures becomes a tint that multiplies on Main Texture and set in each Area."));
                    materialEditor.TexturePropertySingleLine(new GUIContent("Core Texture", "If used as source. A NPR helper, \"Core Area\' is intended as the core area were light slowly angles perpendicular and artistically painted NPR effects may occur, for example painted subsurface colouring as light penetrates the acute surface and emits within the surface, or shadows may be painted to hint ambient occlusion(where light cannot enter and leave this sharp angle)."), _1st_ShadeMap, _1st_ShadeColor, _uvSet_albedo1);
                    materialEditor.TexturePropertySingleLine(new GUIContent("Backward Texture", "If used as source. A NPR helper, \"Backwards Area\' is intended as the area were direct light cannot hit and artistically painted represents ambient light and no painted on shadows."), _2nd_ShadeMap, _2nd_ShadeColor, _uvSet_albedo2);
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("");
                    EditorGUILayout.LabelField("■ Ramp Area Textures:");
                    materialEditor.ShaderProperty(_Use_BaseAs1st, new GUIContent("Ramp Core Source", "Unless you have custom set to MainTex."));
                    materialEditor.ShaderProperty(_Use_1stAs2nd, new GUIContent("Ramp Backward Source", "Unless you have custom set to MainTex."));
                    BoxGUIEnd();
                }
                showToonRampHSVI = ACLStyles.ShurikenFoldout("Color Adjustments:", showToonRampHSVI, EditorGUI.indentLevel);
                if (showToonRampHSVI)
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_useAlbedoTexModding, new GUIContent("Use Color Mods:", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("Mask (G)", ""), _albedoTexHSVIMask);
                    materialEditor.ShaderProperty(_controllerAlbedoHSVI_1, new GUIContent("Front HSVI", ""));
                    materialEditor.ShaderProperty(_controllerAlbedoHSVI_2, new GUIContent("Core HSVI", ""));
                    materialEditor.ShaderProperty(_controllerAlbedoHSVI_3, new GUIContent("Back HSVI", ""));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                // EditorGUI.indentLevel--;
                // ACLStyles.PartingLine();
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Toon Shading:");
                materialEditor.ShaderProperty(_useToonRampSystem, new GUIContent("Use Toon Ramp:", ""));
                EditorGUI.indentLevel++;
                EditorGUILayout.LabelField("■ Area Tints:");
                materialEditor.ShaderProperty(_Color, new GUIContent("Primary Diffuse Color", "Primary diffuse color control."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_BaseColor, new GUIContent("└ Forward Color", "See Main (Forward) Texture tooltip.\nTo prevent being too bright, avoid using full bright colors.\nA Max 97 to 90 Vibrance is reasonable."));
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("■ Core Area:");
                materialEditor.ShaderProperty(_1st_ShadeColor, new GUIContent("├ Core Color", "See Core Texture tooltip.\nTo prevent being too bright, avoid using full bright colors.\nA Max 97 to 90 Vibrance is reasonable."));
                materialEditor.ShaderProperty(_BaseColor_Step, new GUIContent("└ Step", "Where Forward Area blends to Core and Core overwraps Backwards Area\n0.5 is perpendicular to direct light."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_BaseShade_Feather, new GUIContent("└ Feather", "Softens warp. Wraps away from light, so increase Step Core as you soften."));
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("■ Backward Area:");
                materialEditor.ShaderProperty(_2nd_ShadeColor, new GUIContent("├ Backward Color", "See Backward Texture tooltip.\nTo prevent being too bright, avoid using full bright colors.\nA Max 97 to 90 Vibrance is reasonable."));
                materialEditor.ShaderProperty(_ShadeColor_Step, new GUIContent("└ Step", "Where Backward Area blends behind & within Core Area.\n0.5 is perpendicular to direct light."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_1st2nd_Shades_Feather, new GUIContent("└ Feather", "Softens warp. Wraps away from light, so increase Backwards Step as you soften."));
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_DiffToonShadePriority, new GUIContent("Area Priority:", "For the 3 toon areas: forward/core/backward: does area of Backward wrap over Core, or reversed?\nUTS2 style is Core priority."));
                materialEditor.ShaderProperty(_ToonRampFeather_n1_OffsetMode, new GUIContent("Core Feather Mode", "Direction the Feather spreads."));
                materialEditor.ShaderProperty(_ToonRampFeather_n2_OffsetMode, new GUIContent("Backward Feather Mode", "Direction the Feather spreads."));
                EditorGUI.indentLevel--;
                showToonAreaBlends = ACLStyles.ShurikenFoldout("Area Blend Behaviours", showToonAreaBlends, EditorGUI.indentLevel);
                if (showToonAreaBlends)
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_useCrossOverRim, new GUIContent("Cross Over Tone", "A outer rim effect that blends the Core and Backwards Area colors depending if your view is with or against the light. Use this for reactive \"Skin\" or roughness looking effects that adopts to the worlds lighting direction.\n This system is independent of the Step ranges of Core and Backwards Area."));
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("├ Mask(G)", "Black means no effect."), _crossOverMask);
                    materialEditor.ShaderProperty(_crossOverUseToonShades, new GUIContent("├ Use Toon Shades", "Mix the Toon Ramp Core and Backward Colors for a nice visual \"Cross Over\" effect."));
                    materialEditor.ShaderProperty(_crossOverSourceTexSource, new GUIContent("├ Albedo Source:", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("└ Texture", "Texture Albedo, us for things like socking or color tones at sharp angle."), _crossOverAlbedo);
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_crossOverTint, new GUIContent("├ Tint", ""));
                    materialEditor.ShaderProperty(_crossOverStep, new GUIContent("├ Step", "Rim start."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_crossOverFeather, new GUIContent("└ Feather", "Blur or sharpen."));
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_crosspOverRimPow, new GUIContent("├ Curve", "Power curve."));
                    materialEditor.ShaderProperty(_crossOverPinch, new GUIContent("└ Pinch", "Affects Core and Backwards transition sharpness."));
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("");
                    // EditorGUILayout.LabelField("■ Area Blend Behaviours:");
                    materialEditor.ShaderProperty(_Diff_GSF_01, new GUIContent("Diffuse GSF Effect", "Custom Geometric Shadowing Function (GSF) effect to simulate darkening or tinting of diffuse light in rough or penetrable surfaces at acute angles.\nEnabling will reveal The true mixing of regions between Forward/Core/Backaward Areas. Use this to help setup NPR cloth/skin/subsurface/iridescents setups."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_DiffGSF_Offset, new GUIContent("├ Offset GSF", "Offset were GSF begins. You may need to use wide values."));
                    materialEditor.ShaderProperty(_DiffGSF_Feather, new GUIContent("└ Feather GSF", "Blurs GSF"));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                showLightMapShiftMasks = ACLStyles.ShurikenFoldout("Light Shift Masks", showLightMapShiftMasks, EditorGUI.indentLevel);
                if (showLightMapShiftMasks)
                {
                    BoxGUIBegin(guiBox);
                    EditorGUILayout.LabelField("■ Diffuse Ambient Occlusion (AO):");
                    materialEditor.ShaderProperty(_useShadePosition, new GUIContent("Use AO Textures:", "AO texture forces toon ramp blending to use darker toon ramp areas, which looks better than painted on shading.\nIs a legacy effect, I recommend using LightMaps."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_uvSet_ShadePosition, new GUIContent("AO UV Set:", ""));
                    materialEditor.TexturePropertySingleLine(new GUIContent("Core AO (G)", "Forces Diffuse Forwards Area to Core Area.\nUse to Paint reactive toon shadows by texture which looks better than painted on."), _Set_1st_ShadePosition);
                    materialEditor.TexturePropertySingleLine(new GUIContent("Backward AO (G)", "Forces Diffuse Core Area to Backwards Area.\nUse to Paint toon shadows by texture which looks better than painted on."), _Set_2nd_ShadePosition);
                    materialEditor.ShaderProperty(_Set_1st_ShadePositionStrength, new GUIContent("Core Strength", ""));
                    materialEditor.ShaderProperty(_Set_2nd_ShadePositionStrength, new GUIContent("Backward Strength", ""));
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("\n");
                    EditorGUILayout.LabelField("■ Light Map System:");
                    EditorGUILayout.HelpBox("Hover over LightMap Mode Toggle for Details.", MessageType.None, true);
                    materialEditor.ShaderProperty(_UseLightMap, new GUIContent("LightMap Mode:", "Bias Diffuse NPR/PBR diffuse/Toon Ramp wrapping As a more advanced Occlusion Map.\nBiases can Brighten the Ramps shading towards Light or Dark surfaces away from light.\nWhite pushes surface Ramp toward Light and Black towards Shadows, and 50% grey towards mid tones.\nUse the settings below to Recurve the LightMap texture's levels."));
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("LightMap Mask (G)", ""), _LightMap, _uvSet_LightMap);
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_lightMapBlur, new GUIContent("LightMap Blur", ""));
                    materialEditor.TextureScaleOffsetProperty(_LightMap);
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■ Light Map Adjustments:");
                    materialEditor.ShaderProperty(_lightMapRemapL, new GUIContent("Black Level", "Default: 0\nRaises Black level of LightMap Texture.\nControls Shadows.\nExtra -0.1 range for Removing image compression."));
                    materialEditor.ShaderProperty(_lightMapRemapH, new GUIContent("White Level", "Default: 1\nDrops White Level of LightMap Texture.\nControls Toon Ramp Highlights.\nSet 1.0 for Light Maps balanced at gray.\nSet 0.5 For Ambient Occlusion Maps.\nExtra 1.1 range for Removing image compression."));
                    materialEditor.ShaderProperty(_lightMapGain, new GUIContent("Grey Gain Curve", "For Releveling Grey Color Detail.\nRecurves around 0.5 well preserving 0.0 and 1.0 of the LightMap Texture.\nDecimals Weaken Grey Details.\n n>1 Contrasts Grey Details."));
                    EditorGUILayout.LabelField("■ Blends:");                    
                    materialEditor.ShaderProperty(_lightMapSymmetry, new GUIContent("Mask Symmetry Mode", "Symmetric: Mask is normal and distorts evenly on the UV.\nAsymmetric: Mask has a left and right side that needs to react to light direction on the mesh.\nUse Asymmetric mode for \"Face Masks\" seen in games like Honkai Impact, Genshin Impact, and Grey Raven.\nAsymmetric setup requires the face to be a separated Skinned Mesh Renderer & material with its Root Bone assigned the head bone because the Right and Forward of this object affects the masks distortion requirements."));
                    materialEditor.ShaderProperty(_lightMapBlendMode, new GUIContent("Blend Mode", "Bias: Surface brighness bias, where >50% grey lightens surface and <50% darkens surface.\nDarken: Values below 100% darkens surface by % ammount."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_lightMapStrengthShadeRamp1, new GUIContent("├ Ramp Core Mix", "Bias The Light Curve in the Toon Shading towards The Light Map Texture"));
                    materialEditor.ShaderProperty(_lightMapStrengthShadeRamp2, new GUIContent("└ Ramp Shadow Mix", "Bias The Light Curve in the Toon Shading towards The Light Map Texture"));
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_lightMapBlendModeCrossOverRim, new GUIContent("Blend Mode", "Bias: Surface brighness bias, where >50% grey lightens surface and <50% darkens surface.\nDarken: Values below 100% darkens surface by % ammount."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_lightMapStrengthShadeRampCrossOverRim, new GUIContent("└ CrossOver Rim Mix", "Bias The Light Curve in the Cross Over Rim towards The Light Map Texture"));
                    EditorGUI.indentLevel--;
                    // EditorGUILayout.HelpBox("Relevels LightMap's high and low intensity to a new [0,1] clamp.\nAdjust [Z] for darkness and [W] for brightness, and be mindful the 50% gray pivot shifts from this.", MessageType.None, true);
                    // EditorGUILayout.HelpBox("By rule: higher value means brighter toon ramp shift by light direction.\nThese adjust the LightMap affect on new Core and Backward Areas.\nOutput = [X] * (Input) + [Y]. First adjest the [y], then deviate [x] from 1.0 (which means no change).", MessageType.None, true);
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                showToonLightBehaviours = ACLStyles.ShurikenFoldout("Toon Ramp & Light Harmony", showToonLightBehaviours, EditorGUI.indentLevel);
                if (showToonLightBehaviours)
                {
                    BoxGUIBegin(guiBox);
                    // EditorGUILayout.LabelField("■ Diffuse/Toon Light Behaviours:");
                    materialEditor.ShaderProperty(_shadeShadowOffset1, new GUIContent("Shadow Offset Core", "NPR effect of \"flooding\" Core Area color within Dynamic Shadows.\nShifts Toon Ramp Core Step By this value."));
                    materialEditor.ShaderProperty(_shadeShadowOffset2, new GUIContent("Shadow Offset Backward", "NPR effect of \"flooding\" Backward Area color within Dynamic Shadows.\nShifts Toon Ramp Backward Step By this value."));
                    materialEditor.ShaderProperty(_ToonRampLightSourceType_Core, new GUIContent("Light Mode Core", "Sets light model on the Core facing area to be indirect light and how much. For pbr/npr effects on diffuse backface area.\nAll Light: Adds direct and indirect light together.\nNatural ambient: Closer to PBR, core Indirect light is dependent on toon ramp style."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_diffuseIndirectDirectSimCoreMix, new GUIContent("└ Mix Direct Light", "Mix Direct Light into Core Area by amount. A NPR helper to assist Core & Backward's Step/Feather setting's wrap distribution on Indirect light.\nThink of it as how much light transists threw."));
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_ToonRampLightSourceType_Backwards, new GUIContent("Light Mode Backface ", "Sets light model on the Backward area to be indirect light and how much. For pbr/npr effects on diffuse backface area.\nAll Light: Adds direct and indirect light together.\nNatural ambient: Closer to PBR, as backface is only Indirect light as there is realistically no direct light hitting."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_diffuseIndirectDirectSimMix, new GUIContent("└ Mix Direct Light", "Mix Direct Light into Backward Area by amount. A NPR helper to assist Core & Backward's Step/Feather setting's wrap distribution on Indirect light.\nThink of it as how much light transists threw."));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }
            
            //  EditorGUILayout.LabelField("- -");
            showSpecularShine = ACLStyles.ShurikenFoldout("Specular Reflection", showSpecularShine);
            if (showSpecularShine)
            {
                BoxGUIBegin(guiBox);
                materialEditor.ShaderProperty(_UseSpecularSystem, new GUIContent("Use Specular Effects", "Makes visible Direct Light and Cubemap effects.\nWhat is happening is off forces Primary Specular Color black as well as other shine factors off, well still processing roughness."));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_uvSet_specular, new GUIContent("Specular UV Set:", "Affects all realtime shine and reflection, including Cubemap settings."));
                EditorGUILayout.LabelField("■ General Mask:");
                materialEditor.TexturePropertySingleLine(new GUIContent("Global Specular Mask", "Hides all specular output.\nAlso masks Specular Matcap and Cubemap effects."), _Set_HighColorMask, _uvSet_highColorMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_Set_HighColorMask);
                materialEditor.ShaderProperty(_invertHighColorMask, new GUIContent("Invert Mask", ""));
                materialEditor.ShaderProperty(_Tweak_HighColorMaskLevel, new GUIContent("Tweak Mask", ""));
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Specular Behaviour:");
                materialEditor.ShaderProperty(_Glossiness, new GUIContent("Smoothness", "Follows Standard. Higher reflects the world more perfectly. Affects Shine lobe and Cubemap."));
                materialEditor.ShaderProperty(_SpecColor, new GUIContent("Primary Specular Color", "Applies tint on Specular shine and Cubemap color."));
                materialEditor.TextureScaleOffsetProperty(_HighColor_Tex);
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Workflow");
                materialEditor.ShaderProperty(_WorkflowMode, new GUIContent("Workflow Mode:", "Unity Standardised mode for surface Metallic and Smoothness detail on masks."));
                materialEditor.ShaderProperty(_UseDiffuseEnergyConservation, new GUIContent("Energy Conservation", "ON: PBR, which high Specular Mask Dims Diffuse Effects to conserve Energy and match the Standard Shader Workflow. \nOFF: NPR, which Specular Color Simply Adds on Diffuse Effects."));
                showMetalRoughWorkF = ACLStyles.ShurikenFoldout("Metallic & Roughness Workflows", showMetalRoughWorkF, EditorGUI.indentLevel);
                if (showMetalRoughWorkF)
                {
                    BoxGUIBegin(guiBox);
                    EditorGUILayout.LabelField("■ Metallic & Roughness Workflows:");
                    materialEditor.ShaderProperty(_Metallicness, new GUIContent("Metallic Tint", "Follows Standard. Higher tints shine with diffuse texture more. Lower sets tint to nearly black."));
                    materialEditor.TexturePropertySingleLine(new GUIContent("Metallic(R). Smoothness(A)", "Metallic workflow mask."), _MetallicGlossMap);
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("Roughness(R)", "Roughness Mask in Roughness workflow. Works with Metallic mask."), _SpecGlossMap);
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_SpecOverride, new GUIContent("Specular Hybrid:", "Impart Specular workflow's color into Metallic/Roughness color mixing. Usefull if you want to mod the tint Metallic will grab from main texture (albedo).\nWhen On mix with \"Blend Albedo\"."));
                    BoxGUIEnd();
                }
                showSpecWorkF = ACLStyles.ShurikenFoldout("Specular Workflow:", showSpecWorkF, EditorGUI.indentLevel);
                if (showSpecWorkF)
                {
                    BoxGUIBegin(guiBox);
                    EditorGUILayout.LabelField("■ Specular Workflow:");
                    materialEditor.ShaderProperty(_SpecColor, new GUIContent("Primary Specular Color", "Applies tint on Specular shine and Cubemap color."));
                    materialEditor.TexturePropertySingleLine(new GUIContent("Specular Mask(RGB). Smoothness(A)", "You must know how \"specular setup\" works. (RGB) intensity means more metallic, lower color saturation means more metallic (reflects without tint from surface). (A) is Smoothness value."), _HighColor_Tex);
                    EditorGUILayout.LabelField("");
                    EditorGUILayout.LabelField("■ Specular Source Fallback:");
                    materialEditor.ShaderProperty(_highColTexSource, new GUIContent("Blend Albedo", "If you dont have a custom spec mask, you may borrow and blend the diffuse textures.\nI recommend modifying (V) against blacks, (I) for whites, (S) for metallicness."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_SpecularMaskHSV, new GUIContent("Finetune (HSVI)", ""));
                    EditorGUILayout.HelpBox("XYZW -> HSVI. Color adjestment when Blending from Albedo.", MessageType.None, true);
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                showTFI = ACLStyles.ShurikenFoldout("Iridescence:", showTFI, EditorGUI.indentLevel);
                if (showTFI)
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_useThinFilmIridescence,new GUIContent("Use Iridescence:","Use Thin film iridescence. This effect changes specular color from view based how certain thin coatings filter or enchance light waves of color."));
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("Mask (GA)","R = Scale Thickness (D inc)\nG = Iridescence Effect Mask"), _IridescenceMask);
                    materialEditor.ShaderProperty(_Dinc,new GUIContent("D inc","Max film thickness in color wavelength.\nChanging value changes the offset which wavelength color starts until its high enough to fade away interference."));
                    EditorGUILayout.LabelField("");
                    materialEditor.ShaderProperty(_eta2,new GUIContent("η2 (Eta 2)","1st film layer density which wave enters the film.\nAdjustment stretches the color bands against view angle."));
                    materialEditor.ShaderProperty(_eta3,new GUIContent("η3 (Eta 3)","2nd film layer density which wave leaves previous film and enters this.\nAdjust relative to η2 (Eta 2) value for complex and colorful interface patterns."));
                    EditorGUILayout.LabelField("");
                    materialEditor.ShaderProperty(_kappa3,new GUIContent("κ3 (Kappa 3)","General Strength of color interface pattern.\n Use lower value for non-metallic films.\nGenerally lower value for wave color banding intensity and higher value for weaker effect."));
                    materialEditor.ShaderProperty(_rimLightUseTFICol,new GUIContent("Rim Light Apply","Apply Iridescence to the Rim Light Effect"));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Shine Behaviour");
                materialEditor.ShaderProperty(_specColorIntensity, new GUIContent("Intensity Scale (NPR)", ""));
                materialEditor.ShaderProperty(_HighColor, new GUIContent("Shine Tint", "Multiplies over Shines color intensity and tints. Can use to shut it off (use black), or overpower in HDR (for controlling Sharp and Soft mode)."));
                materialEditor.ShaderProperty(_Is_SpecularToHighColor, new GUIContent("Shine Type", "Override Shape and Soft brightness with Shine Tint.\nSharp: Toony\nSoft: Simple and subtle lode\nUnity: Follow Unity's PBR"));
                showSpecularLayering = ACLStyles.ShurikenFoldout("Specular Layering", showSpecularLayering, EditorGUI.indentLevel);
                if (showSpecularLayering)
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_specLayersCount, new GUIContent("Layers:", ""));
                    EditorGUILayout.LabelField("■ Shine Color Mix:");
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_HighColor, new GUIContent("Color 1", ""));
                    materialEditor.ShaderProperty(_specLayerCol2, new GUIContent("Color 2", ""));
                    materialEditor.ShaderProperty(_specLayerCol3, new GUIContent("Color 3", ""));
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■ Shine Type Set:");
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_Is_SpecularToHighColor, new GUIContent("Type 1:", ""));
                    materialEditor.ShaderProperty(_specType2, new GUIContent("Type 2:", ""));
                    materialEditor.ShaderProperty(_specType3, new GUIContent("Type 3:", ""));
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■ Shine Smooth Recurves:");
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_specLayerRoughExp1, new GUIContent("Smooth Recurve 1", ""));
                    materialEditor.ShaderProperty(_specLayerRoughExp2, new GUIContent("Smooth Recurve 2", ""));
                    materialEditor.ShaderProperty(_specLayerRoughExp3, new GUIContent("Smooth Recurve 3", ""));
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■ Shine NPR Shape Behaviour:");
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_spaceLayerFeather1, new GUIContent("Smoothen 1", ""));
                    materialEditor.ShaderProperty(_spaceLayerFeather2, new GUIContent("Smoothen 2", ""));
                    materialEditor.ShaderProperty(_spaceLayerFeather3, new GUIContent("Smoothen 3", ""));
                    materialEditor.ShaderProperty(_spaceLayerOffset1, new GUIContent("Offset 1", ""));
                    materialEditor.ShaderProperty(_spaceLayerOffset2, new GUIContent("Offset 2", ""));
                    materialEditor.ShaderProperty(_spaceLayerOffset3, new GUIContent("Offset 3", ""));
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■ Shine Skew Behaviour:");
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_specLayerHalfAngleTilt2, new GUIContent("Shine Tilt 2", ""));
                    materialEditor.ShaderProperty(_specLayerHalfAngleTilt3, new GUIContent("Shine Tilt 3", ""));
                    materialEditor.ShaderProperty(_specLayerHalfAngleRotate2, new GUIContent("Shine Rotate 2", ""));
                    materialEditor.ShaderProperty(_specLayerHalfAngleRotate3, new GUIContent("Shine Rotate 3", ""));
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■ Tangent Shifting:");
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_specTangentShift1, new GUIContent("Tangent Shift 1", ""));
                    materialEditor.ShaderProperty(_specTangentShift2, new GUIContent("Tangent Shift 2", ""));
                    materialEditor.ShaderProperty(_specTangentShift3, new GUIContent("Tangent Shift 3", ""));
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■ Shine Layers Blending Behaviour:");
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_specMaskLayersOrder, new GUIContent("Layers Order", "Raise to the ealier layers override later. This is useful for preventing unwanted additive color mixing among the layers."));
                    materialEditor.ShaderProperty(_specMaskLayersPinch, new GUIContent("Layers Pinch/Sharpen", "Pinches the layers so  blending between each is less."));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                showAnisotropic = ACLStyles.ShurikenFoldout("Anisotropic Settings", showAnisotropic, EditorGUI.indentLevel);
                if (showAnisotropic)
                {
                    BoxGUIBegin(guiBox);
                    EditorGUILayout.LabelField("■ Anisotropic Behaviour:");
                    materialEditor.ShaderProperty(_anisotropicDirectionFlip, new GUIContent("Flip Direction", ""));
                    materialEditor.ShaderProperty(_anisotropicArry, new GUIContent("Aniso. Strength", ""));
                    EditorGUILayout.LabelField("");
                    EditorGUILayout.LabelField("■ Anisotropic Shift And Tangent Behaviour:");
                    materialEditor.TexturePropertySingleLine(new GUIContent("Tangent Shift Mask(g)", "Shifts Anistrhpic bands along the tangent based on texture intensity around 50% grey and the surfaces normal.\n You can use this to make convincing Strands of hair"), _tangentShiftMask);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_tangentShiftMask);
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_shiftTangentShiftScale1, new GUIContent("Shift Scale", "Scales strangth of Tangent Shift Mask.\n 0.0 means no effect."));
                    BoxGUIEnd();
                }
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }

            showReflection = ACLStyles.ShurikenFoldout("Cubemap Reflection Behavour", showReflection);
            if (showReflection)
            {
                BoxGUIBegin(guiBox);
                materialEditor.ShaderProperty(_useCubeMap, new GUIContent("Use Cubemap", "Enable sampling of CubeMap."));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_CubemapFallbackMode, new GUIContent("Fallback Mode", "Fallback Cubemap intensifies to average lighting.\nSmart: Enables when map gives nothing.\nAlways: Always override with custom."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("└ Fallback Cubemap", ""), _CubemapFallback);
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("");
                materialEditor.ShaderProperty(_GlossinessMapMode, new GUIContent("GlossMask Mode:", "Mask: GlossMask masks workflow mask.\nReplace: Gloss mask works independent."));
                materialEditor.TexturePropertySingleLine(new GUIContent("GlossMask(RGB).Smoothness(A)", "Reflection override mask, good for custom cubemaps or corrections.\nIn mask mode: (RGB) works as tint. (A) is pivot, use 0.5 gray for no effect.\nIn override (RGB) is tint, (A) is smoothness."), _GlossinessMap);
                // EditorGUI.indentLevel++;
                // materialEditor.TextureScaleOffsetProperty(_GlossinessMap);
                // EditorGUI.indentLevel--;
                // ACLStyles.PartingLine();
                EditorGUILayout.LabelField("");
                materialEditor.ShaderProperty(_ENVMmode, new GUIContent("Control Method", "Standard: Reflection follows Standard formula, Intensity dims and roughness pivots change of roughness around 0.5.\nOverride: You override Intensity and Roughness exactly."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_ENVMix, new GUIContent("├ Intensity", "With Standard: Rescales reflection visability by this.\nWith Override: Replace the intensity and ignores roughness mask."));
                materialEditor.ShaderProperty(_envRoughness, new GUIContent("└ Smoothness(0.5)", "For Override only. Pivots on 0.5 making Smoothness higher or weaker.\bYou can use this to blur Cubemap into a average."));
                EditorGUI.indentLevel--;
                // ACLStyles.PartingLine();
                EditorGUILayout.LabelField("");
                materialEditor.ShaderProperty(_EnvGrazeMix, new GUIContent("Use Natural Fresnel", "Natural unmaskable specular at sharp angles linked to Specular."));
                materialEditor.ShaderProperty(_EnvGrazeRimMix, new GUIContent("Use RimLight Fresnel", "Unmaskable specular at sharp angles linked to Specular.\nUses both Rim Light -/+ settings as mask."));
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }

            showRimlights = ACLStyles.ShurikenFoldout("Rim Lighting (Simplified Cubemap Fresnel Effects)", showRimlights);
            if (showRimlights)
            {
                BoxGUIBegin(guiBox);
                // materialEditor.ShaderProperty(_useRimLightSystem, new GUIContent("Use RimLights:", ""));
                materialEditor.ShaderProperty(_useRimLightSystem, new GUIContent("Use Rim Lights", ""));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_rimLightIntensity, new GUIContent("Intensity Scale", ""));
                materialEditor.ShaderProperty(_rimLightVersionMode, new GUIContent("Implementation Type", "Use my New Rimlight setup or Legacy (UTS2) effect."));
                showRimLightNew = ACLStyles.ShurikenFoldout("Rim Controls (Modern)", showRimLightNew, EditorGUI.indentLevel);
                if (showRimLightNew)
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_RimLightColor, new GUIContent("Color", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_rimLightGain, new GUIContent("└ Gain", "Pivots the curve towards were the surface is perpendicular to camera."));
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_rimLightStep, new GUIContent("Step", "Tilts the Pivot. Default Pivot is 0.5"));
                    materialEditor.ShaderProperty(_rimLightDirectionMode, new GUIContent("Direction Mode", "Makes Rim light tilt by light direction and also add a polar opposite rim color."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_rimLightDirectionGain, new GUIContent("├ Gain", ""));
                    materialEditor.ShaderProperty(_rimLightDirectionStep, new GUIContent("├ Step", "Default Pivot is 0.5"));
                    materialEditor.ShaderProperty(_Ap_RimLightColor, new GUIContent("└ Color Opposite", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_rimLightGain_AP, new GUIContent("└ Gain", "Pivots the curve towards were the surface is perpendicular to camera."));
                    EditorGUI.indentLevel--;
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                showRimLightLegacy = ACLStyles.ShurikenFoldout("Rim Controls (Legacy)", showRimLightLegacy, EditorGUI.indentLevel);
                if (showRimLightLegacy)
                {
                    BoxGUIBegin(guiBox);
                    // EditorGUILayout.LabelField("■ Primary Rim:");
                    materialEditor.ShaderProperty(_RimLightColor, new GUIContent("Color", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_RimLight_Power, new GUIContent("└ Power", ""));
                    EditorGUI.indentLevel--;
                    //
                    EditorGUILayout.LabelField("■ Direction Behaviour:");
                    materialEditor.ShaderProperty(_LightDirection_MaskOn, new GUIContent("Light direction mode", "Enables masking by light direction and dual + and - mode. Off makes + a simple overrap."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_Tweak_LightDirection_MaskLevel, new GUIContent("├ Polarize", "Split + and - more by light direction."));
                    materialEditor.ShaderProperty(_Ap_RimLightColor, new GUIContent("└ Color Opposite", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_Ap_RimLight_Power, new GUIContent("└ Power Opposite", ""));
                    EditorGUI.indentLevel--;
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■ Wrap Behaviour:");
                    materialEditor.ShaderProperty(_RimLightAreaOffset, new GUIContent("Offset Wrap", "Shifts RimLights \"warp\". To control how the high and low of the rim curve appear."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_RimLight_InsideMask, new GUIContent("└ Sharpness", "Tampers falloff to a shaper edge. Good for toony lines."));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                showRimlightOvertone = ACLStyles.ShurikenFoldout("2nd Color", showRimlightOvertone, EditorGUI.indentLevel);
                if (showRimlightOvertone)
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_useRimLightOverTone, new GUIContent("2nd Layer Tint", "Blend a 2nd layer tint over (-/+) Forward/Back Rim Lights. Use this to stylize white rim edges or whatever color blends.\nWorks when either Rim is enabled, so shut this off when you are not using it."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_rimOverTonePow, new GUIContent("Power", ""));
                    materialEditor.ShaderProperty(_rimOverToneStep, new GUIContent("Step", "Default Pivot is 0.5"));
                    materialEditor.ShaderProperty(_rimOverToneFeather, new GUIContent("Feather", ""));
                    materialEditor.ShaderProperty(_rimLightOverToneBlendColor1, new GUIContent("├ Color", "Color on + Rim."));
                    materialEditor.ShaderProperty(_rimLightOverToneBlendColor2, new GUIContent("└ Color Opposite", "Color on - Rim."));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                EditorGUILayout.LabelField("■ Texture Color:");
                materialEditor.ShaderProperty(_rimAlbedoMix, new GUIContent("Mix Albedo", "Mix to tint RimLight by source texture."));
                materialEditor.ShaderProperty(_RimLightSource, new GUIContent("└ Source", "Diffuse: Good for Matching Skin\"subsurface\" tones.\nSpecular: Good to match metallic tones as set in your Specular Color settings."));
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Light Model:");
                materialEditor.ShaderProperty(_rimLightLightsourceType, new GUIContent("As: Diffuse:Cubemap", "Light Rim Lights like a surface diffuse or Cubemap. First good for subsurface effects and 2nd for metallic/smoothness effect."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_envOnRim, new GUIContent("├ As: Static:Cubemap", "Masks Rim Lighting by simple ambience to Cubemap colors. Uses Cubemap settings. I recommend overriding Cubemap Fallback and Roughness settings when applying this."));
                materialEditor.ShaderProperty(_rimLightSetPresetCubemap, new GUIContent("└ Cubemap Mix Preset", "A NPR override preset for settings i use often for Toony Rim's.\nEnabling forces Cubemap data exclusively on the Rimlight and Disable if you need the Cubemap On the SURFACE."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_envOnRimColorize, new GUIContent("└ Colorize", "Scale from grayscale to color."));
                EditorGUI.indentLevel--;
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Mask Controls:");
                materialEditor.ShaderProperty(_rimLightUseNPRReduction, new GUIContent("PBR Masking", "Enable so Rimlight's Intensity is controlled with Specularity PBR settings and textures, as in acts as PBR fresnel does with specularity color and smoothness settings. To be enabled after Specularity effects are setup and given Specular/metallic/roughness/etc masks."));
                materialEditor.TexturePropertySingleLine(new GUIContent("Rim Light Mask", ""), _Set_RimLightMask, _uvSet_rimLightMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_Set_RimLightMask);
                materialEditor.ShaderProperty(_invertRimLightMask, new GUIContent("Invert Mask", ""));
                materialEditor.ShaderProperty(_Tweak_RimLightMaskLevel, new GUIContent("Tweak Mask", ""));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }

            // ACLStyles.PartingLine();
            //  EditorGUILayout.LabelField("- -");
            showMatcap = ACLStyles.ShurikenFoldout("Matcap Controls", showMatcap);
            if (showMatcap)
            {
                BoxGUIBegin(guiBox);
                materialEditor.ShaderProperty(_MatCap, new GUIContent("Use Matcaps", "Uses all or none. (Currently this to simplify solving 3 unique matcap systems and hit performance)"));
                ACLStyles.PartingLine();
                showMCAR = ACLStyles.ShurikenFoldout("Hair Angel Ring", showMCAR, EditorGUI.indentLevel);
                if (showMCAR) 
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_AngelRing, new GUIContent("Use Angel Ring ", "Consule the UTS2 documentation for Angel Ring Setup.\nEffect is a Matcap that aligns U (vertical) Texture Coordinate to the 2nd UV set of the meshes U coordinate. Mesh requires UV to be setup for this feature."));
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("Ring Texture", ""), _AngelRing_Sampler, _AngelRing_Color);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_AngelRing_Sampler);
                    EditorGUI.indentLevel--;
                    // materialEditor.ShaderProperty(_AngelRing_Sampler, new GUIContent("_AngelRing_Sampler ", ""));
                    // materialEditor.ShaderProperty(_AngelRing_Color, new GUIContent("_AngelRing_Color ", ""));
                    materialEditor.ShaderProperty(_AR_OffsetU, new GUIContent("├ Offset U ", "Adjest UV Width"));
                    materialEditor.ShaderProperty(_AR_OffsetV, new GUIContent("├ Offset V ", "Adjest UV Vertial Coordinate against Surface Normal"));
                    materialEditor.ShaderProperty(_ARSampler_AlphaOn, new GUIContent("├ Use Alpha", "Alpha Channel of texture masks effect."));
                    materialEditor.ShaderProperty(_uvSet_AngelRing, new GUIContent("└ UV Set:", "Typically models put this in the 2nd UV set."));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                EditorGUILayout.LabelField("■ Mask:");
                materialEditor.TexturePropertySingleLine(new GUIContent("Global Mask(RGBA)", "(Have texture sRGB off)\nR: Diffuse Mask\nG: Multi Mask\nB: Specular\nA: Emission"), _Set_MatcapMask, _uvSet_matcapMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_Set_MatcapMask);
                materialEditor.ShaderProperty(_Tweak_MatcapMaskLevel, new GUIContent("Tweak Mask", ""));
                materialEditor.ShaderProperty(_matcapSpecMaskSwitch, new GUIContent("Spec Mask source:", ""));
                materialEditor.ShaderProperty(_matcapEmissMaskSwitch, new GUIContent("Emission Mask source", ""));
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Matcap Types:");
                materialEditor.TexturePropertySingleLine(new GUIContent("Diffuse Type (x+)", "Use this for \"baked\" toon ramp, subsurface, or iridescent Matcaps. It multiplies on the Diffuse Texture and then adds result. Lighting is Direct(with shadows) + Indirect.\nMasked by Diffuse Matcap Mask."), _MatCapTexMult, _MatCapColMult);
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_McDiffAlbedoMix, new GUIContent("└ Diffuse Albedo Mix", "How much of diffuse texture to mix in diffuse matcap."));
                materialEditor.ShaderProperty(_matcapSmoothnessSource1, new GUIContent("Blur Source:", "Blur Matcap by Specular Smoothness settings or override your own."));
                materialEditor.ShaderProperty(_BlurLevelMatcap1, new GUIContent("└ Smoothness", "Manual override of blur."));
                EditorGUI.indentLevel--;
                // EditorGUILayout.LabelField("");
                materialEditor.TexturePropertySingleLine(new GUIContent("Multiply Type (x)", "Multiplies on the albedo textures. Will always affect diffuse effects."), _MatCapTexHardMult, _MatCapColHardMult);
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_useMCHardMult, new GUIContent("Use Multiply Type", "Keep off when not used so it will not affect diffuse coloring."));
                materialEditor.ShaderProperty(_MatCapTexMultBlend, new GUIContent("└ Blend", ""));
                materialEditor.ShaderProperty(_matcapSmoothnessSource3, new GUIContent("Blur Source:", "Blur Matcap by Specular Smoothness settings or override your own."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_BlurLevelMatcap3, new GUIContent("└ Smoothness", "Manual override of blur."));
                EditorGUI.indentLevel--;
                EditorGUI.indentLevel--;
                // EditorGUILayout.LabelField("");
                materialEditor.TexturePropertySingleLine(new GUIContent("Specular Type (+)", "Use this for \"baked\" Specular Reflection Matcaps. Intensity works like Cubemap Fallback.\nMasked by Global Specular Mask."), _MatCapTexAdd, _MatCapColAdd);
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_matcapSmoothnessSource0, new GUIContent("Blur Source:", "Blur Matcap by Specular Smoothness settings or override your own."));
                materialEditor.ShaderProperty(_BlurLevelMatcap0, new GUIContent("└ Smoothness", "Manual override of blur."));
                EditorGUI.indentLevel--;
                // EditorGUILayout.LabelField("");
                materialEditor.TexturePropertySingleLine(new GUIContent("Emission Type", "Adds in texture and scales to HDR Color as set.\nMasked by Emission masks."), _MatCapTexEmis, _MatCapColEmis);
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_matcapSmoothnessSource2, new GUIContent("Blur Source:", "Blur Matcap by Specular Smoothness settings or override your own."));
                materialEditor.ShaderProperty(_BlurLevelMatcap2, new GUIContent("└ Smoothness", "Manual override of blur."));
                EditorGUI.indentLevel--;
                //
                showMatcap2ndLayer = ACLStyles.ShurikenFoldout("2nd Matcap Layer", showMatcap2ndLayer, EditorGUI.indentLevel);
                if (showMatcap2ndLayer)
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_MatCap2ndLayer, new GUIContent("Use 2nd Matcap Layer", "Blends the first matcap with the alternative matcap for each. Use the mask to blend between the pairs."));
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("2nd Matcap Mask(RGBA)", "(Have texture sRGB off)\nR: Diffuse Mask\nG: Multi Mask\nB: Specular\nA: Emission"), _Set_MatcapMask_2);
                    materialEditor.TexturePropertySingleLine(new GUIContent("Diffuse Type 2 (x+)", ""), _MatCapTexMult_2);
                    materialEditor.TexturePropertySingleLine(new GUIContent("Multiply Type 2 (x)", ""), _MatCapTexHardMult_2);
                    materialEditor.TexturePropertySingleLine(new GUIContent("Specular Type 2 (+)", ""), _MatCapTexAdd_2);
                    materialEditor.TexturePropertySingleLine(new GUIContent("Emission Type 2", ""), _MatCapTexEmis_2);
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Texture Transforms:");
                materialEditor.ShaderProperty(_CameraRolling_Stabilizer, new GUIContent("Roll Stabilizer", "Envokes \"world upright\" matcaps by turning the matcap against your head roll. Used for fake hair shine and other specular effects."));
                materialEditor.ShaderProperty(_Rotate_MatCapUV, new GUIContent("Rotate UV", ""));
                materialEditor.ShaderProperty(_Tweak_MatCapUV, new GUIContent("Scale UV", ""));
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ NormalMap Controls:");
                materialEditor.ShaderProperty(_Is_NormalMapForMatCap, new GUIContent("Use Normal Map", "Distort Matcaps by unique Normals."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map", ""), _NormalMapForMatCap, _BumpScaleMatcap, _uvSet_NormalMapForMatCap);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_NormalMapForMatCap);
                materialEditor.ShaderProperty(_Rotate_NormalMapForMatCapUV, new GUIContent("└ Rotate UV", ""));
                EditorGUI.indentLevel--;
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }
            
            showSSS = ACLStyles.ShurikenFoldout("SubSurface Controls", showSSS);
            if (showSSS)
            {
                BoxGUIBegin(guiBox);
                materialEditor.ShaderProperty(_useSSS, new GUIContent("Use Subsurface Lighting", ""));
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Thickness Mask(G)", "Gives inner volume with pre-baked mask.\nCreate by backing AO with a faces INVERTED in Blender or similar 3d programs."), _SSSThicknessMask);
                // ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_SSSColThin, new GUIContent("└ Thin Color", ""));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_SSSColThick, new GUIContent("├ Thick Tint", ""));
                materialEditor.ShaderProperty(_SSSDepthColL, new GUIContent("├ High Density Range", ""));
                materialEditor.ShaderProperty(_SSSDepthColH, new GUIContent("└ Low Density Range", ""));
                EditorGUI.indentLevel--;
                // ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_useFakeSSS, new GUIContent("Use Fake SSS", ""));
                materialEditor.ShaderProperty(_SSSLensFake, new GUIContent("├ Fake Lens", ""));
                materialEditor.ShaderProperty(_SSSDensityFake, new GUIContent("└ Fake Depth", ""));
                // ACLStyles.PartingLine();
                // if (isDepth)
                // {
                //     EditorGUILayout.HelpBox("Setup requires \"_Write_Depth\" shader applied on used (skin)mesh copies to get depth from back face to front face mesh.\nAll mesh should be closed hull (no gaps in space) for correct depth results.", MessageType.None, true);
                //     materialEditor.ShaderProperty(_useRealSSS, new GUIContent("Use Depth SSS", ""));
                //     materialEditor.ShaderProperty(_depthMaxScale, new GUIContent("├ Depth Max Scale", ""));
                //     materialEditor.ShaderProperty(_SSSDensityReal, new GUIContent("└ Real Density", ""));
                //     ACLStyles.PartingLine();
                //     materialEditor.ShaderProperty(_SSSRim, new GUIContent("Rim Lens", ""));
                //     EditorGUI.indentLevel++;
                //     materialEditor.ShaderProperty(_SSSColRim, new GUIContent("├ Rim Color", ""));
                //     materialEditor.ShaderProperty(_SSSRimMaskL, new GUIContent("├ High Rim Range", ""));
                //     materialEditor.ShaderProperty(_SSSRimMaskH, new GUIContent("└ Low Rim Range", ""));
                //     EditorGUI.indentLevel--;
                // }
                // else
                // {
                //     EditorGUILayout.HelpBox("Volume Depth SSS available in the \"_Solid_Depth\" shader.", MessageType.None, true);
                // }
                // ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_SSSLens, new GUIContent("Light Lens", ""));
                // ACLStyles.PartingLine();
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }

            //// because im evil and emission fallback for vrchat sucks using KEYWORDS and STRANGE GI TAGS to work.
            material.EnableKeyword("_EMISSION");
            material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.AnyEmissive;
            showEmission = ACLStyles.ShurikenFoldout("Emission Controls", showEmission);
            if (showEmission)
            {
                BoxGUIBegin(guiBox);
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Primary Color:");
                materialEditor.ShaderProperty(_uvSet_EmissionColorTex, new GUIContent("Emission UV Set:", ""));
                materialEditor.ShaderProperty(_emissionUseStandardVars, new GUIContent("Select Variable type:", "Select Internal variables For vrchat fallback support.\nStandard: Use fallback safe.\nUTS2: Use legacy UTS2 variables\n I Recommend you migrate UTS2's emission color and texture with the Standard types here so your Emission MAY fallback within Vrchat."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_EmissionColor, new GUIContent("Standard Color", "Color emission as Standard"));
                materialEditor.TexturePropertySingleLine(new GUIContent("Standard Color Tint (RGBA)", "Color texture as Standard's variable"), _EmissionMap);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_EmissionMap);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_Emissive_Color, new GUIContent(" UTS2 Color", "Color emission as UTS2"));
                materialEditor.TexturePropertySingleLine(new GUIContent("UTS2 Color Tint (RGBA)", "Color texture as UTS2's variable"), _Emissive_Tex);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_Emissive_Tex);
                EditorGUI.indentLevel--;
                EditorGUI.indentLevel--;
                showEmission2nd = ACLStyles.ShurikenFoldout("Rim Emission", showEmission2nd, EditorGUI.indentLevel);
                if (showEmission2nd)
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_emissionUse2ndTintRim, new GUIContent("Use Rim Emission", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_Emissive_Color2, new GUIContent("├ Color", ""));
                    materialEditor.TexturePropertySingleLine(new GUIContent("├ Albedo Tint (RGB)", ""), _EmissionColorTex2);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_EmissionColorTex2);
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_emission2ndTintLow, new GUIContent("├ Low Range", "Rim transition starts at 0.5 and full at 1.0."));
                    materialEditor.ShaderProperty(_emission2ndTintHigh, new GUIContent("├ High Range", "Rim transition starts at 0.5 and full at 1.0."));
                    materialEditor.ShaderProperty(_emission2ndTintPow, new GUIContent("└ Power", "Arch curve the mask from 0.0001 to 256. 1.0 is no effect."));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                showDecalEmission = ACLStyles.ShurikenFoldout("Decal (Emission)", showDecalEmission, EditorGUI.indentLevel);
                if (showDecalEmission)
                {
                    BoxGUIBegin(guiBox);
                    EditorGUILayout.LabelField("■ Decal 1:");
                    materialEditor.ShaderProperty(_useDecalEmission1, new GUIContent("Use Decal 1", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_DecalEmission1_blendAmount, new GUIContent("Blend", "Mixes Decal in"));
                    materialEditor.TexturePropertySingleLine(new GUIContent("Decal 1 Tex", ""), _DecalEmission1, _uvSet_DecalEmission1);
                    materialEditor.ShaderProperty(_DecalEmission1_color, new GUIContent("Color", ""));
                    materialEditor.ShaderProperty(_DecalEmission1_blendMode, new GUIContent("Blend Mode:", "Color Blend mode"));
                    materialEditor.ShaderProperty(_DecalEmission1_usePremultiplyAlpha, new GUIContent("Premultiply Alpha", "Use decal's alpha channel"));
                    materialEditor.ShaderProperty(_DecalEmission1_cutoff, new GUIContent("Alpha Cutoff", "Alpha Cutoff"));
                    materialEditor.ShaderProperty(_DecalEmission1_transform, new GUIContent("transform", "UV offset: x=U, y=V.  Z and W is slant over UV"));
                    materialEditor.ShaderProperty(_DecalEmission1_rotate, new GUIContent("Rotate", ""));
                    materialEditor.ShaderProperty(_DecalEmission1_scale, new GUIContent("Scale", "Smaller to decimals means bigger"));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_DecalEmission1_ratioWH, new GUIContent("└ Scale Ratio UV", ""));
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_DecalEmission1_boarder, new GUIContent("Cutout UV Boarder", "A virtual boarder for removing decal tiling.\n Is a virtual Boarder of lower UV (x,y) to upper UV (z,w) to cutout outside of the range. Range can be outside 0 to 1."));
                    materialEditor.ShaderProperty(_DecalEmission1_pivotR, new GUIContent("UV Rotate Pivot", "UV location to Rotate with. xy: (0.5, 0.5) means center of texture."));
                    materialEditor.ShaderProperty(_DecalEmission1_pivotS, new GUIContent("UV Scale Pivot", "UV location to Scale with. xy: (0.5, 0.5) means center of texture."));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Hard Mask:");
                materialEditor.ShaderProperty(_emissionUseMask, new GUIContent("Use Mask", ""));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("Area mask (G)", "A stronger override mask. If set bright areas will only glow. Can use this for pairing with Color Tint textures."), _EmissionColorTex, _uvSet_emissionMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_EmissionColorTex);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_emissiveUseMainTexA, new GUIContent("├ Or Use MainTexure (A)", ""));
                materialEditor.ShaderProperty(_emissionUseMaskDiffuseDimming, new GUIContent("└ Mask Dims Diffuse", ""));
                EditorGUI.indentLevel--;

                // ACLStyles.PartingLine();
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Options:");
                materialEditor.TexturePropertySingleLine(new GUIContent("CRT Driver Emission", "Drives Emission with a updating, Realtime set, Custom Render Texture"), _driverTintTex, _uvSet_driverTintTex);
                materialEditor.ShaderProperty(_emissionProportionalLum, new GUIContent("Adaptive Lum", "For Unrealistic proportional glow to world brightness. Scales color to the average lighting. You might want intensity higher than Emission Color's HDR intensity."));
                materialEditor.ShaderProperty(_useEmissionHSVI, new GUIContent("Use Color Mods:", ""));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("├ Mask", ""), _emissionHSVIMask);
                materialEditor.ShaderProperty(_emissionHSVIController1, new GUIContent("└ Mod HSVI(XYZW)", "Modify: Hue, Saturate, Value, Intenity"));
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_emissionMixTintDiffuseSlider, new GUIContent("Mix Diffuse Color", ""));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_emisLightSourceType, new GUIContent("└ Diffuse Source:", "Other than MainTex, other source texures must be calibrated under Diffuse Extra textures settings."));
                EditorGUI.indentLevel--;
                // materialEditor.ShaderProperty(_emissiveUseMainTexCol, new GUIContent("Tint from MainTex(RGBA)", ""));
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }

            if (iscutout || iscutoutAlpha || isDither)
            {
                showAlphamask = ACLStyles.ShurikenFoldout("Alpha Settings", showAlphamask);
                if (showAlphamask)
                {
                    BoxGUIBegin(guiBox);
                    ACLStyles.PartingLine();
                    if (iscutoutAlpha || isGrabPass)
                    {
                        EditorGUILayout.LabelField("■");
                        materialEditor.ShaderProperty(_ZWrite, new GUIContent("ZWrite", "Depth sorting. Recommend Off for alpha mesh that does not overlay self.\nOn: when strange sort layering happens.\nUsing Transparency Render Queue requires having this off."));
                        materialEditor.ShaderProperty(_useAlphaDepthWrite, new GUIContent("BackFace Depth Write", "Helps Self-Alpha Depth sorting. Pair with ZWrite set OFF.\nRecommend On only for alpha'd mesh that overlays self, and when proper mesh & and material splitting of alpha is not working.\nOn: Will cause sorting issues with dynamic shadows and whats behind it.\nSet Render Queue to Transparency for best ordering."));
                    }
                    EditorGUILayout.LabelField("■");
                    materialEditor.ShaderProperty(_IsBaseMapAlphaAsClippingMask, new GUIContent("Alpha Mask Source", "Main Texture: The typical source alpha.\nClipping mask: Use a swappable alpha mask if you reuse a Diffuse Main Texture that wants variant alpha cutout zones... such as outfit masking."));
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("Clipping mask (G)", "If used. As a Alpha Mask Black 0.0 is invisible"), _ClippingMask, _uvSet_clippingMask);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_ClippingMask);
                    EditorGUI.indentLevel--;
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■");
                    materialEditor.ShaderProperty(_Inverse_Clipping, new GUIContent("Inverse Alpha", ""));
                    materialEditor.ShaderProperty(_Clipping_Level, new GUIContent("Cutout level", "Clip out mesh were alpha is below this."));
                    materialEditor.ShaderProperty(_Tweak_transparency, new GUIContent("Tweak Alpha", "Fine tune visible alpha. Good for Dithering adjustment."));
                    if (iscutoutAlpha)
                    {
                        EditorGUILayout.LabelField("■");
                        materialEditor.ShaderProperty(_UseSpecAlpha, new GUIContent("Specular Alpha Mode", "Make specular reflections visible as a PBR effect.\nAlpha: Alpha only drives visibility.\nReflect: PBR like glass, shine is visible no matter how transparent.\nRecommend Reflect mode paired with Render Queue set to Transparent for PBR consistency."));
                    }
                    EditorGUILayout.LabelField("■");
                    materialEditor.ShaderProperty(_DetachShadowClipping, new GUIContent("Split Shadow Cutout", "Control for dynamic shadows on alpha mesh. Designed so avatar effects like \"Blushes\" or \"Emotes panels\" do not artifact to dynamic shadow."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_Clipping_Level_Shadow, new GUIContent("└ Shadow Cutout level", "Proportional to Cutout level."));
                    EditorGUI.indentLevel--;
                    ACLStyles.PartingLine();
                    BoxGUIEnd();
                }
            }

            if (isOutline)
            {
                showOutline = ACLStyles.ShurikenFoldout("Toon Outline Controls", showOutline);
                if (showOutline)
                {
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_useOutline, new GUIContent("Use Outlines", ""));
                    ACLStyles.PartingLine();
                    EditorGUILayout.LabelField("■ Colors:");
                    materialEditor.ShaderProperty(_Outline_Color, new GUIContent("Outline Color", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_Is_BlendBaseColor, new GUIContent("Use Main Tex", ""));
                    materialEditor.ShaderProperty(_Is_OutlineTex, new GUIContent("Use Outline Tex", ""));
                    EditorGUI.indentLevel--;
                    materialEditor.TexturePropertySingleLine(new GUIContent("└ Outline Albedo(RGB)", ""), _OutlineTex);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_Outline_Sampler);
                    EditorGUI.indentLevel--;
                    showOutlineEmission = ACLStyles.ShurikenFoldout("Outline Emission Controls", showOutlineEmission, EditorGUI.indentLevel);
                    if (showOutlineEmission)
                    {
                        BoxGUIBegin(guiBox);
                        EditorGUILayout.LabelField("■ Emission Controls:");
                        materialEditor.ShaderProperty(_outlineEmissionColor, new GUIContent("Emission Color", ""));
                        materialEditor.TexturePropertySingleLine(new GUIContent("Emission Tint(RGBA)", ""), _outlineEmissionTint);
                        EditorGUI.indentLevel++;
                        materialEditor.TextureScaleOffsetProperty(_outlineEmissionTint);
                        EditorGUI.indentLevel--;
                        EditorGUILayout.LabelField("■ Emission Mask:");
                        materialEditor.ShaderProperty(_outlineEmissionUseMask, new GUIContent("Use Mask:", ""));
                        EditorGUI.indentLevel++;
                        materialEditor.TexturePropertySingleLine(new GUIContent("└ Mask(G)", ""), _outlineEmissionMask);
                        EditorGUI.indentLevel++;
                        materialEditor.TextureScaleOffsetProperty(_outlineEmissionMask);
                        EditorGUI.indentLevel--;
                        EditorGUI.indentLevel--;
                        materialEditor.ShaderProperty(_outlineEmissiveProportionalLum, new GUIContent("Proportional Lumination", ""));
                        EditorGUI.indentLevel--;
                        BoxGUIEnd();
                    }
                    EditorGUILayout.LabelField("");
                    EditorGUILayout.LabelField("■ Shape Controls:");
                    materialEditor.TexturePropertySingleLine(new GUIContent("Thickness Mask(R)", "White: Full thickness, 50%: Half, 0%: Clips out."), _Outline_Sampler);
                    materialEditor.ShaderProperty(_Outline_Width, new GUIContent("Outline Thickness", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_Farthest_Distance, new GUIContent("├ Near Distance", "Surface to camera distance less than this have zero thickness."));
                    materialEditor.ShaderProperty(_Nearest_Distance,  new GUIContent("└ Far Distance", "Surface to camera distance greater than this have full thickness."));
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_Offset_Z, new GUIContent("Camera Depth", "Pulls Outline towards/away from camera for depth sorting. Do use small values."));
                    EditorGUILayout.LabelField("");
                    if (iscutoutAlpha || isDither)
                    {
                        EditorGUILayout.LabelField("■ Alpha Controls:");
                        materialEditor.ShaderProperty(_fillOutlineDepth, new GUIContent("Depth Fill Outlines", "For alpha and outlines:\nEnable to prevent seeing outlines on back-facing mesh.\nDisable when seeing weird sorting and lighting issues."));
                        materialEditor.ShaderProperty(_seperateOutlineAlphaTweak, new GUIContent("Use Alpha Tweak", ""));
                        EditorGUI.indentLevel++;
                        materialEditor.ShaderProperty(_Tweak_transparencyOutlines, new GUIContent("└ Tweak Outline Alpha", ""));
                        EditorGUI.indentLevel--;
                    }
                    else
                    {
                        EditorGUILayout.LabelField("■ Alpha Controls: N/A");
                    }
                    ACLStyles.PartingLine();
                    BoxGUIEnd();
                }
            }

            if (isGrabPass)
            {
                showGrabPassEffects = ACLStyles.ShurikenFoldout("GrabPass Effects", showGrabPassEffects);
                if (showGrabPassEffects)
                {
                    BoxGUIBegin(guiBox);
                    ACLStyles.PartingLine();
                    // EditorGUILayout.HelpBox("", MessageType.Info, true);
                    EditorGUILayout.LabelField("■ GrabPass Mix:");
                    // EditorGUILayout.LabelField("■ Blend & Dynamic Shadow Depth Controls:");
                    materialEditor.ShaderProperty(_grabPassMix, new GUIContent("GrabPass Mix", "How much to mix against Diffuse layer."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_depthBufferCutout, new GUIContent("└ Dynamic Shadows Clip", "This setting controls the cutout of where the shadow appears on the model in the grabpass area. This is deigned for grabpass effects set in AlphaTest queue and thus supporting Dynamic shadows.\nLower under 1.001 for the mesh to block Dynamic Shadows. \nHave a directional light with shadows hit the mesh as you adjust this."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_useGrabPassHardCut, new GUIContent("├ Hard GrabPass Cutout Mix", "Changes Grabpass Mix results with a cutout blend.\nHelps support hybrid mixing of Dynamic Shadows with a hard cutout mix of Grabpass image with diffuse.\nUse this to align perfect haul clipping of Dynamic Shadows on mesh."));
                    materialEditor.ShaderProperty(_grabPassOverBrightnessClamp, new GUIContent("└ Brightness Limiter", "When GrabPass shader is in AlphaTest queue, skybox rendering behind may blur and BLOOM.\nUse this to Clamp the GrapPass image brightness under bloom levels."));
                    EditorGUI.indentLevel--;
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("");
                    EditorGUILayout.LabelField("GrabPass Effects Mask:");
                    materialEditor.TexturePropertySingleLine(new GUIContent("GrapPass Mask (RBA)", "Channels: Red: Mix, Blue: Distortion, Alpha:Blur"), _grabPassMask, _uvSet_grabPassMask);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_grabPassMask);
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("");
                    EditorGUILayout.LabelField("■ GrabPass Tint:");
                    materialEditor.ShaderProperty(_grabPassTint, new GUIContent("Tint", ""));
                    materialEditor.ShaderProperty(_grabPassMixAlbedo, new GUIContent(" Mix Albedo Tint", ""));
                    materialEditor.TexturePropertySingleLine(new GUIContent(" Tint Texture (RGB)", ""), _grabPassTintTex, _uvSet_grabPassTintTex);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_grabPassTintTex);
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("");
                    EditorGUILayout.LabelField("■ GrabPass Depth Or Distortion Options:");
                    materialEditor.ShaderProperty(_useBlurDepth, new GUIContent("Select Effect:", "These effects are mutual due to how the Depth Buffer does not align with distortion effects."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_useDepthEffects, new GUIContent("└ Use Depth Buffer:", "Uncheck if you want no depth buffer effect support.\bDepth Buffer is used to prevent objects in front of the mesh from blurring on the grabpass."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_depthFactor, new GUIContent("├ Depth Scale", "Adjusts scaling of depth buffer."));
                    materialEditor.ShaderProperty(_depthPow, new GUIContent("└ Depth Power", "Adjusts scaling of depth buffer."));
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("");
                    EditorGUILayout.LabelField("■ Distortion Controls:");
                    materialEditor.ShaderProperty(_IORStrength, new GUIContent("Distortion Strength", "How far distortion shifts the screen image.\nUsage is like thickness of a fish tank glass panel."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_IOR, new GUIContent("IOR Value", "Index of Refraction. See online for reasonable IOR values. IOR here controls how much light bends or slows down as light hits the material."));
                    EditorGUI.indentLevel--;
                    materialEditor.TexturePropertySingleLine(new GUIContent("Distortion BumpMap", "Bends the surface Normal for Distortion"), _distortionBumpMap, _distortionBumpMapScale, _uvSet_distortionBumpMap);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_distortionBumpMap);
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("");
                    EditorGUILayout.LabelField("■ Blur/Frosted Effect Controls:");
                    materialEditor.ShaderProperty(_blurWidth, new GUIContent("Blur Width", "UV Screen Width of the blur. Scales to UV of the screen of (0,0) to (1,1). Too high or low makes inefficient scale or blockly artifacts."));
                    materialEditor.ShaderProperty(_sigma, new GUIContent("Sigma", "Controls Gaussian Blur Bell Curve width for sampling area to blur."));
                    EditorGUI.indentLevel--;
                    ACLStyles.PartingLine();
                    BoxGUIEnd();
                }
            }

            // ACLStyles.PartingLine();
            //  EditorGUILayout.LabelField("- -");
            // showGeneralMasks = ACLStyles.ShurikenFoldout("General Effect Masks", showGeneralMasks);
            // if (showGeneralMasks)
            // {

            // }

            showNormalmap = ACLStyles.ShurikenFoldout("Normal Maps", showNormalmap);
            if (showNormalmap)
            {
                BoxGUIBegin(guiBox);
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map", ""), _NormalMap, _BumpScale, _uvSet_normalmap);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_NormalMap);
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("■");
                materialEditor.ShaderProperty(_DetailNormalMapScale01, new GUIContent("Detail Scaling", "None 0.0 enables the Detail Normal Map."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("Detail Normal Map", ""), _NormalMapDetail, _DetailNormalMapScale, _uvSet_NormalMapDetail);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_NormalMapDetail);
                EditorGUI.indentLevel--;
                materialEditor.TexturePropertySingleLine(new GUIContent("Detail Mask (G)", ""), _DetailNormalMask, _uvSet_detailNormalMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_DetailNormalMask);
                EditorGUI.indentLevel-=2;
                EditorGUILayout.LabelField("■");
                materialEditor.ShaderProperty(_Is_NormalMapToBase, new GUIContent("Apply to Diffuse", ""));
                materialEditor.ShaderProperty(_Is_NormalMapToHighColor, new GUIContent("Apply to Specular", ""));
                materialEditor.ShaderProperty(_Is_NormalMapToRimLight, new GUIContent("Apply to Rim Lights", "When used alone can allow a NPR \"weavy\" rim effect."));
                materialEditor.ShaderProperty(_Is_NormaMapToEnv, new GUIContent("Apply to Cubemap", "Disable for a cheap NPR glossy effect against normalmapped others."));
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }

            showDetailTextures = ACLStyles.ShurikenFoldout("Detail Textures & Features", showDetailTextures);
            if (showDetailTextures)
            {
                BoxGUIBegin(guiBox);
                ACLStyles.PartingLine();
                showDetailMask = ACLStyles.ShurikenFoldout("Detail Masks", showDetailMask, EditorGUI.indentLevel);
                if (showDetailMask)
                {
                    BoxGUIBegin(guiBox);
                    // EditorGUILayout.LabelField("■ Intensity:");
                    materialEditor.ShaderProperty(_DetailAlbedo, new GUIContent("Albedo Intensity", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("Detail Map (RGB)", "Multiplies on alebedo (Main Texture), 50% means nothing."), _DetailMap, _uvSet_DetailMap);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_DetailMap);
                    EditorGUI.indentLevel--;
                    materialEditor.TexturePropertySingleLine(new GUIContent("DetailMask (R)", "Masks the Detail Map"), _DetailMask);
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                showDecal = ACLStyles.ShurikenFoldout("Decals", showDecal, EditorGUI.indentLevel);
                if (showDecal)
                {
                    BoxGUIBegin(guiBox);
                    EditorGUILayout.LabelField("■ Decal 1:");
                    materialEditor.ShaderProperty(_useDecal1, new GUIContent("Use Decal 1", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_decal1_blendAmount, new GUIContent("Blend", "Mixes Decal in"));
                    materialEditor.TexturePropertySingleLine(new GUIContent("Decal 1 Tex", ""), _decal1, _uvSet_decal1);
                    materialEditor.ShaderProperty(_decal1_color, new GUIContent("Color", ""));
                    materialEditor.ShaderProperty(_decal1_blendMode, new GUIContent("Blend Mode:", "Color Blend mode"));
                    materialEditor.ShaderProperty(_decal1_usePremultiplyAlpha, new GUIContent("Premultiply Alpha", "Use decal's alpha channel"));
                    materialEditor.ShaderProperty(_decal1_cutoff, new GUIContent("Alpha Cutoff", "Alpha Cutoff"));
                    materialEditor.ShaderProperty(_decal1_transform, new GUIContent("transform", "UV offset: x=U, y=V.  Z and W is slant over UV"));
                    materialEditor.ShaderProperty(_decal1_rotate, new GUIContent("Rotate", ""));
                    materialEditor.ShaderProperty(_decal1_scale, new GUIContent("Scale", "Smaller to decimals means bigger"));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_decal1_ratioWH, new GUIContent("Scale Ratio UV", ""));
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_decal1_boarder, new GUIContent("Cutout UV Boarder", "A virtual boarder for removing decal tiling.\n Is a virtual Boarder of lower UV (x,y) to upper UV (z,w) to cutout outside of the range. Range can be outside 0 to 1."));
                    materialEditor.ShaderProperty(_decal1_pivotR, new GUIContent("UV Rotate Pivot", "UV location to Rotate with. xy: (0.5, 0.5) means center of texture."));
                    materialEditor.ShaderProperty(_decal1_pivotS, new GUIContent("UV Scale Pivot", "UV location to Scale with. xy: (0.5, 0.5) means center of texture."));
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■ Decal 2:");
                    materialEditor.ShaderProperty(_useDecal2, new GUIContent("Use Decal 2", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_decal2_blendAmount, new GUIContent("Blend", "Mixes Decal in"));
                    materialEditor.TexturePropertySingleLine(new GUIContent("Decal 2 Tex", ""), _decal2, _uvSet_decal2);
                    materialEditor.ShaderProperty(_decal2_color, new GUIContent("Color", ""));
                    materialEditor.ShaderProperty(_decal2_blendMode, new GUIContent("Blend Mode:", "Color Blend mode"));
                    materialEditor.ShaderProperty(_decal2_usePremultiplyAlpha, new GUIContent("Premultiply Alpha", "Use decal's alpha channel"));
                    materialEditor.ShaderProperty(_decal2_cutoff, new GUIContent("Alpha Cutoff", "Alpha Cutoff"));
                    materialEditor.ShaderProperty(_decal2_transform, new GUIContent("transform", "UV offset: x=U, y=V.  Z and W is slant over UV"));
                    materialEditor.ShaderProperty(_decal2_rotate, new GUIContent("Rotate", ""));
                    materialEditor.ShaderProperty(_decal2_scale, new GUIContent("Scale", "Smaller to decimals means bigger"));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_decal2_ratioWH, new GUIContent("Scale Ratio UV", ""));
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_decal2_boarder, new GUIContent("Cutout UV Boarder", "A virtual boarder for removing decal tiling.\nIs a virtual Boarder of lower UV (x,y) to upper UV (z,w) to cutout outside of the range. Range can be outside 0 to 1."));
                    materialEditor.ShaderProperty(_decal2_pivotR, new GUIContent("UV Rotate Pivot", "UV location to Rotate with. xy: (0.5, 0.5) means center of texture."));
                    materialEditor.ShaderProperty(_decal2_pivotS, new GUIContent("UV Scale Pivot", "UV location to Scale with. xy: (0.5, 0.5) means center of texture."));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                showInventory = ACLStyles.ShurikenFoldout("Item Inventory", showInventory, EditorGUI.indentLevel);
                if (showInventory){
                    BoxGUIBegin(guiBox);
                    materialEditor.ShaderProperty(_UseInventory, new GUIContent("Use Inventory:"));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_InventoryStride, new GUIContent("├ Inventory Stride"));
                    materialEditor.ShaderProperty(_InventoryItem01Animated, new GUIContent("├ Item 01"));
                    materialEditor.ShaderProperty(_InventoryItem02Animated, new GUIContent("├ Item 02"));
                    materialEditor.ShaderProperty(_InventoryItem03Animated, new GUIContent("├ Item 03"));
                    materialEditor.ShaderProperty(_InventoryItem04Animated, new GUIContent("├ Item 04"));
                    materialEditor.ShaderProperty(_InventoryItem05Animated, new GUIContent("├ Item 05"));
                    materialEditor.ShaderProperty(_InventoryItem06Animated, new GUIContent("├ Item 06"));
                    materialEditor.ShaderProperty(_InventoryItem07Animated, new GUIContent("├ Item 07"));
                    materialEditor.ShaderProperty(_InventoryItem08Animated, new GUIContent("├ Item 08"));
                    materialEditor.ShaderProperty(_InventoryItem09Animated, new GUIContent("├ Item 09"));
                    materialEditor.ShaderProperty(_InventoryItem10Animated, new GUIContent("├ Item 10"));
                    materialEditor.ShaderProperty(_InventoryItem11Animated, new GUIContent("├ Item 11"));
                    materialEditor.ShaderProperty(_InventoryItem12Animated, new GUIContent("├ Item 12"));
                    materialEditor.ShaderProperty(_InventoryItem13Animated, new GUIContent("├ Item 13"));
                    materialEditor.ShaderProperty(_InventoryItem14Animated, new GUIContent("├ Item 14"));
                    materialEditor.ShaderProperty(_InventoryItem15Animated, new GUIContent("├ Item 15"));
                    materialEditor.ShaderProperty(_InventoryItem16Animated, new GUIContent("└ Item 16"));
                    EditorGUI.indentLevel--;
                    BoxGUIEnd();
                }
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }

            // ACLStyles.PartingLine();
            //  EditorGUILayout.LabelField("- -");
            showLightingBehaviour = ACLStyles.ShurikenFoldout("General Lighting Behaviour", showLightingBehaviour);
            if (showLightingBehaviour)
            {
                BoxGUIBegin(guiBox);
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_CullMode, new GUIContent("Cull Mode", "Culling backward/forward/no faces"));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_backFaceColorTint, new GUIContent("└ Backface Color Tint", "Back face color. Use to tint backfaces in certain mesh setups.\nRecommend creating actual backface mesh as backfaces reveals depth sorting issues and line artifacts."));
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Direct Light Adjustments:");
                materialEditor.ShaderProperty(_directLightIntensity, new GUIContent("Direct Light Intensity", "Soft counter for overbright maps. Dim direct light sources and thus rely more on map ambient."));
                materialEditor.ShaderProperty(_shadowCastMin_black, new GUIContent("Dynamic Shadows Removal", "Counters undesirable hard dynamic shadow constrasts for NPR styles in maps with strong direct:ambient light contrasts.\nModifies direct light dynamic shadows behaviour: Each Directional/Point/Spot light in the scene has its own shadow settings and this slider at 1.0 \"brightens\" shadows away.\nUse 0.0 for intended PBR."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("Dynamic Shadows Mask (G)", "Works like Realtime Shadows Removal. Texture brightness removes like the slider value."), _DynamicShadowMask);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_shadowUseCustomRampNDL, new GUIContent("Use Direct Falloff","Force natural PBR Dynamic Light falloff from light. This falloff is also natural Dynamic Shadow."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_shadowNDLStep,new GUIContent("├ Step","Angle Falloff begins.\nRecommend setting so complete shadow is perpendicular to light.\nDefault: 1. NPR: 0.52"));
                materialEditor.ShaderProperty(_shadowNDLFeather,new GUIContent("└ Feather","Softness of falloff. Recommend adjesting so complete shadow is perpendicular to light.\nDefault: 0.5. NPR: 0.025"));
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Shadow Filters:");
                materialEditor.ShaderProperty(_shadowSplits,new GUIContent("Shadow Steps","Use this for stylizing NPR by settings \"Steps\" of intensity."));
                materialEditor.ShaderProperty(_shadowMaskPinch,new GUIContent("Shadow Pinch","\"Pinches\" the frindge zone were shadow transitions from nothing to complete.\nUse this to stylize shadow as NPR."));
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Shadow On Speculars:");
                materialEditor.ShaderProperty(_TweakHighColorOnShadow, new GUIContent("Specular Shadow Reactivity", "Affects Shine lobe's dimming in dynamic shadow. 0.0 is ignore dynamic shadows completely."));
                materialEditor.ShaderProperty(_TweakMatCapOnShadow, new GUIContent("Specular Matcap Shadow Reactivity", "Specular matcaps visibility in dynamic shadow. This depends on context looking like it reacts to direct light or not. 0.0 ignores masking by dynamic shadows."));
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Indirect Light Adjustments:");
                materialEditor.ShaderProperty(_indirectAlbedoMaxAveScale, new GUIContent("Static GI Max:Ave", "How overall Indirect light is sampled by object, abstracted to two sources \"Max\" or \"Average\" color, is used on Diffuse (Toon Ramping).\n1: Use Max color with Average intelligently.\n>1:Strongly switch to Average color as Max color scales brighter, which matches a few NPR shaders behaviour and darkness."));
                materialEditor.ShaderProperty(_indirectGIDirectionalMix, new GUIContent("Indirect GI Directionality", "How Indirect light is sampled in the scene.\n0: Use a simple statistical color by object position.\n1: Use surface angle to light, which is PBR."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_indirectGIDirectionalUseNPR, new GUIContent("├ Use NPR Method", "Blend GI's lightprobes sample (directional) based on objects center towards mesh positions as a tangent ray.\nRequires Root Bone Transform to be setup and set correctly matching around the avatars: hip, spin, or chest bone, as a origin to sample from."));
                materialEditor.ShaderProperty(_indirectGIBlur, new GUIContent("└ Angular GI Blur", "Default 1.\nRaise to blur Indirect GI and reduce distinctness of surface angle. Good for converting Indirect GI from PRB to NPR."));
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ Direction Vectors:");
                materialEditor.ShaderProperty(_eyeStereoViewDirMode, new GUIContent("Eye(s) Direction Mode", "Changes source direction of the camera from eyes. Used for adjusting Toony effects too sharp for the eyes.\n'Between' is good for reducing stereo effects that are harsh for the eye, for example specular shine (sharp) and rim light (sharp).\nPer eye is natural and best representation of PBR."));
                EditorGUILayout.LabelField("");
                EditorGUILayout.LabelField("■ World Brightness Controls:");
                materialEditor.ShaderProperty(_useDistanceDarken, new GUIContent("Contact Darken", "Darkens surface the closer you are. Helpful for immersive headpats and close contact."));
                materialEditor.ShaderProperty(_forceLightClamp, new GUIContent("Scene Light Clamping", "Hard Counter for overbright maps.\nHDR: When map has correctly setup \"Exposure High Definition Range (HDR)\": balancing brightness with post proccess in a realistic range.\nLimit: Prevention when map overblows your avatar colors or you glow. These maps typically attempted \"Low Definition Range (LDR)\" light levelling, were it assumes scene lights are never over 100% white and toon shaders may clamp to 100% as enforcement rule, and that only emission light goes over 100% which causes bloom."));
                if (!(iscutoutAlpha))
                {
                    materialEditor.ShaderProperty(_BlendOp, new GUIContent("Additional Lights Blending", "How realtime Point and Spot lights combine color.\nRecommend MAX for NPR lighting that reduces overblowing color in none \"Exposure HDR\" maps (See Scene Light clamping for def).\nAdd: PBR,If you trust the maps lighting set for correct light adding.\nNot usable in Alpha Transparent due to Premultiply alpha blending needing ADD."));
                }
                else
                {
                    EditorGUILayout.LabelField("[Disabled] Additional Lights Blending");
                }
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }
            //
            if (isPen)
            {
                showPen = ACLStyles.ShurikenFoldout("DPS System", showPen);
                if (showPen)
                { 
                    BoxGUIBegin(guiBox);
                    ACLStyles.PartingLine();
                    materialEditor.ShaderProperty(_PenetratorEnabled, new GUIContent("Use Penetrator"));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_squeeze, new GUIContent("Squeeze"));
                    materialEditor.ShaderProperty(_SqueezeDist, new GUIContent("SqueezeDist"));
                    materialEditor.ShaderProperty(_BulgeOffset, new GUIContent("BulgeOffset"));
                    materialEditor.ShaderProperty(_BulgePower, new GUIContent("BulgePower"));
                    materialEditor.ShaderProperty(_Length, new GUIContent("Penetrator Length"));
                    materialEditor.ShaderProperty(_EntranceStiffness, new GUIContent("EntranceStiffness"));
                    materialEditor.ShaderProperty(_Curvature, new GUIContent("Curvature"));
                    materialEditor.ShaderProperty(_ReCurvature, new GUIContent("ReCurvature"));
                    materialEditor.ShaderProperty(_WriggleSpeed, new GUIContent("WriggleSpeed"));
                    materialEditor.ShaderProperty(_Wriggle, new GUIContent("Wriggle"));
                    materialEditor.ShaderProperty(_OrificeChannel, new GUIContent("OrificeChannel Please Use 0"));
                    EditorGUI.indentLevel--;
                    ACLStyles.PartingLine();
                    BoxGUIEnd();
                } 
            }
            //
            showAnimatable = ACLStyles.ShurikenFoldout("Animatable Properties", showAnimatable);
            if (showAnimatable)
            {
                BoxGUIBegin(guiBox);
                ACLStyles.PartingLine();
                EditorGUILayout.HelpBox("Properties set animated below will be adjustable when the material is locked.", MessageType.Info, true);
                // EditorGUILayout.HelpBox("When Replace Animated Parameters is on, you must animate with the locked-material version so those unique properties are used instead of original properties.", MessageType.Info, true);
                // materialEditor.ShaderProperty(_ReplaceAnimatedParameters, new GUIContent("Replace Animated Parameters","Enable to make these Animatable Parameters unique to this material.\nAnimating these Paramaters must be referenced/used when this material is locked."));
                EditorGUILayout.LabelField("■ Diffuse:");
                materialEditor.ShaderProperty(_ColorAnimated, new GUIContent("_ColorAnimated"));
                materialEditor.ShaderProperty(_controllerAlbedoHSVI_1Animated, new GUIContent("_controllerAlbedoHSVI_1Animated"));
                materialEditor.ShaderProperty(_controllerAlbedoHSVI_2Animated, new GUIContent("_controllerAlbedoHSVI_2Animated"));
                materialEditor.ShaderProperty(_controllerAlbedoHSVI_3Animated, new GUIContent("_controllerAlbedoHSVI_3Animated"));
                EditorGUILayout.LabelField("■ Specular:");
                materialEditor.ShaderProperty(_SpecColorAnimated, new GUIContent("_SpecColorAnimated"));
                materialEditor.ShaderProperty(_GlossinessAnimated, new GUIContent("_GlossinessAnimated"));
                materialEditor.ShaderProperty(_SpecularMaskHSVAnimated, new GUIContent("_SpecularMaskHSVAnimated"));
                EditorGUILayout.LabelField("■ Cubemap:");
                materialEditor.ShaderProperty(_CubemapFallbackModeAnimated, new GUIContent("_CubemapFallbackModeAnimated"));
                EditorGUILayout.LabelField("■ Decals:");
                materialEditor.ShaderProperty(_decal1_blendAmountAnimated, new GUIContent("_decal1_blendAmountAnimated"));
                materialEditor.ShaderProperty(_decal2_blendAmountAnimated, new GUIContent("_decal2_blendAmountAnimated"));
                EditorGUILayout.LabelField("■ Decals Emission:");
                materialEditor.ShaderProperty(_DecalEmission1_blendAmountAnimated, new GUIContent("_DecalEmission1_blendAmountAnimated"));
                EditorGUILayout.LabelField("■ Emission:");
                materialEditor.ShaderProperty(_emissionHSVIController1Animated, new GUIContent("_emissionHSVIController1Animated"));
                EditorGUILayout.LabelField("■ General Lighting:");
                materialEditor.ShaderProperty(_shadowCastMin_blackAnimated, new GUIContent("_shadowCastMin_blackAnimated"));
                materialEditor.ShaderProperty(_directLightIntensityAnimated, new GUIContent("_directLightIntensityAnimated"));
                materialEditor.ShaderProperty(_indirectAlbedoMaxAveScaleAnimated, new GUIContent("_indirectAlbedoMaxAveScaleAnimated"));
                materialEditor.ShaderProperty(_useDistanceDarkenAnimated, new GUIContent("_useDistanceDarkenAnimated"));
                materialEditor.ShaderProperty(_forceLightClampAnimated, new GUIContent("_forceLightClampAnimated"));
                EditorGUILayout.LabelField("■ Alpha:");
                materialEditor.ShaderProperty(_Tweak_transparencyAnimated, new GUIContent("_Tweak_transparencyAnimated"));
                if (isOutline)
                {
                    EditorGUILayout.LabelField("■ OutLine:");
                    materialEditor.ShaderProperty(_outlineEmissionColorAnimated, new GUIContent("_outlineEmissionColorAnimated"));
                }
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }
            showStencilHelpers = ACLStyles.ShurikenFoldout("Stencil Settings", showStencilHelpers);
            if (showStencilHelpers)
            {
                BoxGUIBegin(guiBox);
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_Stencil, new GUIContent("Reference Num", ""));
                materialEditor.ShaderProperty(_StencilComp, new GUIContent("Compare" , ""));
                materialEditor.ShaderProperty(_StencilOp, new GUIContent("Pass", ""));
                materialEditor.ShaderProperty(_StencilFail, new GUIContent("Fail", ""));
                EditorGUILayout.HelpBox("For typical NPR stencil effects like \"Eyes over hair\".\n1st material (eyes/lashes): Same ref Num / Comp:Always / Pass:Replace / Fail:Replace\n2nd material (Hair): Same ref Num / Comp:NotEqual / Pass:Keep / Fail:Keep\nRender Queue 2nd material after 1st.", MessageType.None, true);
                ACLStyles.PartingLine();
                BoxGUIEnd();
            }
            if (isGrabPass)
            {
                EditorGUILayout.HelpBox("For best GrabPass sorting and layering, please set the queue of ACLS Alpha Queue Shaders a smaller number (at least 1 less queue number), or set this Grabpass shader to Transparency Queue (2501 or higher).", MessageType.Info, true);
            }
            materialEditor.RenderQueueField();
            if (_ShaderOptimizerEnabled.floatValue == 1)
            {
                // EditorGUI.EndDisabledGroup();
                EditorGUILayout.HelpBox("WARNING: SHADER IS LOCKED BY THE LOCK BUTTON AND BAKED IN.\nONLY ENABLED-ANIMATABLE PROPERTIES WILL RESPOND.", MessageType.Warning, true);

            }
            ACLStyles.DrawButtons(material);
        }
        
    }
    
    private static void ShaderOptimizerButton(MaterialProperty shaderOptimizer, MaterialEditor materialEditor)
    {
        EditorGUI.BeginChangeCheck();
        GUILayout.Button(shaderOptimizer.floatValue == 0 ? "Lock in optimized Shader" : "Unlock from optimized Shader");
        if (EditorGUI.EndChangeCheck())
        {
            shaderOptimizer.floatValue = shaderOptimizer.floatValue == 1 ? 0 : 1;
            if (shaderOptimizer.floatValue == 1)
                foreach (Material m in materialEditor.targets)
                {
                    var props = MaterialEditor.GetMaterialProperties(new UnityEngine.Object[] {m});
                    if (!ShaderOptimizer.Lock(m, props))
                        m.SetFloat(shaderOptimizer.name, 0);
                }
            else
                foreach (Material m in materialEditor.targets)
                    if (!ShaderOptimizer.Unlock(m))
                        m.SetFloat(shaderOptimizer.name, 1);
        }
        EditorGUILayout.Space(4);
    }


}