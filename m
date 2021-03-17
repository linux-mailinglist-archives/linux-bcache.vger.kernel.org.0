Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045D433E877
	for <lists+linux-bcache@lfdr.de>; Wed, 17 Mar 2021 05:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhCQEaw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 17 Mar 2021 00:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhCQEal (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 Mar 2021 00:30:41 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB47C06174A;
        Tue, 16 Mar 2021 21:30:41 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id s2so514542qtx.10;
        Tue, 16 Mar 2021 21:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cl/IsO9XApCmVlU9KhooKlOLmzn2brD9MHNFOCks2H8=;
        b=dAkGl3lbRCxSXMyR9O72p3eRppGWW+d58+VuaFzEqE2jkmZL1rcUFeE9ropVXZ3ZOK
         uOS0TOjgAilOBUvCDAhNwy/H8vTm/DbSz+yQWSiV6wPFwP33xreAn7lNS3dZ/H3DSHNv
         F8TpnaRfWSHAfKWu1w5v0PkckPHB7jIkuNuuBDK3ygglLNUsBMhPbjpxHlPmgERDmym4
         sQ0gB6KNzsPWouKYe5BwtoUqZTbZ/CAUhexJ9+OY/+1ciRR49X2rU1pi3imp+UYi3POM
         hCQ6lSlV+sNDaAx9elavVZjQC65APijgSctEH9MYGUUOximbJIwo4GOupHCS3EYj68O6
         dElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cl/IsO9XApCmVlU9KhooKlOLmzn2brD9MHNFOCks2H8=;
        b=YIAf2bLvYnyxeFc7j9om0LqXayR4Tj9DMzv+sV9CvSO6ovtIobDVxJR4aTCliwom7U
         0s4VEax+9jfS5SrFlX21dJpSj5/V1iB4KaCUU5gvbnnh9XdT5gGS4dfNqLvlgcoSSh3+
         ztJcbbQI1288vYC5F1RT7Ueyqt0g3n1fuHjnb+/Px0qlOJPlmsoO+/7PWNzXYWX5P5Ki
         iCYgH8C7fshRJM4rt6Eth8u1zw6fNZLF+mhawsPKWSbPMOefXt9yv7FMMQcb7gKzBwd/
         0ykdqQL4ySZDYEDvgMIwUnNDR8wneWcmeRPP1GD9ncznUqRbeHeXcT1RAySyfi0ChIz5
         TnFg==
X-Gm-Message-State: AOAM532s41at+325QLfz9itI8HfUJY28QMuWxDa9lqgeWqPyl3+nRi7R
        djaU60KAKLoYNKG0kbAgXwA=
X-Google-Smtp-Source: ABdhPJxcfkaLRkNpHYgjxrYUw16uNG4Hh05TjDChgoGNh9c0la7KW+dXw+fRALT1jvmXW1BSg32W7w==
X-Received: by 2002:ac8:5cc4:: with SMTP id s4mr2183019qta.214.1615955440177;
        Tue, 16 Mar 2021 21:30:40 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.5])
        by smtp.gmail.com with ESMTPSA id 8sm7439262qkc.32.2021.03.16.21.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 21:30:39 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] md: bcache: Trivial typo fixes in the file journal.c
Date:   Wed, 17 Mar 2021 10:00:18 +0530
Message-Id: <20210317043018.4097983-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


s/condidate/candidate/
s/folowing/following/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/md/bcache/journal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index c6613e817333..9f2eb8dec803 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -111,7 +111,7 @@ reread:		left = ca->sb.bucket_size - offset;
 			 * Check from the oldest jset for last_seq. If
 			 * i->j.seq < j->last_seq, it means the oldest jset
 			 * in list is expired and useless, remove it from
-			 * this list. Otherwise, j is a condidate jset for
+			 * this list. Otherwise, j is a candidate jset for
 			 * further following checks.
 			 */
 			while (!list_empty(list)) {
@@ -498,7 +498,7 @@ static void btree_flush_write(struct cache_set *c)
 		 * - If there are matched nodes recorded in btree_nodes[],
 		 *   they are clean now (this is why and how the oldest
 		 *   journal entry can be reclaimed). These selected nodes
-		 *   will be ignored and skipped in the folowing for-loop.
+		 *   will be ignored and skipped in the following for-loop.
 		 */
 		if (((btree_current_write(b)->journal - fifo_front_p) &
 		     mask) != 0) {
--
2.30.2

