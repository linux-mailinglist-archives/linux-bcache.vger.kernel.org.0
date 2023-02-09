Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308E568FD2E
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Feb 2023 03:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjBICia (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 8 Feb 2023 21:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjBICi3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Feb 2023 21:38:29 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9901C5BF
        for <linux-bcache@vger.kernel.org>; Wed,  8 Feb 2023 18:38:28 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 5613984;
        Wed,  8 Feb 2023 18:38:28 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id NxvxrRwRTj5E; Wed,  8 Feb 2023 18:38:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 4244040;
        Wed,  8 Feb 2023 18:38:27 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 4244040
Date:   Wed, 8 Feb 2023 18:38:25 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Robert Krig <robert.krig@render-wahnsinn.de>
cc:     linux-bcache@vger.kernel.org
Subject: Re: Can you switch caching modes on the fly during use?
In-Reply-To: <92a2df4d-3631-b669-c275-1f067ad72bd1@render-wahnsinn.de>
Message-ID: <6ea8441d-5dce-e516-652a-f86e88b22174@ewheeler.net>
References: <92a2df4d-3631-b669-c275-1f067ad72bd1@render-wahnsinn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 6 Feb 2023, Robert Krig wrote:

> Hi. I was just wondering.
> 
> My cache device is a MD Raid1 SSD.
> My backing device is a BTRFS Raid10 on 8 Spinning disks.
> 
> 
> Everything is setup as default. Which, as far as I recall means writethrough
> caching.
> 
> Can I just switch the caching mode on the fly while the filesystem is in use,
> without any risks of corruption, or do I need to detach the cache, unmount the
> FS, etc...?

Yep!

	# cat /sys/block/bcache0/bcache/cache_mode 
	writethrough [writeback] writearound none

	# echo writeback > /sys/block/bcache0/bcache/cache_mode

More info:
	https://www.kernel.org/doc/Documentation/bcache.txt

-Eric
