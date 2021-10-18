Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70555431FFA
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhJROlC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 10:41:02 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42536 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbhJROlB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 10:41:01 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8CD271FD6D;
        Mon, 18 Oct 2021 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634567929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8UvXsr4YdfQ7VgkGnQdWA+e9mE7dE4zVzaWSBBF8jg=;
        b=o+9Zvqxd1zuDScRmj5FHQAN5pzElDNi2/StYJl4146XL/kcktUIt6iI5buFYaaStGsLoId
        q26b9xdO5mJGwYUW6G+4UwKTe66LzW8kgYWg7u/bNB2Wye1RLAyNvlN2SC9RQOyHgWFujW
        rNFAhqufro2+zDXaSSLwmVzS2uOgItM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634567929;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8UvXsr4YdfQ7VgkGnQdWA+e9mE7dE4zVzaWSBBF8jg=;
        b=Y21sqWMsX6UPj4zZfaRctayVo4D1ZzUauurUOtVIDqXr5Zsh6PpBCgYf3jYW7MdYc+oedo
        B+cZPHL3f9Hx95Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B212114090;
        Mon, 18 Oct 2021 14:38:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hCNhG/WGbWGlBAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 18 Oct 2021 14:38:45 +0000
Subject: Re: [PATCH] bcache: move calc_cached_dev_sectors to proper place on
 backing device detach
To:     Lin Feng <linf@wangsu.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20211015101600.91109-1-linf@wangsu.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <fcae5dd6-ddd7-d402-fed2-a42a473cf823@suse.de>
Date:   Mon, 18 Oct 2021 22:38:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211015101600.91109-1-linf@wangsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/15/21 6:16 PM, Lin Feng wrote:
> Calculation of cache_set's cached sectors is done by travelling
> cached_devs list as shown below:
>
> static void calc_cached_dev_sectors(struct cache_set *c)
> {
> ...
>          list_for_each_entry(dc, &c->cached_devs, list)
>                  sectors += bdev_sectors(dc->bdev);
>
>          c->cached_dev_sectors = sectors;
> }
>
> But cached_dev won't be unlinked from c->cached_devs list until we call
> following list_move(&dc->list, &uncached_devices),
> so previous fix in 'commit 46010141da6677b81cc77f9b47f8ac62bd1cbfd3
> ("bcache: recal cached_dev_sectors on detach")' is wrong, now we move
> it to its right palce.
>
> Signed-off-by: Lin Feng <linf@wangsu.com>

Nice catch! I added it in my testing series. Thanks.

Coly Li

> ---
>   drivers/md/bcache/super.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index f2874c77ff79..8543e6997770 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1154,9 +1154,9 @@ static void cached_dev_detach_finish(struct work_struct *w)
>   
>   	mutex_lock(&bch_register_lock);
>   
> -	calc_cached_dev_sectors(dc->disk.c);
>   	bcache_device_detach(&dc->disk);
>   	list_move(&dc->list, &uncached_devices);
> +	calc_cached_dev_sectors(dc->disk.c);
>   
>   	clear_bit(BCACHE_DEV_DETACHING, &dc->disk.flags);
>   	clear_bit(BCACHE_DEV_UNLINK_DONE, &dc->disk.flags);

