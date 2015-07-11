#include "i2c_io.h"

int i2c_read(int Addr) {
	return (Addr + 1);
}

int i2c_write(int Addr, int Data) {
	return (Addr + Data);
} 
