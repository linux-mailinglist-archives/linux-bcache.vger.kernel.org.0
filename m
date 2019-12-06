Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56C8114DC9
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 09:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfLFI4D (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 03:56:03 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41543 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfLFI4D (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 03:56:03 -0500
Received: by mail-pg1-f193.google.com with SMTP id x8so2984103pgk.8;
        Fri, 06 Dec 2019 00:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9koV2GOa9gLGpNjBXrPkm6jAgXDZ7fPOfYz+Zz14/JY=;
        b=Nl2bmJtIJtm7g/qfRfP2sMux0HRYnpB1a4dCOqegUu1/NefVCr+qpKLgBZw/0hfbg9
         oPxVst0rB161729WTf6M0Cx7/jaTQBbWGqD/br1FvXjCgRmw3ZD8Wmf9VR83gEN8wUDF
         7mGhTr9BRW6GAzD4KiBHoDIvV6hDZk7gssM7HWRZNAsH4z+ckroDPELf+LgoiLcHBVnh
         A+4of2uXALnDzAL2V78zHBP5QFBulJJT5sKoulDXbfZh2oVZRQSu1k5NYTO8qEHfIPad
         am/RH2R6XRyc11cJvuy/O+Pz+/SGTHwb0xyKMLahOseX9wJ0XiZDoD4Q59Q93MwhB5Mp
         4YBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9koV2GOa9gLGpNjBXrPkm6jAgXDZ7fPOfYz+Zz14/JY=;
        b=aXoOyMvlXHwSWmvbIeiKBhh2zsZox+cKo3kv1slCH2++xz0d/Z2m+3YS9LkTZgP07M
         Hh7i+IbLE97QZUCBNlw0Qst6qGykzvMF6wEixE/uUxNIEcMYiXealXATPLaZOq0y2XMy
         SVlDCVwpaeInRLVPY+4KgsvcoDl7jC0xHzEEdid08iK7rNKOJtIuWCd8VzWb3dUrkb2m
         OFq7tIpNiUeQrwibIDk4SHN3u1i/LnDElhhQRLXvTjWwBsP1M5FQXbHTiWoHzEPAsGRr
         NOfqAGK03/DGBLWIYQP2h5aC6S50DkW9ZzFMevcNooqhYsTNA7lnI1TwX1Npl8NKSUPT
         wRQQ==
X-Gm-Message-State: APjAAAWZiXj7QvwQ4Lv1h+o8X/g+SyBbw9asvFc5dvEpAMCA4aHEkjaR
        RtPwO5x4+P6pL+R9BFJXZ8Y=
X-Google-Smtp-Source: APXvYqyxFJT3/J0rUrx1rEE7oCoNjM2gEqBt4TTdM++7dgbl1v8U6QBaq8kMezCRmszfFt7wMJZhfA==
X-Received: by 2002:a63:d24b:: with SMTP id t11mr2275806pgi.414.1575622562555;
        Fri, 06 Dec 2019 00:56:02 -0800 (PST)
Received: from workstation.localdomain ([170.178.178.163])
        by smtp.gmail.com with ESMTPSA id u18sm14520599pgi.44.2019.12.06.00.56.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Dec 2019 00:56:02 -0800 (PST)
From:   Liang Chen <liangchen.linux@gmail.com>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH 1/2] [PATCH] bcache: cached_dev_free needs to put the sb page
Date:   Fri,  6 Dec 2019 16:55:42 +0800
Message-Id: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.7.5
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Same as cache device, the buffer page needs to be put while
freeing cached_dev.  Otherwise a page would be leaked every
time a cached_dev is stopped.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/md/bcache/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 77e9869345e7..a573ce1d85aa 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1275,6 +1275,9 @@ static void cached_dev_free(struct closure *cl)
 
 	mutex_unlock(&bch_register_lock);
 
+	if (dc->sb_bio.bi_inline_vecs[0].bv_page)
+		put_page(bio_first_page_all(&dc->sb_bio));
+
 	if (!IS_ERR_OR_NULL(dc->bdev))
 		blkdev_put(dc->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 
-- 
2.17.0

