Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44173462F1C
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Nov 2021 09:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhK3JBb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Nov 2021 04:01:31 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:57442 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235089AbhK3JBb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Nov 2021 04:01:31 -0500
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2021 04:01:31 EST
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 4J3GDv1vwhz9vC8C
        for <linux-bcache@vger.kernel.org>; Tue, 30 Nov 2021 08:52:15 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wdwUbI3nSnzm for <linux-bcache@vger.kernel.org>;
        Tue, 30 Nov 2021 02:52:15 -0600 (CST)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 4J3GDt6ZVsz9vC7k
        for <linux-bcache@vger.kernel.org>; Tue, 30 Nov 2021 02:52:14 -0600 (CST)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p6.oit.umn.edu 4J3GDt6ZVsz9vC7k
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p6.oit.umn.edu 4J3GDt6ZVsz9vC7k
Received: by mail-pj1-f69.google.com with SMTP id r23-20020a17090a941700b001a74be6cf80so6589361pjo.2
        for <linux-bcache@vger.kernel.org>; Tue, 30 Nov 2021 00:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9fMCH0NKWt3molLrHA4oJZ0OiPJH79kluyM8NW1Juo=;
        b=cFFfjaZFN1GoVY96cCbHXCCcPpXrRofrjx9REKmLinJwH6Jdd7yVbD9Rsf1STazZua
         z8Yg+iscarQMfvNuc4TAG+psZURIDxZpaXXW4YG4Xp9om0OUh38bgJun/za43QKqcky8
         5bybTB5CZm25g6FhrXZwzDFmQHr5i0jYRh/846nSVnfV0XlWyR4UylZefiVRv9dxywsD
         UtziPp8cwHrXhjavRoaN1esnyL0MIwrD7a9o5rsk+znkQoXRTxoxVWtjVPUHE4k3IdiV
         +8ZDHFukr9hwTWUtIdh8A712lX1Wr9wtAXSEBNuFXTp12EBHJzJV/MwEzq5UY3sJigDw
         uieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9fMCH0NKWt3molLrHA4oJZ0OiPJH79kluyM8NW1Juo=;
        b=Z/aaX57Kkv1TCEtTkj0DHRXTHA+zBM4YMpdYWWMbrbpbGwYJtOduNhzx+4SmQPrrqd
         5f4bHCsIenGEhvsylM5s1Mob3e4MmLAoioH7A0t3IQqFMmVx5GU3AaboC1clbb/Vdg/a
         W5aEBe2X+bcPas1OZGzrTkTp9EstnGwo1hWnOfAmzv5l01fHvF+gJjZaZkRkqv2zkFUr
         5F/NoZKD/fvc50wL83CrmT5mB/Gu2VGOsLtwFWP9gSF5lKJ4AlQLTEKR2uXmPVDUX7Ts
         Q5hXauEMq5hdOTdGJnltKy+9AnZzzJ2EiQMRXgEkjJT67IxdzmBgmqGKqyQxXaUVenuY
         CaOQ==
X-Gm-Message-State: AOAM533QxSzxBfmsvVTZlbi+7tmj5RrTPEcDcABQWuS3QH9uN4kgL0nQ
        KKPD0VK3GVoyrSFHD91VkTy5FNk+ToqTgvovM8sX5roIcn28ABncPK5M2vc42igaOit7i9AO+nk
        zRlHkvoERF2bXx96st6OY0f9zI6K+
X-Received: by 2002:a05:6a00:1a04:b0:4a6:4384:2e5f with SMTP id g4-20020a056a001a0400b004a643842e5fmr43962070pfv.36.1638262334260;
        Tue, 30 Nov 2021 00:52:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzc/xABQRyGcSc35TzwobPSt4/vjPNihBOIqmq1/ibTgf7iYbomHvroaZ+E2hqCKqlaTZyIoQ==
X-Received: by 2002:a05:6a00:1a04:b0:4a6:4384:2e5f with SMTP id g4-20020a056a001a0400b004a643842e5fmr43962051pfv.36.1638262334041;
        Tue, 30 Nov 2021 00:52:14 -0800 (PST)
Received: from zqy787-GE5S.lan ([36.7.42.137])
        by smtp.gmail.com with ESMTPSA id j1sm20305982pfu.47.2021.11.30.00.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 00:52:13 -0800 (PST)
From:   Zhou Qingyang <zhou1615@umn.edu>
To:     zhou1615@umn.edu
Cc:     kjlu@umn.edu, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Hannes Reinecke <hare@suse.com>, Michael Lyle <mlyle@lyle.org>,
        Tang Junhui <tang.junhui@zte.com.cn>,
        Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bcache: Fix a NULL pointer dereference in detached_dev_do_request()
Date:   Tue, 30 Nov 2021 16:51:39 +0800
Message-Id: <20211130085139.74175-1-zhou1615@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In detached_dev_do_request(), the return value of kzalloc() is
assigned to ddip, and there is a dereference of it in
detached_dev_do_request(), which could lead to a NULL pointer
dereference on failure of kzalloc().

Fix this bug by adding a check of ddip. This patch imitates the
failure-handling logic in cached_dev_submit_bio().

Note that we found the fixing of the bug hard, as the return value of
the callers is void and we cannot pass an error status upstream.
Please adivce if there is a better way for fixing.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it might be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_BCACHE=m show no new warnings, and our static
analyzer no longer warns about this code.

Fixes:  bc082a55d25c ("bcache: fix inaccurate io state for detached bcache devices")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
---
 drivers/md/bcache/request.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index d15aae6c51c1..3a17925c734b 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1107,6 +1107,11 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	 * which would call closure_get(&dc->disk.cl)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
+	if (!ddip) {
+		bio->bi_status = BLK_STS_RESOURCE;
+		bio_endio(bio);
+		return;
+	}
 	ddip->d = d;
 	/* Count on the bcache device */
 	ddip->orig_bdev = orig_bdev;
-- 
2.25.1

