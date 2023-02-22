Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE7869F0B8
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Feb 2023 09:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjBVIxy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 22 Feb 2023 03:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjBVIxx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Feb 2023 03:53:53 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AAC1C581
        for <linux-bcache@vger.kernel.org>; Wed, 22 Feb 2023 00:53:52 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id l2-20020a05600c1d0200b003e1f6dff952so5556580wms.1
        for <linux-bcache@vger.kernel.org>; Wed, 22 Feb 2023 00:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dVFw1d3E5p6ZAOiPPhC7Cv6PHO+c9gQTcv/x1pvDVtU=;
        b=DiWBkE/5XDNBSZhAoqNoClgUwCHjrKNYXw2HCSYHaIdhq0pVt1Ar55eg9aOTWXRa5p
         s7Rh8h0m7RCB4SzHyBF32LnHp0sbQ4Pcej9LEuftQvS6mWL1dLwKoOpKSS++qefYeeum
         wy5C8fN2LMjb3gB3HIMqxEpTEHYusRpDAiM8ZfzSp6+EqIhCxY/MzihSErbcU4q1PvWf
         FhNt3AICVMGRFiZK9vL6PZSrRWAoAfGKEz7UVGsKPNk9SVP/XduE9GhjXVRqXUXI+QA0
         9YVCKr6Un38A3alP8jG/r7ynn55+V1mK+Ah7vEqw5zzg/HwKq5MaZlPY0Jn7hI3ZM3XB
         DFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dVFw1d3E5p6ZAOiPPhC7Cv6PHO+c9gQTcv/x1pvDVtU=;
        b=p3xzim/eBM7vUCzTSAa7LmDkLUWddvJ7TPia/l58ITAU0FZ1iERgHXSDSerX3I6cWk
         0WGaJo7B69BlS4qQ6cNG961Z5fJjVDGaK3EEGi87FYulHzoQjTOCPFDad/z7oy/jMwrz
         WPT0qG1iHG1dUUOPwaCBOvkpUOJ3KzRGQgM+eeP6bt8fLur4HizS93zaZWykDZx2WDX/
         o1FfCKvwLKZRkyGUsyFAkHTIVXQBVFJibsjrEqVyLmPX5IsFY6tGss09eINmKl5V3tUG
         1m4b9OeV1dq/3E98rdnRDjaR3q7frzdlrJ/ZaxDRlsseuX2++UqMwooNksi8P/UpuCSb
         lXhg==
X-Gm-Message-State: AO0yUKUWjKU8OcFQBWIF3fT0CYTImOQPV7oS/4aN4+v9vEnb0/oXHBdn
        d1qdrWJVex8+oqT1l4/LKLL9aQ==
X-Google-Smtp-Source: AK7set8mkC6fGSF14zgWl1qcup8BuOMEYbbhfNKp0UCu4+rPCdFWhCE+nrMX/DkOF2xyVEJvUlxWqQ==
X-Received: by 2002:a05:600c:929:b0:3df:3bd6:63e5 with SMTP id m41-20020a05600c092900b003df3bd663e5mr4811728wmp.12.1677056030514;
        Wed, 22 Feb 2023 00:53:50 -0800 (PST)
Received: from 2021-EMEA-0269.devotools.com (143.69.14.37.dynamic.jazztel.es. [37.14.69.143])
        by smtp.googlemail.com with ESMTPSA id bh21-20020a05600c3d1500b003e2052bad94sm1076255wmb.33.2023.02.22.00.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 00:53:49 -0800 (PST)
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org,
        Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Subject: [PATCH v2] bcache: Add support for live resize of backing devices
