Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01B52D1A7C
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Dec 2020 21:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgLGU03 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Dec 2020 15:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgLGU02 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Dec 2020 15:26:28 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4740C061749
        for <linux-bcache@vger.kernel.org>; Mon,  7 Dec 2020 12:25:48 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id 81so14643134ioc.13
        for <linux-bcache@vger.kernel.org>; Mon, 07 Dec 2020 12:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XSxnIDKWcmc0O/D/BAiNcqMFr/Q1xkYuolO3yfQcKug=;
        b=X0IPKpZt1mMWV5/EmNhHxPVsoaU+asFnzl66rcvKopkXQ+Dr9wEUd7huG5Sxfihn+W
         YsuX2I3+8um7A0f0rqhsBEjdvdGD0ElgqB1De5K13saBLU+697+Dgp82tFuAl9A3iSFM
         cVtbrC/t7L/NXe8OsWznLsdPK4WKLxJkXIhR+f5PMW4UEVT0gO2dp2u2/OynegwklSK0
         LsDimflFkrgTNtCII//nH+/e23F7kJIAl0bl4ZNnwLh92HRKC/K3hyGXmdF5L0mTdef+
         8W/R2n+5qkYzK19EFm2bPX4h6Hdsvm6kG8AOmRnHJb6qHY0oQyFLa12kEv8vB8R3qo5x
         NLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XSxnIDKWcmc0O/D/BAiNcqMFr/Q1xkYuolO3yfQcKug=;
        b=FpAoDJWD8QJql5B5LirfpUSDxQBJ9WRAF8FsTUxHf6EINQOtj99gN4VIS8g5fmYgs1
         qM7dXxKcq7Bqqbv15YyIwK/c/ofYH7RQhijHCF6NyxGntisBCkJahHgM6SHjn55r1zCc
         /WeIDX0JlRCCTR2qaOB/SjVc/RlqTBQjqJwDkJiTCV6595xXSJxRJDXj18odbR6c94GY
         BoM4/e1z4oBu3azXTvZMZtei7XJJduvyUPJpw6ImWPZb3APMDXD8JeOnV0Th3Xayqc8z
         +V2Im/sMH1n56Ag6sh4ynct3ynzHX7VFE0M4Vf4YXYphDNXTBGlZTu9kYgM/Fivb79ue
         GRcQ==
X-Gm-Message-State: AOAM531lIdXzSC0lvgKnyim5D0ZeHQiDS/JPbhRbY1hkgGyNRdCY9wjr
        VEgYVP+szpNNi8iiOf2eni6Vdw==
X-Google-Smtp-Source: ABdhPJwYB3CEe+LJBdyvrDK2hyXvqaMgSG3V8/dDvdhRxLOkWXF5HVD7ENXvS73eYN1zUYVdmSPsUQ==
X-Received: by 2002:a5d:81c1:: with SMTP id t1mr21544034iol.88.1607372748104;
        Mon, 07 Dec 2020 12:25:48 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l78sm8536115ild.30.2020.12.07.12.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 12:25:47 -0800 (PST)
Subject: Re: [PATCH 0/1] bcache: first wave for Linux v5.11
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20201207163915.126877-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8a7d64b2-61a1-353d-cac2-4dc6115edfb6@kernel.dk>
Date:   Mon, 7 Dec 2020 13:25:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207163915.126877-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/7/20 9:39 AM, Coly Li wrote:
> Hi Jens,
> 
> The first wave bcache change for Linux v5.11 is quite silent. Most of
> the development is not ready for this merge window. The only change in
> this submission is from Dongsheng Yang, this is his second contribution
> which catches a very implict bug and provides a fix. The patch runs on
> his environment for a while and takes effect.

Applied, thanks.

-- 
Jens Axboe

