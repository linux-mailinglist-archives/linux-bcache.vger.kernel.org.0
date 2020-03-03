Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD6B1775D0
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Mar 2020 13:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgCCMT0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Mar 2020 07:19:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21039 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728348AbgCCMTZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Mar 2020 07:19:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583237964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x0gYh1Gq3IgWpR8EgGIFaXzLMc5OTSdWEEAIyNjE2pw=;
        b=BU5ogcxeSolxSHCzvQ+Onr5NeUvJbl3EquoB/cs9sZhzv/0KMNniC/9RgTld3GTnivOfud
        Z4wuy77uPLsLAwHPML1zLs+qN/TM/FfhgkflaEEjs3pHaDagIdIBpnc9LWyT5CeG19PI2v
        Eq57cM7lXXrSMTbr24PdXvF6oUwL6xE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-iZY3IBUQNNuj3HWzRyzJqA-1; Tue, 03 Mar 2020 07:19:22 -0500
X-MC-Unique: iZY3IBUQNNuj3HWzRyzJqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3502C100550E;
        Tue,  3 Mar 2020 12:19:21 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9072E5C1D6;
        Tue,  3 Mar 2020 12:19:19 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue,  3 Mar 2020 13:19:20 +0100 (CET)
Date:   Tue, 3 Mar 2020 13:19:18 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200303121918.GA27520@redhat.com>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303080544.GW4380@dhcp22.suse.cz>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 03/03, Michal Hocko wrote:
>
> > > What is the actual valid usage of this function?
> >
> > I thinks it should die...
>
> Can we simply deprecate it and add a big fat comment explaning why this
> is wrong interface to use?

Michal, I am sorry for confusion.

I have to take my words back, flush_signals() can be more convenient
and faster for kthreads than kernel_deque_signal().

However I still think it needs changes, see below.

Even clear_tsk_thread_flag(SIGPENDING) doesn't look right in general,
but recalc_sigpending() can make a difference. This probably needs
more cleanups.

> + * Kernel threads are not on the receiving end of signal delivery
> + * unless they explicitly request that by allow_signal() and in that case
> + * flush_signals is almost always a bug because signal should be processed
> + * by kernel_dequeue_signal rather than dropping them on the floor.

Yes, but kernel_dequeue_signal() differs. Say, it won't clear TIF_SIGPENDING
if TIF_PATCH_PENDING is set. Again, probably this need more cleanups.

Anyway, we can probably change flush_signals

	void flush_signals(struct task_struct *t)
	{
		unsigned long flags;

		// see the PF_KTHREAD check in __send_signal()
		WARN_ON_ONCE(!list_empty(&t->pending.list) ||
			     !list_empty(&t->signal->shared_pending.list));

		spin_lock_irqsave(&t->sighand->siglock, flags);
		// TODO: use recalc_sigpending()
		clear_tsk_thread_flag(t, TIF_SIGPENDING);
		sigemptyset(&t->pending.signal);
		sigemptyset(&t->signal->shared_pending.signal);
		spin_unlock_irqrestore(&t->sighand->siglock, flags);
	}

kernel_sigaction() doesn't need flush_sigqueue_mask() too.

kernel_dequeue_signal() could just use next_signal(),

	int kernel_dequeue_signal(void)
	{
		struct task_struct *task = current;
		int ret;

		spin_lock_irq(&task->sighand->siglock);
		ret = next_signal(&task->pending, blocked);
		if (!ret)
			ret = next_signal(&task->signal->shared_pending, blocked);
		if (sig_kernel_stop(ret))
			task->jobctl |= JOBCTL_STOP_DEQUEUED;
		recalc_sigpending();
		spin_unlock_irq(&task->sighand->siglock);

		return ret;
	}

but I am not sure this optmization makes sense.

Oleg.

