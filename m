Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8465735B5B5
	for <lists+linux-bcache@lfdr.de>; Sun, 11 Apr 2021 16:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbhDKOkZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 11 Apr 2021 10:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbhDKOkY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 11 Apr 2021 10:40:24 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA0EC061574
        for <linux-bcache@vger.kernel.org>; Sun, 11 Apr 2021 07:40:07 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t22so4661834ply.1
        for <linux-bcache@vger.kernel.org>; Sun, 11 Apr 2021 07:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m17AOPqVR6H1nou/0rvMoe5RDzG1G5/2y1vVSE1r4bM=;
        b=r1Pus7AU/F5XIh+fUqxWCF29vIv+Fqn3wWBcFbXcRpPzNFGxJ3kpxbHhro1PYGKTAt
         dIECFnOvty6Hor2rC+xNpxQwubjU0I4zFYH/8JTnLYnPTMzlypz/DDA2FOAYkB1WVx8+
         Ej2qddKaICB9a2NJrgZLgFMRO7JbJs5hmjKCUqhUxIiIWhK5N0LVSBivYU83O3bAaU4o
         DEbBXy4zVYP8L3L1drcgE+WQLbzkAyEwMCi1cR4SRrqUMdrI73vDZBXL0j11Ml0fmyBr
         spJEjXfPBwWAIu8mXcnICMHHkkKSJJthBOJLiWxjsI+blsIzMyehaJVk341cw9+BsXQT
         E62w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m17AOPqVR6H1nou/0rvMoe5RDzG1G5/2y1vVSE1r4bM=;
        b=db77HL82yvm6wX8q6c5B9FDro4ii45LLY+kKKICV8U38TDC8Qa0xdcYagcxicS5ubb
         /XmuP8QRNeOOxyYPiEaVZ3SYh16+of2f+X6ShXTSt4HyerMPYxJBAPxqy2TDZTBYkSdM
         iOOLDo0iK5Qy8d33OH1Z8NTysQrzJorYsC/iG6Mo0FORTfXYDeWku6mtiHuTbQEcAffA
         DLb7M2kikSkEfC1KwpcTU2cQ3i8SE0OjmoSlS0ENZdCSUQnNt9Fe3Upv0eAZsWtQLpEX
         ZCudTTXDkXUUjzm8Dpn9U80ytF2fO2IsM8xXc0PM+3jWd3qIxdlqJ+ch3reOJoQWQDuz
         BGbQ==
X-Gm-Message-State: AOAM5303+lEyr1bt1yaYAStBEwXnzDApPT1HuEGbqFk4aXl7cchUSuyH
        HbsM9smDguHbLcIhXtq6bGIZaw==
X-Google-Smtp-Source: ABdhPJw/hTbZAvhUtGLcXbO1ELe7BXNqt3l8+3yY49eWVaM3f6hq59KU0HZhuyGjzvbDGqSPPDq3vQ==
X-Received: by 2002:a17:902:6544:b029:ea:f94e:9d4e with SMTP id d4-20020a1709026544b02900eaf94e9d4emr746959pln.16.1618152007255;
        Sun, 11 Apr 2021 07:40:07 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b23sm1706601pju.0.2021.04.11.07.40.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 07:40:06 -0700 (PDT)
Subject: Re: [PATCH 0/7] bcache patches for Linux 5.13 -- 1st wave
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20210411134316.80274-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6808c615-b25c-6ccc-1291-752b42917a2a@kernel.dk>
Date:   Sun, 11 Apr 2021 08:40:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210411134316.80274-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/11/21 7:43 AM, Coly Li wrote:
> Hi Jens,
> 
> This is the 1st wave of bcache for Linux v5.13.
> All the patches in this submission are all about code cleanup or
> minor fixes.
> 
> The 2nd wave patches are about the NVDIMM support on bcache which were
> held in previous merge window. The refined patches work as expected, and
> I am waiting Intel developers to post the update version with the fixes
> of the integration testing. Then I will post out the 2nd wave bcache
> patches for 5.13 merge window.
> 
> Thanks in advance for taking the 1st wave patches.

Applied, thanks.

-- 
Jens Axboe

