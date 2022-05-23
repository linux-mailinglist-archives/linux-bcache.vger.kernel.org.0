Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78DF531C2B
	for <lists+linux-bcache@lfdr.de>; Mon, 23 May 2022 22:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiEWSZf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 23 May 2022 14:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243361AbiEWSZT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 May 2022 14:25:19 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A692CC5E4C
        for <linux-bcache@vger.kernel.org>; Mon, 23 May 2022 10:58:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 8DB0441;
        Mon, 23 May 2022 10:57:55 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 3J5M5twZPSBl; Mon, 23 May 2022 10:57:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 8C91140;
        Mon, 23 May 2022 10:55:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 8C91140
Date:   Mon, 23 May 2022 10:55:55 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Zou Mingzhe <mingzhe.zou@easystack.cn>
cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: Re: [PATCH v3] bcache: dynamic incremental gc
In-Reply-To: <28a044fd-e10e-ce25-6ce5-023ea9085139@easystack.cn>
Message-ID: <c781bbd4-5093-3f9a-38e2-bbe2846387a@ewheeler.net>
References: <20220511073903.13568-1-mingzhe.zou@easystack.cn> <ecce38e7-8ba0-5fbf-61a6-2dfc21c7793d@suse.de> <112eaaf7-05fd-3b4f-0190-958d0c85fa1f@easystack.cn> <37d75ff-877c-5453-b6a0-81c8d737299@ewheeler.net> <2cc994af-292f-ae7e-e793-058ada23c1ca@easystack.cn>
 <28a044fd-e10e-ce25-6ce5-023ea9085139@easystack.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-969978077-1653328557=:2898"
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

--8323328-969978077-1653328557=:2898
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 23 May 2022, Zou Mingzhe wrote:
> 在 2022/5/23 10:52, Zou Mingzhe 写道:
> > 在 2022/5/21 02:24, Eric Wheeler 写道:
> >> On Fri, 20 May 2022, Zou Mingzhe wrote:
> >>
> >> Questions:
> >>
> >> 1. Why is the after-"BW NO GC" graph so much flatter than the before-"BW
> >>     NO GC" graph?  I would expect your control measurements to be about the
> >>     same before vs after.  You might `blkdiscard` the cachedev and
> >>     re-format between runs in case the FTL is getting in the way, or maybe
> >>     something in the patch is affecting the "NO GC" graphs.
> >> 2. I wonder how the latency looks if you zoom into to the latency graph:
> >>     If you truncate the before-"LATENCY DO GC" graph at 3000 us then how
> >>     does the average latency look between the two?
> >> 3. This may be solved if you can fix the control graph issue in #1, but
> >>     the before vs after of "BW DO GC" shows about a 30% decrease in
> >>     bandwidth performance outside of the GC spikes.  "IOPS DO GC" is lower
> >>     with the patch too.  Do you think that your dynamic incremental gc
> >>     algorithm be tuned to deal with GC latency and still provide nearly the
> >>     same IOPS and bandwidth as before?
> >>
> >>
> >> -- 
> >> Eric Wheeler
> 
> Hi Eric,
> 
> I have done a retest round and update all data on
> "https://gist.github.com/zoumingzhe/69a353e7c6fffe43142c2f42b94a67b5".
> 
> First, there is only this patch between before and after, I re-format the disk
> with make-bcache before each fio. Each case was tested 5 times, and the
> results are as follows:
> 
>                     before after
>       NO GC           DO GC          NO GC          DO GC
> 1    99162.29     97366.28     99970.89     98290.81
> 2    99897.80     97879.99     96829.14     95548.88
> 3    98183.49     98834.29     101508.06   98581.53
> 4    98563.17     98476.61     96866.40     96676.87
> 5    97059.91     98356.50     96248.10     94442.61
> 
> Some details are also shown in the new graph, in addition to the raw data
> available for download.
> 
> I confirm that this patch does not cause a drop in iops. We have some other
> patches that may have affected the previous test, but this patch works fine.

Looks great, glad to see that it performs well!

What is the 3000us spike on the "after" line of "LATENCY DO GC" at about 
t=40s ? There is a drop in IOPS and BW on the other graphs at t=40s, too, 
but I don't see the same behavior on the "NO GC" side.

-Eric

> 
> 
> In fact, we mostly modified the gc handling.
> 
> mingzhe
> 
> 
> 
> 
> 
> 
> 
> 
> 
--8323328-969978077-1653328557=:2898--
