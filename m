Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4B125840E
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Sep 2020 00:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgHaW1r (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 31 Aug 2020 18:27:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53680 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728103AbgHaW1q (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 31 Aug 2020 18:27:46 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VMPM51007975
        for <linux-bcache@vger.kernel.org>; Mon, 31 Aug 2020 15:27:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=orOKGnMltIL2BkGpdDMfb191zkSKOEQGAJQMiCk1jzo=;
 b=OyWteilhr2XBhunMHCsFDP8UZGe/7Avuz2HsEYiGlpXIhP2K1QBSUcEL61adf3fKxcwf
 Yh/BiqhZ5+6cr3N/SL+A+zDrvzflzHHEI3s4z446nTirQMdx9GRyHa6h24y15Tc9+vnn
 ciTblBxsUIAVYOOcdpEedMlfwfUv8o/Y7Iw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3386gt7cw8-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-bcache@vger.kernel.org>; Mon, 31 Aug 2020 15:27:46 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 15:27:45 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id DB76762E51BC; Mon, 31 Aug 2020 15:27:42 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>
CC:     <colyli@suse.de>, <axboe@kernel.dk>, <kernel-team@fb.com>,
        <song@kernel.org>, <hch@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 3/3] bcache: use part_[begin|end]_io_acct instead of disk_[begin|end]_io_acct
Date:   Mon, 31 Aug 2020 15:27:25 -0700
Message-ID: <20200831222725.3860186-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200831222725.3860186-1-songliubraving@fb.com>
References: <20200831222725.3860186-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_10:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxlogscore=843
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310132
X-FB-Internal: deliver
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This enables proper statistics in /proc/diskstats for bcache partitions.

Reviewed-by: Coly Li <colyli@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/bcache/request.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index c7cadaafa9475..7f54ae2236441 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -475,6 +475,7 @@ struct search {
 	unsigned int		read_dirty_data:1;
 	unsigned int		cache_missed:1;
=20
+	struct hd_struct	*part;
 	unsigned long		start_time;
=20
 	struct btree_op		op;
@@ -669,7 +670,7 @@ static void bio_complete(struct search *s)
 {
 	if (s->orig_bio) {
 		/* Count on bcache device */
-		disk_end_io_acct(s->d->disk, bio_op(s->orig_bio), s->start_time);
+		part_end_io_acct(s->part, s->orig_bio, s->start_time);
=20
 		trace_bcache_request_end(s->d, s->orig_bio);
 		s->orig_bio->bi_status =3D s->iop.status;
@@ -731,7 +732,7 @@ static inline struct search *search_alloc(struct bio =
*bio,
 	s->write		=3D op_is_write(bio_op(bio));
 	s->read_dirty_data	=3D 0;
 	/* Count on the bcache device */
-	s->start_time		=3D disk_start_io_acct(d->disk, bio_sectors(bio), bio_op=
(bio));
+	s->start_time		=3D part_start_io_acct(d->disk, &s->part, bio);
 	s->iop.c		=3D d->c;
 	s->iop.bio		=3D NULL;
 	s->iop.inode		=3D d->id;
@@ -1072,6 +1073,7 @@ struct detached_dev_io_private {
 	unsigned long		start_time;
 	bio_end_io_t		*bi_end_io;
 	void			*bi_private;
+	struct hd_struct	*part;
 };
=20
 static void detached_dev_end_io(struct bio *bio)
@@ -1083,7 +1085,7 @@ static void detached_dev_end_io(struct bio *bio)
 	bio->bi_private =3D ddip->bi_private;
=20
 	/* Count on the bcache device */
-	disk_end_io_acct(ddip->d->disk, bio_op(bio), ddip->start_time);
+	part_end_io_acct(ddip->part, bio, ddip->start_time);
=20
 	if (bio->bi_status) {
 		struct cached_dev *dc =3D container_of(ddip->d,
@@ -1109,7 +1111,7 @@ static void detached_dev_do_request(struct bcache_d=
evice *d, struct bio *bio)
 	ddip =3D kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	ddip->d =3D d;
 	/* Count on the bcache device */
-	ddip->start_time =3D disk_start_io_acct(d->disk, bio_sectors(bio), bio_=
op(bio));
+	ddip->start_time =3D part_start_io_acct(d->disk, &ddip->part, bio);
 	ddip->bi_end_io =3D bio->bi_end_io;
 	ddip->bi_private =3D bio->bi_private;
 	bio->bi_end_io =3D detached_dev_end_io;
--=20
2.24.1

