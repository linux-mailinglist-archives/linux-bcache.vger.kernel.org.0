Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C18131124
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jan 2020 12:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgAFLGU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jan 2020 06:06:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:41362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgAFLGU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jan 2020 06:06:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3B230AD82;
        Mon,  6 Jan 2020 11:06:17 +0000 (UTC)
Subject: Re: [PATCH 3/7] bcache: rework error unwinding in register_bcache
To:     guoju fang <fangguoju@gmail.com>
References: <20191212153604.19540-1-hch@lst.de>
 <20191212153604.19540-4-hch@lst.de>
 <34f67cbf-a057-7d1a-e0fa-a4233df7a883@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <b87d17ac-c015-8d35-5ee9-68b288f4a30c@suse.de>
Date:   Mon, 6 Jan 2020 19:06:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <34f67cbf-a057-7d1a-e0fa-a4233df7a883@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/1/2 2:40 下午, guoju fang wrote:
> Hi Hellwig,
> 
> There's a bit problem in this patch, if try_module_get failed and then
> goto label out, pr_info will access path that was not initialized. To
> fix it, pr_info should be put before kfree(path).
> 
> Best Regards,
> Guoju.
> 

Yes, it is fixed in my for v5.6 series, like this,
307  out_free_path:
308         kfree(path);
309 +       path = NULL;
310  out_module_put:
311         module_put(THIS_MODULE);
312  out:
313 -       pr_info("error %s: %s", path, err);
314 +       pr_info("error %s: %s", path?path:"", err);
315         return ret;


> 
> On 2019/12/12 23:36, Christoph Hellwig wrote:
>> Split the successful and error return path, and use one goto label for
>> each
>> resource to unwind.  This also fixes some small errors like leaking the
>> module reference count in the reboot case (which seems entirely harmless)
>> or printing the wrong warning messages for early failures.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/md/bcache/super.c | 75 +++++++++++++++++++++++----------------
>>   1 file changed, 45 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 3045f27e0d67..e8013e1b0a14 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -2375,29 +2375,33 @@ static bool bch_is_open(struct block_device
>> *bdev)
>>   static ssize_t register_bcache(struct kobject *k, struct
>> kobj_attribute *attr,
>>                      const char *buffer, size_t size)
>>   {
>> -    ssize_t ret = -EINVAL;
>> -    const char *err = "cannot allocate memory";
>> -    char *path = NULL;
>> -    struct cache_sb *sb = NULL;
>> +    const char *err;
>> +    char *path;
>> +    struct cache_sb *sb;
>>       struct block_device *bdev = NULL;
>> -    struct page *sb_page = NULL;
>> +    struct page *sb_page;
>> +    ssize_t ret;
>>   +    ret = -EBUSY;
>>       if (!try_module_get(THIS_MODULE))
>> -        return -EBUSY;
>> +        goto out;
>>         /* For latest state of bcache_is_reboot */
>>       smp_mb();
>>       if (bcache_is_reboot)
>> -        return -EBUSY;
>> +        goto out_module_put;
>>   +    ret = -ENOMEM;
>> +    err = "cannot allocate memory";
>>       path = kstrndup(buffer, size, GFP_KERNEL);
>>       if (!path)
>> -        goto err;
>> +        goto out_module_put;
>>         sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL);
>>       if (!sb)
>> -        goto err;
>> +        goto out_free_path;
>>   +    ret = -EINVAL;
>>       err = "failed to open device";
>>       bdev = blkdev_get_by_path(strim(path),
>>                     FMODE_READ|FMODE_WRITE|FMODE_EXCL,
>> @@ -2414,57 +2418,68 @@ static ssize_t register_bcache(struct kobject
>> *k, struct kobj_attribute *attr,
>>               if (!IS_ERR(bdev))
>>                   bdput(bdev);
>>               if (attr == &ksysfs_register_quiet)
>> -                goto quiet_out;
>> +                goto done;
>>           }
>> -        goto err;
>> +        goto out_free_sb;
>>       }
>>         err = "failed to set blocksize";
>>       if (set_blocksize(bdev, 4096))
>> -        goto err_close;
>> +        goto out_blkdev_put;
>>         err = read_super(sb, bdev, &sb_page);
>>       if (err)
>> -        goto err_close;
>> +        goto out_blkdev_put;
>>         err = "failed to register device";
>>       if (SB_IS_BDEV(sb)) {
>>           struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
>>             if (!dc)
>> -            goto err_close;
>> +            goto out_put_sb_page;
>>             mutex_lock(&bch_register_lock);
>>           ret = register_bdev(sb, sb_page, bdev, dc);
>>           mutex_unlock(&bch_register_lock);
>>           /* blkdev_put() will be called in cached_dev_free() */
>> -        if (ret < 0)
>> -            goto err;
>> +        if (ret < 0) {
>> +            bdev = NULL;
>> +            goto out_put_sb_page;
>> +        }
>>       } else {
>>           struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
>>             if (!ca)
>> -            goto err_close;
>> +            goto out_put_sb_page;
>>             /* blkdev_put() will be called in bch_cache_release() */
>> -        if (register_cache(sb, sb_page, bdev, ca) != 0)
>> -            goto err;
>> +        if (register_cache(sb, sb_page, bdev, ca) != 0) {
>> +            bdev = NULL;
>> +            goto out_put_sb_page;
>> +        }
>>       }
>> -quiet_out:
>> -    ret = size;
>> -out:
>> -    if (sb_page)
>> -        put_page(sb_page);
>> +
>> +    put_page(sb_page);
>> +done:
>>       kfree(sb);
>>       kfree(path);
>>       module_put(THIS_MODULE);
>> -    return ret;
>> -
>> -err_close:
>> -    blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
>> -err:
>> +    return size;
>> +
>> +out_put_sb_page:
>> +    put_page(sb_page);
>> +out_blkdev_put:
>> +    if (bdev)
>> +        blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
>> +out_free_sb:
>> +    kfree(sb);
>> +out_free_path:
>> +    kfree(path);
>> +out_module_put:
>> +    module_put(THIS_MODULE);
>> +out:
>>       pr_info("error %s: %s", path, err);
>> -    goto out;
>> +    return ret;
>>   }
>>    


-- 

Coly Li
