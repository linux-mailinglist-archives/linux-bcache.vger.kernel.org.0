Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D84164A71
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Feb 2020 17:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgBSQcB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 19 Feb 2020 11:32:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34100 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgBSQcA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Feb 2020 11:32:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UVfIeb+4tVcWdeMMBdsbYkC/EIC/Hs/Sd7Slwqh1/iA=; b=gYhmPc4SHdZ4+l5wtpn6+4s70w
        trenfn4NekiYc9+4QlPCicf3Ru3BstX5PbP3YIO8J/9d9i1zviKpHA/+Uiksm14520mZL+X/3SM0L
        jaS3+A05YvsVQf2HGOXar66glBA+YxMSpqjjZXeD1ISAHeZdEG7mh4vRpDkiuk9jTlmJ63CF3V6bP
        coZtokAFhFYQKsDw1VyOZc4U5OqXJCsyKxse78WcYj0oWO6/QK56EmnnGDPP3k5MmFVovH1x1CN8M
        t7+BB9Y1NMIHS3dKtwvYTh08GjCaT5tvV3GDFFf0XszM80502ERGETiyY74gurZcVK3GIF/mP/drK
        tb2saKBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4SGW-0005aw-1X; Wed, 19 Feb 2020 16:32:00 +0000
Date:   Wed, 19 Feb 2020 08:32:00 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 1/3] bcache: ignore pending signals when creating gc and
 allocator thread
Message-ID: <20200219163200.GA18377@infradead.org>
References: <20200213141207.77219-1-colyli@suse.de>
 <20200213141207.77219-2-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213141207.77219-2-colyli@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Feb 13, 2020 at 10:12:05PM +0800, Coly Li wrote:
> +	/*
> +	 * In case previous btree check operation occupies too many
> +	 * system memory for bcache btree node cache, and the
> +	 * registering process is selected by OOM killer. Here just
> +	 * ignore the SIGKILL sent by OOM killer if there is, to
> +	 * avoid kthread_run() being failed by pending signals. The
> +	 * bcache registering process will exit after the registration
> +	 * done.
> +	 */
> +	if (signal_pending(current))
> +		flush_signals(current);
> +
> +	k = kthread_run(bch_allocator_thread, ca, "bcache_allocator");

This really needs to go into the kthread code itself instead of
requiring cargo culting in the callers.

