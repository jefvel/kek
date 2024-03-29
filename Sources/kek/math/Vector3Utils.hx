package kek.math;
import kha.math.Vector3;

class Vector3Utils {

	public static inline function cross3 (out:Vector3, a:Vector3, b:Vector3) {
		out.x = a.y * b.z - a.z * b.y;
		out.y = a.z * b.x - a.x * b.z;
		out.z = a.x * b.y - a.y * b.x;
	}
	
	public static inline function sub3 (out:Vector3, a:Vector3, b:Vector3) {
		out.x = a.x - b.x;
		out.y = a.y - b.y;
		out.z = a.z - b.z;
	}
	
	public static inline function add3 (out:Vector3, a:Vector3, b:Vector3) {
		out.x = a.x + b.x;
		out.y = a.y + b.y;
		out.z = a.z + b.z;
	}
	
	public static inline function mul3 (out:Vector3, a:Vector3, b:Vector3) {
		out.x = a.x * b.x;
		out.y = a.y * b.y;
		out.z = a.z * b.z;
	}
	
	public static inline function dot3(a:Vector3, b:Vector3) {
		return a.dot(b);
	}

	public static inline function copy3(to:Vector3, from:Vector3) {
		to.x = from.x;
		to.y = from.y;
		to.z = from.z;
	}
	
	public static inline function mul3f(out:Vector3, vec:Vector3, m:Float) {
		out.x = vec.x * m;
		out.y = vec.y * m;
		out.z = vec.z * m;
	}
	
	public static function min3(out:Vector3, a:Vector3, b:Vector3) {
		out.x = Math.min(a.x, b.x);
		out.y = Math.min(a.y, b.y);
		out.z = Math.min(a.z, b.z);
	}
	
	public static function max3(out:Vector3, a:Vector3, b:Vector3) {
		out.x = Math.max(a.x, b.x);
		out.y = Math.max(a.y, b.y);
		out.z = Math.max(a.z, b.z);
	}
}