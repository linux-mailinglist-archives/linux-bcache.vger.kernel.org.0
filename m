Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88CD22142D
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 20:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgGOSVc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 14:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbgGOSVb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 14:21:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18D0C061755;
        Wed, 15 Jul 2020 11:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QjSMmrT9T2E0YbGnNbA74XDA7KOSZ0YsKlQgmRsxjoo=; b=LCsT5BYwnUVa6qWtm86Jur8nV/
        iLdyDopu9rfw9ZTj2p+0xe2gABlUY5dH7LnXeBiR86Q10/6gNeG6exqqMKqc6/ChBzPKveyxDVu78
        8OJ8aL4j6X429TXFy9n4ZRINpwaEMuPZ1AyJXQ7gK2Be3XTAv4xfCE9ZVokyG8dgQSRGsvBsyVdJX
        grbvH3zuC2YGKJgS5tYg7wiNOWMVOHFnnyYsTum53Oo3eNeUZFdD/gNngaGsBUdR7zgP3Y317knQK
        ZJk+Ezk6jWCQgyNKqNmxx9mTp9+IyTK1zXTfvCJq8apMosvjWOUcjWuQI4pNdjSWruHeebr9UHHtI
        6SHVC8hw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvm25-0005Ej-G9; Wed, 15 Jul 2020 18:21:29 +0000
Date:   Wed, 15 Jul 2020 19:21:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 07/16] bcache: struct cache_sb is only for in-memory
 super block now
Message-ID: <20200715182129.GA20035@infradead.org>
References: <20200715143015.14957-1-colyli@suse.de>
 <20200715143015.14957-8-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715143015.14957-8-colyli@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jul 15, 2020 at 10:30:06PM +0800, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> We have struct cache_sb_disk for on-disk super block already, it is
> unnecessary to keep the in-memory super block format exactly mapping
> to the on-disk struct layout.
> 
> This patch adds code comments to notice that struct cache_sb is not
> exactly mapping to cache_sb_disk, and removes the useless member csum
> and pad[5].
> 
> Although struct cache_sb does not belong to uapi, but there are still
> some on-disk format related macros reference it and it is unncessary to
> get rid of such dependency now. So struct cache_sb will continue to stay
> in include/uapi/linux/bache.h for now.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

If you change this it really needs to move out of the uapi header.
