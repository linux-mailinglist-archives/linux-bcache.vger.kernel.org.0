Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C811E380E
	for <lists+linux-bcache@lfdr.de>; Wed, 27 May 2020 07:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbgE0FZK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 May 2020 01:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbgE0FZI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 01:25:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABF9C03E96E;
        Tue, 26 May 2020 22:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TB9a5RlSCttsRGqQbKXaUpDsmIDKmbhQMWP6LpH5XS4=; b=HgOzNOGAvq1hieB8BGbaYM8Yd6
        OtocAuujspm6nkP05lUCMyukmzw/shOAkGR7H6vwElNxY37f5Gf6FH74JCcPV0KXohlfK46c5CIgq
        uKVpylnDhN13Tfwbx+8sF3cFuxHddwTW4sfegH7VWgZTbI3FlQh0trOMNHvm8ki30lCUyYaGnLCl9
        MsfPEcsFZXBs3k0ckvvXDZ647AgGZTPg7G83k4yVSoZ97ChO88vK5GMnthTVY5zd0qyih6qBW39zM
        +J5YSkq2cRdoLxs4Af8aG+/+nZJwGO5OCweoM1adeVpWWaTOk7YX6pdcaCtyhmBG59XLnYknz5mbr
        PtQs+nWA==;
Received: from [2001:4bb8:18c:5da7:8164:affc:3c20:853d] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdoYq-000141-Dn; Wed, 27 May 2020 05:25:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] block: use __this_cpu_add() instead of access by smp_processor_id()
Date:   Wed, 27 May 2020 07:24:18 +0200
Message-Id: <20200527052419.403583-16-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
References: <20200527052419.403583-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Most architectures have fast path to access percpu for current cpu.
The required preempt_disable() is provided by part_stat_lock().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
[hch: rebased]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/part_stat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/part_stat.h b/include/linux/part_stat.h
index a6b0938ce82e9..24125778ef3ec 100644
--- a/include/linux/part_stat.h
+++ b/include/linux/part_stat.h
@@ -54,7 +54,7 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 	 part_stat_read(part, field[STAT_DISCARD]))
 
 #define __part_stat_add(part, field, addnd)				\
-	(part_stat_get(part, field) += (addnd))
+	__this_cpu_add((part)->dkstats->field, addnd)
 
 #define part_stat_add(part, field, addnd)	do {			\
 	__part_stat_add((part), field, addnd);				\
-- 
2.26.2

