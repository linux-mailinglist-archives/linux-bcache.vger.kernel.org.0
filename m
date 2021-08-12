Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03A93EA88C
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Aug 2021 18:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhHLQax (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Aug 2021 12:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhHLQax (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Aug 2021 12:30:53 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0658C061756
        for <linux-bcache@vger.kernel.org>; Thu, 12 Aug 2021 09:30:27 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id bj40so11235103oib.6
        for <linux-bcache@vger.kernel.org>; Thu, 12 Aug 2021 09:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x4cHlQi/obhutO8LyeLFAXruEbBUWhCtJGxWE1s0N8U=;
        b=1rQ0mvustmtHXZ9U4L7gESxZbbqf2omo6y+0DkbXfIM5f7jDR1C54mTtLi+VBRe8Ri
         eKlcSaEDchw6I1SlloYW3zJh04HuTIYO+Q882Jty+7he4kk9+5qPwRsQsLOZVeMjMIsc
         oi3ti9jbeFQ7J/hgVkb0EM50yCmk+wxySBnupMJHBjAM0Bx5zUYk34ix6PG4vi9yZ7oa
         d48PgHNqKN03IFkifLYQ62bUSU7YhdJZ0I9vvA5ZLVJIw2JCm7DusCjxWeO87jlAh9zg
         oSC9fDh0NRkzMVe+Tlv05IDtO33QLAZpSejO9BUjaeTjO8bYFsIpetOwwMJGZLXPeFsA
         N4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x4cHlQi/obhutO8LyeLFAXruEbBUWhCtJGxWE1s0N8U=;
        b=Arj+vqsgwvLLa4e5eTj1jTBAVT4QGO7jX/yI4PpoVLWsC1EjjoGTAR36p599cjm6AI
         tGIGhghSdE9/PrhDLVDcDMpbCRwAfBPExgk9qC1CPGY7yp2jGy2bX170o9sxhH35JX6Y
         neCBZjgj6GxE19woF6u/3whvES3OTl4GznHMfzaYKKpkSp4ggHONlcq5YowSGiaSZItt
         PazP42U540fXUn9nxflGqE8RHIsMoqmistdo6i11UnK0Yy3aKvQtELfb936oODEQyWrf
         i1vrAe00+pC9OCYz4ZtJXXhyV0gQYMDCcpGx5TqEaXSG7OGFRSOAtLC1M6JRWk51RSf8
         TTCw==
X-Gm-Message-State: AOAM533ZhTvxhQrokl7EBUQH28Kp5Z1E+s/TfBIwS3fJAs+ddyFTK7SG
        t633y+APnkduI+vN/iZmk4QSRw==
X-Google-Smtp-Source: ABdhPJy2dkFA+KnUiS1sS6pKuw2wcOYGZn612cKtDfh2S9ahMGuS9i7oBMQNyXf3JaG+igFZLuxRCw==
X-Received: by 2002:aca:1c0a:: with SMTP id c10mr4010067oic.87.1628785827272;
        Thu, 12 Aug 2021 09:30:27 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m9sm637634ooe.32.2021.08.12.09.30.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 09:30:26 -0700 (PDT)
Subject: Re: remove GENHD_FL_UP
To:     Christoph Hellwig <hch@lst.de>
Cc:     Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org
References: <20210809064028.1198327-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <477bcf09-1711-b643-85b2-e8f0809b6dda@kernel.dk>
Date:   Thu, 12 Aug 2021 10:30:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210809064028.1198327-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/9/21 12:40 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series first cleans up various drivers to not rely on the
> internal GENHD_FL_UP to decided if they need to call del_gendisk
> and then removes the flag entirely.

Applied, thanks.

-- 
Jens Axboe

