// ============================================================
//  CenterResize.fx  –  ReShade
//  Scales down the image in the centre of the screen.
//  Slider: 100% = full screen, 50% = half size.
// ============================================================

#include "ReShade.fxh"

// ── Uniform ──────────────────────────────────────────────────
uniform float fScale <
    ui_type    = "slider";
    ui_label   = "Image Size";
    ui_tooltip = "100% = full screen · 50% = half size";
    ui_min     = 0.50;
    ui_max     = 1.00;
    ui_step    = 0.01;
> = 1.00;

uniform float3 fBorderColor <
    ui_type    = "color";
    ui_label   = "Border Color";
    ui_tooltip = "Color of the area around the resized image";
> = float3(0.0, 0.0, 0.0);

// ── Pixel shader ─────────────────────────────────────────────
float4 PS_CenterResize(float4 pos : SV_Position,
                        float2 uv  : TEXCOORD) : SV_Target
{
    // Margin on each side in UV coordinates [0,1]
    float margin = (1.0 - fScale) * 0.5;

    // If the pixel is on the border, it returns the border color
    if (uv.x < margin || uv.x > 1.0 - margin ||
        uv.y < margin || uv.y > 1.0 - margin)
    {
        return float4(fBorderColor, 1.0);
    }

    // Remap the UVs from the cropped area to the entire texture
    float2 scaledUV = (uv - margin) / fScale;

    return tex2D(ReShade::BackBuffer, scaledUV);
}

// ── Tecnica ──────────────────────────────────────────────────
technique CenterResize
<
    ui_label   = "Center Resize";
    ui_tooltip = "Shrinks the image in the centre of the screen.\n"
                 "Use the 'Image size' slider to adjust.";
>
{
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader  = PS_CenterResize;
    }
}
