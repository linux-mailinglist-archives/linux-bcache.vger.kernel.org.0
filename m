Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6C3552A4E
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Jun 2022 06:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiFUEfs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 Jun 2022 00:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiFUEfs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Jun 2022 00:35:48 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A151812ADD
        for <linux-bcache@vger.kernel.org>; Mon, 20 Jun 2022 21:35:46 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id l192so9226123qke.13
        for <linux-bcache@vger.kernel.org>; Mon, 20 Jun 2022 21:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vZIc2zl/B++o0M0+sKHeZn8CLBXmmG1u0TFYH2SjDoE=;
        b=WRFx30pB3UaIB0/WqINn+m/KSJvyaoXQsD0R1PmD02ZaFFC7A93OyoMrCMO1ESYtey
         KarRC2m5ldOMlYOJJpXQOhlIKrxdXJpzJwunUQvjLONTHlPTs91uUjz8byTsa1Ev+O0K
         mrUk2xYAkl1XiabgOzDvtHu5sZsPp0WGDdlFdxn8nSRW4JDMnBvMp2OEn5my+bMPzVnC
         K39IJST8rMwFZmgvSYZuGf4b13wsIlRTpVLBvli18bVLHTDRY7M5aMhaFqzyopWUuex6
         eQE5kG5zE6PLi/UHeEwqaEZ1NwgkAAZ07oxE1B1jnBSl/ICMBwo/j6M6n09fkCHJkReW
         bBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vZIc2zl/B++o0M0+sKHeZn8CLBXmmG1u0TFYH2SjDoE=;
        b=Q6BT8E1JRPxR/5z33IR2tg4ghKXdZEBryl+FEAa1xSeJay9Y1CUKY8SDC9wQFvpgi0
         dQ1SnLsPpYWEc6vJNDb0CgZazJtBNk6k4K20BWwapOGnJTAGDuCbIVQjVSpTbXOVFas3
         bSfyn6/9KaGdIChcPBs7jiDXSrrH5w6G4GQ/AWmiyqhGJkOINDIFPisnK5bamBCdg8lS
         +GLjL1BGthLynGhoJVACEx2U1Wb1vhZ9knjHu0Y+fJsNpfxuBZ0tJNuksNWlLi5/gyQi
         B3GBflgcMjVh36J6IFXwUftol10QWnjZYodYedpoTUmcf7f8EbPUj+LKc/1wK1Bn5NOS
         VNMA==
X-Gm-Message-State: AJIora9I4x4BEN8OvifxzYypCuaix51ig9F7Gdyhkj33NOTPnAJrEgHe
        EX/swZzzPZ05SMZli6sIIJjBdRk3kSAnRTE=
X-Google-Smtp-Source: AGRyM1tArbQxy4Z6d0+8L/LgUhXQAJ1A11mDlGGk+PuHHB39QStwP0qpj06MlipoCordzI7l35feZQ==
X-Received: by 2002:a05:620a:28c1:b0:6a7:6268:4f07 with SMTP id l1-20020a05620a28c100b006a762684f07mr18870340qkp.228.1655786145759;
        Mon, 20 Jun 2022 21:35:45 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id he21-20020a05622a601500b00304ee3372dfsm12026127qtb.45.2022.06.20.21.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 21:35:44 -0700 (PDT)
Date:   Tue, 21 Jun 2022 00:35:43 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Nikhil Kshirsagar <nkshirsagar@gmail.com>
Cc:     linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: Re: trying to reproduce bcache journal deadlock
 https://www.spinics.net/lists/kernel/msg4386275.html
Message-ID: <20220621043543.zvxgekvcs34abim6@moria.home.lan>
References: <CAC6jXv1hTHhPdZNOhbSOzQTW+pBfAXfpGkxJfjjBmS8bYaHfZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC6jXv1hTHhPdZNOhbSOzQTW+pBfAXfpGkxJfjjBmS8bYaHfZw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Jun 21, 2022 at 09:11:10AM +0530, Nikhil Kshirsagar wrote:
> Hello all,
> 
> I am trying to reproduce the problem that
> 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 fixes, but I am not sure how.
> This is to verify and test its backport
> (https://pastebin.com/fEYmPZqC) onto kernel 4.15 (Thanks Kent for the
> help with that backport!)
> 
> Could this be reproduced by creating a bcache device with a smaller
> journal size? And if so, is there some way to pass the journal size
> argument during the creation of the bcache device?

Change SB_JOURNAL_BUCKETS to 8 and make a new cache, it's used in the
initialization path.

Bonus points would be to tweak journal reclaim so that we're slower to reclaim
to makes sure the journal stays full, and then test recovery.
