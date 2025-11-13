Return-Path: <linux-bcache+bounces-1255-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 31285C573DB
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 12:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C2154349679
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 11:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDC5933F8A4;
	Thu, 13 Nov 2025 11:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fvbMGTc+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E502345CC6
	for <linux-bcache@vger.kernel.org>; Thu, 13 Nov 2025 11:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763033906; cv=none; b=jGW4O7HZ1bkXMKbmmLmbOJwGBPzg30991zhgjLl9sPAL1YEXBil3NnKu+CTcMiMG34bcPEPCsZghC5ShN2zBUl2GohUdTIfUl+RiTWR5sWAUVDZRTk2X8X9f3b2EbmBCnQnxoFV+G9Am9jEx338dcUBEdccWx5C2hM344T4l/U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763033906; c=relaxed/simple;
	bh=ELnE8IV2Py/JdIKniMjJbWE3lX2i5Fc3ho84PTNS0jg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fI6oPGkV0RvuyVR6cL3NWiDcEekHSkI8j6EMq0tUdTf7Dt1pi9S99zHA635Ha2RIq8XxWc7EmZ0a7JMQWrukQQrZXfhnt2vyqDkbmUgNR5w5Z7FzZNhqsyXIMZ5fLIgw1qpFLyqPwQFDe/e2jk6bri34GBBfbuI7e8rV5KyxUX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fvbMGTc+; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-880499b2bc7so7035456d6.3
        for <linux-bcache@vger.kernel.org>; Thu, 13 Nov 2025 03:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763033904; x=1763638704; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pgP9WNWvxV4SyeMxufc+beHNpMEnN2n4g+p2ssHNpfM=;
        b=fvbMGTc+LwLhaHnuFA2e8J4tnLk9j4Hfczvt55mCkluwv5t+fzibKxRnhIio81XJWb
         kFoHomqQrYq0vsy4sdiBRvDlHFwQolPLCeSIEpMTgAaxqw80qNP7TYq3zJJk4J4tPHem
         7d62t4AlE1LgMS5tKHlQuXCMovPc3D0ZHbAz0Yn7r8Zw6saL6eAEbxAME/ZhtZzk6nkB
         wEBcUMO9Pzs5lVYbkRn2w3WvSblkr6uIIu21IdgmZD3eaSGHLj9JDfY/yVECfWxcJiUe
         TPui/PDd9ahdcftTbnACdA03GxQBo85BlbHAe2O5ZdFaA41F3MluAKXIPjCEpeZKCO6z
         6X7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763033904; x=1763638704;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgP9WNWvxV4SyeMxufc+beHNpMEnN2n4g+p2ssHNpfM=;
        b=FS5K/XFbnee9lhA+ihZWLp74agr3wvBjy7abiH/EeJkA6JrzKXUwOJhrUPvEF+hbdO
         z35YaGLjSbgXIrEdVc9aiYbKCShH5kt+JqFiZ+/KtMJLHKP1jC3quRk5/xBEn9H2Yu96
         0tavgDD0yor8tPadH6/IkygHBTjmWPln1UemS6mWbOY83eAkETiqdUCOVqdd/+oIPt1j
         V3JlcJzrl1P7gBbw19p2nDREZbDd7Cx+X9BumCuEEP5mYeGMbJjZw0oypl/PYlcpQaTX
         ydnVWv81DYSmY9tpgwf5NXEexV6kxhQ4gqaFx6lpUk0DFyrVSwqtyLi/psINMXkRI5vd
         BlwA==
X-Forwarded-Encrypted: i=1; AJvYcCVBpYrQXd6ab2bbDLpHHYT2Us8rnHK5Szp+q7yps1WkFWGVAaTk6JpKD9x+n/NThdlx5heGNYOWiM2iVQw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMv6yZrzTfPXVwe+Up3NB+CEIZ9VFR16GtYW+zlzymmpI4XNu6
	a43McTe2ZSXNI/fnJosrnwDRTLEYZNgenCBiTWy02+4SZuOQ/p/XvrnT029bUzy+F01FQutIXtQ
	6mvnkVGuIBltaFtRdkeVLtB/aAW3rwzfsT15xCEwLiA==
X-Gm-Gg: ASbGncs/Jetu116qzI24sOLYZXaENdfMg8dyQubmjepM+fA1MJAZq6BBuflr5eN5sph
	w17aWM1f6diOmZsQVPg2t2WtKiQ/rUVy8b5KyQfH0DkXs6LzkMeAXI50tzEbW5tUJtXpjDqvKS4
	znvh8vr1tT5tKUgCFPQjMTYOoMWMgz4rET+BS9+nySH1dy6aRp8uyFtTSvN1kegRgs/yWDRUoc5
	i1UQ7hmKZKzS2bHGo4gUiL259i/VmWIkfbPJR6Sx/4g77m3LeTZk7etjW+7
X-Google-Smtp-Source: AGHT+IFpLYzC3G5p9JQBS3rFphYbIEod4J5L5q0HiHlacwQQ7uFiNr3fLSmpcneuiRUvEsG67H4xiktWPd4IgVb8lI8=
X-Received: by 2002:ad4:5d47:0:b0:880:4ac3:fbdb with SMTP id
 6a1803df08f44-88271922123mr96370946d6.23.1763033904000; Thu, 13 Nov 2025
 03:38:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAsfc_ry+u771V_dTQMiXpaz2iGbQOPmZfhwnyF56pM+FjXdsw@mail.gmail.com>
 <4y5xucuqqqe4ppxu46nwsr6g34bu7ixc5xwwogdvkdpl3zhqi6@c6lj7rk5giem>
 <CAAsfc_pa=AwaaN6Fy2jU6nPwnGET0oZgWZtSc3LtQ9_oJ6supA@mail.gmail.com> <CAAsfc_rRK1rBVYFOzdioQSj5BL_t--Sbg6y5KhS+uiSeKz51xw@mail.gmail.com>
