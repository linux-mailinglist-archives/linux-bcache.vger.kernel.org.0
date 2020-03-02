Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC2C175A73
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Mar 2020 13:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgCBM1z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 07:27:55 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42278 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbgCBM1z (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 07:27:55 -0500
Received: by mail-wr1-f65.google.com with SMTP id z11so3583121wro.9;
        Mon, 02 Mar 2020 04:27:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yyNykTgOSbAFaBa77RPEuXO9wiE6WwtTuJ9VTtl37xM=;
        b=lo7imkpwBiR2ZMuvXLbjCdWSLii6Bi0go1T6eG6ntwjKvV27CwBuhpDDqMjkqkvXI2
         pE51zkh5P0bw5Kozc+Xbra/ZViwxnXBb7Mt/BBEijfGyj8rszn0J6h56Llat/T8gG0jg
         v5u2Ph2y3zd02peTNho5wFtxV6dMzmlVgGpGl7UYqKJ6h5UTRsdHRknP+HhOKwmV4vQv
         2Uw950pIWDpUxf2d/xZNXJgBuNPQKFd0paGucU24dQk26UYkHm4pIVYd+ihwqJEA0u5a
         8FE2wRhSxbbeMzpOd8Or+MKzk6A30m/Bxpb58Zo60YZx48ad05xbk8iHJmt/U5revlgi
         LLnQ==
X-Gm-Message-State: APjAAAUb4TLUwS0IgFxYMmIGUzXYTxSRmLFlYqcTISFMjNZ9Q+Zx9D8j
        KwFGEdloaBVbIBDkZSz8u6g=
X-Google-Smtp-Source: APXvYqywt6nlQKFjC22R4MPtcWGXTuzPrvu9JibL+Pb6zbg4rjZf1NN383asJ5aQ9p80xb/yXlIKtw==
X-Received: by 2002:a5d:614b:: with SMTP id y11mr21688421wrt.161.1583152071815;
        Mon, 02 Mar 2020 04:27:51 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id v131sm16350226wme.23.2020.03.02.04.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 04:27:50 -0800 (PST)
Date:   Mon, 2 Mar 2020 13:27:48 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200302122748.GH4380@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302093450.48016-2-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

[Cc Oleg]

On Mon 02-03-20 17:34:49, Coly Li wrote:
> When cache device and cached device are registered simuteneously and
> register_cache() firstly acquires bch_register_lock. register_bdev()
> has to wait before register_cache() finished, it might be a very long
> time.
> 
> If the registration is from udev rules in system boot up time, and
> registration is not completed before udev timeout (default 180s), the
> registration process will be killed by udevd. Then the following calls
> to kthread_run() or kthread_create() will fail due to the pending
> signal (they are implemented this way at this moment).
> 
> For boot time, this is not good, because it means a cache device with
> huge cached data will always fail in boot time, just because it
> spends too much time to check its internal meta data (btree and dirty
> sectors).
> 
> The failure for cache device registration is solved by previous
> patches, but failure due to timeout also exists in cached device
> registration. As the above text explains, cached device registration
> may also be timeout if it is blocked by a timeout cache device
> registration process. Then in the following code path,
>     bioset_init() <= bcache_device_init() <= cached_dev_init() <=
>     register_bdev() <= register_bcache()
> bioset_init() will fail because internally kthread_create() will fail
> for pending signal in the following code path,
>     bioset_init() => alloc_workqueue() => init_rescuer() =>
>     kthread_create()
> 
> Maybe fix kthread_create() and kthread_run() is better method, but at
> this moment a fast workaroudn is to flush pending signals before
> calling bioset_init() in bcache_device_init().

I cannot really comment on the bcache part because I am not familiar
with the code. It is quite surprising to see an initialization taking
that long though.

Anyway

> This patch calls flush_signals() in bcache_device_init() if there is
> pending signal for current process. It avoids bcache registration
> failure in system boot up time due to bcache udev rule timeout.

this sounds like a wrong way to address the issue. Killing the udev
worker is a userspace policy and the kernel shouldn't simply ignore it.
Is there any problem to simply increase the timeout on the system which
uses a large bcache?

Btw. Oleg, I have noticed quite a lot of flush_signals usage in the
drivers land and I have really hard time to understand their purpose.
What is the actual valid usage of this function? Should we somehow
document it?

> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/super.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 0c3c5419c52b..e8bbd4f171ca 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -850,6 +850,18 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  	if (idx < 0)
>  		return idx;
>  
> +	/*
> +	 * There is a timeout in udevd, if the bcache device is registering
> +	 * by udev rules, and not completed in time, the udevd may kill the
> +	 * registration process. In this condition, there will be pending
> +	 * signal here and cause bioset_init() failed for internally creating
> +	 * its kthread. Here the registration should ignore the timeout and
> +	 * continue, it is safe to ignore the pending signal and avoid to
> +	 * fail bcache registration in boot up time.
> +	 */
> +	if (signal_pending(current))
> +		flush_signals(current);
> +
>  	if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
>  			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>  		goto err;
> -- 
> 2.16.4

-- 
Michal Hocko
SUSE Labs
