Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0F72F0B63
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Jan 2021 04:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbhAKDIM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 10 Jan 2021 22:08:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbhAKDIM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 10 Jan 2021 22:08:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610334406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uy+q9x/LhT5LmxfrDWoXPnKFI8e993HQ2GG56/x1S54=;
        b=Gq9uFMkGvJn9grdr8XmpIfI3VqSSU2MZjaVKRYSxnuP6QNWN8SooM7qoho3dSFHarX0MKb
        +vmOM5m5sz8kxjXCLqANnc1sy/X0U3c6b07vgDHR6FQ++IbQeyDadLUGvB/3MjfupObYmd
        Oj63BZwuaIi67w9JbUM1mOqwaMnbLjE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-jehQohl1PVCNUoXejYQrzg-1; Sun, 10 Jan 2021 22:06:42 -0500
X-MC-Unique: jehQohl1PVCNUoXejYQrzg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FDBD107ACE6;
        Mon, 11 Jan 2021 03:06:41 +0000 (UTC)
Received: from localhost (ovpn-12-180.pek2.redhat.com [10.72.12.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ED766EF50;
        Mon, 11 Jan 2021 03:06:40 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH V3 6/6] bcache: don't pass BIOSET_NEED_BVECS for the 'bio_set' embedded in 'cache_set'
Date:   Mon, 11 Jan 2021 11:05:57 +0800
Message-Id: <20210111030557.4154161-7-ming.lei@redhat.com>
In-Reply-To: <20210111030557.4154161-1-ming.lei@redhat.com>
References: <20210111030557.4154161-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

