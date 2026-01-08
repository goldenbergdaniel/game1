struct Vertex
{
  float4 position;
  float2 uv;
}

struct VS_Output
{
  float4 position : SV_Position;
  float2 uv;
}

static const
Vertex vertices[6] = {
  Vertex(float4(-1, -1, 1, 1), float2(0, 0)),
  Vertex(float4( 1, -1, 1, 1), float2(1, 0)),
  Vertex(float4(-1,  1, 1, 1), float2(0, 1)),

  Vertex(float4( 1, -1, 1, 1), float2(1, 0)),
  Vertex(float4( 1,  1, 1, 1), float2(1, 1)),
  Vertex(float4(-1,  1, 1, 1), float2(0, 1)),
};

[shader("vertex")]
VS_Output vs_main(uint vid : SV_VertexID)
{
  VS_Output output;
  output.position = vertices[vid].position;
  output.uv = vertices[vid].uv;

  return output;
}

struct FS_Constants
{
  uint enabled;
}

[vk::push_constant]
uniform FS_Constants fs_constants;

[vk::binding(2, 0)]
Sampler2D fs_texture;

[shader("fragment")]
float4 fs_main(VS_Output vs) : SV_Target
{
  float4 texel = fs_texture.Sample(vs.uv);

  if (fs_constants.enabled != 0)
  {
    if (all(texel.rgb == float3(0, 0, 0)))
    {
      return float4(1, 1, 1, 1);
    }
    else if (all(texel.rgb == float3(1, 1, 1)))
    {
      return float4(0, 0, 0, 1);
    }
  }

  return texel;
}
