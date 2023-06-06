Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80FA724419
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Jun 2023 15:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbjFFNPd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Jun 2023 09:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237910AbjFFNPd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Jun 2023 09:15:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C43F3
        for <linux-bcache@vger.kernel.org>; Tue,  6 Jun 2023 06:15:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B5CCA1FD6B;
        Tue,  6 Jun 2023 13:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686057330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R0liu47RVFlneuZRSmNb3gMMObt3OxqRgkYuf0XVQ/E=;
        b=SX0X1JoASrimqPovCaArLh5Ot+Vj60BP4ZFTj5Pe0djRH5VavOBkanaUGlzRqFj6Hn/6i5
        BN2NaerO50xTIcaC6lC6WL0M1Ro35lzhdlM3SnIHjQs5lLdff+k7bo6RDUjBkT1/SZSauC
        U+a25EPxf64BROAnKDDTGUlETtRw1Bw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686057330;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R0liu47RVFlneuZRSmNb3gMMObt3OxqRgkYuf0XVQ/E=;
        b=GYXWXpuXkKfR5iOXh3uuDpV/D04nwlr1MxK6jF5V0KQmQ4WFiXzGNrit4Cpv3Zy/KxPwEZ
        kveDQInH/fE+rPAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D487813776;
        Tue,  6 Jun 2023 13:15:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pRTWJ3Exf2RgVQAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 06 Jun 2023 13:15:29 +0000
Date:   Tue, 6 Jun 2023 21:15:27 +0800
From:   Coly Li <colyli@suse.de>
To:     =?utf-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: [PATCH] bcache: don't allocate full_dirty_stripes and
 stripe_sectors_dirty for flash device
Message-ID: <zrw6lms2lsvsyrdflznbldfnq34czuai4zh4dbc3xrg3rwm4tx@ee5yjaiyjicd>
References: <20230606105205.9161-1-colyli@suse.de>
 <AAAAmAD8I1z7-L3v5L3yBaoe.3.1686055811606.Hmail.mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AAAAmAD8I1z7-L3v5L3yBaoe.3.1686055811606.Hmail.mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Jun 06, 2023 at 08:50:11PM +0800, 邹明哲 wrote:
