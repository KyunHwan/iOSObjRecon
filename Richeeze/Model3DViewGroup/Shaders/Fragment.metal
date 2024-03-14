
#include <metal_stdlib>
using namespace metal;
#import "Lighting.h"
#import "ShaderDefs.h"

fragment float4 fragment_main(constant Params &params [[buffer(ParamsBuffer)]],
                              VertexOut in [[stage_in]],
                              constant Light *lights [[buffer(LightBuffer)]],
                              texture2d<float> baseColorTexture [[texture(BaseColor)]])
{
    float3 baseColor = float3(1.0, 1.0, 1.0);
    
    if (params.renderMode == 0) {
        constexpr sampler textureSampler(filter::linear, mip_filter::linear, max_anisotropy(8), address::repeat);
        baseColor = baseColorTexture.sample(textureSampler, in.uv * params.tiling).rgb;
    }
    else {
        baseColor = in.color;
    }
    
    float3 normalDirection = normalize(in.worldNormal);
    float3 color = phongLighting(normalDirection, in.worldPosition, params, lights, baseColor);
    return float4(color, 1);
}
