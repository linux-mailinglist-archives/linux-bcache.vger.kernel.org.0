Return-Path: <linux-bcache+bounces-613-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F08D90A3AB
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BABA282243
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A911836D1;
	Mon, 17 Jun 2024 06:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xHDYpaff"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D923D176FD3;
	Mon, 17 Jun 2024 06:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604349; cv=none; b=j4crC7Hc/23jnVdfpJ02/KAOvRNWC7yobKKGeRYwrUuRoMoH/3pZ0m3r8VECSNfcqe/ggykg+3qJEV1NqupdKkmfcOkjXDfhLY+RcHJU5cC+SHYf7H1QM+zC3ZMr6CCfuDrCGmjP+/SjXo+bBs2bqU0gMd0StA15CB+EKjbvnZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604349; c=relaxed/simple;
	bh=7oZ9JpXO3L/xA6vql8Ygs8CS2YVuPMmAfFunwVijNQw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mGjV+Wt9AiYyVCdBnc9JEbT/ybCwZQ00A3j0BEDrrBrPl+efXD71fu7VFuWy+VB6xDDNkHN0JsDMgujxajYUua0o0gFKJTSyTUP/VdDzTddTOFMdp0CRwlLyNI3np8d/4J7ERIhgamP+2RDpyuVJdISYYEP0U2WfgdneUohSiKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xHDYpaff; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=w5I58mRKj5AU6Yqi3NMuzFTOUn3zWDih3UgJBo1+OXs=; b=xHDYpaffUakf5PuOWBpPooKbf/
	9TfbzNtEmDZrZ632SAc4SRfUuVJxNjnIE5gNHB7SDcAJ13WXLVDplEzCkwbhxr8th8FA1AGmh61+R
	g24j1QTav3xOiX0eITNyRi5Mz2E8AK3xQKNReoItBJuLvJZGhaoHXPsRavxTQyGXej16tbWpW9fkb
	MiE3u8l6QDmidGewrW4mjUWDPWBwBicf+CUbBFJdBIXJq2Vt/dKLWmd1vyB4Oh0xvZA38NfBT/pij
	A+DvQuobhBHBxhKADMh8M+nXHtE0Qh4gwc7U1XvGwmsXXCd4Sd1vVhVl6cw/4+q61JkWAXyCyIYQD
	kLWvV1DA==;
Received: from [91.187.204.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJ5Uk-00000009IBH-3zsu;
	Mon, 17 Jun 2024 06:05:35 +0000
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
	linux-block@vger.kernel.org
Subject: move features flags into queue_limits v2
Date: Mon, 17 Jun 2024 08:04:27 +0200
Message-ID: <20240617060532.127975-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this is the third and last major series to convert settings to
queue_limits for this merge window.  After a bunch of prep patches to
get various drivers in shape, it moves all the queue_flags that specify
driver controlled features into the queue limits so that they can be
set atomically and are separated from the blk-mq internal flags.

Note that I've only Cc'ed the maintainers for drivers with non-mechanical
changes as the Cc list is already huge.

This series sits on top of the for-6.11/block-limits branch.

A git tree is available here:

    git://git.infradead.org/users/hch/block.git block-limit-flags

Gitweb:

    http://git.infradead.org/?p=users/hch/block.git;a=shortlog;h=refs/heads/block-limit-flags


Changes since v1:
 - fix an inverted condition
 - fix the runtime flush disable in xen-blkfront
 - remove sd_is_zoned entirely
 - use SECTOR_SIZE in a few more places
 - fix REQ_NOWAIT disabling for dm targets that don't support it
 - fix typos
 - reword various commit logs

Diffstat:
 Documentation/block/writeback_cache_control.rst |   67 ++++----
 arch/m68k/emu/nfblock.c                         |    1 
 arch/um/drivers/ubd_kern.c                      |    3 
 arch/xtensa/platforms/iss/simdisk.c             |    5 
 block/blk-core.c                                |    7 
 block/blk-flush.c                               |   36 ++--
 block/blk-mq-debugfs.c                          |   13 -
 block/blk-mq.c                                  |   42 +++--
 block/blk-settings.c                            |   46 ++----
 block/blk-sysfs.c                               |  118 ++++++++-------
 block/blk-wbt.c                                 |    4 
 block/blk.h                                     |    2 
 drivers/block/amiflop.c                         |    5 
 drivers/block/aoe/aoeblk.c                      |    1 
 drivers/block/ataflop.c                         |    5 
 drivers/block/brd.c                             |    6 
 drivers/block/drbd/drbd_main.c                  |    6 
 drivers/block/floppy.c                          |    3 
 drivers/block/loop.c                            |   79 ++++------
 drivers/block/mtip32xx/mtip32xx.c               |    2 
 drivers/block/n64cart.c                         |    2 
 drivers/block/nbd.c                             |   24 +--
 drivers/block/null_blk/main.c                   |   13 -
 drivers/block/null_blk/zoned.c                  |    3 
 drivers/block/pktcdvd.c                         |    1 
 drivers/block/ps3disk.c                         |    8 -
 drivers/block/rbd.c                             |   12 -
 drivers/block/rnbd/rnbd-clt.c                   |   14 -
 drivers/block/sunvdc.c                          |    1 
 drivers/block/swim.c                            |    5 
 drivers/block/swim3.c                           |    5 
 drivers/block/ublk_drv.c                        |   21 +-
 drivers/block/virtio_blk.c                      |   37 ++--
 drivers/block/xen-blkfront.c                    |   53 +++---
 drivers/block/zram/zram_drv.c                   |    6 
 drivers/cdrom/gdrom.c                           |    1 
 drivers/md/bcache/super.c                       |    9 -
 drivers/md/dm-table.c                           |  183 +++++-------------------
 drivers/md/dm-zone.c                            |    2 
 drivers/md/dm-zoned-target.c                    |    2 
 drivers/md/dm.c                                 |   13 -
 drivers/md/md.c                                 |   40 -----
 drivers/md/raid5.c                              |    6 
 drivers/mmc/core/block.c                        |   42 ++---
 drivers/mmc/core/queue.c                        |   20 +-
 drivers/mmc/core/queue.h                        |    3 
 drivers/mtd/mtd_blkdevs.c                       |    9 -
 drivers/nvdimm/btt.c                            |    4 
 drivers/nvdimm/pmem.c                           |   14 -
 drivers/nvme/host/core.c                        |   33 ++--
 drivers/nvme/host/multipath.c                   |   24 ---
 drivers/nvme/host/zns.c                         |    3 
 drivers/s390/block/dasd_genhd.c                 |    1 
 drivers/s390/block/dcssblk.c                    |    2 
 drivers/s390/block/scm_blk.c                    |    5 
 drivers/scsi/iscsi_tcp.c                        |    8 -
 drivers/scsi/scsi_lib.c                         |    5 
 drivers/scsi/sd.c                               |   66 +++-----
 drivers/scsi/sd.h                               |    5 
 drivers/scsi/sd_zbc.c                           |   25 +--
 include/linux/blkdev.h                          |  119 ++++++++++-----
 61 files changed, 572 insertions(+), 728 deletions(-)

