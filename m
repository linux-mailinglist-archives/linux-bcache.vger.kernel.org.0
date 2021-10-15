Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADD242FEB8
	for <lists+linux-bcache@lfdr.de>; Sat, 16 Oct 2021 01:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243562AbhJOXdF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 19:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243523AbhJOXdC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 19:33:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906CFC061766;
        Fri, 15 Oct 2021 16:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=aZFecDF1ldcXYk4nHZIO3Oiyap30nIpOJCBEBcBqi0s=; b=HD+Qk+Bx+MpXZU2MHZ4t4Sxat2
        DNGC19tZqsNk5kaOdxLSoQOdAlgAopH4u4gn2XKvhwhhnLHxdWWqN5fCxYWfdEGroOdDkyQFSgVIM
        3NVYP1J6+CVjAH3Hab0vM3zi+zurKIUbPO2QHwBtJeapE+UxtfJCUFN8yoCUrvsHWJZZS4+8Q/on9
        WjWMykMGWnpnRaJrC2ZUBSpQheXdKedAalVoZCgNhqi0wY9btFxH319CAejwGgXRMvmWBVKs9t1kj
        /PlJZy2TK+edVXplwI9ClsL3xg19IRPdhsGIvvZ8RZLaiVWOCF7uYcsZOI48v/N59scjY1eDLwSpr
        zZKZhP1g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbWej-0095uv-7C; Fri, 15 Oct 2021 23:30:29 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        agk@redhat.com, snitzer@redhat.com, colyli@suse.de,
        kent.overstreet@gmail.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, roger.pau@citrix.com,
        geert@linux-m68k.org, ulf.hansson@linaro.org, tj@kernel.org,
        hare@suse.de, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes.berg@intel.com,
        krisman@collabora.com, chris.obbard@collabora.com,
        thehajime@gmail.com, zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, miquel.raynal@bootlin.com, vigneshr@ti.com,
        linux-mtd@lists.infradead.org
Cc:     linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/9] scsi/sr: add error handling support for add_disk()
Date:   Fri, 15 Oct 2021 16:30:21 -0700
Message-Id: <20211015233028.2167651-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015233028.2167651-1-mcgrof@kernel.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Just put the cdrom kref and have the unwinding be done by
sr_kref_release().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/scsi/sr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 115f7ef7a5de..4e5515848fa6 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -728,7 +728,12 @@ static int sr_probe(struct device *dev)
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
 	sr_revalidate_disk(cd);
-	device_add_disk(&sdev->sdev_gendev, disk, NULL);
+
+	error = device_add_disk(&sdev->sdev_gendev, disk, NULL);
+	if (error) {
+		kref_put(&cd->kref, sr_kref_release);
+		goto fail;
+	}
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
-- 
2.30.2

