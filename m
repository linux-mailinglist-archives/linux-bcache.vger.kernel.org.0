Return-Path: <linux-bcache+bounces-367-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5679A89AC28
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:48:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 109E82824F6
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4265D481D8;
	Sat,  6 Apr 2024 16:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lkcdmXOV"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56D24CB45;
	Sat,  6 Apr 2024 16:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422079; cv=none; b=Kz8srmhDc6028MbrSCLPih67ULUexEGVy67S1o8I65bY3uymXpSaeQT0hVUOkc9OSX826erX024J1W795hqlDZ+eObPwVBBrA57Si5x5WbWIzXmm3BmRkLKRX7PsrWmtJnz0LsI84RyNNM2/vmtW+sgEXSy7uX29euVMzZ/5Y0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422079; c=relaxed/simple;
	bh=bbsjMLDh1vvuNiLRmMV+NcOuKuTi5AyduguPnnDUqk4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CoSyCky/BtZJzsvrIsv/ifbOIV6ukNiBN96zRiidfbj8p2T2Yxa8NeCMrLZMkmyQgt2qB2hMP+N4NhfE6PKv+hPX2IW22ltIapkUrnpC4Kd+aPlqMNHoSNcNuhcaiHXQDV+abMl7xnlI3AG7h7Wm7tLQ9Rs0XPN0kJukm+nCfdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lkcdmXOV; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2a2f2cd61cdso662532a91.1;
        Sat, 06 Apr 2024 09:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422077; x=1713026877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/27PnbbqJIcKzLAMpl2qrWzQcCu2oyEBnQ8NZJ3fd4=;
        b=lkcdmXOVEPFPWwowoG5WOInz4E93qsB67RAT7AICkLGozTtEcqTobgHQxYob7to0ja
         VTt6qHf60ZMHXQ88Cd55GvzhbmD3Ai1KjrdezFJxN54WQFxE8NDurie3TfCaYcYUcQ3O
         UgNTtnF9EHAj/k/oaf/7E7YbGDHP4J8O0Y7mxxvstOi+U2n8xssKrqnttfxpOPXfogec
         C1qQTAyZgvyCWq0kfkaSr76Xfa/0a3oiqiVLeK80Zx1clfKjLqZ6Ywnl2nbxZOnmXib0
         zNnPL1iv4ReMjjECHOu8V+03u1FdNnXDc539Dcw/mKTKjv0XZ3wQboMuS/+ukQrVNFJ9
         r64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422077; x=1713026877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/27PnbbqJIcKzLAMpl2qrWzQcCu2oyEBnQ8NZJ3fd4=;
        b=F59l8sKwDQMRKr7mTQbxxoHfvNXGE2HnAVjgjt2x/y0ldJkuoODM/kSiETgdfl4G43
         q4qGlWy/B+esrNHYlrba/+7Iy6sJRIEjDDIBSZ6HEMvJOsm1nu7h+d2suacSnVtFqGeG
         YdyIeE4I2VRyARKfksbEALbUefl5V6wyoP8m4R4gSy5ceFX15DnfCPrKDcHovKIchqkN
         rq70magp1pi01Ux2GnsPqfus0uamMeku7yHrbPxzBcTGkoBuMlcJNazr7QZz7Jt13hJh
         VNtxifGB/vTIDBYitBQWIkftOvCS0o9VkIWS2298L+vqoYeit0N488llGvn2Zc8WO38g
         CwxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXI4klXjTbKs0t6C7imsSoItBPsaFjMiKk+ZpFR5Ju1BnTBM9jcr2T3qUxL6AQ12K2uI9ssiZ0JrNcVHLp6ZhcUWPLvN2Sg8ukznv0cTjD6y+k13KK288cjNw0yegpmfesWuk4CEcxXq9LnF7wq2UoLAcagw3qtOr8lUKbY+ZcuTcdtRqWqmpK6d7RXIyN3hgVGhqlNBNXg9EBPdAsyteuTNcrkvh9/B8LjrEhE
X-Gm-Message-State: AOJu0YxEoFe76oTVRI2And9VlLfaVcNgzzxehb9jzw4qAnA9G9lCA9dV
	1o0I+upH0jfhU4v2pvvjRmvAG0dq7SzbcEbuDMOVBOFEWu+1OwUi
X-Google-Smtp-Source: AGHT+IFxbiwMKuKp6BX+v4dZDdOTLacbPLhfSVk+cPppFP1Rb7Pkm0sxtLz5sQ9Y+7QstP4MTMJZHg==
X-Received: by 2002:a17:902:e5c1:b0:1e0:c91b:b950 with SMTP id u1-20020a170902e5c100b001e0c91bb950mr5605946plf.5.1712422077130;
        Sat, 06 Apr 2024 09:47:57 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:47:56 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: bfoster@redhat.com,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v3 03/17] bcachefs: Fix typo
Date: Sun,  7 Apr 2024 00:47:13 +0800
Message-Id: <20240406164727.577914-4-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace 'utiility' with 'utility'.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 fs/bcachefs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 92c6ad75e702..05ac1b3b0604 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * random utiility code, for bcache but in theory not specific to bcache
+ * random utility code, for bcache but in theory not specific to bcache
  *
  * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
  * Copyright 2012 Google, Inc.
-- 
2.34.1


