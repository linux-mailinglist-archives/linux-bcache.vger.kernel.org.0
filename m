Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E755042FED8
	for <lists+linux-bcache@lfdr.de>; Sat, 16 Oct 2021 01:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243620AbhJOXdV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 19:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243602AbhJOXdP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 19:33:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFF6C061570;
        Fri, 15 Oct 2021 16:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=agaE6D36LcS3m3yT/hy8ziCroVpqabvNI/EGY/bikug=; b=JZN7KnMFum6DusEMzQaTsmPto3
        iq0vhkylIJTrRi3kI9DyDDhakbylqaU5ngke9FXegqhHlTjzaES6xYJGeZrlmkrs5X82hd0xUZPly
        51vs2mHbjxbZ/JrfFkVlCzqGzxcHT6V0Rizcnxt0Xea2U4EbeIEwAYjpLQOYDW9BT1bzfC5yajRai
        glC6KamA1aVYdFKGePYEOx2LGrVyVLkNNW+ZqxRXr7CKdibjpFjc4X28nYiugdtg8MptBKUKfdmaw
        DpCnXlnKNpbt7FZn75/eotERzBrmV/jDeJiM/sUdmtdBCIWBuoe8kaRe5aUI7BgROEiElZFn9evkO
        A1LiSSlQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbWej-0095v3-Bg; Fri, 15 Oct 2021 23:30:29 +0000
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
Subject: [PATCH 6/9] m68k/emu/nfblock: add error handling support for add_disk()
Date:   Fri, 15 Oct 2021 16:30:25 -0700
Message-Id: <20211015233028.2167651-7-mcgrof@kernel.org>
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

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 arch/m68k/emu/nfblock.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index 9a8394e96388..4de5a6087034 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -100,6 +100,7 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 {
 	struct nfhd_device *dev;
 	int dev_id = id - NFHD_DEV_OFFSET;
+	int err = -ENOMEM;
 
 	pr_info("nfhd%u: found device with %u blocks (%u bytes)\n", dev_id,
 		blocks, bsize);
@@ -130,16 +131,20 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	sprintf(dev->disk->disk_name, "nfhd%u", dev_id);
 	set_capacity(dev->disk, (sector_t)blocks * (bsize / 512));
 	blk_queue_logical_block_size(dev->disk->queue, bsize);
-	add_disk(dev->disk);
+	err = add_disk(dev->disk);
+	if (err)
+		goto out_cleanup_disk;
 
 	list_add_tail(&dev->list, &nfhd_list);
 
 	return 0;
 
+out_cleanup_disk:
+	blk_cleanup_disk(dev->disk);
 free_dev:
 	kfree(dev);
 out:
-	return -ENOMEM;
+	return err;
 }
 
 static int __init nfhd_init(void)
-- 
2.30.2

