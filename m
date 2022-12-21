Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32055652C0E
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Dec 2022 05:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiLUEKq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Dec 2022 23:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUEKp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Dec 2022 23:10:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE974B10;
        Tue, 20 Dec 2022 20:10:42 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BL0hwKB010018;
        Wed, 21 Dec 2022 04:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=ClUhSq+np/g8cvy1jXTTXOKZw5S4+F+cwkiflOHV6PQ=;
 b=ua8Tn2UTWIb99nhwntZ4EKu0cH/RSKZOA83X8VdTockde6g99rN07P3MV0uT9MIu4t34
 e1YekJrLAfg1sIiN7pwFe9WDFvqi4wpA+cCezCTfpfxCMhhzxMzXrz4HrClOLqoNQnr2
 E970Z5Ma1BPpDUsZNn5rWxmjwlM6qoevROvApGAvRNuXJOx8ryXycCyEDO/mWHJrbFHp
 hBRo9s4VIg44sxGwad5V+vnk39Jgc3M9dkUUpKInJTp/kvwlbeVEcRLLavFkoCldHsM8
 vpvlCPSfqmqDMPanHeVqWLEm3VByM+CNliv56Gu9PPUmzh41WOTlS7B/SSTcvyNpj7LH uA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tmyqev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 04:05:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BL1Dv45003438;
        Wed, 21 Dec 2022 04:05:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh4762963-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 04:05:13 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BL459MC023735;
        Wed, 21 Dec 2022 04:05:12 GMT
