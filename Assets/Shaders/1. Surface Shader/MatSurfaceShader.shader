Shader "Custom/MatSurfaceShader"
{
    Properties
    {
        _Brightness ("Brightness", Range(0, 1)) = 0.5
        _TestFloat ("Test Float", Float) = 0.5
        _TestColor ("Test Color", Color) = (1, 1, 1, 1)
        _TestVector ("Test Vector", Vector) = (1, 1, 1, 1)
        _TestTexture ("Test Texture", 2D) = "white" {}

        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows noambient

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            //o.Albedo = c.rgb;
            
            // color range는 보통 0~1이 정상이다. 이 범위를 벗어나면 값은 저장하지만 디스플레이에 출력이 안되는데
            // 이를 출력되게끔 표현해줄 수 있는 상태를 HDR(High Dynamic Range)이라고 한다.
            // 즉, HDR상태는 1보다 밝은 색이 있고 0보다 어두운 색이 존재한다는 상태이다.
            
            // float3(1, 0, 0) - 1 = float3(1, 0, 0) - float3(1, 1, 1) => float(0, -1, -1). 데이터는 (0, -1, -1)이지만
            // 표현은 (0, 0, 0)으로 된다.

            o.Emission = float3(0.2, 0.4, 0);
            o.Albedo = float3 (1, 0, 1);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
