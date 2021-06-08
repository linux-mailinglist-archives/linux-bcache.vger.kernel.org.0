Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FC03A0587
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Jun 2021 23:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhFHVIv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 8 Jun 2021 17:08:51 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:40628 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhFHVIu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Jun 2021 17:08:50 -0400
Received: by mail-pg1-f170.google.com with SMTP id j12so17566427pgh.7
        for <linux-bcache@vger.kernel.org>; Tue, 08 Jun 2021 14:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rTsMdC4BXmfgTF7pG31W014xkPHrZAxJCnEYouFG+gQ=;
        b=oMzG0SfeYUnoGEuhJHQ7htz2XgVPAaGjqbJCsNrsjv0VT/wTC6by508zL98Ft+ChNL
         YJ3flE4tYQf42oFERX+vkSK+a1A5e4FDwYQxuFNtDDwNBoSr0N2mvxKytkLtUpU7uzYP
         cCJ7OGIf+41isZ2k+YShyaRwJv7hxwyaBHtqHPlKg5tCRB6TQBWf58QBiNkLGtLQdawx
         mzMrlPKtVgQqgY+3J9TPxWERH/iVjIoJCKCCU5CTjjS+L967Mhu/k+frrX4pWsD0reVX
         qZ1uRRRruSBovnL0kBpyCSxnp7Id1hloFaT2wzGWDYiWrFTykDalzKCkMJE8e3LIeJ3k
         VDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rTsMdC4BXmfgTF7pG31W014xkPHrZAxJCnEYouFG+gQ=;
        b=EYrFn8Os27GLluzftCfq4s5uzZOS7nE0Ds1Ylk3cnAK+z5yo6MPIILl37frarfEE+V
         bgSl1yZsKloouNnXrxWyBXt+XG6u4bMr9k1RE2XtJAOjpxZQyR9Esh/6cD/AtzHlM24a
         jVOk4G3prjTgIfv2jHAObnKsbJUn8COlUxSg634TtZ9zwFOJJb66NAqXAjyjeqDYDoA+
         xwCHLPf5xTv9XQnoqUAJJOdep9rQ/uNATQuONihg22kxc8Jy+dK9Z569wL3UFXnyUaHb
         WBf7oq5HukThfiVWjO6eqyEc33eXg+1xSuTGsiR9nb3+CLlxi8XQLJ62KcW0ABears2f
         DsWg==
X-Gm-Message-State: AOAM531MsThWYVzs1beULX9a5fkzqbVlnJn4jS0B1hKlYsta5vqPPobt
        /QptzKhHdUhYMvFVhluSJgGbzQ==
X-Google-Smtp-Source: ABdhPJxmIxuV54xftG6ihDeETBpL1x1bpTjcbMTDiFUjG1Hdy0sEIgM/suXMIB2EpZgu4yPgzkKiqQ==
X-Received: by 2002:a63:1349:: with SMTP id 9mr130994pgt.235.1623186357366;
        Tue, 08 Jun 2021 14:05:57 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id a66sm9471059pfb.162.2021.06.08.14.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 14:05:56 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] bcache fixes for Linux v5.13-rc6
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@lst.de
References: <20210607125052.21277-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <180599cb-7c2e-da35-96a5-225462c6cd71@kernel.dk>
Date:   Tue, 8 Jun 2021 15:06:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210607125052.21277-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/7/21 6:50 AM, Coly Li wrote:
> Hi Jens,
> 
> This series is important for recent reported bcache panic partially
> triggered by recent bio changes since Linux v5.12.
> 
> Current fix is 5th version since the first effort, it might not be
> perfect yet, but it survives from different workloads from Rolf,
> Thorsten and me for more than 1 week in total.
> 
> Considering many people are waiting for a stable enough fix and it is
> kind of such fix. Please take them for Linux v5.13-rc6.
> 
> Thank you in advance for taking care of them.

Applied, thanks.

-- 
Jens Axboe

