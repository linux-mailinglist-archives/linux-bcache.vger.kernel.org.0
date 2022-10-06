Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CA65F5E72
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Oct 2022 03:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJFBq5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Oct 2022 21:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJFBq4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Oct 2022 21:46:56 -0400
X-Greylist: delayed 445 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Oct 2022 18:46:55 PDT
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DFD870AE
        for <linux-bcache@vger.kernel.org>; Wed,  5 Oct 2022 18:46:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 073D349;
        Wed,  5 Oct 2022 18:39:30 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id IZvssRXb4l1o; Wed,  5 Oct 2022 18:39:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 0AA4D40;
        Wed,  5 Oct 2022 18:39:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 0AA4D40
Date:   Wed, 5 Oct 2022 18:39:26 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Cobra_Fast <cobra_fast@wtwrp.de>
cc:     linux-bcache@vger.kernel.org
Subject: Re: Feature Request - Full Bypass/Verify Mode
In-Reply-To: <5ff94948-9406-9b86-2ab3-db74fcb44d00@ezl.re>
Message-ID: <216bf3b3-b827-efbc-190-31e86de0a85b@ewheeler.net>
References: <5ff94948-9406-9b86-2ab3-db74fcb44d00@ezl.re>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_20,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, 5 Oct 2022, Cobra_Fast wrote:

> Greetings,
> 
> I am using bcache in conjunction with SnapRAID, which works on the FS-level,
> and I have noticed that parity syncs as well as scrubs read data from the
> cache rather than the backing device. This probably not a problem when
> creating parity for new files, but could be a problem when running scrubs, as
> the parity is never checked against data on disk since bcache hides it.

Interesting.
 
> I would therefore very much like a cache_mode that would bypass any and all
> reads, that can be enabled for the duration of a SnapRAID sync or scrub. For
> writes I suppose this mode should act the same as "none".
> 
> This opportunity could be taken to verify data on cache as well; read from
> both backing and cache and invalidate the cache page if it differs from the
> backing data, while satisfying the actual read from backing in any case.

assuming that one or the other is correct... I'm not sure bcache could 
tell which block is valid, and SnapRAID doesn't know about the lldevs.
 
> Perhaps something like this is already possible and I'm just not seeing it?
> I know I can detach backing devices, but to my understanding that also
> invalidates all its cached pages and I would obviously like to keep them for
> this purpose.

Well you can only read-validate pages that are not dirty...if its dirty 
you _must_ read from cache for consistency.

You could put it in write_around mode and wait for dirty_bytes to be 0, 
but I think it will still read from the cache if the page is hot.

Detach sounds like the only option at the moment to get what you're 
seeking.  Future work could include adding a `readaround` to 
/sys/block/bcache0/bcache/cache_mode, but it would still have to read from 
the cache if dirty.  Or maybe if `readaround` hits a dirty block it evicts 
it and re-reads the backing device?  But that sounds messy and slow.

Maybe you could assume that if the cache is correct then the backing 
device is correct and a verify atop of bcache means that bcache is 
consistent, independent of the lower layers.  This is certainly true for 
dirty blocks, and probably for clean (in-cache) blocks too.

-Eric

> 
> Looking forward to your opinions,
> Best regards,
> Andy
> 
> 
