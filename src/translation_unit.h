
#ifndef _ML_LIBCLANG_TRANSLATION_UNIT_H
#define _ML_LIBCLANG_TRANSLATION_UNIT_H

#define CXTranslationUnit_val(v) (*((CXTranslationUnit *)Data_custom_val(v)))

extern value ml_libclang_alloc_cxtranslationunit(CXTranslationUnit tu);

#endif
