Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE7E44F469
	for <lists+linux-bcache@lfdr.de>; Sat, 13 Nov 2021 19:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhKMSIS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 13 Nov 2021 13:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhKMSIS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 13 Nov 2021 13:08:18 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BE5C061766
        for <linux-bcache@vger.kernel.org>; Sat, 13 Nov 2021 10:05:25 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id bk22so12414648qkb.6
        for <linux-bcache@vger.kernel.org>; Sat, 13 Nov 2021 10:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VVMQrKVuXsJRSRY3qfD5dtwzQjhPhYDS6Dz28SQAql0=;
        b=o05rBW9Pl5yV5Vq1mA6/VU3Zix+gGhJdGwlHulY3V4Rs+k6+AueMdGxNWy4gNmuOwv
         xd7NHO9nkmF3AdJ3vNu5LBVovmH96/YNSMye+TfsyBm/FkufnHzQ61/XJRo2moB3uX+0
         8uVwll+DtwxwfGsTH6mzQ7+UCp1EIMILH1mTTOpDsU1p64GVxngZSePN/1BeDKXWEd29
         H3bxpqtgRp7aaaZwB1Yu+aPUetxo8wbt1SgvYgYJt/jPDOGW+DzzDs1zSVWGnnpaWexC
         ai0lhyod0ykRStfyXxvls4yOozGMNLARaZnTmozhrOboJ1sWn5rH/THEeQw8ilSL/EVA
         4/gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VVMQrKVuXsJRSRY3qfD5dtwzQjhPhYDS6Dz28SQAql0=;
        b=FTr+dz+XoIJNl1XxzviDWhy5wcc0pDlYE6rosP7n2o5sIzt5Ev+wD7SdEA6ogf9mMs
         sBgkjMYGvsL/QhqJTtLxkwcjej9wZZsHxtcbpXLoEaD2PiE3KG8UdSF7gMoFSWYK/1MI
         tLo3jOUvYcvwcEd+0XlargGo6jiZ/2fVacga8U/PnNNixJzkgVRIARNsS2HMBoJcRNE8
         nT/T627tlJ41HX8NltHeQ6WLD8s9NqETqmMlu0Xx/WjJN0fO3J/cCuZBJzWbiPfml/SR
         7VbTgP4HcjVR2rLXOBQ1f9415bv7rvY9sLyOP5qJYvirNwRyZMyWdsPDIahcwkd/0hlg
         U+OQ==
X-Gm-Message-State: AOAM531ZyZeNzLI8m72IeD5UaPPq51Ig2hUzN9AzBxa7MR3z6Ex1hmv/
        +7YMl+AR6hKxqNGv7qB4vU7S100wsw==
X-Google-Smtp-Source: ABdhPJxo73u/GDKgvzmEGa3Kz5M0ivznta+Uq2wKrhjoYFZElebpQhMRGmqH47EDnWdis9IChmmcwg==
X-Received: by 2002:a05:620a:c05:: with SMTP id l5mr18578612qki.457.1636826725089;
        Sat, 13 Nov 2021 10:05:25 -0800 (PST)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id j21sm3913727qkk.27.2021.11.13.10.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 10:05:23 -0800 (PST)
Date:   Sat, 13 Nov 2021 13:05:20 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Mauricio Oliveira <mauricio.oliveira@canonical.com>
Cc:     Nikhil Kshirsagar <nkshirsagar@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: bcache-register hang after reboot
Message-ID: <YY/+YDSjdZPma3oT@moria.home.lan>
References: <CAC6jXv0mw4eOzFSzzm0acBJFM5whhC=hTFG6_8H__rfA6zq5Cg@mail.gmail.com>
 <YYwn1eT86dvSRfeA@moria.home.lan>
 <CAO9xwp006wLDLVAoCPFgp_ogLiCunB8F8rHh9UitXqSmtNqLoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9xwp006wLDLVAoCPFgp_ogLiCunB8F8rHh9UitXqSmtNqLoQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Nov 11, 2021 at 05:54:18PM -0300, Mauricio Oliveira wrote:
> Hi Kent,
> 
> On Wed, Nov 10, 2021 at 5:13 PM Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
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
> Thanks for the clarification and suggestions.
> 
> Would it be OK to implement that workaround if requested by a sysadmin ?
> (say, to ack the data safety / crash risk)
> 
> Right now the issue is known, reproduces with v5.15, has no good solution,
> remains after reboot, prints hung task warnings continuously, and prevents
> using the device at all; and this workaround requires kernel dev/build skills.
> 
> Since its effects seem bad enough, it would seem fair enough to provide a
> way out even if it's not a _good_ one.
> 
> Say, we could try and detect the journal full during journal replay, and handle
> it by failing the device registration. This would unblock the tasks, and provide
> a more intuitive error message. (maybe leading to the next paragraph.)
> 
> We could also add a sysfs tunable to skip the call to bch_journal_meta(),
> and allow the registration to proceed, but fail it unconditionally in the end
> so the device isn't used with data safety / crash risk
> (or force an automatic unregister + register again w/ bch_journal_meta(),
> and disable the sysfs tunable).
> 
> This would help with the full journal, and allow a sysadmin to perform the
> workaround without kernel rebuild and reboots.

I think the best solution might be to change bch_btree_set_root() to check if
we're in journal replay, and if we are, make the call to bch_journal_meta()
nonblocking - pass it NULL instead of a closure.
