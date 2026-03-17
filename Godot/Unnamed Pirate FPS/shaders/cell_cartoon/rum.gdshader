shader_type spatial;

#define USE_ALPHA 1
#define USE_ALPHA_CUTOFF 0
#define USE_EMISSION 0
#define USE_REFLECTIONS 0
#define USE_NORMAL_MAP 0
#define USE_OCCLUSION 0
#define USE_HEIGHT_MAP 0
#define USE_ANISOTROPY 0
#define USE_BACKLIGHT 0
#define USE_REFRACTION 0

#include "includes/base-cel-shader.gdshaderinc"

#if USE_ALPHA
render_mode depth_draw_always;
#endif

#if USE_EMISSION
#include "includes/emission.gdshaderinc"
#endif

#if USE_REFLECTIONS
#include "includes/reflections.gdshaderinc"
#endif

#if USE_NORMAL_MAP
#include "includes/normal-map.gdshaderinc"
#endif

#if USE_OCCLUSION
#include "includes/occlusion.gdshaderinc"
#endif

#if USE_HEIGHT_MAP
#include "includes/height-map.gdshaderinc"
#endif

#if USE_ANISOTROPY
#include "includes/anisotropy.gdshaderinc"
#endif

#if USE_BACKLIGHT
#include "includes/backlight.gdshaderinc"
#endif

#if USE_REFRACTION
#include "includes/refraction.gdshaderinc"
#elif !USE_REFRACTION && USE_ALPHA
#include "includes/transparency.gdshaderinc"
#endif

const int n_balls = 8;
uniform vec3 ball_pos[n_balls];
uniform float radi[n_balls];
uniform float blend_r;
const float EPS = 1e-3;

group_uniforms Outline;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_thickness : hint_range(0.0, 1.0) = 0.2;
group_uniforms;

group_uniforms BaseProperties;
#if USE_ALPHA_CUTOFF
uniform float alpha_cutoff: hint_range(0.0, 1.0) = 0.5;
#endif
uniform vec4 color: source_color = vec4(0.7, 0.12, 0.86, 1.0);
uniform sampler2D base_texture: source_color;
uniform vec4 specular: source_color = vec4(0.3, 0.3, 0.3, 0.5);
uniform sampler2D specular_texture: hint_default_white;
uniform vec4 fresnel: source_color = vec4(0.2, 0.2, 0.2, 0.3);
uniform sampler2D fresnel_texture: hint_default_white;
group_uniforms;

varying vec3 SPECULAR_COLOR;
varying float SPECULAR_STRENGTH;
varying vec3 FRESNEL_COLOR;
varying float FRESNEL_STRENGTH;
varying float OUTLINE_MASK;

varying vec2 base_uv;

group_uniforms Tiling;
uniform vec2 uv_scale = vec2(1,1);
uniform vec2 uv_offset = vec2(0,0);
group_uniforms;


bool ray_box_intersect(vec3 ray_origin, vec3 ray_dir,vec3 b_min, vec3 b_max, out float t_min, out float t_max){
	

	vec3 t1 = (b_min - ray_origin)/ray_dir;
	vec3 t2 = (b_max - ray_origin)/ray_dir;
	
	vec3 t_min_vec = min(t1,t2);
	vec3 t_max_vec = max(t1,t2);
	
	t_max =min(t_max_vec.x ,min(t_max_vec.y, t_max_vec.z));
	t_min =max(t_min_vec.x ,max(t_min_vec.y, t_min_vec.z));
	//if (t_min < 0.0){
		//return false;
	//}
		
	if (t_max < t_min){
		return false;
	}
	return true;
	}


