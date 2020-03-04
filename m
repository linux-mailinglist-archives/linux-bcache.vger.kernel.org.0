Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881FE179074
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Mar 2020 13:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387925AbgCDMdt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Mar 2020 07:33:49 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25853 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387776AbgCDMdt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 07:33:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583325228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WjKjsD6JdElv/d5NdWLyMayNDksBD3+ma0hjcd5rcM4=;
        b=ISdmCNN2rU/AHieXgh3RbUUssVacjbtg+lU7tKkbiXhVhoGuYhpZ8Odv5fIwXL0S2kGGAV
        +a9ohHzklQ/ig4BQbZRGEcjCu4XtAxIjtIFRyvTsf0OWMs/GOy2/NK6wrDJSS0JPOfH6mg
        TJkK5m+drJtPp+3fxxOC/KQjEga9NHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-7uQi22bHOr2lj1C4IbilQA-1; Wed, 04 Mar 2020 07:33:46 -0500
X-MC-Unique: 7uQi22bHOr2lj1C4IbilQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31B1A1085946;
        Wed,  4 Mar 2020 12:33:45 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id ABC725C1D6;
        Wed,  4 Mar 2020 12:33:43 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed,  4 Mar 2020 13:33:44 +0100 (CET)
Date:   Wed, 4 Mar 2020 13:33:42 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200304123342.GD13170@redhat.com>
References: <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
 <20200304115718.GI16139@dhcp22.suse.cz>
 <20200304121324.GC13170@redhat.com>
 <20200304122226.GJ16139@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304122226.GJ16139@dhcp22.suse.cz>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 03/04, Michal Hocko wrote:
>
> On Wed 04-03-20 13:13:25, Oleg Nesterov wrote:
> > On 03/04, Michal Hocko wrote:
> > >
> > > So what would be a legit usecase to drop all signals while explicitly
> > > calling allow_signal?
> >
> > Not sure I understand...
>
> flush_signals will simply drop all pending signals on the floor so there
> is no way to handle them, right? I am asking when is still really a
> desirable thing to do when you allow_signal for the kthread. The only
> one I can imagine is that the kthread allows a single signal so it is
> quite clear which signal is flushed.

Yes. This is what I meant when I said "they should do the same if kthread
allows a single signal".

> kernel_dequeue_signal on the other hand will give you a signal and so
> the code can actually handle it in some way.

Yes.

Oleg.

