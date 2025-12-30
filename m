Return-Path: <linux-bcache+bounces-1353-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3538ACE98BC
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Dec 2025 12:34:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3C109303295F
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Dec 2025 11:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095B42E11A6;
	Tue, 30 Dec 2025 11:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Et7nYYrn"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BDB2DA74C
	for <linux-bcache@vger.kernel.org>; Tue, 30 Dec 2025 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767094450; cv=none; b=LppG43XQmx9gDyBbb2j0Kku7sju0l542b827ssqiDHKaOX6AuwRtafwZIOPvJhgUXR1V0/HgVsxaJIQ/SxCUlbDpapNtcf/H0uENa1ui4WeK/c5sMjHWth7Q4IJpWc3sx//XZv6/WvhQZS12VIlJ2lxy3TeUYrqVV8VmFO1ifQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767094450; c=relaxed/simple;
	bh=fVbMV8nmlt82rY0TBKi8+a2SJKlkPtVhDMohWorJhfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M7aNdVs/e4Qq0T9lDhI6XFEF8eH3PM3tzd/Et/yQtJqwEFJtOyZl4JqJvDdYgntMyJaEEeP4dyxCoKTTKfor1ABAvpqErw9gAFKluB4sZBu7Aq+o7Y5Vke7QLAr+ur/vGKN63efVd88nhzYxDyKq4OiXFellHjrA7eWoCFZBqos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Et7nYYrn; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7bc248dc16aso7813612b3a.0
        for <linux-bcache@vger.kernel.org>; Tue, 30 Dec 2025 03:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767094446; x=1767699246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CvMYG/A90bG23VE7NzZHbQYKGHEa/x98YrYvGiQT+mc=;
        b=Et7nYYrnGLiQDEbKl33ZXO8VxYH/bR+Pq8oIj8/pnXjiYZax7FjibJbgbJBDvRzPs8
         6rs89BU68pNtTqomFwwKh6lzBcmmhpMCxpBwF9B+AFUM3bxxo+iMTIUM2NAJlVi6cEUi
         RK+5RW6V1Ts9NVIhI6nV+XPuambwoqM2ob3wRY3cWZJ3NvMtjo1uSPaGDwN5wfSFNXDt
         z9SA+z3lUJiDyB/gC26oW1Y25EIo47qCkRxqxdcsSvrMQqPGRSAOC7VJlGjMhbWG+j/5
         /Bco0VMGk6XYM87gFTPZef//WnIAxS8H9cwsT1XZdPcG1bQmv9hq958iGsjh86ZM0RhD
         43fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767094446; x=1767699246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CvMYG/A90bG23VE7NzZHbQYKGHEa/x98YrYvGiQT+mc=;
        b=FpTlnMCjUMlSVfe7I9+QF6f3tkYDXvYmt/qYBHhM5M1ktCVdmMTjB9NKsYESyH6tVe
         T/LwzObBHVnMKyUIm/SJGsUejbhAG3C0bgNQ8nhlnIYm/TsIdDfmL+MzbUBsGTKJGaSe
         A3rTyE6I8TC1NBuBBkfTtsEkg6F12zzMYTAJgq+UcbPTVp3C6OnLbNN5dbAVu9qs+pF0
         bbed8UNRIiEUmDnUlj71ZEUPiKYcLAhzO8fR2jZMBazavWIwsxCu03Y9Qo8wdiZ1Ov1Y
         gX8SgAsbEe0aYEHSb29tu/6KgjPmaD1In3D5Lb9cXSA3W0pKsUmvlM1xg1fgRDIJc38F
         GXDg==
X-Forwarded-Encrypted: i=1; AJvYcCW06lllxPvl/nn56v2oGjUMy2NoLwt0/A7Ysbf1K31GGn0P3renuEDBw6NwNVbBUqr333pNw9E8SbQa5Vk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDuvcm0MZQf8YsMmOnFV3I/pVQNnV20J3pO1d+I8i3fPoI/t6f
	syRtHD/Hc5TrHqTI27+jaks27usJyDVyd/NbQAZDFVJmctVjOHi+ThLk
X-Gm-Gg: AY/fxX7RcGiDBz5dtRappsXp0bequIgqBDXZFN8AoP+xUIodFyqEanwu+Tu0VgcQ8to
	gUEwMolpsy9yAerFsGCD4WpQCIMx3y7v9JbqAgbTW0tcc+PLmNI2lDHskFFM1R6RaQoYCIeLlBU
	rio3aPz2KRQzG4G+xoFjC18dA4Pb0A4hgwnm/b9cRb5Zpcw5aX8c9Uw6jmhpmH6RXHTeCFkO7Pf
	Iu0jXQ42Jb3DCa2LS23GoJUNBYmtBAWmLnCDq/XMH2hd+nXCL3kEygu7OnzKtHRvgqhPb0rML+S
	aCV1QzDSoFYp+nk9Limo64om7QtQze3JXuA1h2ibbBMi1lQbUB5UR09oFPUc7U1F7efM3DDPSot
	GsCQOvA1xldCaN43HUROalRPPwlOpZ9riJ+y5jwyducO+DBXfSE7vofD1fiD5mmt+mpEpI+PgCa
	K6Nx4wkXPKVfH0nkm9nngerPuO7sfwSKdQIdrxyns=
X-Google-Smtp-Source: AGHT+IEV5TflS9tHM0tLGCg+9ibBidLnOdjGamA6mZ9yLrw690A4lBdCKBmaUIhYo4Zx2Vz6hqfvRg==
X-Received: by 2002:aa7:91c8:0:b0:7ff:cff1:7273 with SMTP id d2e1a72fcca58-7ffcff17488mr20452643b3a.46.1767094446442;
        Tue, 30 Dec 2025 03:34:06 -0800 (PST)
