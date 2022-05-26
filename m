Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223135353CF
	for <lists+linux-bcache@lfdr.de>; Thu, 26 May 2022 21:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbiEZTPo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 26 May 2022 15:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiEZTPn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 May 2022 15:15:43 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B529CF52
        for <linux-bcache@vger.kernel.org>; Thu, 26 May 2022 12:15:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id F055540;
        Thu, 26 May 2022 12:15:42 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 6kjmlAPEPUZL; Thu, 26 May 2022 12:15:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 9C1E939;
        Thu, 26 May 2022 12:15:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 9C1E939
Date:   Thu, 26 May 2022 12:15:34 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
In-Reply-To: <a3830c54-5e88-658f-f0ef-7ac675090b24@suse.de>
Message-ID: <5a9fe523-d88a-b9e-479f-ae6dbb3d596e@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <a3830c54-5e88-658f-f0ef-7ac675090b24@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 23 May 2022, Coly Li wrote:
> On 5/18/22 9:22 AM, Eric Wheeler wrote:
> > Some time ago you ordered an an SSD to test the 4k cache issue, has that
> > been fixed?  I've kept an eye out for the patch but not sure if it was
> > released.
> 
> Yes, I got the Intel P3700 PCIe SSD to fix the 4Kn unaligned I/O issue
> (borrowed from a hardware vendor). The new situation is, current kernel does
> the sector size alignment checking quite earlier in bio layer, if the LBA is
> not sector size aligned, it is rejected in the bio code, and the underlying
> driver doesn't have chance to see the bio anymore. So for now, the unaligned
> LBA for 4Kn device cannot reach bcache code, that's to say, the original
> reported condition won't happen now.

The issue is not with unaligned 4k IOs hitting /dev/bcache0 because you
are right, the bio layer will reject those before even getting to
bcache:

The issue is that the bcache cache metadata sometimes makes metadata or
journal requests from _inside_ bcache that are not 4k aligned.  When
this happens the bio layer rejects the request from bcache (not from
whatever is above bcache).

Correct me if I misunderstood what you meant here, maybe it really was 
fixed.  Here is your response from that old thread that pointed at 
unaligned key access where you said "Wow, the above lines are very 
informative, thanks!"

bcache: check_4k_alignment() KEY_OFFSET(&w->key) is not 4KB aligned:  15725385535
  https://www.spinics.net/lists/linux-bcache/msg06076.html

In that thread Kent sent a quick top-post asking "have you checked extent 
merging?"
	https://www.spinics.net/lists/linux-bcache/msg06077.html

> And after this observation, I stopped my investigation on the unaligned sector
> size I/O on 4Kn device, and returned the P3700 PCIe SSD to the hardware
> vendor.

Hmm, sorry that it wasn't reproduced.  I hope I'm wrong, but if bcache is 
generating the 4k-unaligned requests against the cache meta then this bug 
might still be floating around for "4Kn" cache users.

-Eric