> From: Coly Li <colyli@suse.de>
> Date: 2023-06-06 18:52:05
> To:  linux-bcache@vger.kernel.org
> Cc:  Coly Li <colyli@suse.de>,Mingzhe Zou <mingzhe.zou@easystack.cn>
> Subject: [PATCH] bcache: don't allocate full_dirty_stripes and stripe_sectors_dirty for flash device>The flash device is a special bcache device which doesn't have backing
> >device and stores all data on cache set. Although its data is treated
> >as dirty data but the writeback to backing device never happens.
> >
> >Therefore it is unncessary to always allocate memory for counters
> >full_dirty_stripes and stripe_sectors_dirty when the bcache device is
> >on flash only.
> >
> >This patch avoids to allocate/free memory for full_dirty_stripes and
> >stripe_sectors_dirty in bcache_device_init() and bcache_device_free().
> >Also in bcache_dev_sectors_dirty_add(), if the data is written onto
> >flash device, avoid to update the counters in full_dirty_stripes and
> >stripe_sectors_dirty because they are not used at all.
> >
> >Signed-off-by: Coly Li <colyli@suse.de>
> >Cc: Mingzhe Zou <mingzhe.zou@easystack.cn>
> >---
> > drivers/md/bcache/super.c     | 18 ++++++++++++++----
> > drivers/md/bcache/writeback.c |  8 +++++++-
> > 2 files changed, 21 insertions(+), 5 deletions(-)
> >
> >diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> >index 077149c4050b..00edc093e544 100644
> >--- a/drivers/md/bcache/super.c
> >+++ b/drivers/md/bcache/super.c
> >@@ -887,12 +887,15 @@ static void bcache_device_free(struct bcache_device *d)
> > 	}
> > 
> > 	bioset_exit(&d->bio_split);
> >-	kvfree(d->full_dirty_stripes);
> >-	kvfree(d->stripe_sectors_dirty);
> >+	if (d->full_dirty_stripes)
> >+		kvfree(d->full_dirty_stripes);
> >+	if (d->stripe_sectors_dirty)
> >+		kvfree(d->stripe_sectors_dirty);
> > 
> > 	closure_debug_destroy(&d->cl);
> > }
> > 
> >+
> > static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
> > 		sector_t sectors, struct block_device *cached_bdev,
> > 		const struct block_device_operations *ops)
> >@@ -914,6 +917,10 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
> > 	}
> > 	d->nr_stripes = n;
> > 
> >+	/* Skip allocating stripes counters for flash device */
> >+	if (d->c && UUID_FLASH_ONLY(&d->c->uuids[d->id]))
> >+		goto get_idx;
> >+
> > 	n = d->nr_stripes * sizeof(atomic_t);
> > 	d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
> > 	if (!d->stripe_sectors_dirty)
> >@@ -924,6 +931,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
> > 	if (!d->full_dirty_stripes)
> > 		goto out_free_stripe_sectors_dirty;
> > 
> >+get_idx:
> > 	idx = ida_simple_get(&bcache_device_idx, 0,
> > 				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
> > 	if (idx < 0)
> >@@ -981,9 +989,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
> > out_ida_remove:
> > 	ida_simple_remove(&bcache_device_idx, idx);
> > out_free_full_dirty_stripes:
> >-	kvfree(d->full_dirty_stripes);
> >+	if (d->full_dirty_stripes)
> >+		kvfree(d->full_dirty_stripes);
> > out_free_stripe_sectors_dirty:
> >-	kvfree(d->stripe_sectors_dirty);
> >+	if (d->stripe_sectors_dirty)
> >+		kvfree(d->stripe_sectors_dirty);
> > 	return -ENOMEM;
> > 
> > }
> >diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> >index 24c049067f61..32a034e74622 100644
> >--- a/drivers/md/bcache/writeback.c
> >+++ b/drivers/md/bcache/writeback.c
> >@@ -607,8 +607,14 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
> > 	if (stripe < 0)
> > 		return;
> > 
> >-	if (UUID_FLASH_ONLY(&c->uuids[inode]))
> >+	/*
> >+	 * The flash device doesn't have backing device to writeback,
> >+	 * it is unncessary to calculate stripes related stuffs.
> >+	 */
> >+	if (UUID_FLASH_ONLY(&c->uuids[inode])) {
> > 		atomic_long_add(nr_sectors, &c->flash_dev_dirty_sectors);
> >+		return;
> >+	}
> > 
> > 	stripe_offset = offset & (d->stripe_size - 1);
> > 
> 
> look good, there may be a problem, d->stripe_sectors_dirty will be
> a null pointer for flash device:
> 
> ```
> static inline uint64_t bcache_dev_sectors_dirty(struct bcache_device *d)
> {
> 	uint64_t i, ret = 0;
> 
> 	for (i = 0; i < d->nr_stripes; i++)
> 		ret += atomic_read(d->stripe_sectors_dirty + i);
> 
> 	return ret;
> }
> 
> static void flash_dev_free(struct closure *cl)
> {
> 	struct bcache_device *d = container_of(cl, struct bcache_device, cl);
> 
> 	mutex_lock(&bch_register_lock);
> 	atomic_long_sub(bcache_dev_sectors_dirty(d),
> 			&d->c->flash_dev_dirty_sectors);
> 	del_gendisk(d->disk);
> 	bcache_device_free(d);
> 	mutex_unlock(&bch_register_lock);
> 	kobject_put(&d->kobj);
> }
> ```

You are correct. The above atomic_long_sub() can be avoided, if dirty sectors
of the flash device are not counted by stripe_sectors_dirty counters. This is
something might be improved. Let me think about it.

> 
> The only use of c->flash_dev_dirty_sectorsis to calculate cache_sectors:
> 
> ```
> /* Rate limiting */
> static uint64_t __calc_target_rate(struct cached_dev *dc)
> {
> 	struct cache_set *c = dc->disk.c;
> 
> 	/*
> 	 * This is the size of the cache, minus the amount used for
> 	 * flash-only devices
> 	 */
> 	uint64_t cache_sectors = c->nbuckets * c->cache->sb.bucket_size -
> 				atomic_long_read(&c->flash_dev_dirty_sectors);
> ```
> 
> Do we still need to update the dirty_data of flash device. Whether to
> directly use the size of flash device as a dirty_data.

Yes we have to. The flash device is like kind of thin-provision allocation,
its size is specificed in creation time, but the real occupied space is
indicated by the dirty sectors. So the flash device size can be much larger
than its real consumed space.



-- 
Coly Li
