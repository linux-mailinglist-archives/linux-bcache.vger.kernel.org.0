Return-Path: <linux-bcache+bounces-809-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7319DABB3
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Nov 2024 17:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9B0AB24041
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Nov 2024 16:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C910E20013D;
	Wed, 27 Nov 2024 16:22:39 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m25483.xmail.ntesmail.com (mail-m25483.xmail.ntesmail.com [103.129.254.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A6C2CCC0;
	Wed, 27 Nov 2024 16:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.129.254.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732724559; cv=none; b=UUnBUDd36P4ApBIp6Pzbw27OOmtBRok6djdrUUgNQ7fzkMNZjQxn2IzSI9fOXQ4vKGFwWmVsucEuG2nGwJAtBe9OBCG0n7p957PJE+3ybk0gs30NE9/nCbBEdRuhLCCfoVdPuLVXT40wr0mSlTDk4c8KxxXBRpkM91eLpRZmSCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732724559; c=relaxed/simple;
	bh=LgasnihNaxDx3YVzikdFJxGkeFQhCKhxhqboRxG1BQQ=;
	h=Content-Type:Message-ID:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:From:Date; b=rlra/mzilAoUdPqHeEUBlWOVJklNcj1JKkH5Nh30P2x6K43yznNnMHGxxySN5u4Eo+wE6WtWDQgdPoJW1sUN9BkJraUqU4QGEXf/zNkf0/ZXq6whsxzY/4UpXni7vkA6ix1Vb01nK8PTFd5x6mvLhj/MRay7zrAnrOx2X1rboDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn; spf=none smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=103.129.254.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=easystack.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AFMA0QCFLtADtc2DVJA7zqrc.3.1732683934173.Hmail.mingzhe.zou@easystack.cn>
To: Coly Li  <colyli@suse.de>
Cc: liequan che <liequanche@gmail.com>, 
	Kent Overstreet <kent.overstreet@gmail.com>, 
	linux-bcache <linux-bcache@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBWM10gYmNhY2hlOiByZXZlcnQgcmVwbGFjaW5nIElTX0VSUl9PUl9OVUxMIHdpdGggSVNfRVJSIGFnYWlu?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com Sirius_WEB_WIN_1.44.2
In-Reply-To: <7B52DB03-5E27-4F61-AE1A-11081B12E4BE@suse.de>
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com> <TYZPR02MB78424F31FF023102693D2DB2A65A2@TYZPR02MB7842.apcprd02.prod.outlook.com> <15077D4C-8DE9-4751-9492-51D972B3E4C3@suse.de> <CAAsfc_r_6mZ2HesDOQWU-0F2KXhz=EJ_nHeR4bLanXNnAiduTg@mail.gmail.com> <D5D1CBD5-0031-4285-BE12-910D6898B465@suse.de> <CAAsfc_oTmE2E8pMctiLSwMngVUbtJa4G=KAozzAfztMMc_RMOQ@mail.gmail.com> <0CFF2B9E-4E40-480D-9F3B-F7631FE3CEA5@suse.de> <A86AAB66-C89A-4A37-8416-F9A99D4630D8@suse.de> <CAAsfc_pxrz1bcfo=29-qPuZhEEffbK5=LYGeNRV9gf=vfyp8Aw@mail.gmail.com> <7B52DB03-5E27-4F61-AE1A-11081B12E4BE@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from mingzhe.zou@easystack.cn( [157.0.98.238] ) by ajax-webmail ( [127.0.0.1] ) ; Wed, 27 Nov 2024 13:05:34 +0800 (GMT+08:00)
From: =?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>
Date: Wed, 27 Nov 2024 13:05:34 +0800 (GMT+08:00)
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCH0weVkkdTBkdHUofTRpNTVYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlKTkxVS1VCQ1VJSENZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0hVSktLVU
	pCS0tZBg++
X-HM-Tid: 0a936c003e4e0242kunm19367a954be
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMSnifGRgu673L/Ijp4s6WoduoRTxhnglKj7XEK
	5pPUifPG7dgcXIhkEsU00drc8nRv223mY6Zwy8aEobBtqJSTYDxDFZ6whwZbRG343qV6NKHMQqtO
	2AyDscya0KhunsKU0p032qEcKg/rH6a7OE0iM=
X-HM-Sender-Digest: e1kJHlYWEh9ZQUpCTE1JQkhKTk1NSTdXWQweGVlBDwkOHldZEh8eFQ9Z
	QVlHOj02OksqOD03Dzo*DxhJPy0xOkwBCgkYVUhVSkxISU1DSEJIT01MT1UzFhoSF1UWEhUcARMe
	VQEUDjseGggCCA8aGBBVGBVFWVdZEgtZQVlKTkxVS1VCQ1VJSENZV1kIAVlBSE5ITTdXWRQLDxIU
	FQhZQUs3Bg++

TEdUTQoKcmV2aWV3ZWQgYnkgTWluZ3poZSBab3UKCk9yaWdpbmFsOgpGcm9t77yaQ29seSBMaSA8
Y29seWxpQHN1c2UuZGU+CkRhdGXvvJoyMDI0LTExLTI3IDExOjE3OjAxKOS4reWbvSAoR01UKzA4
OjAwKSkKVG/vvJpsaWVxdWFuIGNoZSA8bGllcXVhbmNoZUBnbWFpbC5jb20+CkNj77yabWluZ3po
ZS56b3VAZWFzeXN0YWNrLmNuPG1pbmd6aGUuem91QGVhc3lzdGFjay5jbj4gLCBLZW50IE92ZXJz
dHJlZXQgPGtlbnQub3ZlcnN0cmVldEBnbWFpbC5jb20+ICwgbGludXgtYmNhY2hlIDxsaW51eC1i
Y2FjaGVAdmdlci5rZXJuZWwub3JnPiAsIGxpbnV4LWtlcm5lbCA8bGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZz4KU3ViamVjdO+8mlJlOiBbUEFUQ0ggVjNdIGJjYWNoZTogcmV2ZXJ0IHJlcGxh
Y2luZyBJU19FUlJfT1JfTlVMTCB3aXRoIElTX0VSUiBhZ2FpbgomZ3Q7IDIwMjTlubQxMeaciDI3
5pelIDExOjAx77yMbGllcXVhbiBjaGUgPGxpZXF1YW5jaGVAZ21haWwuY29tPiDlhpnpgZPvvJoK
Jmd0OyAKJmd0OyBDb21taXQgMDI4ZGRjYWM0NzdiICgiYmNhY2hlOiBSZW1vdmUgdW5uZWNlc3Nh
cnkgTlVMTCBwb2ludCBjaGVjayBpbgomZ3Q7IG5vZGUgYWxsb2NhdGlvbnMiKSBsZWFkcyBhIE5V
TEwgcG9pbnRlciBkZWZlcmVuY2UgaW4gY2FjaGVfc2V0X2ZsdXNoKCkuCiZndDsgCiZndDsgMTcy
MSAgICAgICAgIGlmICghSVNfRVJSX09SX05VTEwoYy0mZ3Q7cm9vdCkpCiZndDsgMTcyMiAgICAg
ICAgICAgICAgICAgbGlzdF9hZGQoJmFtcDtjLSZndDtyb290LSZndDtsaXN0LCAmYW1wO2MtJmd0
O2J0cmVlX2NhY2hlKTsKJmd0OyAKJmd0OyBGcm9tIHRoZSBhYm92ZSBjb2RlIGluIGNhY2hlX3Nl
dF9mbHVzaCgpLCBpZiBwcmV2aW91cyByZWdpc3RyYXRpb24gY29kZQomZ3Q7IGZhaWxzIGJlZm9y
ZSBhbGxvY2F0aW5nIGMtJmd0O3Jvb3QsIGl0IGlzIHBvc3NpYmxlIGMtJmd0O3Jvb3QgaXMgTlVM
TCBhcyB3aGF0CiZndDsgaXQgaXMgaW5pdGlhbGl6ZWQuIEFsc28gX19iY2hfYnRyZWVfbm9kZV9h
bGxvYygpIG5ldmVyIHJldHVybnMgTlVMTCBidXQKJmd0OyBjLSZndDtyb290IGlzIHBvc3NpYmxl
IHRvIGJlIE5VTEwgYXQgYWJvdmUgbGluZSAxNzIxLgomZ3Q7IAomZ3Q7IFRoaXMgcGF0Y2ggcmVw
bGFjZXMgSVNfRVJSKCkgYnkgSVNfRVJSX09SX05VTEwoKSB0byBmaXggdGhpcy4KCgpPSywgdGhp
cyB0aW1lIHRoZSBjb21taXQgbG9nIG1ha2VzIGEgbG90IHNlbnNlLiBJdCBpcyBjbGVhciB0byBt
ZS4KCgomZ3Q7IAomZ3Q7IEZpeGVzOiAwMjhkZGNhYzQ3N2IgKCJiY2FjaGU6IFJlbW92ZSB1bm5l
Y2Vzc2FyeSBOVUxMIHBvaW50IGNoZWNrIGluCiZndDsgbm9kZSBhbGxvY2F0aW9ucyIpCiZndDsg
U2lnbmVkLW9mZi1ieTogTGllcXVhbiBDaGUgPGNoZWxpZXF1YW5AaW5zcHVyLmNvbT4KJmd0OyBD
Yzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwomZ3Q7IENjOiBaaGVuZyBXYW5nIDx6eXl0bHoud3pA
MTYzLmNvbT4KJmd0OyBDYzogQ29seSBMaSA8Y29seWxpQHN1c2UuZGU+CiZndDsgLS0tCiZndDsg
ZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYyB8IDIgKy0KJmd0OyAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKJmd0OyAKJmd0OyBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZC9iY2FjaGUvc3VwZXIuYyBiL2RyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMKJmd0OyBpbmRl
eCBlN2FiZmRkNzdjM2IuLmU0MmYxNDAwY2VhOSAxMDA2NDQKJmd0OyAtLS0gYS9kcml2ZXJzL21k
L2JjYWNoZS9zdXBlci5jCiZndDsgKysrIGIvZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYwomZ3Q7
IEBAIC0xNzE4LDcgKzE3MTgsNyBAQCBzdGF0aWMgQ0xPU1VSRV9DQUxMQkFDSyhjYWNoZV9zZXRf
Zmx1c2gpCiZndDsgICAgICAgIGlmICghSVNfRVJSX09SX05VTEwoYy0mZ3Q7Z2NfdGhyZWFkKSkK
Jmd0OyAgICAgICAgICAgICAgICBrdGhyZWFkX3N0b3AoYy0mZ3Q7Z2NfdGhyZWFkKTsKJmd0OyAK
Jmd0OyAtICAgICAgIGlmICghSVNfRVJSKGMtJmd0O3Jvb3QpKQomZ3Q7ICsgICAgICAgaWYgKCFJ
U19FUlJfT1JfTlVMTChjLSZndDtyb290KSkKJmd0OyAgICAgICAgICAgICAgICBsaXN0X2FkZCgm
YW1wO2MtJmd0O3Jvb3QtJmd0O2xpc3QsICZhbXA7Yy0mZ3Q7YnRyZWVfY2FjaGUpOwomZ3Q7IAom
Z3Q7ICAgICAgICAvKgomZ3Q7IOKAlAomZ3Q7IDIuNDYuMAoKSXQgaXMgZmluZSB0byBtZS4gSSBh
bSBpbiB0cmF2ZWwgdGhlc2UgZGF5cywgYW5kIHdpbGwgaGFuZGxlIHRoaXMgcGF0Y2ggYnkgZW5k
IG9mIHRoaXMgd2Vlay4KClRoYW5rcyBmb3IgY29tcG9zaW5nIHRoaXMgcGF0Y2guCgpDb2x5IExp
CjwvY29seWxpQHN1c2UuZGU+PC96eXl0bHoud3pAMTYzLmNvbT48L2NoZWxpZXF1YW5AaW5zcHVy
LmNvbT48L2xpZXF1YW5jaGVAZ21haWwuY29tPjwvbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zz48L2xpbnV4LWJjYWNoZUB2Z2VyLmtlcm5lbC5vcmc+PC9rZW50Lm92ZXJzdHJlZXRAZ21haWwu
Y29tPjwvbWluZ3poZS56b3VAZWFzeXN0YWNrLmNuPjwvbGllcXVhbmNoZUBnbWFpbC5jb20+PC9j
b2x5bGlAc3VzZS5kZT4NCg0K

