//HLSLPROGRAM과 ENDHLSL사이의 코드를 제외 하면 모두 유니티의 ShaderLab 스크립트
//https://docs.unity3d.com/Manual/SL-Reference.html
//Shader class의 Instance를 Shader Object라고 함
//https://docs.unity3d.com/Manual/shader-objects.html
//
Shader "Unlit/FirstUnlitShader"//Material의 Shader목록에서 트리 형태로 표시 됨
{
    Properties // Properties 블럭 안의 항목들은 Material에서 입력 할 수 있는 Interface가 됨
    {
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader //특정 하드웨어, 렌더 파이프라인, 런타임 설정등에 대한 호환 조건을 주어서 셰이더 객체가 호환 되는 SubShader를 실행 시키도록 한다.
    {
        Tags { //SubShader에 대한 추가 정보
            "RenderPipeline"="UniversalPipeline" //URP를 사용 한다는 명시
            "RenderType"="Opaque" //불투명 렌더를 하겠다는 명시
        }
        
        Pass //PASS 동작해야 할 실제 셰이더 코드와 셰이더를 실행 시키기 전에 Render State에 설정 해야 하는 정보등을 담고 있다.
        {
            HLSLPROGRAM //HLSL 셰이더 코드의 시작
            #pragma vertex vert //Vertex Shader 함수 지정
            #pragma fragment frag  //Fragment Shader 함수 지정
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            //TransformObjectToHClip 함수를 사용하기 위해 포함.

            struct appdata //Vertex Shader의 인자로 받을 구조체이며 그래픽 엔진이 실제 데이터를 이 구조체에 넣어 준다.
            {
                float4 vertex : POSITION; //vertex는 변해도 되는 변수명으로 보이고 POSITON이 엔진에서 어떤 값을 넣어 줘야 될지에 대한 키워드로 추측 됨
                //https://docs.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl-semantics?redirectedfrom=MSDN
                //객체의 로컬공간에 대한 정점 위치
            };

            struct v2f //Fragment Shader의 인자로 받을 구조체이며 Vertex Shader에서 데이터를 생성 하고 값을 넣어 줘야 한다.
            {
                float4 vertex : SV_POSITION; //POSITON과 SV_POSITION의 차이는?
                //homogenous space에서의 정점 위치. homogenous space가 뭐지?
            };

            float4 _Color; //Properties에서 선언한 컬러값이 여기에 자동으로 복사된다.

            //Vertex shader
            v2f vert (appdata v)
            {
                v2f o;                
                o.vertex = TransformObjectToHClip(v.vertex.xyz); //객체의 로컬 좌표를 homogenous space(월드좌표?)로 변환
                return o;
            }

            //Fragment shader
            half4 frag (v2f i) : SV_Target //SV_Target은 결과를 Render Target에 저장 하겠다는 의미인것 같음.            
            {
                return _Color;
            }
            ENDHLSL
        }
    }
}
