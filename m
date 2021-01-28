Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F04307836
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jan 2021 15:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhA1OgI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 09:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhA1OgG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 09:36:06 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C10C0613D6
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 06:35:26 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id jx18so4412281pjb.5
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 06:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+iw74D6kwkV2/01b/gOAeHsEBAoEbZ0PHlHz6VLO6IE=;
        b=V9XDxIHAdMoU5T5MKAy4pizmltrUjWIvT2qlTEzrPOxHOgWfPSRhmY2tMcQ7tUpdtX
         yymXutlkvUKbAxH0w2JrfQr6sy3LgXuFEXxDM3gPCZgPayDMKKVlyonUOM11S+CcZ1Jh
         xACbeHRvhDHemi4qeDFmUDHNe/cbDKKirvrJqKZbH5Q1hd6FdjnkHN85/2zYjvzRRUVq
         x41HPic7uLmIHzaew0lEqoeSZiGe7CqwdW3C6lmhgruSkPrxhqqC0FvuOrpet6ESV0xT
         gURukbksXMTruI6CmD8h8IAD+gNJ6Lgm/wVkuc+jVbkNge+H5+v8p1ybxK1dQJANQRdn
         bdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+iw74D6kwkV2/01b/gOAeHsEBAoEbZ0PHlHz6VLO6IE=;
        b=XPDUr1CRSrfF8wiOHH1OlpEMr8ocbMt8oTDVdM/GlQNLesgDQgR/x4yVIarHhtURlf
         xcPck15ZKXda4ZmK+Qkf6I7hb2Y4t/rU1/eSEMXuqUZDpB7E+qsmKwVN0x2BfBk942Ly
         IC+Zhdve1Pcrp+z+zGUb1dQ/xXodPlc5UExI6pIxs2jGlvoPNSuAiCNkH6nuE80tQwtV
         Qw7XmAv7tiimD41cU45uIGNP8txzKtuwT/ZHG+erjubFPm/1bLhEuURnKrFHzVQhO5fo
         tmTZ6+wYWBKTKve1+HZC1Qy4ap1/YESMBv+ePVZaHP3sztX7cjki5Yf2B2fx2ZhxF0pc
         c7EQ==
X-Gm-Message-State: AOAM532OnhVVDUPKa68hspnfbYjRJxNdR5ujB5RYeq2ZSjWTB1r2500w
        PduuwP9Ra3jOHw+rFgyW0Ez8qA==
X-Google-Smtp-Source: ABdhPJx0UHo847QBEMRkQRZakA65Owwf8bw4LgeF+4QcdcUSFYrREWCyzM2UMARkbl3yyG4l8Sf3ww==
X-Received: by 2002:a17:90a:de10:: with SMTP id m16mr11642090pjv.6.1611844525983;
        Thu, 28 Jan 2021 06:35:25 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id w14sm5353718pjl.38.2021.01.28.06.35.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 06:35:25 -0800 (PST)
Subject: Re: [PATCH] bcache: only check feature sets when sb->version >=
 BCACHE_SB_VERSION_CDEV_WITH_FEATURES
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        stable@vger.kernel.org,
        Bockholdt Arne <a.bockholdt@precitec-optronik.de>
References: <20210128104847.22773-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f7ca907e-abe4-d103-d818-c62dffa04987@kernel.dk>
Date:   Thu, 28 Jan 2021 07:35:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128104847.22773-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/28/21 3:48 AM, Coly Li wrote:
> For super block version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES, it
> doesn't make sense to check the feature sets. This patch checks
> super block version in bch_has_feature_* routines, if the version
> doesn't have feature sets yet, returns 0 (false) to the caller.

Applied, thanks.

-- 
Jens Axboe

