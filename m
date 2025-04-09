Return-Path: <linux-bcache+bounces-862-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17812A8272A
	for <lists+linux-bcache@lfdr.de>; Wed,  9 Apr 2025 16:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F3C9463DD3
	for <lists+linux-bcache@lfdr.de>; Wed,  9 Apr 2025 14:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F5A5264F8C;
	Wed,  9 Apr 2025 14:05:54 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m49231.qiye.163.com (mail-m49231.qiye.163.com [45.254.49.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F00264FAE
	for <linux-bcache@vger.kernel.org>; Wed,  9 Apr 2025 14:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744207553; cv=none; b=b17QEUqvGsjCXa2FgP3vrMv6sGi3d529FedFCTmbGTLBSAb4cL5OfL1J05pEpD4Xbg/B6Dd7ezw12wSKTwyNDLWnDT1QeyP73CpXoVICC4VA+1jN7I7YQO9u4qpdSzapaxWdIFn2meXWnpgZnKFVPBCRM0ZqC5q6IiXHE2+22SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744207553; c=relaxed/simple;
	bh=qfZUpJbWLL4wr/lmkXZhln64O48JkWTrTk5+BUHG+ag=;
	h=Content-Type:Message-ID:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:From:Date; b=ObvbTilwe/0US317kaEU0D/z5F09u2cn7MaAWb4wBJ1ehLF6qcWWAfZn1Qm7WLbZtsp0tfKMghnsFyPRRaNK6BxrTYpvaMpHSfoDU7YeSyWJGVUStWpNYAyAwKHpl+N0HCoREj6zxiG3YXIvqHYt3gtAd91HEa1kepqaW8TH2WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=45.254.49.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <ALcAnACYLj4w0H9xEeuAy4ox.3.1744162924028.Hmail.mingzhe.zou@easystack.cn>
To: Coly Li  <colyli@kernel.org>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, 
	"dongsheng.yang" <dongsheng.yang@easystack.cn>, 
	zoumingzhe <zoumingzhe@qq.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gYmNhY2hlOiBmaXggTlVMTCBwb2ludGVyIGluIGNhY2hlX3NldF9mbHVzaCgp?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com Sirius_WEB_WIN_1.49.0
In-Reply-To: <wboosa77dyqt2sybdg4re7blmh56j2tkpcndydbztakdsxzobp@a7a2ur2wq73y>
References: <20250407125625.270827-1-mingzhe.zou@easystack.cn> <wboosa77dyqt2sybdg4re7blmh56j2tkpcndydbztakdsxzobp@a7a2ur2wq73y>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from mingzhe.zou@easystack.cn( [218.94.118.90] ) by ajax-webmail ( [127.0.0.1] ) ; Wed, 9 Apr 2025 09:42:04 +0800 (GMT+08:00)
From: =?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>
Date: Wed, 9 Apr 2025 09:42:04 +0800 (GMT+08:00)
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaHx8dVklPS00aH0pDQ0IZQlYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lIQkhCVUpLS1
	VKQktLWQY+
X-HM-Tid: 0a961824d7a20242kunm195ec252ff1
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMdPGVk+6WUBic5BJK0kLqbiJsCmuG9MdhyqTcq
	cnmL0IyrvQXLgMHt5crrNISNn5ZxA+B9x7x6DUaLuL4wBumHZOfxWWI4JGABhG/Cw3H9hDegnAzH
	/ba+xrXNkWUZIM1H3dC8cwMJP1z92HWI7yUZI=
X-HM-Sender-Digest: e1kJHlYWEh9ZQUlLS09CS0xNSU5CTTdXWQweGVlBDwkOHldZEh8eFQ9Z
	QVlHOjcYOhU6OCI3EU8MSzNCAz4eDjoCTxQDVUhVSkxPT0pNSUJJT05NS1UzFhoSF1UWEhUcARMe
	VQEUDjseGggCCA8aGBBVGBVFWVdZEgtZQVlJSkNVQk9VSkpDVUJLWVdZCAFZQUlISkk3V1kUCw8S
	FBUIWUFLNwY+

Jmd0O05pY2UgY2F0Y2ghICBUaGFua3MgZm9yIHRoZSBmaXggdXAhCgomZ3Q7VGhlcmUgYXJlIHR3
byBzdWdnZXN0aW9ucyBmcm9tIG1lLAoKSGksIENvbHkgTGkKCiZndDsxKSB0aGUgYWJvdmUgY29k
ZSBleGFtcGxlIGlzIGZyb20gNC4xOCBrZXJuZWwgSSBndWVzcywgY291bGQgeW91IHBsZWFzZQom
Z3Q7ICAgdXBkYXRlIHRoZSBjb21taXQgbG9nIGFnYWluc3QgbGF0ZXN0IHVwc3RyZWFtIGtlcm5l
bCBjb2RlPwoKRmlyc3RseSwgdGhpcyBpcyBhIGZhaXJseSAoYWJvdXQgNC01IHllYXJzIGFnbykg
b2xkIHBhdGNoLiBOb3csIHdlIGhhdmUKcmViYXNlZCB0byB0aGUgNi42IGtlcm5lbC4gV2UgaGF2
ZSBubyBtb3JlIGNyYXNoZXMsIHNvIHdlIGFyZSB1bmFibGUgdG8Kb2J0YWluIHRoZSBsYXRlc3Qg
bWVzc2FnZSBsb2dzLgoKJmd0OzIpIENvdWxkIHlvdSBwbGVhc2UgYWRkIGNvZGUgY29tbWV0IGhl
cmUgdG8gZXhwbGFpbiB3aHkgY2EgaXMgY2hlY2tlZAomZ3Q7ICAgaGVyZT8gTGV0IG90aGVyIHBl
b3BsZSB0byBrbm93IHRoYXQgaW4gcmVnaXN0cmF0aW9uIGZhaWx1cmUgY29kZQomZ3Q7ICAgcGF0
aCwgY2EgbWlnaHQgYmUgTlVMTC4gU3VjaCBpbmZvcm1hdGlvbiBjb3VsZCBiZSBxdWl0ZSBoZWxw
ZnVsIGZvcgomZ3Q7ICAgb3RoZXJzIHRvIHVuZGVyc3RhbmQgdGhlIGNvZGUuCgpUaGlzIGlzIGEg
Z29vZCBpZGVhLiBJIGFtIGN1cnJlbnRseSBkZWFsaW5nIHdpdGggb3RoZXIgaXNzdWVzIGFuZCB3
aWxsCnNlbmQgdGhlIHYyIHZlcnNpb24gbGF0ZXIuCgptaW5nemhlCgomZ3Q7Q29seSBMaQoKDQoN
Cg==

