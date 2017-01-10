package kek.graphics;

import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.MipMapFilter;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.Shaders;
import kha.Image;
import kha.graphics4.TextureAddressing;
import kha.graphics4.TextureFormat;
import kha.graphics4.TextureFilter;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;

class PostprocessingBuffer {
    
    var texture:kha.Image;
    public var graphics(get, null):kha.graphics4.Graphics;
    public var g2(get, null):kha.graphics2.Graphics;
    public var width:Int;
    public var height:Int;
    
    var pipeline:PipelineState;
    var structure:VertexStructure;
    
    var texUnit:TextureUnit;
    
    var screenSizeLocation:ConstantLocation;
    var textureSizeLocation:ConstantLocation;
    var timeLocation:ConstantLocation;
    
    var vBuf:VertexBuffer;
    var iBuf:IndexBuffer;
    var verts = [
        -1.0, -1.0,
        -1.0, 1.0,
        1.0, 1.0,
        1.0, -1.0
    ];
    
    var indices = [
        0, 1, 3,
        1, 2, 3
    ];
    
    var startTime:Float;
    
    public var pixelSize:Int = 2;
    
    public function new() {            
        startTime = kha.Scheduler.realTime();
        structure = new VertexStructure();
        structure.add("pos", VertexData.Float2);
        
        pipeline = new PipelineState();
        pipeline.inputLayout = [structure];
        pipeline.fragmentShader = Shaders.postfx_frag;
        pipeline.vertexShader = Shaders.postfx_vert;
        
        pipeline.depthWrite = false;
        
        pipeline.compile();
        
        vBuf = new VertexBuffer(4, structure, Usage.StaticUsage);
        iBuf = new IndexBuffer(6, Usage.StaticUsage);
        
        var v = vBuf.lock();
        for(i in 0...verts.length) v.set(i, verts[i]);
        vBuf.unlock();
        
        var ib = iBuf.lock();
        for(i in 0...indices.length) ib[i] = indices[i];
        iBuf.unlock();
        
        texUnit = pipeline.getTextureUnit("buff");
        screenSizeLocation = pipeline.getConstantLocation("screenSize");
        textureSizeLocation = pipeline.getConstantLocation("textureSize");
        timeLocation = pipeline.getConstantLocation("time");
    }
    
    public function clear(?color:kha.Color, ?depth:Float, ?stencil:Int) {
		texture.g4.clear(color, depth, stencil);
    }
    
    public function get_graphics():kha.graphics4.Graphics {
        return texture.g4;
    }
    
    public function get_g2():kha.graphics2.Graphics {
        return texture.g2;
    }
    
    var lastWidth = 0;
    var lastHeight = 0;
    
    function nearestPowerOfTwo(i:Int) {
        //return i;
        
        var r = 1;
        while(r < i) {
            r *= 2;
        }
        
        return r;
    }
    
    public function begin(f:kha.Framebuffer) {
        if(texture == null || f.width != lastWidth || f.height != lastHeight){
            lastHeight = f.height;
            lastWidth = f.width;
            
            if(texture != null) {
                texture.unload();
            }
            
            this.width = Std.int(f.width / pixelSize);
            this.height = Std.int(f.height / pixelSize);
            
            texture = kha.Image.createRenderTarget(
                nearestPowerOfTwo(width), nearestPowerOfTwo(height),
                TextureFormat.RGBA32, 
                kha.graphics4.DepthStencilFormat.DepthOnly, 0);
        }
        
        this.graphics.begin();
        this.graphics.viewport(0, texture.height - height, width, height);
    }
    
    public function end(f:kha.Framebuffer) {
        var g4 = f.g4;
        g4.end();
        
        g4.setPipeline(pipeline);
        g4.setFloat(timeLocation, kha.Scheduler.realTime() - startTime);
        g4.begin();
        
        var kanvas = kha.ScreenCanvas.the;
        g4.viewport(0, 0, kanvas.width, kanvas.height);
        
        g4.setFloat2(screenSizeLocation, kanvas.width, kanvas.height);
        g4.setFloat2(textureSizeLocation, texture.width * pixelSize, texture.height * pixelSize);
        
        g4.setTexture(texUnit, texture);
        
        g4.setTextureParameters(texUnit, 
            TextureAddressing.Repeat, 
            TextureAddressing.Repeat, 
            TextureFilter.PointFilter, 
            TextureFilter.PointFilter, 
            MipMapFilter.NoMipFilter
        );
       
        g4.clear(kha.Color.White);
        g4.setVertexBuffer(vBuf);
        g4.setIndexBuffer(iBuf);
        g4.drawIndexedVertices();
        
        g4.end();
    }
}