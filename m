Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413D9533659
	for <lists+linux-bcache@lfdr.de>; Wed, 25 May 2022 07:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiEYFUZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 25 May 2022 01:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbiEYFUY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 May 2022 01:20:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85471DA64;
        Tue, 24 May 2022 22:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=YbBZJecasFJChD0Qx766ygv34+7CE3nsA11f44Yl+UI=; b=OPYvc+r5yRmAXpLvPMiOYs/E8G
        mcFb7ZPfMh5tPcXBZXIy2Tw//q2WNL/BnmHUJeRnqvYIGqlQGhaeJBNUvzVR/qcUmvtE3GquNOu7J
        qE/5nd70uqkfnkgb3+MI0cZxe6qRi0fLP9nolxFOeNLS9TVZybFjampx5UxLYGc1pnC4G8h0jo1lS
        wglmXsdJtVM625U+esHSCVFJ5QXyx8MzYdwFJAlBfQo9xzN6zCaHmAl1JyqVdjW5UyDgKuC7imgeD
        f5XXJjZxFVhFBjytgKzA/v11J2EQKlIxiFY/AVDdmrNLVHqCxpfaK3YS1OdKMSv0quwNNSRWkcIDC
        en+FWfhA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntjRQ-009yDS-6p; Wed, 25 May 2022 05:20:16 +0000
Date:   Tue, 24 May 2022 22:20:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Coly Li <colyli@suse.de>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        linux-block@vger.kernel.org
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
Message-ID: <Yo28kDw8rZgFWpHu@infradead.org>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
 <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net>
 <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net>
 <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
 <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, May 24, 2022 at 02:34:23PM -0700, Eric Wheeler wrote:
> Is this flag influced at all when /sys/block/sdX/queue/scheduler is set 
> to "none", or does the write_cache flag operate independently of the 
> selected scheduler?

This in completely independent from ﬆhe scheduler.

> Does the block layer stop sending flushes at the first device in the stack 
> that is set to "write back"?  For example, if a device mapper target is 
> writeback will it strip flushes on the way to the backing device?

This is up to the stacking driver.  dm and tend to pass through flushes
where needed.

> This confirms what I have suspected all along: We have an LSI MegaRAID 
> SAS-3516 where the write policy is "write back" in the LUN, but the cache 
> is flagged in Linux as write-through:
> 
> 	]# cat /sys/block/sdb/queue/write_cache 
> 	write through
> 
> I guess this is the correct place to adjust that behavior!

MegaRAID has had all kinds of unsafe policies in the past unfortunately.
I'm not even sure all of them could pass through flushes properly if we
asked them to :(
