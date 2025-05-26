Return-Path: <linux-bcache+bounces-1093-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE559AC3D1E
	for <lists+linux-bcache@lfdr.de>; Mon, 26 May 2025 11:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 861231897958
	for <lists+linux-bcache@lfdr.de>; Mon, 26 May 2025 09:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 779521F099A;
	Mon, 26 May 2025 09:43:01 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8E61EF09D;
	Mon, 26 May 2025 09:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748252581; cv=none; b=VFqYhP4bCndc1Yvi0dh3MMt/GsboZ4250XTPOzeTr6MYg5m9/ajYS/GhbVO0DZB4Ythbmbvzo/pevfud5QXj0o7aO+1ONXe1HTIKUp6l5xREDFn6/IdZ1Qz06Wwos+bjA/fdAiw5qRqfCLKZzPS92U0BQw5AI4Faa5PHgbalNFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748252581; c=relaxed/simple;
	bh=ZGtEimytY+dhPlqQ+yJjRc35Hwn8LmWRiTBDEgIWdeA=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=nxpUhAJJJUokVWmPzYigWKAd3DIWTUo0PT4bq1j+ttPY2y6hP33IkSKjrrnbrCZWuQ6wi/9BrwfdLT1RpDGNLjS2MY3quNNmolJdAi9mz5RFYrBw3rBFM8yryWSvUhv6t/zjcJbyQ5QbNcRZwEYRC5ZsSEA42JmM1PzAQKRQcWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
EX-QQ-RecipientCnt: 7
X-QQ-GoodBg: 2
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqQGDUD8fynKBEtT7UhPSW3KwhcbCNuks8I=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: qGfvyB4E8QFdIgczcn18xzsKsELUIMeaEU8LuucsHgI=
X-QQ-STYLE: 
X-QQ-mid: lv3sz3a-2t1748252527td06cbce0
From: "=?utf-8?B?WmhvdSBKaWZlbmc=?=" <zhoujifeng@kylinos.com.cn>
To: "=?utf-8?B?Q29seSBMaQ==?=" <i@coly.li>
Cc: "=?utf-8?B?Q29seSBMaQ==?=" <colyli@kernel.org>, "=?utf-8?B?6YKT5pe65rOi?=" <dengwangbo@kylinos.com.cn>, "=?utf-8?B?a2VudC5vdmVyc3RyZWV0?=" <kent.overstreet@linux.dev>, "=?utf-8?B?bGludXgtYmNhY2hl?=" <linux-bcache@vger.kernel.org>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>, "=?utf-8?B?5aSP5Y2O?=" <xiahua@kylinos.com.cn>
Subject: Re: [PATCH v2] bcache: add the deferred_flush IO processing path in the writeback mode
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Mon, 26 May 2025 17:42:07 +0800
X-Priority: 3
Message-ID: <tencent_0AEE08B04C9DDE6C2354F36C@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <ug3sqyn42af4bjsp3l5d5ymiabtc767oaoud3ddzv6jnw2eh27@4gcxqaq5tatf>
	<20250428073445.24108-1-zhoujifeng@kylinos.com.cn>
	<tencent_2272EC35532EE12E3CCD543A@qq.com>
	<C16766D1-0FDE-40C7-822B-96927F6A683A@coly.li>
