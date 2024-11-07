//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
#ifndef ACLS_SHADOWCASTER
#define ACLS_SHADOWCASTER
            ////
            #include "./ACLS_HELPERS.cginc"

            uniform Texture2D _MainTex; uniform float4 _MainTex_ST;
            uniform Texture2D _ClippingMask; uniform float4 _ClippingMask_ST;
#ifdef ShadowDither
            sampler3D _DitherMaskLOD;
#endif // ShadowDither

            SamplerState sampler_MainTex;
            SamplerState sampler_ClippingMask;

            uniform int _uvSet_albedo;
            uniform int _uvSet_clippingMask;

            uniform int _DetachShadowClipping;
            uniform half _Tweak_transparency;
            uniform half _Clipping_Level;
            uniform half _Clipping_Level_Shadow;
            uniform int _Inverse_Clipping;
            uniform int _IsBaseMapAlphaAsClippingMask;
            // outline
            uniform half _outline_mode;
            uniform half _Outline_Width;
            uniform half _Farthest_Distance;
            uniform half _Nearest_Distance;
            uniform half _Offset_Z;
            // depth
            Texture2D _grabPassMask; float4 _grabPassMask_ST;
            // int _DetachDepthBufferClipping;
            float _depthBufferCutout;


            struct v2f {
                // V2F_SHADOW_CASTER;
                float4 uv01         : TEXCOORD0;
                float4 uv02         : TEXCOORD1;
                float4 worldPos    : TEXCOORD2;
                float3 normalDir : TEXCOORD3;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };
            
            
            
            void vert
            (
                appdata v,
                out v2f o,
                out float4 opos : SV_POSITION
            )
            {
                // o  = (v2f)0;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                AdaptorDPS(v);

                o.uv01          = float4(v.uv0.xy, v.uv1.xy);
                o.uv02          = float4(v.uv2.xy, v.uv3.xy);
                opos = UnityObjectToClipPos(v.vertex);
                o.worldPos  = mul( unity_ObjectToWorld, v.vertex);
                o.normalDir = UnityObjectToWorldNormal( v.normal);
                float4 position = UnityClipSpaceShadowCasterPos(v.vertex, v.normal);
                o.worldPos      = UnityApplyLinearShadowBias(position);
                opos    = o.worldPos;
                //// inventory
                UNITY_BRANCH if (_UseInventory)
                {
                    float inventoryMask = getInventoryMask(v.uv0.xy);
                    UNITY_BRANCH if (!(inventoryMask))
                    {
                        opos.z = 1e+9;
                    }
                }
            }






            float4 frag(v2f i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_TARGET 
            {
                UNITY_SETUP_INSTANCE_ID(i);
#ifdef ScreenDepthDataContext // another manual cutout because alphaTest queue writes depth
                UV_DD uv_grabPassMask   = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, 0), _grabPassMask));
                float4 grabPassMask     = _grabPassMask.SampleGrad( sampler_MainTex, uv_grabPassMask.uv, uv_grabPassMask.dx, uv_grabPassMask.dy); // r:mix, b:distortion, a:blur
                clip((1 - grabPassMask.r) - _depthBufferCutout);
#endif //// ScreenDepthDataContext
#ifndef NotAlpha
                UV_DD uv_toon           = UVDD( TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_albedo), _MainTex));
                float4 mainTex          = _MainTex.SampleGrad(sampler_MainTex, uv_toon.uv, uv_toon.dx, uv_toon.dy);
                float4 clippingMaskTex  = _ClippingMask.Sample(sampler_ClippingMask, TRANSFORM_TEX( UVPick01(i.uv01, i.uv02, _uvSet_clippingMask), _ClippingMask));
                float useMainTexAlpha   = (_IsBaseMapAlphaAsClippingMask) ? mainTex.a : clippingMaskTex.r;
                float alpha             = (_Inverse_Clipping) ? (1.0 - useMainTexAlpha) : useMainTexAlpha;
                float clipTest          = (_DetachShadowClipping) ? _Clipping_Level_Shadow : _Clipping_Level;
                clip(alpha - clipTest);
                clipTest                = saturate(alpha + _Tweak_transparency);
    #ifdef ShadowDither
                uint sampleCount    = GetRenderTargetSampleCount();
                float dither    = ScreenDitherToAlphaCutout_ac(screenPos.xy, (1 - clipTest));
                alpha           = clipTest - dither;
                // alpha           = clipTest - dither/sampleCount + 1. / (sampleCount);
                clip(alpha );
    #else //// ShadowDither
                clip(clipTest);
    #endif //// ShadowDither
                // return 0;
                SHADOW_CASTER_FRAGMENT(i)
#else //// NotAlpha
                // return 0;
                SHADOW_CASTER_FRAGMENT(i)
#endif //// NotAlpha
            }
#endif // ACLS_SHADOWCASTER
