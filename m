Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B064F8568
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Apr 2022 18:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbiDGRBl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Apr 2022 13:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345907AbiDGRBk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Apr 2022 13:01:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319161C8858;
        Thu,  7 Apr 2022 09:59:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D40631F85E;
        Thu,  7 Apr 2022 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649350777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z2Bed+Unj8/31PP3+tIX1i22uICkwYo9ioyedTJiWT8=;
        b=WlaomzRyVsIgdnjDN42Ge69qIdv4Xcv0hottLq9lRt1BUJTW7hVTkNCsx3MEEbL/5GspRM
        oh1bjnM3PoLt055R9wRWQV3SNwGzlvjaUk4f6lrgCsYDxPEDUTgd9WAyvhV1LsSEenx8bn
        9VW1A38KAIBSsYlYMlZEHvdkZAqtjCo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649350777;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z2Bed+Unj8/31PP3+tIX1i22uICkwYo9ioyedTJiWT8=;
        b=lx3mehWOWKnYn7pyR2cHSOOAhhjiuQQnozm1Ucy/jL1WgWceOJhu377M2mi/dlCho7cLTy
        hIdrWBTFJnEjI/AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB8FC13485;
        Thu,  7 Apr 2022 16:59:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IgnoJXgYT2L8GwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 07 Apr 2022 16:59:36 +0000
Message-ID: <c934c457-fe8f-7937-f348-eccf46375878@suse.de>
Date:   Fri, 8 Apr 2022 00:59:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v1] bcache: Check for NULL return of kzalloc()
Content-Language: en-US
To:     QintaoShen <unSimple1993@163.com>
Cc:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com,
        linux-kernel@vger.kernel.org
References: <1648114074-10045-1-git-send-email-unSimple1993@163.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <1648114074-10045-1-git-send-email-unSimple1993@163.com>
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

On 3/24/22 5:27 PM, QintaoShen wrote:
> kzalloc() is a memory allocation function which may return a NULL pointer.
> Therefore, it is better to check the return value of kzalloc() to avoid potential
> NULL-pointer dereference.
>
> Signed-off-by: QintaoShen <unSimple1993@163.com>
> ---
>   drivers/md/bcache/request.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index fdd0194..232ffe3 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1105,6 +1105,9 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
>   	 * which would call closure_get(&dc->disk.cl)
>   	 */
>   	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
> +	if (!ddpp)
> +		return ;

This is wrong. If you test your patch, you may experience a system hang 
I guess.


Coly Li


> +
>   	ddip->d = d;
>   	/* Count on the bcache device */
>   	ddip->orig_bdev = orig_bdev;


