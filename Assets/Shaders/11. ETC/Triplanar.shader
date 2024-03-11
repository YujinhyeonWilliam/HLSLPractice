Shader "Custom/Triplanar"
{
    Properties
    {
      [NoScaleOffset] _MainTex ("Top Texture", 2D) = "white" {}
      _MainTexUV ("TileU, TileV, OffsetU, OffsetV", Vector) = (1, 1, 0, 0)
      [NoScaleOffset] _SideTex ("Side Texture", 2D) = "white" {}
      _SideTexUV ("TileU, TileV, OffsetU, OffsetV", Vector) = (1, 1, 0 , 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Standard
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SideTex;
        float4 _MainTexUV;
        float4 _SideTexUV;

        struct Input
        {
            float3 worldPos;
            float3 worldNormal;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // triUVs
            float2 topUV = float2(IN.worldPos.x, IN.worldPos.z);
            float2 frontUV = float2(IN.worldPos.x, IN.worldPos.y);
            float2 sideUV = float2(IN.worldPos.z, IN.worldPos.y);

            // textures
            float4 topTex = tex2D (_MainTex, topUV * _MainTexUV.xy + _MainTexUV.zw);
            float4 frontTex = tex2D(_SideTex, frontUV * _SideTexUV.xy + _SideTexUV.zw);
            float4 sideTex = tex2D(_SideTex, sideUV * _SideTexUV.xy + _SideTexUV.zw);

            o.Albedo = lerp(topTex, frontTex, abs(IN.worldNormal.z));
            o.Albedo = lerp(o.Albedo, sideTex, abs(IN.worldNormal.x));
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
