Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F2C31A1BB
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Feb 2021 16:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhBLPc6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 Feb 2021 10:32:58 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:28149 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232096AbhBLPcz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Feb 2021 10:32:55 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-7-JP_7B2LuPXKpBjoyLqlaog-1;
 Fri, 12 Feb 2021 15:31:17 +0000
X-MC-Unique: JP_7B2LuPXKpBjoyLqlaog-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 12 Feb 2021 15:31:16 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 12 Feb 2021 15:31:16 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Coly Li' <colyli@suse.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] bcache: Use 64-bit arithmetic instead of 32-bit
Thread-Topic: [PATCH][next] bcache: Use 64-bit arithmetic instead of 32-bit
Thread-Index: AQHXAUq33fUjMDIuaUm57r6l5bDb0apUpJ4g
Date:   Fri, 12 Feb 2021 15:31:16 +0000
Message-ID: <0a2eb2e143ad480cbce3f84c3c920b5f@AcuMS.aculab.com>
References: <20210212125028.GA264620@embeddedor>
 <ea24a361-ab1f-a330-b5e6-007bb9a1013b@suse.de>
In-Reply-To: <ea24a361-ab1f-a330-b5e6-007bb9a1013b@suse.de>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

PiA+ICAJCWlmIChjLT5nY19zdGF0cy5pbl91c2UgPD0gQkNIX1dSSVRFQkFDS19GUkFHTUVOVF9U
SFJFU0hPTERfTUlEKSB7DQo+ID4gLQkJCWZwX3Rlcm0gPSBkYy0+d3JpdGViYWNrX3JhdGVfZnBf
dGVybV9sb3cgKg0KPiA+ICsJCQlmcF90ZXJtID0gKGludDY0X3QpZGMtPndyaXRlYmFja19yYXRl
X2ZwX3Rlcm1fbG93ICoNCj4gPiAgCQkJKGMtPmdjX3N0YXRzLmluX3VzZSAtIEJDSF9XUklURUJB
Q0tfRlJBR01FTlRfVEhSRVNIT0xEX0xPVyk7DQo+ID4gIAkJfSBlbHNlIGlmIChjLT5nY19zdGF0
cy5pbl91c2UgPD0gQkNIX1dSSVRFQkFDS19GUkFHTUVOVF9USFJFU0hPTERfSElHSCkgew0KPiA+
IC0JCQlmcF90ZXJtID0gZGMtPndyaXRlYmFja19yYXRlX2ZwX3Rlcm1fbWlkICoNCj4gPiArCQkJ
ZnBfdGVybSA9IChpbnQ2NF90KWRjLT53cml0ZWJhY2tfcmF0ZV9mcF90ZXJtX21pZCAqDQo+ID4g
IAkJCShjLT5nY19zdGF0cy5pbl91c2UgLSBCQ0hfV1JJVEVCQUNLX0ZSQUdNRU5UX1RIUkVTSE9M
RF9NSUQpOw0KPiA+ICAJCX0gZWxzZSB7DQo+ID4gLQkJCWZwX3Rlcm0gPSBkYy0+d3JpdGViYWNr
X3JhdGVfZnBfdGVybV9oaWdoICoNCj4gPiArCQkJZnBfdGVybSA9IChpbnQ2NF90KWRjLT53cml0
ZWJhY2tfcmF0ZV9mcF90ZXJtX2hpZ2ggKg0KPiA+ICAJCQkoYy0+Z2Nfc3RhdHMuaW5fdXNlIC0g
QkNIX1dSSVRFQkFDS19GUkFHTUVOVF9USFJFU0hPTERfSElHSCk7DQo+ID4gIAkJfQ0KPiA+ICAJ
CWZwcyA9IGRpdl9zNjQoZGlydHksIGRpcnR5X2J1Y2tldHMpICogZnBfdGVybTsNCj4gPg0KPiAN
Cj4gSG1tLCBzaG91bGQgc3VjaCB0aGluZyBiZSBoYW5kbGVkIGJ5IGNvbXBpbGVyID8gIE90aGVy
d2lzZSB0aGlzIGtpbmQgb2YNCj4gcG90ZW50aWFsIG92ZXJmbG93IGlzc3VlIHdpbGwgYmUgZW5k
bGVzcyB0aW1lIHRvIHRpbWUuDQo+IA0KPiBJIGFtIG5vdCBhIGNvbXBpbGVyIGV4cGVydCwgc2hv
dWxkIHdlIGhhdmUgdG8gZG8gc3VjaCBleHBsaWNpdCB0eXBlIGNhc3QNCj4gYWxsIHRoZSB0aW1l
ID8NCg0KV2UgZG8gdG8gZ2V0IGEgNjRiaXQgcHJvZHVjdCBmcm9tIHR3byAzMmJpdCB2YWx1ZXMu
DQpBbiBhbHRlcm5hdGl2ZSBmb3IgdGhlIGFib3ZlIHdvdWxkIGJlOg0KCQlmcF90ZXJtID0gYy0+
Z2Nfc3RhdHMuaW5fdXNlIC0gQkNIX1dSSVRFQkFDS19GUkFHTUVOVF9USFJFU0hPTERfSElHSDsN
CgkJZnBfdGVybSAqPSBkYy0+d3JpdGViYWNrX3JhdGVfZnBfdGVybV9oaWdoOw0KDQpJIGhvcGUg
QkNIX1dSSVRFQkFDS19GUkFHTUVOVF9USFJFU0hPTERfTE9XIGlzIHplcm8gOi0pDQoNCglEYXZp
ZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQg
RmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4
NiAoV2FsZXMpDQo=

