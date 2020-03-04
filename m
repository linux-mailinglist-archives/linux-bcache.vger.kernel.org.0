Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A6B178FE0
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Mar 2020 12:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387774AbgCDLxk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Mar 2020 06:53:40 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53592 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729232AbgCDLxk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 06:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583322818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HstzWJH2ykQEB6rO0ZO7L/hKDYAiyneDC/XNN0VOzv8=;
        b=BWr6K8pUar6zktW1wHW2aa2LbTbWsuCrMU86kT7CYVOuYLnWdcjtv1U3WaUgnaejC2Hn5J
        z+8WhjqwAA7jQKFHfCw/q6SlyVQzv37Em0nsvTKrzKl4EylD5OX5mDbLgbQ4uxeLH3NPDe
        4oiSF9fO9sxS731uVvBcfwMg8M1pptg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-WhXVMfP_PsGrZ7baor5lEw-1; Wed, 04 Mar 2020 06:53:34 -0500
X-MC-Unique: WhXVMfP_PsGrZ7baor5lEw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 977FF107ACCA;
        Wed,  4 Mar 2020 11:53:33 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2086391D8E;
        Wed,  4 Mar 2020 11:53:31 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed,  4 Mar 2020 12:53:33 +0100 (CET)
Date:   Wed, 4 Mar 2020 12:53:31 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200304115330.GB13170@redhat.com>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304113613.GA13170@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 03/04, Oleg Nesterov wrote:
>
> arch/arm/common/bL_switcher.c:bL_switcher_thread(). Why does it do
> flush_signals() ? signal_pending() must not be possible. It seems that
> people think that wait_event_interruptible() or even schedule() in
> TASK_INTERRUPTIBLE state can lead to a pending signal but this is not
> true. Of course, I could miss allow_signal() in bL_switch_to() paths...

Jens, could you explain flush_signals() in io_sq_thread() ?

Oleg.

