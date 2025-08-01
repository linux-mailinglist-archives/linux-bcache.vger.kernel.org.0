Return-Path: <linux-bcache+bounces-1161-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BFA7B17B2B
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Aug 2025 04:28:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 912417B1A4A
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Aug 2025 02:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F12131E2D;
	Fri,  1 Aug 2025 02:28:14 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C45423A6;
	Fri,  1 Aug 2025 02:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754015294; cv=none; b=qRK0tssepAQbknqyRWr7sc+EOVeAYCYbWlSNZyDoHS2sKGjPjDDD2mAitBqAvM6IL4y1ZsEnLLKpuBQtUyo3CMdfkFxyAqD46/9molsME6O8oxqUYU/1V+KvscddICQ+jEZtqmKogoD+0Rn2NMELf5bMWM1Jp8mIT6yxQSTnxL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754015294; c=relaxed/simple;
	bh=Xn4mV7aHXfSVKgMv9RLPLYM7eVtQItAQwiO2SogTiaY=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=YGr/m9qFtMwDFTVzq4hq3Meb6aM8Fvzs0ss8ixb3GvTZsigNpbnFCpA0U4QhNsXuJxUNWkIDvEtJNmAyUDV65D0EqjoTUiVW40HiDBWblEq/Qng4ULu9KDQLZaDP3DuLFkvEVPMsz6ryoPYxyyTBu4vJgXjdpgi320hWFDsx/b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
EX-QQ-RecipientCnt: 4
X-QQ-GoodBg: 2
X-QQ-SSF: 00400000000000F0
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-FEAT: D4aqtcRDiqT0lIevWKG+BWOIYOYYzrVdtBspb4IB9XY=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: hleaaUOK4RmMpSdcyLnN6Ey8+zGngW1fwLAXS9beDPU=
X-QQ-STYLE: 
X-QQ-mid: lv3sz3a-2t1754015241tc9f292a6
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
Date: Fri, 1 Aug 2025 10:27:21 +0800
X-Priority: 3
Message-ID: <tencent_656F159830BC538C2D26CD68@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
	<etlu4r6gxbe2jc3eemj3n4slg6xraxtxxydvxvmhv77xv42uss@7aw3yxbdgrdl>
In-Reply-To: <etlu4r6gxbe2jc3eemj3n4slg6xraxtxxydvxvmhv77xv42uss@7aw3yxbdgrdl>
X-QQ-ReplyHash: 384284173
X-BIZMAIL-ID: 5042854451379478983
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Fri, 01 Aug 2025 10:27:22 +0800 (CST)
Feedback-ID: lv:kylinos.com.cn:qybglogicsvrgz:qybglogicsvrgz5a-0
X-QQ-XMAILINFO: NrFXfVzfO8bEyKAunDzb5Tl0juffVS5iaqjyHFh+GxIUAAh7Y7M/MX3w
	m/AZSx5dC6umpbcK1lUdx9n7Ai0w8HlNhz9b0VNTeEFXEmm96yLew1A83eyQcUbvRxJ2yWQ
	gxgjSBQNXjSjLNPmgkYXI0QJDlYgWiP9PGfLrJn1sADUEyfK6RjIl0fr6ot8zqd/F5IwSZW
	UF6xq2bt2PVQtgAGVpXBDp0GTPd+rRDYHSLmLp/CyZ3BMY2asv4ORiXycd9Gm19fsWTmwsQ
	BTTzWRDl/y8azTT6/E83nZ/uEfDnGpmWj/9shQH1LKI5v8uqrVBJs9XKw0lH7ihwUYzE1TV
	ng1X/O7YQ5xn+Zw03l/rffYivc5bwtONgu5fjlzV99jThO1QiiS96Z3doqo+i3pSLk9hFiT
	Y7tEUAvCJEdCbdDRrwyCEPIpM651KT+JUbuQiuEbyRiy4xzOsmFe7jpmavejWGn60uKbqKd
	R5nl6L+Pu5SQA6cOvQHAlEs1E+wSrv+lifOo548WdV6K6aRuCe0HlMch1oQqT9HSh0d5sFW
	5RRXqYfjQUegnJLV3yT34j86aGeQ0hZ2f2Dv5a/+yTRMzh+JcaESgwm4CqPgfFcUpaPSr8r
	/Pg23EQYXV8kaQorpk/fSF86vybukAX50Nrm2G5FDf4gs0cyK6FqjtVSDz5i63H9Yk9l7wO
	CV9S/+jAKprsKE+dadsF/BWdpi9eZKodST4V43LYKeOM7pa60RECGHqFLi9zBCTNwrdIrz5
	t5j1OzSvJfGf2Q6ScW9TXHpWn6Mj7HzIM/NNDi8AwMOoHUT+1g0o/HETFMIz6ivsHamNLWE
	RjUBUC8RgeNNraTvDm68TmAx2EIY0cK4C/uFV4nVH6VcyavN80sSMgukJPRNRKxAq6X/nLn
	yhTTl1TaFFUNIp4Ux3AKFupQp71tGjBYvp7msVPbCiQP9GajAorwEPIlY/SrEH0YKeYc8WO
	12nc1UPqyha/ArI2u6tGSpkYSwB7ab4M/r8PmMJeYDu0pwTF8OHCrv35KypRdSO9JDAfjo1
	bIBpSemA==
