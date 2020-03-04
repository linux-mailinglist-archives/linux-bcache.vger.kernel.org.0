Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094A617912F
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Mar 2020 14:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388040AbgCDNVG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Mar 2020 08:21:06 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41009 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388021AbgCDNVG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 08:21:06 -0500
Received: by mail-wr1-f65.google.com with SMTP id v4so2359670wrs.8;
        Wed, 04 Mar 2020 05:21:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R8T822xJ98Kw7Hg5RKabbLAHQV+PArtMMz8VmWyJqSY=;
        b=X2IoyFnCjiRJ4NgE9WXQL//vGw8LfTVz7miQP8/H9EbgGCu15kSE0AS5RuRSbl46By
         TCK65jMXg7viBn9wrjw5fLXJDcxsO0KSPAZfwU8P0WXhDXe+v+jvmgUboNNG3OBD4SHP
         zwB7OlxmUeYmE749ahuRzGaK7ZLBa6Td1CVs1V/uq+RbkTXMlBtTG0Thoa3McP200DQO
         hbUHlSJ9H5lgOSEpwufaMnkJZ70nVmSdTo5+l4KmopYRcx47qjTv1OqL8ijqOGYZ0JN4
         2+k84I0MxsAb9nEj3Rn2jcLgrY7hjmHnToAD6eWzX+Dv6XP/HK0yvit4Mkge3VbVMJkZ
         mKQw==
X-Gm-Message-State: ANhLgQ2sRCY4xBaWZis+UiLnAO79XcANeaeGLvvq1lK/m7BAYHSJHlUb
        Xikh2HQaOgQEGArWjhV8vfs=
X-Google-Smtp-Source: ADFU+vuJ/lVs8+cRPryKxebs0+B9BnqVe6tyBKRDdPT1CoykZKVtxfQ2obM1bhud8CVu4fprS1Z8mQ==
X-Received: by 2002:adf:eb51:: with SMTP id u17mr4376503wrn.29.1583328063843;
        Wed, 04 Mar 2020 05:21:03 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id a26sm4343491wmm.18.2020.03.04.05.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 05:21:02 -0800 (PST)
Date:   Wed, 4 Mar 2020 14:21:02 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200304132102.GM16139@dhcp22.suse.cz>
References: <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
 <20200304115718.GI16139@dhcp22.suse.cz>
 <20200304121324.GC13170@redhat.com>
 <20200304122226.GJ16139@dhcp22.suse.cz>
 <20200304123342.GD13170@redhat.com>
 <20200304124144.GL16139@dhcp22.suse.cz>
 <20200304130208.GE13170@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304130208.GE13170@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed 04-03-20 14:02:09, Oleg Nesterov wrote:
> On 03/04, Michal Hocko wrote:
> >
> >  /*
> > - * Flush all pending signals for this kthread.
> > + * Flush all pending signals for this kthread. Please note that this interface
> > + * shouldn't be and if there is a need for it then it should be clearly
> > + * documented why.
> > + *
> > + * Existing users should be double checked because most of them are likely
> > + * obsolete. Kernel threads are not on the receiving end of signal delivery
> > + * unless they explicitly request that by allow_signal() and in that case
> > + * flush_signals is almost always a bug
>                     ^^^^^^^^^^^^^^^^^^^^^^
> I still think this is too strong statement...
> 
> Even if it seems that most current users of flush_signals() are wrong.
> 
> > because signal should be processed
> > + * by kernel_dequeue_signal rather than dropping them on the floor.
> 
> Yes, but to remind we need some cleanups to ensure that
> s/flush_signals/kernel_dequeue_signal/ is always "safe" even when only a
> single signal is allowed,
> 
> > The only
> > + * exception when flush_signals could be used is a micro-optimization when
> > + * only a single signal is allowed when retreiving the specific signal number
> > + * is not needed. Please document this usage.
> >   */
> 
> Agreed.

Care to send a patch? I am pretty sure you would provide a more fitting
wording. All I want to achieve is clarification what people should do.
THis is a terrible interface and many bogus users are just proving the
fact so the more specific about expected usage the better.
-- 
Michal Hocko
SUSE Labs
