Shader "Custom/ToonFresnel"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        //2nd Pass
        CGPROGRAM
       
        #pragma surface surf ToonLight
        #pragma taret 3.0
       
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
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
       
        float4 LightingToonLight(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            
            ndotl *= 5;
            ndotl = ceil(ndotl) / 5;


            float rim = abs(dot(s.Normal, viewDir));

            if(rim > 0.3)
                rim = 1;
            else
                rim = -1;

            float4 final;
            final.rgb = s.Albedo * ndotl * _LightColor0.rgb;
            final.a = s.Alpha;

            return rim;   
        }

        ENDCG
    }
    FallBack "Diffuse"
}
