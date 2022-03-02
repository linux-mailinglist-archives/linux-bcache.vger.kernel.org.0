Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D697F4CA1E0
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Mar 2022 11:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240901AbiCBKMR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Mar 2022 05:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240905AbiCBKMQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Mar 2022 05:12:16 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5D426AEA;
        Wed,  2 Mar 2022 02:11:33 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AD51B1F44D;
        Wed,  2 Mar 2022 10:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646215892; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Ufdyvjw7q8CKnqb2y5YsxaowsIDJGxhrCEaFNYxTtI=;
        b=l5Fcyx972hMbMjiWWCdsLM/xUsAujFEkyNAvc8zYYDtomXLSQc++rEVf17p/+T2WuAhi8H
        CGCb60nafolNS1Q7Ia+yN6/tl2hCSLAUHzDSJyVSZ2asXYtCvYBBDH75MAISa/6aLLeGuC
        mQDds4sg3+FxQ/b2qCmWINMthDbfPms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646215892;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Ufdyvjw7q8CKnqb2y5YsxaowsIDJGxhrCEaFNYxTtI=;
        b=+vtOEPAky+XVEto3xNNqYDepUWDqBLH7YOVD3WHWyAbrjC4/SG8w6xLvzw3++Qsh6NcnZ6
        hpaLQ/Bbl/P7J+Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A661C13BC1;
        Wed,  2 Mar 2022 10:11:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7L4uHdNCH2IudgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 02 Mar 2022 10:11:31 +0000
Message-ID: <f9a07f10-9d9d-de94-64b9-acf722cea8cd@suse.de>
Date:   Wed, 2 Mar 2022 18:11:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] md: bcache: check the return value of kzalloc() in
 detached_dev_do_request()
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20220225082048.19524-1-baijiaju1990@gmail.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220225082048.19524-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/25/22 4:20 PM, Jia-Ju Bai wrote:
> The function kzalloc() in detached_dev_do_request() can fail, so its
> return value should be checked.
>
> Fixes: bc082a55d25c (bcache: fix inaccurate io state for detached bcache devices)
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>   drivers/md/bcache/request.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index d15aae6c51c1..1b5ccfa93b8c 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1107,6 +1107,8 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
>   	 * which would call closure_get(&dc->disk.cl)
>   	 */
>   	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);

Yes this is a potential problem, may result NULL pointer deference.


> +	if (!ddip)
> +		return;

The fix here is incorrect. A proper way to fix might be something like this,

     if (!ddip) {

         bio->bi_status = BLK_STS_RESOURCE;

         bio->bi_end_io(bio);

         return;

     }


The orignal patch will make I/O task be in sleep forever.

>   	ddip->d = d;
>   	/* Count on the bcache device */
>   	ddip->orig_bdev = orig_bdev;


