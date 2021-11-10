Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E0944CA49
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Nov 2021 21:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhKJUQC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Nov 2021 15:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbhKJUQC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Nov 2021 15:16:02 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68433C061764
        for <linux-bcache@vger.kernel.org>; Wed, 10 Nov 2021 12:13:14 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id az8so3700243qkb.2
        for <linux-bcache@vger.kernel.org>; Wed, 10 Nov 2021 12:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XTOQPFNntGkXmoSsXX+YZRRze6SY7GDGFf1pb8c/g4M=;
        b=MJJYTSpVZn/Dn1Bq6FZ7/HniJmJ2/GG7KqMvIsnf8aibYDfizltp4Si3opzFOWTHPP
         Y5Q3cRs4DEk0H8xR9b/mpDfC1EDzKDO+9BZCnseZ8zeaai8wES1l4awbb1mOXPjk/ILf
         qAdbEGMw4ZsIradY6iIGl/VucEuY7jPjtB2fCC3gCoGwDu9atPPB12uDB16ddG0KgR41
         B5qc0tU6On/LBqy9teFAGPkSjo3UXoVrrVNYcau364aEDLk/hoNMACyYbPKkraZ3z8og
         eeSmID5m1KL1kaNER+dkoTgTGI6en38w+RnLeUGx88wzpueotpqhu4a1fJJxmRmcJ4Zh
         i39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XTOQPFNntGkXmoSsXX+YZRRze6SY7GDGFf1pb8c/g4M=;
        b=z4lSFNRge0TqBw7Xp2frwcCbOSXiLs+G/bm+99xgvHTA/T3eek2wURA7QXPdSJdAAi
         em5HCXTHOGm2iZdL16616l30JFsBigVE0PpS52lXeF9G6GorrhT5AW0A/pc1Y/qmryrH
         Icb2MHCHBdl5E0aLtiXdI0B79Ek4Ia+HOG1hrscq0421/cR3Le+Wm6FHuqIe5gsthw6D
         55GpmqAwXPviDEiw0aQodKr/wZLEamZ2o7zfICaSOSc+jOdzBB7cZZEn0n9anWW5578d
         r520j7QlMqL7MBlkBV6GJVN4Yfsg730iGgB3k5jbr7xSCRNjV/KyoqY8ecxL5x7BvM8T
         7PWg==
X-Gm-Message-State: AOAM530Gr/6FgJg7UdIFqK0h6TcpjP6SHCn6EZiGkh3APLVLbwd+HNeZ
        0Gex2lyQnXqxv4tCU8L2Bg==
X-Google-Smtp-Source: ABdhPJxvD6UvMt6L0aZWEU5yK2hVr33ExU/ZO30ApyW32RX8FwL9Y4jtVBocy9eUgoPUEQtOvxCfmw==
X-Received: by 2002:a05:620a:113b:: with SMTP id p27mr1789105qkk.33.1636575193529;
        Wed, 10 Nov 2021 12:13:13 -0800 (PST)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id e10sm488392qtx.66.2021.11.10.12.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 12:13:12 -0800 (PST)
Date:   Wed, 10 Nov 2021 15:13:09 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Nikhil Kshirsagar <nkshirsagar@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: bcache-register hang after reboot
Message-ID: <YYwn1eT86dvSRfeA@moria.home.lan>
References: <CAC6jXv0mw4eOzFSzzm0acBJFM5whhC=hTFG6_8H__rfA6zq5Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC6jXv0mw4eOzFSzzm0acBJFM5whhC=hTFG6_8H__rfA6zq5Cg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Nov 10, 2021 at 11:14:41AM +0530, Nikhil Kshirsagar wrote:
> Hello,
> 
> After a reboot of an Ubuntu server running 4.15.0-143-generic kernel,
> the storage devices using bcache do not come back up and the following
> stack traces are seen in kern.log. Please could someone help me
> understand if this is due to a full bcache journal? Is there any
> workaround, or fix?

Your journal is completely full, so persisting the new btree root while doing
journal replay is hanging.

There isn't a _good_ solution for this journal deadlock in bcache (it's fixed in
bcachefs), but there is a hack:

edit drivers/md/bcache/btree.c line 2493

delete the call to bch_journal_meta(), and build a new kernel. Once you've
gotten it to register, do a clean shutdown and then go back to a stock kernel.

Running the kernel with that call deleted won't be safe if you crash, but it'll
get you going again.
