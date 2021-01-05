Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B672EAB1E
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jan 2021 13:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbhAEMo1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Jan 2021 07:44:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729238AbhAEMo1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Jan 2021 07:44:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609850581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uy+q9x/LhT5LmxfrDWoXPnKFI8e993HQ2GG56/x1S54=;
        b=WdTE2tv8u9+MMwVjAe3cReaL5Tw+JS6p2oesNRWNsNTM1AMPQ8I46ZFp4zZ49lNhgu5oID
        LGwTRUlrIO5xjX37Z0wO6ZqSrtDRBSvNawNK0MxBHHwqK739CqwqpkhSE2HAGw4hdTmWxq
        IYoaQdnDGgLL/hnTQddbQJ6uE7QlLoc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-344HezKgN_OQjZeam1IO1w-1; Tue, 05 Jan 2021 07:42:59 -0500
X-MC-Unique: 344HezKgN_OQjZeam1IO1w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D6FE1927802;
        Tue,  5 Jan 2021 12:42:58 +0000 (UTC)
Received: from localhost (ovpn-12-37.pek2.redhat.com [10.72.12.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D57060BD8;
        Tue,  5 Jan 2021 12:42:56 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH V2 6/6] bcache: don't pass BIOSET_NEED_BVECS for the 'bio_set' embedded in 'cache_set'
Date:   Tue,  5 Jan 2021 20:42:03 +0800
Message-Id: <20210105124203.3726599-7-ming.lei@redhat.com>
In-Reply-To: <20210105124203.3726599-1-ming.lei@redhat.com>
References: <20210105124203.3726599-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This bioset is just for allocating bio only from bio_next_split, and it
needn't bvecs, so remove the flag.

Cc: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a4752ac410dc..4102e47f43e1 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1897,7 +1897,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 		goto err;
 
 	if (bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
-			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
+			BIOSET_NEED_RESCUER))
 		goto err;
 
 	c->uuids = alloc_meta_bucket_pages(GFP_KERNEL, sb);
-- 
2.28.0

