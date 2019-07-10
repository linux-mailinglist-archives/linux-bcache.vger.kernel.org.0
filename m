Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E71B64466
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Jul 2019 11:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfGJJbW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Jul 2019 05:31:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46728 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJJbW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Jul 2019 05:31:22 -0400
Received: from mail-wm1-f69.google.com ([209.85.128.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <andrea.righi@canonical.com>)
        id 1hl8wa-0008Np-5g
        for linux-bcache@vger.kernel.org; Wed, 10 Jul 2019 09:31:20 +0000
Received: by mail-wm1-f69.google.com with SMTP id f189so524194wme.5
        for <linux-bcache@vger.kernel.org>; Wed, 10 Jul 2019 02:31:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=hHPquRzHtRgMtJsb7Rvs2e23qBtTkAoO0X1njgJaMYA=;
        b=hFhPWneaHMoxP7qgrDxKCk4fADLoqzdMrft0W9lZG70nmuy3QxMyJW4U8OZv7J1tx8
         gLnMO0G31AAXf/VzIcIZMOa9eHcjtHns6b0SLucrJEvTdiZjG7b/EIullP0Eyg8JENVg
         ouBC877HV94wl/gO5QOfrKDSkoPLb2fkFzl2uLSHI6/a4Uwrq/pJoDwGzcdo7hUO4rx7
         HzuxXcNGGXUzToC3GuL1KShnfifPdf2sUAMNEkktCwz0ITYwxbeH5ppptoit3TajPbU9
         rjPd2e9X3DLGM1Z6UNSF/exgM8KJRUs4cLXgMl6wbH5KYP9ZIF7MOvUFcy7yXNkgdXl3
         RIUw==
X-Gm-Message-State: APjAAAXiq5ot5ai7IEzfgSZwWeQZEV9uPBw+4WQBqe0JIAwn+TnwOXpK
        q2m1YbxpBVQab6177Z9MXFeSrFjRuBca6L/RKwL9CJJHx2DgxqRbIvqWe8yQkXt74l44FKkNH7u
        KdwHynC5BtdV6aphJmvdysP2r76nHraQVz6ewrm3EWg==
X-Received: by 2002:adf:de10:: with SMTP id b16mr40612wrm.296.1562751079581;
        Wed, 10 Jul 2019 02:31:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqytLogyZohPzr1HFOmbE/x/1a7unmZGtecEIOhDViRcPJnLjsY03n0YB7/wA800VwKpDtmTzw==
X-Received: by 2002:adf:de10:: with SMTP id b16mr40582wrm.296.1562751079307;
        Wed, 10 Jul 2019 02:31:19 -0700 (PDT)
Received: from localhost (host1-198-dynamic.8-87-r.retail.telecomitalia.it. [87.8.198.1])
        by smtp.gmail.com with ESMTPSA id g12sm2220469wrv.9.2019.07.10.02.31.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 02:31:18 -0700 (PDT)
Date:   Wed, 10 Jul 2019 11:31:17 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bcache: fix deadlock in bcache_allocator()
Message-ID: <20190710093117.GA2792@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

bcache_allocator() can call the following:

 bch_allocator_thread()
  -> bch_prio_write()
     -> bch_bucket_alloc()
        -> wait on &ca->set->bucket_wait

But the wake up event on bucket_wait is supposed to come from
bch_allocator_thread() itself => deadlock:

 [ 242.888435] INFO: task bcache_allocato:9015 blocked for more than 120 seconds.
 [ 242.893786] Not tainted 4.20.0-042000rc3-generic #201811182231
 [ 242.896669] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [ 242.900428] bcache_allocato D 0 9015 2 0x80000000
 [ 242.900434] Call Trace:
 [ 242.900448] __schedule+0x2a2/0x880
 [ 242.900455] ? __schedule+0x2aa/0x880
 [ 242.900462] schedule+0x2c/0x80
 [ 242.900480] bch_bucket_alloc+0x19d/0x380 [bcache]
 [ 242.900503] ? wait_woken+0x80/0x80
 [ 242.900519] bch_prio_write+0x190/0x340 [bcache]
 [ 242.900530] bch_allocator_thread+0x482/0xd10 [bcache]
 [ 242.900535] kthread+0x120/0x140
 [ 242.900546] ? bch_invalidate_one_bucket+0x80/0x80 [bcache]
 [ 242.900549] ? kthread_park+0x90/0x90
 [ 242.900554] ret_from_fork+0x35/0x40

Fix by making the call to bch_prio_write() non-blocking, so that
bch_allocator_thread() never waits on itself.

Moreover, make sure to wake up the garbage collector thread when
bch_prio_write() is failing to allocate buckets.

BugLink: https://bugs.launchpad.net/bugs/1784665
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 drivers/md/bcache/alloc.c  |  6 +++++-
 drivers/md/bcache/bcache.h |  2 +-
 drivers/md/bcache/super.c  | 13 +++++++++----
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index f8986effcb50..0797587600c7 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -377,7 +377,11 @@ static int bch_allocator_thread(void *arg)
 			if (!fifo_full(&ca->free_inc))
 				goto retry_invalidate;
 
-			bch_prio_write(ca);
+			if (bch_prio_write(ca, false) < 0) {
+				ca->invalidate_needs_gc = 1;
+				wake_up_gc(ca->set);
+				goto retry_invalidate;
+			}
 		}
 	}
 out:
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index fdf75352e16a..dc5106b21260 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -979,7 +979,7 @@ bool bch_cached_dev_error(struct cached_dev *dc);
 __printf(2, 3)
 bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...);
 
-void bch_prio_write(struct cache *ca);
+int bch_prio_write(struct cache *ca, bool wait);
 void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
 
 extern struct workqueue_struct *bcache_wq;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1b63ac876169..6598b457df1a 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -525,7 +525,7 @@ static void prio_io(struct cache *ca, uint64_t bucket, int op,
 	closure_sync(cl);
 }
 
-void bch_prio_write(struct cache *ca)
+int bch_prio_write(struct cache *ca, bool wait)
 {
 	int i;
 	struct bucket *b;
@@ -560,8 +560,12 @@ void bch_prio_write(struct cache *ca)
 		p->magic	= pset_magic(&ca->sb);
 		p->csum		= bch_crc64(&p->magic, bucket_bytes(ca) - 8);
 
-		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, true);
-		BUG_ON(bucket == -1);
+		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, wait);
+		if (bucket == -1) {
+			if (!wait)
+				return -ENOMEM;
+			BUG_ON(1);
+		}
 
 		mutex_unlock(&ca->set->bucket_lock);
 		prio_io(ca, bucket, REQ_OP_WRITE, 0);
@@ -589,6 +593,7 @@ void bch_prio_write(struct cache *ca)
 
 		ca->prio_last_buckets[i] = ca->prio_buckets[i];
 	}
+	return 0;
 }
 
 static void prio_read(struct cache *ca, uint64_t bucket)
@@ -1903,7 +1908,7 @@ static int run_cache_set(struct cache_set *c)
 
 		mutex_lock(&c->bucket_lock);
 		for_each_cache(ca, c, i)
-			bch_prio_write(ca);
+			bch_prio_write(ca, true);
 		mutex_unlock(&c->bucket_lock);
 
 		err = "cannot allocate new UUID bucket";
-- 
2.20.1

