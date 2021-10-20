Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD422434DFA
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Oct 2021 16:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhJTOkk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Oct 2021 10:40:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55032 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhJTOkj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Oct 2021 10:40:39 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2711A1FD4B;
        Wed, 20 Oct 2021 14:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634740704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XLHgOPpvKx8Sv+67miH/xFAVUSD/7yswrSA+Xxv5Xy4=;
        b=H/axAPg6x+5tnz4XJf8nWRnFNOjrCAZxUaP3AddGaIw4hTMVn5owdIlEkiMDaMtRbMmnac
        U5RPxFoODgUn277q4574dG41TLFzmPE4y5Nrv6aEdouxkDQOoIw4NB6aCg5gcmVvVKf2qt
        7g3UbpVIerMJ1TfnqQP30hRlz7Dveh0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634740704;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XLHgOPpvKx8Sv+67miH/xFAVUSD/7yswrSA+Xxv5Xy4=;
        b=DBmdPpUxwiCz8sXpy46V20oZf6P/rhR61imoPk2s6pO0/MQ/I7au/147rge88i9ymDirzH
        Dy9tBXbqAxLXSFBQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 8EB05A3B96;
        Wed, 20 Oct 2021 14:38:21 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Ding Senjie <dingsenjie@yulong.com>,
        Hannes Reinecke <hare@suse.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 1/8] md: bcache: Fix spelling of 'acquire'
Date:   Wed, 20 Oct 2021 22:38:05 +0800
Message-Id: <20211020143812.6403-2-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020143812.6403-1-colyli@suse.de>
References: <20211020143812.6403-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Ding Senjie <dingsenjie@yulong.com>

acqurie -> acquire

Signed-off-by: Ding Senjie <dingsenjie@yulong.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 185246a0d855..ab64b7762b6e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2746,7 +2746,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		 * The reason bch_register_lock is not held to call
 		 * bch_cache_set_stop() and bcache_device_stop() is to
 		 * avoid potential deadlock during reboot, because cache
-		 * set or bcache device stopping process will acqurie
+		 * set or bcache device stopping process will acquire
 		 * bch_register_lock too.
 		 *
 		 * We are safe here because bcache_is_reboot sets to
-- 
2.31.1

