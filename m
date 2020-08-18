Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58797247EF4
	for <lists+linux-bcache@lfdr.de>; Tue, 18 Aug 2020 09:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgHRHDg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 18 Aug 2020 03:03:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27602 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgHRHDg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Aug 2020 03:03:36 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07I73Q0J023501
        for <linux-bcache@vger.kernel.org>; Tue, 18 Aug 2020 00:03:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Yy34D/NbA5LPKQ3e5rZPbBOItonCgnGr+j0WvmLVOwY=;
 b=AoNwg+se8uLbny9aeLy4XcddDBFQWfhZCzevuD8ByDTDTwL3hEQCgDV4HYKylE2CemXK
 Mdri/vIvo1+Fs9I88qkVwtKYZO6sF/ITbgyNkdo7vyfPEcuRACe9lUzMZMCFHTNEk1tN
 R1HO2PhHgL668Zg8hYb7hibxbY70L0I72WE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304kph6gw-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-bcache@vger.kernel.org>; Tue, 18 Aug 2020 00:03:34 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 00:02:57 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 76D5262E54B8; Tue, 18 Aug 2020 00:02:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>
CC:     <colyli@suse.de>, <axboe@kernel.dk>, <kernel-team@fb.com>,
        <song@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH 3/4] md: use part_[begin|end]_io_acct instead of disk_[begin|end]_io_acct
Date:   Tue, 18 Aug 2020 00:02:37 -0700
Message-ID: <20200818070238.1323126-4-songliubraving@fb.com>
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
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=838
 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180049
X-FB-Internal: deliver
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This enables proper statistics in /proc/diskstats for md partitions.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/md.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6b511c9007d38..00ca65b206d13 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -470,6 +470,7 @@ struct md_io {
 	bio_end_io_t *orig_bi_end_io;
 	void *orig_bi_private;
 	unsigned long start_time;
+	struct hd_struct *part;
 };
=20
 static void md_end_io(struct bio *bio)
@@ -477,7 +478,8 @@ static void md_end_io(struct bio *bio)
 	struct md_io *md_io =3D bio->bi_private;
 	struct mddev *mddev =3D md_io->mddev;
=20
-	disk_end_io_acct(mddev->gendisk, bio_op(bio), md_io->start_time);
+	part_end_io_acct(md_io->part, bio_op(bio), md_io->start_time);
+	hd_struct_put(md_io->part);
=20
 	bio->bi_end_io =3D md_io->orig_bi_end_io;
 	bio->bi_private =3D md_io->orig_bi_private;
@@ -523,7 +525,9 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 		bio->bi_end_io =3D md_end_io;
 		bio->bi_private =3D md_io;
=20
-		md_io->start_time =3D disk_start_io_acct(mddev->gendisk,
+		md_io->part =3D disk_map_sector_rcu(mddev->gendisk,
+						  bio->bi_iter.bi_sector);
+		md_io->start_time =3D part_start_io_acct(md_io->part,
 						       bio_sectors(bio),
 						       bio_op(bio));
 	}
--=20
2.24.1

