Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3A95EB35D
	for <lists+linux-bcache@lfdr.de>; Mon, 26 Sep 2022 23:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiIZVnW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 26 Sep 2022 17:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIZVnV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Sep 2022 17:43:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9EEA50E8;
        Mon, 26 Sep 2022 14:43:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 716A261470;
        Mon, 26 Sep 2022 21:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C117C433D6;
        Mon, 26 Sep 2022 21:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664228599;
        bh=yDsLJI6CYGz3X6/q58qiIO0l/wci+HoSYbTYvzlJ7BA=;
        h=Date:From:To:Cc:Subject:From;
        b=Wo4hh7jWXqgL9EBmMTYJ5FEhmLTj/hY41/Xu70oR7+DDRB0zDnfwgxYkOV5BXW19p
         5Sj1sZwjjgbGx7peQ9WEr47yHEaTi7TRyG5qP7eyd2lojpxc1FpLi+QfyhWuJvh+or
         tutGhqFaMK6brnJYvXb5Yn1xmawieRLFlKag8CVeRdn9j+mulcIr6Cas+klbNJrlts
         XaQ38ABFoI+1gENdJ1OmHqPad7Mli6V1thW13RRK+Dn1K9Suzwq7p6y9ZWUiXbe92T
         auM7skXSdwTLUfmW7yM9lYqqb/t9GcFA2d5wtU0cpZfGgrqN58K9w1wBpekjeNLkWb
         8inCKolEP48qw==
Date:   Mon, 26 Sep 2022 16:43:15 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] bcache: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <YzIc8z+QaHvqPjLX@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length arrays
declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for flexible-array members in unions.

Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/213
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/md/bcache/bcache_ondisk.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
index 97413586195b..d086a0ce4bc2 100644
--- a/drivers/md/bcache/bcache_ondisk.h
+++ b/drivers/md/bcache/bcache_ondisk.h
@@ -359,8 +359,8 @@ struct jset {
 	__u64			prio_bucket[MAX_CACHES_PER_SET];
 
 	union {
-		struct bkey	start[0];
-		__u64		d[0];
+		DECLARE_FLEX_ARRAY(struct bkey, start);
+		DECLARE_FLEX_ARRAY(__u64, d);
 	};
 };
 
@@ -424,8 +424,8 @@ struct bset {
 	__u32			keys;
 
 	union {
-		struct bkey	start[0];
-		__u64		d[0];
+		DECLARE_FLEX_ARRAY(struct bkey, start);
+		DECLARE_FLEX_ARRAY(__u64, d);
 	};
 };
 
-- 
2.34.1

