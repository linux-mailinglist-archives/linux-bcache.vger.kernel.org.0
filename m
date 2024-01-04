Return-Path: <linux-bcache+bounces-209-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D3AB82469E
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 17:50:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A8F81F2563F
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 16:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F069225112;
	Thu,  4 Jan 2024 16:50:28 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F2D525119;
	Thu,  4 Jan 2024 16:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30D88C15;
	Thu,  4 Jan 2024 08:51:12 -0800 (PST)
Received: from e126645.arm.com (unknown [10.57.76.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 497183F64C;
	Thu,  4 Jan 2024 08:50:22 -0800 (PST)
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
	Kees Cook <keescook@chromium.org>,
	Marco Elver <elver@google.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	linux-bcache@vger.kernel.org
Subject: [PATCH v2 0/3] list: Add hlist_count_nodes()
Date: Thu,  4 Jan 2024 17:49:32 +0100
Message-Id: <20240104164937.424320-1-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
- Add usages of the function to avoid considering it as dead code.
v1:
- https://lore.kernel.org/all/20240103090241.164817-1-pierre.gondois@arm.com/

Add a generic hlist_count_nodes() function.

This function aims to be used in a private module. As suggested by
Marco, having it used would avoid to consider it as dead code.
Thus, add some usages of the function in two drivers.

Pierre Gondois (3):
  list: Add hlist_count_nodes()
  binder: Use of hlist_count_nodes()
  bcache: Use of hlist_count_nodes()

 drivers/android/binder.c  |  4 +---
 drivers/md/bcache/sysfs.c |  8 +-------
 include/linux/list.h      | 15 +++++++++++++++
 3 files changed, 17 insertions(+), 10 deletions(-)

-- 
2.25.1


