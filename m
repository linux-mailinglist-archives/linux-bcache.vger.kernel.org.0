Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADDC2E1F6E
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 17:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgLWQ01 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 11:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgLWQ01 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 11:26:27 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABCBC061794
        for <linux-bcache@vger.kernel.org>; Wed, 23 Dec 2020 08:25:47 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id c12so10624919pfo.10
        for <linux-bcache@vger.kernel.org>; Wed, 23 Dec 2020 08:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FCNtsZYBFLDT8cP1bh+6isWEIlEdtCc9b+ja9RvHmTE=;
        b=PJAYCnEwqVQvC1oI3hhQpDH9apfycos6rpUuLunhJzxN0h2SvtM51UBhsD8V4PLCBs
         rDGxoPVyo/rA3WFHIwWoLbfD8UwmwOQE5uoZ8Ntx6YGLCvQxLxpH4boqLtWJ3zjQtmy/
         Qky+LtpGthhFPHywz3m/yYeXLolQjIfQ1LPvDNdEYO3CInEaYPoX/5uan+00i5x4Nb3t
         GBdGzBfkDyMGxtF6KYgByQW6j/tVziGi2ibr2qE2HIsZDaHEvckUgU/GPKjW3YQMkam6
         1L5KuBr4lhjVVtBmVQbFg+5z9tnYgIz3x/fmlLVYtD2/Jmnqn9foprfzhbyChc+oFF4C
         LaUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FCNtsZYBFLDT8cP1bh+6isWEIlEdtCc9b+ja9RvHmTE=;
        b=Oj5j+jIrJ5F+50jWh1LKhZKBYybl5glEnOq/f+hXDmBirqDynQCA/TzePI61lhV+Y5
         Hi5bv1qSQza0BlX0Ww2eTuAUgvv5mk1o3CDvW5lLXNWuNaqO5vxqoUAYt/3hiHUQW8+J
         ZZKY/0bFAzOMH+ccYx9OZUZDbN/coA3FqLBI1ocHchH9B5Ek72I6CMFONR7yI9jlKnJa
         smPVOhoxinBHKICHM9a412FSbMCvRuxDsdFDEO8acdGE4eGHEBecoiLzqpy7BXKMpbHY
         pzP6+/gTc7NcE0sBhrHhMTuBvc4eVOLyORwwxKqZ1zHXLhvTg6Q/KuKOCwbCDmOFo3hq
         Eziw==
X-Gm-Message-State: AOAM533ownnIJ5bO/8BqQtGtsf7eiXTx1gv/qUd1HkFrS9XrtqPHgZp2
        6e1rfIaEbVyZObHmGqBMqDZ2t1MVcO7lxg==
X-Google-Smtp-Source: ABdhPJwTdNDn7R/hReho8BPBuUGavwmnVredKSMtoQo4DQXNkNRCEm9L73NLyFIYuRXNHF7qiU2IuQ==
X-Received: by 2002:a63:f512:: with SMTP id w18mr25104185pgh.154.1608740746859;
        Wed, 23 Dec 2020 08:25:46 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z2sm13717758pgl.49.2020.12.23.08.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 08:25:46 -0800 (PST)
Subject: Re: [PATCH 0/2] bcache second wave patches for Linux v5.11
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20201223150422.3966-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <566237e3-2086-e143-f9dc-c29edc6e8aba@kernel.dk>
Date:   Wed, 23 Dec 2020 09:25:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201223150422.3966-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/23/20 8:04 AM, Coly Li wrote:
> Hi Jens,
> 
> Here are the second wave patches for Linux v5.11. Especially the patch
> from Yi Li is a fix of a regression in this merge window.

Applied, thanks.

-- 
Jens Axboe

