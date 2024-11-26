// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GS/StandardWaterReflections"
{
	Properties
	{
		_Flipbook("Flipbook", 2D) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_Metallic("Metallic", 2D) = "white" {}
		_Occlusion("Occlusion", 2D) = "white" {}
		_RefTile("Ref.Tile", Range( 1 , 30)) = 1
		_RefIntensity("Ref.Intensity", Range( -90 , 0.1)) = 0
		_RefSlope("Ref.Slope", Range( -10 , 1)) = 0
		_RefColour("Ref.Colour", Color) = (1,1,1,0)
		_RefLimit("Ref.Limit", Range( -10 , 10)) = 0
		_RefSpeed("Ref.Speed", Range( 0 , 30)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _RefColour;
		uniform sampler2D _Flipbook;
		uniform float _RefTile;
		uniform float _RefSpeed;
		uniform float _RefIntensity;
		uniform float _RefSlope;
		uniform float _RefLimit;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform sampler2D _Occlusion;
		uniform float4 _Occlusion_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float2 temp_cast_2 = (_RefTile).xx;
			float2 uv_TexCoord2_g4 = i.uv_texcoord * temp_cast_2;
			float2 appendResult9_g4 = (float2(frac( uv_TexCoord2_g4.x ) , frac( uv_TexCoord2_g4.y )));
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles15_g4 = 15.0 * 15.0;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset15_g4 = 1.0f / 15.0;
			float fbrowsoffset15_g4 = 1.0f / 15.0;
			// Speed of animation
			float fbspeed15_g4 = _Time.y * _RefSpeed;
			// UV Tiling (col and row offset)
			float2 fbtiling15_g4 = float2(fbcolsoffset15_g4, fbrowsoffset15_g4);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex15_g4 = round( fmod( fbspeed15_g4 + 0.0, fbtotaltiles15_g4) );
			fbcurrenttileindex15_g4 += ( fbcurrenttileindex15_g4 < 0) ? fbtotaltiles15_g4 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox15_g4 = round ( fmod ( fbcurrenttileindex15_g4, 15.0 ) );
			// Multiply Offset X by coloffset
			float fboffsetx15_g4 = fblinearindextox15_g4 * fbcolsoffset15_g4;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy15_g4 = round( fmod( ( fbcurrenttileindex15_g4 - fblinearindextox15_g4 ) / 15.0, 15.0 ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy15_g4 = (int)(15.0-1) - fblinearindextoy15_g4;
			// Multiply Offset Y by rowoffset
			float fboffsety15_g4 = fblinearindextoy15_g4 * fbrowsoffset15_g4;
			// UV Offset
			float2 fboffset15_g4 = float2(fboffsetx15_g4, fboffsety15_g4);
			// Flipbook UV
			half2 fbuv15_g4 = appendResult9_g4 * fbtiling15_g4 + fboffset15_g4;
			// *** END Flipbook UV Animation vars ***
			float4 tex2DNode18_g4 = tex2D( _Flipbook, fbuv15_g4 );
			float4 temp_output_22_0_g4 = ( tex2DNode18_g4 / ( 1.0 - _RefIntensity ) );
			float4 clampResult24_g4 = clamp( temp_output_22_0_g4 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float3 lerpResult27_g4 = lerp( float3( 0,0,0 ) , _RefColour.rgb , clampResult24_g4.r);
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 appendResult7_g4 = (float3(0.0 , _RefSlope , 0.0));
			float dotResult16_g4 = dot( ase_normWorldNormal , appendResult7_g4 );
			float clampResult23_g4 = clamp( dotResult16_g4 , 0.0 , 1.0 );
			float3 ase_worldPos = i.worldPos;
			float clampResult21_g4 = clamp( ( ase_worldPos.y - _RefLimit ) , 0.0 , 1.0 );
			float clampResult28_g4 = clamp( ( clampResult23_g4 - clampResult21_g4 ) , 0.0 , 1.0 );
			float3 lerpResult30_g4 = lerp( float3( 0,0,0 ) , lerpResult27_g4 , clampResult28_g4);
			o.Emission = ( lerpResult30_g4 * 2.0 );
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 tex2DNode13 = tex2D( _Metallic, uv_Metallic );
			o.Metallic = tex2DNode13.r;
			o.Smoothness = tex2DNode13.a;
			float2 uv_Occlusion = i.uv_texcoord * _Occlusion_ST.xy + _Occlusion_ST.zw;
			o.Occlusion = tex2D( _Occlusion, uv_Occlusion ).r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
2071;31;1556;1049;2173.851;858.1841;1.906;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-1349.886,365.5233;Float;False;Property;_RefIntensity;Ref.Intensity;10;0;Create;True;0;0;False;0;0;1;-90;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1169.886,852.5233;Float;False;Property;_RefSpeed;Ref.Speed;14;0;Create;True;0;0;False;0;0;30;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1159.886,948.5233;Float;False;Property;_RefTile;Ref.Tile;9;0;Create;True;0;0;False;0;1;5.3;1;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;16;-941.2441,395.6105;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1186.886,768.5233;Float;False;Property;_RefSlope;Ref.Slope;11;0;Create;True;0;0;False;0;0;-8.88;-10;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1187.886,693.5233;Float;False;Property;_RefLimit;Ref.Limit;13;0;Create;True;0;0;False;0;0;-2.43;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-1228.561,-417.2012;Float;True;Property;_Normal;Normal;6;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-1234.324,-624.6505;Float;True;Property;_Albedo;Albedo;5;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1247.29,-205.4302;Float;True;Property;_Metallic;Metallic;7;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;4;-1131,497.623;Float;False;Property;_RefColour;Ref.Colour;12;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;14;-1238.646,53.88089;Float;True;Property;_Occlusion;Occlusion;8;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;13;-910.1846,-179.4991;Float;True;Property;_TextureSample3;Texture Sample 3;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-901.5413,79.81198;Float;True;Property;_TextureSample4;Texture Sample 4;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-897.2193,-598.7194;Float;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-892.8973,-394.1513;Float;True;Property;_TextureSample2;Texture Sample 2;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;18;-722.8865,550.5233;Float;False;CausticAdditive;0;;4;7b4112c1f7b544921bffe0269d56faa6;0;6;40;FLOAT;7;False;42;FLOAT3;0,0,0;False;41;FLOAT;-0.6;False;39;FLOAT;-10;False;38;FLOAT;30;False;37;FLOAT;20;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;GS/StandardWaterReflections;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;1;0
WireConnection;13;0;12;0
WireConnection;15;0;14;0
WireConnection;9;0;8;0
WireConnection;11;0;10;0
WireConnection;18;40;16;0
WireConnection;18;42;4;0
WireConnection;18;41;3;0
WireConnection;18;39;6;0
WireConnection;18;38;5;0
WireConnection;18;37;2;0
WireConnection;0;0;9;0
WireConnection;0;1;11;0
WireConnection;0;2;18;0
WireConnection;0;3;13;0
WireConnection;0;4;13;4
WireConnection;0;5;15;0
ASEEND*/
//CHKSM=5F4923D4D124A3D3FD3D1269B44F44A1A52E4482