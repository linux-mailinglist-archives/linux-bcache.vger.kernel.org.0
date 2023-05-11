Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC066FFCF8
	for <lists+linux-bcache@lfdr.de>; Fri, 12 May 2023 01:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbjEKXK6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 11 May 2023 19:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239223AbjEKXK5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 11 May 2023 19:10:57 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BCD35A6
        for <linux-bcache@vger.kernel.org>; Thu, 11 May 2023 16:10:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 1C15446;
        Thu, 11 May 2023 16:10:56 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 58fwtACk-rIm; Thu, 11 May 2023 16:10:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id A0B1D40;
        Thu, 11 May 2023 16:10:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net A0B1D40
Date:   Thu, 11 May 2023 16:10:51 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: Writeback cache all used.
In-Reply-To: <2050992229.3201284.1683598895474@mail.yahoo.com>
Message-ID: <938a1b-c126-6962-ab3c-64e94fa08bcd@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
 <2054791833.3229438.1680723106142@mail.yahoo.com> <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de> <1806824772.518963.1681071297025@mail.yahoo.com> <125091407.524221.1681074461490@mail.yahoo.com> <1399491299.3275222.1681990558684@mail.yahoo.com>
 <98d8ab2f-93ff-4df9-a91a-d0fb65bf675@ewheeler.net> <95701AD2-A13A-4E79-AE27-AAEFF6AA87D3@suse.de> <29836c81-3388-cf59-99b1-15bbf0eaac@ewheeler.net> <2050992229.3201284.1683598895474@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1930919299-1683846651=:22690"
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

--8323328-1930919299-1683846651=:22690
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 9 May 2023, Adriano Silva wrote:
> I got the parameters with this script, although I also checked / sys, doing the math everything is right.
> 
> https://gist.github.com/damoxc/6267899

Thanks.  prio_stats gives me what I'm looking for.  More below.
 
> Em segunda-feira, 8 de maio de 2023 às 21:42:26 BRT, Eric Wheeler <bcache@lists.ewheeler.net> escreveu: 
> On Thu, 4 May 2023, Coly Li wrote:
> > > 2023年5月3日 04:34，Eric Wheeler <bcache@lists.ewheeler.net> 写道：
> > > 
> > > On Thu, 20 Apr 2023, Adriano Silva wrote:
> > >> I continue to investigate the situation. There is actually a performance 
> > >> gain when the bcache device is only half filled versus full. There is a 
> > >> reduction and greater stability in the latency of direct writes and this 
> > >> improves my scenario.
> > > 
> > > Hi Coly, have you been able to look at this?
> > > 
> > > This sounds like a great optimization and Adriano is in a place to test 
> > > this now and report his findings.
> > > 
> > > I think you said this should be a simple hack to add early reclaim, so 
> > > maybe you can throw a quick patch together (even a rough first-pass with 
> > > hard-coded reclaim values)
> > > 
> > > If we can get back to Adriano quickly then he can test while he has an 
> > > easy-to-reproduce environment.  Indeed, this could benefit all bcache 
> > > users.
> > 
> > My current to-do list on hand is a little bit long. Yes I’d like and 
> > plan to do it, but the response time cannot be estimated.
> 
> I understand.  Maybe I can put something together if you can provide some 
> pointers since you are _the_ expert on bcache these days.  Here are a few 
> questions:
> 
> Q's for Coly:


It _looks_ like bcache frees buckets while the `ca->free_inc` list is 
full, but it could go further.  Consider this hypothetical:

https://elixir.bootlin.com/linux/v6.4-rc1/source/drivers/md/bcache/alloc.c#L179

	static void invalidate_buckets_lru(struct cache *ca)
	{
	...
+	int available = 0;
+	mutex_lock(&ca->set->bucket_lock);
+	for_each_bucket(b, ca) {
+		if (!GC_SECTORS_USED(b))
+			unused++;
+		if (GC_MARK(b) == GC_MARK_RECLAIMABLE)
+			available++;
+		if (GC_MARK(b) == GC_MARK_DIRTY)
+			dirty++;
+		if (GC_MARK(b) == GC_MARK_METADATA)
+			meta++;
+	}
+	mutex_unlock(&ca->set->bucket_lock);
+
-	while (!fifo_full(&ca->free_inc)) {
+	while (!fifo_full(&ca->free_inc) || available < TARGET_AVAIL_BUCKETS) {
		if (!heap_pop(&ca->heap, b, bucket_min_cmp)) {
			/*
			 * We don't want to be calling invalidate_buckets()
			 * multiple times when it can't do anything
			 */
			ca->invalidate_needs_gc = 1;
			wake_up_gc(ca->set);
			return;
		}

		bch_invalidate_one_bucket(ca, b);  <<<< this does the work
	}

(TARGET_AVAIL_BUCKETS is a placeholder, ultimately it would be a sysfs 
setting, probably a percentage.)


Coly, would this work?

Can you think of any serious issues with this (besides the fact that for_each_bucket is slow)?



-Eric

> 
> - It looks like it could be a simple change to bch_allocator_thread().  
>   Is this the right place? 
>   https://elixir.bootlin.com/linux/v6.3-rc5/source/drivers/md/bcache/alloc.c#L317
>     - On alloc.c:332
>     if (!fifo_pop(&ca->free_inc, bucket))
>       does it just need to be modified to something like this:
>     if (!fifo_pop(&ca->free_inc, bucket) || 
>         total_unused_cache_percent() < 20)
>       if so, where does bcache store the concept of "Total Unused Cache" ?
> 
> - If I'm going about it wrong above, then where is the code path in bcache 
>   that frees a bucket such that it is completely unused (ie, as it was
>   after `make-bcache -C`?)
> 
> 
> Q's Adriano:
> 
> Where did you get these cache details from your earlier post?  In /sys 
> somewhere, probably, but I didn't find them:
> 
>     Total Cache Size 553.31GiB
>     Total Cache Used 547.78GiB (99%)
>     Total Unused Cache 5.53GiB (1%)
>     Dirty Data 0B (0%)
>     Evictable Cache 503.52GiB (91%)
> 
> 
> 
> 
> --
> Eric Wheeler
> 
> 
> 
> > 
> > Coly Li
> > 
> > [snipped]
> 
--8323328-1930919299-1683846651=:22690--
