Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB55690DF5
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Feb 2023 17:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBIQIF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 9 Feb 2023 11:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjBIQH5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Feb 2023 11:07:57 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CD0A244
        for <linux-bcache@vger.kernel.org>; Thu,  9 Feb 2023 08:07:28 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-16346330067so3151519fac.3
        for <linux-bcache@vger.kernel.org>; Thu, 09 Feb 2023 08:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fohN0yuoKlARw5/tL47R05ejyIhJyIieWnmAo7IJguQ=;
        b=M8fkzkLH4tbgonPiHrlisv7PMk8CW/jdPUAjdPdvCyNKhpfB0i7ORcz696iLAICOzr
         pSasL+smlQPQvZOYerxjnUQKrkTWHZv/rqrtoNSmSajtrgXwRdB2aDsuM2XK3TevtnVd
         kvckaJWl11xaL8giKvRE5W14ay6ReJmiHWFW4epBD91su5C8n1k/mtc63H+iJB0CJY+B
         no7aNmPA99ELr9cEEqxtgEnq7bsb+ZtT1q2Zj0yBo7AmX3wBN608JD8+LlMOpw6tO7rQ
         OGaiZzhUqoOW+CVuNK1r8LaEVfrF7sC4vXSJ34nhcpVapVokm9RB+djL1lAyMMfVrApx
         TopA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fohN0yuoKlARw5/tL47R05ejyIhJyIieWnmAo7IJguQ=;
        b=cYFgrormfQBRoNlMStwho+pbMcEI5sS7q3inogzGtRabtKhWM9YFxrH3QRvTyBUCqj
         hlajlh4uxlHKI3mmhPxNoO1LgOQBJlbUZtX5GEDGpCfeG3ooD14cR2emmWm0RdPsXJ+s
         YhfdqWEUY7IQ+eGuyn16byv1uvzwURDLXChuAVvY2WK87g1KaIhIkFzAI27lnDXODP2R
         2IwtJh0xR6TICmbceakvNr2QzdckQIQgOBpCgJ+f2D2p9NX5cNbQ7kY2gck0Om5AmcIo
         sRQIo8TStGl10/uJcq3hf5RB6yEHWEGS+gFb4szd9T2Hgk895SBvT9O3ikXqefLBgoE0
         7ifA==
X-Gm-Message-State: AO0yUKXILGJ/MRoGK8vNHZTLaEv8+n4BJgW00F4DpYQRkg3igVZ11NY1
        GDB8Gef6zkkE+QtGt+qATIzJaRFTs19RmA+hilArPV529+u3TaTPpic=
X-Google-Smtp-Source: AK7set+1MLjH1vM2U3EGkjCTwB5WlvArvfZXrjfWgPW+L7iBhMEu/yyFHKfpyGgkPag2RnNO6frQwA72wLWeyF/h25A=
X-Received: by 2002:a05:6870:b6a9:b0:163:23ed:982c with SMTP id
 cy41-20020a056870b6a900b0016323ed982cmr738201oab.230.1675958847551; Thu, 09
 Feb 2023 08:07:27 -0800 (PST)
MIME-Version: 1.0
References: <LO0P265MB45742A9C654C2EB4EB3775CEEFD99@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
In-Reply-To: <LO0P265MB45742A9C654C2EB4EB3775CEEFD99@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Thu, 9 Feb 2023 17:07:16 +0100
Message-ID: <CAHykVA5ADwoio5Bhz3wLniufFNrOtT_fA4QR+DFr1EqbN2WpOA@mail.gmail.com>
Subject: Re: Bcache btree cache size bug
To:     benard_bsc@outlook.com
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Feb 9, 2023 at 1:22 PM <benard_bsc@outlook.com> wrote:
>
> I believe I have found a bug in bcache where the btree grows out of
> control and makes operations like garbage collection take a very large
> amount of time affecting client IO. I can see periodic periods where
> bcache devices stop responding to client IO and the cache device starts
> doing a lage amount of reads. In order to test the above I triggered gc
> manually using 'echo 1 > trigger_gc' and observing the cache set. Once
> again a large amount of reads start happening on the cache device and
> all the bcache devices of that cache set stop responding. I believe
> this is becouse gc blocks all client IO while its happening (might be
> wrong). Checking the stats I can see that the
> 'btree_gc_average_duration_ms'  is almost 2 minutes
> (btree_gc_average_duration_ms) which seems excessively large to me.
> Furthermore doing something like checking bset_tree_stats will just
> hang and cause a similar performance impact.
>
> An interesting thing to note is that after garbage collection the
> number of btree nodes is lower but the btree cache actually grows in
> size.
>
> Example:
> /sys/fs/bcache/c_set# cat btree_cache_size
> 5.2G
> /sys/fs/bcache/c_set# cat internal/btree_nodes
> 28318
> /sys/fs/bcache/c_set# cat average_key_size
> 25.2k
>
> Just for reference I have a similar environment (which is busier and
> has more data stored) which doesnt experience this issue and the
> numbers for the above are:
> /sys/fs/bcache/c_set# cat btree_cache_size
> 840.5M
> /sys/fs/bcache/c_set# cat internal/btree_nodes
> 3827
> /sys/fs/bcache/c_set# cat average_key_size
> 88.3k
>
> Kernel version: 5.4.0-122-generic
> OS version: Ubuntu 18.04.6 LTS
Hi Bernard,
your linux distro and kernel version are quite old. There are good
chances that things got fixed in the meanwhile. Would it be possible
for you to try to reproduce your bug with a newer kernel?

Regards,
Andrea
> bcache-tools package: 1.0.8-2ubuntu0.18.04.1
>
> I am able to provide more info if needed
> Regards
>
