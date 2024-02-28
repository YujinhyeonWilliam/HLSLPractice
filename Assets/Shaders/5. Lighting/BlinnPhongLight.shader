Shader "Custom/BlinnPhongLight"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "black" {}
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf BlinnPhong fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Specular = 0.5;
            o.Gloss = 1;
            o.Alpha = c.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
