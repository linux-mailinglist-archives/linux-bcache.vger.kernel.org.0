Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60ED83169CF
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 16:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhBJPMC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 10:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhBJPMB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 10:12:01 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FCFC061756
        for <linux-bcache@vger.kernel.org>; Wed, 10 Feb 2021 07:11:20 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id m17so2205520ioy.4
        for <linux-bcache@vger.kernel.org>; Wed, 10 Feb 2021 07:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tS5pwHzwXhieHszIWnMmjReWJIdbc2e31FQOtEQl4cg=;
        b=pJVodo9Rtion0T6XJgMylaX2zcsRoFqygAtB4s3ACHGJBjJHnN0GfB46pLNSddQH9F
         rNTsmkjiuclaX2RyaazmlfrcaCuGtArMcbeIlV8R1ELa8DhgKJ1LNkGrgdl+vLxfi57F
         eXB/o/mLCnGAmesPo3ohf/eCv0U/hsaPT455oWWESKhEaoeklm88XPU0Fkhq/28uUoBz
         qBVByD0YGEBjCk7ozBla1UheB2DbGs15cuAgpHPHJoNgKS78LKQxkpYb3hTYJfNy0KXH
         n3f1IPEMZDXBFdrHfJUTIdAVyjJAaZDZyo4gb7wKDV49Kf2eUGxTSywGHRchCa5HImwk
         juKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tS5pwHzwXhieHszIWnMmjReWJIdbc2e31FQOtEQl4cg=;
        b=DJw7p6vrZPmaG56tnQ8iDNA1gXc1Fccm/GzCecHihfzKCcIlYxpi0pBgeaFx5Ax9Yu
         9GvG51O/0DEVcL+GHSqV1vl66swjaPtMAtUGrcRww7W3Ftxfxe8NSrVFEAiVNR8KopOK
         dvyM0E5XqlJY9f+FTtceOMPQndjIMgt6WQILiz8jZ8AGh6q3Q2VWdDyZsN1I7ptxLN0B
         blhPVbaQMFcXjSREQpXD3gbTSE/TSQPoo33Zm66g9uvbxo2hwl60GiXQd8vcpxpoBTsL
         VJqYDEWr45koA83qsTSTXOlXr2bjssKSSDgFHVrwQYsbJfKXVVRbKpdUb0Z6aVTAq9GN
         HlOQ==
X-Gm-Message-State: AOAM53298O2SH5nuTjKew2r5KOBSBt219y62gej1z73uMc1LOMHgFxAX
        FYeE/YoNv9Jc+5vc+ojAtKjDxA==
X-Google-Smtp-Source: ABdhPJyEombVB+Gwzrdb4DYEQ+PXgxb1sdRnlhIIujQN+T/M1QLxqTYHX2yXc7y1kO9QlVSXbZwOcg==
X-Received: by 2002:a05:6638:3bc:: with SMTP id z28mr3721115jap.118.1612969879655;
        Wed, 10 Feb 2021 07:11:19 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z7sm1108033iod.8.2021.02.10.07.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 07:11:19 -0800 (PST)
Subject: Re: [PATCH 00/20] bcache patches for Linux v5.12
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Kai Krakow <kai@kaishome.de>
References: <20210210050742.31237-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <50173dee-31dd-9951-bc7f-b5247a46ef5e@kernel.dk>
Date:   Wed, 10 Feb 2021 08:11:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/9/21 10:07 PM, Coly Li wrote:
> Hi Jens,
> 
> This is the first wave bcache patches for Linux v5.12.
> 
> It is nice to see in this round we have 3 new patch contributors:
> Jianpeng Ma, Qiaowei Ren and Kai Krakow.
> 
> In this series, the EXPERIMENTAL patches from Jianpeng Ma, Qiaowei Ren
> and me are initial effort to store bcache meta-data on NVDIMM namespace.
> The NVDIMM space is managed and mapped via DAX interface, and accessed
> by linear address. In this submission we store bcache journal on NVDIMM,
> in future bcache btree nodes and other meta data will be added in too,
> before we remove the EXPERIMENTAL statues.
> 
> Dongdong Tao contributes a performance optimization when
> bcache cache buckets are highly fregmented, Dongdong's patch makes the
> dirty data writeback faster and from his benchmark reprots such changes
> have recognized improvement for randome write I/O thoughput and latency
> for highly fregmented buckets, and no regression for regular I/O
> observed.
> 
> Kai Krakow contributes 4 patches to offload system_wq usage to separated
> btree_io_wq and bch_flush_wq. In his environment the daily backup job
> throughput increases from 60.2MB/s to 419MB/s and accomplished time
> reduced from 14h29m to 2h13m.
> 
> Joe Perches also contributes a fine code stype fix which I pick for this
> submission.
> 
> Please take them for Linux v5.12 merge window.

Applied 1-6 for now, that weird situation with the user visible header
needs to get resolved before it can go any further.

-- 
Jens Axboe

