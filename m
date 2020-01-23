Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB0D7146F03
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Jan 2020 18:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgAWRCy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 23 Jan 2020 12:02:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:51762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729396AbgAWRCy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:02:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7E02AAD73;
        Thu, 23 Jan 2020 17:02:52 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 10/17] lib: crc64: include <linux/crc64.h> for 'crc64_be'
Date:   Fri, 24 Jan 2020 01:01:35 +0800
Message-Id: <20200123170142.98974-11-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>

The crc64_be() is declared in <linux/crc64.h> so include
this where the symbol is defined to avoid the following
warning:

lib/crc64.c:43:12: warning: symbol 'crc64_be' was not declared. Should it be static?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 lib/crc64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/crc64.c b/lib/crc64.c
index 0ef8ae6ac047..f8928ce28280 100644
--- a/lib/crc64.c
+++ b/lib/crc64.c
@@ -28,6 +28,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/crc64.h>
 #include "crc64table.h"
 
 MODULE_DESCRIPTION("CRC64 calculations");
-- 
2.16.4

