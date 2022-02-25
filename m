Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FAB4C417A
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Feb 2022 10:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbiBYJcq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 25 Feb 2022 04:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235025AbiBYJcp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 25 Feb 2022 04:32:45 -0500
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E744187BB2
        for <linux-bcache@vger.kernel.org>; Fri, 25 Feb 2022 01:32:12 -0800 (PST)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id E2F3B8A04E6;
        Fri, 25 Feb 2022 17:32:06 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com, ZouMingzhe <mingzhe.zou@easystack.cn>
Subject: [PATCH] bcache: add writeback_dynamic_rate in configfs
Date:   Fri, 25 Feb 2022 17:32:05 +0800
Message-Id: <20220225093205.5652-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRpCQkpWQhpDQ0pKHhpLQ0
        9DVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PE06Fxw4OjIxHVYaQwMUHQwu
        NwEwCkhVSlVKTU9OTENKTklMSUNOVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBQ09ITjcG
X-HM-Tid: 0a7f30392a09841dkuqwe2f3b8a04e6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: ZouMingzhe <mingzhe.zou@easystack.cn>

The writeback_rate value can be dynamically modified by PI controller.
However, the PI is only valid when dirty > target and writeback_rate
will be limited to writeback_rate_minimum when dirty < target.

The target value is calculated by __calc_target_rate() and user can
modify write_percent to change target. The write_percent can be any
integer between 0 and bch_cutoff_writeback, but 0 is a special value.
If the write_percent is 0, the writeback_rate will never update.

If we want to self-adaptive adjustment writeback_rate when dirty > 0,
this is impossible! This patch add writeback_dynamic_rate in configfs
to replace the logic of write_percent = 0. Then, the write_percent can
be set to 0 if we hope the PI controller to work consistently.

Below is the performance data under 300G caching disk and 100G backing disk.

For same parameters (use default value):
    writeback_rate_minimum : 8 (4k/s)
    writeback_rate_p_term_inverse : 40
    writeback_rate_i_term_inverse : 10000
    writeback_rate_update_seconds : 5

For different parameters:
    A. enable dynamic rate and keep 1% dirty_data (writeback target abort 3G)
        writeback_dynamic_rate = 1, writeback_percent = 1

    B. enable dynamic rate and keep 0% dirty_data
        writeback_dynamic_rate = 1, writeback_percent = 0

    C. disable dynamic rate
        writeback_dynamic_rate = 0

