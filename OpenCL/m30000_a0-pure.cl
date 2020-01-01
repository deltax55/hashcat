/**
 * Author......: See docs/credits.txt
 * License.....: MIT
 */

//#define NEW_SIMD_CODE

#ifdef KERNEL_STATIC
#include "inc_vendor.h"
#include "inc_types.h"
#include "inc_platform.cl"
#include "inc_common.cl"
#include "inc_rp.h"
#include "inc_rp.cl"
#include "inc_scalar.cl"
#include "inc_hash_md5.cl"
#endif

KERNEL_FQ void m30000_mxx (KERN_ATTR_RULES ())
{
  /**
   * modifier
   */

  const u64 lid = get_local_id (0);
  const u64 gid = get_global_id (0);

  if (gid >= gid_max) return;

  /**
   * base
   */

  COPY_PW (pws[gid]);

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < il_cnt; il_pos++)
  {
    pw_t tmp = PASTE_PW;

    tmp.pw_len = apply_rules (rules_buf[il_pos].cmds, tmp.i, tmp.pw_len);

    md5_ctx_t ctx;

    md5_init (&ctx);

    md5_update (&ctx, tmp.i, tmp.pw_len);

    md5_final (&ctx);

    u8 buff[16];
    buff[0]  = ((u8) (ctx.h[0] >>  0));
    buff[1]  = ((u8) (ctx.h[0] >>  8));
    buff[2]  = ((u8) (ctx.h[0] >> 16));
    buff[3]  = ((u8) (ctx.h[0] >> 24));
    buff[4]  = ((u8) (ctx.h[3] >>  0));
    buff[5]  = ((u8) (ctx.h[3] >>  8));
    buff[6]  = ((u8) (ctx.h[3] >> 16));
    buff[7]  = ((u8) (ctx.h[3] >> 24));
    buff[8]  = ((u8) (ctx.h[2] >>  0));
    buff[9]  = ((u8) (ctx.h[2] >>  8));
    buff[10] = ((u8) (ctx.h[2] >> 16));
    buff[11] = ((u8) (ctx.h[2] >> 24));
    buff[12] = ((u8) (ctx.h[1] >>  0));
    buff[13] = ((u8) (ctx.h[1] >>  8));
    buff[14] = ((u8) (ctx.h[1] >> 16));
    buff[15] = ((u8) (ctx.h[1] >> 24));

    u8 temp_result[8];

    for(int i = 0; i<8; i++)
    {
      u8 tmp = (buff[2*i] + buff[2*i+1]) % 0x3e;
      if(tmp > 9)
      {
        if(tmp > 35)
        {
          tmp += 61;
        }
        else
        {
          tmp += 55;
        }
      }
      else
      {
        tmp += 0x30;
      }
      temp_result[i] = tmp;
    }

    u16x result[4];

    for(int i = 0; i<4; i++)
    {
      result[i] |= ((u16) (temp_result[2*i]   >> 0));
      result[i] |= ((u16) (temp_result[2*i+1] >> 8));
    }

    const u16x r0 = result[0];
    const u16x r1 = result[3];
    const u16x r2 = result[2];
    const u16x r3 = result[1];

    COMPARE_M_SCALAR (r0, r1, r2, r3);
  }
}

KERNEL_FQ void m30000_sxx (KERN_ATTR_RULES ())
{
  /**
   * modifier
   */

  const u64 lid = get_local_id (0);
  const u64 gid = get_global_id (0);

  if (gid >= gid_max) return;

  /**
   * digest
   */

  const u16 search[4] =
  {
    ((u16) (digests_buf[digests_offset].digest_buf[0] >>  0)),
    ((u16) (digests_buf[digests_offset].digest_buf[0] >> 16)),
    ((u16) (digests_buf[digests_offset].digest_buf[1] >>  0)),
    ((u16) (digests_buf[digests_offset].digest_buf[1] >> 16))
  };

  /**
   * base
   */

  COPY_PW (pws[gid]);

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < il_cnt; il_pos++)
  {
    pw_t tmp = PASTE_PW;

    tmp.pw_len = apply_rules (rules_buf[il_pos].cmds, tmp.i, tmp.pw_len);

    md5_ctx_t ctx;

    md5_init (&ctx);

    md5_update (&ctx, tmp.i, tmp.pw_len);

    md5_final (&ctx);

    u8 buff[16];
    buff[0]  = ((u8) (ctx.h[0] >>  0));
    buff[1]  = ((u8) (ctx.h[0] >>  8));
    buff[2]  = ((u8) (ctx.h[0] >> 16));
    buff[3]  = ((u8) (ctx.h[0] >> 24));
    buff[4]  = ((u8) (ctx.h[3] >>  0));
    buff[5]  = ((u8) (ctx.h[3] >>  8));
    buff[6]  = ((u8) (ctx.h[3] >> 16));
    buff[7]  = ((u8) (ctx.h[3] >> 24));
    buff[8]  = ((u8) (ctx.h[2] >>  0));
    buff[9]  = ((u8) (ctx.h[2] >>  8));
    buff[10] = ((u8) (ctx.h[2] >> 16));
    buff[11] = ((u8) (ctx.h[2] >> 24));
    buff[12] = ((u8) (ctx.h[1] >>  0));
    buff[13] = ((u8) (ctx.h[1] >>  8));
    buff[14] = ((u8) (ctx.h[1] >> 16));
    buff[15] = ((u8) (ctx.h[1] >> 24));

    u8 temp_result[8];

    for(int i = 0; i<8; i++)
    {
      u8 tmp = (buff[2*i] + buff[2*i+1]) % 0x3e;
      if(tmp > 9)
      {
        if(tmp > 35)
        {
          tmp += 61;
        }
        else
        {
          tmp += 55;
        }
      }
      else
      {
        tmp += 0x30;
      }
      temp_result[i] = tmp;
    }

    u16x result[4];

    for(int i = 0; i<4; i++)
    {
      result[i] |= ((u16) (temp_result[2*i]   << 0));
      result[i] |= ((u16) (temp_result[2*i+1] << 8));
    }

    const u16x r0 = result[0];
    const u16x r1 = result[3];
    const u16x r2 = result[2];
    const u16x r3 = result[1];

    COMPARE_S_SCALAR (r0, r1, r2, r3);
  }
}
