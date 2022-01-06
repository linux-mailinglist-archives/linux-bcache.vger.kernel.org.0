Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705874866BC
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 16:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240483AbiAFPaj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jan 2022 10:30:39 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:48984 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240432AbiAFPah (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jan 2022 10:30:37 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CFA6D21126;
        Thu,  6 Jan 2022 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641483036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JaaMhioQEW8FXdZxgIMxMV7lrLWYprO/TA0tOwQColc=;
        b=WxZhzF/YNfXA4NJ2ftlrpl233Vo0lLMOpKR+Ry9thQOR5LvaaNLDUduki2A6YKXjYaTudR
        YilKBA12LT0P+KSDzWf8cCOcyEisWRfnqKVk4xhKVVE+hyVuZ4lacT1ARjH6M/utXTF6US
        TrwfYn54rlyr4lEZNRqR7FERZfSyrac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641483036;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JaaMhioQEW8FXdZxgIMxMV7lrLWYprO/TA0tOwQColc=;
        b=mP9V3fCqXrfZtsB08gR7ezxllMAGipMgoe99C0CXRCprhRLTLixb5DyKrrjsleDC0lrNfh
        DbDQqT06FUZP3wAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D067913C5A;
        Thu,  6 Jan 2022 15:30:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id u49RJxsL12GNdwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 06 Jan 2022 15:30:35 +0000
Message-ID: <567fffe9-e7cd-b3b4-b462-21c84b7fda9e@suse.de>
Date:   Thu, 6 Jan 2022 23:30:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] bcache: fixup bcache_dev_sectors_dirty_add()
 multithreaded CPU false sharing
Content-Language: en-US
To:     mingzhe.zou@easystack.cn
Cc:     linux-bcache@vger.kernel.org, axboe@kernel.dk
References: <20220106120811.24044-1-mingzhe.zou@easystack.cn>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220106120811.24044-1-mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/6/22 8:08 PM, mingzhe.zou@easystack.cn wrote:
> From: Zou Mingzhe <mingzhe.zou@easystack.cn>
>
> When attaching a cached device (a.k.a backing device) to a cache
> device, bch_sectors_dirty_init() is called to count dirty sectors
> and stripes (see what bcache_dev_sectors_dirty_add() does) on the
> cache device.
>
> When bch_sectors_dirty_init() is called, set_bit(stripe,
> d->full_dirty_stripes) or clear_bit(stripe, d->full_dirty_stripes)
> operation will always be performed. In full_dirty_stripes, each 1bit
> represents stripe_size (8192) sectors (512B), so 1bit=4MB (8192*512),
> and each CPU cache line=64B=512bit=2048MB. When 20 threads process
> a cached disk with 100G dirty data, a single thread processes about
> 23M at a time, and 20 threads total 460M. The full_dirty_stripes bit
> of these data is likely to fall in the same CPU cache line. This will
> cause CPU false sharing problem and reduce performance.

I am fine with the patch, but why "this will cause CPU false sharing" if 
"the full_dirty_stripes bit of these day is likely to fall in the same 
CPU cache line" ?


>
> This patch tries to test_bit before set_bit or clear_bit operation.
> There are 8192 sectors per 1bit, and the number of sectors processed
> by a single bch_sectors_dirty_init() call is only 8, 16, 32, etc.
> So the set_bit or clear_bit operations will be greatly reduced.

Indeed, force setting value before testing is something to be avoided. 
Thanks for caching this. If you may simplify the commit log to explain 
your change is to avoid force setting before testing, it should be fine 
enough for me.

Thanks.

Coly Li

>
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
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

