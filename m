Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC044879DE
	for <lists+linux-bcache@lfdr.de>; Fri,  7 Jan 2022 16:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239719AbiAGPpo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 Jan 2022 10:45:44 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:33834 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239713AbiAGPpo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 Jan 2022 10:45:44 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2AF15210EA;
        Fri,  7 Jan 2022 15:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641570343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KDtM4bXAiOGYS/fZzi3Q22GVAxQ06NsP+ZMxqGz9AXU=;
        b=xq7hZg0cJcyM95Nv7PMaAqAM8Is9X/eXKnD05p9Z+iiTUSN82CFuqHuv5b8H2NtIY2XDbg
        sU3XYkYqZf8Czz6rccjIXMnpShDeo22T/Q99yTvEsYMo8sZ4csffv8PYQMb1g4Au4ksdP1
        WRDT/QHc6asGNkn4VKLM8rXjmxTnKcE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641570343;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KDtM4bXAiOGYS/fZzi3Q22GVAxQ06NsP+ZMxqGz9AXU=;
        b=Qoe2hRo95LGX1e27OzObJNPC4wrdpSKmFeev37uDrc8fU0V7HuLKi/9E+3O1wWXL8wvKOB
        WbPP+q/f4MsBMBAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E391713D17;
        Fri,  7 Jan 2022 15:45:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id V0rCKCVg2GG+HAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 07 Jan 2022 15:45:41 +0000
Message-ID: <fa05fa29-076a-4d33-a578-abf5c2b5c78f@suse.de>
Date:   Fri, 7 Jan 2022 23:45:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] bcache: fixup bcache_dev_sectors_dirty_add()
 multithreaded CPU false sharing
Content-Language: en-US
To:     mingzhe.zou@easystack.cn
Cc:     linux-bcache@vger.kernel.org, bcache@lists.ewheeler.net,
        axboe@kernel.dk
References: <20220107082113.18480-1-mingzhe.zou@easystack.cn>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220107082113.18480-1-mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/7/22 4:21 PM, mingzhe.zou@easystack.cn wrote:
> From: Zou Mingzhe <mingzhe.zou@easystack.cn>
>
> When attaching a cached device (a.k.a backing device) to a cache
> device, bch_sectors_dirty_init() is called to count dirty sectors
> and stripes (see what bcache_dev_sectors_dirty_add() does) on the
> cache device.
>
> When bcache_dev_sectors_dirty_add() is called, set_bit(stripe,
> d->full_dirty_stripes) or clear_bit(stripe, d->full_dirty_stripes)
> operation will always be performed. In full_dirty_stripes, each 1bit
> represents stripe_size (8192) sectors (512B), so 1bit=4MB (8192*512),
> and each CPU cache line=64B=512bit=2048MB. When 20 threads process
> a cached disk with 100G dirty data, a single thread processes about
> 23M at a time, and 20 threads total 460M. These full_dirty_stripes
> bits corresponding to the 460M data is likely to fall in the same CPU
> cache line. When one of these threads performs a set_bit or clear_bit
> operation, the same CPU cache line of other threads will become invalid
> and must read the full_dirty_stripes from the main memory again. Compared
> with single thread, the time of a bcache_dev_sectors_dirty_add()
> call is increased by about 50 times in our test (100G dirty data,
> 20 threads, bcache_dev_sectors_dirty_add() is called more than
> 20 million times).
>
> This patch tries to test_bit before set_bit or clear_bit operation.
> Therefore, a lot of force set and clear operations will be avoided,
> and most of bcache_dev_sectors_dirty_add() calls will only read CPU
> cache line.
>
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>

Added into my testing queue. Thanks.

Coly Li

> ---
>   drivers/md/bcache/writeback.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 68e75c692dd4..4afe22875d4f 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -596,10 +596,13 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
>   
>   		sectors_dirty = atomic_add_return(s,
>   					d->stripe_sectors_dirty + stripe);
> -		if (sectors_dirty == d->stripe_size)
> -			set_bit(stripe, d->full_dirty_stripes);
> -		else
> -			clear_bit(stripe, d->full_dirty_stripes);
> +		if (sectors_dirty == d->stripe_size) {
> +			if (!test_bit(stripe, d->full_dirty_stripes))
> +				set_bit(stripe, d->full_dirty_stripes);
> +		} else {
> +			if (test_bit(stripe, d->full_dirty_stripes))
> +				clear_bit(stripe, d->full_dirty_stripes);
> +		}
>   
>   		nr_sectors -= s;
>   		stripe_offset = 0;

