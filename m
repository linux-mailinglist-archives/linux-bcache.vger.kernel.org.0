Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5CB41A1DA
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Sep 2021 00:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237849AbhI0WCo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Sep 2021 18:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237726AbhI0WCa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Sep 2021 18:02:30 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263F7C061604;
        Mon, 27 Sep 2021 15:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vLYLL0oFZhxGylgSJPWXsGjPK2psQoUWyxkb9au47Xw=; b=vFdtNbirDyd+cqwuiMxjiJzgLG
        Jt0ChJnf2JuPRFu4a+wlNaF4kthrKz7PxnttkR0Ds40s2EhZvp4JmkbSX6L3ADzaVDhCnLDp3cCs/
        l0Ao4N5wA1GF1nIHrrOdTV9k0vDEX8dt7ZIGbkn5jeXk4By4iFu7i+TmcRDENgYIuV6M0/X0COZJ8
        PTZwba2aQr3+WagO31hkbEZG4Js9Hr92YGi4M//TLw0Zk2t95HtZSK54Goe3CUTOj1kxdO0jr9W83
        2Y8mWhaksDHH+sEiqrhCSZnBTG/J8tSzqfz5X0PYVM21EAFDp2zVD0/Chb9dwkwaSbB31hydbvvRb
        1P5EOUhg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyfw-004SvO-N8; Mon, 27 Sep 2021 22:00:40 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
        kbusch@kernel.org, sagi@grimberg.me, vishal.l.verma@intel.com,
        dan.j.williams@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, konrad.wilk@oracle.com, roger.pau@citrix.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, minchan@kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Cc:     xen-devel@lists.xenproject.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 08/10] nvdimm/blk: add error handling support for add_disk()
Date:   Mon, 27 Sep 2021 15:00:37 -0700
Message-Id: <20210927220039.1064193-9-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927220039.1064193-1-mcgrof@kernel.org>
References: <20210927220039.1064193-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Since nvdimm/blk uses devm we just need to move the devm
registration towards the end. And in hindsight, that seems
to also provide a fix given del_gendisk() should not be
called unless the disk was already added via add_disk().
The probably of that issue happening is low though, like
OOM while calling devm_add_action(), so the fix is minor.

We manually unwind in case of add_disk() failure prior
to the devm registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/blk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 591fa1f86f1e..9f1eb41404ac 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -265,7 +265,9 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	}
 
 	set_capacity(disk, available_disk_size >> SECTOR_SHIFT);
-	device_add_disk(dev, disk, NULL);
+	rc = device_add_disk(dev, disk, NULL);
+	if (rc)
+		goto out_before_devm_err;
 
 	/* nd_blk_release_disk() is called if this fails */
 	if (devm_add_action_or_reset(dev, nd_blk_release_disk, disk))
-- 
2.30.2

