Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D64549114A
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jan 2022 22:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiAQVQM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Jan 2022 16:16:12 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:52974 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbiAQVQM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Jan 2022 16:16:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id B05234A;
        Mon, 17 Jan 2022 13:16:11 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id hBliTfses6IN; Mon, 17 Jan 2022 13:16:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 425F039;
        Mon, 17 Jan 2022 13:16:07 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 425F039
Date:   Mon, 17 Jan 2022 13:16:00 -0800 (PST)
From:   bcache@lists.ewheeler.net
To:     Zou Mingzhe <mingzhe.zou@easystack.cn>
cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH] bcache: fixup bcache_dev_sectors_dirty_add() multithreaded
 CPU false sharing
In-Reply-To: <73a82135-2162-fff7-138c-051c8d1001d2@easystack.cn>
Message-ID: <3dafe10-a21b-e262-5ccd-efd1eba75345@ewheeler.net>
References: <20220107082113.18480-1-mingzhe.zou@easystack.cn> <fa05fa29-076a-4d33-a578-abf5c2b5c78f@suse.de> <c0ac712e-c9f-825-c2f6-aad0e648ebe6@ewheeler.net> <73a82135-2162-fff7-138c-051c8d1001d2@easystack.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1488026911-1642454014=:23707"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1488026911-1642454014=:23707
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 17 Jan 2022, Zou Mingzhe wrote:
> 在 2022/1/8 上午4:20, bcache@lists.ewheeler.net 写道:
> 
> On Fri, 7 Jan 2022, Coly Li wrote:
> 
> On 1/7/22 4:21 PM, mingzhe.zou@easystack.cn wrote:
> 
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
> Hi Mingzhe, good catch on this.  I'm curious: how much time does it save 
> attaching a cache?
> 
> Our test, 100G dirty data:
> 
>                                  register caching      register backing
> before coly multithread patch    about 11 seconds      about 3 seconds
> after coly multithread patch     about 0.8 seconds     about 2 seconds
>   (0-39 online cpus, so 20 threads work)
> this patch                       about 0.8 seconds     about 0.3 seconds
>   (0-39 online cpus, so 20 threads work)

Wow, almost 10x faster registering the backing device!

--
Eric Wheeler


> 
> Mingzhe
> 
> 
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> Added into my testing queue. Thanks.
> 
> Coly Li
> 
> ---
>   drivers/md/bcache/writeback.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 68e75c692dd4..4afe22875d4f 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -596,10 +596,13 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c,
> unsigned int inode,
>   
>     sectors_dirty = atomic_add_return(s,
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
>     nr_sectors -= s;
>     stripe_offset = 0;
> 
> 
> 
> 
> 
--8323328-1488026911-1642454014=:23707--
