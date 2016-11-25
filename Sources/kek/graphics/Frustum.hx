package kek.graphics;

import kek.math.Vector3Utils;
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
	
	public var minPoint:Vector3;
	public var maxPoint:Vector3;
	
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
		
		maxPoint = new Vector3();
		minPoint = new Vector3();
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
		Vector3Utils.sub3(Z, pos, eye);
		Z.normalize();
		
		Vector3Utils.cross3(X, up, Z);
		X.normalize();

		Vector3Utils.cross3(Y, Z, X);

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
		
		calculateFrustumPoints();

		// TOP
		aux.x = nc.x + Y.x * nh;
		aux.y = nc.y + Y.y * nh;
		aux.z = nc.z + Y.z * nh;
		Vector3Utils.sub3(aux, aux, pos);
		aux.normalize();
		Vector3Utils.cross3(normal, aux, X);
		
		aux2.x = nc.x + Y.x * nh;
		aux2.y = nc.y + Y.y * nh;
		aux2.z = nc.z + Y.z * nh;
		planes[TOP].setNormalAndPoint(normal, aux2);
		
		
		// BOTTOM
		aux.x = nc.x - Y.x * nh;
		aux.y = nc.y - Y.y * nh;
		aux.z = nc.z - Y.z * nh;
		Vector3Utils.sub3(aux, aux, pos);
		aux.normalize();
		Vector3Utils.cross3(normal, X, aux);
		
		aux2.x = nc.x - Y.x * nh;
		aux2.y = nc.y - Y.y * nh;
		aux2.z = nc.z - Y.z * nh;
		planes[BOTTOM].setNormalAndPoint(normal, aux2);
		
		// LEFT
		aux.x = nc.x - X.x * nw;
		aux.y = nc.y - X.y * nw;
		aux.z = nc.z - X.z * nw;
		Vector3Utils.sub3(aux, aux, pos);
		aux.normalize();
		Vector3Utils.cross3(normal, aux, Y);
		
		aux2.x = nc.x - X.x * nw;
		aux2.y = nc.y - X.y * nw;
		aux2.z = nc.z - X.z * nw;
		planes[LEFT].setNormalAndPoint(normal, aux2);
		
		
		// RIGHT
		aux.x = nc.x + X.x * nw;
		aux.y = nc.y + X.y * nw;
		aux.z = nc.z + X.z * nw;
		Vector3Utils.sub3(aux, aux, pos);
		aux.normalize();
		Vector3Utils.cross3(normal, Y, aux);
		
		aux2.x = nc.x + X.x * nw;
		aux2.y = nc.y + X.y * nw;
		aux2.z = nc.z + X.z * nw;
		planes[RIGHT].setNormalAndPoint(normal, aux2);
	}
	

	inline function calculateFrustumPoints() {
	
		aux.x = aux.y = aux.z = Math.POSITIVE_INFINITY;
		Vector3Utils.copy3(minPoint, aux);
		
		aux.x = aux.y = aux.z = Math.NEGATIVE_INFINITY;
		Vector3Utils.copy3(maxPoint, aux);
		
		// Near planes
		Vector3Utils.mul3f(aux, Y, nh); // Y * nh
		Vector3Utils.mul3f(aux2, X, nw); // X * nw
		
		Vector3Utils.copy3(ntl, nc);
		Vector3Utils.add3(ntl, ntl, aux);
		Vector3Utils.sub3(ntl, ntl, aux2);
		
		Vector3Utils.copy3(ntr, nc);
		Vector3Utils.add3(ntr, ntr, aux);
		Vector3Utils.add3(ntr, ntr, aux2);
		
		Vector3Utils.copy3(nbl, nc);
		Vector3Utils.sub3(nbl, nbl, aux);
		Vector3Utils.sub3(nbl, nbl, aux2);
		
		Vector3Utils.copy3(nbr, nc);
		Vector3Utils.sub3(nbr, nbr, aux);
		Vector3Utils.add3(nbr, nbr, aux2);

		// Far planes
		Vector3Utils.mul3f(aux, Y, fh); // Y * fh
		Vector3Utils.mul3f(aux2, X, fw); // X * fw
		
		Vector3Utils.copy3(ftl, fc);
		Vector3Utils.add3(ftl, ftl, aux);
		Vector3Utils.sub3(ftl, ftl, aux2);
		
		Vector3Utils.copy3(ftr, fc);
		Vector3Utils.add3(ftr, ftr, aux);
		Vector3Utils.add3(ftr, ftr, aux2);
		
		Vector3Utils.copy3(fbl, fc);
		Vector3Utils.sub3(fbl, fbl, aux);
		Vector3Utils.sub3(fbl, fbl, aux2);
		
		Vector3Utils.copy3(fbr, fc);
		Vector3Utils.sub3(fbr, fbr, aux);
		Vector3Utils.add3(fbr, fbr, aux2);
		
		//CAlculate max and min points for AABB of frustum
		Vector3Utils.min3(minPoint, minPoint, ntl);
		Vector3Utils.min3(minPoint, minPoint, ntr);
		Vector3Utils.min3(minPoint, minPoint, nbl);
		Vector3Utils.min3(minPoint, minPoint, nbr);
		
		Vector3Utils.min3(minPoint, minPoint, ftl);
		Vector3Utils.min3(minPoint, minPoint, ftr);
		Vector3Utils.min3(minPoint, minPoint, fbl);
		Vector3Utils.min3(minPoint, minPoint, fbr);
		
		
		Vector3Utils.max3(maxPoint, maxPoint, ntl);
		Vector3Utils.max3(maxPoint, maxPoint, ntr);
		Vector3Utils.max3(maxPoint, maxPoint, nbl);
		Vector3Utils.max3(maxPoint, maxPoint, nbr);
		
		Vector3Utils.max3(maxPoint, maxPoint, ftl);
		Vector3Utils.max3(maxPoint, maxPoint, ftr);
		Vector3Utils.max3(maxPoint, maxPoint, fbl);
		Vector3Utils.max3(maxPoint, maxPoint, fbr);
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