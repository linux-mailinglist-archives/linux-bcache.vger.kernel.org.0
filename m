Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A565E477A8
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 03:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfFQB27 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 Jun 2019 21:28:59 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7477 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbfFQB27 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 Jun 2019 21:28:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560734939; x=1592270939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K29XvBy1OHbhlx9Frdz6GnWtW7nW03odbyP22pCCTYs=;
  b=Hmiz89On8LA3/dwvVhZOxwvPTFAT6Us2TlX6BFv1mr+40xgwV1ND1oC0
   wGyqwSebp9nX1RcIoV4ca17mx6Mj7ApeF/USvOeW8iLDU2zqztNzFZ86Y
   Wff3eOxrOODoYe7DuZby4drfKyMlwQ/l5wCeF1vIgxH8+OxmleXQpux9k
   M2ZC3b6cUCWXela/CCF+2fkNRhILKoL1NpqM2t7eRio3KzCSC746Se8AQ
   5V3jRCxT65cyTOUGeZYCe7NmO9f7vVhU9R2UtbchVeBsQBvokxl8J0WqF
   foZSdjHFdjW3tYIbmQ+F/EXNRxRFuVnZKd+6LuCAQUlsqAJKrxa5CuehJ
   g==;
X-IronPort-AV: E=Sophos;i="5.63,383,1557158400"; 
   d="scan'208";a="112362952"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2019 09:28:59 +0800
IronPort-SDR: tBwixJBN+DwVwWGvSh2gjOX0vMPu1LdRtTaJwOSdb92nn5NPkbniUOmdxkblzZkJpZXOHevbqr
 ocnY7mU0kI1+e1sWIo8Vl6PaDJWFofgxfKkcnJRxAn80jv2VXgMUwLIyvz73cakmDkDWd9jF91
 DQGrnEWl5HnEcA1UzocTnJHwwdTth1FlfANf+IuEeXX5ytiXPCUBARlJxboOb6Cpcn3LrWvhI4
 T530akYmsU/LV3e7PxdEBxtm54dkYLc4SrETYz8llP+8AKi0GK2/foqDhluno4e1YgmQsogdLn
 mBieyRqJ6nCUdLMZBfNPyZbX
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 16 Jun 2019 18:28:36 -0700
IronPort-SDR: CruxJP3S1RgdTPbb+j4RhagDod8aT0DppNlv7Hc4gJ6nlkYw1OV/BFMaiTqoaKy7B9Q75ko5dI
 MdnI/+GVbrgrK2Dx2o7t6EjrDbUl1czNu7z6Nx/4p/lk4XweJTtsW9qja9mPCh+E4Qjmyca9nk
 c/nulsNngUm3vS0Kr493ZqMC9/Bq9KKtI6Az1bEDJDuOvI/VPGL5iE1YUuAcPEa8+faIKcwjJY
 0OFsd9IkEEMkgqSZLSBGE3cOughgybztTr+uLQn0lA5/FQzYCynNImOzNzjGCYIEKrTWJVcVhQ
 PhI=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2019 18:28:59 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, kent.overstreet@gmail.com,
        jaegeuk@kernel.org, damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V2 6/7] f2fs: use helper in init_blkz_info()
Date:   Sun, 16 Jun 2019 18:28:31 -0700
Message-Id: <20190617012832.4311-7-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the init_blkz_info() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help if part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 6b959bbb336a..24e2848afcf5 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2798,7 +2798,7 @@ static int init_percpu_info(struct f2fs_sb_info *sbi)
 static int init_blkz_info(struct f2fs_sb_info *sbi, int devi)
 {
 	struct block_device *bdev = FDEV(devi).bdev;
-	sector_t nr_sectors = bdev->bd_part->nr_sects;
+	sector_t nr_sectors = bdev_nr_sects(bdev);
 	sector_t sector = 0;
 	struct blk_zone *zones;
 	unsigned int i, nr_zones;
-- 
2.19.1

