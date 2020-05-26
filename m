Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE8E1E287F
	for <lists+linux-bcache@lfdr.de>; Tue, 26 May 2020 19:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388238AbgEZRXI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 May 2020 13:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388606AbgEZRXI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 May 2020 13:23:08 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C5C03E96D
        for <linux-bcache@vger.kernel.org>; Tue, 26 May 2020 10:23:08 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x13so10430363pfn.11
        for <linux-bcache@vger.kernel.org>; Tue, 26 May 2020 10:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XZiBVQy3ZyqInX/lPPELK12F4eoCzSnUAnls0FtC9PU=;
        b=O1OYteMQWYmQRQ7Ld32WRgeSOIJYDCuAe7C+1yC2sm+pch158M8XDZDoxqYIhYeWhA
         r6k0aLHWxvlDuWn5QUbwQ9DxvvjbH48aTv/h3SGN8QkaoMuBeABOXgYXSO7V67rHy9z/
         8As+SB8XsW5BpzEUbvlXs7+P2aZIA4plVk0dXGYxj2U/JuyjFSMT46JmtEpi3/NI8hth
         vVbjdMVrEbgqJEki/1na1p5vJTWmstWdrA8sgCKKSwxNtih1K82YyC9mweXYmTPFOLaG
         eFdgXVys8F86ZW5OgykfnuUn82yPTczgLR7g4zoL9ilvKGTHYucGcJqQkDWMsV2xuVbo
         zYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XZiBVQy3ZyqInX/lPPELK12F4eoCzSnUAnls0FtC9PU=;
        b=bbIGtlljBFwkfg0efjEXiI5RcQeqScty1BbYNxnwX6s3WTvrlBt0lHtu9U8kPKyfYl
         QPlIAkNxiKa1IZl5HUKyLuFwzYksqkoXSdYYEAuDbXycFf3T/i0UxkC/lUkn0EEmvCKv
         kI7/xu07hrBUaoEXSYW4Bc+Tb79KMr6aA40s4pni65r2k6WzId7OwNUy93IZCgRSbkmJ
         Cn2Q1i0kt6XfQpXYq6MhgRxz9S/DnNjgF4Fk5eHjOkKJ7u/W3VIscfZ2Eb/Jj5NjRWzj
         ooC8XrvwKxjzRkrMWpLJj8RXky0JyVjnl62JtJRwVic2aNMurqTP+iqpyHT+gZ+5ZSTN
         aYiw==
X-Gm-Message-State: AOAM533LKEntD4vdGZyYO1hrf+R26sG2d0uyQp/Jkrh/tl9S2gvAs1o9
        +y/N0q+fIsWCv0REvEhP6VXCtB/i5BM=
X-Google-Smtp-Source: ABdhPJx2xUoNziZZOSHFHaPKllrnjGzWuV1cv3nCTFlokpAn8VHhFdMAWuzEBXMViYdobVnEAzOEkQ==
X-Received: by 2002:a63:24a:: with SMTP id 71mr2175037pgc.184.1590513787567;
        Tue, 26 May 2020 10:23:07 -0700 (PDT)
Received: from ?IPv6:2600:380:495a:792b:6476:7a3a:9257:12c7? ([2600:380:495a:792b:6476:7a3a:9257:12c7])
        by smtp.gmail.com with ESMTPSA id k24sm129137pfk.134.2020.05.26.10.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 10:23:06 -0700 (PDT)
Subject: Re: [PATCH 3/5] bcache: fix refcount underflow in
 bcache_device_free()
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200526155928.32036-1-colyli@suse.de>
 <20200526155928.32036-4-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <34b826ff-0093-4427-f542-88c17abad934@kernel.dk>
Date:   Tue, 26 May 2020 11:23:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526155928.32036-4-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/26/20 9:59 AM, Coly Li wrote:
> The problematic code piece in bcache_device_free() is,
> 
>  785 static void bcache_device_free(struct bcache_device *d)
>  786 {
>  787     struct gendisk *disk = d->disk;
>  [snipped]
>  799     if (disk) {
>  800             if (disk->flags & GENHD_FL_UP)
>  801                     del_gendisk(disk);
>  802
>  803             if (disk->queue)
>  804                     blk_cleanup_queue(disk->queue);
>  805
>  806             ida_simple_remove(&bcache_device_idx,
>  807                               first_minor_to_idx(disk->first_minor));
>  808             put_disk(disk);
>  809         }
>  [snipped]
>  816 }
> 
> At line 808, put_disk(disk) may encounter kobject refcount of 'disk'
> being underflow.
> 
> Here is how to reproduce the issue,
> - Attche the backing device to a cache device and do random write to
>   make the cache being dirty.
> - Stop the bcache device while the cache device has dirty data of the
>   backing device.
> - Only register the backing device back, NOT register cache device.
> - The bcache device node /dev/bcache0 won't show up, because backing
>   device waits for the cache device shows up for the missing dirty
>   data.
> - Now echo 1 into /sys/fs/bcache/pendings_cleanup, to stop the pending
>   backing device.
> - After the pending backing device stopped, use 'dmesg' to check kernel
>   message, a use-after-free warning from KASA reported the refcount of
>   kobject linked to the 'disk' is underflow.
> 
> The dropping refcount at line 808 in the above code piece is added by
> add_disk(d->disk) in bch_cached_dev_run(). But in the above condition
> the cache device is not registered, bch_cached_dev_run() has no chance
> to be called and the refcount is not added. The put_disk() for a non-
> added refcount of gendisk kobject triggers a underflow warning.
> 
> This patch checks whether GENHD_FL_UP is set in disk->flags, if it is
> not set then the bcache device was not added, don't call put_disk()
> and the the underflow issue can be avoided.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/super.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 467149f3bcc5..c68d42730ca0 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -797,15 +797,20 @@ static void bcache_device_free(struct bcache_device *d)
>  		bcache_device_detach(d);
>  
>  	if (disk) {
> -		if (disk->flags & GENHD_FL_UP)
> +		bool disk_added = false;
> +
> +		if (disk->flags & GENHD_FL_UP) {
> +			disk_added = true;
>  			del_gendisk(disk);
> +		}

This would be cleaner as:

	bool disk_added = (disk->flags & GENHD_FL_UP) != 0;

	if (disk_added)
		del_gendisk(disk);

and so on.

-- 
Jens Axboe

