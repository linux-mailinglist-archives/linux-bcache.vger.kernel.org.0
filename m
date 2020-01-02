Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4A312E329
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Jan 2020 07:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgABGlP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Jan 2020 01:41:15 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33212 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgABGlO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Jan 2020 01:41:14 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so21460267pgk.0
        for <linux-bcache@vger.kernel.org>; Wed, 01 Jan 2020 22:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:in-reply-to:from:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=N9RStK7jK31IMkYsK9Zmty0p4l3nirgKbh7bIe53dXM=;
        b=DjMpV7H7Cdpqv92loVicQMFNBvX/o3CvXkX54DC/A8sYqj7HgJBU5ynOg45QEAgTfq
         VWbZG7u38WQcekoJ82PxUG0KCofV479Y5WHuEnC1+jaXNQALSX5DlqYZuiqAyIkC2EUW
         zqiZVErDwJBdVxWCXU8wuarMOuNollZZ6bKUrPAN+lyvhluDIkUTvT6QzySvLlWz7QTS
         7L7KbAaLtUyHrAeuQn3hhC/3749ZNvXKsOoqV0aC+kShRrtTgOuCjL9Wpd1pYTgsfD2j
         Nnv3JjJCrCMbkPAnMFAO0fMrDIclOu3er1RvgpS5HwMpn4zl2YTvLV2m1A9yWfKiKi92
         NHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:in-reply-to:from
         :message-id:date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=N9RStK7jK31IMkYsK9Zmty0p4l3nirgKbh7bIe53dXM=;
        b=fMRpNyf4ERX/Dc4iObhU2NrrMZvYMMVWIzOeA/3ZSav5H7k270IBVGJYSwncnLnElS
         lZ0xFLn5vgERHfZaFRchi1LJjWEu5gPvlvtSygLOT/vNypXAS6qqxzH3fExPlXidjYmg
         QzHGr9+oONS4tOeTaVDqe6V3AOTYiXvg1KArKIq7vLd+86JItoAdDUh6dQSq+5aUzAAJ
         cCI+vY5o2P+IVl/guzy4fkzxSIWfXDpkv8xAaSk6elc9Fftg2Ct/3aBhfqj79LlCHIQn
         IcZ6gJrtKKPsHjocFJroyCY1JLliS6re2eWzEvjOOhu/dYx0uGPHnKz/NAhmUqVRGcfs
         eOaA==
X-Gm-Message-State: APjAAAV2tJblLD6ThQlPXP7BHC5IWLqtH4Z+jraJ9Mkx7pL+chAv5Zvp
        r1wxup1wyHTusN8eZX0Wcyk2dQy2Z5A=
X-Google-Smtp-Source: APXvYqwVEnrGtsrUlWxXrQ7A04tZcTpfUGvGKKQv3+wNwZeIVek8X4gNTvjZBxv2Wua+FVD54m51EQ==
X-Received: by 2002:aa7:94a4:: with SMTP id a4mr86600990pfl.178.1577947273711;
        Wed, 01 Jan 2020 22:41:13 -0800 (PST)
Received: from [0.0.0.0] (199.168.137.127.16clouds.com. [199.168.137.127])
        by smtp.gmail.com with ESMTPSA id k21sm48817036pfa.63.2020.01.01.22.41.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Jan 2020 22:41:13 -0800 (PST)
Subject: Re: [PATCH 3/7] bcache: rework error unwinding in register_bcache
To:     Christoph Hellwig <hch@lst.de>, linux-bcache@vger.kernel.org
References: <20191212153604.19540-1-hch@lst.de>
 <20191212153604.19540-4-hch@lst.de>
In-Reply-To: <20191212153604.19540-4-hch@lst.de>
From:   guoju fang <fangguoju@gmail.com>
Message-ID: <34f67cbf-a057-7d1a-e0fa-a4233df7a883@gmail.com>
Date:   Thu, 2 Jan 2020 14:40:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Hellwig,

There's a bit problem in this patch, if try_module_get failed and then 
goto label out, pr_info will access path that was not initialized. To 
fix it, pr_info should be put before kfree(path).

Best Regards,
Guoju.


