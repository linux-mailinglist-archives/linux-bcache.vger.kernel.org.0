Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7D84F8564
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Apr 2022 18:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiDGRBI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Apr 2022 13:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240058AbiDGRBI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Apr 2022 13:01:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93271B84EE;
        Thu,  7 Apr 2022 09:58:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 870DF212C6;
        Thu,  7 Apr 2022 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649350738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ar/51NvGFFYPTA9QjJD1sM7luYgOwEuIBJSxBbtt0ME=;
        b=UzpJxv7Tj26hQd3NUYVEo3W6a+bU61Zrxv1ckGgFiK8TiyCPghkx6q4+aos/I6mHbFDtX7
        suokcGykJ7l7g/8VM+v9Uc19t2iC8QM+W1EBKgZrdcTAFHyP3a02O80aygwNMtEr5xSGkg
        JMCOtZPMYYFzLmWHGbLVQIVxJzfh+s0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649350738;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ar/51NvGFFYPTA9QjJD1sM7luYgOwEuIBJSxBbtt0ME=;
        b=XXW4fcNXbW1GimdrWCBs8ye9B3iSY/9QZCIXRQ44G22rArjbi5OfpoM/PBKiuWTZBH1WVf
        GRO3D19TUVphqtAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A8C513485;
        Thu,  7 Apr 2022 16:58:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /D8eElEYT2KfGwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 07 Apr 2022 16:58:57 +0000
Message-ID: <89ad6f76-a947-edd9-2de3-84dbc4901835@suse.de>
Date:   Fri, 8 Apr 2022 00:58:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] bcache: add a check for the return of kzalloc()
Content-Language: en-US
To:     xkernel.wang@foxmail.com
Cc:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com,
        linux-kernel@vger.kernel.org
References: <tencent_C028FEC2BF94C0FF5740D298F572B9396C09@qq.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <tencent_C028FEC2BF94C0FF5740D298F572B9396C09@qq.com>
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

On 3/25/22 11:27 AM, xkernel.wang@foxmail.com wrote:
> From: Xiaoke Wang <xkernel.wang@foxmail.com>
>
> kzalloc() is a memory allocation function which can return NULL when
> some internal memory errors happen. So it is better to check it to
> prevent potential wrong memory access.
>
> Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
> ---
> Note: I just roughly handled the error and this seems to affect the
> original functionality. If this cannot fail, maybe the tag
> `__GFP_NOFAIL` should be considered.

The error handling is incorrect indeed. And IIRC there is someone else 
already fixes it properly and the patch is not upstream yet.

Thanks.


Coly Li


>   drivers/md/bcache/request.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 6d1de88..1dc9821 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1107,14 +1107,16 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
>   	 * which would call closure_get(&dc->disk.cl)
>   	 */
>   	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
> -	ddip->d = d;
> -	/* Count on the bcache device */
> -	ddip->orig_bdev = orig_bdev;
> -	ddip->start_time = start_time;
> -	ddip->bi_end_io = bio->bi_end_io;
> -	ddip->bi_private = bio->bi_private;
> -	bio->bi_end_io = detached_dev_end_io;
> -	bio->bi_private = ddip;
> +	if (ddip) {
> +		ddip->d = d;
> +		/* Count on the bcache device */
> +		ddip->orig_bdev = orig_bdev;
> +		ddip->start_time = start_time;
> +		ddip->bi_end_io = bio->bi_end_io;
> +		ddip->bi_private = bio->bi_private;
> +		bio->bi_end_io = detached_dev_end_io;
> +		bio->bi_private = ddip;
> +	}
>   
>   	if ((bio_op(bio) == REQ_OP_DISCARD) &&
>   	    !blk_queue_discard(bdev_get_queue(dc->bdev)))


