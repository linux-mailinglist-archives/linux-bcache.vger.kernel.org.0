Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E5B3AEC1C
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Jun 2021 17:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhFUPQk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Jun 2021 11:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhFUPQj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Jun 2021 11:16:39 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54C2C061574
        for <linux-bcache@vger.kernel.org>; Mon, 21 Jun 2021 08:14:23 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id q18so15580121ile.10
        for <linux-bcache@vger.kernel.org>; Mon, 21 Jun 2021 08:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tsu7eDLoNDm5bb4H1/D+NsnNSYlHRlAHX6coAFFVuSU=;
        b=b3rb82PI+YEMnnS8yKwnGUJgdkHs6/3GNq3DAKs5pZXqX8QdriURpK51KVxJR44OIZ
         8e6tMcFQcmRkXsoAev0FlaJeq7oH/oD9XANXfzQHeGZx5/JEugdJRdbXXWmSaFPa3XKR
         i6JhxDev9UFkkFIjXX6LDP3XNEmfGYFb7uzVvpyLmYv0qdWsVtcG6tXelkSuF0cqSjfi
         PF2/ogBjOE/cxrbf75kurnOeGx4uCIbwyT0yhbvl1FKZgvbbg81Z8SHlYViLLowzWP47
         BJujuJgD4nZZ5ZMm08m/zFTKE5J0tApHf1701TnmgkeE3DaQc9IwYo9k/N2J1r/RijFf
         eCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tsu7eDLoNDm5bb4H1/D+NsnNSYlHRlAHX6coAFFVuSU=;
        b=NKaynhwBcF8/6O2jv718dh7TOMlpJ2qqD2BrPfE9rZsE8ieKgMI/dzqxECdBD/dXmW
         8cjzk6YaAqRuNVaynn6SvHAAFiK3PoZGFPFY1sowd1C0b/rJHVnAvmMgT98hoSYTeNHD
         xudw/ccxpLdFyVs0Bq92l5iA07g2kPkkrtJv5hXy93/j4H7iTxn3CQJ69TSpkGkiEbCb
         xuWlFxNuM2plP/UP+5auhnr7bJLpPDe1pJ5Fu8GBpQWMvP2nzd6VwmQ1bhOnz58m+x32
         Th2txGFcoRDv0m8FKBiNBPMXhK+VFUWva/xjzbrYBY9MaWHpbRpL6Js7lYuLhW1ov+gq
         PSag==
X-Gm-Message-State: AOAM5310zTYy03jXoDGefuxLgk2iq76bFFMoSOAKkEtkaMNLZCgRsRFl
        KgRO86vudg2qeL1wc0rKbrFCaQ==
X-Google-Smtp-Source: ABdhPJy88YRDcaFe0BKVZvue6TrZNXIZRKsNZz7WrsfoSF8Nm601LTC2PBCAKfusaOb0pfhoBu6qTw==
X-Received: by 2002:a92:c5a9:: with SMTP id r9mr17872497ilt.56.1624288463256;
        Mon, 21 Jun 2021 08:14:23 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u14sm2807443iln.43.2021.06.21.08.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 08:14:22 -0700 (PDT)
Subject: Re: [PATCH 00/14] bcache patches for Linux v5.14
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20210615054921.101421-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cb427b5f-8e55-bed2-1e3d-7382a092d4a0@kernel.dk>
Date:   Mon, 21 Jun 2021 09:14:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210615054921.101421-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/14/21 11:49 PM, Coly Li wrote:
> Hi Jens,
> 
> Here are the bcache patches for Linux v5.14.
> 
> The patches from Chao Yu and Ding Senjie are useful code cleanup. The
> rested patches for the NVDIMM support to bcache journaling.
> 
> For the series to support NVDIMM to bache journaling, all reported
> issue since last merge window are all fixed. And no more issue detected
> during our testing or by the kernel test robot. If there is any issue
> reported during they stay in linux-next, I, Jianpang and Qiaowei will
> response and fix immediately.
> 
> Please take them for Linux v5.14.

I'd really like the user api bits to have some wider review. Maybe
I'm missing something, but there's a lot of weird stuff in the uapi
header that includes things like pointers etc.

-- 
Jens Axboe

