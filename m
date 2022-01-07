Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E32487050
	for <lists+linux-bcache@lfdr.de>; Fri,  7 Jan 2022 03:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345373AbiAGCY4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jan 2022 21:24:56 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:42394 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344468AbiAGCY4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jan 2022 21:24:56 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 684311F39C;
        Fri,  7 Jan 2022 02:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641522295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+5R9xomuZNJ8McwzT6mmLYEwamP8efg+kx9INA94OZ0=;
        b=d3bSIYPimZSN0RsLDrROtoLSaMerZXpcQqe0ZRCGzmtCurjISaDHQUlGDA7q++RwnoP7dz
        bZfzFZ9FTKQbU6ey9ReyJb2RnjcYGS2j9eZ5GdA16kPg68+kjt2zbqq7WT6HrIDVEq85JU
        Zro1FH5uf2cyZE4KqtpzUNYly0Au6a0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641522295;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+5R9xomuZNJ8McwzT6mmLYEwamP8efg+kx9INA94OZ0=;
        b=+ari8iaY9TX01XQDwA+lDqu7UoJcfCAORQTKfksHJR68gN0llPSgmwit0gHNTjTBxEqwxs
        ncEIzcuiDPaaDICA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AF0AE13C9D;
        Fri,  7 Jan 2022 02:24:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id J5RQIHak12F7TwAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 07 Jan 2022 02:24:54 +0000
Message-ID: <cd2a1b75-4fa6-b5d3-1e6f-855ebca218ce@suse.de>
Date:   Fri, 7 Jan 2022 10:24:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: Hot-grow bcache backing device.
Content-Language: en-US
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     mingzhe.zou@easystack.cn, linux-bcache@vger.kernel.org
References: <8c3eff7-ab0-c627-d0df-5ebdd1ecc1bb@ewheeler.net>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <8c3eff7-ab0-c627-d0df-5ebdd1ecc1bb@ewheeler.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/7/22 8:12 AM, Eric Wheeler wrote:
> Hi Coli an Mingzhe:
>
> Since Mingzhe brought up full_dirty_stripes in the other thread: some time
> ago I was looking into hot-resize of bcache devices.  Usually I resize by
> unregister/re-register but it would be nice to do hot.
>
> While reviewing the code for feasibility the only snag I found was safely
> resizing full_dirty_stripes allocation before updating d->nr_stripes and
> calling set_capacity(d->disk, bdev_nr_sectors(dc->bdev)).
>
> I think hot resize of a bdev should be simple and I have a few questions:

It is simple but not very simple. The size information has to be updated 
atomically in both cached device and bcache device.

I guess/feel we need to freeze the bcache device during the resize 
operation. Freeze means holding all new coming external or internal I/Os 
and waiting for all flying I/Os to finish.

>
> 1. Should the newly resized bits of full_dirty_stripes just be zeroed?

I feel zeroing all new growing bits of full_dirty_stripes is good.


>
> 2. Besides d->nr_stripes and full_dirty_stripes, does anything else need
>     to change size?  Long ago Kent confirmed that the cachedev structures
>     are bdev-size agnostic.

struct gendisk *disk from struct bcache_device should be updated to for 
the grown size.


>
> 3. Are there any bcache locks to hold when resizing?

I can see dc->writeback_lock, maybe some other implicit locking 
dependence but I cannot tell immediately.

>
> 4. Is there something like "realloc()" to grow the allocation (I didn't
>     see kvzrealloc())---or would we need to kvzalloc into a new buffer,
>     copy in, and free the old one?

Any method is fine to me, just handle the failure condition properly.

>
> For reference, from bcache_device_init():
>          n = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
>          [...]
>          d->nr_stripes = n;
>
>          n = d->nr_stripes * sizeof(atomic_t);
>          d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
>          if (!d->stripe_sectors_dirty)
>                  return -ENOMEM;
>
>          n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
>>>>>     d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL);

The bcache device should be froze during size extend operation, I am not 
sure whether the whole cache set should be froze too.

And I don't see obvious blocking challenge to implement the backing 
device resize, at my first glance :-)

Coly Li

