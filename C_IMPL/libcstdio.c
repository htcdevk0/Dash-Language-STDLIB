// This C code makes the better FFI implementation for io.print (instead of direct printf)

// Imports
#include <stdio.h>
// For va_list, va_start, va_end and better veriadics.
#include <stdarg.h>

// Made by: htcdevk0
// Version: 1.0.0LL

const char* __dsprintf_author[1] = {"htcdevk0"};
const char* __dsprintf_version[1] = {"1.0.0LL"};

// This function will be used by io module (libdstdio.o)
// Compiled using CLANG

int __dsprintf(char* buf, size_t cap, const char* fmt, ...) {
    va_list args;
    va_start(args, fmt);

    int written = vsnprintf(buf, cap, fmt, args);

    va_end(args);
    return written;
}

// This module is non dynamic, will be compiled for static objects (libcstdio.o)