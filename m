Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04885739C1C
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 11:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjFVJGS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 05:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjFVJFV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 05:05:21 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CAB49C2
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jun 2023 01:58:22 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b515ec39feso12624235ad.0
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jun 2023 01:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687424260; x=1690016260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aRQUwtIbFrjRbKaWDWITc6Upds+hXxxlwcQqvFPvJow=;
        b=Kv6dWh2IIchnBu9RbCVLsx8HZLugRgYdolMOnFdVv/Mze68pcgFvadMFaompRsV/Ii
         Vr4ahAwXirWdfwADAjPFAtSTivwacduawKzyeKPVnp7cESQMTGYfaqAI7425tQvAdQ85
         8rLDDpZCwcAbH67+6k+hMmW8Fi1etqH6LYFHkuQfbD+ESFiwPmeSocm5kXqI50kDiSjf
         PCd9vDumWTECSSKSpOEWhL8aCyPGbcSxO0SaB85LOV7uPD9a5LVIfvAATYV0qgfKCSQQ
         J+7inf8lDO5dvyUSQTFKKOcNdRaAbUMX2WbzVCHQayCH8tZA09PfVWiof+vKchWmVnWN
         0e0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687424260; x=1690016260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aRQUwtIbFrjRbKaWDWITc6Upds+hXxxlwcQqvFPvJow=;
        b=HjmjF5Q8SDH0aykzBJA/aaeZteC8HD0hFz+nm7kcqU8Axkjmrih+q7kaYIgY+tL6j6
         qBEJSjEM4bYSIl6rOw51iVBV5Tcvf6W2oRijEcYjtQhYyRHBQkmXJelZoUZsOXxl1KeF
         xrPXSwss0+LCWTLtlINcj/bw1OFrxi8xREK9ohMY3XbHc2+ha3+4uu2p8Gef3J6V50EJ
         L4lwt1XQgRpjPhSTriXjRPZVkzg7eCsdB3DXhruVbcFQtPZgXsJVc1M7brA1nCIdREeG
         YiRU5VDwGk3z7W32YUNH+ihYwtoZ9/oUHBGIRX6KgQQ4v+Pnk4l1wmF54siHsRQwR9xg
         +JRA==
X-Gm-Message-State: AC+VfDxAjtxth+fkkn3x7Lt5ipECBVieMK0gorSOhrJ+VYu3yQFKXeF+
        dFzYHmJ0FV9luy5wqLa+NrM2cA==
X-Google-Smtp-Source: ACHHUZ4KKZ8AXrupsFYw18EsJWvGfL6qm7cyYV/rSPTKOdYWRQ8IhOkLOim7I9s7W96jDohmbJS9Lg==
X-Received: by 2002:a17:903:41d2:b0:1a6:cf4b:4d7d with SMTP id u18-20020a17090341d200b001a6cf4b4d7dmr21650808ple.2.1687424260203;
        Thu, 22 Jun 2023 01:57:40 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 01:57:39 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 27/29] mm: vmscan: hold write lock to reparent shrinker nr_deferred
Date:   Thu, 22 Jun 2023 16:53:33 +0800
Message-Id: <20230622085335.77010-28-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

For now, reparent_shrinker_deferred() is the only holder
of read lock of shrinker_rwsem. And it already holds the
global cgroup_mutex, so it will not be called in parallel.

Therefore, in order to convert shrinker_rwsem to shrinker_mutex
later, here we change to hold the write lock of shrinker_rwsem
to reparent.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 357a1f2ad690..0711b63e68d9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -433,7 +433,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_read(&shrinker_rwsem);
+	down_write(&shrinker_rwsem);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -442,7 +442,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 			atomic_long_add(nr, &parent_info->nr_deferred[i]);
 		}
 	}
-	up_read(&shrinker_rwsem);
+	up_write(&shrinker_rwsem);
 }
 
 static bool cgroup_reclaim(struct scan_control *sc)
-- 
2.30.2

