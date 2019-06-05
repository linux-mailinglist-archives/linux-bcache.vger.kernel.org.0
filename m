Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7224357B1
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jun 2019 09:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfFEH1l (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jun 2019 03:27:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:41188 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726477AbfFEH1l (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jun 2019 03:27:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2F9A0AE08;
        Wed,  5 Jun 2019 07:27:40 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 4/6] bcache: remove retry_flush_write from struct cache_set
Date:   Wed,  5 Jun 2019 15:27:16 +0800
Message-Id: <20190605072718.121379-5-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190605072718.121379-1-colyli@suse.de>
References: <20190605072718.121379-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In struct cache_set, retry_flush_write is added for commit c4dc2497d50d
("bcache: fix high CPU occupancy during journal") which is reverted in
previous patch.

Now it is useless anymore, and this patch removes it from bcache code.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h | 1 -
 drivers/md/bcache/sysfs.c  | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index cb268d7c6cea..35396248a7d5 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -706,7 +706,6 @@ struct cache_set {
 
 	atomic_long_t		reclaim;
 	atomic_long_t		flush_write;
-	atomic_long_t		retry_flush_write;
 
 	enum			{
 		ON_ERROR_UNREGISTER,
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index eb678e43ac00..80ead1a205b9 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -81,7 +81,6 @@ read_attribute(state);
 read_attribute(cache_read_races);
 read_attribute(reclaim);
 read_attribute(flush_write);
-read_attribute(retry_flush_write);
 read_attribute(writeback_keys_done);
 read_attribute(writeback_keys_failed);
 read_attribute(io_errors);
@@ -695,9 +694,6 @@ SHOW(__bch_cache_set)
 	sysfs_print(flush_write,
 		    atomic_long_read(&c->flush_write));
 
-	sysfs_print(retry_flush_write,
-		    atomic_long_read(&c->retry_flush_write));
-
 	sysfs_print(writeback_keys_done,
 		    atomic_long_read(&c->writeback_keys_done));
 	sysfs_print(writeback_keys_failed,
@@ -914,7 +910,6 @@ static struct attribute *bch_cache_set_internal_files[] = {
 	&sysfs_cache_read_races,
 	&sysfs_reclaim,
 	&sysfs_flush_write,
-	&sysfs_retry_flush_write,
 	&sysfs_writeback_keys_done,
 	&sysfs_writeback_keys_failed,
 
-- 
2.16.4

