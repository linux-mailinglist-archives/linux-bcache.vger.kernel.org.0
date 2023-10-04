Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4967B7C59
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Oct 2023 11:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241990AbjJDJiH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Oct 2023 05:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242018AbjJDJiH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Oct 2023 05:38:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA43B8
        for <linux-bcache@vger.kernel.org>; Wed,  4 Oct 2023 02:38:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9D8FD1F45B;
        Wed,  4 Oct 2023 09:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1696412282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=shAJIvDm92gxG8/1fIa5UyMlxVsDe6+BAjWqKxA7x00=;
        b=LZS+OaEUfmkjdpdhOdVE1y6af89Zy1+D2SyqQFHFSo5hnIoa0rq4DDYATN+QLRgC6XnZ8r
        PnLAiMciA5XIUhwZJmA7fS/6d+7l17VIpghF6ekkUBzeuHXM1JuIYuMn6exVGMxiBxJp1Y
        G2xItF6HzrDXMtJmi0w9rx+KX4XU95s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1696412282;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=shAJIvDm92gxG8/1fIa5UyMlxVsDe6+BAjWqKxA7x00=;
        b=WZrVnFMiK/SDCZ0AH6DNXAmOxW6SdwpyIWAcgNpDIFoMwtlG05vD5893kalPIgtF8ZnesN
        atyFMPxZ34yFdNBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F686139F9;
        Wed,  4 Oct 2023 09:38:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JhD5InoyHWXoSgAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 04 Oct 2023 09:38:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id F2E8AA07CF; Wed,  4 Oct 2023 11:38:01 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH] bcache: Fixup error handling in register_cache()
Date:   Wed,  4 Oct 2023 11:37:57 +0200
Message-Id: <20231004093757.11560-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2602; i=jack@suse.cz; h=from:subject; bh=CVMiJNGm56lvleawpuekUOjtYIs6Dqk6EegL8BcFCK0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBlHTJuKD8bHXnNfefO+Y2RTpt9QA1yE3BDTybG9PsK 1+wrXtmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZR0ybgAKCRCcnaoHP2RA2RZ+B/ 9tZAydEiyxy/cOsbr79KQQWOg7c2xaokmKeVtsaJrtNiIfmAf3FojVQdLB4JVo7DTeOVG0ApJMl7Fw PsiKoYa/sqVbek2FQDHgSvfiONI4+Vt8rK7DzVcTz1vrvBXDH0Jzo9MHKtwwZ6ZNUCukBiEttpb+7+ 8XYT304Hl77Q8LkRYqYvUP9kaGwTVP6qZ/exzoye2DNqWzlPFTnhtq3Y30gb0uE009BwbozHo1zuTp 8OcTUHDqnowtbwgUCA/HOvybCNQzauyy8xiJir4z4mY1AjlBJ3GL1B65vfKkKA5kbZQG3NMtG4VbYi ZzDh98fLHMMnClNQTVLiv4cR46cXGY
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Coverity has noticed that the printing of error message in
register_cache() uses already freed bdev_handle to get to bdev. In fact
the problem has been there even before commit "bcache: Convert to
bdev_open_by_path()" just a bit more subtle one - cache object itself
could have been freed by the time we looked at ca->bdev and we don't
hold any reference to bdev either so even that could in principle go
away (due to device unplug or similar). Fix all these problems by
printing the error message before closing the bdev.

Fixes: dc893f51d24a ("bcache: Convert to bdev_open_by_path()")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/md/bcache/super.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

Hello Christian!

Can you please add this to patch to the bdev_handle conversion series? Either
append it at the end of the series or just fold it into the bcache conversion.
Whatever looks better for you.


diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c11ac86be72b..a30c8d4f2ac8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2354,6 +2354,13 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 	ret = cache_alloc(ca);
 	if (ret != 0) {
+		if (ret == -ENOMEM)
+			err = "cache_alloc(): -ENOMEM";
+		else if (ret == -EPERM)
+			err = "cache_alloc(): cache device is too small";
+		else
+			err = "cache_alloc(): unknown error";
+		pr_notice("error %pg: %s\n", bdev_handle->bdev, err);
 		/*
 		 * If we failed here, it means ca->kobj is not initialized yet,
 		 * kobject_put() won't be called and there is no chance to
@@ -2361,17 +2368,12 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 		 * we explicitly call bdev_release() here.
 		 */
 		bdev_release(bdev_handle);
-		if (ret == -ENOMEM)
-			err = "cache_alloc(): -ENOMEM";
-		else if (ret == -EPERM)
-			err = "cache_alloc(): cache device is too small";
-		else
-			err = "cache_alloc(): unknown error";
-		goto err;
+		return ret;
 	}
 
 	if (kobject_add(&ca->kobj, bdev_kobj(bdev_handle->bdev), "bcache")) {
-		err = "error calling kobject_add";
+		pr_notice("error %pg: error calling kobject_add\n",
+			  bdev_handle->bdev);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -2389,11 +2391,6 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 out:
 	kobject_put(&ca->kobj);
-
-err:
-	if (err)
-		pr_notice("error %pg: %s\n", ca->bdev_handle->bdev, err);
-
 	return ret;
 }
 
-- 
2.35.3

