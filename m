Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD2E2573F9
	for <lists+linux-bcache@lfdr.de>; Mon, 31 Aug 2020 08:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgHaGyY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 31 Aug 2020 02:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHaGyX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 31 Aug 2020 02:54:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E776BC061573;
        Sun, 30 Aug 2020 23:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fnYw0s99bg0mVLtxQRh88DSyw6pWgfhApeUfasNFVdc=; b=pVywHqWveSQ7l957VyirSpMXSc
        kjBBpiu/4qs/C4vh5XP9JL1KKkHB6ALNwEe8pZdH7CI9yw/UbKyIP61uR6IOGrE40rzp6qMgwFRJc
        p6CZlVNOpkfW2dDSikT1p9NNMuiKrxp0JK8HP+fxmKWbYRgg6BHX/tsiTAScYY5MpnBzBLkhXyqNb
        QXmXXpiBKhHu0Ok/mQzK1bpQNiz4el9loDCxPwGPr/hgpd/a4g9g1U2hGOo//oINPhgGgVvqBUgH2
        xBmeemiu4Og+klrIf6oP8Z3NkU3UR905Iv8gMsvAjM6s1QuEO5IbnLR8pRcTdxT6HKp7vhqsvPNjL
        nmB+dfLA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCdhs-0000je-MB; Mon, 31 Aug 2020 06:54:20 +0000
Date:   Mon, 31 Aug 2020 07:54:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org, colyli@suse.de, axboe@kernel.dk,
        kernel-team@fb.com, song@kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 3/3] bcache: use part_[begin|end]_io_acct instead of
 disk_[begin|end]_io_acct
Message-ID: <20200831065420.GC2507@infradead.org>
References: <20200818222645.952219-1-songliubraving@fb.com>
 <20200818222645.952219-4-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818222645.952219-4-songliubraving@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Aug 18, 2020 at 03:26:45PM -0700, Song Liu wrote:
> This enables proper statistics in /proc/diskstats for bcache partitions.
> 
> Reviewed-by: Coly Li <colyli@suse.de>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
