Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5DC4F7955
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Apr 2022 10:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242817AbiDGISh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Apr 2022 04:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242795AbiDGISg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Apr 2022 04:18:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2097D208C03;
        Thu,  7 Apr 2022 01:16:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C45241F85B;
        Thu,  7 Apr 2022 08:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649319395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lDpImFu5Uivn4DfGJlYiz9vYuz2Nv72UWNvkXkuJYGg=;
        b=oLP9PRfRRD7mxq5x7xCJN137uit6q+YNNoudexrZzYyD6+eW+cdU3RXM5iX/XE0sf4Egxi
        fMTd+UAD0c6NXGlbpqt0l8d8ZlhW/0nICmkqzbw3SdkLBy09hjEqOXcvdPjbEm5J9EwiVs
        fZ5hgwB5240MWjviQqGlg33RLCDgVnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649319395;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lDpImFu5Uivn4DfGJlYiz9vYuz2Nv72UWNvkXkuJYGg=;
        b=piEcFzuoq1oygxpi1MEykg2vUI/TY9iYqgx83RkZZRzcJNEIcqCe2t0JkJ25EeU//hq+l+
        qEoICyqK/U13eXDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 08D6613485;
        Thu,  7 Apr 2022 08:16:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wRyrM+CdTmLMCAAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 07 Apr 2022 08:16:32 +0000
Message-ID: <24bb310e-6ce2-88c9-ebdc-59d49c609d77@suse.de>
Date:   Thu, 7 Apr 2022 16:16:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 4/5] block: turn bio_kmalloc into a simple kmalloc wrapper
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20220406061228.410163-1-hch@lst.de>
 <20220406061228.410163-5-hch@lst.de>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220406061228.410163-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/6/22 2:12 PM, Christoph Hellwig wrote:
> Remove the magic autofree semantics and require the callers to explicitly
> call bio_init to initialize the bio.
>
> This allows bio_free to catch accidental bio_put calls on bio_init()ed
> bios as well.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/bio.c                        | 47 ++++++++++++------------------
>   block/blk-crypto-fallback.c        | 14 +++++----
>   block/blk-map.c                    | 42 ++++++++++++++++----------
>   drivers/block/pktcdvd.c            | 25 ++++++++--------
>   drivers/md/bcache/debug.c          | 10 ++++---
>   drivers/md/dm-bufio.c              |  9 +++---
>   drivers/md/raid1.c                 | 12 +++++---
>   drivers/md/raid10.c                | 21 ++++++++-----
>   drivers/target/target_core_pscsi.c | 10 +++----
>   fs/squashfs/block.c                | 15 +++++-----
>   include/linux/bio.h                |  2 +-
>   11 files changed, 112 insertions(+), 95 deletions(-)
[snipped]
> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> index 6230dfdd9286e..7510d1c983a5e 100644
> --- a/drivers/md/bcache/debug.c
> +++ b/drivers/md/bcache/debug.c
> @@ -107,15 +107,16 @@ void bch_btree_verify(struct btree *b)
>   
>   void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>   {
> +	unsigned int nr_segs = bio_segments(bio);
>   	struct bio *check;
>   	struct bio_vec bv, cbv;
>   	struct bvec_iter iter, citer = { 0 };
>   
> -	check = bio_kmalloc(GFP_NOIO, bio_segments(bio));
> +	check = bio_kmalloc(nr_segs, GFP_NOIO);
>   	if (!check)
>   		return;
> -	bio_set_dev(check, bio->bi_bdev);
> -	check->bi_opf = REQ_OP_READ;
> +	bio_init(check, bio->bi_bdev, check->bi_inline_vecs, nr_segs,
> +		 REQ_OP_READ);
>   	check->bi_iter.bi_sector = bio->bi_iter.bi_sector;
>   	check->bi_iter.bi_size = bio->bi_iter.bi_size;
>   
> @@ -146,7 +147,8 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>   
>   	bio_free_pages(check);
>   out_put:
> -	bio_put(check);
> +	bio_uninit(check);
> +	kfree(check);
>   }
>   
>   #endif

[snipped]

For bcache part,

Acked-by: Coly Li <colyli@suse.de>


Coly Li



