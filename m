Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB8C2465F5
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 14:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgHQMGR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 08:06:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:53432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgHQMGQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 08:06:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A02B6AEDA
        for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2020 12:06:40 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 3/8] bcache-tools: list.h: only define offsetof() when it is undefined
Date:   Mon, 17 Aug 2020 20:05:53 +0800
Message-Id: <20200817120558.4491-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817120558.4491-1-colyli@suse.de>
References: <20200817120558.4491-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

For new gcc headers, offsetof() is defined, the definition in list.h
will be warned as redefined.

This patch checks whether offsetof() is defined, and only defines local
version of offsetof() when it is not defined by gcc headers.

Signed-off-by: Coly Li <colyli@suse.de>
---
 list.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/list.h b/list.h
index 55d2bb4..458281d 100644
--- a/list.h
+++ b/list.h
@@ -25,10 +25,12 @@
  */
 /*@{*/
 
+#ifndef offsetof
 /**
  * Get offset of a member
  */
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif /* offsetof*/
 
 /**
  * Casts a member of a structure out to the containing structure
-- 
2.26.2

