Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA472195B10
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 17:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgC0Q06 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 12:26:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45897 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgC0Q06 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 12:26:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id r14so2262628pfl.12
        for <linux-bcache@vger.kernel.org>; Fri, 27 Mar 2020 09:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9wGl6Wa9QcDb2Dodea5tAybsKTGFt4bIi5UGB0n01cs=;
        b=i+G9H0XEanhreLDRyPOrdm3E/anAyqwLOZ+qC4cS/PiYXG6pwl9/qQaaZVRqng5wHG
         a9gYchMK/gcMdHzLIoWL5minq2VRExAsl//MbiQualDRYxuIvBx/3U4rsjaoxTOdZNmj
         YYpuZ5q5Kz5EzYD/xLcxPZ3ndoRseL79xd24pw+4pkVgErTDP2zoQU/3cUzHYiMjkYgP
         g79aqImQisfeL7d6Q73wKV35YKc4hwUYbvtPfxPVvKZ6K3KldSciBSThVvQg0mJ1Vu+r
         apcVbgGzQASsVyxSOrpdLnvmY52yT3a7HgA7IPrTvFWComN5qtDZNH3cIyxqrqWI8iGa
         bL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9wGl6Wa9QcDb2Dodea5tAybsKTGFt4bIi5UGB0n01cs=;
        b=Td2f/wpb5pKHZ8Qn6pFB5n98IXTpXt1RcAxYwsoBJwNW2bkUzWvGxsYkwzp7fQw8je
         N8fekI2rxw26ubuMuyYo+3DdP1r5jBb3mMVUaM5imkyJoY8GyVk1IxSpkKJzWjpoOOpq
         AQHAiaZhZrxUcHq8DhG3Za5hvg+yX1NJ7ry+5b1zEnpJexp6py30S733VgwNC21+HPif
         WZK2msApKT88pLSWwJZd8JlOvfPIlQf1DQ9/lWRUtRFhyApZbz/n2jXwIJEL1PqDjf1h
         lDQyUIoX2F6aSXHLeWkp1EQPJ/LwK36B6KcQcz6h4nXItHN57mZ5w+wAqRfCRlyEod69
         rcbA==
X-Gm-Message-State: ANhLgQ00cXFp7qgZCRDllhNtvR/f6i4fozmspGe2QzesKVeSO7f0Bzrs
        zjO6CaIBfPJErZljYoXrmnoxKw==
X-Google-Smtp-Source: ADFU+vubMB0lGbM3zpgUhH51Md8EsyBIdpegFQwx5b0+Q76FNba1fLDt6/bPPFZndRMdakGtS6Twyg==
X-Received: by 2002:a65:508b:: with SMTP id r11mr95108pgp.143.1585326415251;
        Fri, 27 Mar 2020 09:26:55 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id iq14sm1538619pjb.43.2020.03.27.09.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 09:26:54 -0700 (PDT)
Subject: Re: [PATCH 4/5] block: simplify queue allocation
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20200327083012.1618778-1-hch@lst.de>
 <20200327083012.1618778-5-hch@lst.de>
 <SN4PR0401MB3598BF20E4DCF8F1B129625E9BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200327112131.GA1096@lst.de>
 <SN4PR0401MB3598AD1669D1F5BFCA4F20379BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a2110f00-6d27-1567-2725-3afb2e83ea5f@kernel.dk>
Date:   Fri, 27 Mar 2020 10:26:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <SN4PR0401MB3598AD1669D1F5BFCA4F20379BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/27/20 10:24 AM, Johannes Thumshirn wrote:
> On 27/03/2020 12:21, Christoph Hellwig wrote:
>> Because the two variants are rather pointless.  And this might get
>> more people to actually pass a useful node ID instead of copy and
>> pasting some old example code. 
> 
> So then everybody will copy the NUMA_NO_NODE ones and in X years someone 
> will come up with a wrapper passing in NUMA_NO_NODE to 
> blk_alloc_queue_node(), because he/she didn't read the commit history.

If you care about numa-node, then you are generally using it for other
allocations as well, so it should come naturally. If you don't, then
the copy/paste is fine. Better to expose it as the main API, so people
don't miss it.

-- 
Jens Axboe

