Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BD23750EF
	for <lists+linux-bcache@lfdr.de>; Thu,  6 May 2021 10:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhEFIdp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 May 2021 04:33:45 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5592 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbhEFIdp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 May 2021 04:33:45 -0400
Received: from dggeml718-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FbRbd1xy4zYfG9;
        Thu,  6 May 2021 16:30:21 +0800 (CST)
Received: from dggpeml100004.china.huawei.com (7.185.36.247) by
 dggeml718-chm.china.huawei.com (10.3.17.129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 6 May 2021 16:32:44 +0800
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggpeml100004.china.huawei.com (7.185.36.247) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 6 May 2021 16:32:43 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Thu, 6 May 2021 16:32:43 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     Coly Li <colyli@suse.de>
CC:     pmail_hulkci <hulkci@huawei.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggLW5leHQgdjRdIGJjYWNoZTogVXNlIERFRklORV9N?=
 =?utf-8?Q?UTEX()_for_mutex_lock?=
Thread-Topic: [PATCH -next v4] bcache: Use DEFINE_MUTEX() for mutex lock
Thread-Index: AQHXQZzWOkACBRqWOEaibo3/7cZIParVRgeAgADbM/A=
Date:   Thu, 6 May 2021 08:32:43 +0000
Message-ID: <24f68142888344258542f8f0203fbc88@huawei.com>
References: <20210505110655.1461896-1-zhengyongjun3@huawei.com>
 <8a60b85c-b4c3-5b4c-af1f-877980800ba7@suse.de>
In-Reply-To: <8a60b85c-b4c3-5b4c-af1f-877980800ba7@suse.de>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.64]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

SSd2ZSBiZWVuIG9uIGEgYnVzaW5lc3MgdHJpcCBzb21lIHRpbWUgYWdvIGFuZCBkaWRuJ3QgZG8g
dXBzdHJlYW0gd29yay4gVGhhbmtzIGZvciB5b3VyIHBhdGllbmNlOikNCg0KLS0tLS3pgq7ku7bl
jp/ku7YtLS0tLQ0K5Y+R5Lu25Lq6OiBDb2x5IExpIFttYWlsdG86Y29seWxpQHN1c2UuZGVdIA0K
5Y+R6YCB5pe26Ze0OiAyMDIx5bm0NeaciDbml6UgMTE6MjcNCuaUtuS7tuS6ujogemhlbmd5b25n
anVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5jb20+DQrmioTpgIE6IHBtYWlsX2h1bGtjaSA8aHVs
a2NpQGh1YXdlaS5jb20+OyBrZW50Lm92ZXJzdHJlZXRAZ21haWwuY29tOyBsaW51eC1iY2FjaGVA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQrkuLvpopg6IFJl
OiBbUEFUQ0ggLW5leHQgdjRdIGJjYWNoZTogVXNlIERFRklORV9NVVRFWCgpIGZvciBtdXRleCBs
b2NrDQoNCk9uIDUvNS8yMSA3OjA2IFBNLCBaaGVuZyBZb25nanVuIHdyb3RlOg0KPiBNdXRleCBs
b2NrIGNhbiBiZSBpbml0aWFsaXplZCBhdXRvbWF0aWNhbGx5IHdpdGggREVGSU5FX01VVEVYKCkg
cmF0aGVyIA0KPiB0aGFuIGV4cGxpY2l0bHkgY2FsbGluZyBtdXRleF9pbml0KCkuDQo+IA0KPiBU
aGlzIHBhdGNoIHdpbGwgcmVkdWNlIHRoZSBzaXplIG9mIGJjYWNoZS5rbyBhYm91dCAxNiBieXRl
cywgdGhlIA0KPiByZWFzb24gYXMgZm9sbG93czoNCj4gDQo+IFRob3VnaCB0aGlzIHBhdGNoIHdp
bGwgaW5jcmVhc2UgdGhlIHNpemUgb2YgLmRhdGEgc2VnbWVudCBhYm91dCAzMiANCj4gYnl0ZXMs
IGl0IHdpbGwgYWxzbyByZWR1Y2UgdGhlIHNpemUgb2YgLmluaXQudGV4dCBhbmQgDQo+IC5yb2Rh
dGEuc3RyMS4xKGF0IHg4Nl82NCksIC5yb2RhdGFfc3RyMS44KGF0IGFybTY0KSB0b3RhbCBhYm91
dCA0OCANCj4gYnl0ZXMgd2hpY2ggcmVkdWNlIHRoZSBzaXplIG1vcmUgdGhhbiAuZGF0YSBzZWdt
ZW50Ow0KPiANCj4gSGVyZSBpcyB0aGUgc3RhdGlzdGljczoNCj4gU2VjdGlvbnM6IChhcm02NCBw
bGF0Zm9ybSkNCj4gSWR4IG5hbWUgICAgICAgICAgICAgICAgc2l6ZQ0KPiAtLmluaXQudGV4dCAg
ICAgICAgICAgICAwMDAwMDI0MA0KPiArLmluaXQudGV4dCAgICAgICAgICAgICAwMDAwMDIyOA0K
PiANCj4gLS5yb2RhdGEuc3RyMS44CTAwMDAxMmNkDQo+ICsucm9kYXRhLnN0cjEuOAkwMDAwMTJi
NQ0KPiANCj4gLS5kYXRhICAgICAgICAgICAgICAgICAgMDAwMDBjNjANCj4gKy5kYXRhICAgICAg
ICAgICAgICAgICAgMDAwMDBjODANCj4gDQo+IFNlY3Rpb25zOiAoeDg2IHBsYXRmb3JtKQ0KPiBJ
ZHggbmFtZSAgICAgICAgICAgICAgICBzaXplDQo+IC0uaW5pdC50ZXh0ICAgICAgICAgICAgIDAw
MDAwMWQ5DQo+ICsuaW5pdC50ZXh0ICAgICAgICAgICAgIDAwMDAwMWJmDQo+IA0KPiAtLnJvZGF0
YS5zdHIxLjEJMDAwMDBjODANCj4gKy5yb2RhdGEuc3RyMS4xCTAwMDAwYzZkDQo+IA0KPiAtLmRh
dGEgICAgICAgICAgICAgICAgICAwMDAwMGNjMA0KPiArLmRhdGEgICAgICAgICAgICAgICAgICAw
MDAwMGNlMA0KPiANCj4gUmVwb3J0ZWQtYnk6IEh1bGsgUm9ib3QgPGh1bGtjaUBodWF3ZWkuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBaaGVuZyBZb25nanVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5j
b20+DQoNCkFkZGVkIGluIG15IGZvci10ZXN0IHF1ZXVlLg0KDQpUaGFua3MuDQoNCkNvbHkgTGkN
Cg0KW3NuaXBwZWRdDQo=
