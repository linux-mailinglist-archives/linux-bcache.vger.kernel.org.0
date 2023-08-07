Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A59771FF5
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Aug 2023 13:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjHGLNN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Aug 2023 07:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbjHGLMz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Aug 2023 07:12:55 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F13F199E
        for <linux-bcache@vger.kernel.org>; Mon,  7 Aug 2023 04:12:03 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-2680edb9767so930156a91.0
        for <linux-bcache@vger.kernel.org>; Mon, 07 Aug 2023 04:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691406698; x=1692011498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bO4yc6b0222dRNj48HoFyPuU9QjRVolFKKVhhMGpLKw=;
        b=V+0c3qPhJ3OvHdRK0zt0jjicV8eIk4mcEJBfZa3lpQkwu54lWNVPIEieS4PtRydxoC
         SOQosWaNmtA5ijvBvBTHzjmbD0d0j9BAeGMmaW/jH6uvD6Ej2n/njXM3uIqGlzrBkh1f
         4pNHqPhVUKAnLp7tAzH1vcGObvmfuMOiL8NrO6wDjhRhzYUa1svLTbbXU3r4juxNC7M+
         zvZ3SM7T/9w0Je9dQGJ4Z6qlkuAYn1bir+6JxlC1Qr6arztdDyFiMoqBolNxM3VBbd9i
         jsX4xXrnwmvTP/fkwCWNcOiK6G4rP96fjoeNSyiOnE04LmSKfInS+5dfsRm42DUoM8bY
         LffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691406698; x=1692011498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bO4yc6b0222dRNj48HoFyPuU9QjRVolFKKVhhMGpLKw=;
        b=hP8R6svwIuvTFLf1dbCBtSJh6kSCPpdGUmcw+YyxUicnzDg/RZtpC0jTKoqOWROBAr
         h3GYrKWIvGeRuwIWShqx0hJ3vPbU8k0TH6euuBfLmSPHrfuADrpUjL3dsEx1nEo402Cl
         FOcvzhcMdtpIgvqGCXAmTrip1Yoy86w9pwERnI+hjV0VVnmfnr/IIOeO7ofErd2Z27cx
         ff+NF5k3JTgt0cX0ZbeU2OGtbLYWD4CtRKZzYsWLaOtOD5WTz7oMYkD7m36f1dMQPEEv
         GiySJYGS4ilTRFUKD/M82fiHf/Iby3ubyFNfK1NHxEU6zUCWeKA+vRGg5kbQ5BMEfxJu
         woJQ==
X-Gm-Message-State: ABy/qLZKFaxdMOBVJ0B4Xg4fcDmnq5fWXtwXzCTDw68o3wcGNrJ+W/hF
        UcX08Hvx4prb2ygV/YTA+z2CRQ==
X-Google-Smtp-Source: APBJJlHTPEiI4d70NxX2nHst3XkAfiDRggXx1NmGRpA10Zf8iDezZWW8ih32EzxQIqpHPiYHvUOM5w==
X-Received: by 2002:a17:90a:1f83:b0:268:3dc6:f0c5 with SMTP id x3-20020a17090a1f8300b002683dc6f0c5mr25027705pja.0.1691406698603;
        Mon, 07 Aug 2023 04:11:38 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:11:38 -0700 (PDT)
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
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 08/48] xenbus/backend: dynamically allocate the xen-backend shrinker
Date:   Mon,  7 Aug 2023 19:08:56 +0800
Message-Id: <20230807110936.21819-9-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use new APIs to dynamically allocate the xen-backend shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/xen/xenbus/xenbus_probe_backend.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
index da96c260e26b..929c41a5ccee 100644
--- a/drivers/xen/xenbus/xenbus_probe_backend.c
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -284,13 +284,9 @@ static unsigned long backend_shrink_memory_count(struct shrinker *shrinker,
 	return 0;
 }
 
-static struct shrinker backend_memory_shrinker = {
-	.count_objects = backend_shrink_memory_count,
-	.seeks = DEFAULT_SEEKS,
-};
-
 static int __init xenbus_probe_backend_init(void)
 {
+	struct shrinker *backend_memory_shrinker;
 	static struct notifier_block xenstore_notifier = {
 		.notifier_call = backend_probe_and_watch
 	};
@@ -305,8 +301,16 @@ static int __init xenbus_probe_backend_init(void)
 
 	register_xenstore_notifier(&xenstore_notifier);
 
-	if (register_shrinker(&backend_memory_shrinker, "xen-backend"))
-		pr_warn("shrinker registration failed\n");
+	backend_memory_shrinker = shrinker_alloc(0, "xen-backend");
+	if (!backend_memory_shrinker) {
+		pr_warn("shrinker allocation failed\n");
+		return 0;
+	}
+
+	backend_memory_shrinker->count_objects = backend_shrink_memory_count;
+	backend_memory_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(backend_memory_shrinker);
 
 	return 0;
 }
-- 
2.30.2

