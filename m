Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2E12CC9E0
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Dec 2020 23:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgLBWq7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 17:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLBWq7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 17:46:59 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B4FC0613D6;
        Wed,  2 Dec 2020 14:46:19 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id q137so30255iod.9;
        Wed, 02 Dec 2020 14:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HShAgJCUcps4N1A+2IklR049T/RPogDj41ruzx2BBDo=;
        b=RdBEJfJEaDCigr/rMLVq+8cy888LMCaKBIVSTunG9ji57bTX0HIoEo8hRE9LLPfscf
         EM7cBweMOm/pgGviIwEMlXBC/3Op2f/NT5F3D0Rg/ZidxhHORRrLsEWr48hbAgx9pxjp
         BlKNF5cdSns0aooDvIiWtNfXEN96NcBbbojtsgOjFNHfWk0Uw9CYHyOB/2mFUBGPL/fH
         XTJX5dIkQoyt+51+jwbZfp+R+901vo5Ewb7aU9MOQy000tvqshA5ToKnCb52LbYZmv1A
         +X8Orp5Gz//3XW1IQDgEaPTh4UyYuFI+mqTnHWrE6e7jHC3Wjv7Lw3JONa1ZUwWudMmN
         rJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HShAgJCUcps4N1A+2IklR049T/RPogDj41ruzx2BBDo=;
        b=NAT2aNroTm+dvzX4h/WH0tUzcdPaYjv2OEv3vglItqpkkdbufDZMPqMLfGqCovBl+i
         w3nQxmXBjYtxf/HFdUpgIgfmS6/UtqE6P0pU9LxG7eVtki2aCslvyQ12QgMsl2EVpIjm
         jTkiH/oWcrYddcCqIFxBqBdyYx/V3CSw/Nzx2Zrz6fYI3l9458Np0CYo7QfdESkF/KqM
         2NdoXv/rahjW0QbqdxyQO314tqzyjkRSHgIGzGMKpqDqO2Pc8E46jhds9Rl9mh/Hx70E
         QwgvLwa6bSRUZcHF88rAqcINQMAlZNatA0yI9eTa3H4CWjT54pbb9bArJd2yr0Vs5PE/
         N/eQ==
X-Gm-Message-State: AOAM533VCltEqSXSPqEi4bJf9jDMxR+iOS2mLFm3UUZtH0pPeKooG6ch
        mlJycTTPg4qJcN7f3PcZyda7Gp2kPqwgrw==
X-Google-Smtp-Source: ABdhPJzLQDjBM2feXi0iRxAJyEtngQDMNkvdJGyaFvpaYJZxsZ3XDEBbF+Aj812h7lkT9BmeOE3RFw==
X-Received: by 2002:ac8:6bc6:: with SMTP id b6mr390050qtt.127.1606948651820;
        Wed, 02 Dec 2020 14:37:31 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id z20sm352334qtb.31.2020.12.02.14.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:37:31 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 17:37:03 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: store a pointer to the block_device in struct bio (again)
Message-ID: <X8gXDx0DU+sqJoPc@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <X8gWqZ6li+CvgF4i@mtj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8gWqZ6li+CvgF4i@mtj.duckdns.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Dec 02, 2020 at 05:35:21PM -0500, Tejun Heo wrote:
> On Tue, Dec 01, 2020 at 05:54:15PM +0100, Christoph Hellwig wrote:
> > Hi Jens,
> > 
> > this series switches back from storing the gendisk + partno to storing
> > a block_device pointer in struct bio.  The reason is two fold:  for one
> > the new struct block_device actually is always available, removing the
> > need to avoid originally.  Second the merge struct block_device is much
> > more useful than the old one, as storing it avoids the need for looking
> > up what used to be hd_struct during partition remapping and I/O
> > accounting.
> > 
> > Note that this series depends on the posted but not merged
> > "block tracepoint cleanups" series.
> 
> I'm late but everything looks good to me. So much better than the mess we
> had before. Thank you.
> 
> The only thing I noticed is that blkdev_get_no_open() can now use
> kobject_get() instead of kobject_get_unless_zero() as bdev lookup is
> synchronously disabled before device_del().

Oops, sorry, this was supposed to be a reply to the earlier hd_struct
removal patchset. Reviewing this patchset now.

Thanks.

-- 
tejun
