
#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(Attributes::Position)]];
    float3 color [[attribute(Attributes::Color)]];
    float3 normal [[attribute(Attributes::Normal)]];
    float2 uv [[attribute(Attributes::UV)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 color;
    float3 normal;
    float2 uv;
    float3 worldPosition;
    float3 worldNormal;
};
