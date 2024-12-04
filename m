Return-Path: <linux-bcache+bounces-820-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D14A09E408B
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Dec 2024 18:06:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34F61B25F2F
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Dec 2024 16:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE89A20C024;
	Wed,  4 Dec 2024 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="kFYjJK55"
X-Original-To: linux-bcache@vger.kernel.org
Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [178.154.239.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE92D1B4130
	for <linux-bcache@vger.kernel.org>; Wed,  4 Dec 2024 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733330894; cv=none; b=JW/SKxJi/pO4d8MNs8aqBhXiS8YnXGCkHmFoSTGtmagLkMjC5pnjud8FUrnHv+FBla1o8xD1jm8yhcy3iXhDsttaQZR78C5f0lGUZLZMpBuylRkRfVV7DQZKQGCOWqXKrVjl+YELfUe6rswLhtRt3HTXqh4MCpgjFJjJPORM0Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733330894; c=relaxed/simple;
	bh=p+4IGLyri6wWJF1nrPrj9nNmPRnewU99xaYY06OwAk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XxVdF2ecwdyU8ImM1pRCWK6KSXBPgLzmXd90mU1trNqOHYfgWRMOIID+T1siVEpFytYHJt2u1ckhyMXt4vaFgJB+NE8JSU8n3kTyCzijMVj8RkSLbwk/cgTipVVEzRuWvUoF4orKvPnjB11ox4f2AEx0rN/KTewVOA3l8/3M/EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=kFYjJK55; arc=none smtp.client-ip=178.154.239.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Received: from mail-nwsmtp-smtp-production-main-31.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-31.sas.yp-c.yandex.net [IPv6:2a02:6b8:c08:de2c:0:640:e39b:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id 9666C60E2E;
	Wed,  4 Dec 2024 19:48:01 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-31.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 0mjr0IKMea60-hugyD05t;
	Wed, 04 Dec 2024 19:48:01 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1733330881; bh=+UCG5cY/+/T4HObT4DuXBiAZzo04csdaqdFwUEcJPrc=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=kFYjJK55I6dz+Lb2SD7Fl9NzFnRyIM+7V2vFry8wHBG0JTUbcWlTyJS8VIkrzA/9D
	 RhRAQODDBJnrF88X2E8jk9KHU6oIGi2Bn064+nTFP+mrJx3jkgr0w/VxhvIrXsP6hX
	 K3V/Yk5kQvr7hiSAfZv3BF64/NJ7VNEKoh1SKvZ0=
Authentication-Results: mail-nwsmtp-smtp-production-main-31.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] bcache: fix -Wunterminated-string-initialization from incoming gcc-15
Date: Wed,  4 Dec 2024 19:47:10 +0300
Message-ID: <20241204164710.1631405-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiling with gcc version 15.0.0 20241204 (experimental),
I've noticed the following warning:

drivers/md/bcache/super.c: In function 'uuid_find_empty':
drivers/md/bcache/super.c:549:43: warning: initializer-string for array
of 'char' is too long [-Wunterminated-string-initialization]
  549 |         static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Since C string constants are null-byte terminated by default,
constant zero initializer of 'const char[16]' should have 15
bytes rather than 16.

Fixes: cafe56359144 ("bcache: A block layer cache")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e7abfdd77c3b..c47a9ac031bd 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -546,7 +546,7 @@ static struct uuid_entry *uuid_find(struct cache_set *c, const char *uuid)
 
 static struct uuid_entry *uuid_find_empty(struct cache_set *c)
 {
-	static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
+	static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
 
 	return uuid_find(c, zero_uuid);
 }
-- 
2.47.1


