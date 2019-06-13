Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D8B43C8E
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733016AbfFMPg2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:36:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39166 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbfFMPg1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 11:36:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so12080189pfe.6;
        Thu, 13 Jun 2019 08:36:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1qNETIPzuNaaWbEXZO+YzL0sjuyPrebTHaHLkZ6VN3U=;
        b=p1lT+8zeVo0OGqWaUKgkt/u+5oS8dSS+kNDE4jya4RbiyWElZ/PA1n7ms1XgJCQjN3
         S+/LAF6LCC0BNSndpA//ynr3lbdSpGfF6MsxQmIOMxIyP05+UlWFqKkoH/463bzrQvhw
         xIG4oOgqGicKfsDH6gkNad77MsEQBinEOWh1l10MA7nR8Y0paTK0mG+lE+QaPC+sOenR
         QPsAds2tFkg7fu02Vz2JeYrW7TTLyGn7I3KTt9GayFIQtdRc9E2m146L3vaa2DNchUE3
         9GWt6q7eiYCgGjkuFDbwSkvtj3NO4yc9iQqC/kAETTH97KSiqMehKOFiAV4ziPxxck/K
         hFhw==
X-Gm-Message-State: APjAAAXz2ZgXI8wfQGkuasOMqIuqpK7FUZMOv/aIhzVU/A7wYdZ8/kgC
        kzdBkGQQgSKg9ITZbTIsqQnNy8vT8E0=
X-Google-Smtp-Source: APXvYqxB+FeDDa+u2Me5UdsbXLEVBYw9OT1YMcOtX99zGgs5lfiFPcmi/0tOv017zyhlQ98BTWKWgg==
X-Received: by 2002:a62:e119:: with SMTP id q25mr57599498pfh.148.1560440186481;
        Thu, 13 Jun 2019 08:36:26 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p6sm168870pgs.77.2019.06.13.08.36.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 08:36:25 -0700 (PDT)
Subject: Re: [COMPILE TESTED PATCH 6/8] target/pscsi: use helper in
 pscsi_get_blocks()
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
 <20190613145955.4813-7-chaitanya.kulkarni@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ca5092fa-bc1b-08d5-888a-1ed6f909dfef@acm.org>
Date:   Thu, 13 Jun 2019 08:36:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613145955.4813-7-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/13/19 7:59 AM, Chaitanya Kulkarni wrote:
> This patch updates the pscsi_get_blocks() with newly introduced helper
> function to read the nr_sects from block device's hd_parts with the
> help if part_nr_sects_read() protected by appropriate locking.
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>   drivers/target/target_core_pscsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index c9d92b3e777d..da481edab2de 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -1030,7 +1030,7 @@ static sector_t pscsi_get_blocks(struct se_device *dev)
>   	struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
>   
>   	if (pdv->pdv_bd && pdv->pdv_bd->bd_part)
> -		return pdv->pdv_bd->bd_part->nr_sects;
> +		return bdev_nr_sects(pdv->pdv_bd);
>   
>   	return 0;
>   }

As far as I can see bd_part does not change between blkdev_get() and 
blkdev_put(). Since the pscsi code guarantees that blkdev_put() is not 
called concurrently with pscsi_get_blocks() this patch is not necessary.

Bart.


