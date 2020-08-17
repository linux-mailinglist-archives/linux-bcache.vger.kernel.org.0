Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FDA24647F
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 12:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHQK2t (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 06:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgHQK2r (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 06:28:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF64C061389;
        Mon, 17 Aug 2020 03:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B9Qyumuk5I1If5MbPK3wadNxzdW68zPzE7SqDwqX2pU=; b=P0Cf0RpJ++qLOMSHsXXcrhXNG7
        dJl1HS8x/DIxiKy1d9aM+tXlSAC4/vuWcs7vM9Bgm+Qc3BzMGWCxIKiHRAMPSTrtABeDI3fsdHd9B
        b5Vrti+bYjrrCbubMuakwplXY8hxZMeoFL3+12cNMwTwW9KmLfD4ntmYjIT4uhv/wEVpmtPiHOA+o
        kVh+vtcnBqIdNH1wenbqIHbdQ40hYhZklragiIGoIU3/pn0jnwg/BCQmUkavhuA+WWv6ui0LZ/i8k
        IzTHD8WmUp2PsIOyHEA7Y4BaVjv0zl3InIuPwyZMMa4EvThJPyzBNHFv5XlS4Df/OqVLZjYhT4ZlH
        Jpwta2jw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7cNh-0007xB-H5; Mon, 17 Aug 2020 10:28:45 +0000
Date:   Mon, 17 Aug 2020 11:28:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 14/14] bcache: move struct cache_sb out of uapi bcache.h
Message-ID: <20200817102845.GA30136@infradead.org>
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-15-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200815041043.45116-15-colyli@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Aug 15, 2020 at 12:10:43PM +0800, Coly Li wrote:
> struct cache_sb does not exactly map to cache_sb_disk, it is only for
> in-memory super block and dosn't belong to uapi bcache.h.
> 
> This patch moves the struct cache_sb definition and other depending
> macros and inline routines from include/uapi/linux/bcache.h to
> drivers/md/bcache/bcache.h, this is the proper location to have them.

Honestly, nothing in include/uapi/linux/bcache.h is a UAPI.  It seems
to be a random mix of the on-disk format and internals, but certainly
noting that declares a UAPI at all.

Which might not invalidate this patch, but while you touch it you
should probably add a patch that once only the on-disk format is
left the file gets renamed to say drivers/md/bcache/disk_format.h.
