
#ifndef _ML_LIBCLANG_CURSOR_H
#define _ML_LIBCLANG_CURSOR_H

#define CXCursor_val(v) (*((CXCursor *)Data_custom_val(v)))

extern value ml_libclang_alloc_cxcursor(CXCursor cursor);

#endif
