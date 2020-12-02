Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E8F2CC9B5
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Dec 2020 23:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgLBWgc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 17:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgLBWgb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 17:36:31 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76373C0613D6;
        Wed,  2 Dec 2020 14:35:51 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id x25so388953qkj.3;
        Wed, 02 Dec 2020 14:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fDRCmKzmG6EnsCDvgSnP9O6h60abQiEIqQj5Un1xVQs=;
        b=QTGfcA/KAa1F9u20M9X6dp1tGwTJ9l9iQ/B4uJNQYW4ffy94d2eTrAs+WZtVW5mBwy
         NG/vQbWHcBLBk1Y9Fnfsn5UXGRjaBzMCME72Y3CWeA2k/TMOPd0ke2fhL+tOfi0lIdqv
         jpJAQJ+yOhL8DvusELZ8ozOUQ4OZUDjaR7sFDAUIBLr2EIGBvnLYJTGIhrxhEHuSonll
         3jtLZuq++ZEr3zcGDUFAArIh4qSX5RajDjHpZu/4y6Vr0qwBwKeYw9vmbKWv0+c0ogQ5
         QptM0aJqqEphnjzgRQgy8JYQA21xDcGZw58d6cTygsB3v8XdCOSBjClFfyrDiGsz0Xqo
         qnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=fDRCmKzmG6EnsCDvgSnP9O6h60abQiEIqQj5Un1xVQs=;
        b=ptt54fump8bqBOw9/4npS5wQM/izSrrnJFfNLgy70Pf6Wz68oVed/POKOsZnldwDmv
         GwIdk/0RpsDYXC5KpQQavwdHavVoOqY+E0orYg8bvB9sy6NCVhgdGhOxPZoyqc6WdQdL
         yYZuDgfyN9QQlDd7YpReqjiIT0LHfmt/Dd5oRUb/8MvrrUxwM5Zoy2vUKJRXNaj8yCR9
         5yiXwr0ljpAk/q2NbA08zUTuTYorD8+xjlb/CsHSr20t0Xx5mhQzZ2GJJkl/IzUHNHHE
         hqdW0CFeuVibD/+SjaVXF4XOWzYV7mjFU/rrliv5v1od40Wh5rl97vp1/5Ya2CnrtJ9k
         jj+g==
X-Gm-Message-State: AOAM531bMuBos0WjzcLJfDZh1uWRDrI0MK31dKe1ew2KUSmwFapFaniQ
        p75YlihkmvDb8pm14tK2ZFNs7lXv3d65aA==
X-Google-Smtp-Source: ABdhPJyMGutGFjHzf5aJ0KpE53xmkUwgzzDYFiQltazRaUqs1lE+hnd/Glbacs9CB2txXmoV49DhhA==
X-Received: by 2002:a37:6712:: with SMTP id b18mr5498qkc.340.1606948550514;
        Wed, 02 Dec 2020 14:35:50 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id l79sm59809qke.1.2020.12.02.14.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:35:49 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 17:35:21 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: store a pointer to the block_device in struct bio (again)
Message-ID: <X8gWqZ6li+CvgF4i@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:15PM +0100, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series switches back from storing the gendisk + partno to storing
> a block_device pointer in struct bio.  The reason is two fold:  for one
> the new struct block_device actually is always available, removing the
> need to avoid originally.  Second the merge struct block_device is much
> more useful than the old one, as storing it avoids the need for looking
> up what used to be hd_struct during partition remapping and I/O
> accounting.
> 
> Note that this series depends on the posted but not merged
> "block tracepoint cleanups" series.

I'm late but everything looks good to me. So much better than the mess we
had before. Thank you.

The only thing I noticed is that blkdev_get_no_open() can now use
kobject_get() instead of kobject_get_unless_zero() as bdev lookup is
synchronously disabled before device_del().

-- 
tejun
