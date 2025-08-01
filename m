Return-Path: <linux-bcache+bounces-1165-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42ECAB17CCE
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Aug 2025 08:11:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 801F37B2333
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Aug 2025 06:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D45C1F3BA2;
	Fri,  1 Aug 2025 06:11:20 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A38C2E36EA;
	Fri,  1 Aug 2025 06:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754028680; cv=none; b=unyrCZPrtAFQmADTSg9xwL/FicU763m9ExsM5ROG8VUGwO5Bqm55Z+d0o6a5N84P+/ZP0UP0EFXsCcFq3KwKyspPR9B/NHxy2duKenz8qMIo53v4fSJev5vG1f6qmmyQlwuiW+Fld5Cw5lFr8NWPNz1bK9Jqhk74OlzRbl8VclM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754028680; c=relaxed/simple;
	bh=6B4qPrGMklzrUZMDAftJPz07xrCYuGcZHMUxhWEGjVo=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=CgO5CAn5yxldmcXzcYfl61fS1x3n/jmRtYpUaX0MYtIIpSoQVMUubMYx6LBTc+IvPxpGsgX2vKj+q4w7J4Yvgnmmfx2eOKuLXjQ81m1IbN5KewAiovqN0njyoIcqAHFBa0FDwC/vEefLT9scl/8smpjC4gwIpiPoCKnDpzI2eYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
EX-QQ-RecipientCnt: 4
X-QQ-GoodBg: 2
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqT0lIevWKG+BVnbhYYmM7POEhOP+T0DEcs=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: e04RJrXsrRn3xPT60vlZ+2oyXL+oYr76dyOYJNTw7xY=
X-QQ-STYLE: 
X-QQ-mid: lv3sz3a-2t1754028612ta05b92cb
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
Date: Fri, 1 Aug 2025 14:10:12 +0800
X-Priority: 3
Message-ID: <tencent_6FE47FFD5A5D8EF818ACD926@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
	<etlu4r6gxbe2jc3eemj3n4slg6xraxtxxydvxvmhv77xv42uss@7aw3yxbdgrdl>
	<tencent_656F159830BC538C2D26CD68@qq.com>
	<zcxdklyr2ugq7cfbed4olcsfcboy3nksxtpjs2g76bauvef5cq@4akbspw3ydiw>
	<tencent_22DE1AC52BA931BD442CE823@qq.com>
	<wxyamy7fkf7of4olnvqju2ldflnpj3k5u6qsufvesb3mtoaxwb@fuu5brsbgjwf>
In-Reply-To: <wxyamy7fkf7of4olnvqju2ldflnpj3k5u6qsufvesb3mtoaxwb@fuu5brsbgjwf>
X-QQ-ReplyHash: 2576616297
X-BIZMAIL-ID: 11512612339349411863
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Fri, 01 Aug 2025 14:10:13 +0800 (CST)
Feedback-ID: lv:kylinos.com.cn:qybglogicsvrgz:qybglogicsvrgz5a-0
X-QQ-XMAILINFO: M/ny7O8ElP4xnvsAL/rUQiQk6Ya27HFIx13jHfMTHqoA3E+GyagJ/Pgk
	S+gLx64o9CvlSAD6T0DzpMBdVyDq92qAnBIGdxHEF9pvdabm7hUOphLi4FPGnyUkKu5Eo+O
	nC+clK15UupuwQ8z8uYpwnMDEe0ozWeq9WZPVYC4izA2ZPcPSawvD297EDpGanNckd5bNvj
	nBcnnVlsp53Nw99cZpMw7BE8xKJLxTsRRtLVwEHRebhnaXGyDcXY6Ed7vjKKB+gZSLMrRSU
	njbSl/s7OvknlQCRTgerJRyJ0O8OWu6ZL9tyqS4ujIhk6lcwolOOpniLxMZZaWLgFxiv1k5
	1ykYPAPTZfRe9TvGhXvVfqJmIWV1Eg0UpIoU6m+twrZxphqZ51kvApl6/vOSsp6vgeHCj4Z
	zMneXS+ZtbTFT2E/aB+xsZosaoPPx2VxP2y+yjrpzONNvNPkVXHSwK8TEqbJ/7NSyDmGxNi
	MTQpSkVsO6P/f9qVFPXWFZk/IgLeEmvVDCFwOwZdDb0R1yNaPaUbW+UjvftMERceV7/JIQ1
	gvLGbFhGc1rttlwQ6Gw3qrLepFBYCM3NyPWzhZAX0NEu8JUlyEL6+di1EsTxN/CDUNy2WGb
	omvRsj+ZC0Kk2wXSjhcUzjvF6KRx3FbajmyYCfpuXnhx+aMQdaF27ArRQXN608nKbCdGqnP
	+JaBZHoENvrZ8IeNwqOiIvk4hmb+PN++z6uSqotAd03rmoWxzLR+a6jMoOjeMgHje6eRYAy
	vP8A5xkIg7fCDbCuUFYsRlSapLjh7dhvsgHj0Joi6m+6RvLZVEuYOOYDzOiMQrWS0OaylLe
	BB9bFQl29l5h3f8oXwAdiCL/QfGr0sLYxWcP8EKbtCHlcUkaDbUckylrVrajmrqlxxTEx5S
	Hdth83WwqO7MEgRVqSJeg0nVLkzRPe7daanjSnXLS3/rax2umTknpHC1IkC/ZZ0DYYuCLig
	sN+NC8fj1L4scnPp+2y2NDBtxBhO+EF1iEhewkiN2yVWWkIi7C7+kP+J0aBK8jeHGxnLf+z
	gxTzMneW5op79tEP/qTdE6wOalNAfZsMKaH6YV8QPBfCswHk+XEGuHQ7xDBlrrobLACGs8Z
	Dgj8KHu4dBKZUW3hPoRECntGmqolMYk3AsxE4+zL12s
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0

