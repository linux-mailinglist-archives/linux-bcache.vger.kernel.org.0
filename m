Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADA72CCA46
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 00:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgLBXHZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 18:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLBXHZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 18:07:25 -0500
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AC2C0613D6;
        Wed,  2 Dec 2020 15:06:44 -0800 (PST)
Received: by mail-qv1-xf42.google.com with SMTP id n9so84924qvp.5;
        Wed, 02 Dec 2020 15:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JiLXK8qvyvyeu2ukVHQ2JpMMFoxaPcaESyT/VbSthbA=;
        b=qrrfvsdXI/s8F2fYq1LFmdSRsJ7FBoQhzucwy0LJyxbIgLb4vKO6H3apXfDgSNkeZj
         jnTRKRiROtjTD1h4Yufdq0mWGH6L0HOVdiVyeFo9Vrvmp/t2Upw0djaS2DRqWSp6Mgw3
         UH3Vxsmabxd/KSX+bsYJgBWLtd7PSCFle2X5tVXttGPY7AYBUYV5SMgm3TQOXL3JpyWO
         xjr5DHaVo5oGJQswyGhLsXcuoPiOjLE9b9C2iC1RTO4swQmL8METGBaCo76IqAi7PQu+
         Wp2eyzh5X4m51dR6JDZl+xKZMBs7Co50W9sD2aBCLEqYfLAqZRMifVsn3D33S0yJGmnf
         2g9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=JiLXK8qvyvyeu2ukVHQ2JpMMFoxaPcaESyT/VbSthbA=;
        b=mCzXNDc+GhnbwcVjvlvVNH/Jph0/9d5Z9RxJUL+MIOJqB3ZyTimg7h1+GRXE5rMOcm
         jJlCz4Mb0EPsTxbtlvboWMS9m2v/e/3LI1yTZyTZgBNnLJDcuuvSsqTlfLrFjLkbhbJ9
         didIK8/sE2uxlDw5Gpp4fCgnw80PVVAP8uJAt2l7Ox5xQZhM/YN9DHueM1zkVGydsVLd
         WI9WsDus9vCfIE/5mWEE+LMtP1BAGt+YshU9VV006rEQ7zV7qf1zTZ3NU+3AR+SkIdj2
         7zZxxtWjp18GsN5TcYKCmTLGFDjQkZoDCFBpcxJsYCeWf347BPiIA4FvnlwMU3CmK8ND
         jEQg==
X-Gm-Message-State: AOAM531N6uU93nZfaiuTqsR3kFEjWtmh/UrqlYuVK7wlZcxsxagXeBY+
        LIPj2qISuCriW+ZlKN/LYlI=
X-Google-Smtp-Source: ABdhPJwZn5dxPl6m3pa1aEv5h1pGuTSJHgrMy6TrZ3GcAHDdgW4RCyry1okmV8UoY42HeFjIxVXUcw==
X-Received: by 2002:a05:6214:20a1:: with SMTP id 1mr449637qvd.61.1606950404181;
        Wed, 02 Dec 2020 15:06:44 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id 97sm427113qte.34.2020.12.02.15.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 15:06:43 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 18:06:14 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 6/9] blk-mq: use ->bi_bdev for I/O accounting
Message-ID: <X8gd5vMizq+3d5cp@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-7-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:21PM +0100, Christoph Hellwig wrote:
> Remove the reverse map from a sector to a partition for I/O accounting by
> simply using ->bi_bdev.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