Received: from DESKTOP-LBGNL84.ugreendc.com ([209.146.12.194])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-80d8d93f7f0sm6223434b3a.22.2025.12.30.03.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 03:34:06 -0800 (PST)
From: Wale Zhang <wale.zhang.ftd@gmail.com>
To: colyli@fnnas.com
Cc: kent.overstreet@linux.dev,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wale Zhang <wale.zhang.ftd@gmail.com>
Subject: [RFC PATCH] bcache: make bcache_is_reboot atomic.
Date: Tue, 30 Dec 2025 19:33:57 +0800
Message-ID: <20251230113357.1299759-1-wale.zhang.ftd@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bcache: make bcache_is_reboot atomic.

The smp_mb is mainly used to ensure the dependency relationship between
variables, but there is only one variable bcache_is_reboot. Therefore,
using smp_mb is not very appropriate.

When bcache_reboot and register_bcache occur concurrently, register_bcache
cannot immediately detect that bcache_is_reboot has been set to true.

    cpu0                            cpu1
bcache_reboot
  bcache_is_reboot = true;
  smp_mb();                      register_bcache
                                   smp_mb();
                                   if (bcache_is_reboot)
                                   // bcache_is_reboot may still be false.

Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
---
 drivers/md/bcache/super.c | 19 ++++++-------------
 drivers/md/bcache/sysfs.c | 14 +++++++-------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c17d4517af22..0b2098aa7234 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -41,7 +41,7 @@ static const char invalid_uuid[] = {
 
 static struct kobject *bcache_kobj;
 struct mutex bch_register_lock;
-bool bcache_is_reboot;
+atomic_t bcache_is_reboot = ATOMIC_INIT(0);
 LIST_HEAD(bch_cache_sets);
 static LIST_HEAD(uncached_devices);
 
@@ -2561,10 +2561,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (!try_module_get(THIS_MODULE))
 		goto out;
 
-	/* For latest state of bcache_is_reboot */
-	smp_mb();
 	err = "bcache is in reboot";
-	if (bcache_is_reboot)
+	if (atomic_read(&bcache_is_reboot))
 		goto out_module_put;
 
 	ret = -ENOMEM;
@@ -2735,7 +2733,7 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 
 static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 {
-	if (bcache_is_reboot)
+	if (atomic_read(&bcache_is_reboot))
 		return NOTIFY_DONE;
 
 	if (code == SYS_DOWN ||
@@ -2750,16 +2748,11 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 
 		mutex_lock(&bch_register_lock);
 
-		if (bcache_is_reboot)
+		if (atomic_read(&bcache_is_reboot))
 			goto out;
 
 		/* New registration is rejected since now */
-		bcache_is_reboot = true;
-		/*
-		 * Make registering caller (if there is) on other CPU
-		 * core know bcache_is_reboot set to true earlier
-		 */
-		smp_mb();
+		atomic_set(&bcache_is_reboot, 1);
 
 		if (list_empty(&bch_cache_sets) &&
 		    list_empty(&uncached_devices))
@@ -2935,7 +2928,7 @@ static int __init bcache_init(void)
 
 	bch_debug_init();
 
-	bcache_is_reboot = false;
+	atomic_set(&bcache_is_reboot, 0);
 
 	return 0;
 err:
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 72f38e5b6f5c..5384653c5bbb 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -17,7 +17,7 @@
 #include <linux/sort.h>
 #include <linux/sched/clock.h>
 
-extern bool bcache_is_reboot;
+extern atomic_t bcache_is_reboot;
 
 /* Default is 0 ("writethrough") */
 static const char * const bch_cache_modes[] = {
@@ -296,7 +296,7 @@ STORE(__cached_dev)
 	struct kobj_uevent_env *env;
 
 	/* no user space access if system is rebooting */
-	if (bcache_is_reboot)
+	if (atomic_read(&bcache_is_reboot))
 		return -EBUSY;
 
 #define d_strtoul(var)		sysfs_strtoul(var, dc->var)
@@ -459,7 +459,7 @@ STORE(bch_cached_dev)
 					     disk.kobj);
 
 	/* no user space access if system is rebooting */
-	if (bcache_is_reboot)
+	if (atomic_read(&bcache_is_reboot))
 		return -EBUSY;
 
 	mutex_lock(&bch_register_lock);
@@ -571,7 +571,7 @@ STORE(__bch_flash_dev)
 	struct uuid_entry *u = &d->c->uuids[d->id];
 
 	/* no user space access if system is rebooting */
-	if (bcache_is_reboot)
+	if (atomic_read(&bcache_is_reboot))
 		return -EBUSY;
 
 	sysfs_strtoul(data_csum,	d->data_csum);
@@ -814,7 +814,7 @@ STORE(__bch_cache_set)
 	ssize_t v;
 
 	/* no user space access if system is rebooting */
-	if (bcache_is_reboot)
+	if (atomic_read(&bcache_is_reboot))
 		return -EBUSY;
 
 	if (attr == &sysfs_unregister)
@@ -941,7 +941,7 @@ STORE(bch_cache_set_internal)
 	struct cache_set *c = container_of(kobj, struct cache_set, internal);
 
 	/* no user space access if system is rebooting */
-	if (bcache_is_reboot)
+	if (atomic_read(&bcache_is_reboot))
 		return -EBUSY;
 
 	return bch_cache_set_store(&c->kobj, attr, buf, size);
@@ -1137,7 +1137,7 @@ STORE(__bch_cache)
 	ssize_t v;
 
 	/* no user space access if system is rebooting */
-	if (bcache_is_reboot)
+	if (atomic_read(&bcache_is_reboot))
 		return -EBUSY;
 
 	if (attr == &sysfs_cache_replacement_policy) {
-- 
2.43.0