In-Reply-To: <C16766D1-0FDE-40C7-822B-96927F6A683A@coly.li>
X-QQ-ReplyHash: 1866073068
X-BIZMAIL-ID: 5775426963038862376
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Mon, 26 May 2025 17:42:08 +0800 (CST)
Feedback-ID: lv:kylinos.com.cn:qybglogicsvrgz:qybglogicsvrgz5a-0
X-QQ-XMAILINFO: N2v4nqiyABSwy4NEKnVO3YzS6BkGawvPdQiLW6pPKZRmIJiRZ0ogjxOx
	6Tm8EDXYbkVqKc4G8kdUL6VNq6fpRA2OtvMf0ZWB9++CNaXcxMnRZMzOqKsIWilrQWIbwZj
	mOTXaf3X/qy4EBjUkPMbhbjM8U1Sk/K9iFRdB6wJWrf/r23V+MAg2KDDd5VEoUz7Zlf7iyp
	z9eypmpfshC5O3afMqr+7aEmfNa4oPQSsKgV/xDQYC2rP6qryNtisV0OjINVMnlwB/dF/qH
	0TLeTGg8fQZU2HHQVDy0S2gH48o4g9mubBcerQQnomOqrZZXxX3tjBBwjo9J/kNocy3VwgO
	tDYDDvTQo4f7U+x9yjjW9dYvvoZm9nR/fDPlWU+nNMZ4DTybwA2Gz3/nMo0nc2b/kup8hCG
	NmBRcm7lIkaxakSYaUF48l83KNfKWB6Ku0vbJ/2aO2Re+/ZaKlongs6T/r2U8x8q+YYa57a
	rz4ZmLmZvwMB5H7It/zLl7dNBiD52z2aMuOtLpFzZvxGp2EdEW3ozt/AO853ey6Cq7S0Ch3
	QnzyA/Uv0986VQqmyBMn0pIm35Clotki4Jzyxuoa9U3Py1nN91D+iGxKqqlqaKHy9W7+s3w
	sjQy+SXlOCBOsG+fWynZXHm6AB2A1YNWYETvd+WhN1j1LGojB3UBLzTUqOJMLV1VFO4qNYV
	27qwSRUnJsrVLlwwMFaoZ2vTs/SdZh+e93ma60fYYSQGZKyaS4kEEEnsPx29Z6WzT0O/lz0
	OR3kenaCdCaNsx+K7pQlB9vHKw/gC5yJjOJL+1SQ5I+yomVhqKKkag7kBDweDhtglItG6D9
	k58VEqlU2ZX4alclhBF3Is1hrg66WjehRz5eAflkXpvj+yoF7M9ya1WIzvQRHqhta3nrYcA
	rvQ8NmimcKeR8PYODnseVVPNcpUaNVGD/Z8PR7wNl7nO7tsKcj15b6SuCZEU3ihArC7H2Aa
	6ghLAzy2Vag1z42W7MrFwRZe2bFenIbFhCCrm5IYMiQqbVk/Z8IwfEhDzFp6kFepnj83XO6
	tKw0J86MXjO3040+hO6ry6XntqF9XGzgkJl6xvA+2bD2aRatfPVPJmx1eTRWU=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

