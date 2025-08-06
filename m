Return-Path: <linux-bcache+bounces-1179-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C135B1C4BF
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Aug 2025 13:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1C233BCF87
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Aug 2025 11:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC382222B4;
	Wed,  6 Aug 2025 11:20:40 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB1E19AD70;
	Wed,  6 Aug 2025 11:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754479240; cv=none; b=BRzja2AKH/2QSb0Rd1oh6sdRSggPYk8y/omKLXPU33Od72YvZev6jtW2OsUyMiqxhjnJbBxbNy3YTYbJP+XO6M6VfSwnBjg+zNde5U8pgcQlzR9uM6dIC7TAIhL0Z0wqb3Ibkb+ieNEHszo4bxI9VNFLgL/WAmz4G4CARmmt9LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754479240; c=relaxed/simple;
	bh=T/FeycaOrCdi0IMpMdbYirRnr9Ppd6J30vx+ufk4bjs=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=EpcMFeQvBB3TzRIkd1lrQBex65Y7knwYaMjph6VaCM3XbccK+uSUWoLySGm/1l97aUefkp/uQ2ajuW+oJ1Fbhdf+RbGuFFu8m9tCu54Ajbaaf9QIqXP+PuX0f2W5kwg10/Q4FHKLLTqYLeKvtwipwJYVwII6gYvDShWeXGhlkoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
EX-QQ-RecipientCnt: 4
X-QQ-GoodBg: 2
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqSYbfq2fqToiGQ640EZkclUqGZucf6tfws=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: O3swp8Bi3TUto1g4S/IosBUyQiakYglBAUEG73jZ1LI=
X-QQ-STYLE: 
X-QQ-mid: lv3sz3a-2t1754479190tee495441
From: "=?utf-8?B?WmhvdSBKaWZlbmc=?=" <zhoujifeng@kylinos.com.cn>
To: "=?utf-8?B?Q29seSBMaQ==?=" <colyli@kernel.org>
Cc: "=?utf-8?B?a2VudC5vdmVyc3RyZWV0?=" <kent.overstreet@linux.dev>, "=?utf-8?B?bGludXgtYmNhY2hl?=" <linux-bcache@vger.kernel.org>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
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
Date: Wed, 6 Aug 2025 19:19:49 +0800
X-Priority: 3
Message-ID: <tencent_59A1DBB462115B77340A389D@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
	<20250805045745.iu4ukc6tfdm3j7xn@P16.>
	<tencent_29AAD4111647BCD160DCFD85@qq.com>
	<20250805162915.3kaqbxjbwfuj6u6w@P16.>
In-Reply-To: <20250805162915.3kaqbxjbwfuj6u6w@P16.>
X-QQ-ReplyHash: 3935450540
X-BIZMAIL-ID: 7023397841355543708
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Wed, 06 Aug 2025 19:19:50 +0800 (CST)
Feedback-ID: lv:kylinos.com.cn:qybglogicsvrgz:qybglogicsvrgz5a-0
X-QQ-XMAILINFO: MSyoPQEuxKCuQ6mGOQGeY69CRd7BSKXwJ47tIAULGIzM/8oQeht2vVKo
	A599EpriYYFzJchImjhcb13rmkToxITk7ysJqqJMThdG96NWfccfrvNpOY9Jhu8iOaoAdF3
	tlLOE8KD1B5RZlF9AlnyAqDn2mehMideX1c3ucRNouJJAdCf1T0Q9yLi+5TPYWftxTJNZGQ
	oS8tx3c+ps5KS7Vc0NCTmm3cgjS96pt66CpFqZkEgIs6Vxwl3YG7opxmykHkYI0IFhp9bvS
	v2wePIgoBZ1fUkMptaw03KvVCZ+PivhLRBD9rFwihvIiaDx4f9hP/4wUdTVbPZp278BMml5
	b8GQgxyehO+DiTCzHA1EgEFrRGzz01RRmuEfl0azMqVd/MPm/8Ih+NvH3wU2hZqVXxfJ5IM
	S0tBG0j0s2dDgQJ7Gu/wxzYseyqxFo8pdfVDEcCoQpPfmyzkwNfENUZ9E9XnfMbH4/XsHi7
	iQ7Oop07e3Pgx32HJHCNCLfp6nYrE9H95Pjf3MHjTfeoROpCCMsjZKqfFqBomMp9vEeOOrm
	n2o3SZL7hwxcldY+cAqMQnppmr1FH8OHuKbVWYekvxttAXjEeGOogrYTSxfjyx/RTWG8Uxt
	AEC+IRTK1l7BCOrqeo0jarkKzREDZYZsDxebL0f82QcbspgvZyQNfGYCE2pZY74O1yYaNkC
	OkH3j7RL5HRcwwBJCvNSY24DxjTyCxbvPhnh7QZOzVP3rPUzmdKlHUgn8CcosFp2knmaL/L
	D89tl5SXkfe8F4m81Z4bLEqs0W97cugT+evuNaNtXq/E7nDbE6ezyVlztPFrQVrpQVcgo6Y
	dMK+nZET3BDUM/oxvClPVYUoEpNDEELrm4zdJRnpYIas3NkmdF8lQnFSqHBuwUYg9VDdzLO
	JRAngh9wHy/MVlwpQcj7frThX74oeI5fzORwpYTTxRWfnuGXtPsgCurfKexFGHRt7oCXLb6
	WTvn8qkx2WfPNO0Q/zfj+8Zz2zxBMwzsINDQNh1TFSfeQaJ9v6GiyEgv+gC4YMRBuj+xNMR
	9FQ1YYog==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0

