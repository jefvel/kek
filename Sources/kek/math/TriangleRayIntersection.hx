package kek.math;

import kha.math.Vector3;

class TriangleRayIntersection {
	static var e1:Vector3 = new Vector3();
	static var e2:Vector3 = new Vector3();
	static var P:Vector3 = new Vector3();
	static var Q:Vector3 = new Vector3();
	static var T:Vector3 = new Vector3();
	static var det:Float;
	static var inv_det:Float;
	static var u:Float;
	static var v:Float;
	static var t:Float;
	
	static inline var EPSILON = 0.000001;
	
	public static function intersection(v1:kha.math.Vector3,
										v2:kha.math.Vector3,
										v3:kha.math.Vector3,
										origin:kha.math.Vector3,
										dir:kha.math.Vector3,
										out:kha.math.Vector3):Bool {
		MathUtils.sub3(e1, v2, v1);
		MathUtils.sub3(e2, v3, v1);
		
		MathUtils.cross3(P, dir, e2);
		
		det = e1.dot(P);
		
		if(det > -EPSILON && det < EPSILON) {
			return false;
		}
		
		inv_det = 1.0 / det;
		
		MathUtils.sub3(T, origin, v1);
		
		u = T.dot(P) * inv_det;

		if(u < 0.0 || u > 1.0) {
			return false;
		}
		
		MathUtils.cross3(Q, T, e1);

		v = dir.dot(Q) * inv_det;

		if(v < 0.0 || u + v > 1.0) {
			return false;
		}
		
		t = e2.dot(Q) * inv_det;

		if(t > EPSILON) {
			out.x = origin.x + dir.x * t;
			out.y = origin.y + dir.y * t;
			out.z = origin.z + dir.z * t;
			
			return true;
		}
		
		return false;
	}
}