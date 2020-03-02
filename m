Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98FC175BEE
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Mar 2020 14:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgCBNkx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 08:40:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39920 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbgCBNkw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 08:40:52 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so12653919wrn.6;
        Mon, 02 Mar 2020 05:40:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z3+rVWv/UryQhiWJcT9oQnLzIE2lJBETYP6wP31uofI=;
        b=ucgY1AGAzU7/AnyFFCAFPrcRQHZxdl4xEUg3+TYdaYIwTCGDWoFeaBnYjoUbJ5txpj
         HytS5o8R0SD0SCwJbWZufQ0q0isrBwZ4uk3Tr+FWhUTJHZJ2DG6pGRVB2q77b2kG5LbQ
         4Ee2buwabTvlLbeZR4D50BUrYPv5B/Iih7Tn35wIxG+QqlMdIp8OEn7rDqxeSMmL3oGP
         fk1CeDHtiCjZWMiLVsg0/8CyNn3fOv6mA6sBKRyaBqunXtXzm4Tf4MRARluRfN6FX6qH
         ccU6P8t4gaz9m0vNHTIfFtPPx1gtdtWlILTGC1kc31diKm84g7UPWf9pvAXz8bEleHYq
         9LAA==
X-Gm-Message-State: APjAAAWrcz8izxWc314lf6II595PJPEDYkC1MeSSp5UUulNXlKPnfmAs
        kPvCY6mBPi8NDPehX/GdEOc=
X-Google-Smtp-Source: APXvYqwEB11NRYT0lgBjiExd91VaQCJL3aE7bngI05EyrcY4FHLy7u2Lvf8sG8l52x/NxVV8UMcFzg==
X-Received: by 2002:adf:f7c1:: with SMTP id a1mr15169886wrq.299.1583156450508;
        Mon, 02 Mar 2020 05:40:50 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id u25sm7776775wml.17.2020.03.02.05.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 05:40:49 -0800 (PST)
Date:   Mon, 2 Mar 2020 14:40:48 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com,
        Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200302134048.GK4380@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon 02-03-20 21:29:09, Coly Li wrote:
[...]
> > I cannot really comment on the bcache part because I am not familiar
> > with the code. It is quite surprising to see an initialization taking
> > that long though.
> > 
> 
> Back to the time 10 years ago when bcache merged into Linux mainline,
> checking meta data for a 120G SSD was fast. But now an 8TB SSD is quite
> common on server... So the problem appears.

Does all that work has to happen synchronously from the kworker context?
Is it possible some of the initialization to be done more lazily or in
the background?

> > Anyway
> > 
> >> This patch calls flush_signals() in bcache_device_init() if there is
> >> pending signal for current process. It avoids bcache registration
> >> failure in system boot up time due to bcache udev rule timeout.
> > 
> > this sounds like a wrong way to address the issue. Killing the udev
> > worker is a userspace policy and the kernel shouldn't simply ignore it.
> 
> Indeed the bcache registering process cannot be killed, because a mutex
> lock (bch_register_lock) is held during all the registration operation.
> 
> In my testing, kthread_run()/kthread_create() failure by pending signal
> happens after all metadata checking finished, that's 55 minutes later.
> No mater the registration successes or fails, the time length is same.
> 
> Once the udev timeout killing is useless, why not make the registration
> to success ? This is what the patch does.

I cannot really comment for the systemd part but it is quite unexpected
for it to have signals ignored completely.

> > Is there any problem to simply increase the timeout on the system which
> > uses a large bcache?
> > 
> 
> At this moment, this is a workaround. Christoph Hellwig also suggests to
> fix kthread_run()/kthread_create(). Now I am looking for method to
> distinct that the parent process is killed by OOM killer and not by
> other processes in kthread_run()/kthread_create(), but the solution is
> not clear to me yet.

It is really hard to comment on this because I do not have a sufficient
insight but in genereal. The oom victim context can be checked by
tsk_is_oom_victim but kernel threads are subject of the oom killer
because they do not own any address space. I also suspect that none of
the data you allocate for the cache is accounted per any specific
process.

> When meta-data size is around 40GB, registering cache device will take
> around 55 minutes on my machine for current Linux kernel. I have patch
> to reduce the time to around 7~8 minutes but still too long. I may add a
> timeout in bcache udev rule for example 10 munites, but when the cache
> device get large and large, the timeout will be not enough eventually.
> 
> As I mentioned, this is a workaround to fix the problem now. Fixing
> kthread_run()/kthread_create() may take longer time for me. If there is
> hint to make it, please offer me.

My main question is why there is any need to touch the kernel code. You
can still update the systemd/udev timeout AFAIK. This would be the
proper workaround from my (admittedly limited) POV.

-- 
Michal Hocko
SUSE Labs
