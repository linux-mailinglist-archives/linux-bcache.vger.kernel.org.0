Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317525A847C
	for <lists+linux-bcache@lfdr.de>; Wed, 31 Aug 2022 19:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiHaRgv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 31 Aug 2022 13:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbiHaRgp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Aug 2022 13:36:45 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7A4B7EF1;
        Wed, 31 Aug 2022 10:36:43 -0700 (PDT)
Date:   Wed, 31 Aug 2022 13:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661967401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NBRMm1N3TN2sW5l8lmaOsP+pOHJybKZQLg5sV5Bi+Vs=;
        b=JlOCFCHLrsWklrXM0385YM6w7ONHaEPAHe9rbKLQa6iwi3TeZ6LGh6EG0D5RUZ8bAEay85
        TAGsGzcCQGLMFTxoEaZr7aTw2maxHxNvr+IE3uFEdinyqTaPDARIxnAdsqWHY3hSd8p5Eu
        OEYdA4Gxpjs4b1sPxYJbnA0/z/KA/Fw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Coly Li <colyli@suse.de>
Cc:     linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH 2/3] bcache: Convert to lib/time_stats
Message-ID: <20220831173639.sb6bhg5xvn4gbkiu@moria.home.lan>
References: <20220829165344.2958640-1-kent.overstreet@linux.dev>
 <20220829165344.2958640-3-kent.overstreet@linux.dev>
 <14ACCED7-D24D-4AC4-8677-F7F4630A840A@suse.de>
 <20220831165437.l27raas6k5nlqsdg@moria.home.lan>
 <1F91055C-4253-42CD-8A4A-8B8EA2CF1D6E@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1F91055C-4253-42CD-8A4A-8B8EA2CF1D6E@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Sep 01, 2022 at 01:02:37AM +0800, Coly Li wrote:
> Can I understand that rate = 1/frequency ?  Then frequency 4 is around to rate 0.

Correct, rate = 1/frequency.

> > The quantiles are for the duration, they give you an idea of the statistical
> > distribution, see https://en.wikipedia.org/wiki/Quantile
> 
> I wanted to ask how to read the quantiles line. Does it mean that 1 ns is
> equally divided by 15 segments, and the counter values are for the divided
> 1/15 ns segments?

It is the 15 boundaries between 16 equal segments, yes.

> Quantiles are much humane, standard deviation is scared… Just FYI LOL.

That's valuable feedback then, maybe we'll keep both. The more expensive part of
time stats is just ingesting data points, but we've got a percpu buffer frontend
for that - just doing a bit more moth doesn't cost much.