Received: from bm-iostat-test-2.osdevelopmeniad.oraclevcn.com (bm-iostat-test-2.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3mh4762924-2;
        Wed, 21 Dec 2022 04:05:12 +0000
From:   Gulam Mohamed <gulam.mohamed@oracle.com>
To:     linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
        minchan@kernel.org, ngupta@vflare.org, senozhatsky@chromium.org,
        colyli@suse.de, kent.overstreet@gmail.com, agk@redhat.com,
        snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, junxiao.bi@oracle.com,
        gulam.mohamed@oracle.com, martin.petersen@oracle.com,
        kch@nvidia.com, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        konrad.wilk@oracle.com, joe.jin@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com, shminderjit.singh@oracle.com
Subject: [PATCH for-6.2/block V3 2/2] block: Change the granularity of io ticks from ms to ns
Date:   Wed, 21 Dec 2022 04:05:06 +0000
Message-Id: <20221221040506.1174644-2-gulam.mohamed@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
References: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_01,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212210027
X-Proofpoint-ORIG-GUID: WRRFTkEgbY_ZOwEpC-Dis9KIWXEYUJ7u
X-Proofpoint-GUID: WRRFTkEgbY_ZOwEpC-Dis9KIWXEYUJ7u
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Problem Desc
============
The "iostat" user-space utility was showing %util as 100% for the disks
which has latencies less than a milli-second i.e for latencies in the
range of micro-seconds and below.

Root Cause
==========
The IO accounting in block layer is currently done by updating the
io_ticks in jiffies which is of milli-seconds granularity. Due to this,
for the devices with IO latencies less than a milli-second, the latency
will be accounted as 1 milli-second even-though its in the range of
micro-seconds. This was causing the iostat command to show %util
as 100% which is incorrect.

Recreationg of the issue
========================
Setup
-----
Devices: NVMe 24 devices
Model number: 4610 (Intel)

fio
---
[global]
bs=4K
iodepth=1
direct=1
ioengine=libaio
group_reporting
time_based
runtime=100
thinktime=1ms
numjobs=1
name=raw-write
rw=randrw
ignore_error=EIO:EIO
[job1]
filename=/dev/nvme0n1

iostat o/p
----------

Device   %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme3n1   0.00    0.05    0.00  75.38     0.50     0.00   0.00 100.00

Device   %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme3n1   0.00    0.05    0.00  74.74     0.50     0.00   0.00 100.00

Solution
========
Use ktime_get_ns() to update the disk_stats io_ticks so that the io_ticks
are updated for every io start and end times.

Issues using ktime
==================

Using ktime_get_ns() has a performance overhead as ktime will go ahead
and reads the clock everytime its called. Following test environment
was used by Jens Axboe on which t/io_uring was run which has shown a
high performance drop.

Devices
-------
SSDs: P5800X
No of devices: 24

io_uring config
---------------
Polled IO
iostats: Enabled
Reads: Random
Block Size: 512
QDepth: 128
Batch Submit: 32
Batch Complete: 32
No of Threads: 24

With the above environment and ktime patch, it has shown a performance
drop of ~25% from iostats disabled and ~19% performance drop from current
iostats enabled. This performance drop is high.

Suggestion from Jens Axboe
==========================
Jens Axboe suggested to split the bigger patch into two as follows:

1. In first patch, change all the types from unsigned long to u64, that
   can be done while retaining jiffies.

2. In second patch, add an iostats == 2 setting, which enables the higher
   resolution mode using ktime. We'd still default to 1, lower granularity
   iostats enabled.

Fix details
===========
1. Use ktime_get_ns() to get the current nano-seconds to update the
   io_ticks for start and end time stamps in block layer for io accounting

2. Create a new setting '2' in sysfs for iostats variable i.e for
   /sys/block/<device-name>/queue/iostats, to enable the iostat (io
   accounting) with nano-seconds (using ktime) granularity. This setting
   should be enabled only if the iostat is needed with high resolution
   mode as it has a high performance drop

3. Earlier available settings were 0 and 1 for disable and enable io
   accounting with milli-seconds granularity (jiffies)

Testing
=======
Ran the t/io_uring command with following setup:

Devices
-------
SSDs: P4610
No of devices: 8

io_uring config
---------------
Polled IO
iostats: Enabled
Reads: Random
Block Size: 512
QDepth: 128
Batch Submit: 32
Batch Complete: 32
No of Threads: 24

io_uring o/p
------------
iostat=0, with patch: Maximum IOPS=10.09M
iostat=1, with patch: Maximum IOPS=9.84M
iostat=2, with patch: Maximum IOPS=9.48M

Changes from V2 to V3
=====================
1. Changed all the required variables data-type to u64 as a first patch
2. Create a new setting '2' for iostats in sysfs in this patch
3. Change the code to get the ktime values when iostat=2, in this patch

Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
---
 block/blk-core.c                  | 26 +++++++++++++++++----
 block/blk-mq.c                    |  4 ++--
 block/blk-sysfs.c                 | 39 ++++++++++++++++++++++++++++++-
 block/genhd.c                     | 18 ++++++++++----
 drivers/block/drbd/drbd_debugfs.c | 12 ++++++++--
 drivers/block/zram/zram_drv.c     |  3 ++-
 drivers/md/dm.c                   | 13 +++++++++--
 include/linux/blkdev.h            |  4 ++++
 8 files changed, 103 insertions(+), 16 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5670032fe932..0b5e4eb909a5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -927,6 +927,18 @@ int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 }
 EXPORT_SYMBOL_GPL(iocb_bio_iopoll);
 
