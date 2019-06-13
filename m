Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEB043EBC
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbfFMPwj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:52:39 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:36725 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731638AbfFMJJe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 05:09:34 -0400
Received: by mail-yw1-f68.google.com with SMTP id t126so8047359ywf.3
        for <linux-bcache@vger.kernel.org>; Thu, 13 Jun 2019 02:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I2G6Z61Jyoq4eHQAlfAivrsm4bPEBXSycU3PSdmKD3c=;
        b=BEOrvrAllJlgLye4RFRyp82Ry/5b12FiLvgvqeLjUP0OeyMbkVjphwIi0hjfkSn3K9
         xjgNkqPSyCd1txp9qiMymZUR2TA03nbvNZtcZnYPHZipPejHYF3ESYKCb9+jjqBzsyl5
         poPWiJPd3tu6tDKpEURh0slrlhpdM1Phx4eUvJeHSUa0JkRp9JfZRc16PrDXoOfKYCQH
         svUTAUZLdoi1f+wOidpMtjFeZ5txG4c4APi+jAsN5lj0NZJGhk8WDmhnRS53/JCVWmj2
         YG6YdmF6agcVK+/l+GzAwpT5jiaWcTs6xfxWD/1kcYELMkpdx6lypsLxySlU9rPUmX/B
         P9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I2G6Z61Jyoq4eHQAlfAivrsm4bPEBXSycU3PSdmKD3c=;
        b=fp3vYAegK/lbQJW1jYW4ICw39cKydRU2Fy24SVssFBgm0uz+FErMgX9ryOjnnvQjcG
         fZ+EB1c4EsyemgEUKIKHCR9fbxUrTxKXoc4397IM0ODWX/Nv/vxeTgnzb0NhRnR18vkg
         Mb0ZN6ZQFVf1+0LybzHgMF2inq9xs9eFbGWSAEOlDqgVbgew4SOntuJnfei2Y11TSqEv
         Tc2Expz2COPUwRc8pU9MbGQ/983v4Mk+RTvB5L5ranibwn2TW2RMsGJnsDKD8/ej544l
         jwc5s1iZTL6hE6sAp3DwTpeukkD8C7/G+cbD2ffoXVMYpez/Tx+TwdcmKc1FpMijgWKB
         VUZw==
X-Gm-Message-State: APjAAAWMQgOkrDfwQ4NAnHXugonQYrtgbpMAZ+tkEQTJ7N6nd/uls+uI
        0lDYELuA3wgZN0xuk5JQbwQSwQ==
X-Google-Smtp-Source: APXvYqwSHFGr3kSToQZDrgRpOoOeojYZKZNmb5DDY0s4RCXOutEi7OxzS9r8u5+ecnrWkLOfV4LiBg==
X-Received: by 2002:a81:a18b:: with SMTP id y133mr34060650ywg.239.1560416973175;
        Thu, 13 Jun 2019 02:09:33 -0700 (PDT)
Received: from [172.20.10.3] (mobile-166-172-57-221.mycingular.net. [166.172.57.221])
        by smtp.gmail.com with ESMTPSA id x85sm1123231ywx.63.2019.06.13.02.09.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 02:09:32 -0700 (PDT)
Subject: Re: [PATCH 0/2] bcache: two emergent fixes for Linux v5.2-rc5
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        rolf@rolffokkens.nl, pierre.juhen@orange.fr
References: <20190609221335.24616-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d90c5b6a-f55a-abeb-fa2f-19e3d0e3b42e@kernel.dk>
Date:   Thu, 13 Jun 2019 03:09:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190609221335.24616-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/9/19 4:13 PM, Coly Li wrote:
> Hi Jens,
> 
> Here are two emergent fixes that we should have in Linux v5.2-rc5.
> 
> - bcache: fix stack corruption by PRECEDING_KEY()
>    This patch fixes a GCC9 compiled bcache panic problem, which is
>    reported by Fedora Core, Arch Linux and SUSE Leap Linux users whose
>    kernels are combiled with GCC9. This bug hides for long time since
>    v4.13 and triggered by the new GCC9.
>    When people upgrade their kernel to a GCC9 compiled kernel, this
>    bug may cause the metadata corruption. So we should have this fix
>    in upstream ASAP.
> 
> - bcache: only set BCACHE_DEV_WB_RUNNING when cached device attached
>    There are 2 users report bcache panic after changing writeback
>    percentage of an non-attached bcache device. Therefore I suggest
>    to have this fix upstream in this run.
> 
> Thank you in advance for taking care of these two fixes.

Applied, thanks.

-- 
Jens Axboe

