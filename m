Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEC0431FC1
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 16:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhJROda (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 10:33:30 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41962 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhJROda (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 10:33:30 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4BAF21FD7F;
        Mon, 18 Oct 2021 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634567478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BRpwlclbkEl5Bw8M2BRrB2c9bc/xz+emyW+UTBB76gw=;
        b=DDFjBZA109cQSZn/ypDIV/kmCkEk0/dDK891PqQqpnGYLU+OukMrb0DCjiLLytFXtmnqnw
        REvgbcJe6IYf0K4PwFDZtFKUAppPRZlP9yfOmZTq9gpGt4kxpyoeN3nVORWRUEQcp55xrF
        oMUDfW6kzJ54bKYf+un9UdRMa+HgYX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634567478;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BRpwlclbkEl5Bw8M2BRrB2c9bc/xz+emyW+UTBB76gw=;
        b=xQI4TBjfXINZrIerivx5z39wMUu0Ss2TtHU4rqGcFEcIBZ7fFqCIp0LxM34hymwEgfnIcE
        AkL0BZY3KvPgk9BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD33513AFB;
        Mon, 18 Oct 2021 14:31:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BGWIGi6FbWHJfwAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 18 Oct 2021 14:31:10 +0000
Subject: Re: [PATCH 3/4] bcache: use bvec_kmap_local in bch_data_verify
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org
References: <20211018060934.1816088-1-hch@lst.de>
 <20211018060934.1816088-4-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <bb1e3c13-f8d2-52f6-b881-d4be216f9cce@suse.de>
Date:   Mon, 18 Oct 2021 22:31:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211018060934.1816088-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/18/21 2:09 PM, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
>
> Also switch from page_address to bvec_kmap_local for cbv to be on the
> safe side and to avoid pointlessly poking into bvec internals.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>   drivers/md/bcache/debug.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> index e803cad864be7..6230dfdd9286e 100644
> --- a/drivers/md/bcache/debug.c
> +++ b/drivers/md/bcache/debug.c
> @@ -127,21 +127,20 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>   
>   	citer.bi_size = UINT_MAX;
>   	bio_for_each_segment(bv, bio, iter) {
> -		void *p1 = kmap_atomic(bv.bv_page);
> +		void *p1 = bvec_kmap_local(&bv);
>   		void *p2;
>   
>   		cbv = bio_iter_iovec(check, citer);
> -		p2 = page_address(cbv.bv_page);
> +		p2 = bvec_kmap_local(&cbv);
>   
> -		cache_set_err_on(memcmp(p1 + bv.bv_offset,
> -					p2 + bv.bv_offset,
> -					bv.bv_len),
> +		cache_set_err_on(memcmp(p1, p2, bv.bv_len),
>   				 dc->disk.c,
>   				 "verify failed at dev %pg sector %llu",
>   				 dc->bdev,
>   				 (uint64_t) bio->bi_iter.bi_sector);
>   
> -		kunmap_atomic(p1);
> +		kunmap_local(p2);
> +		kunmap_local(p1);
>   		bio_advance_iter(check, &citer, bv.bv_len);
>   	}
>   