In-Reply-To: <CAAsfc_rRK1rBVYFOzdioQSj5BL_t--Sbg6y5KhS+uiSeKz51xw@mail.gmail.com>
From: liequan che <liequanche@gmail.com>
Date: Thu, 13 Nov 2025 19:38:11 +0800
X-Gm-Features: AWmQ_bmWIj-YyDux4f-p0e4dDonjgLkEi59TnpDIlgAdPp0GJH4xj-vG4i-IhZY
Message-ID: <CAAsfc_pafORaG_PrVpOB9GBK+YCjdzJMd2Ww=ya2PbcPkw04+w@mail.gmail.com>
Subject: [PATCH v2] bcache: fix UAF in cached_dev_free and safely flush/destroy
To: Coly Li <colyli@fnnas.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache <linux-bcache@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

stop writeback thread and rate-update work exactly once across teardown paths,
- Add STOP_THREAD_ONCE() and use it at all three places that stop
  dc->writeback_thread: cached_dev_detach_finish(), cached_dev_free(),
  and the bch_cached_dev_attach() error path.
- In cached_dev_detach_finish(), also clear WB_RUNNING and cancel the
  periodic writeback-rate delayed work to avoid a UAF window after
  detach is initiated.
- Keep the per-dc writeback workqueue flush/destroy in the writeback
  thread exit tail, avoiding double-destroy.
Signed-off-by: cheliequan <cheliequan@inspur.com>
---
 drivers/md/bcache/bcache.h    | 11 +++++++++++
 drivers/md/bcache/super.c     | 14 ++++++--------
 drivers/md/bcache/writeback.c |  7 +++++--
 3 files changed, 22 insertions(+), 10 deletions(-)
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d33e40d26ea..66dc5dca5c20 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -961,6 +961,17 @@ static inline void wait_for_kthread_stop(void)
        }
 }

+/*
+ * Stop a kthread exactly once by taking ownership of the pointer.
+ * Safe against concurrent callers and against already-stopped threads.
+ */
+#define STOP_THREAD_ONCE(dc, member)                                    \
+       do {                                                             \
+               struct task_struct *t__ = xchg(&(dc)->member, NULL);     \
+               if (t__ && !IS_ERR(t__))                                 \
+               kthread_stop(t__);                                       \
+       } while (0)
+
 /* Forward declarations */

 void bch_count_backing_io_errors(struct cached_dev *dc, struct bio *bio);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1492c8552255..b4da0a505d4a 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1143,8 +1143,7 @@ static void cached_dev_detach_finish(struct
work_struct *w)
                cancel_writeback_rate_update_dwork(dc);

        if (!IS_ERR_OR_NULL(dc->writeback_thread)) {
-               kthread_stop(dc->writeback_thread);
-               dc->writeback_thread = NULL;
+               STOP_THREAD_ONCE(dc, writeback_thread);
        }

        mutex_lock(&bch_register_lock);
@@ -1308,8 +1307,9 @@ int bch_cached_dev_attach(struct cached_dev *dc,
struct cache_set *c,
                 * created previously in bch_cached_dev_writeback_start()
                 * have to be stopped manually here.
                 */
-               kthread_stop(dc->writeback_thread);
-               cancel_writeback_rate_update_dwork(dc);
+               if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
+                       cancel_writeback_rate_update_dwork(dc);
+               STOP_THREAD_ONCE(dc, writeback_thread);
                pr_err("Couldn't run cached device %pg\n", dc->bdev);
                return ret;
        }
@@ -1349,10 +1349,8 @@ static CLOSURE_CALLBACK(cached_dev_free)
        if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
                cancel_writeback_rate_update_dwork(dc);

-       if (!IS_ERR_OR_NULL(dc->writeback_thread))
-               kthread_stop(dc->writeback_thread);
-       if (!IS_ERR_OR_NULL(dc->status_update_thread))
-               kthread_stop(dc->status_update_thread);
+       STOP_THREAD_ONCE(dc, writeback_thread);
+       STOP_THREAD_ONCE(dc, status_update_thread);

        mutex_lock(&bch_register_lock);

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 302e75f1fc4b..50e67a784acd 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -741,6 +741,7 @@ static int bch_writeback_thread(void *arg)
        struct cached_dev *dc = arg;
        struct cache_set *c = dc->disk.c;
        bool searched_full_index;
+       struct workqueue_struct *wq = NULL;

        bch_ratelimit_reset(&dc->writeback_rate);

@@ -832,8 +833,10 @@ static int bch_writeback_thread(void *arg)
                }
        }

-       if (dc->writeback_write_wq)
-               destroy_workqueue(dc->writeback_write_wq);
+       wq = xchg(&dc->writeback_write_wq, NULL);
+       if (wq) {
+           destroy_workqueue(wq);
+        }

        cached_dev_put(dc);
        wait_for_kthread_stop();
-- 
2.25.1

