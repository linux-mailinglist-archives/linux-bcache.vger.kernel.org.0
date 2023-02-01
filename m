Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D7686DB4
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Feb 2023 19:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjBASN1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Feb 2023 13:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBASN0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Feb 2023 13:13:26 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C76713B
        for <linux-bcache@vger.kernel.org>; Wed,  1 Feb 2023 10:13:25 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id CE17A86;
        Wed,  1 Feb 2023 10:13:24 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 4QwD-5IVR6mM; Wed,  1 Feb 2023 10:13:20 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 6CDD049;
        Wed,  1 Feb 2023 10:13:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 6CDD049
Date:   Wed, 1 Feb 2023 10:13:20 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     mingzhe <mingzhe.zou@easystack.cn>
cc:     colyli@suse.de, andrea.tomassetti-opensource@devo.com,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        zoumingzhe@qq.com, Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [PATCH 3/3] bcache: support overlay bcache
In-Reply-To: <20230201065202.17610-3-mingzhe.zou@easystack.cn>
Message-ID: <e4a4362e-85d9-285d-726d-3b1df73329f8@ewheeler.net>
References: <20230201065202.17610-1-mingzhe.zou@easystack.cn> <20230201065202.17610-3-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-125853957-1675275200=:28752"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-125853957-1675275200=:28752
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 1 Feb 2023, mingzhe.zou@easystack.cn wrote:
> From: Dongsheng Yang <dongsheng.yang@easystack.cn>
> 
> If we want to build a bcache device with backing device of a bcache flash device,
> we will fail with creating a duplicated sysfs filename.
> 
> E.g:
> (1) we create bcache0 with vdc, then there is "/sys/block/bcache0/bcache" as a link to "/sys/block/vdc/bcache"
>  $ readlink /sys/block/bcache0/bcache
> ../../../pci0000:00/0000:00:0b.0/virtio4/block/vdc/bcache
> 
> (2) if we continue to create bcache1 with bcache0:
>  $ make-bcache -B /dev/bcache0
> 
> We will fail to register bdev with "sysfs: cannot create duplicate 
> filename '/devices/virtual/block/bcache0/bcache'"
> 
> How this commit solving this problem?
> E.g:
>    we have vdf as cache disk, vdc as backing disk.
>
>  $ make-bcache -C /dev/vdf -B /dev/vdc --wipe-bcache
>  $ echo 100G > /sys/block/vdf/bcache_cache/set/flash_vol_create
>  $ lsblk
> NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdf                        252:80   0   50G  0 disk
> ├─bcache0                  251:0    0  100G  0 disk
> └─bcache1                  251:128  0  100G  0 disk
> vdc                        252:32   0  100G  0 disk
> └─bcache0                  251:0    0  100G  0 disk
> 
> (a) rename sysfs file to more meaningful name:
> (a.2) bcahce_cache -> sysfs filename under cache disk (/sys/block/vdf/bcache_cache)
> (a.1) bcache_fdev -> flash bcache device (/sys/block/bcache1/bcache_fdev)
> (a.4) bcache_bdev -> sysfs filename for backing disk (/sys/block/vdc/bcache_bdev)
> (a.3) bcache_cdev -> link to /sys/block/vdc/bcache_bdev (/sys/block/bcache0/bcache_cdev)

Good idea.

> (b) create ->bcache lagacy link file for backward compatability
> $ ll /sys/block/vdc/bcache
> lrwxrwxrwx 1 root root 0 Oct 26 11:21 /sys/block/vdc/bcache -> bcache_bdev
> $ ll /sys/block/bcache0/bcache
> lrwxrwxrwx 1 root root 0 Oct 26 11:21 /sys/block/bcache0/bcache -> ../../../pci0000:00/0000:00:0b.0/virtio4/block/vdc/bcache_bdev
> $ ll /sys/block/bcache1/bcache
> lrwxrwxrwx 1 root root 0 Oct 26 11:19 /sys/block/bcache1/bcache -> bcache_fdev
> $ ll /sys/block/vdf/bcache
> lrwxrwxrwx 1 root root 0 Oct 26 11:17 /sys/block/vdf/bcache -> bcache_cache
> 
> These link are created with sysfs_create_link_nowarn(), that means, we dont
> care about the failure when creating if these links are already created.
> Because these lagacy sysfile are only for backwards compatability in no-overlay usecase
> of bcache, in the no-overlay use, bcache will never create duplicated link.

awesome.
 
