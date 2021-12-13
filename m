Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11326473732
	for <lists+linux-bcache@lfdr.de>; Mon, 13 Dec 2021 23:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243454AbhLMWFG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 Dec 2021 17:05:06 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45666
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241323AbhLMWFG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Dec 2021 17:05:06 -0500
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 996A140037
        for <linux-bcache@vger.kernel.org>; Mon, 13 Dec 2021 22:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639433100;
        bh=4/2kvcMVzhKAHVGnbU0ch5jNa8PQowdBXu/wO7uxMoI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=lrvfw4Bl9bY4sicuwCFQK5xLVvg7prcXM5TfAYy+f0RmNqViVcCEx9lvw9TFBk8Qi
         24ssL/EUu+KjpI0FEjafOcBzL5hEf1mMms37myZ8UVNHwRPCQLgZf585p/7Dgagh2P
         pM9XQ4p5HSc0ge2cu1VgMm0OVTqP9BFrSw8yTdgvplnMEoghNnOqbpTdb5DwGp7xhm
         xJ9rIIDBTCAjGxVwZQ/lai37vP/K50Iq8BtIfndJJmy3Df1bgLXmOZF61h00/iP6Jy
         4LOeCffTXwIPdLSeMKhVGjU+dyustIj0q/XUSq0TdUcyEpMAwLjU5gN5USCCvg2e0j
         6ITnL7kYlmT7A==
Received: by mail-qv1-f70.google.com with SMTP id kj12-20020a056214528c00b003bde2e1df71so25193991qvb.18
        for <linux-bcache@vger.kernel.org>; Mon, 13 Dec 2021 14:05:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4/2kvcMVzhKAHVGnbU0ch5jNa8PQowdBXu/wO7uxMoI=;
        b=MOuhA5E7UXI4pdgW7BRuPqNTk7vBIsEB0p2uDwz82fKLanXyyBK9ry8/mIt2jhwdF5
         HFHh84CJaqWQFW/LTloCqlaFMqMKdeY3/9y5qNmpTLhCQ5pQHHJXjZ0ib1jWjFyoaKcF
         L4Me7vmC1YXUd0IKSRhfzMLhOIzHvBRAcDK1RXAQlGFf99hzqrfES9Txdso5rIdSZGpC
         ZP+68BniqaYbI3PJGyPNs/KCf92t2+MqgttvCwXX3N5Lg/n2SaD94/PjHVIFP/qi6wP0
         iJ02BCBGMPi+4jYehKsQGjg+4dk8CvDIK0Wo6wnp7ACzNzzEq3tJW+e8CNzV0pW734cC
         9pkg==
X-Gm-Message-State: AOAM532bdwZAGZLm/JedXva+UV8ihNDlZVT6Lc/0CkKGWRCo0pqt3f3U
        /+1h6FUrBW+jHpMRG5/OwjJFbvlb3zek2Jssdt1m8J6wOHgwF5UOMqbrRW2+fFPVZGm1F/CmyxC
        CyxQNQXpPRv7maHigrrpadj5iH1YcadgQwEI5++UzSQ==
X-Received: by 2002:a05:622a:95:: with SMTP id o21mr1389687qtw.386.1639433099450;
        Mon, 13 Dec 2021 14:04:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnmL6gGpfpwpgcF0Fln/ByzcaaQmOwJdJB29tHicQXH0F70/p58gxNm91m6afGG8TNs3e/cg==
X-Received: by 2002:a05:622a:95:: with SMTP id o21mr1389655qtw.386.1639433099255;
        Mon, 13 Dec 2021 14:04:59 -0800 (PST)
Received: from mfo-t470.. ([2804:14c:4e1:8732:aee6:69de:6c5c:74a2])
        by smtp.gmail.com with ESMTPSA id n13sm7178252qkp.19.2021.12.13.14.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 14:04:58 -0800 (PST)
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
To:     kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, mfo@canonical.com,
        nkshirsagar@gmail.com
Subject: Re: bcache-register hang after reboot
Date:   Mon, 13 Dec 2021 19:04:55 -0300
Message-Id: <20211213220455.1633987-1-mfo@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <YY/+YDSjdZPma3oT@moria.home.lan>
References: <YY/+YDSjdZPma3oT@moria.home.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hey Kent and Coly,

It turns out that, at least for the disk image that reproduces the issue,
the closure from bch_btree_set_root() to bch_journal_meta() doesn't make
a difference; the stall is in bch_journal() -> journal_wait_for_write().

So the previous suggestion to skip bch_journal_meta() altogether works,
to get things going.. of course, checking for journal replay/full case.

What do you think of this patch?

It simply checks the conditions in run_cache_set() for bch_journal_replay().
(it starts w/ unlikely(!CACHE_SET_RUNNING) to quickly get to the usual case,
and apparently has an extra strict check for !gc_thread, just in case. 
And it is journal_full() only, as the !journal_full() case in journal_wait_
for_write() seems to be handled via another function per the comment.)

This works w/ the disk image here.

Thanks!
Mauricio

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 72abe5cf4b12..bedeffc3ae28 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2477,9 +2477,6 @@ int bch_btree_insert(struct cache_set *c, struct keylist *keys,
 void bch_btree_set_root(struct btree *b)
 {
 	unsigned int i;
-	struct closure cl;
-
-	closure_init_stack(&cl);
 
 	trace_bcache_btree_set_root(b);
 
@@ -2494,8 +2491,18 @@ void bch_btree_set_root(struct btree *b)
 
 	b->c->root = b;
 
-	bch_journal_meta(b->c, &cl);
-	closure_sync(&cl);
+	/* Don't journal during replay if journal is full (prevents deadlock) */
+	if (unlikely(!test_bit(CACHE_SET_RUNNING, &b->c->flags)) &&
+	    CACHE_SYNC(&b->c->cache->sb) && b->c->gc_thread == NULL &&
+	    journal_full(&b->c->journal)) {
+		pr_info("Not journaling new root (replay with full journal)\n");
+	} else {
+		struct closure cl;
+
+		closure_init_stack(&cl);
+		bch_journal_meta(b->c, &cl);
+		closure_sync(&cl);
+	}
 }
 
 /* Map across nodes or keys */
