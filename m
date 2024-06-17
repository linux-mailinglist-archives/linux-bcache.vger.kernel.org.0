Return-Path: <linux-bcache+bounces-638-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D09D90A4D8
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2EE41C2230D
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9947188CB1;
	Mon, 17 Jun 2024 06:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K/Vv+hFa"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5392C1953AC;
	Mon, 17 Jun 2024 06:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604430; cv=none; b=Wmsapv2bEyiX/oB4gpU7HehXBRbl9xgiknXOjEC6lcrcBzBfy0cGUW8gXQN8RI27hVs9inz9tZ93aGQ+CWIgdlOavfuVM2JafaPffRrKcs56iHsWPgW9GF4vLPodbmTAEcthk0kYTfwHMg277e0+a1sj2v3l5srMM/YbyZYwGOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604430; c=relaxed/simple;
	bh=fQtLGbLe3BUFiYkcQLlwsUDSITK3uJUvYiY5IKWimG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ji+KGHlublfzHv8zlU9GUDkld5bdzG7Oimc8JiJJhTMHd2w/eaHQlWUfjdRWhEwddZRrMBW1Z5Y9LMrz8SgLaa+HzKMNWxR/wr2HnbsNnc62MbM/mueUqnjVE64z04mm6TShDEWUhZ0CW0VbWwWTyM+uVsM2AZ5rhoa9uJBDxv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K/Vv+hFa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dPSH4Z18hgBewwqMgLsN2I7WWNT3sMh//IxSNM9UAJw=; b=K/Vv+hFa9Nyaj6c0dtkqikBt6w
	qq2YIoW9lbQTXNs1QZwCu3TJ0gdb1aTGMI/jJDciD0rCDzMo0YBbpIemac2/yg9z1vzk7PHL+Cu21
	hJaAxq4kQMhKmbucck4hfChvPCpVtcHay9f22jj0UEcEQfgYSC4Wqppdr6tM3ho8Qv3Y/Nav4AdiD
	/nqRXJ+/kKq1QJenk4YubPhiXsBeihmEBorMr5EfalN28KRiAoHA9Pc+NO5mqBR0ojItSGvxPwPlD
	FZsTI3i1oePhkKFKVmc7hq1+qX5E0tjVsVmdcjwIlRFF/eDyHTREetqP/tz+7XIOrhzRREm7pFrTG
	SNkrcFPg==;
Received: from [91.187.204.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJ5W3-00000009JFp-161h;
	Mon, 17 Jun 2024 06:06:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-m68k@lists.linux-m68k.org,
	linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com,
	nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org,
	ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 25/26] block: move the skip_tagset_quiesce flag to queue_limits
Date: Mon, 17 Jun 2024 08:04:52 +0200
Message-ID: <20240617060532.127975-26-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240617060532.127975-1-hch@lst.de>
References: <20240617060532.127975-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the skip_tagset_quiesce flag into the queue_limits feature field so
that it can be set atomically with the queue frozen.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-mq-debugfs.c   | 1 -
 drivers/nvme/host/core.c | 8 +++++---
 include/linux/blkdev.h   | 6 ++++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 8b5a68861c119b..344f9e503bdb32 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -93,7 +93,6 @@ static const char *const blk_queue_flag_name[] = {
 	QUEUE_FLAG_NAME(RQ_ALLOC_TIME),
 	QUEUE_FLAG_NAME(HCTX_ACTIVE),
 	QUEUE_FLAG_NAME(SQ_SCHED),
-	QUEUE_FLAG_NAME(SKIP_TAGSET_QUIESCE),
 };
 #undef QUEUE_FLAG_NAME
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 31e752e8d632cd..bf410d10b12006 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4489,13 +4489,15 @@ int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 		return ret;
 
 	if (ctrl->ops->flags & NVME_F_FABRICS) {
-		ctrl->connect_q = blk_mq_alloc_queue(set, NULL, NULL);
+		struct queue_limits lim = {
+			.features	= BLK_FEAT_SKIP_TAGSET_QUIESCE,
+		};
+
+		ctrl->connect_q = blk_mq_alloc_queue(set, &lim, NULL);
         	if (IS_ERR(ctrl->connect_q)) {
 			ret = PTR_ERR(ctrl->connect_q);
 			goto out_free_tag_set;
 		}
-		blk_queue_flag_set(QUEUE_FLAG_SKIP_TAGSET_QUIESCE,
-				   ctrl->connect_q);
 	}
 
 	ctrl->tagset = set;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ab0f7dfba556eb..2c433ebf6f2030 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -322,6 +322,9 @@ enum {
 
 	/* supports PCI(e) p2p requests */
 	BLK_FEAT_PCI_P2PDMA			= (1u << 12),
+
+	/* skip this queue in blk_mq_(un)quiesce_tagset */
+	BLK_FEAT_SKIP_TAGSET_QUIESCE		= (1u << 13),
 };
 
 /*
@@ -594,7 +597,6 @@ struct request_queue {
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
 #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
 #define QUEUE_FLAG_SQ_SCHED     30	/* single queue style io dispatch */
-#define QUEUE_FLAG_SKIP_TAGSET_QUIESCE	31 /* quiesce_tagset skip the queue*/
 
 #define QUEUE_FLAG_MQ_DEFAULT	(1UL << QUEUE_FLAG_SAME_COMP)
 
@@ -629,7 +631,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
 #define blk_queue_sq_sched(q)	test_bit(QUEUE_FLAG_SQ_SCHED, &(q)->queue_flags)
 #define blk_queue_skip_tagset_quiesce(q) \
-	test_bit(QUEUE_FLAG_SKIP_TAGSET_QUIESCE, &(q)->queue_flags)
+	((q)->limits.features & BLK_FEAT_SKIP_TAGSET_QUIESCE)
 
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
-- 
2.43.0