Date:   Wed, 22 Feb 2023 09:53:33 +0100
Message-Id: <20230222085333.39021-1-andrea.tomassetti-opensource@devo.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When a disk changes size, udev rules are fired and register_bcache
function get called. With this patch, every time this happens, the
disk's capacity get checked: if it has changed then the new
bch_update_capacity function get called, otherwise it fails as before.

Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
---
Hi Coly,
this is the second version of the patch. As you correctly pointed out,
I implemented roll-back functionalities in case of error.
I'm testing this funcionality using QEMU/KVM vm via libvirt.
Here the steps:
  1. make-bcache --writeback -B /dev/vdb -C /dev/vdc
  2. mkfs.xfs /dev/bcache0
  3. mount /dev/bcache0 /mnt
  3. dd if=/dev/random of=/mnt/random0 bs=1M count=1000
  4. md5sum /mnt/random0 | tee /mnt/random0.md5
  5. [HOST] virsh blockresize <vm-name> --path <disk-path> --size <new-size>
  6. xfs_growfs /dev/bcache0
  6. Repeat steps 3 and 4 with a different file name (e.g. random1.md5)
  7. umount/reboot/remount and check that the md5 hashes are correct with
        md5sum -c /mnt/random?.md5

 drivers/md/bcache/super.c | 84 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..1435a3f605f8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2443,6 +2443,85 @@ static bool bch_is_open(dev_t dev)
 	return bch_is_open_cache(dev) || bch_is_open_backing(dev);
 }

+static bool bch_update_capacity(dev_t dev)
+{
+	const size_t max_stripes = min_t(size_t, INT_MAX,
+					 SIZE_MAX / sizeof(atomic_t));
+
+	uint64_t n, n_old, orig_cached_sectors = 0;
+	void *tmp_realloc;
+
+	int nr_stripes_old;
+	bool res = false;
+
+	struct bcache_device *d;
+	struct cache_set *c, *tc;
+	struct cached_dev *dcp, *t, *dc = NULL;
+
+	uint64_t parent_nr_sectors;
+
+	list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
+		list_for_each_entry_safe(dcp, t, &c->cached_devs, list)
+			if (dcp->bdev->bd_dev == dev) {
+				dc = dcp;
+				goto dc_found;
+			}
+
+dc_found:
+	if (!dc)
+		return false;
+
+	parent_nr_sectors = bdev_nr_sectors(dc->bdev) - dc->sb.data_offset;
+
+	if (parent_nr_sectors == bdev_nr_sectors(dc->disk.disk->part0))
+		return false;
+
+	d = &dc->disk;
+	orig_cached_sectors = d->c->cached_dev_sectors;
+
+	/* Force cached device sectors re-calc */
+	calc_cached_dev_sectors(d->c);
+
+	/* Block writeback thread */
+	down_write(&dc->writeback_lock);
+	nr_stripes_old = d->nr_stripes;
+	n = DIV_ROUND_UP_ULL(parent_nr_sectors, d->stripe_size);
+	if (!n || n > max_stripes) {
+		pr_err("nr_stripes too large or invalid: %llu (start sector beyond end of disk?)\n",
+			n);
+		goto restore_dev_sectors;
+	}
+	d->nr_stripes = n;
+
+	n = d->nr_stripes * sizeof(atomic_t);
+	n_old = nr_stripes_old * sizeof(atomic_t);
+	tmp_realloc = kvrealloc(d->stripe_sectors_dirty, n_old,
+		n, GFP_KERNEL);
+	if (!tmp_realloc)
+		goto restore_nr_stripes;
+
+	d->stripe_sectors_dirty = (atomic_t *) tmp_realloc;
+
+	n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
+	n_old = BITS_TO_LONGS(nr_stripes_old) * sizeof(unsigned long);
+	tmp_realloc = kvrealloc(d->full_dirty_stripes, n_old, n, GFP_KERNEL);
+	if (!tmp_realloc)
+		goto restore_nr_stripes;
+
+	d->full_dirty_stripes = (unsigned long *) tmp_realloc;
+
+	if ((res = set_capacity_and_notify(dc->disk.disk, parent_nr_sectors)))
+		goto unblock_and_exit;
+
+restore_nr_stripes:
+	d->nr_stripes = nr_stripes_old;
+restore_dev_sectors:
+	d->c->cached_dev_sectors = orig_cached_sectors;
+unblock_and_exit:
+	up_write(&dc->writeback_lock);
+	return res;
+}
+
 struct async_reg_args {
 	struct delayed_work reg_work;
 	char *path;
@@ -2569,7 +2648,10 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			mutex_lock(&bch_register_lock);
 			if (lookup_bdev(strim(path), &dev) == 0 &&
 			    bch_is_open(dev))
-				err = "device already registered";
+				if (bch_update_capacity(dev))
+					err = "capacity changed";
+				else
+					err = "device already registered";
 			else
 				err = "device busy";
 			mutex_unlock(&bch_register_lock);
--
2.39.0

