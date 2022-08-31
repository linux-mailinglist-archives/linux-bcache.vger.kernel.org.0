Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3115A8392
	for <lists+linux-bcache@lfdr.de>; Wed, 31 Aug 2022 18:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiHaQyy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 31 Aug 2022 12:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiHaQyx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Aug 2022 12:54:53 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BB9D31FE;
        Wed, 31 Aug 2022 09:54:43 -0700 (PDT)
Date:   Wed, 31 Aug 2022 12:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661964881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JEP5P0FivNXzUzqKfDvRWYdY+bpNYj7QyhA+GvUOAA8=;
        b=oy8BDHTFcP2BrlGTXifpszllUxXH86Pv/uhrb5Vvx0qLa2JoLx3g7wnt0nSOLOMYEKiDJs
        2NCmMsw9mPuD8JADSvOWhLRPmi8UBEOqVzwFjz54BQPN6frJC8u3+q+B989+uxgznTkBGn
        hijZJCZAL0cuRmj5HQ86K6BZfEcahIU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Coly Li <colyli@suse.de>
Cc:     linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH 2/3] bcache: Convert to lib/time_stats
Message-ID: <20220831165437.l27raas6k5nlqsdg@moria.home.lan>
References: <20220829165344.2958640-1-kent.overstreet@linux.dev>
 <20220829165344.2958640-3-kent.overstreet@linux.dev>
 <14ACCED7-D24D-4AC4-8677-F7F4630A840A@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14ACCED7-D24D-4AC4-8677-F7F4630A840A@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Sep 01, 2022 at 12:00:17AM +0800, Coly Li wrote:
> 
> 
> > 2022年8月30日 00:53，Kent Overstreet <kent.overstreet@linux.dev> 写道：
> > 
> > This patch converts bcache to the new generic time_stats code
> > lib/time_stats.c. The new code is from bcachefs, and has some changes
> > from the version in bcache:
> > 
> > - we now use ktime_get_ns(), not local_clock(). When the code was
> >   originally written multi processor systems that lacked synchronized
> >   TSCs were still common, and so local_clock() was much cheaper than
> >   sched_clock() (though not necessarily fully accurate, due to TSC
> >   drift). ktime_get_ns() should be cheap enough on all common hardware
> >   now, and more standard/correct.
> > 
> > - time_stats are now exported in a single file in sysfs, which means we
> >   can improve the statistics we keep track of without changing all
> >   users. This also means we don't have to manually specify which units
> >   (ms, us, ns) a given time_stats should be printed in; that's handled
> >   dynamically.
> > 
> > - There's a lazily-allocated percpu buffer, which now needs to be freed
> >   with time_stats_exit().
> > 
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > Cc: Coly Li <colyli@suse.de>
> 
> Hi Kent,
> 
> Overall I am OK with the change to bcache code. You may add
> 	Acked-by: Coly Li <colyli@suse.de>
> in future version of this patch.
> 
> In bcache-tools, they don’t read the changed sysfs files (including bcache-status), IMHO changing the output format won’t be problem for upstream.
> 
> My only question is, how to understand the time_stats_to_text() output format,
> count:          3
> rate:           0/sec
> frequency:      4 sec
> avg duration:   4 sec
> max duration:   4 sec
> quantiles (ns): 0 4288669120 4288669120 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048
> 
> Fro the above output, what are “rate”, “frequence” and “quantiles” for?

Rate and frequency are inverses - in this example, we're seeing 4 events per
second.

The quantiles are for the duration, they give you an idea of the statistical
distribution, see https://en.wikipedia.org/wiki/Quantile

In the near future, the quantiles will be removed and replaced with standard
deviation, true and weighted - the quantiles algorithm isn't super accurate, we
can give more accurate numbers with standard deviation.
