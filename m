Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 131B9EE71F
	for <lists+linux-bcache@lfdr.de>; Mon,  4 Nov 2019 19:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfKDSPn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 13:15:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58690 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfKDSPn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 13:15:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0aZoUG652S8l7oLtZfEK/pK2NX3gCKPyV+s+Vd4xFS8=; b=W90DKiOEJShPtki8BPzqjApGz
        tMX5blT1i9m4IPigbIZ0k/3Sm/FquH+7Vp8m8SN1wv4EJREbygwydwn/t9piR/FQ1+mUF+Dxn+dG1
        1E429FzSWYA8VThVaMTSCCgqoKSw01gHIQm0x/t8fxV2XaR89rwfx3NHLOpdCp3EY9DM/yfrwQVrH
        JmZAtAMADYejMSrx2ZmINEFJmHGVRhQwoYJZBy+UTj4cqk/ryBoiMWi+bdOYfKyBKClRK5OUMkiUU
        d89TgUABC0UHAbtdVsZU4ADXmhkvAPk5ga15fQaMCYvvg+aGTyL8LAi1oNIJAAL9DupOHyOweXPvZ
        Ij+S9u+GQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRgtB-0002Pg-1n; Mon, 04 Nov 2019 18:15:41 +0000
Date:   Mon, 4 Nov 2019 10:15:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH V4] block: optimize for small block size IO
Message-ID: <20191104181541.GA21116@infradead.org>
References: <20191102072911.24817-1-ming.lei@redhat.com>
 <20191104181403.GA8984@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104181403.GA8984@kmo-pixel>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Nov 04, 2019 at 01:14:03PM -0500, Kent Overstreet wrote:
> On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
> > __blk_queue_split() may be a bit heavy for small block size(such as
> > 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
> > multiple page. And only consider to try splitting this bio in case
> > that the multiple page flag is set.
> 
> So, back in the day I had an alternative approach in mind: get rid of
> blk_queue_split entirely, by pushing splitting down to the request layer - when
> we map the bio/request to sgl, just have it map as much as will fit in the sgl
> and if it doesn't entirely fit bump bi_remaining and leave it on the request
> queue.
> 
> This would mean there'd be no need for counting segments at all, and would cut a
> fair amount of code out of the io path.

I thought about that to, but it will take a lot more effort.  Mostly
because md/dm heavily rely on splitting as well.  I still think it is
worthwhile, it will just take a significant amount of time and we
should have the quick improvement now.
