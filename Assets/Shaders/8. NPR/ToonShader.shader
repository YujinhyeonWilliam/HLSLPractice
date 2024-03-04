Shader "Custom/ToonShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineThickness ("Outline Thickness", Range(0, 2)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        cull front 

        //1st Pass
        CGPROGRAM
        #pragma surface surf NoLight vertex:vert noshadow noambient
        #pragma target 3.0

        sampler2D _MainTex;
        float4 _OutlineColor;
        float _OutlineThickness;

        struct Input
        {
            float2 uv_MainTex;
        };

        void vert(inout appdata_full v)
        {
           v.vertex.xyz += v.normal.xyz * 0.01 * _OutlineThickness;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {

        }

        float4 LightingNoLight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return _OutlineColor;
        }

        ENDCG

        cull back

        //2nd Pass
        CGPROGRAM
       
        #pragma surface surf Lambert
        #pragma taret 3.0
       
        sampler2D _MainTex;
       
        struct Input
        {
          float2 uv_MainTex;  
        };
       
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
       
        ENDCG
    }
    FallBack "Diffuse"
}
