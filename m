Return-Path: <linux-bcache+bounces-210-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB588246A2
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 17:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B37941F2557D
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 16:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D09E25112;
	Thu,  4 Jan 2024 16:50:34 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1786525577;
	Thu,  4 Jan 2024 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A65E1007;
	Thu,  4 Jan 2024 08:51:18 -0800 (PST)
Received: from e126645.arm.com (unknown [10.57.76.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DBA663F64C;
	Thu,  4 Jan 2024 08:50:28 -0800 (PST)
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
	Jani Nikula <jani.nikula@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-bcache@vger.kernel.org
Subject: [PATCH v2 1/3] list: Add hlist_count_nodes()
Date: Thu,  4 Jan 2024 17:49:33 +0100
Message-Id: <20240104164937.424320-2-pierre.gondois@arm.com>
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

Add a function to count nodes in a hlist. hlist_count_nodes()
is similar to list_count_nodes().

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 include/linux/list.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index 1837caedf723..0f1b1d4a2e2e 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -1175,4 +1175,19 @@ static inline void hlist_move_list(struct hlist_head *old,
 	     pos && ({ n = pos->member.next; 1; });			\
 	     pos = hlist_entry_safe(n, typeof(*pos), member))
 
+/**
+ * hlist_count_nodes - count nodes in the hlist
+ * @head:	the head for your hlist.
+ */
+static inline size_t hlist_count_nodes(struct hlist_head *head)
+{
+	struct hlist_node *pos;
+	size_t count = 0;
+
+	hlist_for_each(pos, head)
+		count++;
+
+	return count;
+}
+
 #endif
-- 
2.25.1


