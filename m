Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1663E4409C2
	for <lists+linux-bcache@lfdr.de>; Sat, 30 Oct 2021 16:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhJ3PBX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 30 Oct 2021 11:01:23 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39976 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhJ3PBX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Oct 2021 11:01:23 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 16FDA1FD36;
        Sat, 30 Oct 2021 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635605932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jDNP1uU1T2HsrR6XxIFIF9oPRNn3dUAQ9/C5zYbJjGk=;
        b=U2I72QVEtDEhCp9io7XtmwcKflZnz1hESRmp7UTgGqtd7ND5gsBsKCmwCylAcr7BuZCG8x
        eC/3Pm4vmCvymfPj7wBpN0Hb6dREc82IA4zim08vTUPRTwmPM0DZYGujGaUaioWD07fqOH
        9iWTQyIdd5Q9QeqQUge2ZW5DxyReykA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635605932;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jDNP1uU1T2HsrR6XxIFIF9oPRNn3dUAQ9/C5zYbJjGk=;
        b=TiC1BWcgHMIhMshyz91bkKVLeWarnQGyK+ATEm1YDpSRHHo6DRgtD081oCgEB89W1cLYNJ
        GIBMsRcVse+hO0CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3A785139CF;
        Sat, 30 Oct 2021 14:58:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id B4aZAatdfWGgUgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 30 Oct 2021 14:58:51 +0000
Message-ID: <abf21c4f-5bbb-a0bb-534a-3d2758b4a8d6@suse.de>
Date:   Sat, 30 Oct 2021 22:58:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH] bcache: remove unused struct member in cache_stats
Content-Language: en-US
To:     Lin Feng <linf@wangsu.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211029115939.92309-1-linf@wangsu.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211029115939.92309-1-linf@wangsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/29/21 7:59 PM, Lin Feng wrote:
> Commit 1616a4c2ab1a80893b6890ae93da40a2b1d0c691
> ("bcache: remove bcache device self-defined readahead")
> remove stuffs for bcache self-defined readahead, but
> cache_readaheads field in cache_stats is leftout, remove it.
>
> Signed-off-by: Lin Feng <linf@wangsu.com>

Nice catch. I add it into my testing queue. Thanks.

Coly Li

> ---
>   drivers/md/bcache/stats.h | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/md/bcache/stats.h b/drivers/md/bcache/stats.h
> index ca4f435f7216..b6bfea66c01f 100644
> --- a/drivers/md/bcache/stats.h
> +++ b/drivers/md/bcache/stats.h
> @@ -18,7 +18,6 @@ struct cache_stats {
>   	unsigned long cache_misses;
>   	unsigned long cache_bypass_hits;
>   	unsigned long cache_bypass_misses;
> -	unsigned long cache_readaheads;
>   	unsigned long cache_miss_collisions;
>   	unsigned long sectors_bypassed;
>   

