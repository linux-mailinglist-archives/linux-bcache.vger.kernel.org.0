Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F9C6FFFD4
	for <lists+linux-bcache@lfdr.de>; Fri, 12 May 2023 07:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjELFNN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 May 2023 01:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjELFNM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 May 2023 01:13:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FA1358A
        for <linux-bcache@vger.kernel.org>; Thu, 11 May 2023 22:13:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A79B6225AE;
        Fri, 12 May 2023 05:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683868389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uNS1pTAS+kCTXpeVIEWr68VIsKmaCTQpVYVa/wOVY4w=;
        b=uNUtq3xYfsXKhIxpLU5cqXfbpsmR5h9kv80LitgVtAk41MZ5xHKUeElOpWFS1aGOgYLNYL
        UXu5OFbhxoPvX7RFJ7DXTTo3xEofq55tjsd+gNWC2Zb/qWQ8H2rdirUPkr59sawQORVpcK
        GAdmmluHZcx0FGP5EV8HK5uTnOdNquI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683868389;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uNS1pTAS+kCTXpeVIEWr68VIsKmaCTQpVYVa/wOVY4w=;
        b=6aoETZzNrqjD6FuQc5mkx6CC/Xk7gYjPZSyu6SO8c+85NGMguizrl9bp1CIp/ePSt6iXa9
        B8sF+tmED/srPUBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5970913499;
        Fri, 12 May 2023 05:13:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gKgBCeTKXWRvSwAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 12 May 2023 05:13:08 +0000
Date:   Fri, 12 May 2023 13:13:06 +0800
From:   Coly Li <colyli@suse.de>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: Writeback cache all used.
Message-ID: <pcwgnlftmhdpqt7byqfinxrjif7laqchpkhv2a4kae46u2mbrf@7eqa2sq6xbzx>
References: <2054791833.3229438.1680723106142@mail.yahoo.com>
 <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de>
 <1806824772.518963.1681071297025@mail.yahoo.com>
 <125091407.524221.1681074461490@mail.yahoo.com>
 <1399491299.3275222.1681990558684@mail.yahoo.com>
 <98d8ab2f-93ff-4df9-a91a-d0fb65bf675@ewheeler.net>
 <95701AD2-A13A-4E79-AE27-AAEFF6AA87D3@suse.de>
 <29836c81-3388-cf59-99b1-15bbf0eaac@ewheeler.net>
 <2050992229.3201284.1683598895474@mail.yahoo.com>
 <938a1b-c126-6962-ab3c-64e94fa08bcd@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <938a1b-c126-6962-ab3c-64e94fa08bcd@ewheeler.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, May 11, 2023 at 04:10:51PM -0700, Eric Wheeler wrote:
> On Tue, 9 May 2023, Adriano Silva wrote:
> > I got the parameters with this script, although I also checked / sys, doing the math everything is right.
> > 
> > https://gist.github.com/damoxc/6267899
> 
> Thanks.  prio_stats gives me what I'm looking for.  More below.
>  
> > Em segunda-feira, 8 de maio de 2023 às 21:42:26 BRT, Eric Wheeler <bcache@lists.ewheeler.net> escreveu: 
> > On Thu, 4 May 2023, Coly Li wrote:
> > > > 2023年5月3日 04:34，Eric Wheeler <bcache@lists.ewheeler.net> 写道：
> > > > 
> > > > On Thu, 20 Apr 2023, Adriano Silva wrote:
> > > >> I continue to investigate the situation. There is actually a performance 
> > > >> gain when the bcache device is only half filled versus full. There is a 
> > > >> reduction and greater stability in the latency of direct writes and this 
> > > >> improves my scenario.
> > > > 
> > > > Hi Coly, have you been able to look at this?
> > > > 
> > > > This sounds like a great optimization and Adriano is in a place to test 
> > > > this now and report his findings.
> > > > 
> > > > I think you said this should be a simple hack to add early reclaim, so 
> > > > maybe you can throw a quick patch together (even a rough first-pass with 
> > > > hard-coded reclaim values)
> > > > 
> > > > If we can get back to Adriano quickly then he can test while he has an 
> > > > easy-to-reproduce environment.  Indeed, this could benefit all bcache 
> > > > users.
> > > 
> > > My current to-do list on hand is a little bit long. Yes I’d like and 
> > > plan to do it, but the response time cannot be estimated.
> > 
> > I understand.  Maybe I can put something together if you can provide some 
> > pointers since you are _the_ expert on bcache these days.  Here are a few 
> > questions:
> > 
> > Q's for Coly:
> 
> 
> It _looks_ like bcache frees buckets while the `ca->free_inc` list is 
> full, but it could go further.  Consider this hypothetical:
> 

Hi Eric,

Bcache starts to invalidate bucket when ca->free_inc is full, and selects some
buckets to be invalidate by the replacement policy. Then continues to call
bch_invalidate_one_bucket() and pushes the invalidated bucket into ca->free_inc
until this list is full or no more candidate bucket to invalidate.


> https://elixir.bootlin.com/linux/v6.4-rc1/source/drivers/md/bcache/alloc.c#L179
> 
> 	static void invalidate_buckets_lru(struct cache *ca)
> 	{
> 	...
> +	int available = 0;
> +	mutex_lock(&ca->set->bucket_lock);

the mutex_lock()/unlock may introduce deadlock. Before invadliate_buckets() is
called, after allocator_wait() returns the mutex lock bucket_lock is held again. 

> +	for_each_bucket(b, ca) {
> +		if (!GC_SECTORS_USED(b))
> +			unused++;
> +		if (GC_MARK(b) == GC_MARK_RECLAIMABLE)
> +			available++;
> +		if (GC_MARK(b) == GC_MARK_DIRTY)
> +			dirty++;
> +		if (GC_MARK(b) == GC_MARK_METADATA)
> +			meta++;
> +	}
> +	mutex_unlock(&ca->set->bucket_lock);
> +
> -	while (!fifo_full(&ca->free_inc)) {
> +	while (!fifo_full(&ca->free_inc) || available < TARGET_AVAIL_BUCKETS) {

If ca->free_inc is full, and you still try to invalidate more candidate buckets, the
following selected bucket (by the heap_pop) will be invalidate in
bch_invalidate_one_bucket() and pushed into ca->free_inc. But now ca->free_inc is
full, so next time when invalidate_buckets_lru() is called again, this already
invalidated bucket will be accessed and checked again in for_each_bucket(). This is
just a waste of CPU cycles.

Further more, __bch_invalidate_one_bucket() will include the bucket's gen number and
its pin counter. Doing this without pushing the bucket into ca->free_inc, makes me
feel uncomfortable.


> 		if (!heap_pop(&ca->heap, b, bucket_min_cmp)) {



> 			/*
> 			 * We don't want to be calling invalidate_buckets()
> 			 * multiple times when it can't do anything
> 			 */
> 			ca->invalidate_needs_gc = 1;
> 			wake_up_gc(ca->set);
> 			return;
> 		}
> 
> 		bch_invalidate_one_bucket(ca, b);  <<<< this does the work
> 	}
> 
> (TARGET_AVAIL_BUCKETS is a placeholder, ultimately it would be a sysfs 
> setting, probably a percentage.)
> 
> 
> Coly, would this work?
> 

It should work on some kind of workloads, but will introduce complains for other kind of workloads.

> Can you think of any serious issues with this (besides the fact that for_each_bucket is slow)?
> 

I don't feel this change may help to make bcache invalidate the clean buckets without extra cost.

It is not simple for me to tell a solution without careful thought, this is a tradeoff of gain and
pay...

Thanks.

[snipped]

-- 
Coly Li
