Shader "Custom/ToonHalfLambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineThickness ("Outline Thickness", Range(0, 2)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        cull front 

        //1st Pass
        CGPROGRAM
        #pragma surface surf NoLight vertex:vert noshadow noambient
        #pragma target 3.0
  
        sampler2D _MainTex;
        float4 _OutlineColor;
        float _OutlineThickness;
  
        struct Input
        {
            float2 uv_MainTex;
        };
  
        void vert(inout appdata_full v)
        {
           v.vertex.xyz += v.normal.xyz * 0.01 * _OutlineThickness;
        }
  
        void surf (Input IN, inout SurfaceOutput o)
        {
            
        }
  
        float4 LightingNoLight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return _OutlineColor;
        }
  
        ENDCG

        cull back

        //2nd Pass
        CGPROGRAM
       
        #pragma surface surf ToonLight noambient
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
       
        float4 LightingToonLight(SurfaceOutput s, float3 lightDir, float atten)
        {
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            
            ndotl *= 5;
            ndotl = ceil(ndotl) / 5;

            float4 final;
            final.rgb = s.Albedo * ndotl * _LightColor0.rgb;
            final.a = s.Alpha;

            return final;   
        }

        ENDCG
    }
    FallBack "Diffuse"
}
