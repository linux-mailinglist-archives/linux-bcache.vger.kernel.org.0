Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBEB248EED
	for <lists+linux-bcache@lfdr.de>; Tue, 18 Aug 2020 21:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgHRTpJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 18 Aug 2020 15:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbgHRTpE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Aug 2020 15:45:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659EDC061342;
        Tue, 18 Aug 2020 12:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U4MIf2lCi6IjYxRdtV0kTVnULW1LZNZAc4yIpa1q9jk=; b=N61G1Cp70WD+t0nHtEm0vZgsCC
        prZOoPO5OGHOGZGBgsN1fGLvsUlXnjF9XIjjIxT5xdhI8AZWTKbPGAwQXGRtRsjR7Q43DFMQ419kz
        9e9w5XkAtwoqa/PqkMXo5k0A7RKzPfLBkxKA0AhWR0esmR/pQ4qfrWVPVbuK2lmUj1m6HXXxkA/VN
        vIZAaQIbsrACBQ6LMDUZk+QTaQgL7XDggekmgdO6yD3MNDgXXI8TwgcWYe0ZI/BiAHc6FeM9QaVmN
        +mvs+7YxMFYgxWll3YTZNJ+J2xP1OaSCtjW8xffbyWFEhQfQ1kN5ChdwpYxvRuy04dfBYAEQMZlHc
        mzSMeekQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k87XZ-00012N-9r; Tue, 18 Aug 2020 19:45:01 +0000
Date:   Tue, 18 Aug 2020 20:45:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org, colyli@suse.de, axboe@kernel.dk,
        kernel-team@fb.com, song@kernel.org
Subject: Re: [PATCH 1/4] block: expose disk_map_sector_rcu() and
 hd_struct_put in genhd.h
Message-ID: <20200818194501.GB3271@infradead.org>
References: <20200818070238.1323126-1-songliubraving@fb.com>
 <20200818070238.1323126-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818070238.1323126-2-songliubraving@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Aug 18, 2020 at 12:02:35AM -0700, Song Liu wrote:
> So they can be used in drivers.

Looking at your later patches I'd much rather hide the call to
disk_map_sector_rcu in the actual accounting helper.
