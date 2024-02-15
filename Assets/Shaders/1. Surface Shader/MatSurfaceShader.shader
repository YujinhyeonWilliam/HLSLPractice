Shader "Custom/MatSurfaceShader"
{
    Properties
    {
        _Red("Red", Range(0, 1)) = 0.5
        _Green("Green", Range(0, 1)) = 0.5
        _Blue("Blue", Range(0, 1)) = 0.5
        _Alpha("Alpha", Range(0, 1)) = 0.5
        _Brightness ("Brightness", Range(-1, 1)) = 0.5
        _Emission ("Emission", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard noambient
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };
 
        float _Red;
        float _Green;
        float _Blue;
        float _Brightness;
        fixed4 _Emission;
        fixed4 _Alpha;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Emission = _Emission;
            o.Albedo = float3(_Red, _Green, _Blue) + _Brightness;
            o.Alpha = _Alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
