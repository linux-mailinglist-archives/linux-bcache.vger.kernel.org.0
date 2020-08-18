Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5DC247EF1
	for <lists+linux-bcache@lfdr.de>; Tue, 18 Aug 2020 09:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHRHDe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 18 Aug 2020 03:03:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11598 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726228AbgHRHDd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Aug 2020 03:03:33 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07I73Q0D023501
        for <linux-bcache@vger.kernel.org>; Tue, 18 Aug 2020 00:03:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=rvea/9K2FjSVrAXUbPe6D5ihbqBBSEoKRQiQoNpsaBc=;
 b=LlgflM9XIjeHpIR44XJTmY5Rzkj5Ch/8rf3dR+csVpuz08pZ45z7kxcjrLvQhTlm6Wyo
 6HDJHWU8aQJXyoPSmJISR7vXTByaCN2spT+5B3dQmmxToyVAJDq7J1tA3qUjRmwXuTvm
 iPv0U1cxiO5PmWVtZGe8XVIxPDpkf5t+c3w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304kph6gw-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-bcache@vger.kernel.org>; Tue, 18 Aug 2020 00:03:32 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 00:02:53 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9194962E54B8; Tue, 18 Aug 2020 00:02:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>
CC:     <colyli@suse.de>, <axboe@kernel.dk>, <kernel-team@fb.com>,
        <song@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH 1/4] block: expose disk_map_sector_rcu() and hd_struct_put in genhd.h
Date:   Tue, 18 Aug 2020 00:02:35 -0700
Message-ID: <20200818070238.1323126-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818070238.1323126-1-songliubraving@fb.com>
References: <20200818070238.1323126-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_04:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=983
 lowpriorityscore=0 suspectscore=2 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180049
X-FB-Internal: deliver
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

So they can be used in drivers.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 block/blk.h           | 8 --------
 block/genhd.c         | 1 +
 include/linux/genhd.h | 8 ++++++++
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 94f7c084f68fc..a6bc909480111 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -332,8 +332,6 @@ void blk_queue_free_zone_bitmaps(struct request_queue=
 *q);
 static inline void blk_queue_free_zone_bitmaps(struct request_queue *q) =
{}
 #endif
=20
-struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sec=
tor);
-
 int blk_alloc_devt(struct hd_struct *part, dev_t *devt);
 void blk_free_devt(dev_t devt);
 void blk_invalidate_devt(dev_t devt);
@@ -358,12 +356,6 @@ static inline int hd_struct_try_get(struct hd_struct=
 *part)
 	return 1;
 }
=20
-static inline void hd_struct_put(struct hd_struct *part)
-{
-	if (part->partno)
-		percpu_ref_put(&part->ref);
-}
-
 static inline void hd_free_part(struct hd_struct *part)
 {
 	free_percpu(part->dkstats);
diff --git a/block/genhd.c b/block/genhd.c
index 60ae4e1b4d387..5b9333317dcb4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -349,6 +349,7 @@ struct hd_struct *disk_map_sector_rcu(struct gendisk =
*disk, sector_t sector)
 	rcu_read_unlock();
 	return part;
 }
+EXPORT_SYMBOL_GPL(disk_map_sector_rcu);
=20
 /**
  * disk_has_partitions
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 31a54072ffd65..b47c64f9f26b4 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -380,6 +380,14 @@ void bd_set_size(struct block_device *bdev, loff_t s=
ize);
 int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long=
);
 long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
=20
+struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sec=
tor);
+
+static inline void hd_struct_put(struct hd_struct *part)
+{
+	if (part->partno)
+		percpu_ref_put(&part->ref);
+}
+
 #ifdef CONFIG_SYSFS
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)=
;
 void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *di=
sk);
--=20
2.24.1

