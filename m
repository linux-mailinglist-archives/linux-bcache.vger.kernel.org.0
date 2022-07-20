Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A731A57B6AD
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Jul 2022 14:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiGTMo7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Jul 2022 08:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiGTMo5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Jul 2022 08:44:57 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB2F6D2DE
        for <linux-bcache@vger.kernel.org>; Wed, 20 Jul 2022 05:44:56 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id o1so13506616qkg.9
        for <linux-bcache@vger.kernel.org>; Wed, 20 Jul 2022 05:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p9pBMImG/W17qKBRIaoDji+W1PG2tbpW4E72jRMgrFs=;
        b=ijYYT+QhRVFpUnqHZMXIxLXcayXC5QXFSBFrfTAyykDS0ixrQgGqgmunr3/BCBoend
         5qrLwyJyNYGQsPBKYgU01bEHP+Wb1X6e8MD4vJ+8sP0ru3/cxjWmYk9zQyq9c/ZBNnX5
         yJXPNVex1uQe0021wZrKaJdFxSgdV5kIE/J5ljYXHxbMKalMO7o7hWEu7QrD2Yyo9tyq
         55QfQFFTQuYMgBdh1bmrcyF8QArTG5cX9ebRMknmUzWbmbwk1vhMVkfDgdfvfDDwyebC
         Sn4c4hPfj5onmovtRCiOzT3fFyqVlNsKMtxHMB0dpkuXUJp4BfkjTPz9eIX7NA73Rigl
         6Kug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p9pBMImG/W17qKBRIaoDji+W1PG2tbpW4E72jRMgrFs=;
        b=uhGjmiJkRgj29Kq7wWk9LNTRYf12/chEb5D79krdES5wiRhX/zabanaK+sJyOEyEQa
         NgskthBPbzPqRu1zMZ5ZIFpbgEy/SLAWHto9e3KE0E4f7NnSt6A9DHLkgLLUV0O+qWNc
         pfwWhGj6sIEgtAZYinK8reTyYpErz6pPvCUMwe3H3AI2p2KQvCAy/sVm9L26sAS2RG1N
         bWo76eYeHRFX1oVQCr6i+yPrksYudBhfKH4B8aMz6n2b13euxCn+P56ebtz0IW/40yui
         Yt6PuzerRxNz7cdsKR80BDA3uMTia9mAhHErK+8DGaebtGz+BXjxDwYgD5dR/ZAsE5wV
         OKxA==
X-Gm-Message-State: AJIora/K7RltJf4GKtV5BM6xNdX20xqYZX1IUYNcLlikhZxLqIaw2Buj
        Fa5fTnkansSVNuPvE6fSXQ7qhmSmby8lqsOSeYj/z9M75+QjlNc7
X-Google-Smtp-Source: AGRyM1uirFSTHXGWG+YecfQ/1K18sixDlfifGPcYxiHKijIgN1use8+H/WoZRsnUdOIctgPLjZuYtIr+x4/0dTAJqpE=
X-Received: by 2002:a05:620a:d49:b0:6b5:c59b:76ac with SMTP id
 o9-20020a05620a0d4900b006b5c59b76acmr19639598qkl.412.1658321095943; Wed, 20
 Jul 2022 05:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220720121645.2834133-1-williamsukatube@163.com>
In-Reply-To: <20220720121645.2834133-1-williamsukatube@163.com>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Wed, 20 Jul 2022 14:44:45 +0200
Message-ID: <CAHykVA5k8H-=1NE+07iETD5rGZZFK0RaSXuvjgwwNPrW8ea4Jg@mail.gmail.com>
Subject: Re: [PATCH -next] bcache: Fix spelling mistakes
To:     williamsukatube@163.com
Cc:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jul 20, 2022 at 2:17 PM <williamsukatube@163.com> wrote:
>
> From: William Dean <williamsukatube@gmail.com>
>
> Fix follow spelling misktakes:
>         automatical  ==> automatic
>         arount ==> around
>         individial  ==> around
Shouldn't be individial ==> individual instead of around ?

