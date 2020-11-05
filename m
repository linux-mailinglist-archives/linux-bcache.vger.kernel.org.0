Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDE02A80B5
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Nov 2020 15:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgKEOUX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Nov 2020 09:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgKEOUW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Nov 2020 09:20:22 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AEEC0613CF;
        Thu,  5 Nov 2020 06:20:22 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id x23so848492plr.6;
        Thu, 05 Nov 2020 06:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MNL8NatmF1PCt+mS/1abZS+QQ8kP3tgXYZ+LX4H+vzs=;
        b=aU0vcx2ye3YD8D0lrIxsNdoc73yJBSlBHCjESl5JwzJJyBdUgQQ+PHDbdy7be3lp8M
         J9CPbkxl9yaWVGlDIr7NSIgvwlG9Dgz/S3u0AjHmtqw1iEVoh67ohEYTAO+C5o3Ee7Ua
         63xyNpZ8p2Ea1Ur6GNNU9JkI2+KTSAQMCyt/PjiDET7Tm7KntBvzKDFiW4Rfblh+VNBr
         xlrvWKFDL6ZVSdrKhS7gouHzMtWWj+qDPcPuyUixjiPnSlbbtImhi7IN/eCXJ1FEqro8
         sEyhCwwZiioBuL9kDK27TQXNyn+We74IKFUL8GHMrkbs5nJV3MUXsfOahzNgWjY/uAnU
         OIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MNL8NatmF1PCt+mS/1abZS+QQ8kP3tgXYZ+LX4H+vzs=;
        b=KKIe/gwmT8U6urQCS9a7V7UeayroAhJA+oYzoUgHs+zjLp5okpshq3wkn4XGRT8p0r
         wq/aTlgkfjoGt4+191B8ZPuw5JgJHMxxt9zb8Q/oTCd2P8UmgnRK8ZlrzuFyZ5WdzOf6
         El51tLYOjCSfDs33tpRpuO/IgHX/NKA0nlLI28ZzzO3dqoAlhs/mCRmwkPDhSqHOIam7
         bycflHgw3byBxAFc9pPIdiN6rvS6t+v6zboeZHtZDe+nGRR4idfzFF0m/Lz0+jnRmVf3
         gGPnvQ6oRrtsnnEgi0Y9sH/yMqmzf465VoAZNTuG6bAzIj3GuyGRPkQKpgHgnjTmjY49
         0gWQ==
X-Gm-Message-State: AOAM531V6MgNB8M8e4Id8uE6qrqWxHtfgsUlcD/sIFtbG4bgTjINogF/
        /3jZNMvHvSMXtVyVHAmLvgM=
X-Google-Smtp-Source: ABdhPJxQoycv3OtMK+OlIg1oRSmsok6FWG5p2xxWO0qD39KORNkctM6hIaCUMegjOVJNx0FyLXbcCQ==
X-Received: by 2002:a17:90a:ea16:: with SMTP id w22mr2678563pjy.64.1604586022116;
        Thu, 05 Nov 2020 06:20:22 -0800 (PST)
Received: from localhost.localdomain ([45.77.27.82])
        by smtp.gmail.com with ESMTPSA id 198sm2721196pfz.182.2020.11.05.06.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 06:20:21 -0800 (PST)
From:   Dongdong Tao <tdd21151186@gmail.com>
To:     colyli@suse.de
Cc:     dongdong.tao@canonical.com,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org (open list:BCACHE (BLOCK LAYER CACHE)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] bcache: make writeback_cutoff and writeback_cutoff_sync writeable
Date:   Thu,  5 Nov 2020 22:19:39 +0800
Message-Id: <20201105141939.9223-1-tdd21151186@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: dongdong tao <dongdong.tao@canonical.com>

commit 9aaf51654672 ("bcache: make cutoff_writeback and
cutoff_writeback_sync tunable") intend to make these two option
configurable by user, but these two are still read-only.

Signed-off-by: dongdong tao <dongdong.tao@canonical.com>
---
 drivers/md/bcache/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 554e3afc9b68..81f4a681705c 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -102,8 +102,8 @@ read_attribute(writeback_keys_done);
 read_attribute(writeback_keys_failed);
 read_attribute(io_errors);
 read_attribute(congested);
-read_attribute(cutoff_writeback);
-read_attribute(cutoff_writeback_sync);
+rw_attribute(cutoff_writeback);
+rw_attribute(cutoff_writeback_sync);
 rw_attribute(congested_read_threshold_us);
 rw_attribute(congested_write_threshold_us);
 
@@ -902,6 +902,8 @@ STORE(__bch_cache_set)
 	sysfs_strtoul_bool(copy_gc_enabled,	c->copy_gc_enabled);
 	sysfs_strtoul_bool(idle_max_writeback_rate,
 			   c->idle_max_writeback_rate_enabled);
+	sysfs_strtoul_clamp(cutoff_writeback, bch_cutoff_writeback, 1, 100);
+	sysfs_strtoul_clamp(cutoff_writeback_sync, bch_cutoff_writeback_sync, 1, 100);
 
 	/*
 	 * write gc_after_writeback here may overwrite an already set
-- 
2.17.1

