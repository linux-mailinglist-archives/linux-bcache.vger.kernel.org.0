Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9553242FEC4
	for <lists+linux-bcache@lfdr.de>; Sat, 16 Oct 2021 01:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243587AbhJOXdI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 19:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243545AbhJOXdE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 19:33:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDD2C061570;
        Fri, 15 Oct 2021 16:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=o1//ec0r5e8VTnwYNp5R5eQwtP7WISCGubCypYTw4Jw=; b=LW2F7o9AfnmLff+UOqZtBvoesh
        ZDxjZh8yGJTFjoCXtG72Qf6wiK50Ivqs2nLYTyK0D4PE3RqGQeM7NHkQc1HgaiuC389ySfZ9y6tbY
        VRe+cl9qKO5Q6YIJqZ7sL3W1y4lRXKxWamL98pgo7JKgSyLRT/JDscfv355hCy4dMGDT46XBVp+Nm
        wVo9xMhmi3IrJFUR2gl64sdIHlMJnpD1Q59OFtrhwk/RMNq6/KnSG6DyCHHu7BJ6DTes7dtF/Fbid
        VAD77+Ygj0Xd4lLc0+I1bb/qHRVoHESD8eaekIlUicJJVR3pSkX9z1zbRu8FVAewt6xEX6yxhkckp
        FUXhxm9Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbWej-0095ux-8E; Fri, 15 Oct 2021 23:30:29 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        agk@redhat.com, snitzer@redhat.com, colyli@suse.de,
        kent.overstreet@gmail.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, roger.pau@citrix.com,
        geert@linux-m68k.org, ulf.hansson@linaro.org, tj@kernel.org,
        hare@suse.de, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes.berg@intel.com,
        krisman@collabora.com, chris.obbard@collabora.com,
        thehajime@gmail.com, zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, miquel.raynal@bootlin.com, vigneshr@ti.com,
        linux-mtd@lists.infradead.org
Cc:     linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 3/9] dm: add add_disk() error handling
Date:   Fri, 15 Oct 2021 16:30:22 -0700
Message-Id: <20211015233028.2167651-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015233028.2167651-1-mcgrof@kernel.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

There are two calls to dm_setup_md_queue() which can fail then,
one on dm_early_create() and we can easily see that the error path
there calls dm_destroy in the error path. The other use case is on
the ioctl table_load case. If that fails userspace needs to call
the DM_DEV_REMOVE_CMD to cleanup the state - similar to any other
failure.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 245fa4153306..6d3265ed37c0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2086,7 +2086,9 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	if (r)
 		return r;
 
-	add_disk(md->disk);
+	r = add_disk(md->disk);
+	if (r)
+		return r;
 
 	r = dm_sysfs_init(md);
 	if (r) {
-- 
2.30.2

