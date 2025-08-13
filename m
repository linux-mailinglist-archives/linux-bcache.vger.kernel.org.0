Return-Path: <linux-bcache+bounces-1188-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF93B24255
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Aug 2025 09:14:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B93013AF762
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Aug 2025 07:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421B02C375E;
	Wed, 13 Aug 2025 07:12:33 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E601529DB68;
	Wed, 13 Aug 2025 07:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755069153; cv=none; b=egmLxidNRATZBsSWOOSkq//q0xPk9jbt+FhkXQlEpVA0CJIgkE5zvRGQtT5g7nxQZalzsD0M+WiVo6EcWsuo4K9bpqDgDWzWoHnLGkfkTaRMl+3B6fADPZpLSTDTnsnpHED3wH2qwv77JY7/utC7zXGdG2i7D64dU5PHKC8QOwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755069153; c=relaxed/simple;
	bh=uARbApm9E0Y5R7rrOBBhI3huju2dfGpn/RJr3dkUSJk=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=sm22d64watBL7ziYQ1N/GK3bEcdxuVUfO5XuDQewFsPNiQGpCSxs9jumD2MOEvt9ezwWAexEZcJnjDcTd3Wfg99ClJhGnSc4l7gqXv0biKGFTjaaY/V3H6L0Kd4GW7/OLX17Mkf6cT8Kyq3ijNBRPM0jCliB3S4L90Suqo6x9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
EX-QQ-RecipientCnt: 5
X-QQ-GoodBg: 2
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqT0lIevWKG+BVnbhYYmM7POEhOP+T0DEcs=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: gSedFlXFAFO7N+DqpOC5AEAnJ7ynS4kdByWKPvkv/Tk=
X-QQ-STYLE: 
X-QQ-mid: lv3sz3a-2t1755069109tfe6282fb
From: "=?utf-8?B?WmhvdSBKaWZlbmc=?=" <zhoujifeng@kylinos.com.cn>
To: "=?utf-8?B?5ZGo57un5bOw?=" <zhoujifeng@kylinos.com.cn>, "=?utf-8?B?Q29seSBMaQ==?=" <colyli@kernel.org>
Cc: "=?utf-8?B?a2VudC5vdmVyc3RyZWV0?=" <kent.overstreet@linux.dev>, "=?utf-8?B?bGludXgtYmNhY2hl?=" <linux-bcache@vger.kernel.org>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
Subject: Re:[PATCH v2] bcache: enhancing the security of dirty data writeback
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Wed, 13 Aug 2025 15:11:48 +0800
X-Priority: 3
Message-ID: <tencent_09D8A9E34CEA74AC70E3901C@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <tencent_27E675CD6ADE39EA7923AD17@qq.com>
	<20250813021236.30133-1-zhoujifeng@kylinos.com.cn>
In-Reply-To: <20250813021236.30133-1-zhoujifeng@kylinos.com.cn>
X-QQ-ReplyHash: 193020551
X-BIZMAIL-ID: 2178544539551876747
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Wed, 13 Aug 2025 15:11:49 +0800 (CST)
Feedback-ID: lv:kylinos.com.cn:qybglogicsvrgz:qybglogicsvrgz5a-0
X-QQ-XMAILINFO: MTGYztYhR5ET3mH53f3L/flPEMdB1A68yBHG9oIBRAqSlLvgvsEYslli
	0nD2Hm9NE1tLAVQni5m+ypwvaUrO2214a7xi1nUZyTVYra7Ql6TfUuVTl6RksVV/FXnl+/W
	d2XOjY9oKB7AR5u5dLQAJdKRJwKns6IyYfaed+v1Z3dTHXG8AmnM5rGu8w/fUckriiEwQUW
	l+IWd9Ud9Qf/4Zk7f5WvzNTgST71sQVRgGfoO0gbuvhKwzJdffWlb3wKlG+fZ4RVV8/1seS
	LR9BnBeC8NGdm953k0LGYs3gEfUUFNCGJ00YmKjVSvXTF0If+UuSrdJZZoIHVxLZtenK3l4
	4m1oWUyP0r7sGuRjXCI+mWjiH1320zaz62JzX+8SjX70O1TbYzWRdMs108VDLMo6jzmllj7
	qXYvxjlrzDTo6skHuOL8UwLS5V0ba/IZs6IuD2oKXWZywwsrQwB+oB6CAngjGwWAmv3kM/y
	lvw9XdAW/lKTbrWNzkbrqR0k6yg11gerXAzHj5MAaE63yW1q+0gGcKIUNyiieDtdAYgJ3MM
	+0ITiiOZ5h2m5w8Y9rQnnqkiLTppGhZwJWN5+aKCRZIyZPiGGHT4gnazVV78668SFY8advU
	IIpp2DfZvFQ8dU63ffV4tPBrZIOA1ZMtHMkoWR9HpZBWZko469fXViyNqOnWTd9Xru+RLcB
	CCTKzhsHnvqhC09dp4XnaglCkpDfIlJdlhBXUs7TJF3YlZHemqGugX1GrEhqZXqZXWRkWtU
	Ddx/2+ADb+t/8S5cosxOT7nJBu598AnjPQTdZHm5ZqX+/eerkux41i2BE8EVnWxHE2CEQOy
	3rmyHEwsDpligia16PyaF+HC4GMqe6X/z08cGaJJ4D5sKE3Q+C4cqPLwZ4N/FT61k7s9ccv
	t4sq2wVJXqydEiQsBW4xX82gBk6YUEhXelI8wwc4jfoKATPW++LQtev+1ybOk5VGGBSpavm
	T65DtSrGMe7uV1d/KkVGvpc9eDzbs8430nuXPF/6pdEEsVSvvgBl03UiCj/CjYw3vTaxweJ
	m0q11eT46vVSbBrzveZnHSbcxthGk=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0

