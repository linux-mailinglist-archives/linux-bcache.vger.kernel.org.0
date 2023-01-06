Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDE8660770
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jan 2023 20:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbjAFTyI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Jan 2023 14:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbjAFTxi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Jan 2023 14:53:38 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99317840B5
        for <linux-bcache@vger.kernel.org>; Fri,  6 Jan 2023 11:53:25 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso6217337pjp.4
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jan 2023 11:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4I/xxvLvEdw5CdlPW8yO+tvB+gpNxNcsXl58L2+adEY=;
        b=OsYKUXbDBbZwtNF4SSg/XY8bwXtGBtu/AJt9KGQsitP9N/G2EIDrH++J8Tx44dUnr5
         HthfVayk6ve2BD06ngqztkeCLTVZfcyo4LzimjyCD2B/K/GEshBO5h03gpVPOn7DiMPV
         sPn7hExpTh04ZTlsoS29JoH3kNUw6QS61qMws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4I/xxvLvEdw5CdlPW8yO+tvB+gpNxNcsXl58L2+adEY=;
        b=bP/U/xtA1A+/kqTq0ihCMuAENS3iBrdagpIY8i1TTRqgYwWX/ULOLBNBow3uATWFrt
         1xav3qqmVtTYjPl5clBiP0IGu/0f1acFVtFlCKbceSS/IY2z+XMaRC0YF0lSpVMUieLu
         +DyZfZi+2FVXRSDN8eag8s//AbTgeEZAaG/e/yOB7gxPAcUaxzRQJcrvDjka7o+ofZDz
         S0h+Xg/wpTJ7tjJzpJXm5dXac9/tTyqSD9/xvW48T8pI8hiI3QSTCCieLaPx5iw94GbQ
         u3sUoE8jgHp7apMBmKIQU9eGdRG/+7zqlsRmHqHLcHGO0WwPDf0ELb+QGWKN3meCklE7
         7nnw==
X-Gm-Message-State: AFqh2koEPDThhElTGQX3Ab+5gViRKQqqeT3t1fDfb9HJ4m/nwMCFEe7R
        bAeDJRJPrLTsnXckdWfVLVQLXA==
X-Google-Smtp-Source: AMrXdXuZg1vPaJ8420PkIjzFTxJknNuhUw+LNTWoSgPRBAEzvpaKWbRhOq9b6OLF4eMxrSPTtAXgtg==
X-Received: by 2002:a17:90b:246:b0:225:fb71:e64d with SMTP id fz6-20020a17090b024600b00225fb71e64dmr43555231pjb.7.1673034805128;
        Fri, 06 Jan 2023 11:53:25 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090a890300b00218cd71781csm1247818pjn.51.2023.01.06.11.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 11:53:24 -0800 (PST)
Date:   Fri, 6 Jan 2023 11:53:23 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Coly Li <colyli@suse.de>
Cc:     Thorsten Leemhuis <linux@leemhuis.info>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bcache: Silence memcpy() run-time false positive warnings
Message-ID: <202301061125.2041FE82D@keescook>
References: <20230106060229.never.047-kees@kernel.org>
 <CBD781CA-342F-482A-A5B0-C4EE2D7FE11B@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CBD781CA-342F-482A-A5B0-C4EE2D7FE11B@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Jan 06, 2023 at 09:39:16PM +0800, Coly Li wrote:
