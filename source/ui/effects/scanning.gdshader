//modified from code by vanviethieuanh https://godotshaders.com/shader/2d-lightning/
shader_type canvas_item;

uniform vec4 lightning_color: source_color;

uniform float size: hint_range (0.,1.);
uniform float width: hint_range (0.,1.);
uniform float speed;
uniform float cycle;
uniform float ratio;
uniform float time_shift;

float rand(float x){
	return x/speed; //fract(sin(x)*100000.0);
}

void fragment(){
	float bolt = abs(mod(UV.x * cycle + (rand(TIME) + time_shift) * speed * -1., 0.5)-0.25)-0.125;
	bolt *= 4. * width;
	// why 4 ? Because we use mod 0.5, the value be devide by half
	// and we -0.25 (which is half again) for abs function. So it 25%!

	// scale down at start and end
	bolt *=  (0.5 - abs(UV.x-0.5)) * 2.;

	// turn to a line
	// center align line
	float wave = abs(UV.y - 0.5 + bolt);
	// invert and ajust size
	wave = 1. - step(size*.5, wave);

	float blink = step(rand(TIME)*ratio, .5);
	wave *= blink;

	vec4 display = lightning_color * vec4(wave);
	COLOR = display;
}