T24gV2VkLCAxMyBBdWcgMjAyNSBhdCAxMDoxNCwgWmhvdSBKaWZlbmcgPHpob3VqaWZlbmdA
a3lsaW5vcy5jb20uY24+IHdyb3RlOg0KPg0KPiBUaGVyZSBpcyBhIHBvdGVudGlhbCBkYXRh
IGNvbnNpc3RlbmN5IHJpc2sgaW4gYmNhY2hlJ3Mgd3JpdGViYWNrIG1vZGU6d2hlbg0KPiB0
aGUgYXBwbGljYXRpb24gY2FsbHMgZnN5bmMsIGJjYWNoZSByZXR1cm5zIHN1Y2Nlc3MgYWZ0
ZXIgY29tcGxldGluZyB0aGUNCj4gbG9nIHdyaXRlLCBwZXJzaXN0aW5nIHRoZSBjYWNoZSBk
aXNrIGRhdGEsIGFuZCBwZXJzaXN0aW5nIHRoZSBIREQgaW50ZXJuYWwNCj4gY2FjaGUuIEhv
d2V2ZXIsIGF0IHRoaXMgcG9pbnQsIHRoZSBhY3R1YWwgYXBwbGljYXRpb24gZGF0YSBtYXkg
c3RpbGwgYmUgaW4NCj4gYSBkaXJ0eSBzdGF0ZSBhbmQgcmVtYWluIHN0dWNrIGluIHRoZSBj
YWNoZSBkaXNrLiB3aGVuIHRoZXNlIGRhdGEgYXJlDQo+IHN1YnNlcXVlbnRseSB3cml0dGVu
IGJhY2sgdG8gdGhlIEhERCBhc3luY2hyb25vdXNseSB0aHJvdWdoIFJFUV9PUF9XUklURSwN
Cj4gdGhlcmUgaXMgbm8gZm9yY2VkIHJlZnJlc2ggbWVjaGFuaXNtIHRvIGVuc3VyZSBwaHlz
aWNhbCBwbGFjZW1lbnQgb24gdGhlDQo+IGRpc2ssIGFuZCB0aGVyZSBtYXkgYmUgbm8gcG93
ZXItb2ZmIHByb3RlY3Rpb24gbWVhc3VyZXMsIHdoaWNoIHBvc2VzIGEgcmlzaw0KPiBvZiBk
YXRhIGxvc3MuIFRoaXMgbWVjaGFuaXNtIG1heSBjYXVzZSB0aGUgYXBwbGljYXRpb24gdG8g
bWlzanVkZ2UgdGhhdCB0aGUNCj4gZGF0YSBoYXMgYmVlbiBwZXJzaXN0ZWQsIHdoaWNoIGlz
IGRpZmZlcmVudCBmcm9tIHRoZSBhY3R1YWwgc3RvcmFnZSBzdGF0ZSwNCj4gYW5kIGFsc28g
dmlvbGF0ZXMgdGhlIHNlbWFudGljIGFncmVlbWVudCB0aGF0IGZzeW5jIHNob3VsZCBlbnN1
cmUgZGF0YQ0KPiBwZXJzaXN0ZW5jZS4NCj4NCj4gVGhpcyBwYXRjaCBhaW1zIHRvIGVuaGFu
Y2UgdGhlIHJlbGlhYmlsaXR5IG9mIGRpcnR5IGRhdGEgd3JpdGViYWNrIHRocm91Z2gNCj4g
UFJFRkxVU0gsIGVuc3VyaW5nIHRoYXQgdGhlIGRpcnR5IGRhdGEgbWFyayBpbiB0aGUgY2Fj
aGUgZGV2aWNlIGlzIGNsZWFyZWQNCj4gb25seSBhZnRlciB0aGUgZGlydHkgZGF0YSBpcyB3
cml0dGVuIHRvIHRoZSBkaXNrLiBEb3VibGUgdHJpZ2dlcmluZw0KPiBjb25kaXRpb25zIGZv
ciBQUkVGTFVTSDoNCj4gMeOAgVdoZW4gdGhlIGN1bXVsYXRpdmUgbnVtYmVyIG9mIGRpcnR5
IGJrZXlzIHdyaXR0ZW4gYmFjayByZWFjaGVzIHRoZQ0KPiB0aHJlc2hvbGQoRHluYW1pYyBj
b250cm9sIHBhcmFtZXRlcnM6L3N5cy9ibG9jay9iY2FjaGUwL2JjYWNoZS8NCj4gZmx1c2hf
aW50ZXJ2YWwsIHRoZSBkZWZhdWx0IHZhbHVlIGlzIDIwMDAwLiBieSBpbmNyZWFzaW5nIHRo
ZSB2YWx1ZSBvZiB0aGlzDQo+IHBhcmFtZXRlciwgdGhlIGltcGFjdCBvZiBmbHVzaCBvbiBw
ZXJmb3JtYW5jZSBjYW4gYmUgcmVkdWNlZC4pDQo+IDLjgIFXaGVuIHRoZSBpbnRlcnZhbCBz
aW5jZSB0aGUgbGFzdCByZWZyZXNoIGV4Y2VlZHMgMzAgc2Vjb25kcw0KPiBJZiBhbnkgb2Yg
dGhlIGNvbmRpdGlvbnMgYXJlIG1ldCwgdGhlIHN5c3RlbSB3aWxsIHNlbmQgYSBQUkVGTFVT
SCBjb21tYW5kDQo+IHRvIHRoZSBiYWNrZW5kIEhERCwgYW5kIGNsZWFyIHRoZSBjb3JyZXNw
b25kaW5nIGRpcnR5IGJrZXkgbWFyayBvbmx5IGFmdGVyDQo+IGNvbmZpcm1pbmcgdGhhdCB0
aGUgUFJFRkxVU0ggaXMgZXhlY3V0ZWQgc3VjY2Vzc2Z1bGx5Lg0KPg0KPiBTaWduZWQtb2Zm
LWJ5OiBaaG91IEppZmVuZyA8emhvdWppZmVuZ0BreWxpbm9zLmNvbS5jbj4NCj4gLS0tDQo+
IHYxIC0+IHYyOiBNYWtlIHJldmlzaW9ucyBhY2NvcmRpbmcgdG8gdGhlIHJldmlldyBjb21t
ZW50cy4NCj4NCj4NCj4gW3NuaXBwZWRdDQo+DQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L21kL2JjYWNoZS9iY2FjaGVfb25kaXNrLmggYi9kcml2ZXJzL21kL2JjYWNoZS9iY2FjaGVf
b25kaXNrLmgNCj4gaW5kZXggNjYyMGE3ZjhmZmZjLi5kZjU4MDA4MzhlNDAgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbWQvYmNhY2hlL2JjYWNoZV9vbmRpc2suaA0KPiArKysgYi9kcml2
ZXJzL21kL2JjYWNoZS9iY2FjaGVfb25kaXNrLmgNCj4gQEAgLTI5NCw2ICsyOTQsMTAgQEAg
QklUTUFTSyhCREVWX0NBQ0hFX01PREUsICAgICAgICAgICBzdHJ1Y3QgY2FjaGVfc2IsIGZs
YWdzLCAwLCA0KTsNCj4gICNkZWZpbmUgQ0FDSEVfTU9ERV9XUklURUJBQ0sgICAgICAgICAg
IDFVDQo+ICAjZGVmaW5lIENBQ0hFX01PREVfV1JJVEVBUk9VTkQgICAgICAgICAyVQ0KPiAg
I2RlZmluZSBDQUNIRV9NT0RFX05PTkUgICAgICAgICAgICAgICAgICAgICAgICAzVQ0KPiAr
QklUTUFTSyhCREVWX1dSSVRFQkFDS19GTFVTSCwgICAgICAgICAgc3RydWN0IGNhY2hlX3Ni
LCBmbGFncywgNCwgMSk7DQo+ICsjZGVmaW5lIFdSSVRFQkFDS19GTFVTSF9PRkYgICAgICAg
ICAgICAwVQ0KPiArI2RlZmluZSBXUklURUJBQ0tfRkxVU0hfT04gICAgICAgICAgICAgMVUN
Cj4gKw0KPiAgQklUTUFTSyhCREVWX1NUQVRFLCAgICAgICAgICAgICAgICAgICAgc3RydWN0
IGNhY2hlX3NiLCBmbGFncywgNjEsIDIpOw0KPiAgI2RlZmluZSBCREVWX1NUQVRFX05PTkUg
ICAgICAgICAgICAgICAgICAgICAgICAwVQ0KPiAgI2RlZmluZSBCREVWX1NUQVRFX0NMRUFO
ICAgICAgICAgICAgICAgMVUNCg0KU29ycnksIHRoZSBpbnNwZWN0aW9uIHdhcyBub3QgdGhv
cm91Z2ggZW5vdWdoLiBUaGlzIGlzIGFuIGludmFsaWQgY29kZS4gSXQgd2FzIGxlZnQgb3Zl
cg0KZnJvbSB0aGUgcGFzdCBhbmQgd2FzIGZvcmdvdHRlbiB0byBiZSBkZWxldGVkLg==


