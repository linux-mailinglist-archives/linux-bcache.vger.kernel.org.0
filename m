Return-Path: <linux-bcache+bounces-1163-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA994B17B6B
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Aug 2025 05:31:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4612B1C2100A
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Aug 2025 03:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEFE1474CC;
	Fri,  1 Aug 2025 03:31:27 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904F98615A;
	Fri,  1 Aug 2025 03:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754019087; cv=none; b=Mc+pjrvAzdfdReerJrYIVxMvPy2MC//iynKZ2dQk1b5llA8Gyh+s61gvOXgO8fC8k+FX09rfhZLJPIM/mQyI71uwYZVvltwbqEAIwA/A+ccHpsNWjfw7iF1RypXZT3U9x1qytczVxgxpmf3pCbvzvk8ijHxmku07ZwcwwJfabVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754019087; c=relaxed/simple;
	bh=M5x0rYlpjgPFrul119gb//i85gX/gViUK3cJ5dM8bYg=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=riTkzF4ksskDx/6EghEe4TEkPNvELGdRIdpzv7mL+nWe8IMQ9x97vhuQygDuqwBqLwnYPC6XcCqCrhan1cwWFhno5OL+ax+GvVfhHy6OiRs5OO6KCtUILoDvRonvUKAKuC2xx8WhA/hxn7KsfkNmCK+ANO3Qbaqw0M144+gtcbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
EX-QQ-RecipientCnt: 4
X-QQ-GoodBg: 2
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqT0lIevWKG+BWOIYOYYzrVdtBspb4IB9XY=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: DuT7lxumEGg+2WYCAVw2O2fn56W4pwTWqYy0fYV/Jog=
X-QQ-STYLE: 
X-QQ-mid: lv3sz3a-2t1754019043t1c38adcd
From: "=?utf-8?B?WmhvdSBKaWZlbmc=?=" <zhoujifeng@kylinos.com.cn>
To: "=?utf-8?B?S2VudCBPdmVyc3RyZWV0?=" <kent.overstreet@linux.dev>
Cc: "=?utf-8?B?Q29seSBMaQ==?=" <colyli@kernel.org>, "=?utf-8?B?bGludXgtYmNhY2hl?=" <linux-bcache@vger.kernel.org>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Fri, 1 Aug 2025 11:30:43 +0800
X-Priority: 3
Message-ID: <tencent_22DE1AC52BA931BD442CE823@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
	<etlu4r6gxbe2jc3eemj3n4slg6xraxtxxydvxvmhv77xv42uss@7aw3yxbdgrdl>
	<tencent_656F159830BC538C2D26CD68@qq.com>
	<zcxdklyr2ugq7cfbed4olcsfcboy3nksxtpjs2g76bauvef5cq@4akbspw3ydiw>
In-Reply-To: <zcxdklyr2ugq7cfbed4olcsfcboy3nksxtpjs2g76bauvef5cq@4akbspw3ydiw>
X-QQ-ReplyHash: 841665476
X-BIZMAIL-ID: 9704118644632358436
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Fri, 01 Aug 2025 11:30:44 +0800 (CST)
Feedback-ID: lv:kylinos.com.cn:qybglogicsvrgz:qybglogicsvrgz5a-0
X-QQ-XMAILINFO: MZ6Tfega+cDUkCQimrMfH9B0NH4rXRlbr1UTy3CL60zyhofFVtmm9KgN
	YJo/oiZ27x1K6XHvHyArZ6DOGg7AmJP7ShbnVNOaAL0B7AC+21Xl8Pk0YAB32xqjiX79Qlg
	+5lit7F6U0lrUEo+f0ocTDZnJ4hQqYBIaQtjGaJaeYmPV+Lqb216Sn6H9yQ0VvNEedJHWbR
	9xF+l4ok4MvCZgc2X8MyDYRf7JX1UyegOl1kjUwdaDn4KF4CtM63njrHvhLd/2sW91FErv2
	B5izxJMjHkYI9+KKLYc2rEs2z3Dr7vTmMDZzFywPG0l9WAOBloSFS+Iu+8PU6/SX35jyvuO
	0lC6Xjw6S3B4SfwYPrAQhUUGaG/vNb11LtZnyOi5+9EaFRqRzpZPKA3hL8jCL2WxKbxtWV4
	VZOJwkGpfZWx/DrQHD8Be6QbgbNEsK7EqdCpzBndXzwH22L0L6fh58zGnLSAtqPyq2s7DiO
	JJHfTvY1Kj/4lp7OVfbL5Iwnw0r7xvfmn3HiFJKUM51Fnl4y3kc82AYN8oEMNM90dM2gNd5
	jj1IyjFHtkp0ABNDktk6aeoOg/0fBklODfLvUXOAtxkAWHEFF0k2QHpnQeQCozXUOT413Oi
	l6W4xYvDLa/7kEs4+cqFlQuYH7bGTbMG6VI0LbgZQv9dmcMl30Gowjt0UzQeIUk6lJ5vxWj
	O3XJO4n19lQFzPxLTDobihePfnzyUYB6FFesrV6Ik4zKnU8vrq55hRV8A/HV6TnqxQi+E4F
	oGo0g47fQ7VOJo0xG5fcUIca8pDY2S3BFSBkaXsrhBqkOTGBqvhjnuVhcW0DyMCn8Z3CAB4
	WIyNth2SkVbflTg9mh5LGK0MjaU2NJyjEHxD6y2ZeDr1wBY60sHpQUy4VmT3OMt5XSm4IOW
	Jt0FzrkyGxzhtfzwbxUz9Ekrw7w5U8cfRSczkfyLK6u1mItJUvdyr2D7O1gt6st9F1XvAtQ
	xJa2vod+GYCCLg1nDTqgeB5FGU/xOVel9AcYC2hI/zEZu04dhSRVlZqVQKd+PnS7X8/bWOV
	QzSShDBpybawwJ320OinWTu3hlcT0nbklsPymXbp1aXx7bpvvJKxh0SPAEAkdQcOO1jeh+C
	bh32LvSNxQD
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

