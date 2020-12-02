Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D652CCA11
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Dec 2020 23:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387820AbgLBWzb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 17:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387806AbgLBWza (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 17:55:30 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824CCC061A04;
        Wed,  2 Dec 2020 14:55:15 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id q5so374531qkc.12;
        Wed, 02 Dec 2020 14:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VtlFvmaklvcZDGrLlSAgQhu+0H7bK0zCUEpwXYO6ZPg=;
        b=D14l/wshUGZCLD3wWiZIT1JCNTY3aTqIyxCfKL/K3/xKFQ9erOkl9v3qtrxneBa5Aj
         RD5YmRyHnCGWKeVe7R66GWndaA83nwR69amIWlSzzwPMtpY/CG0RHaMQPQibbjf3+aRl
         P9ZexYmwx3SuVFl1qgnYiib52TykSz0S/OggqcAzcYEXv0EW5kwUZcOsoyhoevDv+EKA
         qFNTlmOu4GOHodHSx/GJhj7eX8CEc6H4AK0F04VVwF8pUVk8HVvXbydSSCVBPu6qGyEb
         JMDPne/YXTYckXWutVnMWbeU4ypJDfG38/syck4HZkHvvn005LL5LwGlf9hkP3qmNpNo
         2i7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=VtlFvmaklvcZDGrLlSAgQhu+0H7bK0zCUEpwXYO6ZPg=;
        b=DMh/GVxaSBa6XieWsW1nXsJGTPuIA6HpRITQZ4YUb7uYZnOTB2lugKTOfFB42BqFt0
         DODoqkZts1h9nlFl7dzH4oPuCoLj/3rRL00OgHNtOcliaWwkKydD7gQ6QyPQcfqVuf0k
         rLbTtV2EJ/eGBGstwgc05ce0ct2honwY9KgO07wXLt1xsCyoKGxPI1MhgchjT1aV662M
         SCwETbdcCqL/NuWT0gc7P22Y3lae/FeWkH9zCWaR4aWzeY0pqIoy/6cZjOdXY3Arzu/h
         u1Dkg7oVqBl7lBUoougVX09NsbZEXhciCwbKRqyIO7w0/ICv/Smbba/xSmTWl9wXpHLC
         VfNA==
X-Gm-Message-State: AOAM5336Gzakzv1yVQ+EAcY51Zb5fUYRB3WxwuAwkdkIjCGPzn5jnsMw
        a7aa2surTnp/flQQCR9iAsU=
X-Google-Smtp-Source: ABdhPJzxbVxALs+v4IXK2QlV8LBTGqeZrxGS7JYABGudWsaxBMX2uEOJyie3dRa7pXdUAfhwcyfqDw==
X-Received: by 2002:a37:8c06:: with SMTP id o6mr63663qkd.382.1606949714715;
        Wed, 02 Dec 2020 14:55:14 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id r14sm452404qte.27.2020.12.02.14.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:55:13 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 17:54:45 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 3/9] block: store a block_device pointer in struct bio
Message-ID: <X8gbNeczmbhF8ZEW@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:18PM +0100, Christoph Hellwig wrote:
> Replace the gendisk pointer in struct bio with a pointer to the newly
> improved struct block device.  From that the gendisk can be trivially
> accessed with an extra indirection, but it also allows to directly
> look up all information related to partition remapping.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
