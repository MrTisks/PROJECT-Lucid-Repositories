// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GS/WaterReflection"
{
	Properties
	{
		_Flipbook("Flipbook", 2D) = "white" {}
		_Tile("Tile", Range( 1 , 30)) = 0
		_Intensity("Intensity", Float) = 0
		_MaxSlope("MaxSlope", Range( -10 , 1)) = 0
		_Color("Color", Color) = (1,1,1,0)
		_Limit("Limit", Range( -10 , 10)) = 0
		_Speed("Speed", Range( 0 , 30)) = 0
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
			};

			uniform float4 _Color;
			uniform sampler2D _Flipbook;
			uniform float _Tile;
			uniform float _Speed;
			uniform float _Intensity;
			uniform float _MaxSlope;
			uniform float _Limit;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord2.xyz = ase_worldPos;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				float2 temp_cast_1 = (_Tile).xx;
				float2 uv2_g2 = i.ase_texcoord.xy * temp_cast_1 + float2( 0,0 );
				float2 appendResult9_g2 = (float2(frac( uv2_g2.x ) , frac( uv2_g2.y )));
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles15_g2 = 15.0 * 15.0;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset15_g2 = 1.0f / 15.0;
				float fbrowsoffset15_g2 = 1.0f / 15.0;
				// Speed of animation
				float fbspeed15_g2 = _Time.y * _Speed;
				// UV Tiling (col and row offset)
				float2 fbtiling15_g2 = float2(fbcolsoffset15_g2, fbrowsoffset15_g2);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex15_g2 = round( fmod( fbspeed15_g2 + 0.0, fbtotaltiles15_g2) );
				fbcurrenttileindex15_g2 += ( fbcurrenttileindex15_g2 < 0) ? fbtotaltiles15_g2 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox15_g2 = round ( fmod ( fbcurrenttileindex15_g2, 15.0 ) );
				// Multiply Offset X by coloffset
				float fboffsetx15_g2 = fblinearindextox15_g2 * fbcolsoffset15_g2;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy15_g2 = round( fmod( ( fbcurrenttileindex15_g2 - fblinearindextox15_g2 ) / 15.0, 15.0 ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy15_g2 = (int)(15.0-1) - fblinearindextoy15_g2;
				// Multiply Offset Y by rowoffset
				float fboffsety15_g2 = fblinearindextoy15_g2 * fbrowsoffset15_g2;
				// UV Offset
				float2 fboffset15_g2 = float2(fboffsetx15_g2, fboffsety15_g2);
				// Flipbook UV
				half2 fbuv15_g2 = appendResult9_g2 * fbtiling15_g2 + fboffset15_g2;
				// *** END Flipbook UV Animation vars ***
				float4 tex2DNode18_g2 = tex2D( _Flipbook, fbuv15_g2 );
				float4 temp_output_22_0_g2 = ( tex2DNode18_g2 / _Intensity );
				float4 clampResult24_g2 = clamp( temp_output_22_0_g2 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float3 lerpResult27_g2 = lerp( float3( 0,0,0 ) , _Color.rgb , clampResult24_g2.r);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float3 appendResult7_g2 = (float3(0.0 , _MaxSlope , 0.0));
				float dotResult16_g2 = dot( normalizedWorldNormal , appendResult7_g2 );
				float clampResult23_g2 = clamp( dotResult16_g2 , 0.0 , 1.0 );
				float3 ase_worldPos = i.ase_texcoord2.xyz;
				float clampResult21_g2 = clamp( ( ase_worldPos.y - _Limit ) , 0.0 , 1.0 );
				float clampResult28_g2 = clamp( ( clampResult23_g2 - clampResult21_g2 ) , 0.0 , 1.0 );
				float3 lerpResult30_g2 = lerp( float3( 0,0,0 ) , lerpResult27_g2 , clampResult28_g2);
				
				
				finalColor = float4( ( lerpResult30_g2 * 2.0 ) , 0.0 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15401
2071;31;1556;1049;1793.988;555.9429;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;7;-847,307.5;Float;False;Property;_Speed;Speed;10;0;Create;True;0;0;False;0;0;30;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-864,223.5;Float;False;Property;_MaxSlope;MaxSlope;7;0;Create;True;0;0;False;0;0;-8.88;-10;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-865,148.5;Float;False;Property;_Limit;Limit;9;0;Create;True;0;0;False;0;0;-2.43;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-837,403.5;Float;False;Property;_Tile;Tile;5;0;Create;True;0;0;False;0;0;5.3;1;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-1102,-93.5;Float;False;Property;_Color;Color;8;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-848,-147.5;Float;False;Property;_Intensity;Intensity;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;3;-400,5.5;Float;False;CausticAdditive;0;;2;7b4112c1f7b544921bffe0269d56faa6;0;6;40;FLOAT;7;False;42;FLOAT3;1,1,1;False;41;FLOAT;-6.21;False;39;FLOAT;-10;False;38;FLOAT;30;False;37;FLOAT;20;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;1;GS/WaterReflection;0770190933193b94aaa3065e307002fa;0;0;SubShader 0 Pass 0;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;-1;False;-1;-1;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;3;40;4;0
WireConnection;3;42;9;0
WireConnection;3;41;5;0
WireConnection;3;39;6;0
WireConnection;3;38;7;0
WireConnection;3;37;8;0
WireConnection;1;0;3;0
ASEEND*/
//CHKSM=E97374AE0316D1D378FAF5BF66407B546053FE2D