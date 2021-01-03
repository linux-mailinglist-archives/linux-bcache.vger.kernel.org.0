Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9715A2E8D1D
	for <lists+linux-bcache@lfdr.de>; Sun,  3 Jan 2021 17:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbhACQZJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 3 Jan 2021 11:25:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:35466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbhACQZJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 3 Jan 2021 11:25:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C92E7AF2C;
        Sun,  3 Jan 2021 16:24:27 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 3/3] bcache-tools: improve column alignment for "bcache show -m" output
Date:   Mon,  4 Jan 2021 00:24:13 +0800
Message-Id: <20210103162413.16895-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103162413.16895-1-colyli@suse.de>
References: <20210103162413.16895-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch improves the output column alignment for command
"bcache show -m". The changes are adding missing '\t' in printf
format strings.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/bcache.c b/bcache.c
index a0c5a67..234702b 100644
--- a/bcache.c
+++ b/bcache.c
@@ -195,7 +195,7 @@ int show_bdevs_detail(void)
 		fprintf(stderr, "Failed to list devices\n");
 		return ret;
 	}
-	printf("Name\t\tUuid\t\t\t\t\tCset_Uuid\t\t\t\tType\t\tState");
+	printf("Name\t\tUuid\t\t\t\t\tCset_Uuid\t\t\t\tType\t\t\tState");
 	printf("\t\t\tBname\t\tAttachToDev\tAttachToCset\n");
 	list_for_each_entry_safe(devs, n, &head, dev_list) {
 		printf("%s\t%s\t%s\t%lu", devs->name, devs->uuid,
@@ -217,7 +217,7 @@ int show_bdevs_detail(void)
 			printf(" (unknown)");
 			break;
 		}
-		printf("\t%-16s", devs->state);
+		printf("\t\t%-16s", devs->state);
 		printf("\t%-16s", devs->bname);
 		char attachdev[30];
 
-- 
2.26.2

