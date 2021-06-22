Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E643B00E3
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Jun 2021 12:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhFVKFy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Jun 2021 06:05:54 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40716 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhFVKFx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Jun 2021 06:05:53 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 868C61FD36;
        Tue, 22 Jun 2021 10:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624356217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nKhgE6954NvfhMQjK/nStOUEryBEduHx4QCTOdEaIp8=;
        b=dF2a93dYcxV7hUuWppSRFrVcx3D5IYJxzrPXNnwpo6D9KPQV8GMWW7a8UM63y5WBjrr/9P
        lEO1KFnK+P5yO5q+sjz4mqH1QvN5jC/h+JQZlP8++4o1b1H4dTaA9eeWCqwtDiQm4LF026
        Y8S0A6GmceMC6QCjcig62JJkYV4+1jU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624356217;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nKhgE6954NvfhMQjK/nStOUEryBEduHx4QCTOdEaIp8=;
        b=WTZDJR4n7fnthL4WTGNiAtBecWLL0I7PA8YENTYpfBKdyTZqAf1wTTg6HEhE+1+l3Mx5TZ
        /lTFdmd+oWB5iBCg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 6DE80118DD;
        Tue, 22 Jun 2021 10:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624356217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nKhgE6954NvfhMQjK/nStOUEryBEduHx4QCTOdEaIp8=;
        b=dF2a93dYcxV7hUuWppSRFrVcx3D5IYJxzrPXNnwpo6D9KPQV8GMWW7a8UM63y5WBjrr/9P
        lEO1KFnK+P5yO5q+sjz4mqH1QvN5jC/h+JQZlP8++4o1b1H4dTaA9eeWCqwtDiQm4LF026
        Y8S0A6GmceMC6QCjcig62JJkYV4+1jU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624356217;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nKhgE6954NvfhMQjK/nStOUEryBEduHx4QCTOdEaIp8=;
        b=WTZDJR4n7fnthL4WTGNiAtBecWLL0I7PA8YENTYpfBKdyTZqAf1wTTg6HEhE+1+l3Mx5TZ
        /lTFdmd+oWB5iBCg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 18eqGnm10WD/PgAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 22 Jun 2021 10:03:37 +0000
Subject: Re: [PATCH 02/14] md: bcache: Fix spelling of 'acquire'
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Ding Senjie <dingsenjie@yulong.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-3-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <5c35f6e7-d9e0-7454-1ca5-016e1fb15aae@suse.de>
Date:   Tue, 22 Jun 2021 12:03:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210615054921.101421-3-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/15/21 7:49 AM, Coly Li wrote:
> From: Ding Senjie <dingsenjie@yulong.com>
> 
> acqurie -> acquire
> 
> Signed-off-by: Ding Senjie <dingsenjie@yulong.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 0a20ccf5a1db..2f1ee4fbf4d5 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2760,7 +2760,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
>  		 * The reason bch_register_lock is not held to call
>  		 * bch_cache_set_stop() and bcache_device_stop() is to
>  		 * avoid potential deadlock during reboot, because cache
> -		 * set or bcache device stopping process will acqurie
> +		 * set or bcache device stopping process will acquire
>  		 * bch_register_lock too.
>  		 *
>  		 * We are safe here because bcache_is_reboot sets to
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
