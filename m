Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2575A28A048
	for <lists+linux-bcache@lfdr.de>; Sat, 10 Oct 2020 13:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgJJLqW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 10 Oct 2020 07:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbgJJKUC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 10 Oct 2020 06:20:02 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9876AC0613CF;
        Sat, 10 Oct 2020 01:23:59 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t9so12582025wrq.11;
        Sat, 10 Oct 2020 01:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pm44PCTO8oGoL3yU9zyPNHExVf6NxFX1yCHLRcJUSSg=;
        b=SwxwY0eNC5rjMOaZfJtWyRZT5e5YZW5Yh5jEC4eeLrwkbkIS/UW9Y2KBZSviO18pe6
         0I+sEpAPwFRq6PvaXPm0Unjks64D1zl164R9eFInRXXVZo0BKWagCQurDrlilfVcyzLH
         7ZBWcJ11tDXx5Ai40gdqAlhAC8aHyaEzio04Dn4Xg/SjCgHUdSM07jIhVEVXP/VWG/X3
         okPOB8Ojg8kwMLo1+haMo01B4ezuUdXPbXEabKQhY90oWB6z7BM6arxTLpG3lzIeJcCO
         0n5jB9pgqaYXEqrIFd3YzQWvG3D/oTEzlPVbSXp8RtLk9gWDiLcovcTv6EM41H60I7sV
         mjyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pm44PCTO8oGoL3yU9zyPNHExVf6NxFX1yCHLRcJUSSg=;
        b=if32q1AVvjQzRGkaRWWQ1RGCtzlM9K0bzp+V6Tu1Lui46iBnsw6ni/dF+UjGCgG/mq
         CNSsBgwk0uOQUvSu5POyIiOGuARo+oDd3cPzIkPn/knHJeKB9pj7aElGF7iqVsu7y+wU
         6ObSdWXU9ddwgHsxcaclJ/Pd8ohaOgltbReVYoM+kS1yFixOp75lO1vkLCh3tLwkyN71
         oQIwnfO+dbbphqqI8DHdIHlG4OPgPLR7oFl1S+7O7E1bpWAhplePtUoIFI2cRLN08vzK
         vn+xszHOzxm83TJh0aBEWXMr8AvKwmumr+RkucFnL1DxUaRWKeNAqqTMNFeQga+2Ng4d
         PeXg==
X-Gm-Message-State: AOAM532zZx15rejh4+Xij0LDx+NrGu6tzRml1Pqn/oMMuLqXhgWP/6ij
        TLnZmT7U1cvpXsBNTnF4V/nozcBrfarsOQ==
X-Google-Smtp-Source: ABdhPJwFYbdbQvMwwRoJCMw6gaqAnYjXuvcefXcwUKp6PSIjm/zZgW8OLpwHbyXoqWGnu+zq/omwlw==
X-Received: by 2002:adf:e407:: with SMTP id g7mr18880403wrm.349.1602318238127;
        Sat, 10 Oct 2020 01:23:58 -0700 (PDT)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id d2sm5153034wrq.34.2020.10.10.01.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 01:23:57 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Sat, 10 Oct 2020 09:23:36 +0100
To:     Coly Li <colyli@suse.de>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Alex Dewar <alex.dewar90@gmail.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: Use #ifdef instead of boolean variable
Message-ID: <20201010082336.4435mnsxxmzqxq5y@medion>
References: <20201009183447.1611204-1-alex.dewar90@gmail.com>
 <b37a5dd2-437d-65e3-f432-a5247d09d94a@prevas.dk>
 <64db3f27-5904-8857-349e-e50d612932fb@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64db3f27-5904-8857-349e-e50d612932fb@suse.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Oct 10, 2020 at 10:05:22AM +0800, Coly Li wrote:
> On 2020/10/10 07:00, Rasmus Villemoes wrote:
> > On 09/10/2020 20.34, Alex Dewar wrote:
> >> The variable async_registration is used to indicate whether or not
> >> CONFIG_BCACHE_ASYNC_REGISTRATION is enabled, triggering a (false)
> >> warning in Coverity about unreachable code. However, it seems clearer in
> >> this case just to use an #ifdef, so let's do that instead.
> >>
> >> Addresses-Coverity-ID: 1497746: Control flow issues (DEADCODE)
> > 
> > I think that coverity check needs to be ignored. The kernel is full of
> > things that are supposed to be eliminated by the compiler, but still
> > checked for valid syntax etc. Often it's even more hidden than this,
> > something like
> > 
> > // some header
> > #ifdef CONFIG_FOO
> > int foo(void);
> > #else
> > static inline int foo(void) { return 0; }
> > #endif
> > 
> > // code
> > 
> >   if (foo()) { ... // this goes away for CONFIG_FOO=n }
> > 
> >> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> >> ---
> >>  drivers/md/bcache/super.c | 40 +++++++++++++++++----------------------
> >>  1 file changed, 17 insertions(+), 23 deletions(-)
> >>
> >> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> >> index 46a00134a36a..6d4127881c6a 100644
> >> --- a/drivers/md/bcache/super.c
> >> +++ b/drivers/md/bcache/super.c
> >> @@ -2504,11 +2504,6 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
> >>  	struct cache_sb_disk *sb_disk;
> >>  	struct block_device *bdev;
> >>  	ssize_t ret;
> >> -	bool async_registration = false;
> >> -
> >> -#ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
> >> -	async_registration = true;
> >> -#endif
> > 
> > If anything, this should simply be changed to
> > 
> >   bool async_registration = IS_ENABLED(CONFIG_BCACHE_ASYNC_REGISTRATION);
> > 
> > Rasmus
> 
> Hi Rasmus,
> 
> Yes, the above change might be better. But I don't suggest to spent
> effort on this.
> 
> Hi Alex,
> 
> Indeed the code in v5.9 is quite similar to what your patch makes, and I
> change it in this shape in v5.10 series. This piece of code may stay in
> kernel for 2 or 3 versions at most, the purpose is to make it convenient
> for people to test the async registration in production environment.
> Once the new async registration behavior is verified to not break any
> existing thing (which we don't know) it will be the (only) default
> behavior and the CONFIG_BCACHE_ASYNC_REGISTRATION check will be removed.
> 
> Thank you all for looking at this.
> 
> Coly Li

Hi Coly,

That sounds sensible. There's not much point in introducing needless
churn.

Best,
Alex