+/*
+ * Get the time based upon the available granularity for io accounting
+ * If the resolution mode is set to precise (2) i.e
+ * (/sys/block/<device>/queue/iostats = 2), then this will return time
+ * in nano-seconds else this will return time in jiffies
+ */
+u64  blk_get_iostat_ticks(struct request_queue *q)
+{
+       return (blk_queue_precise_io_stat(q) ? ktime_get_ns() : jiffies);
+}
+EXPORT_SYMBOL_GPL(blk_get_iostat_ticks);
+
 void update_io_ticks(struct block_device *part, u64 now, bool end)
 {
 	u64 stamp;
@@ -968,20 +980,26 @@ EXPORT_SYMBOL(bdev_start_io_acct);
 u64 bio_start_io_acct(struct bio *bio)
 {
 	return bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
-				  bio_op(bio), jiffies);
+				  bio_op(bio),
+				  blk_get_iostat_ticks(bio->bi_bdev->bd_queue));
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
 void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
 		      u64 start_time)
 {
+	u64 now;
+	u64 duration;
+	struct request_queue *q = bdev_get_queue(bdev);
 	const int sgrp = op_stat_group(op);
-	u64 now = READ_ONCE(jiffies);
-	u64 duration = (unsigned long)now -(unsigned long) start_time;
+	now = blk_get_iostat_ticks(q);;
+	duration = (unsigned long)now -(unsigned long) start_time;
 
 	part_stat_lock();
 	update_io_ticks(bdev, now, true);
-	part_stat_add(bdev, nsecs[sgrp], jiffies_to_nsecs(duration));
+	part_stat_add(bdev, nsecs[sgrp],
+		(blk_queue_precise_io_stat(q) ? duration :
+		 jiffies_to_nsecs(duration)));
 	part_stat_local_dec(bdev, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4e6b3ccd4989..5318bf87f17e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -975,7 +975,7 @@ static void __blk_account_io_done(struct request *req, u64 now)
 	const int sgrp = op_stat_group(req_op(req));
 
 	part_stat_lock();
-	update_io_ticks(req->part, jiffies, true);
+	update_io_ticks(req->part, blk_get_iostat_ticks(req->q), true);
 	part_stat_inc(req->part, ios[sgrp]);
 	part_stat_add(req->part, nsecs[sgrp], now - req->start_time_ns);
 	part_stat_unlock();
@@ -1007,7 +1007,7 @@ static void __blk_account_io_start(struct request *rq)
 		rq->part = rq->q->disk->part0;
 
 	part_stat_lock();
-	update_io_ticks(rq->part, jiffies, false);
+	update_io_ticks(rq->part, blk_get_iostat_ticks(rq->q), false);
 	part_stat_unlock();
 }
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 93d9e9c9a6ea..e7959782ce59 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -307,7 +307,6 @@ queue_##name##_store(struct request_queue *q, const char *page, size_t count) \
 
 QUEUE_SYSFS_BIT_FNS(nonrot, NONROT, 1);
 QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
-QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
 QUEUE_SYSFS_BIT_FNS(stable_writes, STABLE_WRITES, 0);
 #undef QUEUE_SYSFS_BIT_FNS
 
@@ -363,6 +362,44 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 	return ret;
 }
 
