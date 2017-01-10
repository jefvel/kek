#ifdef GL_ES
precision highp float;
#endif

//uniform vec3 color;
varying vec3 col;
uniform float time;

uniform sampler2D buff;

uniform vec2 screenSize;
uniform vec2 textureSize;

void main() {
    vec2 screenCoord = gl_FragCoord.xy / screenSize;
    
    vec2 uv = gl_FragCoord.xy / (textureSize.xy);
    vec4 color = texture2D(buff, uv);
    

/*
	float amount = 0.0;
	
	amount = (1.0 + sin(time*6.0)) * 0.5;
	amount *= 1.0 + sin(time*16.0) * 0.5;
	amount *= 1.0 + sin(time*19.0) * 0.5;
	amount *= 1.0 + sin(time*27.0) * 0.5;
	amount = pow(amount, 3.0);

	amount *= 0.001;
	
    vec4 col;
    col.r = texture2D( buff, vec2(uv.x+amount,uv.y) ).r;
    col.g = texture2D( buff, uv ).g;
    col.b = texture2D( buff, vec2(uv.x-amount,uv.y) ).b;

	col *= (1.0 - amount * 0.5);
	
    color.rgb = col.rgb;
    
    */

    float depth = color.a;
    
    vec2 d = screenCoord;
    d *= 1.0 - d;
    float vig = d.x * d.y * 15.0;
    vig = pow(abs(vig), 0.20);
    vig = clamp(vig, 0.0, 1.0);
    vig = 1.0 - vig;

    vec4 aberrationColor = color;
    aberrationColor.r = texture2D(buff, uv + d.x * (0.0011 + vig * 0.02)).r;
    aberrationColor.g = texture2D(buff, uv + d.y * (0.0003 + vig * 0.02)).g;
    
    color = mix(color, aberrationColor, vig);
    
    float sky = 1.0 - color.a;
    color.a = 1.0;
    vec3 skyColor = mix(vec3(201,233,246), vec3(80,200,198), pow(abs(uv.y), 2.1));
    skyColor /= 255.0;
    
    color = mix(color, aberrationColor, vig);
    color.a = 1.0;
    color.rgb = mix(color.rgb, skyColor, sky); 
    color.a = 1.0;
    
    gl_FragColor = color;
}