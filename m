Return-Path: <linux-bcache+bounces-281-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D4E86720F
	for <lists+linux-bcache@lfdr.de>; Mon, 26 Feb 2024 11:52:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0564F1C25D43
	for <lists+linux-bcache@lfdr.de>; Mon, 26 Feb 2024 10:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13FCF24219;
	Mon, 26 Feb 2024 10:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TrNsnYYr"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B142C225D9;
	Mon, 26 Feb 2024 10:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708944515; cv=none; b=chb7mmzaOQlm2yCTSOs5sIXogTbX0nXExVUobDLlNi1sITal2m5HvjKLdPrGMGTU6zEMcIae8PBeLaRhg8ORneMTyAq7hd239YhKyBcQypTUVgAhmnS0ME8/Mh65rDv/BCfc6nR2VZhDJ5vU/LRAUAu4kn/LvdenFMSSvF89+i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708944515; c=relaxed/simple;
	bh=3zLYqGMh/0s3dL7o7ScvWBt1bgrzilnvdA6E7X0P4PE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l7wYdtE6ttFvXdfY6CJjaz6FKhCqgheIrkmWxJ3tqhWCYTbJJiWN4A6aZbdMdhaTz2vhkkWmZup30+H+K9fJxFBxqTW+WSma4vkhvBlsKd8+isucz1p45rz91dHouZaB+edW5ilhGq7it+mQO3nGlNLfT2cuZFekGAb0HDbyPKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TrNsnYYr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=3zLYqGMh/0s3dL7o7ScvWBt1bgrzilnvdA6E7X0P4PE=; b=TrNsnYYrYmvqGsfTfcQSsPP3W7
	uHYW7nJ3Ev8H1gcYekkqNLz5yhCaDq9nEKEOB6lubI9D1WCSM1hB3PJkmH2apZQAwxXrl26T5Cx5c
	efWdH4EAi/+FIkLL9aR1GFLFbGWvkRFQIhVelCFmZtEDDDbxC0ahE9om/bg2/MRAS9TtLt2MkLYIY
	4JPzvODVIowesvexviLGEVAQ46TrRi+mtF57hMwKarmcKZfwxXxpnasXP+6WY9C1jaPfSSFlnERH/
	2PpXewCiM/Xq1AuVGCs34ioXosFnwEclcBY9XOk5VX3QbKoRrHXu6jmRQ2B07HKhWPZFYdNRxSQ10
	+DbgM8aA==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYX9-00000000BM4-1ZaX;
	Mon, 26 Feb 2024 10:48:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Coly Li <colyli@suse.de>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: bcache queue limit cleanups
Date: Mon, 26 Feb 2024 11:48:25 +0100
Message-Id: <20240226104826.283067-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this patch against Jens' for-6.9/block tree gets rid of the last
queue limit update in bcache by calculation the io_opt ahead of
time.


