Shader "Custom/Water"
{
    Properties
    {
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Cube ("Cube", Cube) = "" {}
        _SPColor("Specular Color", Color) = (1, 1, 1, 1)
        _SPower("Specular Power", Range(50, 300)) = 150
        _SPMulti("Specular Multiply", Range(1, 10)) = 3
        _RefracPow("Refraction Power", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}  

        GrabPass{}
        CGPROGRAM

        #pragma surface surf WaterSpecular alpha:fade vertex:vert
        #pragma target 3.0

        sampler2D _BumpMap;
        sampler2D _GrabTexture;
        samplerCUBE _Cube;
        float4 _SPColor;
        float _SPower;
        float _SPMulti;
        float _RefracPow;

        void vert(inout appdata_full v)
        {
            float movement;
            movement = sin(abs(v.texcoord.x * 2 - 1) * 6 + _Time.y) * 0.1;
            movement += sin(abs(v.texcoord.y * 2 - 1) * 6 + _Time.y) * 0.1;
            v.vertex.y += movement/2;
        }


        struct Input
        {
            float2 uv_BumpMap;
            float3 worldRefl;
            float3 viewDir;
            float4 screenPos;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 normal1 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap + _Time.x * 0.1));
            float3 normal2 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap - _Time.x * 0.1));
            o.Normal = (normal1 + normal2) / 2;

            float3 refColor = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));

            // refraction term
            float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
            float3 refraction = tex2D(_GrabTexture, (screenUV.xy + o.Normal.xy * _RefracPow));

            // rim term
            float rim = saturate(dot(o.Normal, IN.viewDir));           
            rim = pow(1-rim, 1.5);

            o.Emission = (refColor * rim + refraction) * 0.5;
            o.Alpha = 1;
        }

        float4 LightingWaterSpecular(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            // specular term
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(H, s.Normal));
            spec = pow(spec, _SPower);

            // final term
            float4 finalColor;
            finalColor.rgb = spec * _SPColor.rgb * _SPMulti;
            finalColor.a = s.Alpha;

            return finalColor;
        }

        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Vertexlit"
}
