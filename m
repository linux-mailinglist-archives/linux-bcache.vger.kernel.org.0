Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995545A6F97
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Aug 2022 23:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiH3VuC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Aug 2022 17:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiH3Vth (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Aug 2022 17:49:37 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589F29019A
        for <linux-bcache@vger.kernel.org>; Tue, 30 Aug 2022 14:49:35 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3328a211611so187653637b3.5
        for <linux-bcache@vger.kernel.org>; Tue, 30 Aug 2022 14:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=Ximx3byfJ7rLtdPEIh1Ra0raz9MzgSTr/ga3ge5UvWM=;
        b=hlMw9ssXTclldlCaHPrcXJ+C8bd3xApn5Llhx/6gZpRfRlRJOwhqWghtr5RVB1LK2v
         8FfTzwl4OCrCjFuadtzRuPxbLUjQJudmMLjVKcB1W8L4nbh23VnBIJLeDBpv1hunXsFS
         TNZP/OkUwJBjRdLHnTFXsfbD3FCLleefIIXeH80z2Nq7UmGRffrhNJtzi3K0o37plX80
         MxuLJZry+KmCa87qIRicDj7F3K2/cxyGqrCNJyg48FflYe+16BIsOuCNrNLVMYU6qqtM
         jxbTTAqnCt+yOzPfECe6hBLshpNDmGjFaoiWgb1ccH/WG7XlQYWhlthKRprfEZxNn5xs
         7PgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=Ximx3byfJ7rLtdPEIh1Ra0raz9MzgSTr/ga3ge5UvWM=;
        b=3K1LuY6hq2xhUtN4xi0KeJ1uFklvnRwdBaRoYHjxLznP6HHzz/0nywWd/azlRPOvSJ
         n95z6I7TCoYI8pjNdEbw9Pi8HzgL81pWcsNm7dxlfukG0YK8N9U8vhOX6Du123xSdSeH
         SQQnCvJ1caCoAB+Tw1B1xs7v29GGHWjDzQ90p30gAkbZlmmLQphQewyILLQAjrOp9LQX
         KegYzU0omIP+kv/KV1PHJwyJa7yktpHAe7+7Mbv9s85RPELr25ozXtm3cH/ms4ZGDEO2
         FvCi2yoJo82BLyOZbsZ8KOGzAahUwUNe1g7rsKsYe8rVD2qwW8mpXX2TDQKa6FsOhz0g
         XFsg==
X-Gm-Message-State: ACgBeo0BswAZCQk9X32TIz6mB9uWHaW32ddtpv9G/eGCdnE+pOHR5XtL
        S+6qeDJIO7rj2L0JBd8mBdPLnQY4DUY=
X-Google-Smtp-Source: AA6agR7neVKTaIOQpaQTJJtMxLoXgZYEqvCUk9V+fUBv2iEO9EJWDyjyjmM2UWOPn+DCBvrBJ11meMcGOpo=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a0d:d98c:0:b0:33d:c482:9714 with SMTP id
 b134-20020a0dd98c000000b0033dc4829714mr15776751ywe.415.1661896174717; Tue, 30
 Aug 2022 14:49:34 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:48:53 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-5-surenb@google.com>
Subject: [RFC PATCH 04/30] scripts/kallysms: Always include __start and __stop symbols
From:   Suren Baghdasaryan <surenb@google.com>
To:     akpm@linux-foundation.org
Cc:     kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de,
        dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com,
        void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, peterx@redhat.com, david@redhat.com,
        axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org,
        nathan@kernel.org, changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        elver@google.com, dvyukov@google.com, shakeelb@google.com,
        songmuchun@bytedance.com, arnd@arndb.de, jbaron@akamai.com,
        rientjes@google.com, minchan@google.com, kaleshsingh@google.com,
        surenb@google.com, kernel-team@android.com, linux-mm@kvack.org,
        iommu@lists.linux.dev, kasan-dev@googlegroups.com,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Kent Overstreet <kent.overstreet@linux.dev>

These symbols are used to denote section boundaries: by always including
them we can unify loading sections from modules with loading built-in
sections, which leads to some significant cleanup.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 scripts/kallsyms.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index f18e6dfc68c5..3d51639a595d 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -263,6 +263,11 @@ static int symbol_in_range(const struct sym_entry *s,
 	return 0;
 }
 
+static bool string_starts_with(const char *s, const char *prefix)
+{
+	return strncmp(s, prefix, strlen(prefix)) == 0;
+}
+
 static int symbol_valid(const struct sym_entry *s)
 {
 	const char *name = sym_name(s);
@@ -270,6 +275,14 @@ static int symbol_valid(const struct sym_entry *s)
 	/* if --all-symbols is not specified, then symbols outside the text
 	 * and inittext sections are discarded */
 	if (!all_symbols) {
+		/*
+		 * Symbols starting with __start and __stop are used to denote
+		 * section boundaries, and should always be included:
+		 */
+		if (string_starts_with(name, "__start_") ||
+		    string_starts_with(name, "__stop_"))
+			return 1;
+
 		if (symbol_in_range(s, text_ranges,
 				    ARRAY_SIZE(text_ranges)) == 0)
 			return 0;
-- 
2.37.2.672.g94769d06f0-goog

