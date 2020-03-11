Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A710E181241
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Mar 2020 08:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgCKHqA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Mar 2020 03:46:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:49980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKHqA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Mar 2020 03:46:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 50CD0ABCF;
        Wed, 11 Mar 2020 07:45:59 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Subject: [PATCH] bcache: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 08:45:58 +0100
Message-Id: <20200311074558.8517-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/md/bcache/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 3470fae4eabc..323276994aab 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -154,7 +154,7 @@ static ssize_t bch_snprint_string_list(char *buf,
 	size_t i;
 
 	for (i = 0; list[i]; i++)
-		out += snprintf(out, buf + size - out,
+		out += scnprintf(out, buf + size - out,
 				i == selected ? "[%s] " : "%s ", list[i]);
 
 	out[-1] = '\n';
-- 
2.16.4

