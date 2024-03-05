Shader "Custom/CubeMapReflection"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cube ("Cube Map", Cube) = "" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _MaskMap ("Mask Map", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Lambert
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _MaskMap;

        samplerCUBE _Cube;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_MaskMap;
            float3 worldRefl;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);            
            float4 reflection = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
            float4 mask = tex2D (_MaskMap, IN.uv_MaskMap);

            o.Albedo = c.rgb * (1-mask.r);
            o.Emission = reflection.rgb * mask.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
