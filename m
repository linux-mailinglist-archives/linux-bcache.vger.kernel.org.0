Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CC84F85B7
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Apr 2022 19:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346043AbiDGRU2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Apr 2022 13:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiDGRU0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Apr 2022 13:20:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EF26FA0A;
        Thu,  7 Apr 2022 10:18:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AA302212CA;
        Thu,  7 Apr 2022 17:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649351903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IImX9u7hyHMtT/465kPC3r5ZAKcGOJ6gEaqJKDZXu+4=;
        b=u/kLU55iYahiedriKEFkcAQ8KFcb4vhyT05qsST6PrHv8vtLgwKrg6EFn9frww2zlDJd5V
        W6MsikanQWB9VYdWMTeOy8DQtiWgMGziiQs88kPhkNNpe6+wAXc/kOd3dhUYKakDQMll9I
        4WDDYSr85bnBgYT1w/DNjrIJErGrJ6Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649351903;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IImX9u7hyHMtT/465kPC3r5ZAKcGOJ6gEaqJKDZXu+4=;
        b=Q+80xPDcUy3Afcej8bwNXUBIzcuuqTLgnS0kSiHH6ZFmwQCAkTh+vrPzAYyNDY0oTggTd+
        +Etqhrux+iN7qzBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C07A013485;
        Thu,  7 Apr 2022 17:18:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HZOKJN4cT2J8IwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 07 Apr 2022 17:18:22 +0000
Message-ID: <7b796b3e-2fd9-00bc-5410-1097512162be@suse.de>
Date:   Fri, 8 Apr 2022 01:18:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2] md: bcache: check the return value of kzalloc() in
 detached_dev_do_request()
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com,
        linux-kernel@vger.kernel.org
References: <20220303015544.32186-1-baijiaju1990@gmail.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220303015544.32186-1-baijiaju1990@gmail.com>
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

On 3/3/22 9:55 AM, Jia-Ju Bai wrote:
> The function kzalloc() in detached_dev_do_request() can fail, so its
> return value should be checked.
>
> Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached bcache devices")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
> v2:
> * Fix the error handling code when ddip is NULL.
>    Thank Coly for good advice.
>
> ---
>   drivers/md/bcache/request.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index d15aae6c51c1..673a680240a9 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1107,6 +1107,12 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
>   	 * which would call closure_get(&dc->disk.cl)
>   	 */
>   	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
> +	if (!ddip) {
> +		bio->bi_status = BLK_STS_RESOURCE;
> +		bio->bi_end_io(bio);
> +		return;
> +	}
> +
>   	ddip->d = d;
>   	/* Count on the bcache device */
>   	ddip->orig_bdev = orig_bdev;

Added into my testing queue.

Thanks.


Coly Li

