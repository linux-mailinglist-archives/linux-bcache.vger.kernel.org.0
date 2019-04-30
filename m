Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CC2FC92
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Apr 2019 17:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfD3PP4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Apr 2019 11:15:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54310 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfD3PP4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Apr 2019 11:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sJGdayPWuG1HzcLl6bVyV4BdL/vEwz56KhF67M/GSSA=; b=B0pCeZNCVw9RqMgRSxr0/MICI
        DXgVWf/QVhA+FRivsZ66NUEE2VIC4+LY0vZ+gSDrqSYCJvDFRWZ5nUV1bjG31vcReOhKH/QMZXoNA
        DE+4m7BW1UsJBxDzL3Jj8Vage0Mf8GCbXKSbcRh+9q9XSxNzu+XwyB9TMzpXiH4jTCbWzpBgn1H91
        bQmRpNMO52j+rpeMzHuYz3fY5RXvbUga3oiGF/DBxsnFc9CMIDiorFSMiLn3sscZO6can2H8gK5IW
        95yWHexXGSmWToqkz1bcptE21629NRL+rHC8I+TfK23Op40TzDeEsKLzUfNUJdc+errM2VhppLc52
        F4PGtZI6w==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLUU7-0000rk-At; Tue, 30 Apr 2019 15:15:55 +0000
Date:   Tue, 30 Apr 2019 08:15:55 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: simplify bio_for_each_segment_all
Message-ID: <20190430151555.GG13796@bombadil.infradead.org>
References: <20190425070300.3388-1-hch@lst.de>
 <20190430150658.GA25407@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430150658.GA25407@lst.de>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Apr 30, 2019 at 05:06:58PM +0200, Christoph Hellwig wrote:
> ping?
> 
> On Thu, Apr 25, 2019 at 09:02:58AM +0200, Christoph Hellwig wrote:
> > Hi Jens,
> > 
> > this series simplifies bio_for_each_segment_all a bit, as suggested
> > by willy.
> ---end quoted text---

If Reviewed-by dominates Suggested-by, then

Reviewed-by: Matthew Wilcox <willy@infradead.org>