On 2019/12/12 23:36, Christoph Hellwig wrote:
> Split the successful and error return path, and use one goto label for each
> resource to unwind.  This also fixes some small errors like leaking the
> module reference count in the reboot case (which seems entirely harmless)
> or printing the wrong warning messages for early failures.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/bcache/super.c | 75 +++++++++++++++++++++++----------------
>   1 file changed, 45 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 3045f27e0d67..e8013e1b0a14 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2375,29 +2375,33 @@ static bool bch_is_open(struct block_device *bdev)
>   static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>   			       const char *buffer, size_t size)
>   {
> -	ssize_t ret = -EINVAL;
> -	const char *err = "cannot allocate memory";
> -	char *path = NULL;
> -	struct cache_sb *sb = NULL;
> +	const char *err;
> +	char *path;
> +	struct cache_sb *sb;
>   	struct block_device *bdev = NULL;
> -	struct page *sb_page = NULL;
> +	struct page *sb_page;
> +	ssize_t ret;
>   
> +	ret = -EBUSY;
>   	if (!try_module_get(THIS_MODULE))
> -		return -EBUSY;
> +		goto out;
>   
>   	/* For latest state of bcache_is_reboot */
>   	smp_mb();
>   	if (bcache_is_reboot)
> -		return -EBUSY;
> +		goto out_module_put;
>   
> +	ret = -ENOMEM;
> +	err = "cannot allocate memory";
>   	path = kstrndup(buffer, size, GFP_KERNEL);
>   	if (!path)
> -		goto err;
> +		goto out_module_put;
>   
>   	sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL);
>   	if (!sb)
> -		goto err;
> +		goto out_free_path;
>   
> +	ret = -EINVAL;
>   	err = "failed to open device";
>   	bdev = blkdev_get_by_path(strim(path),
>   				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
> @@ -2414,57 +2418,68 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>   			if (!IS_ERR(bdev))
>   				bdput(bdev);
>   			if (attr == &ksysfs_register_quiet)
> -				goto quiet_out;
> +				goto done;
>   		}
> -		goto err;
> +		goto out_free_sb;
>   	}
>   
>   	err = "failed to set blocksize";
>   	if (set_blocksize(bdev, 4096))
> -		goto err_close;
> +		goto out_blkdev_put;
>   
>   	err = read_super(sb, bdev, &sb_page);
>   	if (err)
> -		goto err_close;
> +		goto out_blkdev_put;
>   
>   	err = "failed to register device";
>   	if (SB_IS_BDEV(sb)) {
>   		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
>   
>   		if (!dc)
> -			goto err_close;
> +			goto out_put_sb_page;
>   
>   		mutex_lock(&bch_register_lock);
>   		ret = register_bdev(sb, sb_page, bdev, dc);
>   		mutex_unlock(&bch_register_lock);
>   		/* blkdev_put() will be called in cached_dev_free() */
> -		if (ret < 0)
> -			goto err;
> +		if (ret < 0) {
> +			bdev = NULL;
> +			goto out_put_sb_page;
> +		}
>   	} else {
>   		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
>   
>   		if (!ca)
> -			goto err_close;
> +			goto out_put_sb_page;
>   
>   		/* blkdev_put() will be called in bch_cache_release() */
> -		if (register_cache(sb, sb_page, bdev, ca) != 0)
> -			goto err;
> +		if (register_cache(sb, sb_page, bdev, ca) != 0) {
> +			bdev = NULL;
> +			goto out_put_sb_page;
> +		}
>   	}
> -quiet_out:
> -	ret = size;
> -out:
> -	if (sb_page)
> -		put_page(sb_page);
> +
> +	put_page(sb_page);
> +done:
>   	kfree(sb);
>   	kfree(path);
>   	module_put(THIS_MODULE);
> -	return ret;
> -
> -err_close:
> -	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
> -err:
> +	return size;
> +
> +out_put_sb_page:
> +	put_page(sb_page);
> +out_blkdev_put:
> +	if (bdev)
> +		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
> +out_free_sb:
> +	kfree(sb);
> +out_free_path:
> +	kfree(path);
> +out_module_put:
> +	module_put(THIS_MODULE);
> +out:
>   	pr_info("error %s: %s", path, err);
> -	goto out;
> +	return ret;
>   }
>   
>   
> 
