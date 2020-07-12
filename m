Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1870221CB5B
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Jul 2020 22:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgGLUhW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Jul 2020 16:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729287AbgGLUhV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Jul 2020 16:37:21 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D50C061794
        for <linux-bcache@vger.kernel.org>; Sun, 12 Jul 2020 13:37:21 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id q17so4543008pls.9
        for <linux-bcache@vger.kernel.org>; Sun, 12 Jul 2020 13:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/nuEi5LSAR+BLYQ3M1VbbdXftovzZ8g7a0HCozi5Z14=;
        b=OKbsTsBjFpc2Q2RpjNItVv+FVfQd9DdK31sK2+p3JNMHwt1q+he7+lWvU0dJ6lQ5pY
         FyNrVK7DBeU3wgSpTq+PpurW0LFMIq2FaqSUR73fvsSD+VUlCF4F67yomf7csOm33DY2
         FilVSTqU5S6LDR5+1jOn1PUXuHjaw/28YUtIx4tkeFUFttTgv7jHUpsTjfq5KU4EZ6Z+
         JtVlGLVNSkS4vpVdGQ+0jSfP3Rm8y1TZLF7Pmph2+YGjy+udBCGPJBxgr4/h0P2LO3dA
         Ut1qM++ITGMc5j5d8XgFpmlQMPqXnzcKap1Sp+3WWXF4nzT84Y18CdJWB0Rk5m/d2vm4
         CtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/nuEi5LSAR+BLYQ3M1VbbdXftovzZ8g7a0HCozi5Z14=;
        b=HZ/h092puCEGj1SzNVFhF0gJaXWzBow60Nme7THCCBYrm9iQrvRpFUkyRy32pK33Nb
         0SwJ8QkTkWS9KAfm9tuJhCeIaztZztnxZ63+tzhwfjLcGc016IkXoLpphybYW/xzBGu6
         XFT6uW4Jy2rDrPe5WVSFfI1ZUqEd+kRh9VqfuI/IYMYA2xIrrq+GLgSV4o9r0ybtb8bU
         /P+LAoElNgLlguanYEBuM48ObQDNkjjg53uHl/JjPLXuGOTmdvXh0aUdEKquUTJNEqMt
         4F2Ro73581hEt+1J4HXhaHMuzqVtM36j/OcW+akYRFqrmIMpK5g5VCon/f2X+61/gz7T
         3haw==
X-Gm-Message-State: AOAM531CrSQgRac2kXYmTUmlHenxkd1qi5AdJzlKJzxP0w7UvLSrojrv
        xEOCH5P6MtafK1aEuY0z9GX5xQ==
X-Google-Smtp-Source: ABdhPJxJ5S6nNjHYOWkL5qX+tcJMU4wE4qGu4a14gg3IesW7UiP86NpYK+fA596DOp1xGeR1N986aQ==
X-Received: by 2002:a17:902:446:: with SMTP id 64mr23802034ple.157.1594586241283;
        Sun, 12 Jul 2020 13:37:21 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id nl5sm13018985pjb.36.2020.07.12.13.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 13:37:20 -0700 (PDT)
Subject: Re: [PATCH 1/2] bcache: avoid nr_stripes overflow in
 bcache_device_init()
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Ken Raeburn <raeburn@redhat.com>,
        stable@vger.kernel.org
References: <20200712174736.9840-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <010a5d09-5de8-8f1e-4ff5-3f194f899073@kernel.dk>
Date:   Sun, 12 Jul 2020 14:37:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200712174736.9840-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/12/20 11:47 AM, Coly Li wrote:
> For some block devices which large capacity (e.g. 8TB) but small io_opt
> size (e.g. 8 sectors), in bcache_device_init() the stripes number calcu-
> lated by,
> 	DIV_ROUND_UP_ULL(sectors, d->stripe_size);
> might be overflow to the unsigned int bcache_device->nr_stripes.
> 
> This patch uses an unsigned long variable to store DIV_ROUND_UP_ULL()
> and after the value is checked to be available in unsigned int range,
> sets it to bache_device->nr_stripes. Then the overflow is avoided.

Does that work on 32-bit, where sizeof(unsigned long) == 4?

-- 
Jens Axboe

