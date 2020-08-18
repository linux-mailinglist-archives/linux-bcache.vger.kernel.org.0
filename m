Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B112247EE7
	for <lists+linux-bcache@lfdr.de>; Tue, 18 Aug 2020 09:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgHRHDD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 18 Aug 2020 03:03:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62666 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726341AbgHRHDA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Aug 2020 03:03:00 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07I6rsnT005112
        for <linux-bcache@vger.kernel.org>; Tue, 18 Aug 2020 00:02:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Npk3GdRY9AeNBQyLoAMZ/zo8qHiGbF7qwAivLfb+2ww=;
 b=aeC7DZuSPWUVSZmImFKzowN+LWCUxCgjNPX3WHobm7GUY8bnz24Xo4mKxtjBR4pdoKNM
 rgjdy6giV79xFjSAEORnM9PpnwsxZn1TaA+Y0aOJ40hYtbkOJReMUWIUweCnnfhhxEJR
 DDF6KNzmFUUpkwWfJXBfd+RmVGJ7yEnLUv0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3304jj176r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-bcache@vger.kernel.org>; Tue, 18 Aug 2020 00:02:58 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 00:02:57 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id C9EEC62E54B8; Tue, 18 Aug 2020 00:02:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>
CC:     <colyli@suse.de>, <axboe@kernel.dk>, <kernel-team@fb.com>,
        <song@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH 2/4] block: introduce part_[begin|end]_io_acct
Date:   Tue, 18 Aug 2020 00:02:36 -0700
Message-ID: <20200818070238.1323126-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818070238.1323126-1-songliubraving@fb.com>
References: <20200818070238.1323126-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_04:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=748 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180048
X-FB-Internal: deliver
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

These functions can be used to enable iostat for partitions on devices
like md, bcache.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 block/blk-core.c       | 20 ++++++++++++++++----
 include/linux/blkdev.h |  5 +++++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 93104c7470e8a..6603f56804f41 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1455,10 +1455,9 @@ void blk_account_io_start(struct request *rq)
 	part_stat_unlock();
 }
=20
-unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sect=
ors,
+unsigned long part_start_io_acct(struct hd_struct *part, unsigned int se=
ctors,
 		unsigned int op)
 {
-	struct hd_struct *part =3D &disk->part0;
 	const int sgrp =3D op_stat_group(op);
 	unsigned long now =3D READ_ONCE(jiffies);
=20
@@ -1471,12 +1470,18 @@ unsigned long disk_start_io_acct(struct gendisk *=
disk, unsigned int sectors,
=20
 	return now;
 }
+EXPORT_SYMBOL(part_start_io_acct);
+
+unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sect=
ors,
+		unsigned int op)
+{
+	return part_start_io_acct(&disk->part0, sectors, op);
+}
 EXPORT_SYMBOL(disk_start_io_acct);
=20
-void disk_end_io_acct(struct gendisk *disk, unsigned int op,
+void part_end_io_acct(struct hd_struct *part, unsigned int op,
 		unsigned long start_time)
 {
-	struct hd_struct *part =3D &disk->part0;
 	const int sgrp =3D op_stat_group(op);
 	unsigned long now =3D READ_ONCE(jiffies);
 	unsigned long duration =3D now - start_time;
@@ -1487,6 +1492,13 @@ void disk_end_io_acct(struct gendisk *disk, unsign=
ed int op,
 	part_stat_local_dec(part, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 }
+EXPORT_SYMBOL(part_end_io_acct);
+
+void disk_end_io_acct(struct gendisk *disk, unsigned int op,
+		unsigned long start_time)
+{
+	part_end_io_acct(&disk->part0, op, start_time);
+}
 EXPORT_SYMBOL(disk_end_io_acct);
=20
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 285b59cfc0646..894e55c91e1d8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1931,6 +1931,11 @@ unsigned long disk_start_io_acct(struct gendisk *d=
isk, unsigned int sectors,
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time);
=20
+unsigned long part_start_io_acct(struct hd_struct *part, unsigned int se=
ctors,
+		unsigned int op);
+void part_end_io_acct(struct hd_struct *part, unsigned int op,
+		unsigned long start_time);
+
 /**
  * bio_start_io_acct - start I/O accounting for bio based drivers
  * @bio:	bio to start account for
--=20
2.24.1

