Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDA2397493
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Jun 2021 15:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhFANty (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Jun 2021 09:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbhFANtw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Jun 2021 09:49:52 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE6EC061756
        for <linux-bcache@vger.kernel.org>; Tue,  1 Jun 2021 06:48:10 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id x15so15521328oic.13
        for <linux-bcache@vger.kernel.org>; Tue, 01 Jun 2021 06:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QlGkt7fWsHM9mcKdq1bDx/YwBl/iUUk0WEjc5rg04fY=;
        b=SJMAgBW5mswAe1ZmlZlRdAFuvYPDEVLqi723Nnx1S4FLz3Yy3Tj3lQWVdZ0F6Qr4eS
         SMIy05Vpx5EU+XswU9cem+w+MzG0a62ahvk23Tf2SUyNvaWPkh1rlmu3OkVCdEssPf8k
         xwwmCV/LazyU6UjgCMJxdw//dP9UOpzUM54yyNCR3QG30hScN/IqdhxGg71hNvOalyX+
         pO6I2f3s4rBYqGHOnzUAspl9mEOwDLA0qywJ9pSLvD5fVKPzw+UNtHhfYY4OA0aw1ASO
         zcdxwDDiGjJD5VEZLuOr0Rlq6ubnYTbGW3SYaGllJ+Xvfy3vmm5YD3DkNvXi1rVEGPqw
         8g9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QlGkt7fWsHM9mcKdq1bDx/YwBl/iUUk0WEjc5rg04fY=;
        b=g8Wa5QBsBfxfRCKmuQKmudDiaqzg2twGHrxtLJu2B7wR0jPNVmBWJZ3964ItV25aYY
         7xETfoYGdioRBlPxcd3JbpNd9GrqYPXfFYhz6UIcOAqaW7cF0BzU3dIKvxS/Fgn/v9Qc
         xcdsJc/H8PdFqZLThJONHqkURg+e3hndIc1YHnhjfIEXs77BQhu56D6S2rJHsF6tmPCA
         eE4MNsVomls0srBowXvtYuZTkM7t9Zw3nG0fBXdjdluWrDFdm0oHNVe2OCEOzslM+FVz
         7K/MAJPToKWGremLwbTyw8rzCyy87XCiWZReGhh5zqRX21+HQRLFJoQt1w26VoL0xCW1
         kCqQ==
X-Gm-Message-State: AOAM532104NuhecQEMJpVBkblEotXylEkZnWwWZKSzPFFRfoFDJHx4l7
        3VZmdyEt0fJKPht+2JYeG9ODSA==
X-Google-Smtp-Source: ABdhPJyRtEOQYxSXItYfv2Xv0el0nwhIYWVK6zfd5YIEz7fo5+/L3t2bxzT7qaz6PyG5RR7CPJmZJA==
X-Received: by 2002:a05:6808:245:: with SMTP id m5mr18302900oie.6.1622555290008;
        Tue, 01 Jun 2021 06:48:10 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id i4sm3456045oih.13.2021.06.01.06.48.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 06:48:09 -0700 (PDT)
Subject: Re: simplify gendisk and request_queue allocation for bio based
 drivers
To:     Christoph Hellwig <hch@lst.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jim Paris <jim@jtan.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
References: <20210521055116.1053587-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a5d7127f-b422-5556-6810-cf4c98c038ac@kernel.dk>
Date:   Tue, 1 Jun 2021 07:48:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/20/21 11:50 PM, Christoph Hellwig wrote:
> Hi all,
> 
> this series is the first part of cleaning up lifetimes and allocation of
> the gendisk and request_queue structure.  It adds a new interface to
> allocate the disk and queue together for bio based drivers, and a helper
> for cleanup/free them when a driver is unloaded or a device is removed.
> 
> Together this removes the need to treat the gendisk and request_queue
> as separate entities for bio based drivers.

Applied, thanks.

-- 
Jens Axboe

