Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DE742F77B
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Oct 2021 17:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbhJOQAI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 12:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241078AbhJOQAH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 12:00:07 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15098C061766
        for <linux-bcache@vger.kernel.org>; Fri, 15 Oct 2021 08:58:01 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v20so6654560plo.7
        for <linux-bcache@vger.kernel.org>; Fri, 15 Oct 2021 08:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rgGaYmDb8aNvCIAME7GO0birqL1mkWt7ydTyP9O/cKE=;
        b=kIRUc5W9BEwRakFXurh5nloSfV/GZ6KodZpU7B1gErDYA9VUyCtogTyGs+Y5G+H20i
         dnc1ZbM+E5Bs4xUGAtigRUSltSsKM9wVuaq9ndK9JOr2Z68iGubgRtUXKZR8iuFZIw97
         IrBdRqOJrF7Mv/zRwmHVkacPzOteyiW6Cc+yE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rgGaYmDb8aNvCIAME7GO0birqL1mkWt7ydTyP9O/cKE=;
        b=BX7bVBn37LPpO0MQgc8QbHehHsBBeO2u1/egMQCaonzADLxAQ5FczpltKrbRpyPONY
         OYbCikIeSjg2kcQdQQpnai7y3acZz5T4FpF+42tNE4U8syOMjHi2XGOGe/fn6cZUEgDK
         bEJLIApfO37kOhTxnOsWWwE/wa1gCPw7VJsgwUfIM3/43YaCXSKDzqMYzfT9PJ1fQMh8
         69D4gDDQpUHhF1FUoVAZea3dMUjFwmsUv/ReEWWgeMvLKq9LrIsCcQ6dAgYiAnU7eQO0
         jUmPIzP9g8kg6/01Wsz8m3lFzk1nchvBLKybwYUW19sYQMpxE/Q6J+N5Ue1skFZ9aDUg
         7fGQ==
X-Gm-Message-State: AOAM530kaNZ9YGbwHJpajWuWdYJKcZmo547F+M8u7nUIJsN33mBs9qAQ
        6lYKg6MLpzRPcOWJJHuGAC4cjg==
X-Google-Smtp-Source: ABdhPJx303madCzq8aEdsp3YSciE1Wq7LVhGoNPOEW0M7ZYp3QKmvN8DHnOwfgCID2D8+p9KXQEc7Q==
X-Received: by 2002:a17:902:b40a:b0:13d:cbcd:2e64 with SMTP id x10-20020a170902b40a00b0013dcbcd2e64mr11832704plr.18.1634313480495;
        Fri, 15 Oct 2021 08:58:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i123sm5371745pfg.157.2021.10.15.08.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 08:58:00 -0700 (PDT)
Date:   Fri, 15 Oct 2021 08:57:59 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Theodore Ts'o <tytso@mit.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ntfs3@lists.linux.dev, reiserfs-devel@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH 08/30] target/iblock: use bdev_nr_bytes instead of open
 coding it
Message-ID: <202110150857.A7E96DAE@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015132643.1621913-9-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Oct 15, 2021 at 03:26:21PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

Is this basically an open-coded non-sb version of sb_bdev_nr_blocks()?

Reviewed-by: Kees Cook <keescook@chromium.org>

> ---
>  drivers/target/target_core_iblock.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 31df20abe141f..b1ef041cacd81 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -232,9 +232,9 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
>  	struct block_device *bd,
>  	struct request_queue *q)
>  {
> -	unsigned long long blocks_long = (div_u64(i_size_read(bd->bd_inode),
> -					bdev_logical_block_size(bd)) - 1);
>  	u32 block_size = bdev_logical_block_size(bd);
> +	unsigned long long blocks_long =
> +		div_u64(bdev_nr_bytes(bd), block_size) - 1;
>  
>  	if (block_size == dev->dev_attrib.block_size)
>  		return blocks_long;
> -- 
> 2.30.2
> 

-- 
Kees Cook
