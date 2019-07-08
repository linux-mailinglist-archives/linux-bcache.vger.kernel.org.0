Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F21628A7
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jul 2019 20:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbfGHSsD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Jul 2019 14:48:03 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:40616 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfGHSsD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jul 2019 14:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562611683; x=1594147683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=9HCTUA025JIZSm64FGSGpZxpfChbQ94lvGtg+dmKvTo=;
  b=DK2EioRQ9/WEfpCU2JZ1MUa9aEfst7J7UpNOaY0ygb5XP2MDQgK6IoCK
   BhqNfs1+rdQN0XeNcnsNBHlAUog043hezMIE3e9JeGO1iUOkLd2+nRQsm
   kKwdc3oCFZNkmBIw1HfPlXcHCG9Y01ZboOb2vzgMOBilcWvUHSAgQrueb
   9CEKB/v7t7LN2bbHcStqSBSDo6ahqXAJTNiahkgBhv0Xj9OukLAaSHcpe
   paWfKjZGINo5JEiVxtGXKL/37NWHtrcpt7TxFMCc8b+xlxQ548gt6Cekk
   ot3EzwmkINpV4bqJtDYbHq6RUmy+OBYubHxNTYEu9nMVXlBGIWNO7FBxK
   g==;
IronPort-SDR: o7PA8DYD9ZXarrkV/RelgHnhi1PO6omk6MM3WsyRgksxy35NnovVtRsPyDxbBBYn4tO5zoP9ox
 i3uep1IfbSliL6DQF4TZwvfcsRjrUvyKfCC5imnzhsW1TI9xTR7tnjhPQQCB687DI3uOASJfjD
 41+H59T/7C6eAXbwJ3J0LIZeqkswdlqRddcHkqXiNTODJSXU3EQH8OaBRJsNwcdsA/Cf4EWB6z
 IzKpfFevTBwi7+X56Z79rydEHtpYNDDMI+7MYsw+TaYLxQF5ytZDJofPyyCRIXZxM6fqjstD0U
 C30=
X-IronPort-AV: E=Sophos;i="5.63,466,1557158400"; 
   d="scan'208";a="112477286"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2019 02:48:03 +0800
IronPort-SDR: 3Mi+U2FENEv6tIBaw8rijg8FkM09NXQX9SXQkGwNVCsmhgIgMZ3T0/UUy9uvPdx4PlXL0YnQVX
 CXA6NY6hv4/6NkyUIa0JZnElR459z9RXN+/SUB0ezQRaJdxqFr5cDiCRnD7LHK3/znU6QiPe4x
 ipXAxpdBi1qLUyyrhL0qusCCPce09ch3cfwFlT9sl6nLhbXnr93ood1ngmDekZNgdCQtQt1CSH
 dm5EP5pzcjegbj8iPqve99Rp9R2i6aznNRRrEC+oBA1Hs3BPGxHdGo7x/drn7OC0vevqoD5YE1
 9UI4aEZMwejLwBTexYQHndm0
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 08 Jul 2019 11:46:51 -0700
IronPort-SDR: IANeuyJ1+oRIdNc63u5j8ED18tDaGyZU+gvHhHZl87+2ajQm6m/jQpodcxPNu6UDb5asJbFKCF
 6kz3QDjj06c+UBwngWRsx/wVxzGhe9RxGj9M6n8nOLjRppziguHG7Au4OsvD9KbRnMH5je9sId
 HZ4Az4HgCGj+Ik8pP5ZOAxIWgro9VZXW9hO0HsvtN/hE2ky3WsAJ8tq8rmu1xhjScNYGWeQANg
 CM/zAZ7im7Ix2Wx+pAYuDpo1aK5GRVnwAfHYBnzr+C01DF6NPe1R8G3EOZVTfz4MlWW3FOijlF
 U58=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jul 2019 11:48:02 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 8/9] target/pscsi: use helper in pscsi_get_blocks()
Date:   Mon,  8 Jul 2019 11:47:10 -0700
Message-Id: <20190708184711.2984-9-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the pscsi_get_blocks() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help of part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index c9d92b3e777d..da481edab2de 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1030,7 +1030,7 @@ static sector_t pscsi_get_blocks(struct se_device *dev)
 	struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
 
 	if (pdv->pdv_bd && pdv->pdv_bd->bd_part)
-		return pdv->pdv_bd->bd_part->nr_sects;
+		return bdev_nr_sects(pdv->pdv_bd);
 
 	return 0;
 }
-- 
2.17.0

