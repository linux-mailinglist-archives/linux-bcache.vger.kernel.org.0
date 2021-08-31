Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665AE3FC0B0
	for <lists+linux-bcache@lfdr.de>; Tue, 31 Aug 2021 04:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239395AbhHaCGr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 30 Aug 2021 22:06:47 -0400
Received: from smtp.h3c.com ([221.12.31.13]:45288 "EHLO h3cspam01-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239348AbhHaCGr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Aug 2021 22:06:47 -0400
Received: from DAG2EX05-BASE.srv.huawei-3com.com ([10.8.0.68])
        by h3cspam01-ex.h3c.com with ESMTP id 17V25KDU066512;
        Tue, 31 Aug 2021 10:05:20 +0800 (GMT-8)
        (envelope-from xi.fengfei@h3c.com)
Received: from DAG2EX05-BASE.srv.huawei-3com.com (10.8.0.68) by
 DAG2EX05-BASE.srv.huawei-3com.com (10.8.0.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 31 Aug 2021 10:05:21 +0800
Received: from DAG2EX05-BASE.srv.huawei-3com.com ([fe80::f963:2fad:283e:6b1c])
 by DAG2EX05-BASE.srv.huawei-3com.com ([fe80::f963:2fad:283e:6b1c%2]) with
 mapi id 15.01.2242.012; Tue, 31 Aug 2021 10:05:21 +0800
From:   Xifengfei <xi.fengfei@h3c.com>
To:     Coly Li <colyli@suse.de>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: remove the redundant judgment on bi_size
Thread-Topic: [PATCH] bcache: remove the redundant judgment on bi_size
Thread-Index: AdeeDBa9/WMeMJ4kT3KL2Y0pxfhQgA==
Date:   Tue, 31 Aug 2021 02:05:20 +0000
Message-ID: <7a523ae04e6c412e98ca00275ed4ad1a@h3c.com>
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
X-MAIL: h3cspam01-ex.h3c.com 17V25KDU066512
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T0suIFRoYW5rcyBmb3Igb3VyIGV4cGxhbmF0aW9uLiAgIF5fXg0KDQpGZW5nIGZlaQ0KDQotLS0t
LemCruS7tuWOn+S7ti0tLS0tDQrlj5Hku7bkuro6IENvbHkgTGkgW21haWx0bzpjb2x5bGlAc3Vz
ZS5kZV0gDQrlj5HpgIHml7bpl7Q6IDIwMjHlubQ45pyIMzHml6UgOTozNQ0K5pS25Lu25Lq6OiB4
aWZlbmdmZWkgKFJEKSA8eGkuZmVuZ2ZlaUBoM2MuY29tPg0K5oqE6YCBOiBsaW51eC1iY2FjaGVA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBrZW50Lm92ZXJz
dHJlZXRAZ21haWwuY29tDQrkuLvpopg6IFJlOiBbUEFUQ0hdIGJjYWNoZTogcmVtb3ZlIHRoZSBy
ZWR1bmRhbnQganVkZ21lbnQgb24gYmlfc2l6ZQ0KDQpPbiA4LzMwLzIxIDI6MjkgUE0sIFhpZmVu
Z2ZlaSB3cm90ZToNCj4g77yIU29ycnksIHRoZXJlIHdhcyBhbiBvYnZpb3VzIHR5cG8gaW4gdGhl
IGxhc3QgZW1haWzvvIkNCj4gVGhhbmtzIGEgbG90LiBJIHVuZGVyc3RhbmQgdGhlIHB1cnBvc2Uu
DQo+IFNvIGlzIHRoZSBvcmlnaW5hbCBqdWRnbWVudCBwcm9jZXNzIHRvbyBjb21wbGljYXRlZD8g
IENhbiB3ZSBqdWRnZSANCj4gYmlfc2l6ZSBkaXJlY3RseT8gIFRoaXMgd2lsbCBiZSBtb3JlIGNv
bmNpc2UNCj4NCj4gQEAgLTQyMyw3ICs0MjMsNyBAQCBzdGF0aWMgYm9vbCBjaGVja19zaG91bGRf
YnlwYXNzKHN0cnVjdCBjYWNoZWRfZGV2ICpkYywgc3RydWN0IGJpbyAqYmlvKQ0KPiAgICAgICAg
ICBhZGRfc2VxdWVudGlhbCh0YXNrKTsNCj4gICAgICAgICAgaS0+c2VxdWVudGlhbCA9IDA7DQo+
ICAgZm91bmQ6DQo+IC0gICAgICAgaWYgKGktPnNlcXVlbnRpYWwgKyBiaW8tPmJpX2l0ZXIuYmlf
c2l6ZSA+IGktPnNlcXVlbnRpYWwpDQo+ICsgICAgICAgaWYgKGJpby0+YmlfaXRlci5iaV9zaXpl
KQ0KPiAgICAgICAgICAgICAgICAgIGktPnNlcXVlbnRpYWwgICArPSBiaW8tPmJpX2l0ZXIuYmlf
c2l6ZTsNCj4NCj4gICAgICAgICAgaS0+bGFzdCAgICAgICAgICAgICAgICAgID0gYmlvX2VuZF9z
ZWN0b3IoYmlvKTsNCg0KVGhlIGFib3ZlIGNoYW5nZSB3b3JrcywgYnV0IHRoZSBjb2RlIHJlYWRh
YmlsaXR5IGRlY3JlYXNlZCBiZWNhdXNlIGhvdy93aHkgaS0+c2VxdWVudGlhbCBpcyBtYWludGFp
bmVkIGlzIG5vdCB0aGF0IGRpcmVjdGx5IHZpc2libGUuDQoNClRoaXMgaXMgYSBkaWZmZXJlbmNl
IG9mIGNvZGluZyBzdHlsZXMuIElNSE8gZm9yIHRoaXMgcGFydGljdWxhciBjYXNlLCB0aGUgcmVh
ZGFiaWxpdHkgaXMgbW9yZSBpbXBvcnRhbnQgdGhhbiBsZXNzIENQVSBpbnN0cnVjdGlvbnMuDQoN
ClRoYW5rcy4NCg0KQ29seSBMaQ0KDQo+IFRoYW5rcw0KPiBGZW5nZmVpDQo+DQo+IC0tLS0t6YKu
5Lu25Y6f5Lu2LS0tLS0NCj4g5Y+R5Lu25Lq6OiBDb2x5IExpIFttYWlsdG86Y29seWxpQHN1c2Uu
ZGVdDQo+IOWPkemAgeaXtumXtDogMjAyMeW5tDjmnIgyOeaXpSAxNTo1MA0KPiDmlLbku7bkuro6
IHhpZmVuZ2ZlaSAoUkQpIDx4aS5mZW5nZmVpQGgzYy5jb20+DQo+IOaKhOmAgTogbGludXgtYmNh
Y2hlQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgDQo+IGtl
bnQub3ZlcnN0cmVldEBnbWFpbC5jb20NCj4g5Li76aKYOiBSZTogW1BBVENIXSBiY2FjaGU6IHJl
bW92ZSB0aGUgcmVkdW5kYW50IGp1ZGdtZW50IG9uIGJpX3NpemUNCj4NCj4gT24gOC8yOS8yMSAx
Mjo0OSBQTSwgRmVuZ2ZlaSBYaSB3cm90ZToNCj4+IFRoZSBiaV9zaXplIGlzIHVuc2lnbmVkIGlu
dCB0eXBlIGRhdGEgbm90IGxlc3MgdGhhbiAwLCBzbyB3ZSBjYW4gDQo+PiBkaXJlY3RseSBhZGQg
Ymlfc2l6ZSB3aXRob3V0IGV4dHJhIGp1ZGdtZW50DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogRmVu
Z2ZlaSBYaSA8eGkuZmVuZ2ZlaUBoM2MuY29tPg0KPiBOQUNLLiBUaGUgY2hlY2sgaXMgbmVjZXNz
YXJ5IHRvIGF2b2lkIHJlZHVuZGFudCBhbmQgdW5uZWNlc3NhcnkgbWVtb3J5IHdyaXRlLg0KPg0K
PiBDb2x5IExpDQo+DQo+PiAtLS0NCj4+ICAgIGRyaXZlcnMvbWQvYmNhY2hlL3JlcXVlc3QuYyB8
IDQgKy0tLQ0KPj4gICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAzIGRlbGV0aW9u
cygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmMgDQo+
PiBiL2RyaXZlcnMvbWQvYmNhY2hlL3JlcXVlc3QuYyBpbmRleCA2ZDFkZTg4OWIuLjI3ODhlZWMz
YSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbWQvYmNhY2hlL3JlcXVlc3QuYw0KPj4gKysrIGIv
ZHJpdmVycy9tZC9iY2FjaGUvcmVxdWVzdC5jDQo+PiBAQCAtNDIzLDkgKzQyMyw3IEBAIHN0YXRp
YyBib29sIGNoZWNrX3Nob3VsZF9ieXBhc3Moc3RydWN0IGNhY2hlZF9kZXYgKmRjLCBzdHJ1Y3Qg
YmlvICpiaW8pDQo+PiAgICAJYWRkX3NlcXVlbnRpYWwodGFzayk7DQo+PiAgICAJaS0+c2VxdWVu
dGlhbCA9IDA7DQo+PiAgICBmb3VuZDoNCj4+IC0JaWYgKGktPnNlcXVlbnRpYWwgKyBiaW8tPmJp
X2l0ZXIuYmlfc2l6ZSA+IGktPnNlcXVlbnRpYWwpDQo+PiAtCQlpLT5zZXF1ZW50aWFsCSs9IGJp
by0+YmlfaXRlci5iaV9zaXplOw0KPj4gLQ0KPj4gKwlpLT5zZXF1ZW50aWFsCQkrPSBiaW8tPmJp
X2l0ZXIuYmlfc2l6ZTsNCj4+ICAgIAlpLT5sYXN0CQkJID0gYmlvX2VuZF9zZWN0b3IoYmlvKTsN
Cj4+ICAgIAlpLT5qaWZmaWVzCQkgPSBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg1MDAwKTsN
Cj4+ICAgIAl0YXNrLT5zZXF1ZW50aWFsX2lvCSA9IGktPnNlcXVlbnRpYWw7DQoNCg==
