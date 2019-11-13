Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B11F9FABA7
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2019 09:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfKMIEd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Nov 2019 03:04:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:52378 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726303AbfKMIEd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Nov 2019 03:04:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0597DABD6;
        Wed, 13 Nov 2019 08:04:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 03/12] bcache: fix static checker warning in bcache_device_free()
Date:   Wed, 13 Nov 2019 16:03:17 +0800
Message-Id: <20191113080326.69989-4-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191113080326.69989-1-colyli@suse.de>
References: <20191113080326.69989-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Commit cafe56359144 ("bcache: A block layer cache") leads to the
following static checker warning:

    ./drivers/md/bcache/super.c:770 bcache_device_free()
    warn: variable dereferenced before check 'd->disk' (see line 766)

drivers/md/bcache/super.c
   762  static void bcache_device_free(struct bcache_device *d)
   763  {
   764          lockdep_assert_held(&bch_register_lock);
   765
   766          pr_info("%s stopped", d->disk->disk_name);
                                      ^^^^^^^^^
Unchecked dereference.

   767
   768          if (d->c)
   769                  bcache_device_detach(d);
   770          if (d->disk && d->disk->flags & GENHD_FL_UP)
                    ^^^^^^^
Check too late.

   771                  del_gendisk(d->disk);
   772          if (d->disk && d->disk->queue)
   773                  blk_cleanup_queue(d->disk->queue);
   774          if (d->disk) {
   775                  ida_simple_remove(&bcache_device_idx,
   776                                    first_minor_to_idx(d->disk->first_minor));
   777                  put_disk(d->disk);
   778          }
   779

It is not 100% sure that the gendisk struct of bcache device will always
be there, the warning makes sense when there is problem in block core.

This patch tries to remove the static checking warning by checking
d->disk to avoid NULL pointer deferences.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ebb854ed05a4..7beccede5360 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -761,20 +761,28 @@ static inline int idx_to_first_minor(int idx)
 
 static void bcache_device_free(struct bcache_device *d)
 {
+	struct gendisk *disk = d->disk;
+
 	lockdep_assert_held(&bch_register_lock);
 
-	pr_info("%s stopped", d->disk->disk_name);
+	if (disk)
+		pr_info("%s stopped", disk->disk_name);
+	else
+		pr_err("bcache device (NULL gendisk) stopped");
 
 	if (d->c)
 		bcache_device_detach(d);
-	if (d->disk && d->disk->flags & GENHD_FL_UP)
-		del_gendisk(d->disk);
-	if (d->disk && d->disk->queue)
-		blk_cleanup_queue(d->disk->queue);
-	if (d->disk) {
+
+	if (disk) {
+		if (disk->flags & GENHD_FL_UP)
+			del_gendisk(disk);
+
+		if (disk->queue)
+			blk_cleanup_queue(disk->queue);
+
 		ida_simple_remove(&bcache_device_idx,
-				  first_minor_to_idx(d->disk->first_minor));
-		put_disk(d->disk);
+				  first_minor_to_idx(disk->first_minor));
+		put_disk(disk);
 	}
 
 	bioset_exit(&d->bio_split);
-- 
2.16.4

