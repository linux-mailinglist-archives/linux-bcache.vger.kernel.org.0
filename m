Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAA5333041
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Mar 2021 21:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhCIUuf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 9 Mar 2021 15:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhCIUuU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 9 Mar 2021 15:50:20 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF15C061760
        for <linux-bcache@vger.kernel.org>; Tue,  9 Mar 2021 12:50:20 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id k2so13446064ili.4
        for <linux-bcache@vger.kernel.org>; Tue, 09 Mar 2021 12:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T8Beol1vwvugLcX6dyhYM7QV2XmUWY2CELTq49rlsJk=;
        b=D4CmLh/h2w/J1i0VPcOxlMFzEuqzUjkpZtNtGOHi/2VTPRS7Z4qe8S9++KSJqtONh2
         GOPmuiR+6JbHCGHAK13IqjCjXyDgT+XXLFglPrNmHuLwPgKTq7CqhnBpQJQ70AMRdJjx
         9AcgAFs/YLmF9GzqzhmbtkFISp6+3GH3IngohIJDFQBaAml64P+bL1kaBQDvjiHAD+nZ
         ylIvnP/ECzkcH6FTu/Eq8i3heCzxDc+WojQ+JLZxZg36GU20orXdHOUYWfHzCBedmaED
         sMWf4IbjzJFW7nkYDaVelbHDETMOt1gMYXO8haqGobcIHTaasa4OPllmCpVlfRC4Ix3c
         YTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T8Beol1vwvugLcX6dyhYM7QV2XmUWY2CELTq49rlsJk=;
        b=hTYdR463FBZySRd+UwVXGk//mjoLEsOZP7n+OhnDSA/NksF2gC5ZLNSARMQBRLU9Vv
         KJ/419+7pJq+5gWr0VaORMcQ3VS2jGVHIq62cm7tVlSzFd0EyMYn2XT5uniJ4arBG6Bz
         OwlecnMUieLjBniSBhn4CbuQJln14w2kJ+DTsLivcXWxLosVkPLDL+HIM7s9oGIpkMvy
         IkUUDzOfzIjyHkOxOcZEUIBv2ydNLSAOMzVBTYygQIyaAdw0CLjrSXfOupD+D9dafi3A
         d7vgrfVxcGjy/XedE+pxj2TGk+fQpT3LZhWUL9/6R5TQvCbzrC0dTA/hy7VM+Ceh6esr
         xgjg==
X-Gm-Message-State: AOAM530rm88ZG9VxGu0mbfRM12cn4pQkLxrCtOGemMWgAUB/C23qcjPZ
        xpFA67XGFUO+fzuIaqU+tsbCyg==
X-Google-Smtp-Source: ABdhPJzL4us6wU9N46CCAROdfi7JEXE1HxM1m4J4+Smd3ru46Jtr3H8nfy06m2kjHYjK9tiAsRTGag==
X-Received: by 2002:a92:ddd0:: with SMTP id d16mr45367ilr.52.1615323019838;
        Tue, 09 Mar 2021 12:50:19 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c19sm8079624ile.17.2021.03.09.12.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 12:50:19 -0800 (PST)
Subject: Re: [PATCH v2] include: Remove pagemap.h from blkdev.h
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org
References: <20210309195747.283796-1-willy@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b4d3285a-e1a2-1381-2bfd-ceeaf5ab55c9@kernel.dk>
Date:   Tue, 9 Mar 2021 13:50:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210309195747.283796-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/9/21 12:57 PM, Matthew Wilcox (Oracle) wrote:
> My UEK-derived config has 1030 files depending on pagemap.h before
> this change.  Afterwards, just 326 files need to be rebuilt when I
> touch pagemap.h.  I think blkdev.h is probably included too widely,
> but untangling that dependency is harder and this solves my problem.
> x86 allmodconfig builds, but there may be implicit include problems
> on other architectures.

For the block bits:

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

