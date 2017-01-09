package kek.component;

class ObjectSpace {

	static var nextId: Int = 0;
	public function new(){

	}
	
	public function generateObjectId() {
		return ++nextId;
	}
}