Andrea
>         embeddded  ==> embedded
>         addionally  ==> additionally
>         unncessary  ==> unnecessary
>         definitly  ==> definitely
>
> Reported-by: Hacash Robot <hacashRobot@santino.com>
> Signed-off-by: William Dean <williamsukatube@gmail.com>
> ---
>  drivers/md/bcache/bcache.h    | 2 +-
>  drivers/md/bcache/bset.h      | 2 +-
>  drivers/md/bcache/btree.c     | 2 +-
>  drivers/md/bcache/btree.h     | 2 +-
>  drivers/md/bcache/stats.c     | 2 +-
>  drivers/md/bcache/writeback.c | 2 +-
>  drivers/md/bcache/writeback.h | 2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 2acda9cea0f9..2b35c0a14d4d 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -635,7 +635,7 @@ struct cache_set {
>         struct bkey             gc_done;
>
>         /*
> -        * For automatical garbage collection after writeback completed, this
> +        * For automatic garbage collection after writeback completed, this
>          * varialbe is used as bit fields,
>          * - 0000 0001b (BCH_ENABLE_AUTO_GC): enable gc after writeback
>          * - 0000 0010b (BCH_DO_AUTO_GC):     do gc after writeback
> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> index d795c84246b0..76f75bbcb731 100644
> --- a/drivers/md/bcache/bset.h
> +++ b/drivers/md/bcache/bset.h
> @@ -45,7 +45,7 @@
>   * 4 in memory - we lazily resort as needed.
>   *
>   * We implement code here for creating and maintaining auxiliary search trees
> - * (described below) for searching an individial bset, and on top of that we
> + * (described below) for searching an individual bset, and on top of that we
>   * implement a btree iterator.
>   *
>   * BTREE ITERATOR:
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index e136d6edc1ed..a26863eedc6f 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -154,7 +154,7 @@ void bch_btree_node_read_done(struct btree *b)
>         /*
>          * c->fill_iter can allocate an iterator with more memory space
>          * than static MAX_BSETS.
> -        * See the comment arount cache_set->fill_iter.
> +        * See the comment around cache_set->fill_iter.
>          */
>         iter = mempool_alloc(&b->c->fill_iter, GFP_NOIO);
>         iter->size = b->c->cache->sb.bucket_size / b->c->cache->sb.block_size;
> diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
> index 1b5fdbc0d83e..b46bf6268aca 100644
> --- a/drivers/md/bcache/btree.h
> +++ b/drivers/md/bcache/btree.h
> @@ -54,7 +54,7 @@
>   * Btree nodes never have to be explicitly read in; bch_btree_node_get() handles
>   * this.
>   *
> - * For writing, we have two btree_write structs embeddded in struct btree - one
> + * For writing, we have two btree_write structs embedded in struct btree - one
>   * write in flight, and one being set up, and we toggle between them.
>   *
>   * Writing is done with a single function -  bch_btree_write() really serves two
> diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
> index 68b02216033d..dcd87eb6f85e 100644
> --- a/drivers/md/bcache/stats.c
> +++ b/drivers/md/bcache/stats.c
> @@ -11,7 +11,7 @@
>  #include "sysfs.h"
>
>  /*
> - * We keep absolute totals of various statistics, and addionally a set of three
> + * We keep absolute totals of various statistics, and additionally a set of three
>   * rolling averages.
>   *
>   * Every so often, a timer goes off and rescales the rolling averages.
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 3f0ff3aab6f2..bd83a33b8a2f 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -238,7 +238,7 @@ static void update_writeback_rate(struct work_struct *work)
>         /*
>          * If the whole cache set is idle, set_at_max_writeback_rate()
>          * will set writeback rate to a max number. Then it is
> -        * unncessary to update writeback rate for an idle cache set
> +        * unnecessary to update writeback rate for an idle cache set
>          * in maximum writeback rate number(s).
>          */
>         if (atomic_read(&dc->has_dirty) && dc->writeback_percent &&
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index 31df716951f6..37f66bea522f 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -69,7 +69,7 @@ static inline int offset_to_stripe(struct bcache_device *d,
>         }
>
>         /*
> -        * Here offset is definitly smaller than INT_MAX,
> +        * Here offset is definitely smaller than INT_MAX,
>          * return it as int will never overflow.
>          */
>         return offset;
> --
> 2.25.1
>
