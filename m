Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB8452F28E
	for <lists+linux-bcache@lfdr.de>; Fri, 20 May 2022 20:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348563AbiETSYO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 20 May 2022 14:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiETSYN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 20 May 2022 14:24:13 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61ADD190D13
        for <linux-bcache@vger.kernel.org>; Fri, 20 May 2022 11:24:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 16BD545;
        Fri, 20 May 2022 11:24:12 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Opn2oMDyoMfv; Fri, 20 May 2022 11:24:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id A500540;
        Fri, 20 May 2022 11:24:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net A500540
Date:   Fri, 20 May 2022 11:24:05 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Zou Mingzhe <mingzhe.zou@easystack.cn>
cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: Re: [PATCH v3] bcache: dynamic incremental gc
In-Reply-To: <112eaaf7-05fd-3b4f-0190-958d0c85fa1f@easystack.cn>
Message-ID: <37d75ff-877c-5453-b6a0-81c8d737299@ewheeler.net>
References: <20220511073903.13568-1-mingzhe.zou@easystack.cn> <ecce38e7-8ba0-5fbf-61a6-2dfc21c7793d@suse.de> <112eaaf7-05fd-3b4f-0190-958d0c85fa1f@easystack.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-442626393-1653071047=:2898"
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

--8323328-442626393-1653071047=:2898
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 20 May 2022, Zou Mingzhe wrote:
> 在 2022/5/12 21:41, Coly Li 写道:
> > On 5/11/22 3:39 PM, mingzhe.zou@easystack.cn wrote:
> >> From: ZouMingzhe <mingzhe.zou@easystack.cn>
> >>
> >> Currently, GC wants no more than 100 times, with at least
> >> 100 nodes each time, the maximum number of nodes each time
> >> is not limited.
> >>
> >> ```
> >> static size_t btree_gc_min_nodes(struct cache_set *c)
> >> {
> >>          ......
> >>          min_nodes = c->gc_stats.nodes / MAX_GC_TIMES;
> >>          if (min_nodes < MIN_GC_NODES)
> >>                  min_nodes = MIN_GC_NODES;
> >>
> >>          return min_nodes;
> >> }
> >> ```
> >>
> >> According to our test data, when nvme is used as the cache,
> >> it takes about 1ms for GC to handle each node (block 4k and
> >> bucket 512k). This means that the latency during GC is at
> >> least 100ms. During GC, IO performance would be reduced by
> >> half or more.
> >>
> >> I want to optimize the IOPS and latency under high pressure.
> >> This patch hold the inflight peak. When IO depth up to maximum,
> >> GC only process very few(10) nodes, then sleep immediately and
> >> handle these requests.
> >>
> >> bch_bucket_alloc() maybe wait for bch_allocator_thread() to
> >> wake up, and and bch_allocator_thread() needs to wait for gc
> >> to complete, in which case gc needs to end quickly. So, add
> >> bucket_alloc_inflight to cache_set in v3.
> >>
> >> ```
> >> long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
> >> {
> >>          ......
> >>          do {
> >> prepare_to_wait(&ca->set->bucket_wait, &w,
> >>                                  TASK_UNINTERRUPTIBLE);
> >>
> >>                  mutex_unlock(&ca->set->bucket_lock);
> >>                  schedule();
> >>                  mutex_lock(&ca->set->bucket_lock);
> >>          } while (!fifo_pop(&ca->free[RESERVE_NONE], r) &&
> >>                   !fifo_pop(&ca->free[reserve], r));
> >>          ......
> >> }
> >>
> >> static int bch_allocator_thread(void *arg)
> >> {
> >>     ......
> >>     allocator_wait(ca, bch_allocator_push(ca, bucket));
> >>     wake_up(&ca->set->btree_cache_wait);
> >>     wake_up(&ca->set->bucket_wait);
> >>     ......
> >> }
> >>
> >> static void bch_btree_gc(struct cache_set *c)
> >> {
> >>     ......
> >>     bch_btree_gc_finish(c);
> >>     wake_up_allocators(c);
> >>     ......
> >> }
> >> ```
> >>
> >> Apply this patch, each GC maybe only process very few nodes,
> >> GC would last a long time if sleep 100ms each time. So, the
> >> sleep time should be calculated dynamically based on gc_cost.
> >>
> >> At the same time, I added some cost statistics in gc_stat,
> >> hoping to provide useful information for future work.
> >
> >
> > Hi Mingzhe,
> >
> > From the first glance, I feel this change may delay the small GC period, and
> > finally result a large GC period, which is not expected.
> >
> > But it is possible that my feeling is incorrect. Do you have detailed
> > performance number about both I/O latency  and GC period, then I can have
> > more understanding for this effort.
> >
> > BTW, I will add this patch to my testing set and experience myself.
> >
> >
> > Thanks.
> >
> >
> > Coly Li
> >
> >
> Hi Coly,
> 
> First, your feeling is right. Then, I have some performance number abort
> before and after this patch.
> Since the mailing list does not accept attachments, I put them on the gist.
> 
> Please visit the page for details:
> https://gist.github.com/zoumingzhe/69a353e7c6fffe43142c2f42b94a67b5
> mingzhe

The graphs certainly show that peak latency is much lower, that is 
improvement, and dmesg shows the avail_nbuckets stays about the same so GC 
is keeping up.

Questions: 

1. Why is the after-"BW NO GC" graph so much flatter than the before-"BW 
   NO GC" graph?  I would expect your control measurements to be about the 
   same before vs after.  You might `blkdiscard` the cachedev and 
   re-format between runs in case the FTL is getting in the way, or maybe 
   something in the patch is affecting the "NO GC" graphs.

2. I wonder how the latency looks if you zoom into to the latency graph: 
   If you truncate the before-"LATENCY DO GC" graph at 3000 us then how 
   does the average latency look between the two?

3. This may be solved if you can fix the control graph issue in #1, but 
   the before vs after of "BW DO GC" shows about a 30% decrease in 
   bandwidth performance outside of the GC spikes.  "IOPS DO GC" is lower 
   with the patch too.  Do you think that your dynamic incremental gc 
   algorithm be tuned to deal with GC latency and still provide nearly the 
   same IOPS and bandwidth as before?


--
Eric Wheeler



> >
> >
> > [snipped]
> >
> >
> >
> 
> 
--8323328-442626393-1653071047=:2898--
