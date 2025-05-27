Return-Path: <linux-bcache+bounces-1095-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AD47AC4772
	for <lists+linux-bcache@lfdr.de>; Tue, 27 May 2025 07:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2ABE7A79F8
	for <lists+linux-bcache@lfdr.de>; Tue, 27 May 2025 05:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22731B4F0A;
	Tue, 27 May 2025 05:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GtdCp2W/"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78442F2A;
	Tue, 27 May 2025 05:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748322966; cv=none; b=dl7ewFkg3CLQIV9arCvBOIbwr77HWZ4CjLKEqpyc+WwvFCva58Tfg1vDBrQNSltWnAsa6l3r1ko1XXCL+0Foqz39k8tlg/dxakPMVGyaS8vN2SIk8wx0sPDAprwrRA5axnff996HO4e3vufTtmpJaqCu+jtXzE2BdhQ1dXUS0Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748322966; c=relaxed/simple;
	bh=zSZqXBgYMhYt0AkOfCoMEQ808fK71voPb1VKFjgOYXM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OItKZbrscMwJSfk1c6drOSXg3ru+qoVx4vQUdYNuASV8sYwLytmyqYRKzz79j0nq4x0nNxRWzUzpG68wQkAIfzFoFyoo08uGE+VVx/Ph7cVmh8NNTij24NGsvqXdppBkpUo9OioisOhW3oC4wnGQuogk+6StNz24XyruOldE38s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GtdCp2W/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D215C4CEEA;
	Tue, 27 May 2025 05:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748322966;
	bh=zSZqXBgYMhYt0AkOfCoMEQ808fK71voPb1VKFjgOYXM=;
	h=From:To:Cc:Subject:Date:From;
	b=GtdCp2W/D6dwIWMYEqxI7H2QGOFv6LQo7Wya9xw1sjHqV8twYNeavZDR8EJA5pTPU
	 L/QfAajBPmQmsDNj5wzIRb9Ye3UAm2lLKCD7vorQOOE6T/lJnhDy7ygifI8yEXPqwA
	 neHm0RmWVFHwzaEBWSQqBVljCE6qx24X3hRBYjzx90ysmGaTwxmKSqUdK8DuZe1sSW
	 btZqZy9mQqmAIjOTeFXalDZhixoEpmOtmYL0uvoxGaNCd/CGQ8z8gnLLxwOWQTZPcs
	 1uGcCbM2fFW9/UHafPGAupp1ifpue0L3q0Bi8XnW8Zd9EFeDKP7og3TUIawmppVs3e
	 NpIclt1zd6moQ==
From: colyli@kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Coly Li <colyli@kernel.org>
Subject: [PATCH 0/3] bcache-6.16-20250527
Date: Tue, 27 May 2025 13:15:58 +0800
Message-Id: <20250527051601.74407-1-colyli@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@kernel.org>

Hi Jens,

Please consider to take these patches for 6.16. They are generated
against linux-block tree for-6.16/block branch.

Linggang and Mingzhe from Easystack contribute two important fixes, the
patches are verified in their production environment for quite long
time. This time we have a new contributor Robert Pang from Google who
posts a code clean patch.

Thank you in advance.

Coly Li
---

Linggang Zeng (1):
  bcache: fix NULL pointer in cache_set_flush()

Mingzhe Zou (1):
  bcache: reserve more RESERVE_BTREE buckets to prevent allocator hang

Robert Pang (1):
  bcache: remove unused constants

 drivers/md/bcache/btree.c |  2 --
 drivers/md/bcache/super.c | 55 ++++++++++++++++++++++++++++++++-------
 2 files changed, 46 insertions(+), 11 deletions(-)

-- 
2.39.5


