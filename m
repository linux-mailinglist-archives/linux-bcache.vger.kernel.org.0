Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D84361F45
	for <lists+linux-bcache@lfdr.de>; Fri, 16 Apr 2021 14:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbhDPMC4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 16 Apr 2021 08:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbhDPMC4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Apr 2021 08:02:56 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD39C061756
        for <linux-bcache@vger.kernel.org>; Fri, 16 Apr 2021 05:02:31 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q10so19059784pgj.2
        for <linux-bcache@vger.kernel.org>; Fri, 16 Apr 2021 05:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LCvosQGwNbJA+iQBpZKKYUGjH70GQQJ3bWsEuw6AmHo=;
        b=0JSTVg9MF7kKaCsOKY7jLR1Wqh4coVUIXQ+SUWxu4hDllpWDeQh0RHpe9782ZcZRKq
         wU6C25+bBMBb8CtfSBtBP0/KxiULbAlRvhhQttqMmKwWOCWtTTn+QUUcJ18u8z6DCzRS
         xbnIP5y0SmpYidHchUFP5fjKdwnAazfP8TMNPeOHbngiQW0ep5DFroX/8j+fVDTtSnQf
         5hCvwBywBTqMtKyXZocklFhwvL0p1FKCD8FY4dEJhjfIbutjdJw1gWRGY4QKmkduJYwS
         BZt17ISywQnVG+eAl4W5SWe+vWzbzlJwQb9/jzCGf7rkHwZGh3kuwiNrf1nNTXZF8DtY
         QR2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LCvosQGwNbJA+iQBpZKKYUGjH70GQQJ3bWsEuw6AmHo=;
        b=WCPQm6Ic7oEZFvDVmqV/j00OOEK9vF/zPhHYEr5WcVRZIcIotxGOSm5p5W/MtTiJNX
         VTeu0Jxu8Ruf1rcxgnqk++GYRxXzl/DL+GS1rjElMWpK6CW32oigPjdv36OlMjp5gLM1
         7PKTu5jN3AmLYEnYYFAUw7xOYVvBrzTwXLQlXEMm6hpAwpyrQKumC5YT8lqe4lX1k3Ht
         ynazSGGRJ4W8tAXlS4/3PVXoUW0I28WsGBHXwReKGBPnWAkkrAXnWarD0oxr+lCcKdCb
         b9Maf78QgbBORFUChDQKgcuGhPAzpwUh+u8z0uyt1blIHqR2XkGH8skYEcFKLxQ7tfZC
         Wcrw==
X-Gm-Message-State: AOAM5311oiFy1jROiGqb6BPmzxsS6wWieyjgO/8ivclXkT8f6WLTCj03
        P4ZpZXjXJFI9lpCv+fW1WHARug==
X-Google-Smtp-Source: ABdhPJwmj3M9UF+aXclQbeyD5vvBHLkl7ix2wO/gn76HWQMKGwNd07PrWd7l1d4IOAXfS57b9gmmnw==
X-Received: by 2002:a63:fc58:: with SMTP id r24mr7882087pgk.368.1618574551129;
        Fri, 16 Apr 2021 05:02:31 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s22sm4770868pfe.150.2021.04.16.05.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 05:02:30 -0700 (PDT)
Subject: Re: [PATCH 00/13] bcache patches for Linux v5.13 -- 2nd wave
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        jianpeng.ma@intel.com, qiaowei.ren@intel.com
References: <20210414054648.24098-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <241da7b5-65d3-e3dd-83e7-39ba85e8dc9f@kernel.dk>
Date:   Fri, 16 Apr 2021 06:02:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210414054648.24098-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/13/21 11:46 PM, Coly Li wrote:
> Hi Jens,
> 
> This is the 2nd wave of bcache patches for Linux v5.13. This series are
> patches to use NVDIMM to store bcache journal, which is the first effort
> to support NVDIMM for bcache [EXPERIMENTAL].
> 
> All concerns from Linux v5.12 merge window are fixed, especially the
> data type defined in include/uapi/linux/bcache-nvm.h. And in this
> series, all the lists defined in bcache-nvm.h uapi file are stored and
> accessed directly on NVDIMM as memory objects.
> 
> Intel developers Jianpeng Ma and Qiaowei Ren compose the initial code of
> nvm-pages, the related patches are,
> - bcache: initialize the nvm pages allocator
> - bcache: initialization of the buddy
> - bcache: bch_nvm_alloc_pages() of the buddy
> - bcache: bch_nvm_free_pages() of the buddy
> - bcache: get allocated pages from specific owner
> All the code depends on Linux libnvdimm and dax drivers, the bcache nvm-
> pages allocator can be treated as user of these two drivers.
> 
> The nvm-pages allocator is a buddy-like allocator, which allocates size
> in power-of-2 pages from the NVDIMM namespace. User space tool 'bcache'
> has a new added '-M' option to format a NVDIMM namespace and register it
> via sysfs interface as a bcache meta device. The nvm-pages kernel code
> does a DAX mapping to map the whole namespace into system's memory
> address range, and allocating the pages to requestion like typical buddy
> allocator does. The major difference is nvm-pages allocator maintains
> the pages allocated to each requester by a owner list which stored on
> NVDIMM too. Owner list of different requester is tracked by a pre-
> defined UUID, all the pages tracked in all owner lists are treated as
> allocated busy pages and won't be initialized into buddy system after
> the system reboot.
> 
> I modify the bcache code to recognize the nvm meta device feature,
> initialize journal on NVDIMM, and do journal I/Os on NVDIMM in the
> following patches,
> - bcache: add initial data structures for nvm pages
> - bcache: use bucket index to set GC_MARK_METADATA for journal buckets
>   in bch_btree_gc_finish()
> - bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
> - bcache: initialize bcache journal for NVDIMM meta device
> - bcache: support storing bcache journal into NVDIMM meta device
> - bcache: read jset from NVDIMM pages for journal replay
> - bcache: add sysfs interface register_nvdimm_meta to register NVDIMM
>   meta device
> - bcache: use div_u64() in init_owner_info()
> 
> The bcache journal code may request a block of power-of-2 size pages
> from the nvm-pages allocator, normally it is a range of 256MB or 512MB
> continuous pages range. During meta data journaling, the in-memory jsets
> go into the calculated nvdimm pages location by kernel memcpy routine.
> So the journaling I/Os won't go into block device (e.g. SSD) anymore,
> the write and read for journal jsets happen on NVDIMM.
> 
> The whole series is testing for a while and all addressed issues are
> verified to be fixed. Now it is time to consider this series as an
> initial code base of a commnity cooperation and have them in bcache
> upstream for future development.
> 
> Thanks in advance for taking this. 

Applied, with 13/13 folded in.

-- 
Jens Axboe

