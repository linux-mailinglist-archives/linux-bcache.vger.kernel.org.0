Return-Path: <linux-bcache+bounces-1091-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F11F1AC3A11
	for <lists+linux-bcache@lfdr.de>; Mon, 26 May 2025 08:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99E3B1892918
	for <lists+linux-bcache@lfdr.de>; Mon, 26 May 2025 06:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AB81DDA0C;
	Mon, 26 May 2025 06:42:21 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A15145346;
	Mon, 26 May 2025 06:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748241741; cv=none; b=L3NKAB+Iomc59iCOdcFV6q6mN+jGMd56pkmsqhOUELW5dfPwtBZFrOiAw3oMBQHF28hZMwO6pDliP8q8hT9liD3+kJpYXKk+tOeojriVkijfcz5KzL74IVICixO6FxP8+VImxn0FQODp0wuk886MzK6TjbeZ5FoHKevsGiBmJl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748241741; c=relaxed/simple;
	bh=Dto3alqyhv1IFsuAaSE87rggYSdjWxuZA9B5mPtViBg=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=r3JGTftElF7VA2p1lLDXuBMYeD7c+0Ll85C8Ai2w4ZEFGUfsftJ8ruO00fkFpCDgS95QAyVvd8aRMt0uApKo2gunsxDC3bpBmyOJJ9Is73HiXukmnxv54Aaov0PchRQdzmkQl5mR8+osx45C/kYDER4SxQpqEC2rEGI/8c83CLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
EX-QQ-RecipientCnt: 7
X-QQ-GoodBg: 2
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqQGDUD8fynKBEtT7UhPSW3KwhcbCNuks8I=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: xCtZ55NvqPrQU0mqf/YbY7g/9V6q/xIBF7T2cAyOssM=
X-QQ-STYLE: 
X-QQ-mid: lv3sz3a-2t1748241687t30395f74
From: "=?utf-8?B?WmhvdSBKaWZlbmc=?=" <zhoujifeng@kylinos.com.cn>
To: "=?utf-8?B?5ZGo57un5bOw?=" <zhoujifeng@kylinos.com.cn>, "=?utf-8?B?Q29seSBMaQ==?=" <colyli@kernel.org>
Cc: "=?utf-8?B?6YKT5pe65rOi?=" <dengwangbo@kylinos.com.cn>, "=?utf-8?B?a2VudC5vdmVyc3RyZWV0?=" <kent.overstreet@linux.dev>, "=?utf-8?B?bGludXgtYmNhY2hl?=" <linux-bcache@vger.kernel.org>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>, "=?utf-8?B?5aSP5Y2O?=" <xiahua@kylinos.com.cn>
Subject: Re:[PATCH v2] bcache: add the deferred_flush IO processing path in the writeback mode
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Mon, 26 May 2025 14:41:27 +0800
X-Priority: 3
Message-ID: <tencent_2272EC35532EE12E3CCD543A@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <ug3sqyn42af4bjsp3l5d5ymiabtc767oaoud3ddzv6jnw2eh27@4gcxqaq5tatf>
	<20250428073445.24108-1-zhoujifeng@kylinos.com.cn>
