package kek.graphics;

typedef Frame = {
	x:Int,
	y:Int,
	w:Int,
	h:Int,
	uvx:Float,
	uvy:Float,
	duration:Int
}

typedef Animation = {
	name:String,
	from:Int,
	to:Int,
	totalLength:Int,
	looping:Bool
}

typedef AseFrame = {
	frame:Frame,
	duration:Int
}

typedef AseSize = {
	w:Int,
	h:Int
}

typedef AseMeta = {
	frameTags: Array<Animation>,
	size: AseSize,
	scale: Float,
}

typedef AseFile = {
	frames: Map<String, AseFrame>,
	meta: AseMeta
}

class TileSheet {
	public var tilesX:Float;
	public var tilesY:Float;
	
	public var image:kha.Image;
	public var frames:Array<Frame>;
	private var animations:Map<String, Animation>;
	
	var defaultAnimation:Animation;
	
	public function new(image:kha.Image, ?sheetData:kha.Blob) {
		this.image = image;
		this.frames = new Array<Frame>();
		this.animations = new Map<String, Animation>();

		if(sheetData != null) {
			parseAsepriteData(sheetData);
		}
	}
	
	public inline function getAnimation(animation:String) {
		if(animations[animation] == null) {
			return defaultAnimation;
		}
		
		return animations[animation];
	}

	public function parseAsepriteData(aseData:kha.Blob) {
		var data:AseFile = haxe.Json.parse(aseData.toString());
		
		for(s in Reflect.fields(data.frames)) {
			var f:AseFrame = Reflect.field(data.frames, s);
			
			f.frame.duration = f.duration;
			f.frame.uvx = f.frame.x / data.meta.size.w;
			f.frame.uvy = f.frame.y / data.meta.size.h;
			this.frames.push(f.frame);
			
			tilesX = f.frame.w / data.meta.size.w;
			tilesY = f.frame.h / data.meta.size.h;
		}

		for(s in data.meta.frameTags){
			this.animations[s.name] = s;
			var frameCount = s.to - s.from;
			s.totalLength = 0;
			
			s.looping = true;
			
			for(i in 0...frameCount + 1) {
				s.totalLength += this.frames[i + s.from].duration;
			}
		}
		
		var totalLength = 0;
		for(f in frames) {
			totalLength += f.duration;
		}
		
		defaultAnimation = {
			from: 0,
			to: frames.length - 1,
			name: "[default]",
			looping: true,
			totalLength: totalLength
		};
	}
	
	public function getFrame(i:Int): Frame{
		return frames[i];
	}

	public function addFrame(x:Int, y:Int, w:Int, h:Int) {
		frames.push({
			x: x,
			y: y,
			w: w,
			h: h,
			uvx:0.0,
			uvy:0.0,
			duration: 100
		});
	}

	public function addAnimation(name:String, from:Int, to:Int) {
		animations[name] = {
			name: name,
			from: from,
			to: to,
			totalLength: 0,
			looping: true
		};
	}
}