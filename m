Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26923FB139
	for <lists+linux-bcache@lfdr.de>; Mon, 30 Aug 2021 08:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhH3GbO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 30 Aug 2021 02:31:14 -0400
Received: from smtp.h3c.com ([221.12.31.56]:56092 "EHLO h3cspam02-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233306AbhH3GbN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Aug 2021 02:31:13 -0400
Received: from DAG2EX06-IDC.srv.huawei-3com.com ([10.8.0.69])
        by h3cspam02-ex.h3c.com with ESMTP id 17U6Thbu073167;
        Mon, 30 Aug 2021 14:29:44 +0800 (GMT-8)
        (envelope-from xi.fengfei@h3c.com)
Received: from DAG2EX05-BASE.srv.huawei-3com.com (10.8.0.68) by
 DAG2EX06-IDC.srv.huawei-3com.com (10.8.0.69) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 30 Aug 2021 14:29:46 +0800
Received: from DAG2EX05-BASE.srv.huawei-3com.com ([fe80::f963:2fad:283e:6b1c])
 by DAG2EX05-BASE.srv.huawei-3com.com ([fe80::f963:2fad:283e:6b1c%2]) with
 mapi id 15.01.2242.012; Mon, 30 Aug 2021 14:29:46 +0800
From:   Xifengfei <xi.fengfei@h3c.com>
To:     Coly Li <colyli@suse.de>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: remove the redundant judgment on bi_size
Thread-Topic: [PATCH] bcache: remove the redundant judgment on bi_size
Thread-Index: AdedZ0n5UnkcexYQTOSkKpzakNUUpQAAPKRw
Date:   Mon, 30 Aug 2021 06:29:45 +0000
Message-ID: <ed49f33da50e4f5c88f986c8ed239e78@h3c.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.152.246]
x-sender-location: DAG2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-DNSRBL: 
X-MAIL: h3cspam02-ex.h3c.com 17U6Thbu073167
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

77yIU29ycnksIHRoZXJlIHdhcyBhbiBvYnZpb3VzIHR5cG8gaW4gdGhlIGxhc3QgZW1haWzvvIkN
ClRoYW5rcyBhIGxvdC4gSSB1bmRlcnN0YW5kIHRoZSBwdXJwb3NlLg0KU28gaXMgdGhlIG9yaWdp
bmFsIGp1ZGdtZW50IHByb2Nlc3MgdG9vIGNvbXBsaWNhdGVkPyAgQ2FuIHdlIGp1ZGdlIGJpX3Np
emUgZGlyZWN0bHk/ICBUaGlzIHdpbGwgYmUgbW9yZSBjb25jaXNlDQoNCkBAIC00MjMsNyArNDIz
LDcgQEAgc3RhdGljIGJvb2wgY2hlY2tfc2hvdWxkX2J5cGFzcyhzdHJ1Y3QgY2FjaGVkX2RldiAq
ZGMsIHN0cnVjdCBiaW8gKmJpbykNCiAgICAgICAgYWRkX3NlcXVlbnRpYWwodGFzayk7DQogICAg
ICAgIGktPnNlcXVlbnRpYWwgPSAwOw0KIGZvdW5kOg0KLSAgICAgICBpZiAoaS0+c2VxdWVudGlh
bCArIGJpby0+YmlfaXRlci5iaV9zaXplID4gaS0+c2VxdWVudGlhbCkNCisgICAgICAgaWYgKGJp
by0+YmlfaXRlci5iaV9zaXplKQ0KICAgICAgICAgICAgICAgIGktPnNlcXVlbnRpYWwgICArPSBi
aW8tPmJpX2l0ZXIuYmlfc2l6ZTsNCg0KICAgICAgICBpLT5sYXN0ICAgICAgICAgICAgICAgICAg
PSBiaW9fZW5kX3NlY3RvcihiaW8pOw0KDQpUaGFua3MNCkZlbmdmZWkNCg0KLS0tLS3pgq7ku7bl
jp/ku7YtLS0tLQ0K5Y+R5Lu25Lq6OiBDb2x5IExpIFttYWlsdG86Y29seWxpQHN1c2UuZGVdDQrl
j5HpgIHml7bpl7Q6IDIwMjHlubQ45pyIMjnml6UgMTU6NTANCuaUtuS7tuS6ujogeGlmZW5nZmVp
IChSRCkgPHhpLmZlbmdmZWlAaDNjLmNvbT4NCuaKhOmAgTogbGludXgtYmNhY2hlQHZnZXIua2Vy
bmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsga2VudC5vdmVyc3RyZWV0QGdt
YWlsLmNvbQ0K5Li76aKYOiBSZTogW1BBVENIXSBiY2FjaGU6IHJlbW92ZSB0aGUgcmVkdW5kYW50
IGp1ZGdtZW50IG9uIGJpX3NpemUNCg0KT24gOC8yOS8yMSAxMjo0OSBQTSwgRmVuZ2ZlaSBYaSB3
cm90ZToNCj4gVGhlIGJpX3NpemUgaXMgdW5zaWduZWQgaW50IHR5cGUgZGF0YSBub3QgbGVzcyB0
aGFuIDAsIHNvIHdlIGNhbiANCj4gZGlyZWN0bHkgYWRkIGJpX3NpemUgd2l0aG91dCBleHRyYSBq
dWRnbWVudA0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBGZW5nZmVpIFhpIDx4aS5mZW5nZmVpQGgzYy5j
b20+DQoNCk5BQ0suIFRoZSBjaGVjayBpcyBuZWNlc3NhcnkgdG8gYXZvaWQgcmVkdW5kYW50IGFu
ZCB1bm5lY2Vzc2FyeSBtZW1vcnkgd3JpdGUuDQoNCkNvbHkgTGkNCg0KPiAtLS0NCj4gICBkcml2
ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmMgfCA0ICstLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDMgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2JjYWNoZS9yZXF1ZXN0LmMgYi9kcml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmMgDQo+IGluZGV4
IDZkMWRlODg5Yi4uMjc4OGVlYzNhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL21kL2JjYWNoZS9y
ZXF1ZXN0LmMNCj4gKysrIGIvZHJpdmVycy9tZC9iY2FjaGUvcmVxdWVzdC5jDQo+IEBAIC00MjMs
OSArNDIzLDcgQEAgc3RhdGljIGJvb2wgY2hlY2tfc2hvdWxkX2J5cGFzcyhzdHJ1Y3QgY2FjaGVk
X2RldiAqZGMsIHN0cnVjdCBiaW8gKmJpbykNCj4gICAJYWRkX3NlcXVlbnRpYWwodGFzayk7DQo+
ICAgCWktPnNlcXVlbnRpYWwgPSAwOw0KPiAgIGZvdW5kOg0KPiAtCWlmIChpLT5zZXF1ZW50aWFs
ICsgYmlvLT5iaV9pdGVyLmJpX3NpemUgPiBpLT5zZXF1ZW50aWFsKQ0KPiAtCQlpLT5zZXF1ZW50
aWFsCSs9IGJpby0+YmlfaXRlci5iaV9zaXplOw0KPiAtDQo+ICsJaS0+c2VxdWVudGlhbAkJKz0g
YmlvLT5iaV9pdGVyLmJpX3NpemU7DQo+ICAgCWktPmxhc3QJCQkgPSBiaW9fZW5kX3NlY3Rvcihi
aW8pOw0KPiAgIAlpLT5qaWZmaWVzCQkgPSBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg1MDAw
KTsNCj4gICAJdGFzay0+c2VxdWVudGlhbF9pbwkgPSBpLT5zZXF1ZW50aWFsOw0KDQo=
