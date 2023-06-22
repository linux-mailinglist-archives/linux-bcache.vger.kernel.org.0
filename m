Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8DC73A47D
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 17:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjFVPM4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 11:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjFVPMr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 11:12:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71C9199F;
        Thu, 22 Jun 2023 08:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iYO/2fIAfCy2gY0BGu2rVTSyHy9PvUmyfq9b+CT/AHE=; b=ufx4co6UqJ99ag8XLsIR4ALPKw
        fTDJdNZ+76a3Cw+T38oD5j4wq9z6MWzqKvkqlbJ39z0fQTCJ5NJ0HRAtwxB6KH9dA9uvH0fKINzP7
        wzMq3+wLFGhMkIxXcxOiNrr1+ImYYh0M09O9KAjJpEw7parxNZx31xjUcYCz0YI1UD20vJqwerzkB
        Bxx12GvD+gO7G/HmDGts1cQhNwCi53idiZ/qLnCfiNPtavbxTFWC2VMoJ76fzQmCkp1i1XflVAW2x
        xBNKPcTnzu/Qvhho7WwB5HUV+oYEDzlo6vt5cKYVnNd3sX1BBxR7i9+VoPe5dvsLUKohZILrNvInx
        7H6X9Bfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qCLz3-0015xg-2L;
        Thu, 22 Jun 2023 15:12:29 +0000
Date:   Thu, 22 Jun 2023 08:12:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH 2/2] bcache: Fix bcache device claiming
Message-ID: <ZJRk3Y8LjGhEKqK6@infradead.org>
References: <20230621162024.29310-1-jack@suse.cz>
 <20230621162333.30027-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621162333.30027-2-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jun 21, 2023 at 06:23:27PM +0200, Jan Kara wrote:
> Commit 2736e8eeb0cc ("block: use the holder as indication for exclusive
> opens") introduced a change that blkdev_put() has to get exclusive
> holder of the bdev as an argument. However it overlooked that
> register_bdev() and register_cache() overwrite the bdev->bd_holder field
> in the block device to point to the real owning object which was not
> available at the time we called blkdev_get_by_path(). Messing with bdev
> internals like this is a layering violation and it also causes
> blkdev_put() to issue warning about mismatching holders.

Ugg, yes.

> Fix bcache to reopen the block device with appropriate holder once it is
> available which also restores the behavior that multiple bcache caches
> cannot claim the same device which was also broken by commit
> 2736e8eeb0cc.

That was actually an intentional and documented change in commit
29499ab060fe ("bcache: don't pass a stack address to
blkdev_get_by_path") because the old behavior was broken already in
addition to the changing of the block stuff underneath.  Not that I'm
arguing against your changes here, but the commit log probably needs a
bit of tweaking.