T24gRnJpLCAxIEF1ZyAyMDI1IGF0IDEwOjM3LCBLZW50IE92ZXJzdHJlZXQgPGtlbnQub3Zl
cnN0cmVldEBsaW51eC5kZXY+IHdyb3RlOg0KPg0KPiBPbiBGcmksIEF1ZyAwMSwgMjAyNSBh
dCAxMDoyNzoyMUFNICswODAwLCBaaG91IEppZmVuZyB3cm90ZToNCj4gPiBJbiB0aGUgd3Jp
dGViYWNrIG1vZGUsIHRoZSBjdXJyZW50IGJjYWNoZSBjb2RlIHVzZXMgdGhlDQo+ID4gUkVR
X09QX1dSSVRFIG9wZXJhdGlvbiB0byBoYW5kbGUgZGlydHkgZGF0YSwgYW5kIGNsZWFycyB0
aGUgYmtleQ0KPiA+IGRpcnR5IGZsYWcgaW4gdGhlIGJ0cmVlIGR1cmluZyB0aGUgYmlvIGNv
bXBsZXRpb24gY2FsbGJhY2suIEkgdGhpbmsNCj4gPiB0aGVyZSBtaWdodCBiZSBhIHBvdGVu
dGlhbCByaXNrOiBpZiBpbiB0aGUgZXZlbnQgb2YgYW4gdW5leHBlY3RlZA0KPiA+IHBvd2Vy
IG91dGFnZSwgdGhlIGRhdGEgaW4gdGhlIEhERCBoYXJkd2FyZSBjYWNoZSBtYXkgbm90IGhh
dmUNCj4gPiBoYWQgdGltZSB0byBiZSBwZXJzaXN0ZWQsIHRoZW4gdGhlIGRhdGEgaW4gdGhl
IEhERCBoYXJkd2FyZSBjYWNoZQ0KPiA+IHRoYXQgaXMgcGVuZGluZyBwcm9jZXNzaW5nIG1h
eSBiZSBsb3N0LiBTaW5jZSBhdCB0aGlzIHRpbWUgdGhlIGJrZXkNCj4gPiBkaXJ0eSBmbGFn
IGluIHRoZSBidHJlZSBoYXMgYmVlbiBjbGVhcmVkLCB0aGUgZGF0YSBzdGF0dXMgcmVjb3Jk
ZWQNCj4gPiBieSB0aGUgYmtleSBkb2VzIG5vdCBtYXRjaCB0aGUgYWN0dWFsIHNpdHVhdGlv
biBvZiB0aGUgU1NEIGFuZA0KPiA+IEhERC4NCj4gPiBBbSBJIHVuZGVyc3RhbmRpbmcgdGhp
cyBjb3JyZWN0bHk/DQo+DQo+IEZvciB3aGF0IHlvdSdyZSBkZXNjcmliaW5nLCB3ZSBuZWVk
IHRvIG1ha2Ugc3VyZSB0aGUgYmFja2luZyBkZXZpY2UgaXMNCj4gZmx1c2hlZCB3aGVuIHdl
J3JlIGZsdXNoaW5nIHRoZSBqb3VybmFsLg0KPg0KPiBJdCdzIHBvc3NpYmxlIHRoYXQgdGhp
cyBpc24ndCBoYW5kbGVkIGNvcnJlY3RseSBpbiBiY2FjaGU7IGJjYWNoZWZzDQo+IGRvZXMs
IGFuZCBJIHdyb3RlIHRoYXQgY29kZSBhZnRlciBiY2FjaGUgLSBidXQgdGhlIGJjYWNoZSB2
ZXJzaW9uIHdvdWxkDQo+IGxvb2sgcXVpdGUgZGlmZmVyZW50Lg0KPg0KPiBZb3UndmUgcmVh
ZCB0aGF0IGNvZGUgbW9yZSByZWNlbnRseSB0aGFuIEkgaGF2ZSAtIGhhdmUgeW91IGNoZWNr
ZWQgZm9yDQo+IHRoYXQ/DQoNCkluIHRoZSBgd3JpdGVfZGlydHlfZmluaXNoYCBmdW5jdGlv
biwgdGhlcmUgaXMgYW4gYXR0ZW1wdCB0byB1cGRhdGUgdGhlDQpgYmtleWAgc3RhdHVzLCBi
dXQgSSBkaWQgbm90IG9ic2VydmUgYW55IGxvZ2dpbmcgd3JpdGluZyBwcm9jZXNzLiBJbiB0
aGUNCmNvcmUgZnVuY3Rpb24gYGpvdXJuYWxfd3JpdGVfdW5sb2NrZWRgIG9mIGJjYWNoZSBm
b3Igd3JpdGluZyBsb2dzLCBJDQphbHNvIGNvdWxkbid0IGZpbmQgdGhlIGNvZGUgbG9naWMg
Zm9yIHNlbmRpbmcgYSBGTFVTSCBjb21tYW5kIHRvIHRoZQ0KYmFja2VuZCBIREQu


