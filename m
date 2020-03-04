Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9995D17908B
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Mar 2020 13:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbgCDMlu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Mar 2020 07:41:50 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53154 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgCDMlt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 07:41:49 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so1913907wmc.2;
        Wed, 04 Mar 2020 04:41:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k9ZUgJ2y5FoAeOcjgBtyAv9QSnxPv/F9aAo3tJZ6stg=;
        b=twhDf9ALW93K54gzJeuQYeciVELVIO5dXqCFJ5d7dYnEKZD2tx0rSJqBcIUG4HrkAK
         mRTOJKy36p4l7tyO1hteuKa4zyWR0coGrZU1n9veHFuhrD6mesl2j+PlXiTK7L7XW3wG
         l/a2UPfHqH1G/Y9jv8bd68ULd1roHkNLEJlcReAuse0O7lI/cHS8RDirWEaouKtspKoz
         C0hXlUEtPzPUwodbv1+ZqL9+/Gjek9pWv3SQThDZrEuZjfgU0wtbv0H/VIOEHx74+SiY
         OwUG6VSs85eiOB8QFnMePCO7vaI4AYgEEIdRNyNS9dmipMCiB4Jn5Fl0FBQQxhXmz3kr
         cQsg==
X-Gm-Message-State: ANhLgQ3PiUVYtxQRUcKH9b6aZ0nXhDrjKzUWKOBwbg/TAiZY19nbwvvB
        cnv95rdwpbi33e2R1SPEBxo=
X-Google-Smtp-Source: ADFU+vubSRivErKd4V7pm6hYOJLVpUBjOFdVyrrtJKBHw4QM8JS5q3jChXOT4Z91IYhIrCHjmvlboQ==
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr3551538wme.30.1583325705906;
        Wed, 04 Mar 2020 04:41:45 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id w22sm4212824wmk.34.2020.03.04.04.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 04:41:44 -0800 (PST)
Date:   Wed, 4 Mar 2020 13:41:44 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200304124144.GL16139@dhcp22.suse.cz>
References: <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
 <20200304115718.GI16139@dhcp22.suse.cz>
 <20200304121324.GC13170@redhat.com>
 <20200304122226.GJ16139@dhcp22.suse.cz>
 <20200304123342.GD13170@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304123342.GD13170@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed 04-03-20 13:33:42, Oleg Nesterov wrote:
> On 03/04, Michal Hocko wrote:
> >
> > On Wed 04-03-20 13:13:25, Oleg Nesterov wrote:
> > > On 03/04, Michal Hocko wrote:
> > > >
> > > > So what would be a legit usecase to drop all signals while explicitly
> > > > calling allow_signal?
> > >
> > > Not sure I understand...
> >
> > flush_signals will simply drop all pending signals on the floor so there
> > is no way to handle them, right? I am asking when is still really a
> > desirable thing to do when you allow_signal for the kthread. The only
> > one I can imagine is that the kthread allows a single signal so it is
> > quite clear which signal is flushed.
> 
> Yes. This is what I meant when I said "they should do the same if kthread
> allows a single signal".

OK, good that we are at the same page. I have clearly misread your
earlier email.
 
> > kernel_dequeue_signal on the other hand will give you a signal and so
> > the code can actually handle it in some way.
> 
> Yes.

diff --git a/kernel/signal.c b/kernel/signal.c
index 9ad8dea93dbb..959adc2a5a3d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -465,7 +465,18 @@ void flush_sigqueue(struct sigpending *queue)
 }
 
 /*
- * Flush all pending signals for this kthread.
+ * Flush all pending signals for this kthread. Please note that this interface
+ * shouldn't be and if there is a need for it then it should be clearly
+ * documented why.
+ *
+ * Existing users should be double checked because most of them are likely
+ * obsolete. Kernel threads are not on the receiving end of signal delivery
+ * unless they explicitly request that by allow_signal() and in that case
+ * flush_signals is almost always a bug because signal should be processed
+ * by kernel_dequeue_signal rather than dropping them on the floor. The only
+ * exception when flush_signals could be used is a micro-optimization when
+ * only a single signal is allowed when retreiving the specific signal number
+ * is not needed. Please document this usage.
  */
 void flush_signals(struct task_struct *t)
 {

-- 
Michal Hocko
SUSE Labs
