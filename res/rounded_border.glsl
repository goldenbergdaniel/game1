// ---------- Vertex shader ----------
// Assumes a quad drawn with 4 verts (or 2 tris), positions in [-1,1] locally.
// halfSize = half-extent of the quad in pixels (or whatever unit you use).

layout(location = 0) in vec2 inPos;      // [-1,1] quad-local position
layout(location = 0) out vec2 vLocalPos; // pass through
layout(location = 1) out vec2 vHalfSize;

layout(push_constant) uniform PushConstants {
    vec2 halfSize;   // half-width, half-height in pixels
    float cornerRadius;
    float borderThickness;
} pc;

void main() {
    vLocalPos = inPos * pc.halfSize; // now in pixel space, centered at origin
    vHalfSize = pc.halfSize;
    gl_Position = /* your usual MVP transform */ vec4(inPos, 0.0, 1.0);
}

// ---------- Fragment shader ----------

layout(location = 0) in vec2 vLocalPos;
layout(location = 1) in vec2 vHalfSize;
layout(location = 0) out vec4 outColor;

layout(push_constant) uniform PushConstants {
    vec2 halfSize;
    float cornerRadius;
    float borderThickness;
} pc;

// Signed distance to a rounded box, centered at origin.
// b = half-size, r = corner radius. Negative inside, positive outside.
float sdRoundedBox(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + r;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

void main() {
    float r = pc.cornerRadius;

    // Outer edge distance
    float dOuter = sdRoundedBox(vLocalPos, vHalfSize, r);

    // Inner edge distance: shrink the box by the border thickness
    float dInner = sdRoundedBox(vLocalPos, vHalfSize - pc.borderThickness, max(r - pc.borderThickness, 0.0));

    // Antialiasing width in pixels — derivative-based so it scales with zoom
    float aa = fwidth(dOuter);

    // Outside the outer edge -> fade to 0 alpha
    float outerMask = 1.0 - smoothstep(-aa, aa, dOuter);

    // Inside the inner edge -> also fade to 0 alpha (this carves the hole)
    float innerMask = smoothstep(-aa, aa, dInner);

    float alpha = outerMask * innerMask;

    vec3 borderColor = vec3(1.0, 1.0, 1.0); // whatever color you want
    outColor = vec4(borderColor, alpha);
}
