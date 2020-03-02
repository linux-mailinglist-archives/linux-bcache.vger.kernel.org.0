Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317E1176101
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Mar 2020 18:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgCBR2o (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 12:28:44 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53051 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbgCBR2o (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 12:28:44 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so161900wmc.2;
        Mon, 02 Mar 2020 09:28:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wEtPgfu0HfG5feNW7QnIunlJKGFySpxLBRnknTYQe/o=;
        b=bKijkowJY+cKo0xCaRbUYG2Nl/FO9/+SIKBBDKMuYhWBKJCiYss2ewMpEysvrBYBcX
         5UZT5YnuOHtiA3pIp2Lu8Wg4sc0QVcaUmqtvgZeMK2RjeEkfHdWZfz+VPPGH+MlWr9Ui
         uNe4OWFIA/UB4MyV98iv/nXOXWjg6zfiEdaPGzdURJ3S4tAMIYCJd97KKYMG6JgS6kEc
         ZaLwVYpj5t+4BoyxJXaPJx2QbbMd/hAz1lDkWNhy0JzR6rcMwZyuT9hKZjbXzTjOnoTb
         Hw1XYrn/sd0PQma3SO+pRDme8fTvUOPJ5feEfFdR2WzbmpSO6SmDBvSYIBdfIqXjAonP
         9Hyg==
X-Gm-Message-State: ANhLgQ0XyMaIxZ/6fpzXT5f0hLIhaUWREaKFLs2KOPpZFO1pBlD5fqGE
        LePoB+t5cROQEmK0cWJo/oY=
X-Google-Smtp-Source: ADFU+vs+ow+Ij0NYg2Lpe7b8CoZIs9XQJnYhnDOVmky6bbcbxQ64Zr3zwqSCNb85q/bHmOwHqQEhWg==
X-Received: by 2002:a7b:cbc9:: with SMTP id n9mr128747wmi.89.1583170121968;
        Mon, 02 Mar 2020 09:28:41 -0800 (PST)
Received: from localhost (ip-37-188-253-61.eurotel.cz. [37.188.253.61])
        by smtp.gmail.com with ESMTPSA id t187sm115832wmt.25.2020.03.02.09.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 09:28:41 -0800 (PST)
Date:   Mon, 2 Mar 2020 18:28:40 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com,
        Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200302172840.GQ4380@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
 <20200302134048.GK4380@dhcp22.suse.cz>
 <cc759569-e79e-a1a0-3019-0e07dd6957cb@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc759569-e79e-a1a0-3019-0e07dd6957cb@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue 03-03-20 01:06:38, Coly Li wrote:
> On 2020/3/2 9:40 下午, Michal Hocko wrote:
[...]
> > I cannot really comment for the systemd part but it is quite unexpected
> > for it to have signals ignored completely.
> > 
> 
> I see. But so far I don't have better solution to fix this problem.
> Asking people to do extra configure to udev rules is very tricky, most
> of common users will be scared. I need to get it fixed by no-extra
> configuration.

Well, I believe that having an explicit documentation that large cache
requires more tim to initialize is quite reasonable way forward. We
already do have similar situations with memory hotplug on extra large
machines with a small block size.
 
> >>> Is there any problem to simply increase the timeout on the system which
> >>> uses a large bcache?
> >>>
> >>
> >> At this moment, this is a workaround. Christoph Hellwig also suggests to
> >> fix kthread_run()/kthread_create(). Now I am looking for method to
> >> distinct that the parent process is killed by OOM killer and not by
> >> other processes in kthread_run()/kthread_create(), but the solution is
> >> not clear to me yet.
> > 
> > It is really hard to comment on this because I do not have a sufficient
> > insight but in genereal. The oom victim context can be checked by
> > tsk_is_oom_victim but kernel threads are subject of the oom killer
> > because they do not own any address space. I also suspect that none of
> > the data you allocate for the cache is accounted per any specific
> > process.
> 
> You are right, the cached data is not bonded to process, it is bonded to
> specific backing block devices.
> 
> In my case, kthread_run()/kthread_create() is called in context of
> registration process (/lib/udev/bcache-register), so it is unnecessary
> to worry about kthread address space. So maybe I can check
> tsk_is_oom_victim to judge whether current process is killing by OOM
> killer other then simply calling pending_signal() ?

What exactly are going to do about this situation? If you want to bail
out then you should simply do that on any pending fatal signal. Why is
OOM special?

> >> When meta-data size is around 40GB, registering cache device will take
> >> around 55 minutes on my machine for current Linux kernel. I have patch
> >> to reduce the time to around 7~8 minutes but still too long. I may add a
> >> timeout in bcache udev rule for example 10 munites, but when the cache
> >> device get large and large, the timeout will be not enough eventually.
> >>
> >> As I mentioned, this is a workaround to fix the problem now. Fixing
> >> kthread_run()/kthread_create() may take longer time for me. If there is
> >> hint to make it, please offer me.
> > 
> > My main question is why there is any need to touch the kernel code. You
> > can still update the systemd/udev timeout AFAIK. This would be the
> > proper workaround from my (admittedly limited) POV.
> > 
> 
> I see your concern. But the udev timeout is global for all udev rules, I
> am not sure whether change it to a very long time is good ... (indeed I
> tried to add event_timeout=3600 but I can still see the signal received).

All processes which can finish in the default timeout are not going to
regress when the forcefull temination happens later. I cannot really
comment on the systemd part because I am not familiar with internals but
the mere existence of the timeout suggests that the workflow should be
prepared for longer timeouts because initialization taking a long time
is something we have to live with. Something just takes too long to
initialized.
 
> Ignore the pending signal in bcache registering code is the only method
> currently I know to avoid bcache auto-register failure in boot time. If
> there is other way I can achieve the same goal, I'd like to try.

The problem is that you are effectivelly violating signal delivery
semantic because you are ignoring user signal without userspace ever
noticing. That to me sounds like a free ticket to all sorts of
hard-to-debug problems. What if the userspace expects the signal to be
handled? Really, you want to increase the existing timeout to workaround
it. If you can make the initialization process more swift then even
better.

> BTW, by the mean time, I am still looking for the reason why
> event_timeout=3600 in /etc/udev/udev.conf does not take effect...

I have a vague recollection that there are mutlitple timeouts and
setting only some is not sufficient.
-- 
Michal Hocko
SUSE Labs
