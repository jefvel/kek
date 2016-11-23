package kek.math;
import kha.math.Vector3;

class MathUtils {

	public static inline function cross3 (out:Vector3, a:Vector3, b:Vector3) {
		out.x = a.y * b.z - a.z * b.y;
		out.y = a.z * b.x - a.x * b.z;
		out.z = a.x * b.y - a.y * b.x;
	}
	
	public static inline function sub3(out:Vector3, a:Vector3, b:Vector3) {
		out.x = a.x - b.x;
		out.y = a.y - b.y;
		out.z = a.z - b.z;
	}
	
	public static inline function add3(out:Vector3, a:Vector3, b:Vector3) {
		out.x = a.x + b.x;
		out.y = a.y + b.y;
		out.z = a.z + b.z;
	}
	
	public static inline function mul3(out:Vector3, a:Vector3, b:Vector3) {
		out.x = a.x * b.x;
		out.y = a.y * b.y;
		out.z = a.z * b.z;
	}
	
	public static function dot3(a:Vector3, b:Vector3) {
		return a.dot(b);
	}
}