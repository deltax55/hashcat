/**
 * Author......: See docs/credits.txt
 * License.....: MIT
 */

#ifndef _EXT_LZMA_H

#include <LzmaDec.h>
#include <Lzma2Dec.h>

#if defined(USE_SYSTEM_ZLIB) && USE_SYSTEM_ZLIB
#include <minizip/ioapi.h>
#include <minizip/unzip.h>
#else
#include "contrib/minizip/ioapi.h"
#include "contrib/minizip/unzip.h"
#endif

int hc_lzma1_decompress (const unsigned char *in, SizeT *in_len, unsigned char *out, SizeT *out_len, const char *props);
int hc_lzma2_decompress (const unsigned char *in, SizeT *in_len, unsigned char *out, SizeT *out_len, const char *props);

void *hc_lzma_alloc (MAYBE_UNUSED ISzAllocPtr p, size_t size);
void  hc_lzma_free  (MAYBE_UNUSED ISzAllocPtr p, void *address);

#endif // _EXT_LZMA_H
