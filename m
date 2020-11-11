Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DBE2AE787
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Nov 2020 05:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgKKElA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 10 Nov 2020 23:41:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33604 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgKKElA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Nov 2020 23:41:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB4XnCD142421;
        Wed, 11 Nov 2020 04:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=NXI1c6CsMKtQGAgf4Gl51+Xu72nD6F6c8qTL5VPqB4g=;
 b=JHx+/ZuH1M3uL6OxeblTp1/sKScDT5MCUDvguNKX8rUI1p8H57usIYV9bRHCWDespQQ7
 zRTMMKp/fqTTX6zx0mJYGPZuwpzDLOzO8GjNCOEVqSMsDZK7RKIfKSRe9TM2ZTtpRRxc
 Tb1pPjXgA3IJb2rUED1OtLxGxwWZ7l9/GpSMvLg6B+2Lbznx0AUOo/5gp3ZKLgj9Llp/
 egMHyyTdOYvuP126mx9fRuvDSSw0KRh9qLgFrEJQIZ14HUR1kLcuUfrnRt7w4SKpNnIa
 899Zc52zaaV9bAIADND/8dnA1ahfGc1zBkS8smzP4DGtkLAseBT7exTqjCDdcFBo2lcJ JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhky3su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 04:40:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB4a9rv116814;
        Wed, 11 Nov 2020 04:38:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34p5gxvdgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 04:38:30 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB4cPuQ001178;
        Wed, 11 Nov 2020 04:38:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 20:38:25 -0800
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org,
        martin.petersen@oracle.com
