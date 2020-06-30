Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2259020FBA6
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Jun 2020 20:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390751AbgF3SV6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Jun 2020 14:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388193AbgF3SV5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Jun 2020 14:21:57 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA811C03E97B
        for <linux-bcache@vger.kernel.org>; Tue, 30 Jun 2020 11:21:56 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b92so9831453pjc.4
        for <linux-bcache@vger.kernel.org>; Tue, 30 Jun 2020 11:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9nMjhxRG610D6xAYb4aZ5VRp2i+EwPdQw1qks+ZgrLU=;
        b=hwnoVOlqAmU5zhHyPngbwhlN1yE0Rso1wSEH5Cjpo1eHOGtwX+AR6fF4SKm61iSSaU
         xiq7Si+fCLVLBMD4J7QWGIGpRMN22P7LkDW6XHYnqvsHwEiKJn/e7f4zxe/RH81FYZzf
         6Qah7lhZ47GF32wkEdApitqRosxk7IcYLclUVGOXkeLM+pP0S9zvuPgq8PcNplpKOkyE
         awjP1mt8uhAMtNOYRMd+Y1yvSZf+ZepFpwCbSYGQZlgNrN664rZd2V1H/xVqglgX5aPU
         phGafx1o9DcWQXNw7D5cKE9cBpAhM0fImNVpDBnmceKAdk/tkJjCm50uuW5RXHV8UW9k
         l/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9nMjhxRG610D6xAYb4aZ5VRp2i+EwPdQw1qks+ZgrLU=;
        b=HWyJKhAQumepxsFdClbqzA8hzvg4b2tsxpszxBMLAd2HpI3OeHlh6TU2SHsOzkXL/q
         jU/1letU4gTqOwQDRNF7KzyhfMkLmyK+VH+6lxAFMEuL2MKwQ+LFMVT31bJtA8Mga9eL
         U1TUAoWx8E4QY7f/r23OqWl/xX9xTJHq2LTcgzjCf8lt55DGtfWbIKHrS/ehfIcrdKCt
         J9RUcv3xwGtEkKvEyVVzoAi4v84dw44r4WuZ6PpFd42cpEueHopsLW6jKjB0I9rKxdFz
         wBYxpBiS6AAj1Y7sEKwH9EQoREEIcl6/v5Ny1nldLfPo0ft7Vz0yMRCE5KcvN6FEsgQR
         2knA==
X-Gm-Message-State: AOAM533pUE8yhpWcQeMDZi3UR1fUnniQ85Wzc3sNTLMs5zo6IYTrHoJL
        PHjsHjiedQBuRB0M+Qn/wPt4RQ==
X-Google-Smtp-Source: ABdhPJx1eVZzUauHavuDMn/utz58o2Sp76o2c6uyFezmO+u8oFk4qpnRUZKKvG8yetkSCycNIsxDcg==
X-Received: by 2002:a17:90a:7409:: with SMTP id a9mr23663497pjg.107.1593541316394;
        Tue, 30 Jun 2020 11:21:56 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4113:50ea:3eb3:a39b? ([2605:e000:100e:8c61:4113:50ea:3eb3:a39b])
        by smtp.gmail.com with ESMTPSA id 10sm3244047pfx.136.2020.06.30.11.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 11:21:55 -0700 (PDT)
Subject: Re: rename ->make_request_fn and move it to the
 block_device_operations
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux-nvdimm@lists.01.org, linux-s390@vger.kernel.org,
        dm-devel@redhat.com, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org,
        drbd-dev@lists.linbit.com
References: <20200629193947.2705954-1-hch@lst.de>
 <bd1443c0-be37-115b-1110-df6f0e661a50@kernel.dk>
 <6ddbe343-0fc2-58c8-3726-c4ba9952994f@kernel.dk>
 <20200630181928.GA7853@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f173ab34-53c4-0316-f755-240f00cc7075@kernel.dk>
Date:   Tue, 30 Jun 2020 12:21:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200630181928.GA7853@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/30/20 12:19 PM, Christoph Hellwig wrote:
> On Tue, Jun 30, 2020 at 09:43:31AM -0600, Jens Axboe wrote:
>> On 6/30/20 7:57 AM, Jens Axboe wrote:
>>> On 6/29/20 1:39 PM, Christoph Hellwig wrote:
>>>> Hi Jens,
>>>>
>>>> this series moves the make_request_fn method into block_device_operations
>>>> with the much more descriptive ->submit_bio name.  It then also gives
>>>> generic_make_request a more descriptive name, and further optimize the
>>>> path to issue to blk-mq, removing the need for the direct_make_request
>>>> bypass.
>>>
>>> Looks good to me, and it's a nice cleanup as well. Applied.
>>
>> Dropped, insta-crashes with dm:
> 
> Hmm.  Can you send me what is at "submit_bio_noacct+0x1f6" from gdb?
> Or your .config?

I'd have to apply and compile again. But it's a bad RIP, so I'm guessing
it's ->submit_bio == NULL. Let me know if you really need it, and I can
re-generate the OOPS and have the vmlinux too.

-- 
Jens Axboe

