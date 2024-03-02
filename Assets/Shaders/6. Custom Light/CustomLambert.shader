Shader "Custom/CustomLambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("NormalMap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
    
        #pragma surface surf CustomLight
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Alpha = c.a;
        }

        float4 LightingCustomLight(SurfaceOutput s, float3 lightDir, float atten)
        {
           float ndotl = saturate(dot(s.Normal, lightDir));
           float4 final;
           final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;
           final.a = s.Alpha;

           // s.Albedo를 가져오면 이 Albedo 텍스처는 Labmert라이트와 연산이 되어 Diffuse(난반사)가 된다.
           // ndotl은 '조명과 노멀의 각도'를 표현한 것 뿐이고 조명의 색상이나 강도는 _LightColor0이라는 내장 변수에 저장되어있다.
           // 이 변수(_LightColor0)를 곱한 후 조명의 색상과 강도를 변화시키면 그대로 변화한다.

           // atten은 빛의 감쇠 현상(attenuation)을 뜻한다. atten을 계산하지 않으면 아래와 같은 일이 일어나지 않는다.
           // (1) self shadow가 생기지 않는다. 자기 자신의 그림자를 자기가 받지 안는다.
           // (2) receive shadow가 동작하지 않는다. 다른 물체가 이 얼굴에 그림자를 드리우지 못한다.
           // (3) 조명의 감쇠 현상이 일어나지 않는다. Directional Light에선 잘 느껴지지 않지만 point light에선 점점 멀어질수록 어두워지는데
           //     이것이 atten이 하는 일이고 atten이 없다면 point 라이트에서 멀어져도 어두워지지 않는다.

           return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
