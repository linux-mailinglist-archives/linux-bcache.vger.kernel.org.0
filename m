Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77757655CEB
	for <lists+linux-bcache@lfdr.de>; Sun, 25 Dec 2022 12:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiLYLkb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 25 Dec 2022 06:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLYLka (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 25 Dec 2022 06:40:30 -0500
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346F66328;
        Sun, 25 Dec 2022 03:40:28 -0800 (PST)
Received: by mail-wr1-f42.google.com with SMTP id d4so213191wrw.6;
        Sun, 25 Dec 2022 03:40:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHIIoLI6GIci6V+pJYW1QHErBVX3zcPxWh+ZJQxLA0o=;
        b=RBf9RMQ5Qst8eEVr26mVoIbmDnzWdRsX02HiJABs74Yc3wC4OwQF/wgbisfTRrOHcp
         7jjaDnY9GYdPxmek+eDuaJFxoGEoGRRJnqskqxUz/3CwwQZSuBiByg85SA712Q6GHU0M
         wQE06D7NGvDYhbZ9aec2yALM2+nh7U6rEvJtSfclLIXFy2qvil/yPaGnogJ4B1ksRZCq
         k+ARgoj/CrTiL1QO3wkeRMhF/78dKe9+PfLhCaOvlo0lip75h4aRke+pyOAyLD8RLxBp
         iCZO2gCz3e5az31ulBkcxLijVRiJUr7Y5I1hiTfjSPCoW0wtAMEyyA5iqKDTHzFRIbyJ
         tQKA==
X-Gm-Message-State: AFqh2ko9jcLU3lI/dA3nyaTr68FzYH4bNp3ZGM6ZygwCo88bp4CmfYVT
        gzzbY4zrZvXrvJVbQ3GkrqY=
X-Google-Smtp-Source: AMrXdXtOU+j5gb521X9u9SLkgvSyxLbk+fAjhclAlSe9w631NeEuF0qIeOMvF5fteB8K21s8/zxQPQ==
X-Received: by 2002:adf:f30f:0:b0:242:864e:c71c with SMTP id i15-20020adff30f000000b00242864ec71cmr8954222wro.24.1671968426666;
        Sun, 25 Dec 2022 03:40:26 -0800 (PST)
Received: from [192.168.64.177] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id e16-20020adfdbd0000000b002362f6fcaf5sm7652128wrj.48.2022.12.25.03.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Dec 2022 03:40:26 -0800 (PST)
Message-ID: <1d0eb8e4-a91f-4635-bac7-9bc6cefbeff0@grimberg.me>
Date:   Sun, 25 Dec 2022 13:40:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH for-6.2/block V3 1/2] block: Data type conversion for IO
 accounting
Content-Language: en-US
To:     Gulam Mohamed <gulam.mohamed@oracle.com>,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
        minchan@kernel.org, ngupta@vflare.org, senozhatsky@chromium.org,
        colyli@suse.de, kent.overstreet@gmail.com, agk@redhat.com,
        snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, junxiao.bi@oracle.com,
        martin.petersen@oracle.com, kch@nvidia.com,
        drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, konrad.wilk@oracle.com, joe.jin@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com, shminderjit.singh@oracle.com
References: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 12/21/22 06:05, Gulam Mohamed wrote:
> Change the data type of start and end time IO accounting variables in,
> block layer, from "unsigned long" to "u64". This is to enable nano-seconds
> granularity, in next commit, for the devices whose latency is less than
> milliseconds.
> 
> Changes from V2 to V3
> =====================
> 1. Changed all the required variables data-type to u64 as part of this
>     first patch
> 2. Create a new setting '2' for iostats in sysfs in next patch
> 3. Change the code to get the ktime values when iostat=2 in next patch
> 
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
> ---
>   block/blk-core.c              | 24 ++++++++++++------------
>   block/blk.h                   |  2 +-
>   drivers/block/drbd/drbd_int.h |  2 +-
>   drivers/block/zram/zram_drv.c |  4 ++--
>   drivers/md/bcache/request.c   | 10 +++++-----
>   drivers/md/dm-core.h          |  2 +-
>   drivers/md/dm.c               |  2 +-
>   drivers/md/md.h               |  2 +-
>   drivers/md/raid1.h            |  2 +-
>   drivers/md/raid10.h           |  2 +-
>   drivers/md/raid5.c            |  2 +-
>   drivers/nvdimm/btt.c          |  2 +-
>   drivers/nvdimm/pmem.c         |  2 +-
>   include/linux/blk_types.h     |  2 +-
>   include/linux/blkdev.h        | 12 ++++++------
>   include/linux/part_stat.h     |  2 +-

nvme-mpath now also has stats, so struct nvme_request should also be
updated.
