Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3FA6437BC
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732629AbfFMPAu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 11:00:50 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13747 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732854AbfFMPAt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 11:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560438049; x=1591974049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B/236jbkaiRrkc0lA3JhYQDl5t+iiEvCT4RzOYq7iYk=;
  b=kBOpgLs/WwdQ5qgyUw0bUubiqyl0GG3DWqRYcnv1OeGnof/qbdlX2T/H
   zBeUH9Y/vhE3L4zTaf8rZYN3CuoKNfGefV6dGXrTULeSkJYXbDvnq6e0/
   mdcDYLw0ED2zb9qzSxI49GRoVU21lWRuTa7im9m+Oi7hVLb+AqUH53B9T
   wLSWEX/AR4KBwouv4PNW97R9wwhLfi65WsrxjmAXis7xX7VaxtsBNSNZ5
   +xA03f9PKtEh6wBiW53m1srmkWdZ/bEJ+fQdLP3d2ZZO7spFBojC5Fa/+
   852huZDeOOyklG6mORMAZhta59GdSPbsd7MB+Ge8/UuHN7hOd+Cmt1YP9
   g==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="216832963"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2019 23:00:48 +0800
IronPort-SDR: EJ/q/CYe96umvfGn/a1qXmkKWG/MPfTGZG0uBMFUi0z3cnHtruwOkWTsL9IcPok+ypqf3r+boq
 DBMRXgZRbo1qAp9AyIYk6EY7zs1uKblom+X1C/974sUUsLoNTUqYViAuzF8K6OoSbrSlwVuNOY
 ODopYFdzvMxExQ+ingzUO3F0fe5Q4cXSmEtDidZVSxqrqvydipta8CPE+CP8qSLgXFBDBU5S0z
 eKh0meUiHiAg6rhxlu25Gw+YAfhcfFncAx5f2gj4Cg/nSOjNxlfFeLcRR0FX0kj1pPiOXijIAD
 B261B6CJs2lLEZZ3ninI/Wy+
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP; 13 Jun 2019 08:00:32 -0700
IronPort-SDR: 7aK0vX8frD8+u/MtbTBVoK7pbwqBiQbprXpR2WVWZQx+qDw6LtiZR3jArM9y6vyLPeLEOdDAvq
 1GajpKHJv+5s1gyfr3gRSfQT90nbHIKRSuAzKiB+yXSCot0X++QzT1EdQxGp4a9pKubsiUrSXE
 ALks+oMxUuesOyemLFB2hmXHZ6lK1PDWV61uHdkqHixNKc4t7bG+OMsWQuO+PvmJGyADAAsDw8
 C2xmtwJ4xC4PUyfaK7eMR26D/T+fFiyz3QMyIbZt97T8X4fSrP1FshIMM953YMTgfPotJ/5lOt
 GY0=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Jun 2019 08:00:48 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 8/8] blktrace: use helper in blk_trace_setup_lba()
Date:   Thu, 13 Jun 2019 07:59:55 -0700
Message-Id: <20190613145955.4813-9-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blk_trace_setup_lba() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help if part_nr_sects_read() protected by appropriate locking.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 kernel/trace/blktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index e1c6d79fb4cc..35ff49503b85 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -461,7 +461,7 @@ static void blk_trace_setup_lba(struct blk_trace *bt,
 
 	if (part) {
 		bt->start_lba = part->start_sect;
-		bt->end_lba = part->start_sect + part->nr_sects;
+		bt->end_lba = part->start_sect + bdev_nr_sects(bdev);
 	} else {
 		bt->start_lba = 0;
 		bt->end_lba = -1ULL;
-- 
2.19.1

