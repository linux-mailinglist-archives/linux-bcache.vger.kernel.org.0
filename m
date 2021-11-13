Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6A644F472
	for <lists+linux-bcache@lfdr.de>; Sat, 13 Nov 2021 19:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhKMSPk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 13 Nov 2021 13:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhKMSPk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 13 Nov 2021 13:15:40 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8730BC061766
        for <linux-bcache@vger.kernel.org>; Sat, 13 Nov 2021 10:12:47 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id q64so1677247qkd.5
        for <linux-bcache@vger.kernel.org>; Sat, 13 Nov 2021 10:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PwEmfwfhWCMZO7tV3XtG6dDY+12GRRTG948HcWKOFWk=;
        b=UHtLAJmwBFruLwYGxcK66IjgUWmQXgEmDDQxnZ3T24u8cGQ+61nVwIRvrQTXfu3M29
         WxfP4bDvJtsjxg0ZBMrtrtsU66aSUpmt8GG/QvCqwUFY8/NVuKGOVvR7sex7DUfgY6Rq
         hU+CptjvI/93Mv7NdMzntPpPgCR4mVEVHLZ295GdC+wN6rHSGNsecqf7As1vpmcaZrNr
         L4CmNPsaS6SQr6p6PJkqAz5+QBmkROsICm8BIEzZ7BlpRdm/Shqbs4eeSbse237UUJy/
         +2qrk8+B7ZQ0/fo2sLw4EVv0qW1kwlFtU6djsVjycZjos2c/uxz3qGe1KBub5y+gRDNi
         t4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PwEmfwfhWCMZO7tV3XtG6dDY+12GRRTG948HcWKOFWk=;
        b=y81tX0wGHvjdZViY7znpYXhirVmDweOnqKV2kuefRY7YckONiuT8i1IGV3JgmpgAK/
         qZxpBJndJYrH/wFSxGugMYxUMAq/uoJzs4wrrX9JH81gfajwgXY/aVJgK90JDjOHye5g
         M/slu3VnnRWTvMwV0gBR2s/KpyWXcvynzz3oWdxi1Q6Ze461m5ttD4JwuF1LiKLUotJ4
         fh40gb13mnGmc+ckpih432F9/oAIqnTojAHviHduB5Yi415y7AJ8Nt8Nfqgqq0lsGD12
         vEUwRQYA0JE4jdfI1RMbVzNE75uc2TZYEpjkYplBhJY511QwM00ED5MGgWD7/OOPGxwZ
         DbwQ==
X-Gm-Message-State: AOAM533v+2BSJifoU/5j+9/22eltFVo0GKw1f9WNLTo5N98xDLmCct3g
        +9UPrymVugswbFgnZ/sUaw==
X-Google-Smtp-Source: ABdhPJypMfHejkzQtkrG5hXWV8vHVTd2zuAnv7s8uJ61Xh8wWYqZa1Cxe5UCxo2taBpHWB/lkEsFFA==
X-Received: by 2002:a37:747:: with SMTP id 68mr20210992qkh.227.1636827166750;
        Sat, 13 Nov 2021 10:12:46 -0800 (PST)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id q4sm5025986qtw.19.2021.11.13.10.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 10:12:45 -0800 (PST)
Date:   Sat, 13 Nov 2021 13:12:44 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org,
        Nikhil Kshirsagar <nkshirsagar@gmail.com>
Subject: Re: bcache-register hang after reboot
Message-ID: <YZAAHFtd/mLKVH6B@moria.home.lan>
References: <CAC6jXv0mw4eOzFSzzm0acBJFM5whhC=hTFG6_8H__rfA6zq5Cg@mail.gmail.com>
 <YYwn1eT86dvSRfeA@moria.home.lan>
 <3768e9e4-892e-ca99-507c-040c725f0db5@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3768e9e4-892e-ca99-507c-040c725f0db5@suse.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Nov 12, 2021 at 01:45:06PM +0800, Coly Li wrote:
> On 11/11/21 4:13 AM, Kent Overstreet wrote:
> > On Wed, Nov 10, 2021 at 11:14:41AM +0530, Nikhil Kshirsagar wrote:
> > > Hello,
> > > 
> > > After a reboot of an Ubuntu server running 4.15.0-143-generic kernel,
> > > the storage devices using bcache do not come back up and the following
> > > stack traces are seen in kern.log. Please could someone help me
> > > understand if this is due to a full bcache journal? Is there any
> > > workaround, or fix?
> > Your journal is completely full, so persisting the new btree root while doing
> > journal replay is hanging.
> > 
> > There isn't a _good_ solution for this journal deadlock in bcache (it's fixed in
> > bcachefs), but there is a hack:
> > 
> > edit drivers/md/bcache/btree.c line 2493
> > 
> > delete the call to bch_journal_meta(), and build a new kernel. Once you've
> > gotten it to register, do a clean shutdown and then go back to a stock kernel.
> > 
> > Running the kernel with that call deleted won't be safe if you crash, but it'll
> > get you going again.
> 
> This happens eventually. I had a patch to reserve the last 2 blocks in the
> last journal bucket, and only to use them during boot time. It seems to be
> time to refine the patch.

bcachefs has that modification as well - the bcache journal code is so minimal
in comparison.

> (BTW, looking forward to see bcachefs in mainline kernel).

Thanks! Now that snapshots are done, I'm going to be focusing on closing bugs
for awhile, and then hopefully finally upstreaming it soon.
