Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A371770B8
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Mar 2020 09:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgCCIFs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Mar 2020 03:05:48 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39317 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbgCCIFr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Mar 2020 03:05:47 -0500
Received: by mail-wm1-f66.google.com with SMTP id j1so360188wmi.4;
        Tue, 03 Mar 2020 00:05:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VN8h+lNVWgJupwZ7sOqHZQrZrplobWHWydFd7tUhWVQ=;
        b=JW1dmdeTaYEYlh/4d5poi49UMxcf63snIivKpHEDycZW8dp2PVzpiBH46xdKpZ+9M8
         cR91g2QYT1HcVCMABi46x5h16F7sALD1THnjVd8EAlF5f7GEwfxveeJHENSVZFid3Sjk
         qUB9Ye2k6ct7tvfWosd5DIgYSyNcfuCMjT6sUhlixs3a3Ke0AmcngBsYlPFonacBzRAJ
         ir55DjjGVjPQMxpg8UZArUWoffZXabU1gUT9VhURi6NvmEkScSRVic9OxRmZlTrg8HJ3
         +7Z47hjm2OOg11z0xE2X4vADjkWLJV8A8oziDhdesK0RIoxbiYqd1i/mDFpuAFUViLay
         fGMg==
X-Gm-Message-State: ANhLgQ1yjDsVEfethzOjRUBoWhWhQntUWLn47dPIIMxfieL6n9PNyQDh
        uWR1/OYjWqcpAYN7QUDu/Kq3R0pG
X-Google-Smtp-Source: ADFU+vvLJyjWPR1wVF+Ou2sWSs56ROHDul5N7S06Nse67CGwupqRTW4bBDR4X3SIU6KCrhBqlTJYnw==
X-Received: by 2002:a7b:cbd6:: with SMTP id n22mr3066952wmi.118.1583222746120;
        Tue, 03 Mar 2020 00:05:46 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id n3sm2857589wmc.27.2020.03.03.00.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 00:05:45 -0800 (PST)
Date:   Tue, 3 Mar 2020 09:05:44 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200303080544.GW4380@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302134919.GB9769@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon 02-03-20 14:49:19, Oleg Nesterov wrote:
> On 03/02, Michal Hocko wrote:
> >
> > I cannot really comment on the bcache part because I am not familiar
> > with the code.
> 
> same here...
> 
> > > This patch calls flush_signals() in bcache_device_init() if there is
> > > pending signal for current process. It avoids bcache registration
> > > failure in system boot up time due to bcache udev rule timeout.
> >
> > this sounds like a wrong way to address the issue. Killing the udev
> > worker is a userspace policy and the kernel shouldn't simply ignore it.
> 
> Agreed. If nothing else, if a userspace process has pending SIKILL then
> flush_signals() is very wrong.
> 
> > Btw. Oleg, I have noticed quite a lot of flush_signals usage in the
> > drivers land and I have really hard time to understand their purpose.
> 
> Heh. I bet most if not all users of flush_signals() are simply wrong.
> 
> > What is the actual valid usage of this function?
> 
> I thinks it should die...

Can we simply deprecate it and add a big fat comment explaning why this
is wrong interface to use?

So what about this?
diff --git a/kernel/signal.c b/kernel/signal.c
index 9ad8dea93dbb..8a895e565e84 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -465,7 +465,13 @@ void flush_sigqueue(struct sigpending *queue)
 }
 
 /*
- * Flush all pending signals for this kthread.
+ * Flush all pending signals for this kthread. Please note that this interface
+ * shouldn't be used and in fact it is DEPRECATED.
+ * Existing users should be double checked because most of them are likely
+ * obsolete. Kernel threads are not on the receiving end of signal delivery
+ * unless they explicitly request that by allow_signal() and in that case
+ * flush_signals is almost always a bug because signal should be processed
+ * by kernel_dequeue_signal rather than dropping them on the floor.
  */
 void flush_signals(struct task_struct *t)
 {
-- 
Michal Hocko
SUSE Labs
