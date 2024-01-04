Return-Path: <linux-bcache+bounces-211-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FC08246A5
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 17:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 881CA1C2259F
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 16:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287082511D;
	Thu,  4 Jan 2024 16:50:41 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5351288D5;
	Thu,  4 Jan 2024 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BA391007;
	Thu,  4 Jan 2024 08:51:25 -0800 (PST)
Received: from e126645.arm.com (unknown [10.57.76.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 310D83F64C;
	Thu,  4 Jan 2024 08:50:35 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Pierre Gondois <pierre.gondois@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Martijn Coenen <maco@android.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Coly Li <colyli@suse.de>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Marco Elver <elver@google.com>,
	Kees Cook <keescook@chromium.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-bcache@vger.kernel.org
Subject: [PATCH v2 2/3] binder: Use of hlist_count_nodes()
Date: Thu,  4 Jan 2024 17:49:34 +0100
Message-Id: <20240104164937.424320-3-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240104164937.424320-1-pierre.gondois@arm.com>
References: <20240104164937.424320-1-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make use of the newly added hlist_count_nodes().

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 drivers/android/binder.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 92128aae2d06..f9ca4d58d825 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6077,9 +6077,7 @@ static void print_binder_node_nilocked(struct seq_file *m,
 	struct binder_work *w;
 	int count;
 
-	count = 0;
-	hlist_for_each_entry(ref, &node->refs, node_entry)
-		count++;
+	count = hlist_count_nodes(&node->refs);
 
 	seq_printf(m, "  node %d: u%016llx c%016llx hs %d hw %d ls %d lw %d is %d iw %d tr %d",
 		   node->debug_id, (u64)node->ptr, (u64)node->cookie,
-- 
2.25.1


