Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5EA487CB
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 17:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfFQPrz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Jun 2019 11:47:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46757 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbfFQPrz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Jun 2019 11:47:55 -0400
Received: by mail-pf1-f196.google.com with SMTP id 81so5891579pfy.13;
        Mon, 17 Jun 2019 08:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3BR0qPvwGztmo1YT4Qkv5eX3l9PMCJXYuchfYSws6oM=;
        b=c8AKqbUqPYyy1kO3Tl0OxB865ZKAvEYggZJW/3VhQV7CecEBQxXFOGfghoYFdi/hbg
         Xr3EH/U4u42JRpfr+Z3mY6TSz5Wd4/51T9Vekh9tJmq0lu7JChAviGKYRPJYr2rEC34H
         2kqh+pN9cdBLQhL9+WwkIKR/Y0zdBmrVeTR5eTxZm8Aw0tO0aWW0IAiEVshOjCK8MyJ8
         zPTjdRshlsZkSXcX6Lq7stbsq54ReFZvwhbAH7aFbhu2EEkOSXls+CvddD5L1KdMAIxN
         mc0Ey2nXfD3YPBtf4qKpyn+23QU7D7J6I9AXVjN+NMgS+Q1BdbQ59SoN7wC2TsD71gDu
         dm1w==
X-Gm-Message-State: APjAAAUYpBukUI++FYEzo+qgjq6V5HFeOXstGFe3T7GpsFQwhj9E6Cwm
        li0Shd4xj5yX6U3D3M/h0g5ZQJ3u
X-Google-Smtp-Source: APXvYqyk8pRE+n20iUuJkmweCDUcP563eXMR2ontvquIboxZrWT0ykYj+U8xHBKWel9/IOTKP8FeDg==
X-Received: by 2002:a65:6543:: with SMTP id a3mr46459828pgw.300.1560786474405;
        Mon, 17 Jun 2019 08:47:54 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a21sm12169467pfc.108.2019.06.17.08.47.53
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 08:47:53 -0700 (PDT)
Subject: Re: [PATCH V2 1/7] block: add a helper function to read nr_setcs
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, kent.overstreet@gmail.com,
        jaegeuk@kernel.org, damien.lemoal@wdc.com
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
 <20190617012832.4311-2-chaitanya.kulkarni@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <67bcc55e-a674-7a71-7ce3-3a6745977740@acm.org>
Date:   Mon, 17 Jun 2019 08:47:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617012832.4311-2-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/16/19 6:28 PM, Chaitanya Kulkarni wrote:
> This patch introduces helper function to read the number of sectors
> from struct block_device->bd_part member. For more details Please refer
> to the comment in the include/linux/genhd.h for part_nr_sects_read().
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>   include/linux/blkdev.h | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 592669bcc536..2ef1de20fd22 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1475,6 +1475,16 @@ static inline void put_dev_sector(Sector p)
>   	put_page(p.v);
>   }
>   
> +/* Helper function to read the bdev->bd_part->nr_sects */
> +static inline sector_t bdev_nr_sects(struct block_device *bdev)
> +{
> +	sector_t nr_sects;
> +
> +	nr_sects = part_nr_sects_read(bdev->bd_part);
> +
> +	return nr_sects;
> +}

Although this looks fine to me, is there any reason why the body of that 
function has not been written as follows?

static inline sector_t bdev_nr_sects(struct block_device *bdev)
{
	return part_nr_sects_read(bdev->bd_part);
}

Thanks,

Bart.