> In overlay usecase after this commit, please dont use bcache link any more, instead
> use bcache_cdev, bcache_fdev, bcache_bdev or bcache_cache.
> 
> Then we can create a cached_dev with bcache1 (flash dev) as backing dev.
> $ make-bcache -B /dev/bcache1
> $ lsblk
> NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> vdf                        252:80   0   50G  0 disk
> ├─bcache0                  251:0    0  100G  0 disk
> └─bcache1                  251:128  0  100G  0 disk
>   └─bcache2                251:256  0  100G  0 disk
> 
> As a result there is a cached device bcache2 with backing device of a flash device bcache1.
>         ----------------------------
>         | bcache2 (cached_dev)     |
>         | ------------------------ |
>         | |   sdb (cache_dev)    | |
>         | ------------------------ |
>         | ------------------------ |
>         | |   bcache1 (flash_dev)| |
>         | ------------------------ |
>         ----------------------------

Does this allow an arbitrary depth of bcache stacking?

-Eric

> 
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
> ---
>  drivers/md/bcache/super.c | 40 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..0ca8c05831c9 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1087,12 +1087,19 @@ int bch_cached_dev_run(struct cached_dev *dc)
>  
>  	if (sysfs_create_link(&d->kobj, &disk_to_dev(d->disk)->kobj, "dev") ||
>  	    sysfs_create_link(&disk_to_dev(d->disk)->kobj,
> -			      &d->kobj, "bcache")) {
> +			      &d->kobj, "bcache_cdev")) {
>  		pr_err("Couldn't create bcache dev <-> disk sysfs symlinks\n");
>  		ret = -ENOMEM;
>  		goto out;
>  	}
>  
> +	ret = sysfs_create_link_nowarn(&disk_to_dev(d->disk)->kobj,
> +				       &d->kobj, "bcache");
> +	if (ret && ret != -EEXIST) {
> +		pr_err("Couldn't create lagacy disk sysfs ->bcache symlinks\n");
> +		goto out;
> +	}
> +
>  	dc->status_update_thread = kthread_run(cached_dev_status_update,
>  					       dc, "bcache_status_update");
>  	if (IS_ERR(dc->status_update_thread)) {
> @@ -1461,8 +1468,17 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>  		goto err;
>  
>  	err = "error creating kobject";
> -	if (kobject_add(&dc->disk.kobj, bdev_kobj(bdev), "bcache"))
> +	if (kobject_add(&dc->disk.kobj, bdev_kobj(bdev), "bcache_bdev"))
>  		goto err;
> +
> +	err = "error creating lagacy sysfs link";
> +	ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
> +				       &dc->disk.kobj, "bcache");
> +	if (ret && ret != -EEXIST) {
> +		pr_err("Couldn't create lagacy disk sysfs ->bcache");
> +		goto err;
> +	}
> +
>  	if (bch_cache_accounting_add_kobjs(&dc->accounting, &dc->disk.kobj))
>  		goto err;
>  
> @@ -1524,6 +1540,7 @@ static void flash_dev_flush(struct closure *cl)
>  
>  static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
>  {
> +	int ret;
>  	int err = -ENOMEM;
>  	struct bcache_device *d = kzalloc(sizeof(struct bcache_device),
>  					  GFP_KERNEL);
> @@ -1546,10 +1563,17 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
>  	if (err)
>  		goto err;
>  
> -	err = kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache");
> +	err = kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache_fdev");
>  	if (err)
>  		goto err;
>  
> +	ret = sysfs_create_link_nowarn(&disk_to_dev(d->disk)->kobj,
> +				       &d->kobj, "bcache");
> +	if (ret && ret != -EEXIST) {
> +		pr_err("Couldn't create lagacy flash dev ->bcache");
> +		goto err;
> +	}
> +
>  	bcache_device_link(d, c, "volume");
>  
>  	if (bch_has_feature_obso_large_bucket(&c->cache->sb)) {
> @@ -2370,12 +2394,20 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>  		goto err;
>  	}
>  
> -	if (kobject_add(&ca->kobj, bdev_kobj(bdev), "bcache")) {
> +	if (kobject_add(&ca->kobj, bdev_kobj(bdev), "bcache_cache")) {
>  		err = "error calling kobject_add";
>  		ret = -ENOMEM;
>  		goto out;
>  	}
>  
> +	ret = sysfs_create_link_nowarn(&part_to_dev(bdev->bd_part)->kobj,
> +				       &ca->kobj, "bcache");
> +	if (ret && ret != -EEXIST) {
> +		pr_err("Couldn't create lagacy disk sysfs ->cache symlinks\n");
> +		goto out;
> +	} else
> +		ret = 0;
> +
>  	mutex_lock(&bch_register_lock);
>  	err = register_cache_set(ca);
>  	mutex_unlock(&bch_register_lock);
> -- 
> 2.17.1
> 
> 
--8323328-125853957-1675275200=:28752--
