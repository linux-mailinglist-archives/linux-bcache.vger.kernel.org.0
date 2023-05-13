Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CF67019F8
	for <lists+linux-bcache@lfdr.de>; Sat, 13 May 2023 23:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjEMVFd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 13 May 2023 17:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjEMVFd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 13 May 2023 17:05:33 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E1F1FDE
        for <linux-bcache@vger.kernel.org>; Sat, 13 May 2023 14:05:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id E48A545;
        Sat, 13 May 2023 14:05:30 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id F0bhVnGT7RQr; Sat, 13 May 2023 14:05:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 6ED8E40;
        Sat, 13 May 2023 14:05:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 6ED8E40
Date:   Sat, 13 May 2023 14:05:26 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: Writeback cache all used.
In-Reply-To: <pcwgnlftmhdpqt7byqfinxrjif7laqchpkhv2a4kae46u2mbrf@7eqa2sq6xbzx>
Message-ID: <b33952ec-da5d-ad1-c710-ac374955215@ewheeler.net>
References: <2054791833.3229438.1680723106142@mail.yahoo.com> <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de> <1806824772.518963.1681071297025@mail.yahoo.com> <125091407.524221.1681074461490@mail.yahoo.com> <1399491299.3275222.1681990558684@mail.yahoo.com>
 <98d8ab2f-93ff-4df9-a91a-d0fb65bf675@ewheeler.net> <95701AD2-A13A-4E79-AE27-AAEFF6AA87D3@suse.de> <29836c81-3388-cf59-99b1-15bbf0eaac@ewheeler.net> <2050992229.3201284.1683598895474@mail.yahoo.com> <938a1b-c126-6962-ab3c-64e94fa08bcd@ewheeler.net>
 <pcwgnlftmhdpqt7byqfinxrjif7laqchpkhv2a4kae46u2mbrf@7eqa2sq6xbzx>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1248967855-1684011012=:22690"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1248967855-1684011012=:22690
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 12 May 2023, Coly Li wrote:
> On Thu, May 11, 2023 at 04:10:51PM -0700, Eric Wheeler wrote:
> > On Tue, 9 May 2023, Adriano Silva wrote:
> > > I got the parameters with this script, although I also checked / sys, doing the math everything is right.
> > > 
> > > https://gist.github.com/damoxc/6267899
> > 
> > Thanks.  prio_stats gives me what I'm looking for.  More below.
> >  
> > > Em segunda-feira, 8 de maio de 2023 às 21:42:26 BRT, Eric Wheeler <bcache@lists.ewheeler.net> escreveu: 
> > > On Thu, 4 May 2023, Coly Li wrote:
> > > > > 2023年5月3日 04:34，Eric Wheeler <bcache@lists.ewheeler.net> 写道：
> > > > > 
> > > > > On Thu, 20 Apr 2023, Adriano Silva wrote:
> > > > >> I continue to investigate the situation. There is actually a performance 
> > > > >> gain when the bcache device is only half filled versus full. There is a 
> > > > >> reduction and greater stability in the latency of direct writes and this 
> > > > >> improves my scenario.
> > > > > 
> > > > > Hi Coly, have you been able to look at this?
> > > > > 
> > > > > This sounds like a great optimization and Adriano is in a place to test 
> > > > > this now and report his findings.
> > > > > 
> > > > > I think you said this should be a simple hack to add early reclaim, so 
> > > > > maybe you can throw a quick patch together (even a rough first-pass with 
> > > > > hard-coded reclaim values)
> > > > > 
> > > > > If we can get back to Adriano quickly then he can test while he has an 
> > > > > easy-to-reproduce environment.  Indeed, this could benefit all bcache 
> > > > > users.
> > > > 
> > > > My current to-do list on hand is a little bit long. Yes I’d like and 
> > > > plan to do it, but the response time cannot be estimated.
> > > 
> > > I understand.  Maybe I can put something together if you can provide some 
> > > pointers since you are _the_ expert on bcache these days.  Here are a few 
> > > questions:
> > > 
> > > Q's for Coly:
> > 
> > 
> > It _looks_ like bcache frees buckets while the `ca->free_inc` list is 
> > full, but it could go further.  Consider this hypothetical:
> > 
> 
> Hi Eric,
> 
> Bcache starts to invalidate bucket when ca->free_inc is full, and selects some
> buckets to be invalidate by the replacement policy. Then continues to call
> bch_invalidate_one_bucket() and pushes the invalidated bucket into ca->free_inc
> until this list is full or no more candidate bucket to invalidate.

