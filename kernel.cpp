// Extern C functions used here cuz the bootloader needs to resolve the names of our functions duh

extern "C" void main(){
    *(char*)0xb8000 = 'Q'; // apathy
    return;
}
