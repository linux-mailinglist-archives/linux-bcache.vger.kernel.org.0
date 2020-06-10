Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CC01F5341
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Jun 2020 13:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgFJLdC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Jun 2020 07:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbgFJLdC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Jun 2020 07:33:02 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBF7C03E96B
        for <linux-bcache@vger.kernel.org>; Wed, 10 Jun 2020 04:33:02 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id l17so1588295qki.9
        for <linux-bcache@vger.kernel.org>; Wed, 10 Jun 2020 04:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dqXbCdAePNXrPcTH2v/20NMNpRfyJMJdk2FTZpXV81U=;
        b=V2OAVUmh2hlkA74Djd0j38MyijgsIh1VA1WQK4RVwVhsGd9QKuXjFpMnpgzwUh0Anh
         camwYXFzBUW7Uia0SwOGAQtgETzjIsGKsJ7A9a60t207eWfKdSUBi+1fkr8Ziu8kRIZT
         m7g5QyEKXh79zMikl9ODWBy/Sky98mSFxlyQ7K3eQoiukqeAqA3Pt9AcsRPIAXRQu+q3
         pM1swx7epJa0o8K5uVUU+GyAvSR0AGlGiR3gBXEChEqCDJmC40Y2a6XvMbiGlJXuPJPP
         s6FfPaxQK0CtXzmYbRT4DGbFcJUpEceaobWg8ZMMZXqgyOQu7TyIOTkvPPgN1ln6pmed
         +q5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dqXbCdAePNXrPcTH2v/20NMNpRfyJMJdk2FTZpXV81U=;
        b=Kj33wZ8iFpOQ0AmhWaihxBmPJnE/9Ay46jZyOcqw1/sjMx3solPS9inVL3AhTT4q0K
         /h3er/A5qNfMp3AjcpP2xP7hogJLXsEURTYGCXSIQqRNZFoerTBvCeQz0JuogqLY4zyC
         xumlADkb1p8VVjPt2EXDNJaygSzpQrOiwVksDT0ddl32unXOZx4RJFxeOAh29zPc3ap+
         H7mthFowZN95deI7VUOBTW6TVDFnOgANMu49z824BM2ds+TN4LxrD9w2rM7peabm+hSA
         bdoh0VPAjHFkJ8z8hC2qOQVzs60UF+DdIu92Xaad7NWozv+wrluDrRxDz4zegB6Yfj9C
         +fyA==
X-Gm-Message-State: AOAM532tb6C0IoDcrghUPw3XOW+bWqSVx1mfm68FYE+S4qwZPja43ySP
        a0xAU+p5fsUP5E6p20BfkGucmkk=
X-Google-Smtp-Source: ABdhPJw9y1+S3oTgCvrG4wMI2mUxVWmKO0Zk3kYjWpJOHbGgMrZDW/oAPBq9jI65Vp1O93voWG3NAA==
X-Received: by 2002:a37:7902:: with SMTP id u2mr2525897qkc.53.1591788779805;
        Wed, 10 Jun 2020 04:32:59 -0700 (PDT)
Received: from zaphod.evilpiepirate.org ([2601:19b:c500:a1:7403:986f:d31f:7f2e])
        by smtp.gmail.com with ESMTPSA id v69sm11774256qkb.96.2020.06.10.04.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:32:59 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:32:54 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Stefan K <shadow_7@gmx.net>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker
 merged)
Message-ID: <20200610113254.GA824770@zaphod.evilpiepirate.org>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <3828047.K31vBF4JiT@t460-skr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3828047.K31vBF4JiT@t460-skr>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jun 10, 2020 at 01:02:10PM +0200, Stefan K wrote:
> ... one year later ...
> 
> what is the status now? the latest update on patreon is a few month old.
> What are the blockers to merge bcachefs into the kernel?
> 
> I hope that the bcachefs thing will be merged soon.

Status update coming. Did journalling of updates to interior btree nodes a few
months ago to get rid of FUA writes and for other reasons and that turned out to
be more work than expected; still debugging the new btree key cache code which
is needed to fully fix recovery from unclean shutdown.

Main blocker for merging is the dio cache coherency thing. That and working
through all known bugs. There's an outstanding data corruption bug someone in
the IRC channel is helping track down. Bleh. Debugging is endless.