> 
> 
> > 2023年1月6日 14:02，Kees Cook <keescook@chromium.org> 写道：
> > 
> > struct bkey has internal padding in a union, but it isn't always named
> > the same (e.g. key ## _pad, key_p, etc). This makes it extremely hard
> > for the compiler to reason about the available size of copies done
> > against such keys. Use unsafe_memcpy() for now, to silence the many
> > run-time false positive warnings:
> > 
> 
> The keys is embedded in multiple data structures as a generalized model with some helpers, bkey_bytes() is one of them.

Yeah, if the helpers were able to operate on the padding variable (rather than
the key), then the compiler would be in a better position to figure out
bounds checking. Right now it sees the destination as the key and then
the size as larger than the key (but equal to the union's padding
variable -- but it doesn't "know" about that).

> >  memcpy: detected field-spanning write (size 264) of single field "&i->j" at drivers/md/bcache/journal.c:152 (size 240)
> >  memcpy: detected field-spanning write (size 24) of single field "&b->key" at drivers/md/bcache/btree.c:939 (size 16)
> >  memcpy: detected field-spanning write (size 24) of single field "&temp.key" at drivers/md/bcache/extents.c:428 (size 16)
> > 
> 
> How does the above information can be founded? Should I use llvm and enable FORTIFY_SOURCE?

It was reported at run-time under a kernel built with
CONFIG_FORTIFY_SOURCE=y (See https://bugzilla.kernel.org/show_bug.cgi?id=216785)

> I don’t say the bkey and bkey_bytes() stuffs are elegant, but why the compiler cannot find such situation? IMHO it is quite similar to something like “struct foo *bar[0]” at the end of a data structure.

Nit: "bar[0]" is deprecated in favor of "bar[]" or
DECLARE_FLEX_ARRAY(...) where needed, see:
https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
and here is the patch that fixes this:
https://lore.kernel.org/all/YzIc8z+QaHvqPjLX@work/

But to answer the question, what's happening is mostly due to a
(specification?) bug in GCC and Clang (where it can't tell an outer
struct contains an inner struct that ends in a flexible array), so this:

struct jset {
	...
        union {
                struct bkey     start[0];
                __u64           d[0];
        };
};

looks like it has a fixed size, when in fact it doesn't.
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101832
There is disagreement within GCC about whether or not this behavior is
"by design", so for the meantime, we have to work around it in the
kernel.

So the first warning comes from:

	memcpy(&i->j, j, bytes);

where the compiler thinks the object pointed at by "&i->j" is fixed size,
as it doesn't "see" the trailing flexible arrays within j.

The other 2 warnings come from the same problem, but they're from
struct bkey and the union created by BKEY_PADDED(). Here's everything
I could see:

struct bkey {
        __u64   high;
        __u64   low;
        __u64   ptr[];
};

#define BKEY_PADDED(key)                                        \
        union { struct bkey key; __u64 key ## _pad[BKEY_PAD]; }

#define BITMASK(name, type, field, offset, size)                \
static inline __u64 name(const type *k)                         \
{ return (k->field >> offset) & ~(~0ULL << size); }             \

#define KEY_FIELD(name, field, offset, size) \
        BITMASK(name, struct bkey, field, offset, size)

KEY_FIELD(KEY_PTRS,     high, 60, 3)


static inline unsigned long bkey_u64s(const struct bkey *k)
{
        return (sizeof(struct bkey) / sizeof(__u64)) + KEY_PTRS(k);
}

static inline unsigned long bkey_bytes(const struct bkey *k)
{
        return bkey_u64s(k) * sizeof(__u64);
}

#define bkey_copy(_dest, _src)  memcpy(_dest, _src, bkey_bytes(_src))


	BKEY_PADDED(key) temp;
	bkey_copy(&temp.key, k);

So, again, the memcpy() in bkey_copy() can't see into &temp.key to
notice the trailing flexible array, and thinks it is copying "too much".

However, in both cases, the bounds checking is being performed (first by
set_bytes(), and in the latter two, by bkey_bytes()), so the direct fix
is to just disable the FORTIFY checking on these memcpy() uses.

> > Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> > Link: https://lore.kernel.org/all/19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.info/
> > Cc: Coly Li <colyli@suse.de>
> > Cc: Kent Overstreet <kent.overstreet@gmail.com>
> > Cc: linux-bcache@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> The code comments as justification is informative. Thanks for this.
> 
> Acked-by: Coly Li <colyli@suse.de>

Thanks!

-Kees

-- 
Kees Cook
