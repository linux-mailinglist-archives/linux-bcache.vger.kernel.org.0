Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11366178FA1
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Mar 2020 12:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgCDLgW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Mar 2020 06:36:22 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42428 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729261AbgCDLgW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 06:36:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583321781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AgdVEd1uxkYkvaVshY1wColNeZbgIueeDtuyNxX73SA=;
        b=hxs7kAVR4d8sXmtrgyL8Z9+MIHcz245cPU21ctaRJ4jvAhpZSs1i/e9qXqPDfE/ys68sS8
        +ScxiDUtiCcdQ1L/sna14OHGGjqfJn+KCTlxaCeP6ZpzLEq/3LXL9cCjUVnfzMIyX6lUR3
        HLN0qVej/eHniuchAocdOWn3mj1Rc6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-LDYPEbQ4MjyALBAZvG1nAg-1; Wed, 04 Mar 2020 06:36:17 -0500
X-MC-Unique: LDYPEbQ4MjyALBAZvG1nAg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB754800D48;
        Wed,  4 Mar 2020 11:36:15 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id 53C0F8F341;
        Wed,  4 Mar 2020 11:36:14 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed,  4 Mar 2020 12:36:15 +0100 (CET)
Date:   Wed, 4 Mar 2020 12:36:13 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200304113613.GA13170@redhat.com>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303160307.GI4380@dhcp22.suse.cz>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 03/03, Michal Hocko wrote:
>
> On Tue 03-03-20 13:19:18, Oleg Nesterov wrote:
> [...]
> > but I am not sure this optmization makes sense.
>
> I would much rather start with a clarification on what should be use
> what shouldn't. Because as of now, people tend to copy patterns which
> are broken or simply do not make any sense at all.

Yes, it has a lot of buggy users.

It should only be used by kthtreads which do allow_signal(), and imo
even in this case kernel_dequeue_signal() makes more sense.

I am looking at 2 first users reported by git-grep.

arch/arm/common/bL_switcher.c:bL_switcher_thread(). Why does it do
flush_signals() ? signal_pending() must not be possible. It seems that
people think that wait_event_interruptible() or even schedule() in
TASK_INTERRUPTIBLE state can lead to a pending signal but this is not
true. Of course, I could miss allow_signal() in bL_switch_to() paths...

drivers/block/drbd/. I know nothing about this code, but it seems that
flush_signals() can be called by the userspace process. This should be
forbidden.

IOW, I mostly agree with

	- * Flush all pending signals for this kthread.
	+ * Flush all pending signals for this kthread. Please note that this interface
	+ * shouldn't be used and in fact it is DEPRECATED.
	+ * Existing users should be double checked because most of them are likely
	+ * obsolete. Kernel threads are not on the receiving end of signal delivery
	+ * unless they explicitly request that by allow_signal() and in that case
	+ * flush_signals is almost always a bug because signal should be processed
	+ * by kernel_dequeue_signal rather than dropping them on the floor.

you wrote in your previous email, but "DEPRECATED" and "almost always a bug"
looks a bit too strong to me.

I would like to add WARN_ON(!PF_KTHREAD) into flush_signals() and let people
fix their code ;)

Oleg.

