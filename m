Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D853FB125
	for <lists+linux-bcache@lfdr.de>; Mon, 30 Aug 2021 08:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhH3GZN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 30 Aug 2021 02:25:13 -0400
Received: from smtp.h3c.com ([221.12.31.13]:43803 "EHLO h3cspam01-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232091AbhH3GZM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Aug 2021 02:25:12 -0400
Received: from DAG2EX01-BASE.srv.huawei-3com.com ([10.8.0.64])
        by h3cspam01-ex.h3c.com with ESMTP id 17U6NkGF053334;
        Mon, 30 Aug 2021 14:23:46 +0800 (GMT-8)
        (envelope-from xi.fengfei@h3c.com)
Received: from DAG2EX05-BASE.srv.huawei-3com.com (10.8.0.68) by
 DAG2EX01-BASE.srv.huawei-3com.com (10.8.0.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 30 Aug 2021 14:23:48 +0800
Received: from DAG2EX05-BASE.srv.huawei-3com.com ([fe80::f963:2fad:283e:6b1c])
 by DAG2EX05-BASE.srv.huawei-3com.com ([fe80::f963:2fad:283e:6b1c%2]) with
 mapi id 15.01.2242.012; Mon, 30 Aug 2021 14:23:47 +0800
From:   Xifengfei <xi.fengfei@h3c.com>
To:     Coly Li <colyli@suse.de>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: remove the redundant judgment on bi_size
Thread-Topic: [PATCH] bcache: remove the redundant judgment on bi_size
Thread-Index: AdedZ0n5UnkcexYQTOSkKpzakNUUpQ==
Date:   Mon, 30 Aug 2021 06:23:46 +0000
Message-ID: <99cf62c8e3db44df8cc09ee5b327712c@h3c.com>
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
X-MAIL: h3cspam01-ex.h3c.com 17U6NkGF053334
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

VGhhbmtzIGEgbG90LiBJIHVuZGVyc3RhbmQgdGhlIHB1cnBvc2UuDQpTbyBpcyB0aGUgb3JpZ2lu
YWwganVkZ21lbnQgcHJvY2VzcyB0b28gY29tcGxpY2F0ZWQ/ICBDYW4gd2UganVkZ2UgYmlfc2l6
ZSBkaXJlY3RseT8gIFRoaXMgd2lsbCBiZSBtb3JlIGNvbmNpc2UNCg0KQEAgLTQyMyw3ICs0MjMs
NyBAQCBzdGF0aWMgYm9vbCBjaGVja19zaG91bGRfYnlwYXNzKHN0cnVjdCBjYWNoZWRfZGV2ICpk
Yywgc3RydWN0IGJpbyAqYmlvKQ0KICAgICAgICBhZGRfc2VxdWVudGlhbCh0YXNrKTsNCiAgICAg
ICAgaS0+c2VxdWVudGlhbCA9IDA7DQogZm91bmQ6DQotICAgICAgIGlmIChpLT5zZXF1ZW50aWFs
ICsgYmlvLT5iaV9pdGVyLmJpX3NpemUgPiBpLT5zZXF1ZW50aWFsKQ0KKyAgICAgICBpZiAoIWJp
by0+YmlfaXRlci5iaV9zaXplKQ0KICAgICAgICAgICAgICAgIGktPnNlcXVlbnRpYWwgICArPSBi
aW8tPmJpX2l0ZXIuYmlfc2l6ZTsNCg0KICAgICAgICBpLT5sYXN0ICAgICAgICAgICAgICAgICAg
PSBiaW9fZW5kX3NlY3RvcihiaW8pOw0KDQpUaGFua3MNCkZlbmdmZWkNCg0KLS0tLS3pgq7ku7bl
jp/ku7YtLS0tLQ0K5Y+R5Lu25Lq6OiBDb2x5IExpIFttYWlsdG86Y29seWxpQHN1c2UuZGVdIA0K
5Y+R6YCB5pe26Ze0OiAyMDIx5bm0OOaciDI55pelIDE1OjUwDQrmlLbku7bkuro6IHhpZmVuZ2Zl
aSAoUkQpIDx4aS5mZW5nZmVpQGgzYy5jb20+DQrmioTpgIE6IGxpbnV4LWJjYWNoZUB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGtlbnQub3ZlcnN0cmVldEBn
bWFpbC5jb20NCuS4u+mimDogUmU6IFtQQVRDSF0gYmNhY2hlOiByZW1vdmUgdGhlIHJlZHVuZGFu
dCBqdWRnbWVudCBvbiBiaV9zaXplDQoNCk9uIDgvMjkvMjEgMTI6NDkgUE0sIEZlbmdmZWkgWGkg
d3JvdGU6DQo+IFRoZSBiaV9zaXplIGlzIHVuc2lnbmVkIGludCB0eXBlIGRhdGEgbm90IGxlc3Mg
dGhhbiAwLCBzbyB3ZSBjYW4gDQo+IGRpcmVjdGx5IGFkZCBiaV9zaXplIHdpdGhvdXQgZXh0cmEg
anVkZ21lbnQNCj4NCj4gU2lnbmVkLW9mZi1ieTogRmVuZ2ZlaSBYaSA8eGkuZmVuZ2ZlaUBoM2Mu
Y29tPg0KDQpOQUNLLiBUaGUgY2hlY2sgaXMgbmVjZXNzYXJ5IHRvIGF2b2lkIHJlZHVuZGFudCBh
bmQgdW5uZWNlc3NhcnkgbWVtb3J5IHdyaXRlLg0KDQpDb2x5IExpDQoNCj4gLS0tDQo+ICAgZHJp
dmVycy9tZC9iY2FjaGUvcmVxdWVzdC5jIHwgNCArLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspLCAzIGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZC9iY2FjaGUvcmVxdWVzdC5jIGIvZHJpdmVycy9tZC9iY2FjaGUvcmVxdWVzdC5jIA0KPiBpbmRl
eCA2ZDFkZTg4OWIuLjI3ODhlZWMzYSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUv
cmVxdWVzdC5jDQo+ICsrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL3JlcXVlc3QuYw0KPiBAQCAtNDIz
LDkgKzQyMyw3IEBAIHN0YXRpYyBib29sIGNoZWNrX3Nob3VsZF9ieXBhc3Moc3RydWN0IGNhY2hl
ZF9kZXYgKmRjLCBzdHJ1Y3QgYmlvICpiaW8pDQo+ICAgCWFkZF9zZXF1ZW50aWFsKHRhc2spOw0K
PiAgIAlpLT5zZXF1ZW50aWFsID0gMDsNCj4gICBmb3VuZDoNCj4gLQlpZiAoaS0+c2VxdWVudGlh
bCArIGJpby0+YmlfaXRlci5iaV9zaXplID4gaS0+c2VxdWVudGlhbCkNCj4gLQkJaS0+c2VxdWVu
dGlhbAkrPSBiaW8tPmJpX2l0ZXIuYmlfc2l6ZTsNCj4gLQ0KPiArCWktPnNlcXVlbnRpYWwJCSs9
IGJpby0+YmlfaXRlci5iaV9zaXplOw0KPiAgIAlpLT5sYXN0CQkJID0gYmlvX2VuZF9zZWN0b3Io
YmlvKTsNCj4gICAJaS0+amlmZmllcwkJID0gamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoNTAw
MCk7DQo+ICAgCXRhc2stPnNlcXVlbnRpYWxfaW8JID0gaS0+c2VxdWVudGlhbDsNCg0K
