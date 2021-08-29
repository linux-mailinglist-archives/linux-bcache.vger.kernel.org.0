Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9FF3FAA02
	for <lists+linux-bcache@lfdr.de>; Sun, 29 Aug 2021 09:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhH2Hul (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 29 Aug 2021 03:50:41 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57284 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbhH2Huk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 29 Aug 2021 03:50:40 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 459C01FD75;
        Sun, 29 Aug 2021 07:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630223388; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6AJCQrMwOYOoE/hrQTuKCTvgVl9v/oGI+DWe9yCP7Y=;
        b=TLGSfNKyAg9sSaJPyrrXd6sT1MzexconV7pyvDx6iK/7wlvOyVgeh+DzO1sig2UddPsATC
        CSm2sPnn+rBSGfHFQ+Uquqyu9oNQo76Sj7usntxjj9z/iVZu7Ct0Spo+Q2EsaM7rAuic63
        mEdoImxLUI/F0JDFHJFBrDWTN67r3rs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630223388;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6AJCQrMwOYOoE/hrQTuKCTvgVl9v/oGI+DWe9yCP7Y=;
        b=gJbTPwAyTRSyjPVvJBsXMjALMsTvzthladALsfDcdFZ5aEhxyBF6ms0oBBpptGOKySmstQ
        /is2DrVNlvW12GBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 751CE139F6;
        Sun, 29 Aug 2021 07:49:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IiDPDRo8K2FJHQAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 29 Aug 2021 07:49:46 +0000
Subject: Re: [PATCH] bcache: remove the redundant judgment on bi_size
To:     Fengfei Xi <xi.fengfei@h3c.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20210829044947.14703-1-xi.fengfei@h3c.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <be10bf36-5a99-f441-767f-23e76a96aa73@suse.de>
Date:   Sun, 29 Aug 2021 15:49:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210829044947.14703-1-xi.fengfei@h3c.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/29/21 12:49 PM, Fengfei Xi wrote:
> The bi_size is unsigned int type data not less than 0,
> so we can directly add bi_size without extra judgment
>
> Signed-off-by: Fengfei Xi <xi.fengfei@h3c.com>

NACK. The check is necessary to avoid redundant and unnecessary memory 
write.

Coly Li

> ---
>   drivers/md/bcache/request.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 6d1de889b..2788eec3a 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -423,9 +423,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>   	add_sequential(task);
>   	i->sequential = 0;
>   found:
> -	if (i->sequential + bio->bi_iter.bi_size > i->sequential)
> -		i->sequential	+= bio->bi_iter.bi_size;
> -
> +	i->sequential		+= bio->bi_iter.bi_size;
>   	i->last			 = bio_end_sector(bio);
>   	i->jiffies		 = jiffies + msecs_to_jiffies(5000);
>   	task->sequential_io	 = i->sequential;

