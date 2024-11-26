Shader "WACOMalt/WACOWater4" {
    Properties {
        _MainTex ("Base Color", 2D) = "white" {}
        _BaseColor2 ("Base Color 2", 2D) = "white" {}
        _BaseColorAmount ("BaseColorAmount", Range(0, 1)) = 0
        _BaseHorizSpeed ("BaseHorizSpeed", Range(-4, 4)) = 0
        _BaseVertSpeed ("BaseVertSpeed", Range(-4, 4)) = 0
        _BaseScaling ("BaseScaling", Range(0, 0.2)) = 0.1
        _BaseScalingSpeed ("BaseScalingSpeed", Range(0, 1)) = 0.2
        _Base2HorizSpeed ("Base2HorizSpeed", Range(-4, 4)) = 0
        _Base2VertSpeed ("Base2VertSpeed", Range(-4, 4)) = 0
        _Base2Scaling ("Base2Scaling", Range(0, 0.2)) = 0.1
        _Base2ScalingSpeed ("Base2ScalingSpeed", Range(0, 1)) = 0.2
        _Water1 ("Water1", 2D) = "bump" {}
        _W1HorizSpeed ("W1HorizSpeed", Range(-4, 4)) = 0
        _W1VertSpeed ("W1VertSpeed", Range(-4, 4)) = 0
        _W1Scaling ("W1Scaling", Range(0, 0.2)) = 0
        _W1ScalingSpeed ("W1ScalingSpeed", Range(0, 1)) = 0.2
        _Water2 ("Water2", 2D) = "bump" {}
        _W2HorizSpeed ("W2HorizSpeed", Range(-4, 4)) = 0
        _W2VertSpeed ("W2VertSpeed", Range(-4, 4)) = 0
        _W2Scaling ("W2Scaling", Range(0, 0.2)) = 0
        _W2ScalingSpeed ("W2ScalingSpeed", Range(0, 1)) = 0.2
        _Water3 ("Water3", 2D) = "bump" {}
        _W3HorizSpeed ("W3HorizSpeed", Range(-4, 4)) = 0
        _W3VertSpeed ("W3VertSpeed", Range(-4, 4)) = 0
        _W3Scaling ("W3Scaling", Range(0, 0.2)) = 0
        _W3ScalingSpeed ("W3ScalingSpeed", Range(0, 1)) = 0.2
        _Water4 ("Water4", 2D) = "bump" {}
        _W4HorizSpeed ("W4HorizSpeed", Range(-4, 4)) = 0
        _W4VertSpeed ("W4VertSpeed", Range(-4, 4)) = 0
        _W4Scaling ("W4Scaling", Range(0, 0.2)) = 0
        _W4ScalingSpeed ("W4ScalingSpeed", Range(0, 1)) = 0.2
        [MaterialToggle] _UseCubemap ("UseCubemap", Float ) = 0
        [MaterialToggle] _CubemapIsLatLong ("CubemapIsLatLong", Float ) = 0
        _CubeReflectionMap ("CubeReflectionMap", Cube) = "_Skybox" {}
        _LatLongReflectionMap ("LatLongReflectionMap", 2D) = "black" {}
        _fresnelexp ("fresnelexp", Range(0, 10)) = 1
        _distortion ("distortion", Range(0, 10)) = 1
        _ReflectionMip ("ReflectionMip", Range(0, 4)) = 0
        _normalIntensity ("normalIntensity", Range(-4, 4)) = 1
        _RefractionOffset ("RefractionOffset", Vector) = (0,0,0,0)
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _Water4; uniform float4 _Water4_ST;
            uniform sampler2D _Water3; uniform float4 _Water3_ST;
            uniform sampler2D _Water2; uniform float4 _Water2_ST;
            uniform sampler2D _Water1; uniform float4 _Water1_ST;
            uniform samplerCUBE _CubeReflectionMap;
            uniform float _fresnelexp;
            uniform float _W1HorizSpeed;
            uniform float _W1VertSpeed;
            uniform float _W1Scaling;
            uniform float _W1ScalingSpeed;
            uniform float _W2HorizSpeed;
            uniform float _W2VertSpeed;
            uniform float _W2Scaling;
            uniform float _W2ScalingSpeed;
            uniform float _W3HorizSpeed;
            uniform float _W3VertSpeed;
            uniform float _W3Scaling;
            uniform float _W3ScalingSpeed;
            uniform float _W4HorizSpeed;
            uniform float _W4VertSpeed;
            uniform float _W4Scaling;
            uniform float _W4ScalingSpeed;
            uniform float _BaseScaling;
            uniform float _BaseScalingSpeed;
            uniform float _BaseHorizSpeed;
            uniform float _BaseVertSpeed;
            uniform float _Base2Scaling;
            uniform float _Base2ScalingSpeed;
            uniform float _Base2HorizSpeed;
            uniform float _Base2VertSpeed;
            uniform sampler2D _BaseColor2; uniform float4 _BaseColor2_ST;
            float2 Function_node_9367( float2 uv ){
            float2 uvs = uv;
            #if UNITY_SINGLE_PASS_STEREO
            uvs = (uv.xy + float2 (unity_StereoEyeIndex,0)) * float2 (.5f,1);
            #endif
            
            return uvs;
            }
            
            uniform float _distortion;
            uniform fixed _UseCubemap;
            float3 Function_node_3815( float3 VR , float mip ){
            float4 skyData = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, VR, mip);
            return DecodeHDR (skyData, unity_SpecCube0_HDR);
            }
            
            uniform float _ReflectionMip;
            uniform float _normalIntensity;
            uniform float4 _RefractionOffset;
            uniform fixed _CubemapIsLatLong;
            uniform sampler2D _LatLongReflectionMap; uniform float4 _LatLongReflectionMap_ST;
            uniform float _BaseColorAmount;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                float4 projPos : TEXCOORD5;
                UNITY_FOG_COORDS(6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 node_1174 = _Time;
                float node_9335 = (-1.0);
                float node_6709 = 1.0;
                float node_6210 = (node_6709+(-1*_W1Scaling));
                float2 node_9743 = (((i.uv0*(node_6210 + ( (sin((node_1174.g*_W1ScalingSpeed)) - node_9335) * ((node_6709+_W1Scaling) - node_6210) ) / (node_6709 - node_9335)))+(_W1HorizSpeed*node_1174.g)*float2(1,0))+(_W1VertSpeed*node_1174.g)*float2(0,1));
                float3 _Water1_var = UnpackNormal(tex2D(_Water1,TRANSFORM_TEX(node_9743, _Water1)));
                float4 node_5192 = _Time;
                float node_5143 = (-1.0);
                float node_8519 = 1.0;
                float node_89 = (node_8519+(-1*_W2Scaling));
                float2 node_2094 = (((i.uv0*(node_89 + ( (sin((node_5192.g*_W2ScalingSpeed)) - node_5143) * ((node_8519+_W2Scaling) - node_89) ) / (node_8519 - node_5143)))+(_W2HorizSpeed*node_5192.g)*float2(1,0))+(_W2VertSpeed*node_5192.g)*float2(0,1));
                float3 _Water2_var = UnpackNormal(tex2D(_Water2,TRANSFORM_TEX(node_2094, _Water2)));
                float4 node_7151 = _Time;
                float node_801 = (-1.0);
                float node_3970 = 1.0;
                float node_6413 = (node_3970+(-1*_W3Scaling));
                float2 node_1178 = (((i.uv0*(node_6413 + ( (sin((node_7151.g*_W3ScalingSpeed)) - node_801) * ((node_3970+_W3Scaling) - node_6413) ) / (node_3970 - node_801)))+(_W3HorizSpeed*node_7151.g)*float2(1,0))+(_W3VertSpeed*node_7151.g)*float2(0,1));
                float3 _Water3_var = UnpackNormal(tex2D(_Water3,TRANSFORM_TEX(node_1178, _Water3)));
                float4 node_9500 = _Time;
                float node_4127 = (-1.0);
                float node_2619 = 1.0;
                float node_508 = (node_2619+(-1*_W4Scaling));
                float2 node_658 = (((i.uv0*(node_508 + ( (sin((node_9500.g*_W4ScalingSpeed)) - node_4127) * ((node_2619+_W4Scaling) - node_508) ) / (node_2619 - node_4127)))+(_W4HorizSpeed*node_9500.g)*float2(1,0))+(_W4VertSpeed*node_9500.g)*float2(0,1));
                float3 _Water4_var = UnpackNormal(tex2D(_Water4,TRANSFORM_TEX(node_658, _Water4)));
                float3 node_9699 = (_Water1_var.rgb+_Water2_var.rgb+_Water3_var.rgb+_Water4_var.rgb);
                float3 normalLocal = float3((node_9699.rg*_normalIntensity),node_9699.b);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
////// Lighting:
                float4 node_112 = _Time;
                float node_3539 = (-1.0);
                float node_3165 = 1.0;
                float node_3432 = (node_3165+(-1*_Base2Scaling));
                float2 node_2368 = (((i.uv0*(node_3432 + ( (sin((node_112.g*_Base2ScalingSpeed)) - node_3539) * ((node_3165+_Base2Scaling) - node_3432) ) / (node_3165 - node_3539)))+(_Base2HorizSpeed*node_112.g)*float2(1,0))+(_Base2VertSpeed*node_112.g)*float2(0,1));
                float4 _BaseColor2_var = tex2D(_BaseColor2,TRANSFORM_TEX(node_2368, _BaseColor2));
                float4 node_9396 = _Time;
                float node_9450 = (-1.0);
                float node_417 = 1.0;
                float node_2807 = (node_417+(-1*_BaseScaling));
                float2 node_6720 = (((i.uv0*(node_2807 + ( (sin((node_9396.g*_BaseScalingSpeed)) - node_9450) * ((node_417+_BaseScaling) - node_2807) ) / (node_417 - node_9450)))+(_BaseHorizSpeed*node_9396.g)*float2(1,0))+(_BaseVertSpeed*node_9396.g)*float2(0,1));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_6720, _MainTex));
                float3 node_2832 = normalize(viewReflectDirection).rgb;
                float node_9637 = 3.141592654;
                float2 node_5477 = saturate((float2((atan2(node_2832.r,node_2832.b)+node_9637),acos((-1*node_2832.g)))/float2((2.0*node_9637),node_9637)));
                float4 _LatLongReflectionMap_var = tex2Dlod(_LatLongReflectionMap,float4(TRANSFORM_TEX(node_5477, _LatLongReflectionMap),0.0,_ReflectionMip));
                float2 node_3057 = (((_Water1_var.rgb+_RefractionOffset.rgb)+(_Water2_var.rgb+_RefractionOffset.rgb)+(_Water3_var.rgb+_RefractionOffset.rgb)+(_Water4_var.rgb+_RefractionOffset.rgb)).rg*(_distortion*0.01));
                float3 finalColor = ((lerp(_BaseColor2_var.rgb,_MainTex_var.rgb,0.5)*_BaseColorAmount)+float4(lerp(lerp( Function_node_3815( viewReflectDirection , _ReflectionMip ), lerp( texCUBElod(_CubeReflectionMap,float4(viewReflectDirection,_ReflectionMip)).rgb, _LatLongReflectionMap_var.rgb, _CubemapIsLatLong ), _UseCubemap ),tex2D( _GrabTexture, Function_node_9367( (sceneUVs.rg+node_3057) )).rgb,(1.0 - pow(1.0-max(0,dot(normalDirection, viewDirection)),_fresnelexp))),1.0)).rgb;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
