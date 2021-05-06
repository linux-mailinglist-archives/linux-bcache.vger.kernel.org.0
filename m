Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615C7374DB1
	for <lists+linux-bcache@lfdr.de>; Thu,  6 May 2021 04:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhEFCvH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 May 2021 22:51:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:45926 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231295AbhEFCvH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 May 2021 22:51:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3EADBAFAB;
        Thu,  6 May 2021 02:50:09 +0000 (UTC)
Subject: Re: Kernel Oops: kernel BUG at block/bio.c:52
To:     Marco Rebhan <me@dblsaiko.net>
Cc:     linux-bcache@vger.kernel.org, victor@westerhu.is
References: <5607192.MhkbZ0Pkbq@invader>
From:   Coly Li <colyli@suse.de>
Message-ID: <104da4a6-61be-63f9-8670-6243e9625e5a@suse.de>
Date:   Thu, 6 May 2021 10:50:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <5607192.MhkbZ0Pkbq@invader>
Content-Type: multipart/mixed;
 boundary="------------070C0F601446F87263B6669F"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------070C0F601446F87263B6669F
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 4/28/21 2:57 AM, Marco Rebhan wrote:
> Hi,
> 
> I'm getting the same issue on kernel 5.12.0 after upgrading from 
> 5.11.16. For me, so far the error always occurs a short while after 
> boot.
> 
>> Could you please help to apply a debug patch and gather some debug 
>> information when it reproduces ?
> 
> I could do that as well, which patch should I apply?

Could you please try the attached patch ?  If a suspicious bio
allocation happens, this patch will print out a warning kernel message
and avoid the BUG() panic.

Thank you in advance.

Coly Li

--------------070C0F601446F87263B6669F
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-bcache-avoid-oversized-bio_alloc_bioset-call-in-cach.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-bcache-avoid-oversized-bio_alloc_bioset-call-in-cach.pa";
 filename*1="tch"

From 6f2edee7100efabf2ccccb84e4a92ccbfbddd8c5 Mon Sep 17 00:00:00 2001
From: Coly Li <colyli@suse.de>
Date: Thu, 6 May 2021 10:38:41 +0800
Subject: [PATCH] bcache: avoid oversized bio_alloc_bioset() call in
 cached_dev_cache_miss()

Since Linux v5.12, calling bio_alloc_bioset() with oversized bio vectors
number will cause a BUG() panic in biovec_slab(). There are 2 locations
in bcache code calling bio_alloc_bioset(), and only the location in
cached_dev_cache_miss() has such potential oversized risk.

In cached_dev_cache_miss() the bio vectors number is calculated by
DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS), this patch checks the
calculated result, if it is larger than BIO_MAX_VECS, then give up the
allocation of cache_bio and sending request to backing device directly.

By this restriction, the potential BUG() panic can be avoided from the
cache missing code path.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/request.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 29c231758293..a657d3a2b624 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -879,7 +879,7 @@ static void cached_dev_read_done_bh(struct closure *cl)
 static int cached_dev_cache_miss(struct btree *b, struct search *s,
 				 struct bio *bio, unsigned int sectors)
 {
-	int ret = MAP_CONTINUE;
+	int ret = MAP_CONTINUE, nr_iovecs = 0;
 	unsigned int reada = 0;
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 	struct bio *miss, *cache_bio;
@@ -916,9 +916,14 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	/* btree_search_recurse()'s btree iterator is no good anymore */
 	ret = miss == bio ? MAP_DONE : -EINTR;
 
-	cache_bio = bio_alloc_bioset(GFP_NOWAIT,
-			DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS),
-			&dc->disk.bio_split);
+	nr_iovecs = DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS);
+	if (nr_iovecs > BIO_MAX_VECS) {
+		pr_warn("inserting bio is too large: %d iovecs, not intsert.\n",
+			nr_iovecs);
+		goto out_submit;
+	}
+	cache_bio = bio_alloc_bioset(GFP_NOWAIT, nr_iovecs,
+				     &dc->disk.bio_split);
 	if (!cache_bio)
 		goto out_submit;
 
-- 
2.26.2


--------------070C0F601446F87263B6669F--
