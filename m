Return-Path: <linux-bcache+bounces-212-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 422468246A7
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 17:51:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69DD31C224C5
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 16:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2FE25549;
	Thu,  4 Jan 2024 16:50:48 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA8B25569;
	Thu,  4 Jan 2024 16:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 12DDE1007;
	Thu,  4 Jan 2024 08:51:32 -0800 (PST)
Received: from e126645.arm.com (unknown [10.57.76.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 412BC3F64C;
	Thu,  4 Jan 2024 08:50:42 -0800 (PST)
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
Subject: [PATCH v2 3/3] bcache: Use of hlist_count_nodes()
Date: Thu,  4 Jan 2024 17:49:35 +0100
Message-Id: <20240104164937.424320-4-pierre.gondois@arm.com>
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
 drivers/md/bcache/sysfs.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index a438efb66069..6956beb55326 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -702,13 +702,7 @@ static unsigned int bch_cache_max_chain(struct cache_set *c)
 	for (h = c->bucket_hash;
 	     h < c->bucket_hash + (1 << BUCKET_HASH_BITS);
 	     h++) {
-		unsigned int i = 0;
-		struct hlist_node *p;
-
-		hlist_for_each(p, h)
-			i++;
-
-		ret = max(ret, i);
+		ret = max(ret, hlist_count_nodes(h));
 	}
 
 	mutex_unlock(&c->bucket_lock);
-- 
2.25.1


