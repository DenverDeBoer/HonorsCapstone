/*
 * Code Generator
 * Will be used to be able to create
 * code at either current or a previous location.
 * Primarily needed for conditional statements where not all
 * code will have to be executed
 */

int dataOffset = 0;	//Initial offset for data location

//Returns a reserved location for data
int dataLocation() {
	return dataOffset++;
}

int codeOffset = 0;	//Initial offset for code location

//Returns the current offset of the code
int codeLocation()
{
	return codeOffset;
}

//Returns reserved code location
int reservedLocation()
{
	return codeOffset++;
}

//Generate code at current location
void generateCode(enum codeOps operation, int arg)
{
	code[codeOffset].op = operation;
	code[codeOffset].arg = arg;
}

//Generate code at reserved location
void backpatch(int address, enum codeOps operation, int arg)
{
	code[address].op = operation;
	code[address].arg = arg;
}