T24gV2VkLCA2IEF1ZyAyMDI1IGF0IDAwOjI5LCBDb2x5IExpIDxjb2x5bGlAa2VybmVsLm9y
Zz4gd3JvdGU6DQo+DQo+IE9uIFR1ZSwgQXVnIDA1LCAyMDI1IGF0IDA1OjM3OjQ0UE0gKzA4
MDAsIFpob3UgSmlmZW5nIHdyb3RlOg0KPiA+IE9uIFR1ZSwgNSBBdWcgMjAyNSBhdCAxMzow
MCwgQ29seSBMaSA8Y29seWxpQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiA+ID4NCj4gPiA+IE9u
IFRodSwgSnVsIDMxLCAyMDI1IGF0IDAyOjIxOjQwUE0gKzA4MDAsIFpob3UgSmlmZW5nIHdy
b3RlOg0KPiA+ID4gPiBUaGVyZSBpcyBhIHBvdGVudGlhbCBkYXRhIGNvbnNpc3RlbmN5IHJp
c2sgaW4gYmNhY2hlJ3Mgd3JpdGViYWNrIG1vZGU6d2hlbg0KPiA+ID4gPiB0aGUgYXBwbGlj
YXRpb24gY2FsbHMgZnN5bmMsIGJjYWNoZSByZXR1cm5zIHN1Y2Nlc3MgYWZ0ZXIgY29tcGxl
dGluZyB0aGUNCj4gPiA+ID4gbG9nIHdyaXRlLCBwZXJzaXN0aW5nIHRoZSBjYWNoZSBkaXNr
IGRhdGEsIGFuZCBwZXJzaXN0aW5nIHRoZSBIREQgaW50ZXJuYWwNCj4gPiA+ID4gY2FjaGUu
IEhvd2V2ZXIsIGF0IHRoaXMgcG9pbnQsIHRoZSBhY3R1YWwgYXBwbGljYXRpb24gZGF0YSBt
YXkgc3RpbGwgYmUgaW4NCj4gPiA+ID4gYSBkaXJ0eSBzdGF0ZSBhbmQgcmVtYWluIHN0dWNr
IGluIHRoZSBjYWNoZSBkaXNrLiB3aGVuIHRoZXNlIGRhdGEgYXJlDQo+ID4gPiA+IHN1YnNl
cXVlbnRseSB3cml0dGVuIGJhY2sgdG8gdGhlIEhERCBhc3luY2hyb25vdXNseSB0aHJvdWdo
IFJFUV9PUF9XUklURSwNCj4gPiA+ID4gdGhlcmUgaXMgbm8gZm9yY2VkIHJlZnJlc2ggbWVj
aGFuaXNtIHRvIGVuc3VyZSBwaHlzaWNhbCBwbGFjZW1lbnQgb24gdGhlDQo+ID4gPiA+IGRp
c2ssIGFuZCB0aGVyZSBtYXkgYmUgbm8gcG93ZXItb2ZmIHByb3RlY3Rpb24gbWVhc3VyZXMs
IHdoaWNoIHBvc2VzIGEgcmlzaw0KPiA+ID4gPiBvZiBkYXRhIGxvc3MuIFRoaXMgbWVjaGFu
aXNtIG1heSBjYXVzZSB0aGUgYXBwbGljYXRpb24gdG8gbWlzanVkZ2UgdGhhdCB0aGUNCj4g
PiA+ID4gZGF0YSBoYXMgYmVlbiBwZXJzaXN0ZWQsIHdoaWNoIGlzIGRpZmZlcmVudCBmcm9t
IHRoZSBhY3R1YWwgc3RvcmFnZSBzdGF0ZSwNCj4gPiA+ID4gYW5kIGFsc28gdmlvbGF0ZXMg
dGhlIHNlbWFudGljIGFncmVlbWVudCB0aGF0IGZzeW5jIHNob3VsZCBlbnN1cmUgZGF0YQ0K
PiA+ID4gPiBwZXJzaXN0ZW5jZS4NCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBbc25pcHBlZF0N
Cj4gPiA+DQo+ID4gPg0KPiA+ID4NCj4gPiA+IElmIGJlZm9yZSB0aGUgY2xlYXJlZCBrZXkg
aW5zZXJ0ZWQgaW50byB0aGUgYnRyZWUsIHRoZXJlIGFyZSBuZXcgd3JpdGUNCj4gPiA+IGlu
dG8gb3ZlcmxhcHBlZCBMQkEgcmFuZ2Ugb2YgdGhlIGNsZWFyZWQga2V5IGFuZCBhIGRpcnR5
IGtleSBpbnNlcnRlZC4NCj4gPiA+IFRoZW4gdGhlIGNsZWFyZWQga2V5IGlzIGluc2VydGVk
IGFuZCBvdmVyd3JpdGVzIHRoZSBkaXJ0eSBrZXksIGJ1dCB0aGUNCj4gPiA+IGRpcnR5IGRh
dGEgb24gY2FjaGUgaXMgbm90IHdyaXR0ZW4gYmFjayB0byBiYWNraW5nIGRldmljZSB5ZXQu
IEhvdyB0bw0KPiA+ID4gaGFuZGxlIHN1Y2ggc2l0dWF0aW9uPw0KPiA+ID4NCj4gPg0KPiA+
IFRoZXJlIGFyZSBpbmRlZWQgc29tZSBpc3N1ZXMgaGVyZS4gSSBoYXZlIGluaXRpYWxseSBj
b21lIHVwIHdpdGggYQ0KPiA+IHNvbHV0aW9uOiBVdGlsaXplIHRoZSBleGlzdGluZyBkYy0+
d3JpdGViYWNrX2tleXMgbWVjaGFuaXNtIGZvcg0KPiA+IHByb3RlY3Rpb24uIFRoZSBnZW5l
cmFsIHByb2Nlc3NpbmcgZmxvdyBpcyBhcyBmb2xsb3dzOg0KPiA+IDEuIEluIHRoZSB3cml0
ZV9kaXJ0eV9maW5pc2goKSBmdW5jdGlvbiwgcmVtb3ZlIHRoZSBvcGVyYXRpb24gb2YNCj4g
PiB1cGRhdGluZyBia2V5IGluc2VydGlvbiwgYW5kIGRlbGV0ZSB0aGUgY29kZSBiY2hfa2V5
YnVmX2RlbCgmZGMNCj4gPiAtPndyaXRlYmFja19rZXlzLCB3KS4NCj4gPiAyLiBBZnRlciBl
eGVjdXRpbmcgdGhlIHJlYWRfZGlydHkoZGMpIGNvZGUsIHBlcmZvcm0gZmx1c2gsIHRoZW4N
Cj4gPiBpbnNlcnQgdGhlIHVwZGF0ZWQgYmtleSwgYW5kIGZpbmFsbHkgcmVtb3ZlIHRoZSBi
a2V5IGZyb20gZGMtPg0KPiA+IHdyaXRlYmFja19rZXlzLiBUaGlzIHByb2Nlc3MgaXMgZXF1
aXZhbGVudCB0byBzZW5kaW5nIGEgZmx1c2gNCj4gPiBldmVyeSBLRVlCVUZfTlIgYmtleXMg
YXJlIHdyaXR0ZW4gYmFjay4NCj4gPiAzLiBTdXBwb3J0IGNvbmZpZ3VyYWJsZSBLRVlCVUZf
TlIgdG8gaW5kaXJlY3RseSBjb250cm9sIHRoZQ0KPiA+IGZyZXF1ZW5jeSBvZiBmbHVzaC4N
Cj4gPg0KPiA+IElzIHRoaXMgcGxhbiBhcHByb3ByaWF0ZT8gT3IgYXJlIHRoZXJlIGFueSBi
ZXR0ZXIgd2F5cyB0byBoYW5kbGUgaXQ/DQo+DQo+IE5vLCBJIHdvbid0IHN1Z2dlc3QgdGhp
cyB3YXkuIEl0IHNvdW5kcyBjb21wbGljYWVkIGFuZCBjaGFuZ2VzIHRoZSBtYWluDQo+IGNv
ZGUgZmxvdyB0b28gbXVjaCBpbiBhbiBpbXBsaWNpdCB3YXksIHRoaXMgc2hvdWxkIGJlIGF2
b2lkZWQuDQo+DQo+IFNvIGl0IHNlZW1zIEtlbnQncyBzdWdnZXN0aW9uIHRvIGZsdXNoIGJh
Y2tpbmcgZGV2aWNlIGJlZm9yZSBjb21taXR0aW5nDQo+IGpzZXQgaXMgdGhlIHByb3BlciBt
ZXRob2QgSSBjYW4gc2VlIG5vdy4NCj4NCj4gQ29seSBMaQ0KPg0KDQpTb3JyeSwgbXkgcHJl
dmlvdXMgcmVzcG9uc2Ugd2FzIG5vdCByaWdvcm91cyBlbm91Z2guIEkgaGF2ZSBjYXJlZnVs
bHkNCmNvbnNpZGVyZWQgeW91ciBxdWVzdGlvbiBhYm91dCAidGhlIGJrZXkgYmVpbmcgb3Zl
cndyaXR0ZW4iLiBJbiBmYWN0LA0KdGhlcmUgaXMgbm8gaXNzdWUgb2YgYmVpbmcgb3Zlcndy
aXR0ZW4uIFRoZSBiY2FjaGUgaGFzIGluZ2VuaW91c2x5DQpkZXNpZ25lZCBhIHJlcGxhY2Ug
bWVjaGFuaXNtLiBJbiBteSBjb2RlLCB0aGUgYmtleSB3aXRoIHRoZSBkaXJ0eSBmbGFnDQpj
bGVhcmVkIGlzIGluc2VydGVkIHVzaW5nIHRoZSByZXBsYWNlIG1ldGhvZC4gVGhpcyBtZXRo
b2QgaGFuZGxlcw0KYWRkcmVzcyBvdmVybGFwcyBpbmdlbmlvdXNseSBkdXJpbmcgdGhlIGlu
c2VydGlvbiBvZiB0aGUgYmtleSBhbmQgd2lsbA0Kbm90IG92ZXJ3cml0ZSB0aGUgYmtleSBn
ZW5lcmF0ZWQgYnkgY29uY3VycmVudCB3cml0ZXMuIFRoZSBtYWluIGNvZGUNCmZvciB0aGUg
cmVwbGFjZSBtZWNoYW5pc20gaXMgbG9jYXRlZCBpbiBiY2hfYnRyZWVfaW5zZXJ0X2tleS0+
YmNoX2V4dGVudF9pbnNlcnRfZml4dXANCiwgd2hpY2ggY2FsbHMgdGhlIGJjaF9ia2V5X2Vx
dWFsX2hlYWRlciBmdW5jdGlvbiwgd2hpY2ggaXMgYWxzbyBhDQpjcnVjaWFsIGNoZWNrcG9p
bnQu


