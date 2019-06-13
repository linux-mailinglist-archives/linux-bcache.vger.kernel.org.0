Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A090243BCA
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfFMPbu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:31:50 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41503 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfFMPbt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 11:31:49 -0400
Received: by mail-pl1-f196.google.com with SMTP id s24so8286036plr.8;
        Thu, 13 Jun 2019 08:31:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sw+SllUv08twj2EAyMoEep+5QsSUddK0/P8AXJZORSo=;
        b=hzq079ExytLwC9vLrLEvXTCDpk7cLCp2hMA5+K108avL1yOKx1PskaaBNLJIIe8HHm
         yobIkivBIPy8wnPxxzNVBuvOIFHX0sFSLtd8JWOe6HqPXLjzSh6O+ueE1gWqAxzXNIHO
         9ARlcO47D4t8oHP4Bslyc2n9DU9aDqKKKyTdP0Lg2AsPmiY94NgbTJQhGU2h2hx/Ewag
         BsyPT5lz29AezBVfCTtISO9TDXmqW0YZoU1WuhqmAQgnQA4SHh/QEjPYsVkqRquw2e4a
         oNzzBmWUGPxbsbK5moxe52TQpSICijDllCZ3eG3MXTYqpFcAlbcIKHdXUYAbArGAMh4n
         NznQ==
X-Gm-Message-State: APjAAAUhix+xdxLBAUikust4vTojxcwhQarbfU3SnjmEuiMTQSe63nNU
        JwrrtWvqSEcQxKTcLtpgL1g=
X-Google-Smtp-Source: APXvYqw4oamYkUwHgg92Z05hHQ0ZGYDNMbYqfHf5XI4ShcHflr22ojcnpivazqf3vnWipfEjMdywWw==
X-Received: by 2002:a17:902:2e81:: with SMTP id r1mr88928480plb.0.1560439909030;
        Thu, 13 Jun 2019 08:31:49 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 5sm161353pgi.28.2019.06.13.08.31.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 08:31:46 -0700 (PDT)
Subject: Re: [PATCH 1/8] block: add a helper function to read nr_setcs
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
 <20190613145955.4813-2-chaitanya.kulkarni@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9abfc2b8-4496-db7a-fcbb-b52102a67f8e@acm.org>
Date:   Thu, 13 Jun 2019 08:31:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613145955.4813-2-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/13/19 7:59 AM, Chaitanya Kulkarni wrote:
> This patch introduces helper function to read the number of sectors
> from struct block_device->bd_part member. For more details Please refer
> to the comment in the include/linux/genhd.h for part_nr_sects_read().
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>   include/linux/blkdev.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 592669bcc536..1ae65107182a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1475,6 +1475,18 @@ static inline void put_dev_sector(Sector p)
>   	put_page(p.v);
>   }
>   
> +/* Helper function to read the bdev->bd_part->nr_sects */
> +static inline sector_t bdev_nr_sects(struct block_device *bdev)
> +{
> +	sector_t nr_sects;
> +
> +	rcu_read_lock();
> +	nr_sects = part_nr_sects_read(bdev->bd_part);
> +	rcu_read_unlock();
> +
> +	return nr_sects;
> +}
> +
>   int kblockd_schedule_work(struct work_struct *work);
>   int kblockd_schedule_work_on(int cpu, struct work_struct *work);
>   int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork, unsigned long delay);
> 

Please explain what makes you think that part_nr_sects_read() must be 
protected by an RCU read lock.

Thanks,

Bart.
