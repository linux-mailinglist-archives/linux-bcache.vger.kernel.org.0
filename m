Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B627C281CED
	for <lists+linux-bcache@lfdr.de>; Fri,  2 Oct 2020 22:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgJBU3Y (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 2 Oct 2020 16:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgJBU3Y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 2 Oct 2020 16:29:24 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9CBC0613D0
        for <linux-bcache@vger.kernel.org>; Fri,  2 Oct 2020 13:29:24 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l8so2901634ioh.11
        for <linux-bcache@vger.kernel.org>; Fri, 02 Oct 2020 13:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+43azacrszXaJZE4tAWv17/zXnM0+9G1SeNbkNsAJqI=;
        b=k+pqyndRWPOHK5PXMx7ywsEbyOub5RRMmbLgmlywTJaYmiDD/Y0NAHAXgAwr+m7yhe
         FTxISuOXWCyjCdLZzJl/5W8C5TMUBp+QF0xUA8YlfX4Zpnq9Pj/EVHuLeXRKuvHPmxOu
         vumJsu4bv71Oa0k7Qnim6RHiAJhx1nN0OTcSadE8VwPCYQ5g+OEbgy8gmWCMD3cKg3AJ
         ClqximQZqkcQcBO3JgFAyPDlSQKKB0wDC/TIrgfpxyIshVfHWXi1d4/WrNHsILXm5Qwk
         Xfl29A3vn9DNIRXV6yxJvZwipSmx/26tK0k3ayqDJ/a5cXB+vQ2Y7E+z7YO0qt5Y/qTN
         UDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+43azacrszXaJZE4tAWv17/zXnM0+9G1SeNbkNsAJqI=;
        b=YiXg0l7Iq4YKahfKZOiC4wCa03aGQEwhq/3Wy5RrTcz9uFpI4ObF9aI4kbSeVpZo1d
         /idyuxDQAj9zhlwtJ1LclykckMbODPLEoBHpGC/YYRiYzhhABmsrWFHVLCUEH8LonxHg
         ohJ4otvPt0nA4awGEFDK6j6axTiblqgib3rK4kivNtI7iY999+AjnGsWjqmYa9+JJf0N
         y7kMppNLWF8xMCcTrnaCRsS3Gktr+GT+2igkmpfgtGfNfO8eNJAzCDd11cMEyJXijX7c
         epQ3SH7sIpfnEN5kK02m5ZnLS23RR0xm/P3r3aLpfH2Qs95acRLtjjGUh7wqsZzFd8Kf
         BFHA==
X-Gm-Message-State: AOAM53096q1RNr8jGX2D/HQ5l7wp0CX3AkNzaMHv33UqKPOdtX5H1NMK
        1lnKUcs9cX4etlLTuv1uVwkUdg==
X-Google-Smtp-Source: ABdhPJwiPCxWx4+wvdiGtHkxh2ha4S06WYXc+9By+kX79clLRtqUEb8EXe4nJq+y3N19zqpu2FYWnA==
X-Received: by 2002:a6b:660b:: with SMTP id a11mr3203810ioc.144.1601670563392;
        Fri, 02 Oct 2020 13:29:23 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k198sm1360386ilk.80.2020.10.02.13.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 13:29:22 -0700 (PDT)
Subject: Re: [PATCH 00/15] bcache patches for Linux v5.10
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20201001065056.24411-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <74b67325-cbb7-8039-f865-dfeacb548ba9@kernel.dk>
Date:   Fri, 2 Oct 2020 14:29:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201001065056.24411-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/1/20 12:50 AM, Coly Li wrote:
> Hi Jens,
> 
> This is the first wave bcache patches for Linux v5.10. In this period
> most of the changes from Qinglang Miao and me are code cleanup and
> simplification. And we have a good fix is from our new contributor
> Dongsheng Yang,
> - bcache: check c->root with IS_ERR_OR_NULL() in mca_reserve() 
> 
> Please take them for Linux v5.10. Thank you in advance.

Applied, thanks.

-- 
Jens Axboe

