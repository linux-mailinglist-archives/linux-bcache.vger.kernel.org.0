Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224D21790C2
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Mar 2020 14:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388029AbgCDNCR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Mar 2020 08:02:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388022AbgCDNCR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 08:02:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583326936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OdHSi0QPp60vZX5FbBZBBTDVaZmSwSltSaVNHKPUqJM=;
        b=ZtBStZbMb52gQGX8XCFl1720wBZEeYvkwhAUhB6YE2gaKP3NJUPUYGYhabPfSn4g6d5KZK
        8xyKZh3anQxWWCZDgKuhCidQxwL9KtNzJhbvlccAU6bOKDiIhvlmnZn7ho7cWesLImMZ5y
        kzbthG6lJbFGej4y6F/V2t7wYhkm+9U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-5fkdTn6iOtOcwobYUI5a_w-1; Wed, 04 Mar 2020 08:02:13 -0500
X-MC-Unique: 5fkdTn6iOtOcwobYUI5a_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5FD11B18BC7;
        Wed,  4 Mar 2020 13:02:11 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id 29BC648;
        Wed,  4 Mar 2020 13:02:10 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed,  4 Mar 2020 14:02:11 +0100 (CET)
Date:   Wed, 4 Mar 2020 14:02:09 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200304130208.GE13170@redhat.com>
References: <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
 <20200304115718.GI16139@dhcp22.suse.cz>
 <20200304121324.GC13170@redhat.com>
 <20200304122226.GJ16139@dhcp22.suse.cz>
 <20200304123342.GD13170@redhat.com>
 <20200304124144.GL16139@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304124144.GL16139@dhcp22.suse.cz>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 03/04, Michal Hocko wrote:
>
>  /*
> - * Flush all pending signals for this kthread.
> + * Flush all pending signals for this kthread. Please note that this interface
> + * shouldn't be and if there is a need for it then it should be clearly
> + * documented why.
> + *
> + * Existing users should be double checked because most of them are likely
> + * obsolete. Kernel threads are not on the receiving end of signal delivery
> + * unless they explicitly request that by allow_signal() and in that case
> + * flush_signals is almost always a bug
                    ^^^^^^^^^^^^^^^^^^^^^^
I still think this is too strong statement...

Even if it seems that most current users of flush_signals() are wrong.

> because signal should be processed
> + * by kernel_dequeue_signal rather than dropping them on the floor.

Yes, but to remind we need some cleanups to ensure that
s/flush_signals/kernel_dequeue_signal/ is always "safe" even when only a
single signal is allowed,

> The only
> + * exception when flush_signals could be used is a micro-optimization when
> + * only a single signal is allowed when retreiving the specific signal number
> + * is not needed. Please document this usage.
>   */

Agreed.

Oleg.

