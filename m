Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E1731A30D
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Feb 2021 17:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhBLQo1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 Feb 2021 11:44:27 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:36914 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229977AbhBLQoQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Feb 2021 11:44:16 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-262-cLzRw_uIPoO1pDyclYXeKQ-1; Fri, 12 Feb 2021 16:42:28 +0000
X-MC-Unique: cLzRw_uIPoO1pDyclYXeKQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 12 Feb 2021 16:42:21 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 12 Feb 2021 16:42:21 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dongdong tao <dongdong.tao@canonical.com>
Subject: RE: [PATCH][next] bcache: Use 64-bit arithmetic instead of 32-bit
Thread-Topic: [PATCH][next] bcache: Use 64-bit arithmetic instead of 32-bit
Thread-Index: AQHXAUq33fUjMDIuaUm57r6l5bDb0apUpJ4ggAAJh4CAAAZ5cA==
Date:   Fri, 12 Feb 2021 16:42:21 +0000
Message-ID: <468c8699c8ea445cac433406be983e79@AcuMS.aculab.com>
References: <20210212125028.GA264620@embeddedor>
 <ea24a361-ab1f-a330-b5e6-007bb9a1013b@suse.de>
 <0a2eb2e143ad480cbce3f84c3c920b5f@AcuMS.aculab.com>
 <cb3ffad1-e877-c6f9-168e-da7f55c59485@suse.de>
In-Reply-To: <cb3ffad1-e877-c6f9-168e-da7f55c59485@suse.de>
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

