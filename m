Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064302573F8
	for <lists+linux-bcache@lfdr.de>; Mon, 31 Aug 2020 08:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgHaGyK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 31 Aug 2020 02:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgHaGyJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 31 Aug 2020 02:54:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2C6C061573;
        Sun, 30 Aug 2020 23:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RGnMIEf8I/JCxwIKhPuddrWvVvesL7VayiD1BisVbH4=; b=fKCLTR13zslY0KzRXEFg8ZYe6l
        qw32gWzUw5Aw36YJzn3/ESSj+VghH0qhD2yHLRqNgZsTWe/C9ZSeeSCDrcAgx//TEgN2wa5j65CGS
        HGswSJosP3sahOOw1LVVUNONmQa4ZM4enl1W03Y+gCW2Ewvww6mfv3+TgnoO6bXivzvOngZwvg+Wf
        XQPcUf4WTsuaYljO1R0IGILl3k6De6iw/VaHaOok8xFfK9EkbKp5YsloWXNHOv9yw1Tung3h65De2
        VPRqkMoBpaKCRj7qXWNHWQBs16UD27cUfzgMcYU7bw8OoMgypOz9oluxWQBizB/Q2S11Cc+LBjHMN
        APVEyFBw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCdhf-0000ie-AE; Mon, 31 Aug 2020 06:54:07 +0000
Date:   Mon, 31 Aug 2020 07:54:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org, colyli@suse.de, axboe@kernel.dk,
        kernel-team@fb.com, song@kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 2/3] md: use part_[begin|end]_io_acct instead of
 disk_[begin|end]_io_acct
Message-ID: <20200831065407.GB2507@infradead.org>
References: <20200818222645.952219-1-songliubraving@fb.com>
 <20200818222645.952219-3-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818222645.952219-3-songliubraving@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Aug 18, 2020 at 03:26:44PM -0700, Song Liu wrote:
> This enables proper statistics in /proc/diskstats for md partitions.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
