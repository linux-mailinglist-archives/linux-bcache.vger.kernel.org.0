Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3708E5A5842
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Aug 2022 02:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiH3ABC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Aug 2022 20:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiH3ABA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Aug 2022 20:01:00 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BBF62A86;
        Mon, 29 Aug 2022 17:00:58 -0700 (PDT)
Date:   Mon, 29 Aug 2022 20:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661817657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jJPz8pVCwweKgpeW4WUF/uGLiBPtN7wJWGEfgkepeY0=;
        b=ViRNyaG6zDTNMdiaD9rxTdK/u01sPgpNSj3Cz8YWpvFHHFeYOoyzVXTQRx6dpHDTpj3PSO
        eBPO2xb7kX7x9Z2MH3OKP6wmmv3wFwZlXvBaJvDwSMbgT6oulbKZk2M2NpQ1ZvbBDu2c45
        yiEhgvJORFjAy1lCZgXpIeaHiqZNcjw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        colyli@suse.de
Subject: Re: [PATCH 1/3] lib/time_stats: New library for statistics on events
Message-ID: <20220830000050.u4e7p3ddii4amfbb@moria.home.lan>
References: <20220829165344.2958640-1-kent.overstreet@linux.dev>
 <20220829165344.2958640-2-kent.overstreet@linux.dev>
 <1e80af02-ca1a-f320-bd3d-0ab674712da4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e80af02-ca1a-f320-bd3d-0ab674712da4@infradead.org>
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

On Mon, Aug 29, 2022 at 04:34:14PM -0700, Randy Dunlap wrote:
> 
> 
> On 8/29/22 09:53, Kent Overstreet wrote:
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index bbe3ef939c..bfb49505c9 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -1728,6 +1728,9 @@ config LATENCYTOP
> >  	  Enable this option if you want to use the LatencyTOP tool
> >  	  to find out which userspace is blocking on what kernel operations.
> >  
> > +config TIME_STATS
> > +	bool
> > +
> 
> Hi Kent,
> 
> Why not just in lib/Kconfig?

Probably just lazyness, I'll move it there :)
