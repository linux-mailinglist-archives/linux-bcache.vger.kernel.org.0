Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E9410E8B5
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2019 11:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfLBKYe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Dec 2019 05:24:34 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36435 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfLBKYe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Dec 2019 05:24:34 -0500
Received: by mail-pg1-f194.google.com with SMTP id k13so18156711pgh.3;
        Mon, 02 Dec 2019 02:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m0LCE5hcVVGk8fjDfWm4sSuGTECQ8UothTBhXvlTHPM=;
        b=novKqp8HWeDTOaxtSE7iRnp+oxbOVTDKu5VeT7nuojFFq4Bja0+QGnvmpv8mMxF0lp
         CkdfBH7XWnDjZOgzL+Kpov4pkK53VNxDniXkeZEq6xTaau5HaS85SfIpSHxK/akRnYTN
         fiDUP8MSCTDw+m2YQZQMgwKC8tyJOVySc9qjLx/whf5c+XhT7D3eAZt6gP1Yp03sfEla
         h3n2g7lrWWlUZNBqq0HvK4tndbg+xuwLErgGNhniFb+l43lyACzQq/ktmkOOLpZgA5nn
         NzyV90EIzfCCg8GuVGCB6z4//8YEUroJVB2mv9d9bKe+lSQdG6I+kkpe0hlBVVZ/e5/X
         H07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m0LCE5hcVVGk8fjDfWm4sSuGTECQ8UothTBhXvlTHPM=;
        b=DOq0g4jvRkzB6VLecY1tE5LEW8NYx+DAueBQiZo4EoDQZnqKb6QxzKska+Iy8aphf+
         5VYoZgFHpeMzD9XD0WlXnKBL8OLfF0fIie5XT+a+l3h6PkTbY2KWU3ZbnD0Ji+O0fdf2
         4jJgilP4HRzJ7P+F23pNzQEpbyHVwe4prr7V5MCAHnv41Bxv9TNOUFirJVUoSAZZwUPa
         suafrPi+qGWmqyPbzTnz+hahaOpejAl6bvAyLqkOfJLo3tZSSJ9mfO8tOw0jCnI+KvUz
         I381Tm7+Zrd9ll8Vom4cK4EGH1PnR4qpH8dIORecX4fgZFc/r0odV8tno6tj94P6l6/W
         elXw==
X-Gm-Message-State: APjAAAWd9Jv/TeX2IC/l2EPGjqg9HA713ZmAyVGjV8wG6JSnutLcTQ1J
        ZdnFpENNJEvuTVayM5llvz8=
X-Google-Smtp-Source: APXvYqy/U6PuDC1PIAsN3CGJuP0GcaVjxkgA4tu43H+VJNkGysMwN5CXvF8uLZW/+yW7IQV7JO2JhA==
X-Received: by 2002:a63:cc05:: with SMTP id x5mr31319016pgf.141.1575282272237;
        Mon, 02 Dec 2019 02:24:32 -0800 (PST)
Received: from wangyang5-l1.corp.qihoo.net ([104.192.108.10])
        by smtp.gmail.com with ESMTPSA id w2sm34639796pgm.18.2019.12.02.02.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:24:31 -0800 (PST)
From:   kungf <wings.wyang@gmail.com>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, kungf <wings.wyang@gmail.com>
Subject: [PATCH] bcache: add REQ_FUA to avoid data lost in writeback mode
Date:   Mon,  2 Dec 2019 18:24:09 +0800
Message-Id: <20191202102409.3980-1-wings.wyang@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

data may lost when in the follow scene of writeback mode:
1. client write data1 to bcache
2. client fdatasync
3. bcache flush cache set and backing device
if now data1 was not writed back to backing, it was only guaranteed safe in cache.
4.then cache writeback data1 to backing with only REQ_OP_WRITE
So data1 was not guaranteed in non-volatile storage,  it may lost if  power interruption 

Signed-off-by: kungf <wings.wyang@gmail.com>
---
 drivers/md/bcache/writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4a40f9eadeaf..e5cecb60569e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -357,7 +357,7 @@ static void write_dirty(struct closure *cl)
 	 */
 	if (KEY_DIRTY(&w->key)) {
 		dirty_init(w);
-		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
+		bio_set_op_attrs(&io->bio, REQ_OP_WRITE | REQ_FUA, 0);
 		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 		bio_set_dev(&io->bio, io->dc->bdev);
 		io->bio.bi_end_io	= dirty_endio;
-- 
2.17.1

