Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37EE1ECF0E
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Nov 2019 15:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfKBODq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 2 Nov 2019 10:03:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34043 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfKBODq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Nov 2019 10:03:46 -0400
Received: by mail-pg1-f195.google.com with SMTP id e4so8252251pgs.1
        for <linux-bcache@vger.kernel.org>; Sat, 02 Nov 2019 07:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rtuDPqJZ0XL0I3niBJJ+k2E1GedQ1MMy4bRevHQ+bw4=;
        b=TRgUnVcByAkYuvAlQNyPJkaDxxox1KYzIF5hquLLmn0AzhQt8aFInkbMxUqlURVXiB
         9QU50KrAmHGHmTDL2tmOXlQb86gQ8unGF489aAc1bnZiHQO++EHlyIys5M3tf0eQW9+S
         gg1W4vqdPvVdaWzmfeQ440jYVaDjpPXZg1yOKdsWpoEedXp/TNJt7FA5ldPmWon+k/XW
         AVtsx8+ydQQGGUia1foFd5z5v2GNXn1TjrQKrKvuG+IgqthJA0asa59G72PtTabQpuZS
         fkQZn/uW1mjGIFz/k+Lkvy3z1+ZXGXUEjy7troJE0PnxRbIL4ZUCFFIhPwkvQGiYkQEy
         CaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rtuDPqJZ0XL0I3niBJJ+k2E1GedQ1MMy4bRevHQ+bw4=;
        b=q1b4nI97zfacj2I6kgYsf6YSZxUh/vdyB4xMFRTj7kej7RPbRDaKSYsKxJ1Gz4HmFf
         Uc9PUMjY2/eOpneZ3Ha70bF1N002U0dCFKTy5TZAJoYXSUDO2MQviOwiNCF1i5NDHKjR
         p7rNPkvpu5cJfX3IUQH9Jd4WvPwzJO8KTGC/NWf5BegUPN6a7yMrjnnqEuFxukxyO4JX
         KBekpdAfUl2mmU6Qmkvg9M5utGgkA/8jmXNZgxiZIe9u9o6u2uQpJZBQ1p47yvsCoaes
         nw71Iu+lDpx0ecev+DCjARj6yeb43SQKztM5XhA7aWo16gijjc7UdrSHMCuwQhvEvS1H
         pU8g==
X-Gm-Message-State: APjAAAX0lvLDlN+3zmH2MDVcYrc6mW5ZyvRzCbMNvZyWfrd4HBg9kD/q
        Yo6FQEAsfW3oa/JFaHVCkEKj6eSvkGaehw==
X-Google-Smtp-Source: APXvYqzAGyaSRBGFZuWmHK1zrMVvhmAYfeg6v+AAzMTYsYhCLLu7ILJkm2DMFJVLiC4rb8ZjP2u+9g==
X-Received: by 2002:a65:6290:: with SMTP id f16mr20439011pgv.40.1572703425334;
        Sat, 02 Nov 2019 07:03:45 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id x20sm9174065pfa.186.2019.11.02.07.03.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Nov 2019 07:03:44 -0700 (PDT)
Subject: Re: [PATCH V4] block: optimize for small block size IO
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
References: <20191102072911.24817-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <606b9117-1fb6-780b-8fb1-001c06768a2e@kernel.dk>
Date:   Sat, 2 Nov 2019 08:03:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191102072911.24817-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/2/19 1:29 AM, Ming Lei wrote:
> __blk_queue_split() may be a bit heavy for small block size(such as
> 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
> multiple page. And only consider to try splitting this bio in case
> that the multiple page flag is set.
> 
> ~3% - 5% IOPS improvement can be observed on io_uring test over
> null_blk(MQ), and the io_uring test code is from fio/t/io_uring.c
> 
> bch_bio_map() should be the only one which doesn't use bio_add_page(),
> so force to mark bio built via bch_bio_map() as MULTI_PAGE.
> 
> RAID5 has similar usage too, however the bio is really single-page bio,
> so not necessary to handle it.

Thanks Ming, applied.

-- 
Jens Axboe