In-Reply-To: <20250428073445.24108-1-zhoujifeng@kylinos.com.cn>
X-QQ-ReplyHash: 3544881457
X-BIZMAIL-ID: 16601570920909843670
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Mon, 26 May 2025 14:41:28 +0800 (CST)
Feedback-ID: lv:kylinos.com.cn:qybglogicsvrgz:qybglogicsvrgz5a-0
X-QQ-XMAILINFO: NRqTDyx93rcorGNSP02F5amW0PG+0uPTDiU7GpLuEGb4ScJ9w70+Hjrd
	c1MGnfNIowUKrufX0EHwZV1ktocdlWkUOJqwyaD8ar5kHXJOuQAFuPCZB0nLkvuTT7NPZ/P
	vVERKq4QHnxU5SRRdfGiW69lrxCedxr2nUpmQSapxfdAyHdMiPkp0zXrLBKODD7hltAAmY3
	btcxOUK2enKNTSeEC8V2tb+PP6/UGypQfUpoJctNZ3FcmVcEpNEKXkdK5gHMljz2ic0X27H
	rgGDo6sA+Udgowhll09lpPLKZ6Q0nCIC3Vq6q3mPk9GA6AwED6RjtUCmNeukTAAO7R+2i/m
	y8Sp8uE2YUDf8glDJFe8sImJVMSfhk3oetkJRbE5lo2yrRzU/4yeT3rSi/zprXZW8Ovf2v/
	nHzyuIxV60oG9JQ7PgHmbZwe2yLaT+nQJtBDm/4l2TpyXkZBj54yKYUYL9/E+Llm1zPt406
	PtycxDAve9ZW6h/X1iDhhftb2vZoXPpzRP6/InCZBMn5euodSXztlBu2HTDe2fq7Oq/vabY
	fmMSyLD13W4p9JWf+ctdIDqEAJBon+gPOc2MVdeCn3ajuQTEkLrQjsvuj/89fQhQMFGlS1+
	0HlbF9Ur+0Q8CP/rLnKs8YZRSS5iQ2Ufo7Og9GXmkjQVFvKF55XsBzZrkWIbhsdrDF2H3+4
	+yAQQOTBA9AnnK/7C3truKJzLODu1nkpEkq9B04Fk3f2GMaMpkn3QEZ7cq2+toTsvJAHD3W
	MiRX324ifPbSMCplnOdMs7H3xgVYMNXrcOKtKBMtB7MWLfkHVmX4mzUEjvdB+E6er+vwjCA
	qxIFHTmUSo0U0mEB9tqfr0/QoJEc0J0eZDZRRxUjMJf2vA5JXCS7BKQi1YNeg+fEqQ1YyQd
	CADEhgaX70VyvogNiesAum5CPmBKIhK62XHDuDMpvfGzc+uLuW/jtxf8TEv73h0MEQhlUg2
	QZY5gIuqmz6+hl7R/HzFo2KKOkStEUYufSx9vCbV9jVNNAN40VC6Rof2d/LnphZxXUx8eRI
	lQm5NFp/5PemItEMRphmg9j/dDPpojl19RXsUXGQ==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

T24gTW9uLCAyOCBBcHIgMjAyNSBhdCAxNTozNiwgWmhvdSBKaWZlbmcgPHpob3VqaWZlbmdA
a3lsaW5vcy5jb20uY24+IHdyb3RlOg0KLi4uLi4NCj4gdjEtPnYyOiBWZXJzaW9uIHYyIG1h
aW5seSBhZGRyZXNzZXMgdGhlIGlzc3VlIG9mIGxvdyBlZmZpY2llbmN5IGluDQo+IHdyaXRp
bmcgYmFjayBkaXJ0eSBkYXRhIGluIHZlcnNpb24gdjEuIFdoZW4gd3JpdGluZyBiYWNrIGRp
cnR5IGRhdGEsDQo+IGl0IG5vIGxvbmdlciB1c2VzIHRoZSBGVUEgbWV0aG9kIGJ1dCBpbnN0
ZWFkIHdyaXRlcyBiYWNrIG5vIG1vcmUgdGhhbg0KPiA1MDAgZGlydHkgYmtleXMgYW5kIHRo
ZW4gdW5pZm9ybWx5IHNlbmRzIGEgUFJFRkxVU0ggaW5zdHJ1Y3Rpb24gb25jZS4NCj4gSSB3
aWxsIHN1cHBsZW1lbnQgbW9yZSB0ZXN0IGRhdGEgbGF0ZXIuDQouLi4uLg0KDQpDb21wYXJp
c29uIHRlc3QgZGF0YTo6DQpodHRwczovL2dpdGh1Yi5jb20vamlmZW5nemhvdS9maWxlL2Js
b2IvbWFpbi9iY2FjaGUtZGVmZXJyZWQtcGF0Y2gtY29ycmVsYXRpb24tZGF0YS5wZGYNCg0K
QmVzdCByZWdhcmRzLA0KDQpaaG91IEppZmVuZw==


