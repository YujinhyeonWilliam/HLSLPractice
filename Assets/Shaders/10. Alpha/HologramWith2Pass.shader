Shader "Custom/HologramWith2Pass"
{
    Properties
    {
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _RimColor ("Rim Color", Color) = (0, 1, 0, 1)
        _RimPower ("Rim Power", Range(0, 10)) = 3
        _LineThickness ("Line Thickness", Range(0, 60)) = 30
        _CountOfLines ("Line Counts", int) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        LOD 200

        // 1st pass zwrite on, rendering off
        zwrite on
        ColorMask 0
        CGPROGRAM
        #pragma surface surf nolight noambient noforwardadd nolightmap novertexlights noshadow

        struct Input{
          float4 color:COLOR;    
        };

        void surf(Input IN, inout SurfaceOutput o)
        {

        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, 0);
        }

        ENDCG

        // 2nd pass zwrite off, rendering on
        zwrite off
        CGPROGRAM

        #pragma surface surf noLight noambient alpha:fade
        #pragma target 3.0

        sampler2D _BumpMap;
        float4 _RimColor;
        float _RimPower;
        float _LineThickness;
        int _CountOfLines;

        struct Input
        {
            float2 uv_BumpMap;
            float3 viewDir;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Emission = _RimColor;
            float rim = saturate(dot(o.Normal, IN.viewDir));
            // frac함수는 인자의 소수점 부분만 리턴해준다. (ex. frac(2.9) = 0.9)
            rim = pow(1 - rim, _RimPower) + pow(frac(IN.worldPos.g * _CountOfLines - _Time.y), _LineThickness);
            o.Alpha = rim;
        }

        float4 LightingnoLight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, s.Alpha);
        }

        ENDCG
    }
    FallBack "Transparent/Diffuse"
}
