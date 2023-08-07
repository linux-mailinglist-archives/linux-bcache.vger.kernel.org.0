Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E51877221A
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Aug 2023 13:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjHGL27 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Aug 2023 07:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbjHGL1Z (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Aug 2023 07:27:25 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37424482
        for <linux-bcache@vger.kernel.org>; Mon,  7 Aug 2023 04:24:12 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-563393b63dbso675049eaf.1
        for <linux-bcache@vger.kernel.org>; Mon, 07 Aug 2023 04:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691407374; x=1692012174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a0ijFA9s9bGVMHT4vLgTYS12L8yx2Rc7o6TjM9ZoJx8=;
        b=FECfOfj72ycZwm7hdlUhHhM3+/bSz7INVBKp7+8j9owbOu4j/iXbHy0pG+YExVe3+6
         Aelt7yehqWzNi7DSWuMehcpzFiN19xM709rQ/Wq3kmWL+t2+4RSGWdxXQPa4osGoiq9L
         SrBgW7Hkz6f5ldGhtqHqifLlB8MjXmVxTVOqV9b8DqoREcf6McPu58tokxCPaKeK1+iV
         YgfpjJxPVPTFYY7Ml7WDt5mRs3FviHfelm35q1JoKw5gVEjBHbMCzPj5g9YzimtGmMH1
         hzPIAi/taZG6upwrGHjQIXVyACDnYEaX/75siNbJTLTa3Azx0WFIRd6XwOi6bhf/BzLH
         jDNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691407374; x=1692012174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a0ijFA9s9bGVMHT4vLgTYS12L8yx2Rc7o6TjM9ZoJx8=;
        b=MvbfzLEW1Aj5PGnaw80A+WbUt8K7GCuXMf54aO95fOclv6cMvyLWKNp552h/a1qEJ4
         EmRlpqtlCMoNHWvfUbR7moAGD7NXFlSLSnwWxY/k4Quhf/gd/5fKa8/b3NGh7Sip4mWL
         w9BnktsfoB8YakRUVz8x4ENggjsdrfE+CBmemSn2n2hf3CiYRzfmAGWUIVgQn6W2oRNO
         /PcQ2NMFVq/LPGZ1kkvMZLvTeZwodqJygzqrtFK44lQJ4Ktv7PWhUXZa0DEilISibPQC
         tK+vB8XHBbiFlHfXqlUHI1CHNRxmvmZ9CZ/JBuI7p+68BTfogFp5jOUusQ7hn5iK3zSp
         L6bw==
X-Gm-Message-State: AOJu0YxkBKdp4ZGYrzoa5Z0XgtALZl24KEHrgm7YX9rO1ZljS+psq85Y
        S/NZK7eEypIHg6pAqQ/E/fTGRnzfGAoStytFFjw=
X-Google-Smtp-Source: AGHT+IELWLhV4Bj40lkko/D2F7gtSRcHKPclt9k8JlXsq8dyT7OdoG/0VZRRAUzfMJnehzLNwTS/oA==
X-Received: by 2002:a17:90a:2909:b0:269:5bf7:d79c with SMTP id g9-20020a17090a290900b002695bf7d79cmr2214416pjd.1.1691406841328;
        Mon, 07 Aug 2023 04:14:01 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:14:01 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev, simon.horman@corigine.com,
        dlemoal@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 19/48] rcu: dynamically allocate the rcu-kfree shrinker
Date:   Mon,  7 Aug 2023 19:09:07 +0800
Message-Id: <20230807110936.21819-20-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use new APIs to dynamically allocate the rcu-kfree shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 kernel/rcu/tree.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7c79480bfaa0..3b20fc46c514 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3449,13 +3449,6 @@ kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	return freed == 0 ? SHRINK_STOP : freed;
 }
 
-static struct shrinker kfree_rcu_shrinker = {
-	.count_objects = kfree_rcu_shrink_count,
-	.scan_objects = kfree_rcu_shrink_scan,
-	.batch = 0,
-	.seeks = DEFAULT_SEEKS,
-};
-
 void __init kfree_rcu_scheduler_running(void)
 {
 	int cpu;
@@ -4931,6 +4924,7 @@ static void __init kfree_rcu_batch_init(void)
 {
 	int cpu;
 	int i, j;
+	struct shrinker *kfree_rcu_shrinker;
 
 	/* Clamp it to [0:100] seconds interval. */
 	if (rcu_delay_page_cache_fill_msec < 0 ||
@@ -4962,8 +4956,18 @@ static void __init kfree_rcu_batch_init(void)
 		INIT_DELAYED_WORK(&krcp->page_cache_work, fill_page_cache_func);
 		krcp->initialized = true;
 	}
-	if (register_shrinker(&kfree_rcu_shrinker, "rcu-kfree"))
-		pr_err("Failed to register kfree_rcu() shrinker!\n");
+
+	kfree_rcu_shrinker = shrinker_alloc(0, "rcu-kfree");
+	if (!kfree_rcu_shrinker) {
+		pr_err("Failed to allocate kfree_rcu() shrinker!\n");
+		return;
+	}
+
+	kfree_rcu_shrinker->count_objects = kfree_rcu_shrink_count;
+	kfree_rcu_shrinker->scan_objects = kfree_rcu_shrink_scan;
+	kfree_rcu_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(kfree_rcu_shrinker);
 }
 
 void __init rcu_init(void)
-- 
2.30.2