T24gRnJpLCAxIEF1ZyAyMDI1IGF0IDExOjQyLCBLZW50IE92ZXJzdHJlZXQgPGtlbnQub3Zl
cnN0cmVldEBsaW51eC5kZXY+IHdyb3RlOg0KPg0KPiBPbiBGcmksIEF1ZyAwMSwgMjAyNSBh
dCAxMTozMDo0M0FNICswODAwLCBaaG91IEppZmVuZyB3cm90ZToNCj4gPiBPbiBGcmksIDEg
QXVnIDIwMjUgYXQgMTA6MzcsIEtlbnQgT3ZlcnN0cmVldCA8a2VudC5vdmVyc3RyZWV0QGxp
bnV4LmRldj4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gT24gRnJpLCBBdWcgMDEsIDIwMjUgYXQg
MTA6Mjc6MjFBTSArMDgwMCwgWmhvdSBKaWZlbmcgd3JvdGU6DQo+ID4gPiA+IEluIHRoZSB3
cml0ZWJhY2sgbW9kZSwgdGhlIGN1cnJlbnQgYmNhY2hlIGNvZGUgdXNlcyB0aGUNCj4gPiA+
ID4gUkVRX09QX1dSSVRFIG9wZXJhdGlvbiB0byBoYW5kbGUgZGlydHkgZGF0YSwgYW5kIGNs
ZWFycyB0aGUgYmtleQ0KPiA+ID4gPiBkaXJ0eSBmbGFnIGluIHRoZSBidHJlZSBkdXJpbmcg
dGhlIGJpbyBjb21wbGV0aW9uIGNhbGxiYWNrLiBJIHRoaW5rDQo+ID4gPiA+IHRoZXJlIG1p
Z2h0IGJlIGEgcG90ZW50aWFsIHJpc2s6IGlmIGluIHRoZSBldmVudCBvZiBhbiB1bmV4cGVj
dGVkDQo+ID4gPiA+IHBvd2VyIG91dGFnZSwgdGhlIGRhdGEgaW4gdGhlIEhERCBoYXJkd2Fy
ZSBjYWNoZSBtYXkgbm90IGhhdmUNCj4gPiA+ID4gaGFkIHRpbWUgdG8gYmUgcGVyc2lzdGVk
LCB0aGVuIHRoZSBkYXRhIGluIHRoZSBIREQgaGFyZHdhcmUgY2FjaGUNCj4gPiA+ID4gdGhh
dCBpcyBwZW5kaW5nIHByb2Nlc3NpbmcgbWF5IGJlIGxvc3QuIFNpbmNlIGF0IHRoaXMgdGlt
ZSB0aGUgYmtleQ0KPiA+ID4gPiBkaXJ0eSBmbGFnIGluIHRoZSBidHJlZSBoYXMgYmVlbiBj
bGVhcmVkLCB0aGUgZGF0YSBzdGF0dXMgcmVjb3JkZWQNCj4gPiA+ID4gYnkgdGhlIGJrZXkg
ZG9lcyBub3QgbWF0Y2ggdGhlIGFjdHVhbCBzaXR1YXRpb24gb2YgdGhlIFNTRCBhbmQNCj4g
PiA+ID4gSERELg0KPiA+ID4gPiBBbSBJIHVuZGVyc3RhbmRpbmcgdGhpcyBjb3JyZWN0bHk/
DQo+ID4gPg0KPiA+ID4gRm9yIHdoYXQgeW91J3JlIGRlc2NyaWJpbmcsIHdlIG5lZWQgdG8g
bWFrZSBzdXJlIHRoZSBiYWNraW5nIGRldmljZSBpcw0KPiA+ID4gZmx1c2hlZCB3aGVuIHdl
J3JlIGZsdXNoaW5nIHRoZSBqb3VybmFsLg0KPiA+ID4NCj4gPiA+IEl0J3MgcG9zc2libGUg
dGhhdCB0aGlzIGlzbid0IGhhbmRsZWQgY29ycmVjdGx5IGluIGJjYWNoZTsgYmNhY2hlZnMN
Cj4gPiA+IGRvZXMsIGFuZCBJIHdyb3RlIHRoYXQgY29kZSBhZnRlciBiY2FjaGUgLSBidXQg
dGhlIGJjYWNoZSB2ZXJzaW9uIHdvdWxkDQo+ID4gPiBsb29rIHF1aXRlIGRpZmZlcmVudC4N
Cj4gPiA+DQo+ID4gPiBZb3UndmUgcmVhZCB0aGF0IGNvZGUgbW9yZSByZWNlbnRseSB0aGFu
IEkgaGF2ZSAtIGhhdmUgeW91IGNoZWNrZWQgZm9yDQo+ID4gPiB0aGF0Pw0KPiA+DQo+ID4g
SW4gdGhlIGB3cml0ZV9kaXJ0eV9maW5pc2hgIGZ1bmN0aW9uLCB0aGVyZSBpcyBhbiBhdHRl
bXB0IHRvIHVwZGF0ZSB0aGUNCj4gPiBgYmtleWAgc3RhdHVzLCBidXQgSSBkaWQgbm90IG9i
c2VydmUgYW55IGxvZ2dpbmcgd3JpdGluZyBwcm9jZXNzLiBJbiB0aGUNCj4gPiBjb3JlIGZ1
bmN0aW9uIGBqb3VybmFsX3dyaXRlX3VubG9ja2VkYCBvZiBiY2FjaGUgZm9yIHdyaXRpbmcg
bG9ncywgSQ0KPiA+IGFsc28gY291bGRuJ3QgZmluZCB0aGUgY29kZSBsb2dpYyBmb3Igc2Vu
ZGluZyBhIEZMVVNIIGNvbW1hbmQgdG8gdGhlDQo+ID4gYmFja2VuZCBIREQuDQo+DQo+IFRo
ZSByaWdodCBwbGFjZSBmb3IgaXQgd291bGQgYmUgaW4gdGhlIGpvdXJuYWwgY29kZTogYmVm
b3JlIGRvaW5nIGENCj4gam91cm5hbCB3cml0ZSwgaXNzdWUgZmx1c2hlcyB0byB0aGUgYmFj
a2luZyBkZXZpY2VzLg0KPg0KPiBDYW4geW91IGNoZWNrIGZvciB0aGF0Pw0KPg0KDQpJIGNo
ZWNrZWQgYW5kIGZvdW5kIHRoYXQgdGhlcmUgd2FzIG5vIGNvZGUgZm9yIHNlbmRpbmcgYSBm
bHVzaCByZXF1ZXN0DQp0byB0aGUgYmFja2VuZCBkZXZpY2UgYmVmb3JlIHRoZSBleGVjdXRp
b24gbG9nIHdhcyB3cml0dGVuLiBBZGRpdGlvbmFsbHksDQppbiB0aGUgY2FsbGJhY2sgZnVu
Y3Rpb24gYWZ0ZXIgdGhlIGRpcnR5IGRhdGEgd2FzIHdyaXR0ZW4gYmFjaywgd2hlbiBpdA0K
dXBkYXRlZCB0aGUgYmtleSwgaXQgZGlkIG5vdCBpbnNlcnQgdGhpcyB1cGRhdGUgaW50byB0
aGUgbG9nLg0KDQpUaGUgZm9sbG93aW5nIGNhbGxiYWNrIGZ1bmN0aW9uIGFmdGVyIGRpcnR5
IGRhdGEgaXMgd3JpdHRlbiBiYWNrIG9ubHkNCnVwZGF0ZXMgdGhlIGJrZXksIHdpdGhvdXQg
cmVjb3JkaW5nIHRoZSBpbnNlcnRlZCBia2V5IGluIHRoZSBqb3VybmFsOg0Kc3RhdGljIENM
T1NVUkVfQ0FMTEJBQ0sod3JpdGVfZGlydHlfZmluaXNoKQ0Kew0KICAgIGNsb3N1cmVfdHlw
ZShpbywgc3RydWN0IGRpcnR5X2lvLCBjbCk7DQogICAgc3RydWN0IGtleWJ1Zl9rZXkgKncg
PSBpby0+YmlvLmJpX3ByaXZhdGU7DQogICAgc3RydWN0IGNhY2hlZF9kZXYgKmRjID0gaW8t
PmRjOw0KDQogICAgYmlvX2ZyZWVfcGFnZXMoJmlvLT5iaW8pOw0KDQogICAgLyogVGhpcyBp
cyBraW5kIG9mIGEgZHVtYiB3YXkgb2Ygc2lnbmFsbGluZyBlcnJvcnMuICovDQogICAgaWYg
KEtFWV9ESVJUWSgmdy0+a2V5KSkgew0KICAgICAgICBpbnQgcmV0Ow0KICAgICAgICB1bnNp
Z25lZCBpbnQgaTsNCiAgICAgICAgc3RydWN0IGtleWxpc3Qga2V5czsNCg0KICAgICAgICBi
Y2hfa2V5bGlzdF9pbml0KCZrZXlzKTsNCg0KICAgICAgICBia2V5X2NvcHkoa2V5cy50b3As
ICZ3LT5rZXkpOw0KICAgICAgICBTRVRfS0VZX0RJUlRZKGtleXMudG9wLCBmYWxzZSk7DQog
ICAgICAgIGJjaF9rZXlsaXN0X3B1c2goJmtleXMpOw0KDQogICAgICAgIGZvciAoaSA9IDA7
IGkgPCBLRVlfUFRSUygmdy0+a2V5KTsgaSsrKQ0KICAgICAgICAgICAgYXRvbWljX2luYygm
UFRSX0JVQ0tFVChkYy0+ZGlzay5jLCAmdy0+a2V5LCBpKS0+cGluKTsNCg0KICAgICAgICBy
ZXQgPSBiY2hfYnRyZWVfaW5zZXJ0KGRjLT5kaXNrLmMsICZrZXlzLCBOVUxMLCAmdy0+a2V5
KTsNCg0KICAgICAgICBpZiAocmV0KQ0KICAgICAgICAgICAgdHJhY2VfYmNhY2hlX3dyaXRl
YmFja19jb2xsaXNpb24oJnctPmtleSk7DQoNCiAgICAgICAgYXRvbWljX2xvbmdfaW5jKHJl
dA0KICAgICAgICAgICAgICAgID8gJmRjLT5kaXNrLmMtPndyaXRlYmFja19rZXlzX2ZhaWxl
ZA0KICAgICAgICAgICAgICAgIDogJmRjLT5kaXNrLmMtPndyaXRlYmFja19rZXlzX2RvbmUp
Ow0KICAgIH0NCg0KICAgIGJjaF9rZXlidWZfZGVsKCZkYy0+d3JpdGViYWNrX2tleXMsIHcp
Ow0KICAgIHVwKCZkYy0+aW5fZmxpZ2h0KTsNCg0KICAgIGNsb3N1cmVfcmV0dXJuX3dpdGhf
ZGVzdHJ1Y3RvcihjbCwgZGlydHlfaW9fZGVzdHJ1Y3Rvcik7DQp9


