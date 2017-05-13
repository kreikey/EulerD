//template bleh(T) {
struct SimpleQueue(T) {
	private:
	T[] iqueue;
	int startIndex = 0;
	int endIndex = 0;
	int lengthIncrement = 10;
	public:
	void enqueue(T n) {
		//writeln("length: ", iqueue.length);
		//writeln("bleh");
		if (iqueue.length == endIndex) {
			iqueue.length += lengthIncrement;
		}
		//writeln("length: ", iqueue.length);
		iqueue[endIndex++] = n;
	}
	T dequeue() {
		return iqueue[startIndex++];
	}
	bool isEmpty() {
		if (startIndex == endIndex)
			return true;
		else
			return false;
	}

}
//}
//simpleQueue!int;
//simpleQueue!char;