Return-Path: <linux-bcache+bounces-105-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC8F8054E4
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Dec 2023 13:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 807041F215C7
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Dec 2023 12:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1385C906;
	Tue,  5 Dec 2023 12:40:29 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E8F172B;
	Tue,  5 Dec 2023 04:40:08 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Sl0VS2FdDz4f3lD7;
	Tue,  5 Dec 2023 20:40:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id ECBB41A0539;
	Tue,  5 Dec 2023 20:40:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgCnqxEiGm9lNdk8Cw--.27561S4;
	Tue, 05 Dec 2023 20:40:04 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	roger.pau@citrix.com,
	colyli@suse.de,
	kent.overstreet@gmail.com,
	joern@lazybastard.org,
	miquel.raynal@bootlin.com,
	richard@nod.at,
	vigneshr@ti.com,
	sth@linux.ibm.com,
	hoeppner@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	clm@fb.com,
	josef@toxicpanda.com,
	dsterba@suse.com,
	nico@fluxnic.net,
	xiang@kernel.org,
	chao@kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	agruenba@redhat.com,
	jack@suse.com,
	konishi.ryusuke@gmail.com,
	willy@infradead.org,
	akpm@linux-foundation.org,
	hare@suse.de,
	p.raghav@samsung.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-nilfs@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH -next RFC 13/14] gfs2: use bdev api
Date: Tue,  5 Dec 2023 20:39:00 +0800
Message-Id: <20231205123900.1866871-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
References: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCnqxEiGm9lNdk8Cw--.27561S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFyUZFWfCw1kJrWxJrW3GFg_yoW8Jw47pF
	yDAF1akF4DWrnIga1kZF4rt3Wj9aykG3y0yr95Aw1YvrsrGw1ag392kF4DJF4UXa97Xws0
	ga1ay3yakr1aqr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Wrv_Gr1U
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26F4UJVW0owCI42IY6xAIw20EY4v20xvaj40_Gr0_Zr1lIxAIcVC2z280aVAFwI0_
	Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVWxJr0_GcJvcSsGvfC2KfnxnUUI43ZEXa7VUb
	ZNVDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Avoid to access bd_inode directly, prepare to remove bd_inode from
block_devcie.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 fs/gfs2/glock.c      | 2 +-
 fs/gfs2/ops_fstype.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f28c67181230..c66b0ed07e15 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1227,7 +1227,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	mapping = gfs2_glock2aspace(gl);
 	if (mapping) {
                 mapping->a_ops = &gfs2_meta_aops;
-		mapping->host = s->s_bdev->bd_inode;
+		bdev_correlate_mapping(s->s_bdev, mapping);
 		mapping->flags = 0;
 		mapping_set_gfp_mask(mapping, GFP_NOFS);
 		mapping->i_private_data = NULL;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 00ce89bdf32c..3145a56c88cb 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -114,7 +114,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	address_space_init_once(mapping);
 	mapping->a_ops = &gfs2_rgrp_aops;
-	mapping->host = sb->s_bdev->bd_inode;
+	bdev_correlate_mapping(sb->s_bdev, mapping);
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	mapping->i_private_data = NULL;
-- 
2.39.2


