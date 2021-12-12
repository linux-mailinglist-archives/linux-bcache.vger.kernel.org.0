Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E945471CF0
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 21:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhLLUWA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 15:22:00 -0500
Received: from mail-il1-f182.google.com ([209.85.166.182]:43687 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhLLUV7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 15:21:59 -0500
Received: by mail-il1-f182.google.com with SMTP id r2so13276932ilb.10
        for <linux-bcache@vger.kernel.org>; Sun, 12 Dec 2021 12:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Z4mT0au3JukqBAgU3oEmx9JeEJmI3L15TXOdiyyaWE=;
        b=tnEFO82JXZXA1yetn0HsVo3L0AA8hefaR/S05ydySSU5LuVQthYkAMQVXzDjnTuxFR
         Hxx+xb/Ccy2IPbqUR+mjjlLnRX1BhRGfOLJhrbQ9GVeb1bKUTnYeXl/2ip0FYwXm/e+J
         T7zCFN+BUB7XoMlFQAH/jPZQIqpzmcoaTRbUjma92lnuQytUTjYcI2cd1vrUlEx/bOjU
         wCmdgxGS60ZnhjOJH2mu7hqftgFQIJctUZXFKn9s41A4xzRZeoOmwdJWAYGMXvRkJKy1
         5HCEwrw+be8eiINQtLXpW8hbGFZysETCiDGqTJjGDkrXI2W6ETWkPHenmCh4fBA8xmaU
         EJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Z4mT0au3JukqBAgU3oEmx9JeEJmI3L15TXOdiyyaWE=;
        b=ANwBIXOv6ynlEOcnv4R231gSYUezGCiiJeN04Q1JqlCZmxf77H1anldgc4tfvRnJLo
         3SgiENFbiVBzvSx0mRxm2MZrBW7VakYu040Yi42i3RlBHK819xxW7E73qK/23bmeuReo
         ziDyn6v8OnCNhtil3Ec7+1rFYOAA5bsRr0CchfhoxkAvSQweFru3CMbJiZgw7HABDGSZ
         JFmJrQzKQqucyKmnY7qgy2aXIyPA0dAjxI/sIbTypEzr0zx4IoBbhz6wRFrNZ/HuRO+L
         Js3cEGPkmeYLVFGiDyoXfpIbBPYPTb8guIkmOaaiLXFEsMJjhwtS7eXgmmH4A/oRi3qJ
         ha8w==
X-Gm-Message-State: AOAM530v1R/K8gk0RPaizJNNkfBuD9Xu7kGtivNqsV01wyLsXOtnmFma
        6zkWlqxd8GsnX5/yc2ziQMAXlw==
X-Google-Smtp-Source: ABdhPJzPCgA1sSc5tQmoiUVEoLkba9q01af7JSqG84BLWz05C+6LtxnO0nl1D96sWhMZRPvOyMLeow==
X-Received: by 2002:a05:6e02:1baa:: with SMTP id n10mr26670307ili.117.1639340459226;
        Sun, 12 Dec 2021 12:20:59 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r18sm6285569ilh.59.2021.12.12.12.20.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Dec 2021 12:20:58 -0800 (PST)
Subject: Re: [PATCH v13 00/12] bcache for 5.17: enable NVDIMM for bcache
 journal
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Ying Huang <ying.huang@intel.com>
References: <20211212170552.2812-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5b08ac62-78c8-4b5a-eb8e-16739e8daa05@kernel.dk>
Date:   Sun, 12 Dec 2021 13:20:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211212170552.2812-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/12/21 10:05 AM, Coly Li wrote:
> Hi Jens,
> 
> This is the v12 effort the enabling NVDIMM for bcache journal, the code
> is under testing for months and quite stable now. Please consider to
> take them for Linux v5.17 merge window.

As I've mentioned before, this really needs some thorough review from
people not associated with the project. I spent a bit of time on the
first section of the patches, and it doesn't look ready to me.

Do you have any tests for this new code? Any that exercise the error
paths?

-- 
Jens Axboe

