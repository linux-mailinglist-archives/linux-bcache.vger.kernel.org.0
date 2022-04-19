Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7525061C0
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Apr 2022 03:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbiDSBlu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Apr 2022 21:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiDSBlu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Apr 2022 21:41:50 -0400
X-Greylist: delayed 552 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Apr 2022 18:39:09 PDT
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45975237C4
        for <linux-bcache@vger.kernel.org>; Mon, 18 Apr 2022 18:39:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 43E4581;
        Mon, 18 Apr 2022 18:29:56 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id GnGMFcKCBTtr; Mon, 18 Apr 2022 18:29:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id E1E5340;
        Mon, 18 Apr 2022 18:29:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net E1E5340
Date:   Mon, 18 Apr 2022 18:29:52 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Cedric de Wijs <cedric.dewijs@eclipso.eu>
cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Subject: Re: kernel 5.16.11 can't use an existing /dev/bcache0 as backing
 device for /dev/bcache1
In-Reply-To: <0bf15c2d-a309-789f-c722-c1bab20aa8c9@suse.de>
Message-ID: <33a2635b-89e7-d3ae-8b7d-63f57a721d7@ewheeler.net>
References: <a719b71b-6ab1-d9c8-b437-8f43ee306767@eclipso.eu> <aa879f78-32d9-b814-2b8f-558f3433d667@suse.de> <bdfa8a1b-ddc1-990f-f8b8-2541317de4d2@eclipso.eu> <0bf15c2d-a309-789f-c722-c1bab20aa8c9@suse.de>
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

On Sat, 5 Mar 2022, Coly Li wrote:
> On 3/5/22 3:54 PM, Cedric de Wijs wrote:
> > On 3/4/22 08:45, Coly Li wrote:
> >> On 3/3/22 1:23 AM, Cedric de Wijs wrote:
> >>> Hi All,
> >>>
> >>> Summary: the kernel can't use an existing /dev/bcache0 as backing device
> >>> for /dev/bcache1, and throws a lot of errors in /var/log/syslog.
> >>>
>
> > 1) Is stacking bcaches on op of each other unsupported for now, and is it
> > considered a technical problem that needs to be solved?
> >
> > 2) If I manage to somehow make the code work with stacked bcaches, will this
> > code be accepted in the kernel?
> 
> 
> Bcache is designed that a cache set or a backing device cannot be stacked by
> itself. Otherwise some internal data structure will be conflicted, e.g. sysfs
> device model related ones.

Hi Cedric,

Try placing a dm-linear as "bcache0-wrapper" device above bcache0 and 
place /dev/mapper/bcache0-wrapper as the backing device for bcache1.

That could give you the extra layer of indirection needed to isolate 
bcache from itself and dm-linear is pretty fast so the performance wont be 
affected too much.  This seems an appropriate quote:

  "All problems in computer science can be solved by another level of 
   indirection... Except for the problem of too many layers of 
   indirection." - David Wheeler

You might also look at dm-cache and dm-writeboost above or below bcache.

-Eric
