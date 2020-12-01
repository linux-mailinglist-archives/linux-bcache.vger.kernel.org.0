Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE972C9689
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Dec 2020 05:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgLAEfs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 30 Nov 2020 23:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgLAEfr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Nov 2020 23:35:47 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC749C0613CF;
        Mon, 30 Nov 2020 20:35:07 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id e5so466440pjt.0;
        Mon, 30 Nov 2020 20:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=BPtWYGD7y8CigqXoE2gXVtOc81D8k8JttMXCbXMY8s0=;
        b=YtFuwEFsueHt4H+UiwWyjkGT+32Y7ExycKvIjYZJyciw08BO8hcpGs/PW2Up2XUhDV
         McPNQ4m4mviviDMYzU/W4wBwVDXT+RmBa6V1PeDFDfyHeNKhhkniIu34apuz41AhSzs6
         v5FlmRULyJNvR4zG+Mq2y21Hy/R+zftifiFqbLnBCa2ueaPCaYpaPPXHJs5Wy/n4kJ/y
         r/lxdug5eGLvhr/x+6tdEH8jHqGgs+t9P2boyf/Rrc2IFwElPE3gUVRWMdi0Q0raAMRf
         Gk5tBWIwjxKz8PqRBg5BdRgWLg424IglcC2I+fsHZX5Yt2LtN0q0p8mPZh7cLK0AMczd
         IbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=BPtWYGD7y8CigqXoE2gXVtOc81D8k8JttMXCbXMY8s0=;
        b=WRjLNXC5P57dTa/Gdkc14MfguUw4XHweeGto3i4b0k98xuuqE/NyrMSUduudytUkjV
         5XdI40UlCiU1Ssi8bewwQJA6tG2BjUr6HyYLyIaV4dInlvqnzXFnyuSdBJUxD1z48UZu
         GPydEyZadceRxnc6PiZULjht+jldICj+tFHLWCnltNmo4zr3M+N61J1DxR6QGKUlOxfg
         A7LtJbZvE+qk2GwVkEHVTC7tOYRfzPQgnF4+lX/xuR3B/ghM5Ou+B8bfAIe2+MeQ6bx4
         o6pjwvD1lqXcrkg+lzSlFLNB71uxZQ0rvyCAPZi09fK/v5t75MyTwFIx/Jatvs25cHRL
         RMVg==
X-Gm-Message-State: AOAM5333UXLa2m7QnHyR55wc2rLIVvRNlymIIvK+DbynlDm22yqRp2qO
        BGXrJgHqLXRt9mRfuAY06x7wgNG30d2PEYbZLZpol/zRSVg=
X-Google-Smtp-Source: ABdhPJyBt3QNzW9OVRkY+oVCY64/AnhKw2iU+cGYjXVyQhP9Bv0zJs3DTlgcK9463VIJADa4k/DRkmH2iag8z8YK/zo=
X-Received: by 2002:a17:902:a581:b029:da:d78:7f79 with SMTP id
 az1-20020a170902a581b02900da0d787f79mr1073866plb.32.1606797307177; Mon, 30
 Nov 2020 20:35:07 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90a:7886:0:0:0:0 with HTTP; Mon, 30 Nov 2020 20:35:06
 -0800 (PST)
In-Reply-To: <20201130112137.587437-1-yili@winhong.com>
References: <20201130112137.587437-1-yili@winhong.com>
From:   Yi Li <yilikernel@gmail.com>
Date:   Tue, 1 Dec 2020 12:35:06 +0800
Message-ID: <CAJfdMYDnDJXFVfEECtQ9-E4F9kfsF035PH+x3kaVn6PPSYCydA@mail.gmail.com>
Subject: Re: [PATCH] bcache: fix panic due to cache_set is null
To:     Yi Li <yili@winhong.com>
Cc:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo Chao <guochao@winhong.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

sorry, This patch will cause deadlock, i will check and redo it.