RnJvbTogQ29seSBMaSA8Y29seWxpQHN1c2UuZGU+DQo+IFNlbnQ6IDEyIEZlYnJ1YXJ5IDIwMjEg
MTY6MDINCj4gDQo+IE9uIDIvMTIvMjEgMTE6MzEgUE0sIERhdmlkIExhaWdodCB3cm90ZToNCj4g
Pj4+ICAJCWlmIChjLT5nY19zdGF0cy5pbl91c2UgPD0gQkNIX1dSSVRFQkFDS19GUkFHTUVOVF9U
SFJFU0hPTERfTUlEKSB7DQo+ID4+PiAtCQkJZnBfdGVybSA9IGRjLT53cml0ZWJhY2tfcmF0ZV9m
cF90ZXJtX2xvdyAqDQo+ID4+PiArCQkJZnBfdGVybSA9IChpbnQ2NF90KWRjLT53cml0ZWJhY2tf
cmF0ZV9mcF90ZXJtX2xvdyAqDQo+ID4+PiAgCQkJKGMtPmdjX3N0YXRzLmluX3VzZSAtIEJDSF9X
UklURUJBQ0tfRlJBR01FTlRfVEhSRVNIT0xEX0xPVyk7DQo+ID4+PiAgCQl9IGVsc2UgaWYgKGMt
PmdjX3N0YXRzLmluX3VzZSA8PSBCQ0hfV1JJVEVCQUNLX0ZSQUdNRU5UX1RIUkVTSE9MRF9ISUdI
KSB7DQo+ID4+PiAtCQkJZnBfdGVybSA9IGRjLT53cml0ZWJhY2tfcmF0ZV9mcF90ZXJtX21pZCAq
DQo+ID4+PiArCQkJZnBfdGVybSA9IChpbnQ2NF90KWRjLT53cml0ZWJhY2tfcmF0ZV9mcF90ZXJt
X21pZCAqDQo+ID4+PiAgCQkJKGMtPmdjX3N0YXRzLmluX3VzZSAtIEJDSF9XUklURUJBQ0tfRlJB
R01FTlRfVEhSRVNIT0xEX01JRCk7DQo+ID4+PiAgCQl9IGVsc2Ugew0KPiA+Pj4gLQkJCWZwX3Rl
cm0gPSBkYy0+d3JpdGViYWNrX3JhdGVfZnBfdGVybV9oaWdoICoNCj4gPj4+ICsJCQlmcF90ZXJt
ID0gKGludDY0X3QpZGMtPndyaXRlYmFja19yYXRlX2ZwX3Rlcm1faGlnaCAqDQo+ID4+PiAgCQkJ
KGMtPmdjX3N0YXRzLmluX3VzZSAtIEJDSF9XUklURUJBQ0tfRlJBR01FTlRfVEhSRVNIT0xEX0hJ
R0gpOw0KPiA+Pj4gIAkJfQ0KPiA+Pj4gIAkJZnBzID0gZGl2X3M2NChkaXJ0eSwgZGlydHlfYnVj
a2V0cykgKiBmcF90ZXJtOw0KPiA+Pj4NCj4gPj4NCj4gPj4gSG1tLCBzaG91bGQgc3VjaCB0aGlu
ZyBiZSBoYW5kbGVkIGJ5IGNvbXBpbGVyID8gIE90aGVyd2lzZSB0aGlzIGtpbmQgb2YNCj4gPj4g
cG90ZW50aWFsIG92ZXJmbG93IGlzc3VlIHdpbGwgYmUgZW5kbGVzcyB0aW1lIHRvIHRpbWUuDQo+
ID4+DQo+ID4+IEkgYW0gbm90IGEgY29tcGlsZXIgZXhwZXJ0LCBzaG91bGQgd2UgaGF2ZSB0byBk
byBzdWNoIGV4cGxpY2l0IHR5cGUgY2FzdA0KPiA+PiBhbGwgdGhlIHRpbWUgPw0KPiA+DQo+IA0K
PiBIaSBEYXZpZCwNCj4gDQo+IEkgYWRkIERvbmdkb25nIFRhbyBDY2VkLCB3aG8gaXMgYXV0aG9y
IG9mIHRoaXMgcGF0Y2guDQo+IA0KPiBDb3VsZCB5b3UgcGxlYXNlIG9mZmVyIG1lIG1vcmUgaW5m
b3JtYXRpb24gYWJvdXQgdGhlIGZvbGxvd2luZyBsaW5lcz8NCj4gTGV0IG1lIGFzayBtb3JlIGZv
ciBteSBxdWVzdGlvbnMuDQo+IA0KPiA+IFdlIGRvIHRvIGdldCBhIDY0Yml0IHByb2R1Y3QgZnJv
bSB0d28gMzJiaXQgdmFsdWVzLg0KPiA+IEFuIGFsdGVybmF0aXZlIGZvciB0aGUgYWJvdmUgd291
bGQgYmU6DQo+ID4gCQlmcF90ZXJtID0gYy0+Z2Nfc3RhdHMuaW5fdXNlIC0gQkNIX1dSSVRFQkFD
S19GUkFHTUVOVF9USFJFU0hPTERfSElHSDsNCj4gPiAJCWZwX3Rlcm0gKj0gZGMtPndyaXRlYmFj
a19yYXRlX2ZwX3Rlcm1faGlnaDsNCj4gDQo+IFRoZSBvcmlnaW5hbCBsaW5lIGlzLA0KPiBmcF90
ZXJtID0gZGMtPndyaXRlYmFja19yYXRlX2ZwX3Rlcm1faGlnaCAqIChjLT5nY19zdGF0cy5pbl91
c2UgLQ0KPiBCQ0hfV1JJVEVCQUNLX0ZSQUdNRU5UX1RIUkVTSE9MRF9ISUdIKQ0KPiANCj4gVGhl
IGZpcnN0IHZhbHVlIGRjLT53cml0ZWJhY2tfcmF0ZV9mcF90ZXJtX2hpZ2ggaXMgdW5zaWduZWQg
aW50ICgzMmJpdCksDQo+IGFuZCB0aGUgc2Vjb25kIHZhbHVlIChjLT5nY19zdGF0cy5pbl91c2Ug
LQ0KPiBCQ0hfV1JJVEVCQUNLX0ZSQUdNRU5UX1RIUkVTSE9MRF9ISUdIKSBpcyB1bnNpZ25lZCBp
bnQgKDMyYml0KSB0b28uIEFuZA0KPiBmcF90ZXJtIGlzIDY0Yml0LCBpZiB0aGUgcHJvZHVjdCBp
cyBsYXJnZXIgdGhhbiAzMmJpdHMsIHRoZSBjb21waWxlcg0KPiBzaG91bGQga25vdyBmcF90ZXJt
IGlzIDY0Yml0IGFuZCB1cGdyYWRlIHRoZSBwcm9kdWN0IHRvIDY0Yml0Lg0KPiANCj4gVGhlIGFi
b3ZlIGlzIGp1c3QgbXkgZ3Vlc3MsIGJlY2F1c2UgSSBmZWVsIGNvbXBpbGluZyBzaG91bGQgaGF2
ZSB0aGUNCj4gY2x1ZSBmb3IgdGhlIHByb2R1Y3QgdXBncmFkZSB0byBhdm9pZCBvdmVyZmxvdy4g
QnV0IEkgYWxtb3N0IGtub3cNCj4gbm90aGluZyBhYm91dCBjb21waWxlciBpbnRlcm5hbCAuLi4u
DQoNCk5vLCB0aGUgZXhwcmVzc2lvbiBpcyBldmFsdWF0ZWQgYXMgMzJiaXQgYW5kIHRoZW4gZXh0
ZW5kZWQgZm9yIHRoZSBhc3NpZ25tZW50Lg0KDQpPciwgbW9yZSBjb3JyZWN0bHksIGludGVnZXIg
dmFyaWFibGVzIHNtYWxsZXIgdGhhbiBpbnQgKHVzdWFsbHkgc2hvcnQgYW5kIGNoYXIpDQphcmUg
ZXh0ZW5kZWQgdG8gaW50IHByaW9yIHRvIGFueSBhcml0aG1ldGljLg0KSWYgb25lIGFyZ3VtZW50
IHRvIGFuIG9wZXJhdG9yIGlzIGxhcmdlciB0aGFuIGludCBpdCBpcyBleHRlbmRlZC4NCklmIHRo
ZXJlIGlzIGEgc2lnbiB2IHVuc2lnbmVkIG1pc21hdGNoIHRoZSBzaWduZWQgdmFsdWUgaXMgY2Fz
dCB0byB1bnNpZ25lZA0KKHNhbWUgYml0IHBhdHRlcm4gb24gMidzIGNvbXBsaW1lbnQgc3lzdGVt
cykuDQoNClRoZXJlIGFyZSBzb21lIG9kZGl0aWVzOg0KLSAndW5zaWduZWQgY2hhci9zaG9ydCcg
Z2V0cyBjb252ZXJ0ZWQgdG8gJ3NpZ25lZCBpbnQnIHVubGVzcw0KICBjaGFyL3Nob3J0IGFuZCBp
bnQgYXJlIHRoZSBzYW1lIHNpemUgKHdoaWNoIGlzIGFsbG93ZWQpLg0KICAoQWx0aG91Z2ggaWYg
Y2hhciBhbmQgaW50IGFyZSB0aGUgc2FtZSBzaXplIHRoZXJlIGFyZSBpc3N1ZXMNCiAgd2l0aCB0
aGUgdmFsdWUgZm9yIEVPRi4pDQotICgxIDw8IDMxKSBpcyBhIHNpZ25lZCBpbnRlZ2VyLCBpdCB3
aWxsIGdldCBzaWduIGV4dGVuZGVkIGlmIHVzZWQNCiAgdG8gbWFzayBhIDY0Yml0IHZhbHVlLg0K
DQpLJlIgQyBjb252ZXJ0ZWQgJ3Vuc2lnbmVkIGNoYXInIHRvICd1bnNpZ25lZCBpbnQnIC0gYnV0
IHRoZSBBTlNJDQpzdGFuZGFyZHMgYm9keSBkZWNpZGVkIG90aGVyd2lzZS4NCg0KVGhlIGNvbXBp
bGVyIGlzIGFsbG93ZWQgdG8gdXNlIGFuICdhcyBpZicgcnVsZSB0byB1c2UgdGhlIDhiaXQgYW5k
DQoxNmJpdCBhcml0aG1ldGljL3JlZ2lzdGVycyBvbiB4ODYuDQpCdXQgb24gYWxtb3N0IGV2ZXJ5
dGhpbmcgZWxzZSBhcml0aG1ldGljIG9uIGNoYXIvc2hvcnQgbG9jYWwgdmFyaWFibGVzDQpyZXF1
aXJlcyB0aGUgY29tcGlsZXIgcmVwZWF0ZWRseSBtYXNrIHRoZSB2YWx1ZSBiYWNrIHRvIDgvMTYg
Yml0cy4NCg0KVGhlIEMgbGFuZ3VhZ2UgaGFzIHNvbWUgb3RoZXIgb2RkaXRpZXMgLSB0aGF0IGFy
ZSBhbGxvd2VkIGJ1dCBuZXZlciBkb25lLg0KKEV4Y2VwdCBmb3IgJ3Rob3VnaHQtbWFjaGluZXMn
IGluIGNvbXAubGFuZy5jKQ0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

