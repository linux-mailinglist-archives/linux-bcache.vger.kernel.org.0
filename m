Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF1442B824
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Oct 2021 08:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhJMHBS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Oct 2021 03:01:18 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48026 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbhJMHBS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Oct 2021 03:01:18 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6D38C1FF92;
        Wed, 13 Oct 2021 06:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634108354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3tUCEcZuFRYSLnVBLkohynaSi9b0pGLfms8DExFxQvo=;
        b=JBfNbLIbKybmCNz2skVR0VOpzMx/cV1xw0uOp3DwVBzJi4QnL5a8iPTPL0+qobkDZ1lAWn
        LTn6yOYoppnrd08w87+V5hbfyI18pzISszvZoMHIlouXIhNHgri+zMyNRQf7M4lrP1saLY
        AJ3uIDjUZ4zN0GbXTcFNlLGaDYw7KrY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634108354;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3tUCEcZuFRYSLnVBLkohynaSi9b0pGLfms8DExFxQvo=;
        b=A94QhBhulaK5+Mdl2P/MVhd5UxFzSuHLQ4G9PCSDgjyABGC3ozfpMac7OZsXNUa02IioI2
        qqJI/VLW+aY7Z6Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 61F8A13CD1;
        Wed, 13 Oct 2021 06:59:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aAKaC8GDZmH4ZgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 13 Oct 2021 06:59:13 +0000
Subject: Re: [PATCH] bcache: replace snprintf in show functions with
 sysfs_emit
To:     Qing Wang <wangqing@vivo.com>
References: <1634095639-4227-1-git-send-email-wangqing@vivo.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <2df27e53-c77f-b938-abf4-4e22271ee3d7@suse.de>
Date:   Wed, 13 Oct 2021 14:59:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1634095639-4227-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/13/21 11:27 AM, Qing Wang wrote:
> coccicheck complains about the use of snprintf() in sysfs show functions.
>
> Fix the coccicheck warning:
> WARNING: use scnprintf or sprintf.
>
> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
>
> Signed-off-by: Qing Wang <wangqing@vivo.com>
> ---
>   drivers/md/bcache/sysfs.c | 2 +-
>   drivers/md/bcache/sysfs.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 05ac1d6..e146c9e 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -639,7 +639,7 @@ static int bch_bset_print_stats(struct cache_set *c, char *buf)
>   	if (ret < 0)
>   		return ret;
>   
> -	return snprintf(buf, PAGE_SIZE,
> +	return sysfs_emit(buf,
>   			"btree nodes:		%zu\n"
>   			"written sets:		%zu\n"
>   			"unwritten sets:		%zu\n"

Let's keep this location as snprintf(), to make code style be consistent.


> diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
> index 215df32..8bec32d 100644
> --- a/drivers/md/bcache/sysfs.h
> +++ b/drivers/md/bcache/sysfs.h
> @@ -51,7 +51,7 @@ STORE(fn)								\
>   #define sysfs_printf(file, fmt, ...)					\
>   do {									\
>   	if (attr == &sysfs_ ## file)					\
> -		return snprintf(buf, PAGE_SIZE, fmt "\n", __VA_ARGS__);	\
> +		return sysfs_emit(buf, fmt "\n", __VA_ARGS__);	\
>   } while (0)
>   
>   #define sysfs_print(file, var)						\

IMHO I like this change :-) BTW, for snprint() from util.h, it seems 
only to be used by sysfs_print() in syfs.h, would you like to change it 
to use sysfs_emit too ?

Thanks for the patch.

Coly Li