Understood.  The goal:  In an attempt to work around Adriano's performance 
issue, we wish to invalidate buckets even after free_inc is full.  If we 
can keep ~20% of buckets unused (ie, !GC_SECTORS_USED(b) ) then I think it 
will fix his issue.  That is the theory we wish to test and validate.

> > https://elixir.bootlin.com/linux/v6.4-rc1/source/drivers/md/bcache/alloc.c#L179
> > 
> > 	static void invalidate_buckets_lru(struct cache *ca)
> > 	{
> > 	...
> 
> the mutex_lock()/unlock may introduce deadlock. Before invadliate_buckets() is
> called, after allocator_wait() returns the mutex lock bucket_lock is held again. 

I see what you mean.  Maybe the bucket lock is already held; if so then I 
don't need to grab it again. For now I've pulled the mutex_lock lines for 
discussion.

We only use for_each_bucket() to get a "fuzzy" count of `available` 
buckets (pseudo code updated below). It doesn't need to be exact.

Here is some cleaned up and concise pseudo code for discussion (I've not 
yet compile tested):

+	int available = 0;
+
+	//mutex_lock(&ca->set->bucket_lock);
+	for_each_bucket(b, ca) {
+		if (GC_MARK(b) == GC_MARK_RECLAIMABLE)
+			available++;
+	}
+	//mutex_unlock(&ca->set->bucket_lock);
+
-	while (!fifo_full(&ca->free_inc)) {
+	while (!fifo_full(&ca->free_inc) || available < TARGET_AVAIL_BUCKETS) {
		...
 		bch_invalidate_one_bucket(ca, b);  <<<< this does the work
+               available++;
	}

Changes from previous post:

  - `available` was not incremented, now it is , so now the loop can 
    terminate.
  - Removed the other counters for clarity, we only care about 
    GC_MARK_RECLAIMABLE for this discussion.
  - Ignore locking for now
  
(TARGET_AVAIL_BUCKETS is a placeholder, ultimately it would be a sysfs 
setting, probably a percentage.)
 
> If ca->free_inc is full, and you still try to invalidate more candidate 
> buckets, the following selected bucket (by the heap_pop) will be 
> invalidate in bch_invalidate_one_bucket() and pushed into ca->free_inc. 
> But now ca->free_inc is full, so next time when invalidate_buckets_lru() 
> is called again, this already invalidated bucket will be accessed and 
> checked again in for_each_bucket(). This is just a waste of CPU cycles.

True. I was aware of this performance issue when I wrote that; bcache 
takes ~1s to iterate for_each_bucket() on my system.  Right now we just 
want to keep ~20% of buckets completely unused and verify 
correctness...and then I can work on hiding the bucket counting overhead 
caused by for_each_bucket().

> Further more, __bch_invalidate_one_bucket() will include the bucket's gen number and
> its pin counter. Doing this without pushing the bucket into ca->free_inc, makes me
> feel uncomfortable.

Questions for my understanding: 

- Is free_inc just a reserve list such that most buckets are in the heap 
  after a fresh `make-bcache -C <cdev>`?

- What is the difference between buckets in free_inc and buckets in the 
  heap? Do they overlap?

I assume you mean this:

	void __bch_invalidate_one_bucket(...) { 
		...
		bch_inc_gen(ca, b);
		b->prio = INITIAL_PRIO;
		atomic_inc(&b->pin);

If I understand the internals of bcache, the `gen` is just a counter that 
increments to make the bucket "newer" than another referenced version.  
Incrementing the `gen` on an unused bucket should be safe, but please 
correct me if I'm wrong here.

I'm not familiar with b->pin, it doesn't appear to be commented in `struct 
bucket` and I didn't see it used in bch_allocator_push().  

What is b->pin used for?

> > Coly, would this work?
> 
> It should work on some kind of workloads, but will introduce complains for other kind of workloads.

As this is written above, I agree.  Right now I'm just trying to 
understand the code well enough to free buckets preemptively so allocation 
doesn't happen during IO.  For now please ignore the cost of 
for_each_bucket().

> > Can you think of any serious issues with this (besides the fact that 
> > for_each_bucket is slow)?
> > 
> 
> I don't feel this change may help to make bcache invalidate the clean 
> buckets without extra cost.

For the example pseudo code above that is true, and for now I am _not_ 
trying to address performance.
 
> It is not simple for me to tell a solution without careful thought, this 
> is a tradeoff of gain and pay...

Certainly that is the end goal, but first I need to understand the code 
well enough to invalidate buckets down to 20% free and still maintain 
correctness.

Thanks for your help understaing this.

-Eric

> 
> Thanks.
> 
> [snipped]
> 
> -- 
> Coly Li
> 
--8323328-1248967855-1684011012=:22690--
