Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9A8230A73
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Jul 2020 14:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbgG1Ml7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Jul 2020 08:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgG1Ml7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Jul 2020 08:41:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96D7C061794;
        Tue, 28 Jul 2020 05:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EHHSwX8KP1sCoYb62iEmD4SsGqOWTIYeWpBxFyufhzA=; b=jw8t6nleAUS0nb7EU9bqm6w5Mz
        3ytPdUqCyusYxnY/Dg5ao6fV5FjoEzxgdr+Y5739a5z5zkKwGVftvS9dxi/PikzqRd+cCpYevT25+
        /ASWBAcIeTw+x/LG9xVU02o7efUcXLLBkI8i96iKtTVZWTjvo2pR9fNO2Qq5xOHnOHmkgnnz0cBAP
        VW2pEGXrE7W57fvF5jGlHmdPWTRxPorqOPCFXXmOOhfozRIu1FBrK0aH0+JUth+XLS/CNf7DD/oo1
        7C6JfumKGZZ6GKWFbTV0DH7Q6nMOcRucKcUyHAmkUIDh+NiqOPFXKEmuobWJEJuXH6ME5NL8seKiQ
        uwMs+2Qg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0Ovc-0002mk-NC; Tue, 28 Jul 2020 12:41:56 +0000
Date:   Tue, 28 Jul 2020 13:41:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH 00/25] bcache patches for Linux v5.9
Message-ID: <20200728124156.GA10627@infradead.org>
References: <20200725120039.91071-1-colyli@suse.de>
 <bbc97069-6d8f-d8c5-35b1-d85ccb2566df@kernel.dk>
 <20200728121407.GA4403@infradead.org>
 <bcad941d-1505-5934-c0af-2530f8609591@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcad941d-1505-5934-c0af-2530f8609591@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Jul 28, 2020 at 08:40:16PM +0800, Coly Li wrote:
> On 2020/7/28 20:14, Christoph Hellwig wrote:
> > On Sat, Jul 25, 2020 at 07:39:00AM -0600, Jens Axboe wrote:
> >>> Please take them for your Linux v5.9 block drivers branch.
> >>
> >> Thanks, applied.
> > 
> > Can you please revert "cache: fix bio_{start,end}_io_acct with proper
> > device" again?  It really is a gross hack making things worse rather
> > than better.
> > 
> 
> Hi Christoph and Jens,
> 
> My plan was to submit another fix to current fix. If you plan to revert
> the original fix, it is OK to me, just generate the patch on different
> code base.

Let's get the fixup out ASAP then..
