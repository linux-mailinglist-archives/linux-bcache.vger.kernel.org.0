Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733AD6FBC0C
	for <lists+linux-bcache@lfdr.de>; Tue,  9 May 2023 02:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjEIAm1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 May 2023 20:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEIAm0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 May 2023 20:42:26 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9618C59E8
        for <linux-bcache@vger.kernel.org>; Mon,  8 May 2023 17:42:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 61AD585;
        Mon,  8 May 2023 17:42:25 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id NfdSrXbe2hxq; Mon,  8 May 2023 17:42:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id E0B7945;
        Mon,  8 May 2023 17:42:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net E0B7945
Date:   Mon, 8 May 2023 17:42:20 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: Writeback cache all used.
In-Reply-To: <95701AD2-A13A-4E79-AE27-AAEFF6AA87D3@suse.de>
Message-ID: <29836c81-3388-cf59-99b1-15bbf0eaac@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
 <2054791833.3229438.1680723106142@mail.yahoo.com> <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de> <1806824772.518963.1681071297025@mail.yahoo.com> <125091407.524221.1681074461490@mail.yahoo.com> <1399491299.3275222.1681990558684@mail.yahoo.com>
 <98d8ab2f-93ff-4df9-a91a-d0fb65bf675@ewheeler.net> <95701AD2-A13A-4E79-AE27-AAEFF6AA87D3@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1265952573-1683592467=:22690"
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

--8323328-1265952573-1683592467=:22690
Content-Type: text/plain; CHARSET=ISO-2022-JP

On Thu, 4 May 2023, Coly Li wrote:
> > 2023年5月3日 04:34，Eric Wheeler <bcache@lists.ewheeler.net> 写道：
> > 
> > On Thu, 20 Apr 2023, Adriano Silva wrote:
> >> I continue to investigate the situation. There is actually a performance 
> >> gain when the bcache device is only half filled versus full. There is a 
> >> reduction and greater stability in the latency of direct writes and this 
> >> improves my scenario.
> > 
> > Hi Coly, have you been able to look at this?
> > 
> > This sounds like a great optimization and Adriano is in a place to test 
> > this now and report his findings.
> > 
> > I think you said this should be a simple hack to add early reclaim, so 
> > maybe you can throw a quick patch together (even a rough first-pass with 
> > hard-coded reclaim values)
> > 
> > If we can get back to Adriano quickly then he can test while he has an 
> > easy-to-reproduce environment.  Indeed, this could benefit all bcache 
> > users.
> 
> My current to-do list on hand is a little bit long. Yes I’d like and 
> plan to do it, but the response time cannot be estimated.

I understand.  Maybe I can put something together if you can provide some 
pointers since you are _the_ expert on bcache these days.  Here are a few 
questions:

Q's for Coly:

- It looks like it could be a simple change to bch_allocator_thread().  
  Is this the right place? 
  https://elixir.bootlin.com/linux/v6.3-rc5/source/drivers/md/bcache/alloc.c#L317
    - On alloc.c:332
	if (!fifo_pop(&ca->free_inc, bucket))
      does it just need to be modified to something like this:
	if (!fifo_pop(&ca->free_inc, bucket) || 
		total_unused_cache_percent() < 20)
      if so, where does bcache store the concept of "Total Unused Cache" ?

- If I'm going about it wrong above, then where is the code path in bcache 
  that frees a bucket such that it is completely unused (ie, as it was
  after `make-bcache -C`?)


Q's Adriano:

Where did you get these cache details from your earlier post?  In /sys 
somewhere, probably, but I didn't find them:

	Total Cache Size 553.31GiB
	Total Cache Used 547.78GiB (99%)
	Total Unused Cache 5.53GiB (1%)
	Dirty Data 0B (0%)
	Evictable Cache 503.52GiB (91%)



--
Eric Wheeler



> 
> Coly Li
> 
> [snipped]
--8323328-1265952573-1683592467=:22690--
