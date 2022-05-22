Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DC4530500
	for <lists+linux-bcache@lfdr.de>; Sun, 22 May 2022 19:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbiEVRnK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 22 May 2022 13:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiEVRnJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 22 May 2022 13:43:09 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DE939803
        for <linux-bcache@vger.kernel.org>; Sun, 22 May 2022 10:43:08 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id i1so11236117plg.7
        for <linux-bcache@vger.kernel.org>; Sun, 22 May 2022 10:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EfnEA+O5nIjrLI4sMBqJH1ChEsauuK1CZkXSDQaVoQw=;
        b=7gbkL1QhnCD9yCDSJ30BEVzu2O4Pt9jCh5zrIG3k0eIhFFeQqDaTyEol8UBGKiD66z
         V8KyLdKV17oZ1ATYqhFHx35abuF3Jl1HIj1kxmUDXhrX0x6p3NuJOb6hI/YIRdKIInV8
         BO8cCFrKk3miGDbWnHGXEPZDTom0HRvdENMi1aWQ7CuNyHXASlfMwyBCGeYcM132vIL7
         j3GB9cJ9qNuBovlPrhM72blglUhkdE2Ih8E6At/g8jnqgaGuT/nfqyfbPh5ROF3ZemEM
         4KAjXTKV4K5RyzkYSgmwVF6jlQCdoXaMz8Wg/f9fgcdmVC9q5Yuf0DKD5e12iN1TwRQd
         KBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EfnEA+O5nIjrLI4sMBqJH1ChEsauuK1CZkXSDQaVoQw=;
        b=nvnISsdVWRVp2uU4c6JcRb/DX6aIJ2rgRAUyHmEtG1HoHJKZAr+9qWqwIh1rQZPKA4
         bKElFNmgKMDQDxkA6niwq8ASHG0DiGYEkQ7BOEt04B25DXvlnsNuFuAQRxRzEIfMiix3
         rv7XSxCzn2hG2TUomBkL5VIkJqibkbHQDi8DEyFGK/A9Cv179gpfjLvNX8ZMlPjJgxyv
         5tO/n9AKMG5J2+o9pVaLAY6ccg6SvIUD/yrv8TggHGc15vlBq55+CT305joc+aN/MxeO
         mnOKPxH6x6AiZjHW2rSJuh9cBMNwX30tBs7sOyBw7o6zZPVlzEQBh3gjuzA8+z3eeFCb
         FkNg==
X-Gm-Message-State: AOAM530n8l+n8wo+pWgNd5ExcTsLPcKmQ6CIBJ9N2sDAKxiWqyjH83Hh
        IUM4mbFh/q1OuQBUA1KYRzRQznWvU67pgg==
X-Google-Smtp-Source: ABdhPJy334YvYjB7ZhmDp1PiuiIAlNpn7sSbzpy9NTOT9Iy1mrTyAx7wbaXG9SLZQGJ6ipjPUaafJQ==
X-Received: by 2002:a17:90a:688a:b0:1df:6940:e83e with SMTP id a10-20020a17090a688a00b001df6940e83emr21789008pjd.120.1653241387683;
        Sun, 22 May 2022 10:43:07 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z11-20020aa7958b000000b005103abd2fdbsm5475622pfj.206.2022.05.22.10.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 10:43:05 -0700 (PDT)
Message-ID: <ece7e00e-5d03-41c0-4013-75809958e9d7@kernel.dk>
Date:   Sun, 22 May 2022 11:43:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 0/4] bcache patches for Linux v5.19 (1st wave)
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20220522170736.6582-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220522170736.6582-1-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/22/22 11:07 AM, Coly Li wrote:
> Hi Jens,
> 
> The bcache has 4 patches for Linux v5.19 merge window, all from me.
> - The first 2 patches are code clean up and potential bug fixes for
> multi- threaded btree nodes check (for cache device) and dirty sectors
> counting (for backing device), although no report from mailing list for
> them, it is good to have the fixes.
> - The 3rd patch removes incremental dirty sectors counting because it
> is conflicted with multithreaded dirty sectors counting and the latter
> one is 10x times faster.
> - The last patch fixes a journal no-space deadlock during cache device
> registration, it always reserves one journal bucket and only uses it
> in registration time, so the no-spance condition won't happen anymore.
> 
> There are still 2 fixes are still under the long time I/O pressure
> testing, once they are accomplished, I will submit to you in later
> RC cycles.
> 
> Please take them, and thanks in advance.

It's late for sending in that stuff, now I have to do a round 2 or
your patches would get zero time in linux-next. Please send patches
a week in advance at least, not on the day of release...

-- 
Jens Axboe

