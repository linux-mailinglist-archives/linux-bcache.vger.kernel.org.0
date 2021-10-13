Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC2B42B713
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Oct 2021 08:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237991AbhJMG3r (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Oct 2021 02:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237967AbhJMG3r (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Oct 2021 02:29:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57757C061714
        for <linux-bcache@vger.kernel.org>; Tue, 12 Oct 2021 23:27:44 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id np13so1381365pjb.4
        for <linux-bcache@vger.kernel.org>; Tue, 12 Oct 2021 23:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C7+rA9/qIKI+jEKdGT8jq286cyAFBOUDDboMnfms+Z8=;
        b=AlEYQ5u0lf8LlpP+7qsCcuJhK1pgOk4qAHuS3VO4jhvcYvvdHIhevJhnSmtjCxYajF
         GvRWvFMVajscl3jlCv3bKH7RKiMCJHNfpDbORo8xCSB0MCLratUhvvPInP4hPM2sN7/u
         axF+0KLgxbxN6eO5bdOoxf3QMqBfSL0vk4cKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C7+rA9/qIKI+jEKdGT8jq286cyAFBOUDDboMnfms+Z8=;
        b=EOKGUEGG0B5Lyqrg31QO1S7q7omhqEF4sX7kBMph1HSVkzTROLR3dUp77hrtR7P8OC
         iZWeZHHFta4PxIEF01Nee9vHIf7tIOF5F3KaeUPSfUektGruK0sajYoKFGmCxhwIrXUZ
         GfWrRH1wnVRU+8reHaZWfcuUY843Q0qD+qxUOLBevyJtO1Jy0kaxN+2BnsKoccJ6dkQG
         XC4WqQVBuc9mjNcBTRcoZLYUHk310HEfcgFv2CF9vnHzhJHdvIVZvA2VHBv6t/h/VuIw
         OWL3HVbsIKJkx5B//mj0PrnzPqIuHnJ//FtunjZZtTTitNaCiOQzVOSxDMi4Rb2v/m0r
         ifNA==
X-Gm-Message-State: AOAM533rwoYOECWJknux0cz4RwSq6z4ka5FN+89kGfrBhHd7G9HdupAh
        66FSc/bNGLK263j8giQ/VJpXZg==
X-Google-Smtp-Source: ABdhPJz8mp+/J7KQDpbHq7K2lAJxf17Ai5GLPqj67ERcH9Uej4DEhzNclBgAGGyGj3QY5e4RheoMRg==
X-Received: by 2002:a17:90b:88d:: with SMTP id bj13mr4255866pjb.211.1634106463887;
        Tue, 12 Oct 2021 23:27:43 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x15sm7730841pgo.48.2021.10.12.23.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:27:43 -0700 (PDT)
Date:   Tue, 12 Oct 2021 23:27:42 -0700
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
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev,
        reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 24/29] block: add a sb_bdev_nr_blocks helper
Message-ID: <202110122319.3029AE5AA@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-25-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-25-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Oct 13, 2021 at 07:10:37AM +0200, Christoph Hellwig wrote:
> Add a helper to return the size of sb->s_bdev in sb->s_blocksize_bits
> based unites.  Note that SECTOR_SHIFT has to be open coded due to
> include dependency issues for now, but I have a plan to sort that out
> eventually.

Wouldn't that just need a quick lift into a new header file to be
included by genhd.h, blkev.h, and:

drivers/mtd/ssfdc.c:#define SECTOR_SHIFT                9
fs/hfsplus/hfsplus_raw.h:#define HFSPLUS_SECTOR_SHIFT         9

I think that's worth doing at some point in this series since genhd.h
already has existing open-coded "9"s. And, really, a *lot* of other
places too:

$ git grep -E '(<<|>>) 9' | grep -E '\b(block|blk|sector|bdev)\b' | wc -l
240

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/genhd.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 082a3e5fd8fa1..6eaef8fa78bcd 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -245,6 +245,12 @@ static inline sector_t get_capacity(struct gendisk *disk)
>  	return bdev_nr_sectors(disk->part0);
>  }
>  
> +static inline u64 sb_bdev_nr_blocks(struct super_block *sb)
> +{
> +	return bdev_nr_sectors(sb->s_bdev) >>
> +		(sb->s_blocksize_bits - 9 /* SECTOR_SHIFT */);
> +}
> +
>  int bdev_disk_changed(struct gendisk *disk, bool invalidate);
>  void blk_drop_partitions(struct gendisk *disk);
>  
> -- 
> 2.30.2
> 

-- 
Kees Cook
