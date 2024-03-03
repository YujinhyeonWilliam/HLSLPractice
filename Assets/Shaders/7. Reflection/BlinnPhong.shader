Shader "Custom/BlinnPhong"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("NormalMap", 2D) = "bump" {}
        // _SpecColor는 내장된 프로퍼티이므로 이름 겹치지 않게 선언
        _SpecCol ("Specular Color", Color) = (1, 1, 1, 1)
        _SpecPow ("Specular Power", Range(10, 200)) = 100
        _GlossTex ("Gloss Map", 2D) = "white" {}

        _RimColor ("Rim Light Color", Color) = (1, 1, 1, 1)
        _RimPow ("Rim Light Power", Range(0, 20)) = 6
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf CustomLight
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _GlossTex;

        float4 _SpecCol;
        float _SpecPow;
        float4 _RimColor;
        float _RimPow;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_GlossTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            float4 m = tex2D(_GlossTex, IN.uv_GlossTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Gloss = m.a;
            o.Alpha = c.a;
        }

        // (SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        // (SurfaceOutput s, float3 lightDir, float atten)
        // 위 둘 중 하나만 갖다 쓸 수 있다.

        float4 LightingCustomLight(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            // Labmert Term
           float ndotl = saturate(dot(s.Normal, lightDir));
           float4 final;
           float3 DiffColor;

           DiffColor = ndotl * s.Albedo * _LightColor0.rgb * atten;

           // Specular Term
           float3 SpecColor;
           float3 HalfVector = normalize(lightDir + viewDir);
           float Specular = saturate(dot(HalfVector, s.Normal));
           Specular = pow(Specular, _SpecPow);
           SpecColor = Specular * _SpecCol.rgb * s.Gloss;

           // Rim Term
           float3 rimColor;
           float rim = abs(dot(viewDir, s.Normal)); //saturate대신 abs 사용. 추후 양면 렌더링시 abs의 필요성을 느낄 예정
           float invrim = 1 - rim;
           rimColor = pow(invrim, _RimPow) * _RimColor;

           // Fake Specular Term
           float3 fakeSpec;
           fakeSpec = pow(rim, 50) * float3(0.2, 0.2, 0.2) * s.Gloss;

           // Final Term
           final.rgb = DiffColor.rgb + SpecColor.rgb + rimColor.rgb + fakeSpec.rgb;
           final.a = s.Alpha;

           return final;
        }

        ENDCG
    }
        FallBack "Diffuse"
}
