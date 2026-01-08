struct Vertex
{
  float4 position;
  float4 color;
  float2 uv;
}

struct Push_Constants
{
  float4x4 transform;
  Vertex *vertices;
}

[vk::push_constant]
uniform Push_Constants constants;

struct Uniform_Buffer
{
  float4 light;
};

uniform Uniform_Buffer uniforms;

struct VS_Output
{
  float4 position : SV_Position;
  float4 color;
  float2 uv;
  float4 light;
}

[shader("vertex")]
VS_Output vs_main(uint vid : VS_VertexID)
{
  VS_Output output;
  
  output.position = float4(constants.vertices[vid].position.xyz, 1);
  output.color = constants.vertices[vid].color;
  output.uv = constants.vertices[vid].uv;
  output.light = uniforms.light;

  return output;
}

[vk::binding(1, 0)]
Sampler2D fs_texture;

[shader("fragment")]
float4 fs_main(VS_Output vin) : SV_Target
{
  float4 texel = fs_texture.Sample(vin.uv);
  float4 out_color = texel * vin.color * vin.light;

  return out_color;
}
