Shader "Unlit/TextureUnlitShader"
{
    Properties
    {
        //텍스쳐 입력 인터페이스
        _MainTex("Albedo", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
        }
        
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv     : TEXCOORD0;
            };

            float4 _Color;
            //MainTex를 Texture로 사용하겠다는 매크로
            TEXTURE2D(_MainTex);
            //MainTex의 샘플러를 생성하는 매크로
            SAMPLER(sampler_MainTex);

            v2f vert (appdata v)
            {
                v2f o;                
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv = v.uv;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                //MainTex의 샘플을 가져오는 매크로.. 샘플러는 왜필요하지?
                return SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv) * _Color;
            }
            ENDHLSL
        }
    }
}