float s_min(float a, float b, float k){
 	float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

float sdf_metaballs(vec3 p){
	float fields[n_balls];
	
	for (int i = 0; i < n_balls; i++){		
		fields[i] = length(p - ball_pos[i]) - radi[i];
	}
	float d = fields[0];
	for (int i = 0; i < n_balls; i++){		
		d = s_min(d,fields[i], blend_r);
	}
	return d;
	
}

vec3 estimate_normal(vec3 p) {
    float dx = sdf_metaballs(p + vec3( EPS, 0.0, 0.0)) -
               sdf_metaballs(p - vec3( EPS, 0.0, 0.0));

    float dy = sdf_metaballs(p + vec3(0.0,  EPS, 0.0)) -
               sdf_metaballs(p - vec3(0.0,  EPS, 0.0));

    float dz = sdf_metaballs(p + vec3(0.0, 0.0,  EPS)) -
               sdf_metaballs(p - vec3(0.0, 0.0,  EPS));

    return normalize(vec3(dx, dy, dz));
}


bool ray_march(vec3 ray_origin, vec3 ray_dir, float t_min, float t_max, out vec3 p) {
	float t = t_min;
    const int MAX_STEPS = 64;
    for (int i = 0; i < MAX_STEPS; i++) {
        p = ray_origin + t * ray_dir;
        float d = sdf_metaballs(p);    // distance to surface
        if (d < 0.001) {               // hit!            
            return true;
        }
        t += d;                        // advance by the distance field
        if (t > t_max) 
			break;
    }
	return false;
}

void vertex() {
	UV = UV * uv_scale.xy + uv_offset.xy;
	#if !USE_HEIGHT_MAP
		base_uv = UV;
	#endif
}

void fragment() {
	
	vec3 world_position = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 ray_origin = CAMERA_POSITION_WORLD;
	vec3 ray_dir = normalize(world_position - ray_origin);

    ray_origin = (inverse(MODEL_MATRIX) * vec4(ray_origin, 1.0)).xyz;
    ray_dir    = normalize((inverse(MODEL_MATRIX) * vec4(ray_dir, 0.0)).xyz);

    // 2. Find where the ray enters and exits the cube (ray–box intersection)
    float t_min, t_max;
    if (!ray_box_intersect(ray_origin, ray_dir, vec3(-0.5), vec3(0.5), t_min, t_max))
        discard;         
	// keep cull_disabled
	if (!FRONT_FACING && t_min > 0.0) {
	    discard;          // skip back faces only when the eye is outside
	}
          // misses the box
    // 3. March the ray through the SDF field
	vec3 p = vec3(0);
	if(!ray_march(ray_origin, ray_dir, t_min, t_max, p))
		discard;
		
	SPECULAR_COLOR = specular.rgb * texture(specular_texture, base_uv).rgb;
	SPECULAR_STRENGTH = specular.a * texture(specular_texture, base_uv).a;
	FRESNEL_COLOR = fresnel.rgb * texture(fresnel_texture, base_uv).rgb;
	FRESNEL_STRENGTH = fresnel.a * texture(fresnel_texture, base_uv).a;
	
	vec3 normals = estimate_normal(p);
	NORMAL = normalize((VIEW_MATRIX * MODEL_MATRIX * vec4(normals, 0.0)).xyz);

	vec3 view_pos = (VIEW_MATRIX * MODEL_MATRIX * vec4(p, 1.0)).xyz;
	vec3 view_dir = normalize(-view_pos);

	float ndv = dot(NORMAL, view_dir);
	float rim = 1.0 - ndv;
	OUTLINE_MASK = step(1.0 - outline_thickness, rim);

	vec2 uv = p.xy + 0.5;
	ALBEDO = color.rgb * texture(base_texture, uv).rgb;

	ALPHA = 0.9;
    
	vec4 world_p = MODEL_MATRIX * vec4(p, 1.0);
    vec4 clip_p  = PROJECTION_MATRIX * VIEW_MATRIX * world_p;
    float depth  = clip_p.z / clip_p.w;     // −1 … 1
    DEPTH = depth ;       //  0 … 1  //  0 … 1
	}
	
void light() {
#if USE_BACKLIGHT
	DIFFUSE_LIGHT += backlight_diffuse(
			ALBEDO,
			LIGHT_COLOR,
			LIGHT,
			NORMAL,
			ATTENUATION,
			BACKLIGHT
	);
#else
	DIFFUSE_LIGHT += diffuse_light(
			ALBEDO,
			LIGHT_COLOR,
			LIGHT,
			NORMAL,
			ATTENUATION
	);
#endif

#if USE_ANISOTROPY
	SPECULAR_LIGHT += anisotropy_specular(
			LIGHT_COLOR,
			SPECULAR_COLOR,
			SPECULAR_STRENGTH,
			NORMAL,
			VIEW,
			LIGHT,
			ATTENUATION,
			UV,
			ANISOTROPY_DIR,
			ANISOTROPY_RATIO
	);
#else
	SPECULAR_LIGHT += specular_light(
			LIGHT_COLOR,
			SPECULAR_COLOR,
			SPECULAR_STRENGTH,
			NORMAL,
			VIEW,
			LIGHT,
			ATTENUATION
	);
#endif

	SPECULAR_LIGHT += fresnel_light(
			LIGHT_COLOR,
			FRESNEL_COLOR,
			FRESNEL_STRENGTH,
			NORMAL,
			VIEW,
			LIGHT,
			ATTENUATION
	);
if (OUTLINE_MASK > 0.5) {
    DIFFUSE_LIGHT = outline_color.rgb;
    SPECULAR_LIGHT = vec3(0.0);
}
}

