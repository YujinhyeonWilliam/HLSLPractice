Shader "Custom/Dissolve"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _OutlineThickness ("Outline Thickness", Range(1, 1.5)) = 1.15
        [HDR] _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        LOD 200
        
        // 1st Pass : zwrite on, rendering off
        zwrite on
        ColorMask 0
        CGPROGRAM

        #pragma surface surf nolight noambient noforwardadd nolightmap novertexlights noshadow
        
        struct Input
        {
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

        // 2nd Pass : zwrite off, rendering on
        zwrite off
        CGPROGRAM

        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        sampler2D _NoiseTex;

        float _lerpValue;
        float _Cutout;
        float _OutlineThickness;
        float4 _OutlineColor;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 noise = tex2D (_NoiseTex, IN.uv_NoiseTex);
            float fracValue = frac(_Time.y);
            float alpha;

            o.Albedo = c.rgb;

            // Pingpong효과. 시간에 따라 오브젝트가 사라졌다가 나타났다함
            if(floor(_Time.y) % 2 == 0)
                _lerpValue = 1 - fracValue;
            else
                _lerpValue = fracValue;

            _Cutout = lerp(0, 1, _lerpValue) * 0.05;

           if(noise.r >= _Cutout)
               alpha = 1;
           else
               alpha = 0;

         
           // Dissolve의 외곽선 색깔 처리
           float outline;
           if(noise.r >= _Cutout * _OutlineThickness)
              outline = 0;
           else
              outline = 1;
           
           o.Emission = outline * _OutlineColor.rgb;
           o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