Test results:
            Tab.1 fio randwrite 10GiB under rate 100MiB/s
    ================================================================
        time      | 10s   | 20s   | 30s   | 40s   | 50s   | 60s
    --------------+-------+-------+-------+-------+-------+---------
    A's dirty     | 0.9G  | 1.9G  | 2.9G  | 3.5G  | 4.7G  | 5.5G
        rate(p+i) | 4k    | 4k    | 6.2M  | 18.4M | 43.0M | 65.7M
        rate_p    |-55.5M |-29.9M |-4.3M  | 7.6M  | 32.3M | 55.0M
        rate_i    | 12.4M | 11.0M | 10.5M | 10.7M | 10.7M | 10.7M
    --------------+-------+-------+-------+-------+-------+---------
    B's dirty     | 958.2M| 1.7G  | 2.6G  | 3.4G  | 4.3G  | 5.2G
        rate(p+i) | 38.4M | 60.6M | 71.9M | 94.1M | 117.1M| 139.5M
        rate_p    | 23.2M | 45.4M | 56.7M | 78.9M | 102.0M| 124.4M
        rate_i    | 15.1M | 15.1M | 15.1M | 15.1M | 15.1M | 15.1M
    --------------+-------+-------+-------+-------+-------+---------
    C's dirty     | 931.9M| 1.7G  | 2.6G  | 3.4G  | 4.3G  | 5.1G
        rate(p+i) | N/A   | N/A   | N/A   | N/A   | N/A   | N/A
    ================================================================

            Tab.2 fio randwrite 10GiB under rate 10MiB/s
    ================================================================
        time      | 100s  | 200s  | 300s  | 400s  | 500s  | 600s
    --------------+-------+-------+-------+-------+-------+---------
    A's dirty     | 0.9G  | 1.9G  | 2.9G  | 3.4G  | 3.4G  | 3.3G
        rate(p+i) | 4k    | 4k    | 4k    | 9.2M  | 10.6M | 10.7M
        rate_p    |-55.5M |-29.9M |-4.3M  | 9.1M  | 8.5M  | 6.7M
        rate_i    |-1.1M  |-1.1M  |-1.1M  | 123.5k| 2.1M  | 3.9M
    --------------+-------+-------+-------+-------+-------+---------
    B's dirty     | 134.6M| 94.5M | 109.1M| 78.6M | 65.0M | 69.9M
        rate(p+i) | 11.7M | 11.1M | 11.6M | 11.3M | 11.2M | 11.6M
        rate_p    | 3.6M  | 2.4M  | 2.7M  | 2.1M  | 1.6M  | 1.7M
        rate_i    | 8.1M  | 8.6M  | 8.9M  | 9.2M  | 9.6M  | 9.8M
    --------------+-------+-------+-------+-------+-------+---------
    C's dirty     | 56.1M | 30.6M | 19.0M | 16.9M | 14.5M | 22.5M
        rate(p+i) | N/A   | N/A   | N/A   | N/A   | N/A   | N/A
    ================================================================

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/bcache.h    | 1 +
 drivers/md/bcache/sysfs.c     | 5 +++++
 drivers/md/bcache/writeback.c | 7 ++++---
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 9ed9c955add7..752f23c5c3c5 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -372,6 +372,7 @@ struct cached_dev {
 	unsigned int		partial_stripes_expensive:1;
 	unsigned int		writeback_metadata:1;
 	unsigned int		writeback_running:1;
+	unsigned int		writeback_dynamic_rate:1;
 	unsigned int		writeback_consider_fragment:1;
 	unsigned char		writeback_percent;
 	unsigned int		writeback_delay;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 1f0dce30fa75..d251ce0d259f 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -117,6 +117,7 @@ rw_attribute(writeback_running);
 rw_attribute(writeback_percent);
 rw_attribute(writeback_delay);
 rw_attribute(writeback_rate);
+rw_attribute(writeback_dynamic_rate);
 rw_attribute(writeback_consider_fragment);
 
 rw_attribute(writeback_rate_update_seconds);
@@ -198,6 +199,7 @@ SHOW(__bch_cached_dev)
 	var_printf(bypass_torture_test,	"%i");
 	var_printf(writeback_metadata,	"%i");
 	var_printf(writeback_running,	"%i");
+	var_printf(writeback_dynamic_rate, "%i");
 	var_printf(writeback_consider_fragment,	"%i");
 	var_print(writeback_delay);
 	var_print(writeback_percent);
@@ -309,6 +311,7 @@ STORE(__cached_dev)
 	sysfs_strtoul_bool(bypass_torture_test, dc->bypass_torture_test);
 	sysfs_strtoul_bool(writeback_metadata, dc->writeback_metadata);
 	sysfs_strtoul_bool(writeback_running, dc->writeback_running);
+	sysfs_strtoul_bool(writeback_dynamic_rate, dc->writeback_dynamic_rate);
 	sysfs_strtoul_bool(writeback_consider_fragment, dc->writeback_consider_fragment);
 	sysfs_strtoul_clamp(writeback_delay, dc->writeback_delay, 0, UINT_MAX);
 
@@ -329,6 +332,7 @@ STORE(__cached_dev)
 		return ret;
 	}
 
+
 	sysfs_strtoul_clamp(writeback_rate_update_seconds,
 			    dc->writeback_rate_update_seconds,
 			    1, WRITEBACK_RATE_UPDATE_SECS_MAX);
@@ -515,6 +519,7 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_writeback_delay,
 	&sysfs_writeback_percent,
 	&sysfs_writeback_rate,
+	&sysfs_writeback_dynamic_rate,
 	&sysfs_writeback_consider_fragment,
 	&sysfs_writeback_rate_update_seconds,
 	&sysfs_writeback_rate_i_term_inverse,
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index c7560f66dca8..45150881146e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -235,7 +235,7 @@ static void update_writeback_rate(struct work_struct *work)
 		return;
 	}
 
-	if (atomic_read(&dc->has_dirty) && dc->writeback_percent) {
+	if (atomic_read(&dc->has_dirty) && dc->writeback_dynamic_rate) {
 		/*
 		 * If the whole cache set is idle, set_at_max_writeback_rate()
 		 * will set writeback rate to a max number. Then it is
@@ -274,7 +274,7 @@ static unsigned int writeback_delay(struct cached_dev *dc,
 				    unsigned int sectors)
 {
 	if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
-	    !dc->writeback_percent)
+	    !dc->writeback_dynamic_rate)
 		return 0;
 
 	return bch_next_delay(&dc->writeback_rate, sectors);
@@ -294,7 +294,7 @@ static void dirty_init(struct keybuf_key *w)
 
 	bio_init(bio, bio->bi_inline_vecs,
 		 DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS));
-	if (!io->dc->writeback_percent)
+	if (!io->dc->writeback_dynamic_rate)
 		bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
 
 	bio->bi_iter.bi_size	= KEY_SIZE(&w->key) << 9;
@@ -1014,6 +1014,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 
 	dc->writeback_metadata		= true;
 	dc->writeback_running		= false;
+	dc->writeback_dynamic_rate	= true;
 	dc->writeback_consider_fragment = true;
 	dc->writeback_percent		= 10;
 	dc->writeback_delay		= 30;
-- 
2.17.1

