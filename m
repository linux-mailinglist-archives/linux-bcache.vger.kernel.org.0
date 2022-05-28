Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96387536989
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 02:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbiE1A6a (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 20:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiE1A63 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 20:58:29 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A9E64BFE
        for <linux-bcache@vger.kernel.org>; Fri, 27 May 2022 17:58:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 4006481;
        Fri, 27 May 2022 17:58:28 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id iWH_d_DmmgPM; Fri, 27 May 2022 17:58:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id E00EEB;
        Fri, 27 May 2022 17:58:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net E00EEB
Date:   Fri, 27 May 2022 17:58:20 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     colyli <colyli@suse.de>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
In-Reply-To: <56405053a802525729f4e9f08e7861e5@suse.de>
Message-ID: <c542b8d-2bda-2075-ab51-6f37956ac48@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <a3830c54-5e88-658f-f0ef-7ac675090b24@suse.de> <5a9fe523-d88a-b9e-479f-ae6dbb3d596e@ewheeler.net>
 <56405053a802525729f4e9f08e7861e5@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1852147575-1653699496=:2952"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1852147575-1653699496=:2952
Content-Type: text/plain; CHARSET=ISO-2022-JP

On Sat, 28 May 2022, colyli wrote:
> 在 2022-05-27 03:15，Eric Wheeler 写道：
> > On Mon, 23 May 2022, Coly Li wrote:
> >> On 5/18/22 9:22 AM, Eric Wheeler wrote:
> >> > Some time ago you ordered an an SSD to test the 4k cache issue, has that
> >> > been fixed?  I've kept an eye out for the patch but not sure if it was
> >> > released.
> >> 
> >> Yes, I got the Intel P3700 PCIe SSD to fix the 4Kn unaligned I/O issue
> >> (borrowed from a hardware vendor). The new situation is, current kernel
> >> does
> >> the sector size alignment checking quite earlier in bio layer, if the LBA
> >> is
> >> not sector size aligned, it is rejected in the bio code, and the underlying
> >> driver doesn't have chance to see the bio anymore. So for now, the
> >> unaligned
> >> LBA for 4Kn device cannot reach bcache code, that's to say, the original
> >> reported condition won't happen now.
> > 
> > The issue is not with unaligned 4k IOs hitting /dev/bcache0 because you
> > are right, the bio layer will reject those before even getting to
> > bcache:
> > 
> > The issue is that the bcache cache metadata sometimes makes metadata or
> > journal requests from _inside_ bcache that are not 4k aligned.  When
> > this happens the bio layer rejects the request from bcache (not from
> > whatever is above bcache).
> > 
> > Correct me if I misunderstood what you meant here, maybe it really was
> > fixed.  Here is your response from that old thread that pointed at
> > unaligned key access where you said "Wow, the above lines are very
> > informative, thanks!"
> > 
> 
> It was not fixed, at least I didn't do it on purpose. Maybe it was avoided
> by other fixes, e.g. the oversize bkey fix. But I don't have evidence the
> issue was fixed.
> 
> > bcache: check_4k_alignment() KEY_OFFSET(&w->key) is not 4KB aligned:
> > 15725385535
> >   https://www.spinics.net/lists/linux-bcache/msg06076.html
> > 
> > In that thread Kent sent a quick top-post asking "have you checked extent
> > merging?"
> >  https://www.spinics.net/lists/linux-bcache/msg06077.html
> > 
> 
> It embarrassed me that I received your informative debug information, and I
> glared very hard at the code for quite long time, but didn't have any clue
> that how such problem may happen in the extent related code.

You do great work on bcache, I appreciate everything you do.  No need to 
be embarrassed, this is just a hard bug to pin down!

> Since you reported the issue and I believe you, I will keep my eyes on the
> non-aligned 4Kn issue for bcache internal I/O. Hope someday I may have idea
> suddenly to point out where the problem is, and fix it.

You might try this for testing:

1. Format with -w 4096

2. Add some WARN_ONCE's around metadata and journal IO operations and run 
   it through your stress test to see what turns up.  The -w 4096 will 
   guarantee that all userspace IOs are 4k aligned, and then if any WARN's 
   trigger then they are suspect.  Even on 512-byte cache deployments we 
   should target 4k-aligned meta IOs hitting the SSD cache.  This would
   fix 2 things:

      a. It will guarantee that all journal/meta IOs are aligned to 4k for 
         4k cache users.

      b. Fix Adriano's performance issues since for at least his Hynix 
         SSD because 512b IOs are ~6x high latency than 4k IOs on his 
         system.

--
Eric Wheeler


> 
> Coly Li
> 
> 
--8323328-1852147575-1653699496=:2952--
