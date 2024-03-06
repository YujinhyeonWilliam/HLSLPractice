Shader "Custom/AdvancedFire"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albeod (RGB)", 2D) = "black" {}
        _Speed ("Speed", float) = 1
        _Wrinkleness ("Wrinkle", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        LOD 200

        cull off

        CGPROGRAM

        #pragma surface surf Standard alpha:fade

        sampler2D _MainTex;
        sampler2D _MainTex2;
        float _Wrinkleness;
        float _Speed;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 d = tex2D (_MainTex2, float2(IN.uv_MainTex2.x, IN.uv_MainTex2.y - _Time.y * _Speed));
            d.rgb *= _Wrinkleness;
            fixed4 c = tex2D (_MainTex, saturate(IN.uv_MainTex + d.r));

            o.Emission = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
