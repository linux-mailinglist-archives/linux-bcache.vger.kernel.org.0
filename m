Return-Path: <linux-bcache+bounces-844-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A71B2A32223
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Feb 2025 10:29:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D9F53A59C0
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Feb 2025 09:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD955205E31;
	Wed, 12 Feb 2025 09:29:02 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m49223.qiye.163.com (mail-m49223.qiye.163.com [45.254.49.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D0B205AD4
	for <linux-bcache@vger.kernel.org>; Wed, 12 Feb 2025 09:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739352542; cv=none; b=n47yPkHL95c99hbrYUPy3lxWKN+dgigQy3sesE0daUFv/Fluf1TVojhHagDbvJkvgu9GcrD8nsMnf0EKGhAAoOgcxs0qpc63R8GqURFbng0sVQr64T5wDtBaOJyrh5sGd+7qSeGRBbGs2HnWC7bbNWeoUwvopvCk+VoMLKIOLVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739352542; c=relaxed/simple;
	bh=HobnbV5FYd6bzk/tW6gMPs+UmvmuMDTBYkupLDXAV5c=;
	h=Content-Type:Message-ID:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:From:Date; b=ox+d1Hv9hHeTa5D81YMTSh3nQqP+tD3Vw9w3iWgBzFvCMvWGpfMx5QOE6evndSGqMGTzftdLpd7nojpMWLPV+2AwmUOzKGe5URh6Jz++LLpfITlK0EzPd/oRB7xe6rQfFUcdTarjQFQyK3cdmIjfJz/QZs/EO9FK1c9f7wfKJMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn; spf=none smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=45.254.49.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=easystack.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <ALsAXgAaLhNhHzKQW2msV4pl.3.1739343977966.Hmail.mingzhe.zou@easystack.cn>
To: Julian Sun  <sunjunchao2870@gmail.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, colyli <colyli@kernel.org>
Subject: =?UTF-8?B?UmU6W1BBVENIXSBiY2FjaGU6IFVzZSB0aGUgbGFzdGVzdCB3cml0ZWJhY2tfZGVsYXkgdmFsdWUgd2hlbiB3cml0ZWJhY2sgdGhyZWFkIGlzIHdva2VuIHVw?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com Sirius_WEB_WIN_1.47.0
In-Reply-To: <20250212055126.117092-1-sunjunchao2870@gmail.com>
References: <20250212055126.117092-1-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from mingzhe.zou@easystack.cn( [218.94.118.90] ) by ajax-webmail ( [127.0.0.1] ) ; Wed, 12 Feb 2025 15:06:17 +0800 (GMT+08:00)
From: =?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>
Date: Wed, 12 Feb 2025 15:06:17 +0800 (GMT+08:00)
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDS0JCVkNNGU0YGB5KHUseQ1YVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+
X-HM-Tid: 0a94f8df23e60242kunm194892bc97a
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMdPGVk+6WUBic5BJK0kLqbiJsCmuG9MdhyqTcq
	cnmL0IyrvQXLgMHt5crrNISNn5Z/liK1AQ4Ex0S/+2bdLCvlYUr5kEP0A/oGew4DD0rL2YnWAEmw
	s05MXW6K6rEBQKrZe2H8GYOLJsUItRaTHuibI=
X-HM-Sender-Digest: e1kJHlYWEh9ZQUpCQkpCTUxCS0pPSzdXWQweGVlBDwkOHldZEh8eFQ9Z
	QVlHOjcIOiMcOho3EzUTMwEwKixJFggtTwsXVUhVSkxIQkhPSEJMQ0xNQ1UzFhoSF1UWEhUcARMe
	VQEUDjseGggCCA8aGBBVGBVFWVdZEgtZQVlJSkNVQk9VSkpDVUJLWVdZCAFZQUhISk83V1kUCw8S
	FBUIWUFLNwY+

T3JpZ2luYWw6CkZyb23vvJpKdWxpYW4gU3VuIDxzdW5qdW5jaGFvMjg3MEBnbWFpbC5jb20+CkRh
dGXvvJoyMDI1LTAyLTEyIDEzOjUxOjI2KOS4reWbvSAoR01UKzA4OjAwKSkKVG/vvJpsaW51eC1i
Y2FjaGU8bGludXgtYmNhY2hlQHZnZXIua2VybmVsLm9yZz4KQ2PvvJpjb2x5bGk8Y29seWxpQGtl
cm5lbC5vcmc+ICwga2VudC5vdmVyc3RyZWV0PGtlbnQub3ZlcnN0cmVldEBsaW51eC5kZXY+ICwg
SnVsaWFuIFN1biA8c3VuanVuY2hhbzI4NzBAZ21haWwuY29tPgpTdWJqZWN077yaW1BBVENIXSBi
Y2FjaGU6IFVzZSB0aGUgbGFzdGVzdCB3cml0ZWJhY2tfZGVsYXkgdmFsdWUgd2hlbiB3cml0ZWJh
Y2sgdGhyZWFkIGlzIHdva2VuIHVwCldoZW4gdXNlcnMgcmVzZXQgd3JpdGViYWNrX2RlbGF5IHZh
bHVlIGFuZCB3b2tlIHVwIHdyaXRlYmFjawp0aHJlYWQgdmlhIHN5c2ZzIGludGVyZmFjZSwgZXhw
ZWN0IHRoZSB3cml0ZWJhY2sgdGhyZWFkCnRvIGRvIGFjdHVhbCB3cml0ZWJhY2sgd29yaywgYnV0
IGluIHJlYWxpdHksIHRoZSB3cml0ZWJhY2sKdGhyZWFkIHByb2JhYmx5IGNvbnRpbnVlIHRvIHNs
ZWVwLgoKRm9yIGV4YW1wbGUgdGhlIGZvbGxvd2luZyBzY3JpcHQgc2V0IHdyaXRlYmFja19kZWxh
eSB0byAwIGFuZAp3YWtlIHVwIHdyaXRlYmFjayB0aHJlYWQsIGJ1dCB3cml0ZWJhY2sgdGhyZWFk
IGp1c3QgY29udGludWUgdG8Kc2xlZXA6CmVjaG8gMCAmZ3Q7IC9zeXMvYmxvY2svYmNhY2hlMC9i
Y2FjaGUvd3JpdGViYWNrX2RlbGF5CmVjaG8gMSAmZ3Q7IC9zeXMvYmxvY2svYmNhY2hlMC9iY2Fj
aGUvd3JpdGViYWNrX3J1bm5pbmcKClVzaW5nIHRoZSBsYXN0ZXN0IHZhbHVlIHdoZW4gd3JpdGVi
YWNrIHRocmVhZCBpcyB3b2tlbiB1cCBjYW4KdXJnZSBpdCB0byBkbyBhY3R1YWwgd3JpdGViYWNr
IHdvcmsuCgpTaWduZWQtb2ZmLWJ5OiBKdWxpYW4gU3VuIDxzdW5qdW5jaGFvMjg3MEBnbWFpbC5j
b20+Ci0tLQogZHJpdmVycy9tZC9iY2FjaGUvd3JpdGViYWNrLmMgfCA0ICsrKy0KIDEgZmlsZSBj
aGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL21kL2JjYWNoZS93cml0ZWJhY2suYyBiL2RyaXZlcnMvbWQvYmNhY2hlL3dyaXRlYmFjay5j
CmluZGV4IGMxZDI4ZTM2NTkxMC4uMGQyZDA2YWFhY2ZlIDEwMDY0NAotLS0gYS9kcml2ZXJzL21k
L2JjYWNoZS93cml0ZWJhY2suYworKysgYi9kcml2ZXJzL21kL2JjYWNoZS93cml0ZWJhY2suYwpA
QCAtODI1LDggKzgyNSwxMCBAQCBzdGF0aWMgaW50IGJjaF93cml0ZWJhY2tfdGhyZWFkKHZvaWQg
KmFyZykKCkhpLCBKdWxpYW4gU3VuOgoKV2Ugc2hvdWxkIGZpcnN0IHVuZGVyc3RhbmQgdGhlIHJv
bGUgb2Ygd3JpdGFibGVfZGVsYXkuIAoKVGhlIHdyaXRlYmFjayB0aHJlYWQgb25seSBzbGVlcCB3
aGVuIHNlYXJjaGVkX2Z1bGxfaW5kZXggaXMgVHJ1ZSwKd2hpY2ggbWVhbnMgdGhhdCB0aGVyZSBh
cmUgdmVyeSBmZXcgZGlydHkga2V5cyBhdCB0aGlzIHRpbWUsIGFsbApkaXJ0eSBrZXlzIGFyZSBy
ZWZpbGxlZCBhdCBvbmNlLgoKIAkJCXdoaWxlIChkZWxheSAmYW1wOyZhbXA7CiAJCQkgICAgICAg
IWt0aHJlYWRfc2hvdWxkX3N0b3AoKSAmYW1wOyZhbXA7CiAJCQkgICAgICAgIXRlc3RfYml0KENB
Q0hFX1NFVF9JT19ESVNBQkxFLCAmYW1wO2MtJmd0O2ZsYWdzKSAmYW1wOyZhbXA7Ci0JCQkgICAg
ICAgIXRlc3RfYml0KEJDQUNIRV9ERVZfREVUQUNISU5HLCAmYW1wO2RjLSZndDtkaXNrLmZsYWdz
KSkKKwkJCSAgICAgICAhdGVzdF9iaXQoQkNBQ0hFX0RFVl9ERVRBQ0hJTkcsICZhbXA7ZGMtJmd0
O2Rpc2suZmxhZ3MpKSB7CiAJCQkJZGVsYXkgPSBzY2hlZHVsZV90aW1lb3V0X2ludGVycnVwdGli
bGUoZGVsYXkpOworCQkJCWRlbGF5ID0gbWluKGRlbGF5LCBkYy0mZ3Q7d3JpdGViYWNrX2RlbGF5
ICogSFopOworCQkJfQoKU28sIEkgZG9uJ3QgdGhpbmsgaXQgaXMgbmVjZXNzYXJ5IHRvIGltbWVk
aWF0ZWx5IGFkanVzdCB0aGUgc2xlZXAgdGltZQp1bmxlc3MgdGhlIHdyaXRlYmFja19kZWxheSBp
cyBzZXQgdmVyeSBsYXJnZS4gV2UgbmVlZCB0byBzZXQgYSByZWFzb25hYmxlCnZhbHVlIGZvciB3
cml0YWJsZV9kZWxheSBhdCBzdGFydHVwLCByYXRoZXIgdGhhbiBhZGp1c3RpbmcgaXQgYXQgcnVu
dGltZS4KCm1pbmd6aGUKIAogCQkJYmNoX3JhdGVsaW1pdF9yZXNldCgmYW1wO2RjLSZndDt3cml0
ZWJhY2tfcmF0ZSk7CiAJCX0KLS0gCjIuMzkuNQoKCgo8L3N1bmp1bmNoYW8yODcwQGdtYWlsLmNv
bT48L3N1bmp1bmNoYW8yODcwQGdtYWlsLmNvbT48L2tlbnQub3ZlcnN0cmVldEBsaW51eC5kZXY+
PC9jb2x5bGlAa2VybmVsLm9yZz48L2xpbnV4LWJjYWNoZUB2Z2VyLmtlcm5lbC5vcmc+PC9zdW5q
dW5jaGFvMjg3MEBnbWFpbC5jb20+DQoNCg==

