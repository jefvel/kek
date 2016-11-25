package kek.graphics;

import kek.math.MathUtils;
import kha.math.Vector3;
import kha.math.Vector3;

@:enum
abstract FrustumLocation(Int) {
	var OUTSIDE = 0;
	var INTERSECT = 1;
	var INSIDE = 2;
}

class Frustum {

	inline static var TOP = 0;
	inline static var BOTTOM = 1;
	inline static var LEFT = 2;
	inline static var RIGHT = 3;
	inline static var NEARP = 4;
	inline static var FARP = 5;
	
	var ntl:Vector3;
	var ntr:Vector3;
	var nbl:Vector3;
	var nbr:Vector3;
	var ftl:Vector3;
	var ftr:Vector3;
	var fbl:Vector3;
	var fbr:Vector3;
	
	var nw:Float;
	var nh:Float;
	var fw:Float;
	var fh:Float;
	
	var nearD:Float;
	var farD:Float;
	var ratio:Float;
	var fov:Float;
	var tang:Float;
	
	var planes:Array<kek.math.Plane>;
	
	inline static var ANG2RAD = (3.14159265358979323846 / 180.0);

	public function new() {
		planes = new Array<kek.math.Plane>();
		for(p in 0...6) {
			planes.push(new kek.math.Plane());
		}
		
		ntl = new Vector3();
		ntr = new Vector3();
		nbl = new Vector3();
		nbr = new Vector3();
		
		ftl = new Vector3();
		ftr = new Vector3();
		fbl = new Vector3();
		fbr = new Vector3();
	}
	
	public function setCamInternals(fov:Float, ratio:Float, nearD:Float, farD:Float) {
		this.fov = fov;
		this.ratio = ratio;
		this.nearD = nearD;
		this.farD = farD;

		this.tang = Math.tan(ANG2RAD * fov * 0.5);
		this.nh = nearD * tang;
		this.nw = nh * ratio;
		this.fh = farD * tang;
		this.fw = fh * ratio;
	}
	
	var dir:Vector3 = new Vector3();
	var nc:Vector3 = new Vector3();
	var fc:Vector3 = new Vector3();
	
	var X:Vector3 = new Vector3();
	var Y:Vector3 = new Vector3();
	var Z:Vector3 = new Vector3();
	
	static var aux:Vector3 = new Vector3();
	static var aux2:Vector3 = new Vector3();
	static var normal:Vector3 = new Vector3();
	public function setCamDef(pos:Vector3, eye:Vector3, up:Vector3) {
		MathUtils.sub3(Z, pos, eye);
		Z.normalize();
		
		MathUtils.cross3(X, up, Z);
		X.normalize();

		MathUtils.cross3(Y, Z, X);

		nc.x = pos.x - Z.x * nearD;
		nc.y = pos.y - Z.y * nearD;
		nc.z = pos.z - Z.z * nearD;

		fc.x = pos.x - Z.x * farD;
		fc.y = pos.y - Z.y * farD;
		fc.z = pos.z - Z.z * farD;
		
		Z.x = -Z.x; Z.y = -Z.y; Z.z = -Z.z;
		planes[NEARP].setNormalAndPoint(Z, nc);
		
		Z.x = -Z.x; Z.y = -Z.y; Z.z = -Z.z;
		planes[FARP].setNormalAndPoint(Z, fc);

		// TOP
		aux.x = nc.x + Y.x * nh;
		aux.y = nc.y + Y.y * nh;
		aux.z = nc.z + Y.z * nh;
		MathUtils.sub3(aux, aux, pos);
		aux.normalize();
		MathUtils.cross3(normal, aux, X);
		
		aux2.x = nc.x + Y.x * nh;
		aux2.y = nc.y + Y.y * nh;
		aux2.z = nc.z + Y.z * nh;
		planes[TOP].setNormalAndPoint(normal, aux2);
		
		
		// BOTTOM
		aux.x = nc.x - Y.x * nh;
		aux.y = nc.y - Y.y * nh;
		aux.z = nc.z - Y.z * nh;
		MathUtils.sub3(aux, aux, pos);
		aux.normalize();
		MathUtils.cross3(normal, X, aux);
		
		aux2.x = nc.x - Y.x * nh;
		aux2.y = nc.y - Y.y * nh;
		aux2.z = nc.z - Y.z * nh;
		planes[BOTTOM].setNormalAndPoint(normal, aux2);
		
		
		// LEFT
		aux.x = nc.x - X.x * nw;
		aux.y = nc.y - X.y * nw;
		aux.z = nc.z - X.z * nw;
		MathUtils.sub3(aux, aux, pos);
		aux.normalize();
		MathUtils.cross3(normal, aux, Y);
		
		aux2.x = nc.x - X.x * nw;
		aux2.y = nc.y - X.y * nw;
		aux2.z = nc.z - X.z * nw;
		planes[LEFT].setNormalAndPoint(normal, aux2);
		
		
		// RIGHT
		aux.x = nc.x + X.x * nw;
		aux.y = nc.y + X.y * nw;
		aux.z = nc.z + X.z * nw;
		MathUtils.sub3(aux, aux, pos);
		aux.normalize();
		MathUtils.cross3(normal, Y, aux);
		
		aux2.x = nc.x + X.x * nw;
		aux2.y = nc.y + X.y * nw;
		aux2.z = nc.z + X.z * nw;
		planes[RIGHT].setNormalAndPoint(normal, aux2);
	}
	
	public function pointInFrustum(x:Float, y:Float, z:Float) {
	}
	
	public function boxInFrustum(
		x:Float, y:Float, z:Float,
		sizeX:Float, sizeY:Float, sizeZ:Float):FrustumLocation{
		
		var result = OUTSIDE;
		for(plane in planes) {
			aux2.x = x;
			aux2.y = y;
			aux2.z = z;
			
			if(plane.normal.x > 0) {
				aux2.x += sizeX;
			}
			
			if(plane.normal.y > 0) {
				aux2.y += sizeY;
			}
			
			if(plane.normal.z > 0) {
				aux2.z += sizeZ;
			}
			
			if(plane.distance(aux2) < 0) {
				return OUTSIDE;
			}
			
			aux2.x = x;
			aux2.y = y;
			aux2.z = z;
			if(plane.normal.x < 0) {
				aux2.x += sizeX;
			}
			
			if(plane.normal.y < 0) {
				aux2.y += sizeY;
			}
			
			if(plane.normal.z < 0) {
				aux2.z += sizeZ;
			}
			
			if(plane.distance(aux2) < 0) {
				result = INTERSECT;
			}
		}
		
		return result;
	}
	
	public function sphereInFrustum(x:Float, y:Float, z:Float, radius:Float):FrustumLocation {
		aux2.x = x;
		aux2.y = y;
		aux2.z = z;
		
		var dist;
		var res = INSIDE;
		for(plane in planes) {
			dist = plane.distance(aux2);
			if(dist < -radius) {
				return OUTSIDE;
			} else if(dist < radius) {
				res = INTERSECT;
			}
		}
		
		return res;
	}
}