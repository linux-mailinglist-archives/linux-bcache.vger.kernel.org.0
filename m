Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C8B3337B3
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Mar 2021 09:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhCJIo2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Mar 2021 03:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhCJIn6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Mar 2021 03:43:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DBBC06174A;
        Wed, 10 Mar 2021 00:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vuo0YO0EmNV+mXqkprYzB4nCqf8LGaGX/f4JDhgk+/c=; b=p5AuWvLaCuU/C/3qq+kaSkAvEX
        vKtvFB/7Pp0l8OQ3Hjlgt+Gdlmojl2GcVfJbK4oNDb9uSkjuuv+5a031m7RPru5IcZ4nDfGvAcPLP
        /o4zZS1IoPw8SJiu9OZJ0Faw4XwOc/+hE7aaJPNXsN38Rncqkt3JkXuCv1yFBvP3t3Fnwn8PMRTSb
        fOURb9Y8kLuFYaShP/FZCe6WHdluCvBaxzGooPslnZlVQyZzqVgJTgt6AMwprhJyZWlwvJYkLMIMC
        d2+KDFOGqNEsTMq2HRRaKT0CRvQEdZ3/Z/YXqWFBshlfHqLYe81+af++AJslw0/Tk8BFBQVLYj/+a
        FrK7yhRA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJuR7-002uDa-4t; Wed, 10 Mar 2021 08:43:24 +0000
Date:   Wed, 10 Mar 2021 08:43:21 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] include: Remove pagemap.h from blkdev.h
Message-ID: <20210310084321.GA682482@infradead.org>
References: <20210309195747.283796-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309195747.283796-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Mar 09, 2021 at 07:57:47PM +0000, Matthew Wilcox (Oracle) wrote:
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

Looks good.  I suspect blkdev.h also has penty of other includes that
aren't needed either..

Reviewed-by: Christoph Hellwig <hch@lst.de>

