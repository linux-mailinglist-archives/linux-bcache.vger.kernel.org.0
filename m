Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E70356BF4
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Apr 2021 14:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352099AbhDGMSz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Apr 2021 08:18:55 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5122 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbhDGMSz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Apr 2021 08:18:55 -0400
Received: from dggeme709-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FFk0B0z1LzYSXp;
        Wed,  7 Apr 2021 20:16:42 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme709-chm.china.huawei.com (10.1.199.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Wed, 7 Apr 2021 20:18:42 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2106.013;
 Wed, 7 Apr 2021 20:18:42 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     Coly Li <colyli@suse.de>
CC:     pmail_hulkci <hulkci@huawei.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggLW5leHQgdjJdIGJjYWNoZTogdXNlIERFRklORV9N?=
 =?utf-8?Q?UTEX()_for_mutex_lock?=
Thread-Topic: [PATCH -next v2] bcache: use DEFINE_MUTEX() for mutex lock
Thread-Index: AQHXK4/bL4Upvi4Xy0mPK9cWZ86QCaqoSX8AgACvlhA=
Date:   Wed, 7 Apr 2021 12:18:42 +0000
Message-ID: <537fd76b3f51421c95483fff3ec95aa6@huawei.com>
References: <20210407093848.567720-1-zhengyongjun3@huawei.com>
 <7037a34e-988e-dbf5-9bed-e40f5e11c36b@suse.de>
In-Reply-To: <7037a34e-988e-dbf5-9bed-e40f5e11c36b@suse.de>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.249]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

