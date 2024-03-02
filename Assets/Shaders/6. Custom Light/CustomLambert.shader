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

           // s.Albedo�� �������� �� Albedo �ؽ�ó�� Labmert����Ʈ�� ������ �Ǿ� Diffuse(���ݻ�)�� �ȴ�.
           // ndotl�� '����� ����� ����'�� ǥ���� �� ���̰� ������ �����̳� ������ _LightColor0�̶�� ���� ������ ����Ǿ��ִ�.
           // �� ����(_LightColor0)�� ���� �� ������ ����� ������ ��ȭ��Ű�� �״�� ��ȭ�Ѵ�.

           // atten�� ���� ���� ����(attenuation)�� ���Ѵ�. atten�� ������� ������ �Ʒ��� ���� ���� �Ͼ�� �ʴ´�.
           // (1) self shadow�� ������ �ʴ´�. �ڱ� �ڽ��� �׸��ڸ� �ڱⰡ ���� �ȴ´�.
           // (2) receive shadow�� �������� �ʴ´�. �ٸ� ��ü�� �� �󱼿� �׸��ڸ� �帮���� ���Ѵ�.
           // (3) ������ ���� ������ �Ͼ�� �ʴ´�. Directional Light���� �� �������� ������ point light���� ���� �־������� ��ο����µ�
           //     �̰��� atten�� �ϴ� ���̰� atten�� ���ٸ� point ����Ʈ���� �־����� ��ο����� �ʴ´�.

           return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
