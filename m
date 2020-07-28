Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47002230DA0
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Jul 2020 17:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbgG1PXh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Jul 2020 11:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730670AbgG1PXg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Jul 2020 11:23:36 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC9AC0619D2
        for <linux-bcache@vger.kernel.org>; Tue, 28 Jul 2020 08:23:36 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t18so16541958ilh.2
        for <linux-bcache@vger.kernel.org>; Tue, 28 Jul 2020 08:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F4Wsebso6IWC8aSQZbXXH5ooZdFajOtRRLZ4DaokWp4=;
        b=pKu+ivn1uOpQqNTDIQ1KY6QsdvMa8+DSGEMZGrbKfXulugnqrBwlXPUes12BmXvZq4
         fgPkcyKJ857iqq/EXdXswQOBbhAONGDc6Z/mwnWUoXPHVIIsOxCe46bCXjqc8pW8Vt6R
         BHpaJwPA3dpZm5WJme07DuvnBWkqIJIgtmAiGO9QiRx6z3XWuNG4+z4OpAVdfz/dtDYx
         83rvj+yRBtoLHdiA9eaMPosyaty/X9x8VH6FX58WK18zMkY4x4Mpn8fidJh+5OlCkn0K
         DWwFK/vx8NdSQ4WVrsLOZLs0/4vrxkO1F3HVVqVQWxazfw18/DYHZcOE8E1bgEcqJDk3
         CYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F4Wsebso6IWC8aSQZbXXH5ooZdFajOtRRLZ4DaokWp4=;
        b=U6z3bjHTXy45wyqGd+wUN7LFUsy1whbYSH3HeSbyNVstux+JQXeI3AFcdy7DOU38EQ
         0obHoMRn3xMHvthyCONxMVUJ/qVrm/dEsJwITHXWrQGDQP31q8Lz60BIIaIaw0Z/B6EQ
         J2W0GmBrPyhKsa5A2yz/tIeuXSerdpzsBrBAT94O8zBId1yaoezNBNumNGrpckld+6bD
         KrHGOTF8HKpeU4pRQwMnN4i7AJcPvADJ2KQfCjOf6wNrjR7XQ/H1uANrdtuvl1T66+SE
         WLInHL+Lwqrd936fk/ecPdyhhTdNEDb47KgjZf0pY2h1w/IBTqEf9WwWMGMXzOfmA9rk
         xX+g==
X-Gm-Message-State: AOAM5321ST4jW6+TbvNxkZ5gDufpV4FYPPLr10OE5ppI/1SXC+MUFSRv
        XISkzVRD+kKgPUBOVO9HQSgqXg==
X-Google-Smtp-Source: ABdhPJzUA/rPdjZE+tCi3vy8e9Z6IxJTfTdB3l1PLu8xq3p+qLhCLyEP8K2KM5/a58sm7uQwlDPAng==
X-Received: by 2002:a92:cc06:: with SMTP id s6mr28424185ilp.8.1595949816045;
        Tue, 28 Jul 2020 08:23:36 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l11sm6281065ioh.52.2020.07.28.08.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 08:23:35 -0700 (PDT)
Subject: Re: [PATCH] bcache: use disk_{start,end}_io_acct() to count I/O for
 bcache device
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20200728135920.4618-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <648c19eb-a718-a49b-37cb-d95ea78e831b@kernel.dk>
Date:   Tue, 28 Jul 2020 09:23:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728135920.4618-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/28/20 7:59 AM, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> This patch is a fix to patch "bcache: fix bio_{start,end}_io_acct with
> proper device". The previous patch uses a hack to temporarily set
> bi_disk to bcache device, which is mistaken too.
> 
> As Christoph suggests, this patch uses disk_{start,end}_io_acct() to
> count I/O for bcache device in the correct way.

Applied, thanks.

-- 
Jens Axboe

