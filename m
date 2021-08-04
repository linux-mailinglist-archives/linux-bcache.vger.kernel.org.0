Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522CC3DFEA7
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 12:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237333AbhHDKBa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 06:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhHDKBa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 06:01:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBCAC0613D5;
        Wed,  4 Aug 2021 03:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=C7BNoQnfAhpf1wqghahug1gwysuiZ4tUzmHR/Uv5INQ=; b=DjcorNtLkts0oP6dnpTQfumsvp
        O2P1/zhII9l+7JUkGtZMN2Pn1xTz0ZLBQgMMVSZityRrbsgwhAkYOjzhRRwjxHzFnaLs33AHuOS0f
        3+v2K+PBrXa476TIP8IbNnljuGnrm+SbD9rl5MQwqfsq2is6VruACOLulFtvIYbB+zAWHWjcwxGNF
        Ew5/GSbbMlxTpikTCQjGda88tmEsu5PwVMA3zd0BwewYOk6UeHdzz7NlslL6lXnktoKPgsn1ZtEU5
        gX4nbrwsXi8O41tKqVUHrft0/km/Fas41l1i1kIVNcS5jAgBmoAAV1jnnV2ZJQO8q54pLY2hOG6nR
        FsMBFdRQ==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDfi-005f2N-DE; Wed, 04 Aug 2021 09:59:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Coly Li <colyli@suse.de>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 03/15] dm: make EBS depend on !HIGHMEM
Date:   Wed,  4 Aug 2021 11:56:22 +0200
Message-Id: <20210804095634.460779-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210804095634.460779-1-hch@lst.de>
References: <20210804095634.460779-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

__ebs_rw_bvec use page_address on the submitted bios data, and thus
can't deal with highmem.  Disable the target on highmem configs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 0602e82a9516..ecc559c60d40 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -340,7 +340,7 @@ config DM_WRITECACHE
 
 config DM_EBS
 	tristate "Emulated block size target (EXPERIMENTAL)"
-	depends on BLK_DEV_DM
+	depends on BLK_DEV_DM && !HIGHMEM
 	select DM_BUFIO
 	help
 	  dm-ebs emulates smaller logical block size on backing devices
-- 
2.30.2

