package kek.math;
import kha.math.Vector3;

class Plane {
	public var d:Float;
	
	public var point:Vector3;
	
	public var normal:Vector3;
	
	public function new() {
		d = 0.0;
		point = new Vector3();
		normal = new Vector3();
	}
	
	private static var aux1:Vector3 = new Vector3();
	private static var aux2:Vector3 = new Vector3();
	public function set3Points(a:Vector3, b:Vector3, c:Vector3) {
	
		kek.math.Vector3Utils.sub3(aux1, a, b);
		kek.math.Vector3Utils.sub3(aux2, c, b);
		kek.math.Vector3Utils.cross3(normal, aux2, aux1);
		
		normal.normalize();
		point.x = b.x;
		point.y = b.y;
		point.z = b.z;
		d = -(normal.dot(point));
	}
	
	public function setCoefficients(x:Float, y:Float, z:Float, d:Float) {
		normal.x = x;
		normal.y = y;
		normal.z = z;
		
		var l = normal.length;
		normal.x = x / l;
		normal.y = y / l;
		normal.z = z / l;
		
		d = d / l;
	}
	
	public function setNormalAndPoint(normal:Vector3, point:Vector3) {
		this.normal.x = normal.x;
		this.normal.y = normal.y;
		this.normal.z = normal.z;
		
		this.normal.normalize();
		
		d = -(normal.dot(point));
	}
	
	public function distance(p:Vector3):Float {
		return d + normal.dot(p);
	}
}