Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FF42F016E
	for <lists+linux-bcache@lfdr.de>; Sat,  9 Jan 2021 17:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbhAIQWB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 9 Jan 2021 11:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbhAIQWB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 Jan 2021 11:22:01 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBBAC061786
        for <linux-bcache@vger.kernel.org>; Sat,  9 Jan 2021 08:21:20 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c13so5551462pfi.12
        for <linux-bcache@vger.kernel.org>; Sat, 09 Jan 2021 08:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mjEHFalIIEItGJAOPep0ageUbDkcTaW2RlpMs/tn1ZE=;
        b=Dw5sp9jpqgebmGbrxGSfEFBvMpxjqcNy1O3GssH1G7FxTXI6Z7fYUWgJHpndqM78Zs
         cmX3eNMjkuN6Zv/dc+Lzp2OojCG6OR+qzGHjwn3Kwhx3QDjALJtb5p7Dc4V5XY1HXGcs
         b2+niC0j9ZySQI+Jq0BdtB0xOWr12deerievSs3o8v+n/ra5ZuYqMcLalOwVWn25O4Ej
         5KV7dlRD3n+qepPb1dbeFQZd0Z5m+hCr/rrYW7xn7BmWC2TDAaokd0jQWLxVPstiYape
         o/oevbAwX81gGPMaVLpqMDoLY5A/RMrsthM93aFwzOapqmGRxnhVo6oMbTa5A/Eo7mQo
         F1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mjEHFalIIEItGJAOPep0ageUbDkcTaW2RlpMs/tn1ZE=;
        b=mE7FKFvkZJ2XWSQLsUhhBHRft4vvCbxo4wX/7b5iBPoEH8CSIqZml7ugaIuWIyvqD6
         dFQCDUoD/1olHjwekFOacONG/RKphNd2q5JXnMJhV7qKhkP++5IsXD08VWljvusiYMTd
         vPRyq4gxL1GtFPPqID32iVObANlEwcLS09aBDNCCjNkG454vLuLYNP/J7xBLdAkpid6Y
         p/ot9ww4XsjBtSLRLRIS63Ja7r53m8C/1BGYPGB6fCvh4iw+kTjkIilUJ/kfKoHrLFo8
         arYn/b2byklBqnFyEEfNin6w7agOqb7zClPPOIZICIjaKsJPH7/9ju2hOytNJ8pauF3u
         vKXg==
X-Gm-Message-State: AOAM531dIyjN/Xn4cX8xzIU3gLcZcKoZiD50kFP9iZ8Y3rpHHTOqyEJo
        v++wChyz8UP7cBn0NwWH7Lr9wg==
X-Google-Smtp-Source: ABdhPJzKxybHaIoZNUzJxMOrJ/5glxC1qKgRvZCORlG+LCtkFdRMtoAr0uIQFWRsxQg2SRp717+eZw==
X-Received: by 2002:aa7:9357:0:b029:1a5:43da:b90d with SMTP id 23-20020aa793570000b02901a543dab90dmr8987669pfn.54.1610209280254;
        Sat, 09 Jan 2021 08:21:20 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 6sm13403529pgo.17.2021.01.09.08.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 08:21:19 -0800 (PST)
Subject: Re: [PATCH 0/5] bcache patches for Linux v5.11-rc3
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20210104074122.19759-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <32e3eec4-9371-cb5e-5fc7-0cd46dc6b5af@kernel.dk>
Date:   Sat, 9 Jan 2021 09:21:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210104074122.19759-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/4/21 12:41 AM, Coly Li wrote:
> Hi Jens,
> 
> This series is not planned but necessary. The four patches from me fix
> a bcache super block layout issue which was introduced in 5.9 when large
> bucket (32MB-1TB size for zoned device) feature firstly introduced.
> 
> Previous code has problem on space consumption and checksum calculation.
> These four patches improve and fix the problems with on-disk format
> consistency. Although now almost no one (except me) uses the large
> bucket code now, it should be good to have the fix as soon as possible.
> 
> This series also has a patch from Yi Li which avoid a redundant value
> assignment in a two-level loop. It is cool if we may have it in 5.11.
> 
> User space bcache-tools are updated for the above kernel changes too.
> Please take them for 5.11-rc3.

Applied, thanks.

-- 
Jens Axboe

