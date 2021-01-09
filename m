Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB1D2F009E
	for <lists+linux-bcache@lfdr.de>; Sat,  9 Jan 2021 16:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbhAIPCt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 9 Jan 2021 10:02:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:60802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbhAIPCt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 Jan 2021 10:02:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C4C08AAF1;
        Sat,  9 Jan 2021 15:02:07 +0000 (UTC)
Subject: Re: [PATCH 0/5] bcache patches for Linux v5.11-rc3
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20210104074122.19759-1-colyli@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <0ec90bb3-aa7b-431c-eed2-557cb15f9d06@suse.de>
Date:   Sat, 9 Jan 2021 23:02:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210104074122.19759-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/4/21 3:41 PM, Coly Li wrote:
> Hi Jens,
> 
> This series is not planned but necessary. The four patches from me fix
> a bcache super block layout issue which was introduced in 5.9 when large
> bucket (32MB-1TB size for zoned device) feature firstly introduced.
> 
> Previous code has problem on space consumption and checksum calculation.
> These four patches improve and fix the problems with on-disk format
> consistency. Although now almost no one (except me) uses the large
> bucket code now, it should be good to have the fix as soon as possible.
> 
> This series also has a patch from Yi Li which avoid a redundant value
> assignment in a two-level loop. It is cool if we may have it in 5.11.
> 
> User space bcache-tools are updated for the above kernel changes too.
> Please take them for 5.11-rc3.
> 

Hi Jens,

Could you please to take this series for rc3?

Thanks in advance.


Coly Li



> ---
> 
> 
> Coly Li (4):
>   bcache: fix typo from SUUP to SUPP in features.h
>   bcache: check unsupported feature sets for bcache register
>   bcache: introduce BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE for large
>     bucket
>   bcache: set bcache device into read-only mode for
>     BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET
> 
> Yi Li (1):
>   bcache: set pdev_set_uuid before scond loop iteration
> 
>  drivers/md/bcache/features.c |  2 +-
>  drivers/md/bcache/features.h | 30 ++++++++++++++++----
>  drivers/md/bcache/super.c    | 53 +++++++++++++++++++++++++++++++++---
>  include/uapi/linux/bcache.h  |  2 +-
>  4 files changed, 76 insertions(+), 11 deletions(-)
> 