Subject: Re: [PATCH, RFC 11/10] block: propagate BLKROSET to all partitions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1imacecwz.fsf@ca-mkp.ca.oracle.com>
References: <20201106140817.GA23557@lst.de>
Date:   Tue, 10 Nov 2020 23:38:22 -0500
In-Reply-To: <20201106140817.GA23557@lst.de> (Christoph Hellwig's message of
        "Fri, 6 Nov 2020 15:08:17 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110022
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Christoph,

> When setting the whole device read-only (or clearing the read-only
> state), also update the policy for all partitions.  The s390 dasd
> driver has awlways been doing this and it makes a lot of sense.

For your amusement, here's my attempt at addressing this from a while
back. Can't remember exactly why this stranded, I even wrote blktests
for it...

-- 
Martin K. Petersen	Oracle Linux Engineering

From a7898967402a69e59607300aa8e2e2a6941a61c1 Mon Sep 17 00:00:00 2001
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 27 Mar 2019 12:21:41 -0400
Subject: [PATCH] block: Fix read-only block device setting after revalidate

Commit 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading
partition") addressed a long-standing problem with user read-only
policy being overridden as a result of a device-initiated revalidate.
The commit has since been reverted due to a regression that left some
USB devices read-only indefinitely.

To fix the underlying problems with revalidate we need to keep track
of hardware state and user policy separately. Every time the state is
changed, either via a hardware event or the BLKROSET ioctl, the
per-partition read-only state is updated based on the combination of
device state and policy. The resulting active state is stored in a
separate hd_struct flag to avoid introducing additional lookups in the
I/O hot path.

The gendisk has been updated to reflect the current hardware state set
by the device driver. This is done to allow returning the device to
the hardware state once the user clears the BLKROSET flag.

For partitions, the existing hd_struct 'policy' flag is split into
two:

 - 'read_only' indicates the currently active read-only state of a
   whole disk device or partition.

 - 'ro_policy' indicates the whether the user has administratively set
   the whole disk or partition read-only via the BLKROSET ioctl.

The resulting semantics are as follows:

 - If BLKROSET is used to set a whole-disk device read-only, any
   partitions will end up in a read-only state until the user
   explicitly clears the flag.

 - If BLKROSET sets a given partition read-only, that partition will
   remain read-only even if the underlying storage stack initiates a
   revalidate. However, the BLKRRPART ioctl will cause the partition
   table to be dropped and any user policy on partitions will be lost.

 - If BLKROSET has not been set, both the whole disk device and any
   partitions will reflect the current write-protect state of the
   underlying device.

Cc: Jeremy Cline <jeremy@jcline.org>
Cc: Ewan D. Milne <emilne@redhat.com>
Reported-by: Oleksii Kurochko <olkuroch@cisco.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201221
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/block/blk-core.c b/block/blk-core.c
index 4673ebe42255..932f179a9095 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -792,7 +792,7 @@ static inline bool bio_check_ro(struct bio *bio, struct hd_struct *part)
 {
 	const int op = bio_op(bio);
 
-	if (part->policy && op_is_write(op)) {
+	if (part->read_only && op_is_write(op)) {
 		char b[BDEVNAME_SIZE];
 
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
diff --git a/block/genhd.c b/block/genhd.c
index 703267865f14..75138cf5540d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1539,38 +1539,73 @@ static void set_disk_ro_uevent(struct gendisk *gd, int ro)
 	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
 }
 
-void set_device_ro(struct block_device *bdev, int flag)
-{
-	bdev->bd_part->policy = flag;
-}
-
-EXPORT_SYMBOL(set_device_ro);
-
-void set_disk_ro(struct gendisk *disk, int flag)
+/**
+ * update_part_ro_state - iterate over partitions to update read-only state
+ * @disk:	The disk device
+ *
+ * This function updates the read-only state for all partitions on a
+ * given disk device. This is required every time a hardware event
+ * signals that the device write-protect state has changed. It is also
+ * necessary when the user sets or clears the read-only flag on the
+ * whole-disk device.
+ */
+static void update_part_ro_state(struct gendisk *disk)
 {
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 
-	if (disk->part0.policy != flag) {
-		set_disk_ro_uevent(disk, flag);
-		disk->part0.policy = flag;
-	}
-
-	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY_PART0);
 	while ((part = disk_part_iter_next(&piter)))
-		part->policy = flag;
+		if (disk->read_only || disk->part0.ro_policy || part->ro_policy)
+			part->read_only = true;
+		else
+			part->read_only = false;
 	disk_part_iter_exit(&piter);
 }
 
+/**
+ * set_device_ro - set a block device read-only
+ * @bdev:	The block device (whole disk or partition)
+ * @state:	true or false
+ *
+ * This function is used to specify the read-only policy for a
+ * block_device (whole disk or partition). set_device_ro() is called
+ * by the BLKROSET ioctl.
+ */
+void set_device_ro(struct block_device *bdev, bool state)
+{
+	bdev->bd_part->read_only = bdev->bd_part->ro_policy = state;
+	if (bdev->bd_part->partno == 0)
+		update_part_ro_state(bdev->bd_disk);
+}
+EXPORT_SYMBOL(set_device_ro);
+
+/**
+ * set_disk_ro - set a gendisk read-only
+ * @disk:	The disk device
+ * @state:	true or false
+ *
+ * This function is used to indicate whether a given disk device
+ * should have its read-only flag set. set_disk_ro() is typically used
+ * by device drivers to indicate whether the underlying physical
+ * device is write-protected.
+ */
+void set_disk_ro(struct gendisk *disk, bool state)
+{
+	if (disk->read_only == state)
+		return;
+	set_disk_ro_uevent(disk, state);
+	disk->read_only = state;
+	update_part_ro_state(disk);
+}
 EXPORT_SYMBOL(set_disk_ro);
 
 int bdev_read_only(struct block_device *bdev)
 {
 	if (!bdev)
 		return 0;
-	return bdev->bd_part->policy;
+	return bdev->bd_part->read_only;
 }
-
 EXPORT_SYMBOL(bdev_read_only);
 
 int invalidate_partition(struct gendisk *disk, int partno)
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 8e596a8dff32..8c55b90c918d 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -98,7 +98,7 @@ static ssize_t part_ro_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%d\n", p->policy ? 1 : 0);
+	return sprintf(buf, "%u\n", p->read_only ? 1 : 0);
 }
 
 static ssize_t part_alignment_offset_show(struct device *dev,
@@ -338,7 +338,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 		queue_limit_discard_alignment(&disk->queue->limits, start);
 	p->nr_sects = len;
 	p->partno = partno;
-	p->policy = get_disk_ro(disk);
+	p->read_only = get_disk_ro(disk);
 
 	if (info) {
 		struct partition_meta_info *pinfo = alloc_part_info(disk);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 06c0fd594097..3ebd94f520cc 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -118,7 +118,8 @@ struct hd_struct {
 	unsigned int discard_alignment;
 	struct device __dev;
 	struct kobject *holder_dir;
-	int policy, partno;
+	bool read_only, ro_policy;
+	int partno;
 	struct partition_meta_info *info;
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	int make_it_fail;
@@ -183,6 +184,7 @@ struct gendisk {
 
 	char disk_name[DISK_NAME_LEN];	/* name of major driver */
 	char *(*devnode)(struct gendisk *gd, umode_t *mode);
+	bool read_only;			/* device read-only state */
 
 	unsigned int events;		/* supported events */
 	unsigned int async_events;	/* async events, subset of all */
@@ -431,12 +433,12 @@ extern void del_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
 
-extern void set_device_ro(struct block_device *bdev, int flag);
-extern void set_disk_ro(struct gendisk *disk, int flag);
+extern void set_device_ro(struct block_device *bdev, bool state);
+extern void set_disk_ro(struct gendisk *disk, bool state);
 
 static inline int get_disk_ro(struct gendisk *disk)
 {
-	return disk->part0.policy;
+	return disk->part0.read_only;
 }
 
 extern void disk_block_events(struct gendisk *disk);