X-QQ-RECHKSPAM: 0

T24gRnJpLCAxIEF1ZyAyMDI1IGF0IDAwOjAyLCBLZW50IE92ZXJzdHJlZXQgPGtlbnQub3Zl
cnN0cmVldEBsaW51eC5kZXY+IHdyb3RlOg0KPg0KPiBPbiBUaHUsIEp1bCAzMSwgMjAyNSBh
dCAwMjoyMTo0MFBNICswODAwLCBaaG91IEppZmVuZyB3cm90ZToNCj4gPiBUaGVyZSBpcyBh
IHBvdGVudGlhbCBkYXRhIGNvbnNpc3RlbmN5IHJpc2sgaW4gYmNhY2hlJ3Mgd3JpdGViYWNr
IG1vZGU6d2hlbg0KPiA+IHRoZSBhcHBsaWNhdGlvbiBjYWxscyBmc3luYywgYmNhY2hlIHJl
dHVybnMgc3VjY2VzcyBhZnRlciBjb21wbGV0aW5nIHRoZQ0KPiA+IGxvZyB3cml0ZSwgcGVy
c2lzdGluZyB0aGUgY2FjaGUgZGlzayBkYXRhLCBhbmQgcGVyc2lzdGluZyB0aGUgSEREIGlu
dGVybmFsDQo+ID4gY2FjaGUuIEhvd2V2ZXIsIGF0IHRoaXMgcG9pbnQsIHRoZSBhY3R1YWwg
YXBwbGljYXRpb24gZGF0YSBtYXkgc3RpbGwgYmUgaW4NCj4gPiBhIGRpcnR5IHN0YXRlIGFu
ZCByZW1haW4gc3R1Y2sgaW4gdGhlIGNhY2hlIGRpc2suIHdoZW4gdGhlc2UgZGF0YSBhcmUN
Cj4gPiBzdWJzZXF1ZW50bHkgd3JpdHRlbiBiYWNrIHRvIHRoZSBIREQgYXN5bmNocm9ub3Vz
bHkgdGhyb3VnaCBSRVFfT1BfV1JJVEUsDQo+ID4gdGhlcmUgaXMgbm8gZm9yY2VkIHJlZnJl
c2ggbWVjaGFuaXNtIHRvIGVuc3VyZSBwaHlzaWNhbCBwbGFjZW1lbnQgb24gdGhlDQo+ID4g
ZGlzaywgYW5kIHRoZXJlIG1heSBiZSBubyBwb3dlci1vZmYgcHJvdGVjdGlvbiBtZWFzdXJl
cywgd2hpY2ggcG9zZXMgYSByaXNrDQo+ID4gb2YgZGF0YSBsb3NzLiBUaGlzIG1lY2hhbmlz
bSBtYXkgY2F1c2UgdGhlIGFwcGxpY2F0aW9uIHRvIG1pc2p1ZGdlIHRoYXQgdGhlDQo+ID4g
ZGF0YSBoYXMgYmVlbiBwZXJzaXN0ZWQsIHdoaWNoIGlzIGRpZmZlcmVudCBmcm9tIHRoZSBh
Y3R1YWwgc3RvcmFnZSBzdGF0ZSwNCj4gPiBhbmQgYWxzbyB2aW9sYXRlcyB0aGUgc2VtYW50
aWMgYWdyZWVtZW50IHRoYXQgZnN5bmMgc2hvdWxkIGVuc3VyZSBkYXRhDQo+ID4gcGVyc2lz
dGVuY2UuDQo+DQo+IFNvLCB0aGUgd2F5IHlvdSBzdGFydCBvdXQgZGVzY3JpYmluZyB0aGUg
cGF0Y2gsIGl0IHNvdW5kcyBsaWtlIHlvdSdyZQ0KPiBhZGRyZXNzaW5nIHNvbWUgc29ydCBv
ZiBidWcgaW4gUkVRX09QX0ZMVVNIIGhhbmRsaW5nLCBidXQgaXQgbG9va3MgbGlrZQ0KPiB3
aGF0IHlvdSdyZSBhY3R1YWxseSBkb2luZyBpcyBhZGRpbmcgYSBtb2RlIHdoZXJlIGZsdXNo
ZXMgYWxzbyBmbHVzaA0KPiBiY2FjaGU/DQo+DQo+IFRoaXMgZG9lc24ndCBzb3VuZCBsaWtl
IGEgYnVnZml4LCB0aGlzIHNvdW5kcyBsaWtlIGEgY29tcGxldGVseSBuZXcNCj4gbW9kZSAt
IHdlJ2QgbmVlZCBhbiBleHBsYW5hdGlvbiBvZiB0aGUgdXNlIGNhc2UgeW91J3JlIGFpbWlu
ZyBmb3IuDQoNClllcywgdGhpcyBpcyBub3QgYWJvdXQgdHJ5aW5nIHRvIGZpeCBhIHBhcnRp
Y3VsYXIgZGVmZWN0LiBJbnN0ZWFkLCBpdCBpcyBhYm91dA0KYWRkaW5nIGEgbmV3IG1ldGhv
ZCB3aXRoaW4gdGhlIGN1cnJlbnQgd3JpdGViYWNrIG1vZGUgdG8gbWFrZSB0aGUNCnByb2Nl
c3Mgb2Ygd3JpdGluZyBkaXJ0eSBkYXRhIGluIHRoZSBjYWNoZSB0byB0aGUgSEREIG1vcmUg
cmVsaWFibGUuDQoNCj4gVGhlIG1vZGVsIGZvciBiY2FjaGUgaGFzIGFsd2F5cyBiZWVuIHRo
YXQgc2luY2UgdGhlIGNhY2hlIGlzIHBlcnNpc3RlbnQsDQo+IHdoZW4geW91J3JlIGluIHdy
aXRlYmFjayBtb2RlIHRoZXJlIGFyZSBubyBmc3luYy9SRVFfT1BfRkxVU0gNCj4gY29uc2lk
ZXJhdGlvbnMgZm9yIGRpcnR5IGRhdGE7IG9uY2Ugd2UndmUgcHJvcGVybHkgcGVyc2lzdGVk
IChhbmQNCj4gZmx1c2hlZCkgdGhhdCBkYXRhIHdlJ3JlIGdvb2QuDQoNCkluIHRoZSB3cml0
ZWJhY2sgbW9kZSwgdGhlIGN1cnJlbnQgYmNhY2hlIGNvZGUgdXNlcyB0aGUNClJFUV9PUF9X
UklURSBvcGVyYXRpb24gdG8gaGFuZGxlIGRpcnR5IGRhdGEsIGFuZCBjbGVhcnMgdGhlIGJr
ZXkNCmRpcnR5IGZsYWcgaW4gdGhlIGJ0cmVlIGR1cmluZyB0aGUgYmlvIGNvbXBsZXRpb24g
Y2FsbGJhY2suIEkgdGhpbmsNCnRoZXJlIG1pZ2h0IGJlIGEgcG90ZW50aWFsIHJpc2s6IGlm
IGluIHRoZSBldmVudCBvZiBhbiB1bmV4cGVjdGVkDQpwb3dlciBvdXRhZ2UsIHRoZSBkYXRh
IGluIHRoZSBIREQgaGFyZHdhcmUgY2FjaGUgbWF5IG5vdCBoYXZlDQpoYWQgdGltZSB0byBi
ZSBwZXJzaXN0ZWQsIHRoZW4gdGhlIGRhdGEgaW4gdGhlIEhERCBoYXJkd2FyZSBjYWNoZQ0K
dGhhdCBpcyBwZW5kaW5nIHByb2Nlc3NpbmcgbWF5IGJlIGxvc3QuIFNpbmNlIGF0IHRoaXMg
dGltZSB0aGUgYmtleQ0KZGlydHkgZmxhZyBpbiB0aGUgYnRyZWUgaGFzIGJlZW4gY2xlYXJl
ZCwgdGhlIGRhdGEgc3RhdHVzIHJlY29yZGVkDQpieSB0aGUgYmtleSBkb2VzIG5vdCBtYXRj
aCB0aGUgYWN0dWFsIHNpdHVhdGlvbiBvZiB0aGUgU1NEIGFuZA0KSERELg0KQW0gSSB1bmRl
cnN0YW5kaW5nIHRoaXMgY29ycmVjdGx5Pw0KDQo+IElmIHlvdSB3YW50IGEgbW9kZSB3aGVy
ZSB5b3UgY2FuIHJ1biBpbiB3cml0ZWJhY2sgbW9kZSwgYnV0IG9iZXkgZmx1c2hlcw0KPiBz
byB0aGF0IGl0J3Mgc3RpbGwgc2FmZSB0byBsb3NlIG9yIHlhbmsgdGhlIGNhY2hlIGRldmlj
ZSAtIGlzIHRoYXQgd2hhdA0KPiB5b3UncmUgYWZ0ZXI/DQoNCldoZW4gZGlydHkgZGF0YSBp
cyB0ZW1wb3JhcmlseSBzdG9yZWQgaW4gdGhlIEhERCBoYXJkd2FyZSBjYWNoZSAobm90DQpw
ZXJzaXN0ZWR0byB0aGUgZGlzayBtZWRpdW0pLCBpZiBhbiB1bmV4cGVjdGVkIHBvd2VyIG91
dGFnZSBvciB1bnBsdWdnaW5nDQpvY2N1cnMsIHRoZSBkYXRhIGluIHRoZSBIREQgaGFyZHdh
cmUgY2FjaGUgbWF5IGJlIGxvc3QuIElmIHN1Y2ggYSBzY2VuYXJpbw0Kb2NjdXJzLCBzaW5j
ZSB0aGVkaXJ0eSBmbGFnIG9mIHRoZSBia2V5IGluIHRoZSBidHJlZSBoYXMgYmVlbiBjbGVh
cmVkIGF0IHRoaXMNCnRpbWUsIGJ1dCB0aGUgYWN0dWFsIGRpcnR5ZGF0YSBjb3JyZXNwb25k
aW5nIHRvIHRoZSBia2V5IGhhcyBub3QgYmVlbg0Kc3VjY2Vzc2Z1bGx5IHdyaXR0ZW4gYmFj
ayB0byB0aGUgSERELiBJIHdhbnQgdG8gdXNlIGEgbWV0aG9kIHRvIGF2b2lkIHRoaXMNCnNp
dHVhdGlvbi4=