SSB3aWxsIHNlbmQgeW91IHYzIHBhdGNoIHNvb24sIHRoYW5rIHlvdTopDQoNCi0tLS0t6YKu5Lu2
5Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogQ29seSBMaSBbbWFpbHRvOmNvbHlsaUBzdXNlLmRlXSAN
CuWPkemAgeaXtumXtDogMjAyMeW5tDTmnIg35pelIDE3OjUwDQrmlLbku7bkuro6IHpoZW5neW9u
Z2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0K5oqE6YCBOiBwbWFpbF9odWxrY2kgPGh1
bGtjaUBodWF3ZWkuY29tPjsga2VudC5vdmVyc3RyZWV0QGdtYWlsLmNvbTsgbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZzsgbGludXgtYmNhY2hlQHZnZXIua2VybmVsLm9yZw0K5Li76aKYOiBS
ZTogW1BBVENIIC1uZXh0IHYyXSBiY2FjaGU6IHVzZSBERUZJTkVfTVVURVgoKSBmb3IgbXV0ZXgg
bG9jaw0KDQpPbiA0LzcvMjEgNTozOCBQTSwgWmhlbmcgWW9uZ2p1biB3cm90ZToNCj4gbXV0ZXgg
bG9jayBjYW4gYmUgaW5pdGlhbGl6ZWQgYXV0b21hdGljYWxseSB3aXRoIERFRklORV9NVVRFWCgp
IHJhdGhlciANCj4gdGhhbiBleHBsaWNpdGx5IGNhbGxpbmcgbXV0ZXhfaW5pdCgpLg0KPiANCj4g
dGhpcyBwYXRjaCB3aWxsIHJlZHVjZSB0aGUgc2l6ZSBvZiBiY2FjaGUua28gYWJvdXQgNjQgYnl0
ZXMsIHRoZSANCj4gcmVhc29uIGFzIGZvbGxvd3M6DQo+IA0KPiB0aG91Z2ggdGhpcyBwYXRjaCB3
aWxsIGluY3JlYXNlIHRoZSBzaXplIG9mIC5kYXRhIHNlZ21lbnQgYWJvdXQgMzIgDQo+IGJ5dGVz
LCBpdCB3aWxsIGFsc28gcmVkdWNlIHRoZSBzaXplIG9mIC5pbml0LnRleHQgYW5kIA0KPiAucm9k
YXRhLnN0cjEuMShhdCB4ODZfNjQpLCAucm9kYXRhX3N0cjEuOChhdCBhcm02NCkgYW5kIC5ic3Mg
c2VnbWVudCANCj4gdG90YWwgYWJvdXQgOTYgYnl0ZXMgd2hpY2ggcmVkdWNlICB0aGUgc2l6ZSBt
b3JlIHRoYW4gLmRhdGEgc2VnbWVudDsNCj4gDQoNClRoYW5rcyBmb3IgdGhlIGZvbGxvd2luZyBp
bmZvcm1hdGlvbi4gQlRXLCB0aGUgYnNzIHNlY3Rpb24gc2hvdWxkIGJlIGlnbm9yZWQsIGJlY2F1
c2UgdGhleSBkb24ndCB0YWtlIHBoeXNpY2FsIGZpbGUgc2l6ZS4NCg0KSXQgc2VlbXMgYWx0aG91
Z2ggdGhlIHBhdGNoZWQgY29kZSBoYXMgbGFyZ2VyIC5kYXRhIHNlY3Rpb24sIGJ1dCB0aGUgZ2Vu
ZXJhdGVkIGNvZGUgaW4gLmluaXQudGV4dCBhbmQgLnJvZGF0YS5zdHIxLjEob3IgOCkgYXJlIG11
Y2ggbGVzc2VyIHRoYW4gdGhlIGluY3JlYXNlZCBzaXplLiBUaGlzIGlzIHJlYWxseSBpbnRlcmVz
dGluZyA6LSkNCg0KWW91ciBkYXRhIGlzIGNvbnZpbmNlZCwgaXQgaXMgZmFpciB0byB0YWtlIHRo
aXMgcGF0Y2ggaW4uDQoNCkNvdWxkIHlvdSBwbGVhc2UgcG9zdCBhIHYzIHZlcnNpb24gd2hpY2gg
cmVtb3ZlcyB0aGUgLmJzcyBpbmZvcm1hdGlvbiA/DQoNCg0KQ29seSBMaQ0KDQoNCj4gaGVyZSBp
cyB0aGUgc3RhdGlzdGljczoNCj4gU2VjdGlvbnM6IChhcm02NCBwbGF0Zm9ybSkNCj4gSWR4IG5h
bWUJCXNpemUNCj4gLS5pbml0LnRleHQJCTAwMDAwMjQwDQo+ICsuaW5pdC50ZXh0CQkwMDAwMDIy
OA0KPiANCj4gLS5yb2RhdGEuc3RyMS44CTAwMDAxMmNkDQo+ICsucm9kYXRhLnN0cjEuOAkwMDAw
MTJiNQ0KPiANCj4gLS5kYXRhCQkJMDAwMDBjNjANCj4gKy5kYXRhCQkJMDAwMDBjODANCj4gDQo+
IC0uYnNzCQkJMDAwMDAwODANCj4gKy5ic3MJCQkwMDAwMDA2MA0KPiANCj4gU2VjdGlvbnM6ICh4
ODYgcGxhdGZvcm0pDQo+IElkeCBuYW1lCQlzaXplDQo+IC0uaW5pdC50ZXh0CQkwMDAwMDFkOQ0K
PiArLmluaXQudGV4dAkJMDAwMDAxYmYNCj4gDQo+IC0ucm9kYXRhLnN0cjEuMQkwMDAwMGM4MA0K
PiArLnJvZGF0YS5zdHIxLjEJMDAwMDBjNmQNCj4gDQo+IC0uZGF0YQkJCTAwMDAwY2MwDQo+ICsu
ZGF0YQkJCTAwMDAwY2UwDQo+IA0KPiAtLmJzcwkJCTAwMDAwMDgwDQo+ICsuYnNzCQkJMDAwMDAw
NzANCj4gDQo+IFJlcG9ydGVkLWJ5OiBIdWxrIFJvYm90IDxodWxrY2lAaHVhd2VpLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0K
PiAtLS0NCj4gIGRyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgfCAzICstLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgYi9kcml2ZXJzL21kL2JjYWNoZS9zdXBlci5jIA0K
PiBpbmRleCAwM2UxZmU0ZGU1M2QuLjM2MzVmNDU0MzA5ZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9tZC9iY2FjaGUvc3VwZXIuYw0KPiArKysgYi9kcml2ZXJzL21kL2JjYWNoZS9zdXBlci5jDQo+
IEBAIC00MCw3ICs0MCw3IEBAIHN0YXRpYyBjb25zdCBjaGFyIGludmFsaWRfdXVpZFtdID0geyAg
fTsNCj4gIA0KPiAgc3RhdGljIHN0cnVjdCBrb2JqZWN0ICpiY2FjaGVfa29iajsNCj4gLXN0cnVj
dCBtdXRleCBiY2hfcmVnaXN0ZXJfbG9jazsNCj4gK0RFRklORV9NVVRFWChiY2hfcmVnaXN0ZXJf
bG9jayk7DQo+ICBib29sIGJjYWNoZV9pc19yZWJvb3Q7DQo+ICBMSVNUX0hFQUQoYmNoX2NhY2hl
X3NldHMpOw0KPiAgc3RhdGljIExJU1RfSEVBRCh1bmNhY2hlZF9kZXZpY2VzKTsNCj4gQEAgLTI4
NjksNyArMjg2OSw2IEBAIHN0YXRpYyBpbnQgX19pbml0IGJjYWNoZV9pbml0KHZvaWQpDQo+ICAN
Cj4gIAljaGVja19tb2R1bGVfcGFyYW1ldGVycygpOw0KPiAgDQo+IC0JbXV0ZXhfaW5pdCgmYmNo
X3JlZ2lzdGVyX2xvY2spOw0KPiAgCWluaXRfd2FpdHF1ZXVlX2hlYWQoJnVucmVnaXN0ZXJfd2Fp
dCk7DQo+ICAJcmVnaXN0ZXJfcmVib290X25vdGlmaWVyKCZyZWJvb3QpOw0KPiAgDQo+IA0KDQo=
