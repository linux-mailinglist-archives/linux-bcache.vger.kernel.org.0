Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD79431FC8
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 16:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhJROfd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 10:35:33 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57052 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbhJROfd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 10:35:33 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7280521A8A;
        Mon, 18 Oct 2021 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634567601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TBpzqSzVqj4AkI4jcdM5ohxGyC/jWf/CLhYv29iYFLA=;
        b=mlYcho+KtxRFI1LT3TbkXlZAqc60ybYO4MHrhHacQRXj8e1EcydGJu0rrbbP3MSKtBGGBb
        ZxlZrE4oivLoiTpXt2XDN90qnHd4HLR6/MGsD1V3913kOApnCkEqsWIITXKgrBZmXqk40s
        g0B461p+WqENBWSqTDaHPYMzsv1SMJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634567601;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TBpzqSzVqj4AkI4jcdM5ohxGyC/jWf/CLhYv29iYFLA=;
        b=1VQ2qriipyAG4YT+c+kFuMIAKB80dWXU2+YRL3OpcUSjfPiGPAHcq2REn4nUIWQJbqUvZb
        FZgzGGAEsjv4N7BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3379413AFB;
        Mon, 18 Oct 2021 14:33:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id h+wWHa+FbWERAgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 18 Oct 2021 14:33:19 +0000
Subject: Re: [PATCH 4/4] bcache: remove bch_crc64_update
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org
References: <20211018060934.1816088-1-hch@lst.de>
 <20211018060934.1816088-5-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <72307d16-e59a-fa1a-37c6-87ffd7a1fc1e@suse.de>
Date:   Mon, 18 Oct 2021 22:33:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211018060934.1816088-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/18/21 2:09 PM, Christoph Hellwig wrote:
> bch_crc64_update is an entirely pointless wrapper around crc64_be.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>   drivers/md/bcache/btree.c   | 2 +-
>   drivers/md/bcache/request.c | 2 +-
>   drivers/md/bcache/util.h    | 8 --------
>   3 files changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 0595559de174a..93b67b8d31c3d 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -141,7 +141,7 @@ static uint64_t btree_csum_set(struct btree *b, struct bset *i)
>   	uint64_t crc = b->key.ptr[0];
>   	void *data = (void *) i + 8, *end = bset_bkey_last(i);
>   
> -	crc = bch_crc64_update(crc, data, end - data);
> +	crc = crc64_be(crc, data, end - data);
>   	return crc ^ 0xffffffffffffffffULL;
>   }
>   
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 64ce5788f80cb..3f10f82483047 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -46,7 +46,7 @@ static void bio_csum(struct bio *bio, struct bkey *k)
>   	bio_for_each_segment(bv, bio, iter) {
>   		void *d = kmap(bv.bv_page) + bv.bv_offset;
>   
> -		csum = bch_crc64_update(csum, d, bv.bv_len);
> +		csum = crc64_be(csum, d, bv.bv_len);
>   		kunmap(bv.bv_page);
>   	}
>   
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index b64460a762677..6274d6a17e5e7 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -548,14 +548,6 @@ static inline uint64_t bch_crc64(const void *p, size_t len)
>   	return crc ^ 0xffffffffffffffffULL;
>   }
>   
> -static inline uint64_t bch_crc64_update(uint64_t crc,
> -					const void *p,
> -					size_t len)
> -{
> -	crc = crc64_be(crc, p, len);
> -	return crc;
> -}
> -
>   /*
>    * A stepwise-linear pseudo-exponential.  This returns 1 << (x >>
>    * frac_bits), with the less-significant bits filled in by linear

