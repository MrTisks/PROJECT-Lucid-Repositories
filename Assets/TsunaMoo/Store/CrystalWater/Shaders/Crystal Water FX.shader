// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TsunaMoo/Crystal Water FX"
{
	Properties
	{
		[HideInInspector]shader_is_using_thry_editor("", Float) = 0
		[HideInInspector]shader_properties_label_file("TsunaMooLabels", Float) = 0
		[HideInInspector]shader_master_label("<color=#ffffffff>Tsuna</color> <color=#000000ff>Moo</color> <color=#ffffffff>Shader</color> <color=#000000ff>Lab</color>--{texture:{name:tsuna_moo_icon,height:128}}", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Float) = 2
		[HideInInspector]Instancing("Instancing", Float) = 0
		[HideInInspector]m_MainSet("Main", Float) = 0
		_Color("Color Tint", Color) = (0,0,0,0)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Glossiness("Smoothness", Range( 0 , 1)) = 0
		_AntiAliasingVarianceSm("Anti Aliasing Variance", Range( 0 , 5)) = 5
		_AntiAliasingThresholdSm("Anti Aliasing Threshold", Range( 0 , 1)) = 0.01
		[HideInInspector]m_Flow("Flow", Float) = 0
		[NoScaleOffset]_FlowMap("Flow Map", 2D) = "white" {}
		_FlowSpeed("Flow Speed", Range( -2 , 2)) = 0
		[HideInInspector]m_Water1("Water 1", Float) = 0
		[NoScaleOffset]_WaterMap1("Water Normal Map--{reference_property:_Water1Strength}", 2D) = "white" {}
		[HideInInspector]_Water1Strength("Strength", Range( -2 , 3)) = 3
		[Vector2]_Water1Tiling("Tiling", Vector) = (1,1,0,0)
		_Water1SpeedX("Speed X", Range( -2 , 2)) = 0
		_Water1SpeedY("Speed Y", Range( -2 , 2)) = 0
		[HideInInspector]m_Water2("Water 2", Float) = 0
		[NoScaleOffset]_WaterMap2("Water Normal Map--{reference_property:_Water2Strength}", 2D) = "white" {}
		[HideInInspector]_Water2Strength("Strength", Range( -2 , 3)) = 1
		[Vector2]_Water2Tiling("Tiling", Vector) = (1,1,0,0)
		_Water2SpeedX("Speed X", Range( -2 , 2)) = 0
		_Water2SpeedY("Speed Y", Range( -2 , 2)) = 0
		[HideInInspector]footer_discord("", Float) = 0
		[HideInInspector]footer_booth("", Float) = 0
		[HideInInspector]footer_github("", Float) = 0
		[HideInInspector]footer_patreon("", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull [_Cull]
		Blend One One
		BlendOp Add
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Standard keepalpha noshadow nolightmap  nodynlightmap nodirlightmap 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float shader_properties_label_file;
		uniform float shader_is_using_thry_editor;
		uniform float shader_master_label;
		uniform float footer_discord;
		uniform float footer_patreon;
		uniform float footer_github;
		uniform float m_Water1;
		uniform float _Cull;
		uniform float m_Flow;
		uniform float m_Water2;
		uniform float m_MainSet;
		uniform float footer_booth;
		uniform float Instancing;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_WaterMap1);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_FlowMap);
		uniform float4 _FlowMap_ST;
		SamplerState sampler_FlowMap;
		uniform float _FlowSpeed;
		uniform float2 _Water1Tiling;
		uniform float _Water1SpeedX;
		uniform float _Water1SpeedY;
		SamplerState sampler_linear_repeat;
		uniform float _Water1Strength;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_WaterMap2);
		uniform float _Water2SpeedX;
		uniform float _Water2SpeedY;
		uniform float _Water2Strength;
		uniform float2 _Water2Tiling;
		uniform float4 _Color;
		uniform float _Metallic;
		uniform float _Glossiness;
		uniform float _AntiAliasingVarianceSm;
		uniform float _AntiAliasingThresholdSm;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float4 tex2DNode1 = SAMPLE_TEXTURE2D( _FlowMap, sampler_FlowMap, uv_FlowMap );
			float2 appendResult2 = (float2(tex2DNode1.r , tex2DNode1.g));
			float2 temp_output_147_0 = ( appendResult2 - float2( 0.5,0.5 ) );
			float mulTime6 = _Time.y * _FlowSpeed;
			float temp_output_10_0 = frac( -mulTime6 );
			float2 lerpResult15 = lerp( ( ( uv_FlowMap + ( temp_output_147_0 * temp_output_10_0 ) ) * _Water1Tiling ) , float2( 0,0 ) , float2( 0,0 ));
			float2 appendResult44 = (float2(_Water1SpeedX , _Water1SpeedY));
			float2 temp_output_47_0 = ( _Time.y * appendResult44 );
			float2 appendResult45 = (float2(_Water2SpeedX , _Water2SpeedY));
			float2 temp_output_48_0 = ( _Time.y * appendResult45 );
			float2 lerpResult18 = lerp( ( ( uv_FlowMap + ( temp_output_147_0 * frac( ( -mulTime6 + 0.5 ) ) ) ) * _Water2Tiling ) , float2( 0,0 ) , float2( 0,0 ));
			float3 lerpResult20 = lerp( ( UnpackScaleNormal( SAMPLE_TEXTURE2D( _WaterMap1, sampler_linear_repeat, ( lerpResult15 + temp_output_47_0 ) ), _Water1Strength ) + UnpackScaleNormal( SAMPLE_TEXTURE2D( _WaterMap2, sampler_linear_repeat, ( lerpResult15 + temp_output_48_0 ) ), _Water2Strength ) ) , ( UnpackScaleNormal( SAMPLE_TEXTURE2D( _WaterMap1, sampler_linear_repeat, ( temp_output_47_0 + lerpResult18 ) ), _Water1Strength ) + UnpackScaleNormal( SAMPLE_TEXTURE2D( _WaterMap2, sampler_linear_repeat, ( temp_output_48_0 + lerpResult18 ) ), _Water2Strength ) ) , saturate( abs( ( 1.0 - ( temp_output_10_0 * 2.0 ) ) ) ));
			o.Normal = lerpResult20;
			o.Albedo = _Color.rgb;
			o.Metallic = _Metallic;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_1_0_g1 = ase_worldNormal;
			float3 temp_output_4_0_g1 = ddx( temp_output_1_0_g1 );
			float dotResult6_g1 = dot( temp_output_4_0_g1 , temp_output_4_0_g1 );
			float3 temp_output_5_0_g1 = ddy( temp_output_1_0_g1 );
			float dotResult8_g1 = dot( temp_output_5_0_g1 , temp_output_5_0_g1 );
			float lerpResult120 = lerp( _Glossiness , 0.0 , sqrt( sqrt( saturate( min( ( ( ( dotResult6_g1 + dotResult8_g1 ) * _AntiAliasingVarianceSm ) * 2.0 ) , _AntiAliasingThresholdSm ) ) ) ));
			o.Smoothness = lerpResult120;
			o.Alpha = _Color.a;
		}

		ENDCG
	}
	CustomEditor "Thry.ShaderEditor"
}
/*ASEBEGIN
Version=18935
333.6;78.4;2232;1533;102.4412;940.3855;1.405806;True;False
Node;AmplifyShaderEditor.RangedFloatNode;139;-2216.229,402.4942;Inherit;False;Property;_FlowSpeed;Flow Speed;14;0;Create;True;0;0;0;False;0;False;0;1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1590.093,-268.6232;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1899.989,406.9609;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2064.116,30.78948;Inherit;True;Property;_FlowMap;Flow Map;13;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;305c07a8ce5ca984b8387c51eed98f95;305c07a8ce5ca984b8387c51eed98f95;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;143;-1684.525,410.2767;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;2;-1751.503,60.86528;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1339.955,409.1152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;10;-1516.725,233.6219;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;147;-1522.631,59.93914;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;17;-1187.182,411.0313;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-1073.874,163.5964;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-1260.631,30.33911;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;151;-917.3839,145.9043;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;148;-1044.006,-100.9765;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1289.188,-482.7443;Inherit;False;Property;_Water2SpeedY;Speed Y;26;0;Create;False;0;0;0;False;0;False;0;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1330.856,-633.7955;Inherit;False;Property;_Water2SpeedX;Speed X;25;0;Create;False;0;0;0;False;0;False;0;0.1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1327.843,-1111.392;Inherit;False;Property;_Water1SpeedX;Speed X;19;0;Create;False;0;0;0;False;0;False;0;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;154;-1060.778,-357.5106;Inherit;False;Property;_Water1Tiling;Tiling;18;0;Create;False;0;0;0;False;1;Vector2;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;58;-1307.048,-883.8954;Inherit;False;Property;_Water1SpeedY;Speed Y;20;0;Create;False;0;0;0;False;0;False;0;0.1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;155;-956.2476,15.69335;Inherit;False;Property;_Water2Tiling;Tiling;24;0;Create;False;0;0;0;False;1;Vector2;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;44;-863.9572,-1004.257;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-812.6803,-170.7213;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;5,5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-870.57,-527.6605;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-717.295,394.7883;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;46;-900.7239,-778.4399;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-753.8752,99.17873;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;5,5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;41;-328.1496,405.6185;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-600.383,-923.2822;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-601.5432,-675.14;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;15;-603.6524,-160.0336;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;18;-578.1892,93.02003;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-288.971,-363.7114;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-292.2471,-921.2816;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerStateNode;126;-389.6561,-1502.806;Inherit;False;0;0;0;1;-1;None;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.TexturePropertyNode;60;-523.7746,-1164.783;Inherit;True;Property;_WaterMap1;Water Normal Map--{reference_property:_Water1Strength};16;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;None;None;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;57;-159.275,-530.3492;Inherit;False;Property;_Water2Strength;Strength;23;1;[HideInInspector];Create;False;0;0;0;False;0;False;1;1;-2;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;61;-538.2534,-1398.263;Inherit;True;Property;_WaterMap2;Water Normal Map--{reference_property:_Water2Strength};22;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;None;None;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.AbsOpNode;34;2.986259,323.0775;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-166.7585,-634.2142;Inherit;False;Property;_Water1Strength;Strength;17;1;[HideInInspector];Create;False;0;0;0;False;0;False;3;1;-2;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-287.2302,-212.2907;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-301.3988,-768.7758;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;113;544.4653,459.8457;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;114;541.008,703.5401;Inherit;False;Property;_AntiAliasingVarianceSm;Anti Aliasing Variance;10;0;Create;False;0;0;0;False;0;False;5;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;225.3335,-537.1769;Inherit;True;Property;_TextureSample3;Texture Sample 3;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;112;539.7883,791.885;Inherit;False;Property;_AntiAliasingThresholdSm;Anti Aliasing Threshold;11;0;Create;False;0;0;0;False;0;False;0.01;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;56;211.2879,-796.1333;Inherit;True;Property;_Water2;Water 2;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;36;162.7597,341.7677;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;73;233.6635,-299.6492;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;54;207.8028,-1023.588;Inherit;True;Property;_Water1;Water 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;79;786.4761,-613.6068;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;156;859.9929,695.2284;Inherit;False;GSAA;-1;;1;a3c5c6cf9d1dd744589a5e3146f5a3a1;0;3;1;FLOAT3;0,0,0;False;10;FLOAT;0;False;12;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;145;930.5344,72.07893;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;780.0562,-788.2566;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;116;539.6572,607.7891;Inherit;False;Property;_Glossiness;Smoothness;9;0;Create;False;0;0;0;False;0;False;0;0.904;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;1056.76,1274.034;Inherit;False;Property;m_Water1;Water 1;15;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;1097.275,1172.031;Inherit;False;Property;footer_booth;;28;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;1081.275,1059.031;Inherit;False;Property;m_MainSet;Main;6;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;1317.563,129.5169;Inherit;False;Property;_Metallic;Metallic;8;0;Create;False;0;0;0;False;0;False;0;0.582;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;1233.76,1272.034;Inherit;False;Property;m_Water2;Water 2;21;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;924.4983,1209.105;Inherit;False;Property;m_Flow;Flow;12;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;1300.655,1048.222;Inherit;False;Property;_Cull;Cull;4;0;Create;True;0;0;0;True;1;Enum(UnityEngine.Rendering.CullMode);False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;1395.31,1170.789;Inherit;False;Property;footer_github;;29;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;1465.275,948.0311;Inherit;False;Property;shader_properties_label_file;TsunaMooLabels;1;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;1544.258,1170.769;Inherit;False;Property;footer_discord;;27;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;125;1390.653,-95.17245;Inherit;False;Property;_Color;Color Tint;7;0;Create;False;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;120;1318.056,611.6528;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;1273.275,948.0311;Inherit;False;Property;shader_master_label;<color=#ffffffff>Tsuna</color> <color=#000000ff>Moo</color> <color=#ffffffff>Shader</color> <color=#000000ff>Lab</color>--{texture:{name:tsuna_moo_icon,height:128}};2;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;929.1025,-698.6718;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;129;1097.275,948.0311;Inherit;False;Property;shader_is_using_thry_editor;;0;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;1827.028,376.8549;Inherit;False;Property;Instancing;Instancing;5;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;1241.275,1172.031;Inherit;False;Property;footer_patreon;;30;1;[HideInInspector];Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1787.16,-86.65837;Float;False;True;-1;2;Thry.ShaderEditor;0;0;Standard;TsunaMoo/Crystal Water FX;False;False;False;False;False;False;True;True;True;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;2;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;3;-1;-1;-1;0;False;0;0;True;131;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;139;0
WireConnection;1;1;3;0
WireConnection;143;0;6;0
WireConnection;2;0;1;1
WireConnection;2;1;1;2
WireConnection;16;0;143;0
WireConnection;10;0;143;0
WireConnection;147;0;2;0
WireConnection;17;0;16;0
WireConnection;150;0;147;0
WireConnection;150;1;17;0
WireConnection;149;0;147;0
WireConnection;149;1;10;0
WireConnection;151;0;3;0
WireConnection;151;1;150;0
WireConnection;148;0;3;0
WireConnection;148;1;149;0
WireConnection;44;0;59;0
WireConnection;44;1;58;0
WireConnection;152;0;148;0
WireConnection;152;1;154;0
WireConnection;45;0;43;0
WireConnection;45;1;42;0
WireConnection;40;0;10;0
WireConnection;153;0;151;0
WireConnection;153;1;155;0
WireConnection;41;0;40;0
WireConnection;47;0;46;0
WireConnection;47;1;44;0
WireConnection;48;0;46;0
WireConnection;48;1;45;0
WireConnection;15;0;152;0
WireConnection;18;0;153;0
WireConnection;72;0;48;0
WireConnection;72;1;18;0
WireConnection;52;0;15;0
WireConnection;52;1;47;0
WireConnection;34;0;41;0
WireConnection;71;0;47;0
WireConnection;71;1;18;0
WireConnection;53;0;15;0
WireConnection;53;1;48;0
WireConnection;74;0;61;0
WireConnection;74;1;72;0
WireConnection;74;5;57;0
WireConnection;74;7;126;0
WireConnection;56;0;61;0
WireConnection;56;1;53;0
WireConnection;56;5;57;0
WireConnection;56;7;126;0
WireConnection;36;0;34;0
WireConnection;73;0;60;0
WireConnection;73;1;71;0
WireConnection;73;5;51;0
WireConnection;73;7;126;0
WireConnection;54;0;60;0
WireConnection;54;1;52;0
WireConnection;54;5;51;0
WireConnection;54;7;126;0
WireConnection;79;0;73;0
WireConnection;79;1;74;0
WireConnection;156;1;113;0
WireConnection;156;10;114;0
WireConnection;156;12;112;0
WireConnection;145;0;36;0
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;120;0;116;0
WireConnection;120;2;156;0
WireConnection;20;0;55;0
WireConnection;20;1;79;0
WireConnection;20;2;145;0
WireConnection;0;0;125;0
WireConnection;0;1;20;0
WireConnection;0;3;119;0
WireConnection;0;4;120;0
WireConnection;0;9;125;4
ASEEND*/
//CHKSM=1621393454881B0A204B4E790B7EFB9F7BA718CB