On 11/30/20, Yi Li <yili@winhong.com> wrote:
> bcache_device_detach will release the cache_set after hotunplug cache
> disk. update_writeback_rate should check validate of cache_set.
>
>   IP: [<ffffffffa03730c9>] update_writeback_rate+0x59/0x3a0 [bcache]
>   PGD 879620067 PUD 8755d3067 PMD 0
>   Oops: 0000 [#1] SMP
>   CPU: 8 PID: 1005702 Comm: kworker/8:0 Tainted: G 4.4.0+10 #1
>   Hardware name: Intel BIOS SE5C610.86B.01.01.0021.032120170601 03/21/2017
>   Workqueue: events update_writeback_rate [bcache]
>   task: ffff8808786f3800 ti: ffff88077082c000 task.ti: ffff88077082c000
>   RIP: e030:[<ffffffffa03730c9>] update_writeback_rate+0x59/0x3a0 [bcache]
>   RSP: e02b:ffff88077082fde0  EFLAGS: 00010202
>   RAX: 0000000000000018 RBX: ffff8808047f0b08 RCX: 0000000000000000
>   RDX: 0000000000000001 RSI: ffff88088170dab8 RDI: ffff88088170dab8
>   RBP: ffff88077082fe18 R08: 000000000000000a R09: 0000000000000000
>   R10: 0000000000000000 R11: 0000000000017bc8 R12: 0000000000000000
>   R13: ffff8808047f0000 R14: 0000000000000200 R15: ffff8808047f0b08
>   FS:  00007f157b6d6700(0000) GS:ffff880881700000(0000)
> knlGS:0000000000000000
>   CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000368 CR3: 0000000875c05000 CR4: 0000000000040660
>   Stack:
>    0000000000000001 0000000000007ff0 ffff88085ff600c0 ffff880881714e80
>    ffff880881719500 0000000000000200 ffff8808047f0b08 ffff88077082fe60
>    ffffffff81088c0c 0000000081714e80 0000000000000000 ffff880881714e80
>   Call Trace:
>    [<ffffffff81088c0c>] process_one_work+0x1fc/0x3b0
>    [<ffffffff81089575>] worker_thread+0x2a5/0x470
>    [<ffffffff815a2f58>] ? __schedule+0x648/0x870
>    [<ffffffff810892d0>] ? rescuer_thread+0x300/0x300
>    [<ffffffff8108e3d5>] kthread+0xd5/0xe0
>    [<ffffffff8108e300>] ? kthread_stop+0x110/0x110
>    [<ffffffff815a704f>] ret_from_fork+0x3f/0x70
>    [<ffffffff8108e300>] ? kthread_stop+0x110/0x110
>
> Reported-by: Guo Chao <guochao@winhong.com>
> Signed-off-by: Guo Chao <guochao@winhong.com>
> Signed-off-by: Yi Li <yili@winhong.com>
> ---
>  drivers/md/bcache/writeback.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 3c74996978da..186c4c6e1607 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -175,7 +175,15 @@ static void update_writeback_rate(struct work_struct
> *work)
>  	struct cached_dev *dc = container_of(to_delayed_work(work),
>  					     struct cached_dev,
>  					     writeback_rate_update);
> -	struct cache_set *c = dc->disk.c;
> +	struct cache_set *c = NULL;
> +
> +	mutex_lock(&bch_register_lock);
> +	c = dc->disk.c;
> +
> +	if (c == NULL) {
> +		mutex_unlock(&bch_register_lock);
> +		return;
> +	}
>
>  	/*
>  	 * should check BCACHE_DEV_RATE_DW_RUNNING before calling
> @@ -194,6 +202,7 @@ static void update_writeback_rate(struct work_struct
> *work)
>  		clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>  		/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
>  		smp_mb__after_atomic();
> +		mutex_unlock(&bch_register_lock);
>  		return;
>  	}
>
> @@ -230,6 +239,7 @@ static void update_writeback_rate(struct work_struct
> *work)
>  	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>  	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
>  	smp_mb__after_atomic();
> +	mutex_unlock(&bch_register_lock);
>  }
>
>  static unsigned int writeback_delay(struct cached_dev *dc,
> --
> 2.25.3
>
>
>
>
