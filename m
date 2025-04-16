Return-Path: <linux-bcache+bounces-890-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28CA0A90E5B
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 00:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CD133A86AA
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Apr 2025 22:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43409231C9C;
	Wed, 16 Apr 2025 22:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZcFbSWtI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C0E2236F8;
	Wed, 16 Apr 2025 22:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744840900; cv=none; b=AZAE9fVDKrtXTUbHO2sUWmbL5RUuyctXbH+P6YaZG0q20ftsO26/QFkB+foaWzWirZJd7w8n/oT0tYjdsjpy7wYsnbla4phHfK9suq7vfh0mvHifTofJnVqQjkgjkXLoM3KQm/1etZQH8kydiJ8QgTEWr6KFSlDoBXoA16lLuVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744840900; c=relaxed/simple;
	bh=GKy1K6eDKAaPaa5kKmwg7ZIYcTdUhp7FDnOYinSy8EQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b6wHBtegNYjpynLLSH/CRq9en2hOVKhc8JpYhRCXJugG6PS9xXt6/yHjh9o1xS4DI8Q6ZdvckWXz+rTzltXpIRe7qw0K2kFgvjKN8QHW3SLQ31W9lQelfLJUP65n2MJAFbtKmelED3LkQxsk3kN/dTZ9JZ9DmR9MF6/3AZ2O3gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZcFbSWtI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF38C4CEE4;
	Wed, 16 Apr 2025 22:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744840899;
	bh=GKy1K6eDKAaPaa5kKmwg7ZIYcTdUhp7FDnOYinSy8EQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ZcFbSWtISa1Wzxw4kPKrtcyvhn0fnbRrUEBjMrTLV/vST7ilLL9RawCBdg0i+gXF4
	 nTGwFhOqmMOBDyNrpmcx6vLpj6Bvvncx+GV1nTgw9TiedOhqq+TNTy3EwdoYI0cAhl
	 Tzf9belqrfrhix6MfDN5KGGtsgLAESW+xAlhJ2g1K3RH+YetSfhT70BQjEtQ+mymfo
	 RwpW2SGpK0TCbj5xMRao4KmkX3XFkKdRZ22vvZ5/0P6YBdfIQHfIDl5rBQwqkAaVih
	 xpwxPStEbaymyGZBxlP8mpw4nLaYSkQDNTYxMAcSAaxPhjP3NvatLyG7gk2x3+HVJ9
	 v1QNw5cTybJ1g==
From: Kees Cook <kees@kernel.org>
To: Coly Li <colyli@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] md/bcache: Mark __nonstring look-up table
Date: Wed, 16 Apr 2025 15:01:36 -0700
Message-Id: <20250416220135.work.394-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1492; i=kees@kernel.org; h=from:subject:message-id; bh=GKy1K6eDKAaPaa5kKmwg7ZIYcTdUhp7FDnOYinSy8EQ=; b=owGbwMvMwCVmps19z/KJym7G02pJDBkMGvs5qgM9k90DpvYKfZMPUpqXYXj0TdMz5z2TV0xaq L2jgPl8RykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwER6XjD8LxNsjz7kJD+d0/5A itCnvdJOXBd8uc1uun6yfPfzVDD3H4Z/RvX33u5PmsDnso6F8cKr7YlRHZoNGWzRqy+8mnhRnN2 DGQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

GCC 15's new -Wunterminated-string-initialization notices that the 16
character lookup table "zero_uuid" (which is not used as a C-String)
needs to be marked as "nonstring":

drivers/md/bcache/super.c: In function 'uuid_find_empty':
drivers/md/bcache/super.c:549:43: warning: initializer-string for array of 'char' truncates NUL terminator but destination lacks 'nonstring' attribute (17 chars into 16 available) [-Wunterminated-string-initialization]
  549 |         static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Add the annotation to silence the GCC warning.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Coly Li <colyli@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e42f1400cea9..577d048170fe 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -546,7 +546,7 @@ static struct uuid_entry *uuid_find(struct cache_set *c, const char *uuid)
 
 static struct uuid_entry *uuid_find_empty(struct cache_set *c)
 {
-	static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
+	static const char zero_uuid[] __nonstring = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
 
 	return uuid_find(c, zero_uuid);
 }
-- 
2.34.1