T24gTW9uLCAyNiBNYXkgMjAyNSBhdCAxNTo0MiwgQ29seSBMaSA8aUBjb2x5LmxpPiB3cm90
ZToNCj4NCj4gSGkgSmlmZW5nLA0KPg0KPiA+IDIwMjXlubQ15pyIMjbml6UgMTQ6NDHvvIxa
aG91IEppZmVuZyA8emhvdWppZmVuZ0BreWxpbm9zLmNvbS5jbj4g5YaZ6YGT77yaDQo+ID4N
Cj4gPiBPbiBNb24sIDI4IEFwciAyMDI1IGF0IDE1OjM2LCBaaG91IEppZmVuZyA8emhvdWpp
ZmVuZ0BreWxpbm9zLmNvbS5jbj4gd3JvdGU6DQo+ID4gLi4uLi4NCj4gPj4gdjEtPnYyOiBW
ZXJzaW9uIHYyIG1haW5seSBhZGRyZXNzZXMgdGhlIGlzc3VlIG9mIGxvdyBlZmZpY2llbmN5
IGluDQo+ID4+IHdyaXRpbmcgYmFjayBkaXJ0eSBkYXRhIGluIHZlcnNpb24gdjEuIFdoZW4g
d3JpdGluZyBiYWNrIGRpcnR5IGRhdGEsDQo+ID4+IGl0IG5vIGxvbmdlciB1c2VzIHRoZSBG
VUEgbWV0aG9kIGJ1dCBpbnN0ZWFkIHdyaXRlcyBiYWNrIG5vIG1vcmUgdGhhbg0KPiA+PiA1
MDAgZGlydHkgYmtleXMgYW5kIHRoZW4gdW5pZm9ybWx5IHNlbmRzIGEgUFJFRkxVU0ggaW5z
dHJ1Y3Rpb24gb25jZS4NCj4gPj4gSSB3aWxsIHN1cHBsZW1lbnQgbW9yZSB0ZXN0IGRhdGEg
bGF0ZXIuDQo+ID4gLi4uLi4NCj4gPg0KPiA+IENvbXBhcmlzb24gdGVzdCBkYXRhOjoNCj4g
PiBodHRwczovL2dpdGh1Yi5jb20vamlmZW5nemhvdS9maWxlL2Jsb2IvbWFpbi9iY2FjaGUt
ZGVmZXJyZWQtcGF0Y2gtY29ycmVsYXRpb24tZGF0YS5wZGYNCj4gPg0KPg0KPiBDYW4gSSBh
Y2Nlc3MgdGhlIHJhdyBkYXRhIHRvIGhhdmUgYSBsb29rPw0KPg0KPiBBbmQgdGhlIHRocmVl
IGRpZmZlcmVudCB0ZXN0aW5ncywgd2hpY2ggcGFyYW1ldGVycyBvZiBiY2FjaGUgYXJlIG1v
ZGlmaWVkIGZyb20gZGVmYXVsdD8NCj4NCj4gVGhhbmsuDQo+DQo+DQo+IENvbHkgTGkNCg0K
VGVzdCByYXcgZGF0YSBhZGRyZXNzOg0KaHR0cHM6Ly9naXRodWIuY29tL2ppZmVuZ3pob3Uv
ZmlsZS90cmVlL21haW4vZGVmZXJyZWQlMjB0ZXN0JTIwZGF0YQ0KDQpJIGhhdmUgbm90IGxl
YXJuZWQgdGhlIGRlZmF1bHQgdmFsdWVzIOKAi+KAi29mIHRoZSBwYXJhbWV0ZXJzIGluIHRo
ZSBjb25maWd1cmF0aW9uIGZpbGUuIEdlbmVyYWxseSwgdGhleSBhcmUgDQpjb25maWd1cmVk
IGFjY29yZGluZyB0byB0aGUgcmVxdWlyZWQgY2hhcmFjdGVyaXN0aWNzLCBzdWNoIGFzIHJh
bmRvbSBJTywgc2VxdWVudGlhbCBJTywgYmxvY2sgc2l6ZSwgZXRjLg0KVGhlIG9ubHkgZGlm
ZmVyZW5jZSBiZXR3ZWVuIHRoZSBmaXJzdCBhbmQgc2Vjb25kIHRlc3QgcGFyYW1ldGVycyBp
cyBvcGVuZmxhZ3MuIFRoZSBkaWZmZXJlbmNlIGJldHdlZW4gDQp0aGUgdGhpcmQgdGVzdCBh
bmQgdGhlIGZpcnN0IHR3byBncm91cHMgaXMgb3BlbmZsYWdzLCB4ZmVyc2l6ZSwgYW5kIHNl
ZWtwY3QuIFRoZSB4ZmVyc2l6ZSBwYXJhbWV0ZXIgaXMgDQp1c2VkIHRvIGNvbnRyb2wgdGhl
IGFjY2VzcyBibG9jayBzaXplLCBhbmQgdGhlIHNlZWtwY3QgcGFyYW1ldGVyIGlzIHVzZWQg
dG8gY29udHJvbCB0aGUgcmFuZG9tIHJhdGlvLiAwIA0KcmVwcmVzZW50cyBjb21wbGV0ZSBv
cmRlciBhbmQgMTAwIHJlcHJlc2VudHMgMTAwJSByYW5kb20u


