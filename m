Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D39434F07
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Oct 2021 17:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhJTPas (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Oct 2021 11:30:48 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:60264 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhJTPar (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Oct 2021 11:30:47 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 85C891FD33;
        Wed, 20 Oct 2021 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634743712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u2G1JVJm+eqBNFDVpnzb/HgQDnZjQzD2Xue4wI5hvF0=;
        b=EPbh9/ohfNUAHlQoeSzWZm4kyernpFobi8z09Fh4T/BLz+XhYRl2iG3Pm+6cl2gGFKrq/s
        wZynLka6VpMINeBMwLTBt0bXi/Sp/hJ3L/j6s1SrTLyYyDkPE7M5+Wp0+WAzgRLOiTdz2a
        E9I/ElPX2qbJXenE9Z3vqL2P439x69I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634743712;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u2G1JVJm+eqBNFDVpnzb/HgQDnZjQzD2Xue4wI5hvF0=;
        b=TJ+mUaX12/k175PKOlfYTZgQhTFcRwfrEpvw3+ueRvLQREcYaON0ijNjTALmpJLfL5fJ97
        lFnA4t+lxzCr62Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 868EF13BA1;
        Wed, 20 Oct 2021 15:28:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id laeXCZ81cGEqOQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 20 Oct 2021 15:28:31 +0000
Message-ID: <ae9f553a-ce85-4537-7038-3f16bdf69cab@suse.de>
Date:   Wed, 20 Oct 2021 23:28:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH] bcache: use pr_err instead of pr_notice if we are really
 error
Content-Language: en-US
To:     Lin Feng <linf@wangsu.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20211020021313.140414-1-linf@wangsu.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211020021313.140414-1-linf@wangsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/20/21 10:13 AM, Lin Feng wrote:
> In bcache we have:
> ./bset.c:			pr_notice("loop %u, %llu per us\n", size,
> ./super.c:	pr_notice("error %s: %s\n", dc->backing_dev_name, err);
> ./super.c:		pr_notice("invalidating existing data\n");
> ./super.c:		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
> ./super.c:		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
> ./super.c:			pr_notice("Timeout waiting for devices to be closed\n");
>
> and 3 sites with string 'error' are really error happening on device
> register.

It is fine to keep current dmesg level and message format.

Thanks.

Coly Li

>
> Signed-off-by: Lin Feng <linf@wangsu.com>
> ---
>   drivers/md/bcache/super.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index f2874c77ff79..18a2e4bea9c2 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1493,7 +1493,7 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>   
>   	return 0;
>   err:
> -	pr_notice("error %s: %s\n", dc->backing_dev_name, err);
> +	pr_err("%s: %s\n", dc->backing_dev_name, err);
>   	bcache_device_stop(&dc->disk);
>   	return ret;
>   }
> @@ -2338,7 +2338,7 @@ static int cache_alloc(struct cache *ca)
>   err_free:
>   	module_put(THIS_MODULE);
>   	if (err)
> -		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
> +		pr_err("%s: %s\n", ca->cache_dev_name, err);
>   	return ret;
>   }
>   
> @@ -2397,7 +2397,7 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>   
>   err:
>   	if (err)
> -		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
> +		pr_err("%s: %s\n", ca->cache_dev_name, err);
>   
>   	return ret;
>   }