+static ssize_t queue_iostats_show(struct request_queue *q, char *page)
+{
+       bool iostat = blk_queue_io_stat(q);
+       bool precise_iostat = blk_queue_precise_io_stat(q);
+
+       return queue_var_show(iostat << precise_iostat, page);
+}
+
+static ssize_t queue_iostats_store(struct request_queue *q, const char *page,
+                                  size_t count)
+{
+       unsigned long val;
+       ssize_t ret = -EINVAL;
+
+       ret = queue_var_store(&val, page, count);
+
+       if (ret < 0)
+               return ret;
+
+       if (val == 2) {
+               blk_queue_flag_set(QUEUE_FLAG_IO_STAT, q);
+               blk_queue_flag_set(QUEUE_FLAG_PRECISE_IO_STAT, q);
+               q->disk->part0->bd_stamp = 0;
+       }
+       else if (val == 1) {
+               blk_queue_flag_set(QUEUE_FLAG_IO_STAT, q);
+               blk_queue_flag_clear(QUEUE_FLAG_PRECISE_IO_STAT, q);
+               q->disk->part0->bd_stamp = 0;
+       }
+       else if (val == 0) {
+               blk_queue_flag_clear(QUEUE_FLAG_IO_STAT, q);
+               blk_queue_flag_clear(QUEUE_FLAG_PRECISE_IO_STAT, q);
+               q->disk->part0->bd_stamp = 0;
+       }
+
+       return ret;
+}
+
 static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
 {
 	bool set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
diff --git a/block/genhd.c b/block/genhd.c
index 03a96d6473e1..d034219a4683 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -951,6 +951,7 @@ ssize_t part_stat_show(struct device *dev,
 	struct request_queue *q = bdev_get_queue(bdev);
 	struct disk_stats stat;
 	unsigned int inflight;
+	u64 stat_ioticks;
 
 	if (queue_is_mq(q))
 		inflight = blk_mq_in_flight(q, bdev);
@@ -959,10 +960,13 @@ ssize_t part_stat_show(struct device *dev,
 
 	if (inflight) {
 		part_stat_lock();
-		update_io_ticks(bdev, jiffies, true);
+		update_io_ticks(bdev, blk_get_iostat_ticks(q), true);
 		part_stat_unlock();
 	}
 	part_stat_read_all(bdev, &stat);
+	stat_ioticks = (blk_queue_precise_io_stat(q) ?
+				div_u64(stat.io_ticks, NSEC_PER_MSEC) :
+				jiffies_to_msecs(stat.io_ticks));
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
@@ -979,7 +983,7 @@ ssize_t part_stat_show(struct device *dev,
 		(unsigned long long)stat.sectors[STAT_WRITE],
 		(unsigned int)div_u64(stat.nsecs[STAT_WRITE], NSEC_PER_MSEC),
 		inflight,
-		jiffies_to_msecs(stat.io_ticks),
+		(unsigned int)stat_ioticks,
 		(unsigned int)div_u64(stat.nsecs[STAT_READ] +
 				      stat.nsecs[STAT_WRITE] +
 				      stat.nsecs[STAT_DISCARD] +
@@ -1217,6 +1221,8 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	unsigned int inflight;
 	struct disk_stats stat;
 	unsigned long idx;
+	struct request_queue *q;
+	u64 stat_ioticks;
 
 	/*
 	if (&disk_to_dev(gp)->kobj.entry == block_class.devices.next)
@@ -1235,12 +1241,16 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		else
 			inflight = part_in_flight(hd);
 
+		q = bdev_get_queue(hd);
 		if (inflight) {
 			part_stat_lock();
-			update_io_ticks(hd, jiffies, true);
+			update_io_ticks(hd, blk_get_iostat_ticks(q), true);
 			part_stat_unlock();
 		}
 		part_stat_read_all(hd, &stat);
+		stat_ioticks = (blk_queue_precise_io_stat(q) ?
+				div_u64(stat.io_ticks, NSEC_PER_MSEC) :
+				jiffies_to_msecs(stat.io_ticks));
 		seq_printf(seqf, "%4d %7d %pg "
 			   "%lu %lu %lu %u "
 			   "%lu %lu %lu %u "
@@ -1260,7 +1270,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			   (unsigned int)div_u64(stat.nsecs[STAT_WRITE],
 							NSEC_PER_MSEC),
 			   inflight,
-			   jiffies_to_msecs(stat.io_ticks),
+			   (unsigned int)stat_ioticks,
 			   (unsigned int)div_u64(stat.nsecs[STAT_READ] +
 						 stat.nsecs[STAT_WRITE] +
 						 stat.nsecs[STAT_DISCARD] +
diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index a72c096aa5b1..af193bcc4f3a 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -97,6 +97,12 @@ static void seq_print_one_request(struct seq_file *m, struct drbd_request *req,
 {
 	/* change anything here, fixup header below! */
 	unsigned int s = req->rq_state;
+	unsigned long start_time;
+	struct request_queue *q = req->device->rq_queue;
+
+	start_time = (blk_queue_precise_io_stat(q) ?
+			nsecs_to_jiffies(req->start_jif) :
+			req->start_jif);
 
 #define RQ_HDR_1 "epoch\tsector\tsize\trw"
 	seq_printf(m, "0x%x\t%llu\t%u\t%s",
@@ -105,7 +111,7 @@ static void seq_print_one_request(struct seq_file *m, struct drbd_request *req,
 		(s & RQ_WRITE) ? "W" : "R");
 
 #define RQ_HDR_2 "\tstart\tin AL\tsubmit"
-	seq_printf(m, "\t%d", jiffies_to_msecs(now - req->start_jif));
+	seq_printf(m, "\t%d", jiffies_to_msecs(now - start_time));
 	seq_print_age_or_dash(m, s & RQ_IN_ACT_LOG, now - req->in_actlog_jif);
 	seq_print_age_or_dash(m, s & RQ_LOCAL_PENDING, now - req->pre_submit_jif);
 
@@ -171,7 +177,9 @@ static void seq_print_waiting_for_AL(struct seq_file *m, struct drbd_resource *r
 			/* if the oldest request does not wait for the activity log
 			 * it is not interesting for us here */
 			if (req && !(req->rq_state & RQ_IN_ACT_LOG))
-				jif = req->start_jif;
+				jif = (blk_queue_precise_io_stat(device->rq_queue) ?
+						nsecs_to_jiffies(req->start_jif):
+						req->start_jif);
 			else
 				req = NULL;
 			spin_unlock_irq(&device->resource->req_lock);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index da28eb83e6ed..8e22487de7de 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1663,6 +1663,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	struct zram *zram;
 	struct bio_vec bv;
 	u64 start_time;
+	struct request_queue *q = bdev_get_queue(bdev);
 
 	if (PageTransHuge(page))
 		return -ENOTSUPP;
@@ -1682,7 +1683,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	bv.bv_offset = 0;
 
 	start_time = bdev_start_io_acct(bdev->bd_disk->part0,
-			SECTORS_PER_PAGE, op, jiffies);
+			SECTORS_PER_PAGE, op, blk_get_iostat_ticks(q));
 	ret = zram_bvec_rw(zram, &bv, index, offset, op, NULL);
 	bdev_end_io_acct(bdev->bd_disk->part0, op, start_time);
 out:
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 011a85ea40da..1bb58a0b8cd1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -482,7 +482,11 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 
 u64 dm_start_time_ns_from_clone(struct bio *bio)
 {
-	return jiffies_to_nsecs(clone_to_tio(bio)->io->start_time);
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	u64 start_time_ns = (blk_queue_precise_io_stat(q) ?
+				clone_to_tio(bio)->io->start_time :
+				jiffies_to_nsecs(clone_to_tio(bio)->io->start_time));
+	return start_time_ns;
 }
 EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
 
@@ -498,6 +502,11 @@ static void dm_io_acct(struct dm_io *io, bool end)
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 	unsigned int sectors;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+
+	u64 start_time = (blk_queue_precise_io_stat(q) ?
+				nsecs_to_jiffies(io->start_time) :
+				io->start_time);
 
 	/*
 	 * If REQ_PREFLUSH set, don't account payload, it will be
@@ -589,7 +598,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	io->orig_bio = bio;
 	io->md = md;
 	spin_lock_init(&io->lock);
-	io->start_time = jiffies;
+	io->start_time = blk_get_iostat_ticks(bio->bi_bdev->bd_queue);
 	io->flags = 0;
 
 	if (static_branch_unlikely(&stats_enabled))
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ca94d690d292..0543a536c6e5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -570,6 +570,7 @@ struct request_queue {
 #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
 #define QUEUE_FLAG_SQ_SCHED     30	/* single queue style io dispatch */
 #define QUEUE_FLAG_SKIP_TAGSET_QUIESCE	31 /* quiesce_tagset skip the queue*/
+#define QUEUE_FLAG_PRECISE_IO_STAT 32   /* To enable precise io accounting */
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1UL << QUEUE_FLAG_IO_STAT) |		\
 				 (1UL << QUEUE_FLAG_SAME_COMP) |	\
@@ -578,6 +579,7 @@ struct request_queue {
 void blk_queue_flag_set(unsigned int flag, struct request_queue *q);
 void blk_queue_flag_clear(unsigned int flag, struct request_queue *q);
 bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
+u64  blk_get_iostat_ticks(struct request_queue *q);
 
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
@@ -589,6 +591,8 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_stable_writes(q) \
 	test_bit(QUEUE_FLAG_STABLE_WRITES, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
+#define blk_queue_precise_io_stat(q)   \
+	test_bit(QUEUE_FLAG_PRECISE_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
 #define blk_queue_zone_resetall(q)	\
 	test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)
-- 
2.31.1

