Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DADA166341
	for <lists+linux-bcache@lfdr.de>; Thu, 20 Feb 2020 17:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgBTQiF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 20 Feb 2020 11:38:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbgBTQiF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 20 Feb 2020 11:38:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rCFYdxif4Wq/3VywZBr2KtSL6aDnXbslwaVf67t0EhM=; b=tiau9kNEIEwonwJNmsx5AgCmn5
        ioSS2Q8TImxUikKX/De/O6SLO5hKbbnNXVytrBwTIquBF3T1SwzC6ujJyApVsdtIW7yGeq6QlclLQ
        zdwtQgmeLfEoxwBrWuKPSY/+KgQFjqruF3kmvE3yG4PDnae0X3h80k9qgnM1fVQIu21zFvVTvlUTU
        SAhHqOeqOPOqcyYd2uUIQTuvfM0chEvGzxmGXViMcoGsWtd9vS5KnU6PCP6JYuCMdjOJ5EONCJBCR
        pWkjRCsTGm0SQzLDYCRyzbyylqnRJq0khNS2wKW8y/YXBzjSI2wXZjW7wrJD7VQDr/rn12XMAs6uN
        f4y+B5dQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4opv-0005fq-9G; Thu, 20 Feb 2020 16:38:03 +0000
Date:   Thu, 20 Feb 2020 08:38:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 1/3] bcache: ignore pending signals when creating gc and
 allocator thread
Message-ID: <20200220163803.GA12147@infradead.org>
References: <20200213141207.77219-1-colyli@suse.de>
 <20200213141207.77219-2-colyli@suse.de>
 <20200219163200.GA18377@infradead.org>
 <1f6cd622-3476-068b-3593-f918ab011156@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f6cd622-3476-068b-3593-f918ab011156@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Feb 20, 2020 at 09:20:49PM +0800, Coly Li wrote:
> Therefore I need to explicitly call pending_signal() before calling
> kthread_run().

Right now you have to.  But the proper fix is to not require this and
fix kthread_run to work from a thread that has been selected by the OOM
killer.  In the most trivial version by moving your code into
kthread_run, but there probably are better ways as well.
