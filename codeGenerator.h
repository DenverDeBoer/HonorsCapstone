/*
 * Code Generator
 * Will be used to be able to create
 * code at either current or a previous location.
 * Primarily needed for conditional statements where not all
 * code will have to be executed
 * Created by: Denver DeBoer
 */
#ifndef CODE_GENERATOR
#define CODE_GENERATOR

#include "stackMachine.h"

//Initial offset for data location
int dataOffset = 0;

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
int reserveLocation()
{
	return codeOffset++;
}

//Generate code at current location
void generateCode(enum codeOps operation, int arg)
{
	code[codeOffset].op = operation;
	code[codeOffset++].arg = arg;
}

//Generate code at reserved location
void backpatch(int address, enum codeOps operation, int arg)
{
	code[address].op = operation;
	code[address].arg = arg;
}

//Print operation instruction and corresponding argument value
//void printCode()
//{
//	int i = 0;
//	while(i < codeOffset) {
//		printf("%3ld: %-10s%4ld\n",i,opName[(int) code[i].op], code[i].arg );
//		i++;
//	}
//}

#endif
