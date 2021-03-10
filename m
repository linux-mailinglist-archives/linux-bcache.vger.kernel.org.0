Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418F73339FC
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Mar 2021 11:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhCJK3V (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Mar 2021 05:29:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:60318 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231228AbhCJK3M (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Mar 2021 05:29:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B81D1AE42;
        Wed, 10 Mar 2021 10:29:10 +0000 (UTC)
Subject: Re: [PATCH v2] include: Remove pagemap.h from blkdev.h
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org
References: <20210309195747.283796-1-willy@infradead.org>
From:   Coly Li <colyli@suse.de>
Message-ID: <4d6e3281-98e5-e161-3883-00ccc88e1682@suse.de>
Date:   Wed, 10 Mar 2021 18:29:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210309195747.283796-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/10/21 3:57 AM, Matthew Wilcox (Oracle) wrote:
> My UEK-derived config has 1030 files depending on pagemap.h before
> this change.  Afterwards, just 326 files need to be rebuilt when I
> touch pagemap.h.  I think blkdev.h is probably included too widely,
> but untangling that dependency is harder and this solves my problem.
> x86 allmodconfig builds, but there may be implicit include problems
> on other architectures.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
> v2: Fix CONFIG_SWAP=n implicit use of pagemap.h by swap.h.  Increases
>     the number of files from 240, but that's still a big win -- 68%
>     reduction instead of 77%.
> 
>  block/blk-settings.c      | 1 +
>  drivers/block/brd.c       | 1 +
>  drivers/block/loop.c      | 1 +
>  drivers/md/bcache/super.c | 1 +
>  drivers/nvdimm/btt.c      | 1 +
>  drivers/nvdimm/pmem.c     | 1 +
>  drivers/scsi/scsicam.c    | 1 +
>  include/linux/blkdev.h    | 1 -
>  include/linux/swap.h      | 1 +
>  9 files changed, 8 insertions(+), 1 deletion(-)
> 
[snipped]

> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 71691f32959b..f154c89d1326 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -16,6 +16,7 @@
>  #include "features.h"
>  
>  #include <linux/blkdev.h>
> +#include <linux/pagemap.h>
>  #include <linux/debugfs.h>
>  #include <linux/genhd.h>
>  #include <linux/idr.h>[snipped]

For bcache part, Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li
