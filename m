Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B33325BDD
	for <lists+linux-bcache@lfdr.de>; Fri, 26 Feb 2021 04:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhBZDTm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 25 Feb 2021 22:19:42 -0500
Received: from fzex.ruijie.com.cn ([120.35.11.201]:51172 "EHLO
        FZEX3.ruijie.com.cn" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229586AbhBZDTi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Feb 2021 22:19:38 -0500
Received: from FZEX6.ruijie.com.cn ([fe80::81ab:68a2:5882:ab67]) by
 FZEX3.ruijie.com.cn ([fe80::9480:e49e:2190:b001%15]) with mapi id
 14.03.0123.003; Fri, 26 Feb 2021 11:17:00 +0800
From:   <wubenqing@ruijie.com.cn>
To:     <colyli@suse.de>
CC:     <linux-bcache@vger.kernel.org>
Subject: Re: bcacheX is missing after removing a backend and adding it again
Thread-Topic: bcacheX is missing after removing a backend and adding it again
Thread-Index: AdcL3QG1DlzruyiWRFOdV08NPS0ryg==
Date:   Fri, 26 Feb 2021 03:16:59 +0000
Message-ID: <82A10A71B70FF2449A8AD233969A45A101CCD9C3CD@FZEX6.ruijie.com.cn>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.20.102.126]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

PiBPbiAyLzI1LzIxIDExOjEyIEFNLCB3dWJlbnFpbmdAcnVpamllLmNvbS5jbiB3cm90ZToNCj4g
PiBIaSBndXlzLA0KPiA+IEkgYW0gdGVzdGluZyBhIHNjZW5hcmlvIHdoZXJlIG11bHRpcGxlIGJh
Y2tlbmQgYXR0YWNoIG9uZSBjYWNoZS4gV2hlbiBJDQo+IHJlbW92ZWQgb25lIG9mIHRoZSBiYWNr
ZW5kIGFuZCBhZGRlZCBpdCBiYWNrLCBJIGZvdW5kIHRoYXQgYmNhY2hlWCB3YXMNCj4gbWlzc2lu
Zy4gSSBjb25maWd1cmVkIGNhY2hlX21vZGUgdG8gd3JpdGViYWNrLg0KPiA+DQo+ID4gQmVmb3Jl
Og0KPiA+IC9kZXYvc2RkDQo+ID4gqbippGJjYWNoZTANCj4gPiAvZGV2L3NkYw0KPiA+IKm4qaRi
Y2FjaGUxDQo+ID4NCj4gPiBBZnRlcjoNCj4gPiAvZGV2L3NkZw0KPiA+IC9kZXYvc2RjDQo+ID4g
qbippGJjYWNoZTENCj4gPg0KPiA+DQo+ID4gVGhlIG5hbWUgb2YgdGhlIGJsb2NrIGRldmljZSAv
ZGV2L3NkZCBpcyBjaGFuZ2VkIHRvIC9kZXYvc2RnLCBhbmQNCj4gYmNhY2hlMCBpcyBtaXNzaW5n
IHdoZW4gZXhjdXRpbmcgbHNibGsuIEkgZm91bmQgdGhhdA0KPiAvc3lzL2Jrb2NrL2JhY2hlMC9i
Y2FjaGUgbGluayB0byB0aGUgb2xkIGRldmljZSB3aGljaCBkb2VzIG5vdCBleGlzdC4NCj4gPiAj
IGxsIC9zeXMvYmxvY2svYmNhY2hlMC9iY2FjaGUNCj4gPiBscnd4cnd4cnd4IDEgcm9vdCByb290
IDAgRmViIDIzIDE3OjM2IC9zeXMvYmxvY2svYmNhY2hlMC9iY2FjaGUgLT4NCj4gPiAuLi8uLi8u
Li9wY2kwMDAwOjgwLzAwMDA6ODA6MDEuMC8wMDAwOjgyOjAwLjAvaG9zdDEvcG9ydC0xOjMvZW5k
X2RldmljDQo+ID4gZS0xOjMvdGFyZ2V0MTowOjMvMTowOjM6MC9ibG9jay9zZGQvYmNhY2hlDQo+
ID4NCj4gPg0KPiA+IFRoZSBzdXBlciBibG9jayBvZiAvZGV2L3NkZyBzaG93cyB0aGF0IHRoZXJl
IGlzIHN0aWxsIGRpcnR5IGRhdGEgc3RvcmVkIG9uDQo+IHRoZSBjYWNoZSBkZXZpY2UuDQo+ID4g
IyBiY2FjaGUtc3VwZXItc2hvdyAvZGV2L3NkZw0KPiA+IHNiLm1hZ2ljb2sNCj4gPiBzYi5maXJz
dF9zZWN0b3I4IFttYXRjaF0NCj4gPiBzYi5jc3VtIDgwQUU4Q0ZDQ0M3NDAwNzUgW21hdGNoXQ0K
PiA+IHNiLnZlcnNpb24xIFtiYWNraW5nIGRldmljZV0NCj4gPg0KPiA+IGRldi5sYWJlbChlbXB0
eSkNCj4gPiBkZXYudXVpZDIyY2I4ZTQ3LTY3ZDgtNGY1NC05N2I0LWE4Yzg2ZDk4NmFhYw0KPiA+
IGRldi5zZWN0b3JzX3Blcl9ibG9jayAxDQo+ID4gZGV2LnNlY3RvcnNfcGVyX2J1Y2tldCAxMDI0
DQo+ID4gZGV2LmRhdGEuZmlyc3Rfc2VjdG9yIDE2DQo+ID4gZGV2LmRhdGEuY2FjaGVfbW9kZSAx
IFt3cml0ZWJhY2tdDQo+ID4gZGV2LmRhdGEuY2FjaGVfc3RhdGUgMiBbZGlydHldDQo+ID4NCj4g
Pg0KPiA+IFdoZW4gSSBjaGVja2VkIHRoZSBrZXJuZWwgbG9nLCBJIGZvdW5kIHRoYXQ6DQo+ID4g
Li4uDQo+ID4gWzgxNzAxLjQ0NzEzMF0gYmNhY2hlOiBiY2hfY291bnRfYmFja2luZ19pb19lcnJv
cnMoKSBzZGQ6IElPIGVycm9yIG9uDQo+ID4gYmFja2luZyBkZXZpY2UsIHVucmVjb3ZlcmFibGUg
WzgxNzAxLjQ4NzU0M10gYmNhY2hlOg0KPiA+IGJjaF9jb3VudF9iYWNraW5nX2lvX2Vycm9ycygp
IHNkZDogSU8gZXJyb3Igb24gYmFja2luZyBkZXZpY2UsDQo+ID4gdW5yZWNvdmVyYWJsZSBbODE3
MDEuOTg1NTYyXSBiY2FjaGU6IGJjaF9jb3VudF9iYWNraW5nX2lvX2Vycm9ycygpDQo+ID4gc2Rk
OiBJTyBlcnJvciBvbiBiYWNraW5nIGRldmljZSwgdW5yZWNvdmVyYWJsZSBbODE3MDIuNTkwNDM1
XSBiY2FjaGU6DQo+ID4gYmFja2luZ19yZXF1ZXN0X2VuZGlvKCkgQ2FuJ3QgZmx1c2ggc2RkOiBy
ZXR1cm5lZCBiaV9zdGF0dXMgMTANCj4gPg0KPiA+IC4uLg0KPiA+IFs4MTg0OS44OTA2MDRdIGJj
YWNoZTogcmVnaXN0ZXJfYmRldigpIHJlZ2lzdGVyZWQgYmFja2luZyBkZXZpY2Ugc2RnDQo+ID4g
WzgxODQ5Ljg5MDYwOF0gYmNhY2hlOiBiY2hfY2FjaGVkX2Rldl9hdHRhY2goKSBUcmllZCB0byBh
dHRhY2ggc2RnIGJ1dA0KPiA+IGR1cGxpY2F0ZSBVVUlEIGFscmVhZHkgYXR0YWNoZWQNCj4gPg0K
PiA+IC4uLg0KPiA+DQo+ID4gIklPIGVycm9yIG9uIGJhY2tpbmcgZGV2aWNlLCB1bnJlY292ZXJh
YmxlIiBhcHBlYXJlZCA2MyB0aW1lcyBpbiB0b3RhbC4gSXQNCj4gbWF5IGJlIHRoYXQgdGhlIGlv
X2Rpc2FibGUgb2YgdGhlIGJhY2tlbmQgZGV2aWNlIGlzIHNldCB0byB0cnVlIGR1ZSB0bw0KPiBp
b19lcnJvcl9saW1pdCBpcyA2NCwgYnV0IEkgZGlkIG5vdCBmaW5kIHRoZSBsb2cgInRvbyBtYW55
IElPIGVycm9ycyBvbiBiYWNraW5nDQo+IGRldmljZSIgd2hpY2ggYmNoX2NhY2hlZF9kZXZfZXJy
b3Igd2lsbCBwcmludC4NCj4gPg0KPiA+IGJjaF93cml0ZWJhY2tfdGhyZWFkIGlzIHZlcnkgaGln
aCBjcHUgdXNhZ2UgYW5kIHRoZSBTU0QoY2FjaGUpIHNob3dzDQo+IHZlcnkgaGlnaCByZWFkIHRy
YWZmaWMgYnV0IG5vIHdyaXRlIHRyYWZmaWMuDQo+ID4NCj4gPiBEZXZpY2U6ICAgICAgICAgcnJx
bS9zICAgd3JxbS9zICAgICByL3MgICAgIHcvcyAgICByTUIvcw0KPiB3TUIvcyBhdmdycS1zeiBh
dmdxdS1zeiAgIGF3YWl0IHJfYXdhaXQgd19hd2FpdCAgc3ZjdG0gICV1dGlsDQo+ID4gbnZtZTBu
MSAgICAgICAgICAgMC4wMCAgICAgMC4wMCAzMzgzNi4wMCAgICAwLjAwICAxNjE5LjA3DQo+IDAu
MDAgICAgOTguMDAgICAgNzYuNTUgICAgMi42OCAgICAyLjY4ICAgIDAuMDAgICAwLjAzIDEwMC4w
MA0KPiA+DQo+ID4NCj4gPiBUaGUgaW1wb3J0YW50IHByb2JsZW0gaXMgdGhhdCB0aGVyZSBpcyBu
byB3YXkgdG8gcmVjb3ZlciBiY2FjaGUwLCBldmVuIGlmIEkNCj4gdHJ5IHRvIHJlLWV4ZWN1dGUg
ImVjaG8gL2Rldi9zZGcgPiAvc3lzL2ZzL2JjYWNoZS9yZWdpc3RlciIuIFRoZSBrZXJuZWwgbG9n
DQo+IHNob3dzIHRoYXQ6DQo+ID4gWzkxMDkxLjYyMTc3M10gYmNhY2hlOiByZWdpc3Rlcl9iY2Fj
aGUoKSBlcnJvciA6IGRldmljZSBhbHJlYWR5DQo+ID4gcmVnaXN0ZXJlZA0KPiA+DQo+ID4gSSBz
dXNwZWN0IHRoYXQgL2Rldi9zZGQgc3RpbGwgcmVtYWlucyBpbiBjLT5jYWNoZWRfZGV2cywgYW5k
IGl0IGlzIHNldCB0bw0KPiBpb19kaXNhYmxlLCBhbmQgL2Rldi9zZGQgZG9lcyBub3QgZXhpc3Qg
YW55bW9yZSwgc28gd3JpdGViYWNrIGNhbm5vdCBmbHVzaA0KPiBkaXJ0eSBkYXRhLiBTaW5jZSB0
aGUgbmFtZSBvZiB0aGUgYmxvY2sgZGV2aWNlIGhhcyBiZWNvbWUgL2Rldi9zZGcsDQo+IC9kZXYv
c2RnIGNhbm5vdCBiZSByZWF0dGFjaGVkIHN1Y2Nlc3NmdWxseS4NCj4gPiBEb2VzIGJjYWNoZSBz
dXBwb3J0IGJhY2tlbmQgZm9yIGhvdC1zd2FwcGluZyBzY2VuYXJpb3M/IElmIG5vdCwgd2hhdA0K
PiBjb21tYW5kIHNob3VsZCBJIHVzZSB0byBtYW51YWxseSByZXN0b3JlIGJjYWNoZTAuDQo+IA0K
PiBXaGljaCBrZXJuZWwgdmVyc2lvbiBkbyB5b3UgdXNlID8NCj4gDQo+IEEgcmVib290IG1pZ2h0
IHNvbHZlIHRoZSBwcm9ibGVtLiBCdXQgSSBmZWVsIGl0IGNvdWxkIGJlIGltcHJvdmVkIHRvIGF2
b2lkDQo+IHRoZSBleHRyYSByZWJvb3QuDQo+IA0KPiBMZXQgbWUgYWRkIGl0IGludG8gbXkgdG9k
byBsaXN0LCBpZiBubyBvbmUgZWxzZSBwb3N0cyBwYXRjaCBiZWZvcmUgSSB3b3JrIG9uDQo+IGl0
Li4uDQo+IA0KPiBUaGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uLg0KPiANCj4gQ29seSBMaQ0KDQpU
aGFuayB5b3UsIHlvdXIgc3VnZ2VzdGlvbiB3b3JrZWQuIFdoZW4gSSByZXN0YXJ0ZWQgdGhlIG1h
Y2hpbmUsIHRoZSBwcm9ibGVtIGRpc2FwcGVhcmVkLiBUaGUga2VybmVsIHZlcnNpb24gaXMgIjUu
NC45MC0xLmVsNy5lbHJlcG8ueDg2XzY0Ii4gDQpXaGF0IGlzIHRoZSByZWFzb24gd2h5IGJjaF93
cml0ZWJhY2tfdGhyZWFkIG9jY3VwaWVzIGEgaGlnaCBDUFUsIGFuZCBhbHdheXMgcmVhZHMgZGF0
YSBmcm9tIFNTRHMgYXQgYSB2ZXJ5IGhpZ2ggcmF0ZS4gVGhpcyBwaGVub21lbm9uIGNvbnRpbnVl
ZCBmb3Igc2V2ZXJhbCBob3VycyB1bnRpbCBJIHJlc3RhcnRlZCB0aGUgbWFjaGluZS4gUGxlYXNl
IGhlbHAgdG8gY29uZmlybSB3aGV0aGVyIGl0IGlzIGEgYnVnLg0KDQpBbm90aGVyIHF1ZXN0aW9u
IGlzIGFib3V0IHRoZSBjYWNoZSBkZXZpY2UuIEkgYWxzbyB1bnBsdWdnZWQgYW5kIHBsdWdnZWQg
dGhlIGNhY2hlIGRldmljZSBhbmQgZm91bmQgYSBwcm9ibGVtLiBBZnRlciB0aGUgY2FjaGUgZGlz
ayB3YXMgYmFjayBvbmxpbmUsIHRoZSBiYWNrZW5kIGRpZCBub3QgYXV0b21hdGljYWxseSBhdHRh
Y2ggc3VjY2Vzc2Z1bGx5LiBBbmQgbWFudWFsbHkgdXNpbmcgdGhlIGNvbW1hbmQgY2FuIG9ubHkg
bWFrZSBvbmUgb2YgdGhlIGJhY2tlbmQgYXR0YWNoIHN1Y2NlZWQsIGFuZCB0aGUgb3RoZXIgb25l
IGZhaWxzLg0KDQpCZWZvcmU6DQpOQU1FICAgICAgICAgICAgICBNQUo6TUlOIFJNICAgU0laRSBS
TyBUWVBFIE1PVU5UUE9JTlQNCnNkZCAgICAgICAgICAgICAgICAgODo0OCAgIDAgICA5LjFUICAw
IGRpc2sgDQqpuKmkYmNhY2hlMCAgICAgICAgIDI1MjowICAgIDAgICA5LjFUICAwIGRpc2sgDQpz
ZGIgICAgICAgICAgICAgICAgIDg6MTYgICAwIDkzMS41RyAgMCBkaXNrIA0KqbippGJjYWNoZTEg
ICAgICAgICAyNTI6MTI4ICAwIDkzMS41RyAgMCBkaXNrIA0Kc2RoICAgICAgICAgICAgICAgICA4
OjExMiAgMCA0NDcuMUcgIDAgZGlzayANCqnAqaRzZGgxICAgICAgICAgICAgICA4OjExMyAgMCAg
IDIwMEcgIDAgcGFydCANCqmmIKnAqaRiY2FjaGUwICAgICAgIDI1MjowICAgIDAgICA5LjFUICAw
IGRpc2sgDQqppiCpuKmkYmNhY2hlMSAgICAgICAyNTI6MTI4ICAwIDkzMS41RyAgMCBkaXNrIA0K
qbippHNkaDIgICAgICAgICAgICAgIDg6MTE0ICAwIDI0Ny4xRyAgMCBwYXJ0DQovZGV2L3NkaCBp
cyBjYWNoZSBkZXZpY2UuDQoNCkFmdGVyOg0KTkFNRSAgICAgICAgICAgICAgTUFKOk1JTiBSTSAg
IFNJWkUgUk8gVFlQRSBNT1VOVFBPSU5UDQpzZGQgICAgICAgICAgICAgICAgIDg6NDggICAwICAg
OS4xVCAgMCBkaXNrIA0KqbippGJjYWNoZTAgICAgICAgICAyNTI6MCAgICAwICAgOS4xVCAgMCBk
aXNrIA0Kc2RiICAgICAgICAgICAgICAgICA4OjE2ICAgMCA5MzEuNUcgIDAgZGlzayANCqm4qaRi
Y2FjaGUxICAgICAgICAgMjUyOjEyOCAgMCA5MzEuNUcgIDAgZGlzayANCnNkZyAgICAgICAgICAg
ICAgICAgODo5NiAgIDAgNDQ3LjFHICAwIGRpc2sgDQqpwKmkc2RnMSAgICAgICAgICAgICAgODo5
NyAgIDAgICAyMDBHICAwIHBhcnQgDQqpuKmkc2RnMiAgICAgICAgICAgICAgODo5OCAgIDAgMjQ3
LjFHICAwIHBhcnQNCi9kZXYvc2RnIGlzIGNhY2hlIGRldmljZS4NCg0KVGhlIGtlcm5lbCBsb2cg
aXM6DQouLi4NCls4MjU2Ni40MzYxNTddIGJsa191cGRhdGVfcmVxdWVzdDogSS9PIGVycm9yLCBk
ZXYgc2RoLCBzZWN0b3IgMTc4Njg0MDAgb3AgMHgwOihSRUFEKSBmbGFncyAweDAgcGh5c19zZWcg
MSBwcmlvIGNsYXNzIDANCls4MjU2Ni40MzYxNjJdIGJjYWNoZTogYmNoX2NvdW50X2lvX2Vycm9y
cygpIHNkaDE6IElPIGVycm9yIG9uIHJlYWRpbmcgZnJvbSBjYWNoZSwgcmVjb3ZlcmluZy4NCls4
MjU2Ni40MzYxNzFdIGJsa191cGRhdGVfcmVxdWVzdDogSS9PIGVycm9yLCBkZXYgc2RoLCBzZWN0
b3IgMjgxOTI0OTYgb3AgMHgxOihXUklURSkgZmxhZ3MgMHgwIHBoeXNfc2VnIDQgcHJpbyBjbGFz
cyAwDQpbODI1NjYuNDM2MTczXSBiY2FjaGU6IGJjaF9jb3VudF9pb19lcnJvcnMoKSBzZGgxOiBJ
TyBlcnJvciBvbiB3cml0aW5nIGRhdGEgdG8gY2FjaGUuDQpbODI1NjYuNDM2MTc1XSBiY2FjaGU6
IGJjaF9jb3VudF9pb19lcnJvcnMoKSBzZGgxOiBJTyBlcnJvciBvbiB3cml0aW5nIGRhdGEgdG8g
Y2FjaGUuDQpbODI1NjYuNDM2MTgwXSBibGtfdXBkYXRlX3JlcXVlc3Q6IEkvTyBlcnJvciwgZGV2
IHNkaCwgc2VjdG9yIDI5MzAzOTM2IG9wIDB4MTooV1JJVEUpIGZsYWdzIDB4MCBwaHlzX3NlZyAz
IHByaW8gY2xhc3MgMA0KWzgyNTY2LjQzNjE4Ml0gYmNhY2hlOiBiY2hfY291bnRfaW9fZXJyb3Jz
KCkgc2RoMTogSU8gZXJyb3Igb24gd3JpdGluZyBkYXRhIHRvIGNhY2hlLg0KWzgyNTY2LjQzNjE4
Nl0gYmxrX3VwZGF0ZV9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBzZGgsIHNlY3RvciAzMDQ2MjMy
MCBvcCAweDE6KFdSSVRFKSBmbGFncyAweDAgcGh5c19zZWcgMSBwcmlvIGNsYXNzIDANCls4MjU2
Ni40MzYxODhdIGJjYWNoZTogYmNoX2NvdW50X2lvX2Vycm9ycygpIHNkaDE6IElPIGVycm9yIG9u
IHdyaXRpbmcgZGF0YSB0byBjYWNoZS4NCls4MjU2Ni40MzY2OTFdIGJjYWNoZTogYmNoX2NvdW50
X2lvX2Vycm9ycygpIHNkaDE6IElPIGVycm9yIG9uIHdyaXRpbmcgZGF0YSB0byBjYWNoZS4NCls4
MjU2Ni40Mzg2NTRdIGJsa191cGRhdGVfcmVxdWVzdDogSS9PIGVycm9yLCBkZXYgc2RoLCBzZWN0
b3IgMjgxOTI1Mjggb3AgMHgxOihXUklURSkgZmxhZ3MgMHgwIHBoeXNfc2VnIDE2IHByaW8gY2xh
c3MgMA0KWzgyNTY2LjQ0MDM1Nl0gYmNhY2hlOiBiY2hfY2FjaGVfc2V0X2Vycm9yKCkgYmNhY2hl
OiBlcnJvciBvbiBmNGU4YjRkNi1jMzU0LTQ1YmUtOTUxMC03MjVmZTY5YzFiMTY6IA0KWzgyNTY2
LjQ0MzIyN10gYmNhY2hlOiBiY2hfY2FjaGVfc2V0X2Vycm9yKCkgQ0FDSEVfU0VUX0lPX0RJU0FC
TEUgYWxyZWFkeSBzZXQNCls4MjU2Ni40NDUxNTZdIHNkaDE6IHRvbyBtYW55IElPIGVycm9ycyB3
cml0aW5nIGRhdGEgdG8gY2FjaGUNCls4MjU2Ni40NDUxNThdIGJjYWNoZTogYmNoX2NhY2hlX3Nl
dF9lcnJvcigpICwgZGlzYWJsaW5nIGNhY2hpbmcNCg0KWzgyNTY2LjQ0NTE4M10gYmNhY2hlOiBj
b25kaXRpb25hbF9zdG9wX2JjYWNoZV9kZXZpY2UoKSBzdG9wX3doZW5fY2FjaGVfc2V0X2ZhaWxl
ZCBvZiBiY2FjaGUwIGlzICJhdXRvIiBhbmQgY2FjaGUgaXMgZGlydHksIHN0b3AgaXQgdG8gYXZv
aWQgcG90ZW50aWFsIGRhdGEgY29ycnVwdGlvbi4NCls4MjU2Ni40NDg5ODNdIGJjYWNoZTogYmNo
X2NhY2hlX3NldF9lcnJvcigpIGJjYWNoZTogZXJyb3Igb24gZjRlOGI0ZDYtYzM1NC00NWJlLTk1
MTAtNzI1ZmU2OWMxYjE2OiANCls4MjU2Ni40NTA4NzVdIGJjYWNoZTogY29uZGl0aW9uYWxfc3Rv
cF9iY2FjaGVfZGV2aWNlKCkgc3RvcF93aGVuX2NhY2hlX3NldF9mYWlsZWQgb2YgYmNhY2hlMSBp
cyAiYXV0byIgYW5kIGNhY2hlIGlzIGNsZWFuLCBrZWVwIGl0IGFsaXZlLg0KWzgyNTY2LjQ1MjY1
M10gc2RoMTogdG9vIG1hbnkgSU8gZXJyb3JzIHdyaXRpbmcgZGF0YSB0byBjYWNoZQ0KWzgyNTY2
LjQ1MjY1NF0gYmNhY2hlOiBiY2hfY2FjaGVfc2V0X2Vycm9yKCkgLCBkaXNhYmxpbmcgY2FjaGlu
Zw0KDQpbODI1NjYuNDU0NDUzXSBiY2FjaGU6IGNhY2hlZF9kZXZfZGV0YWNoX2ZpbmlzaCgpIENh
Y2hpbmcgZGlzYWJsZWQgZm9yIHNkYg0KWzgyNTY2LjQ1OTAwNl0gYmNhY2hlOiBjYWNoZWRfZGV2
X2RldGFjaF9maW5pc2goKSBDYWNoaW5nIGRpc2FibGVkIGZvciBzZGQNCls4MjU2Ni40OTkwMjVd
IGJjYWNoZTogY2FjaGVfc2V0X2ZyZWUoKSBDYWNoZSBzZXQgZjRlOGI0ZDYtYzM1NC00NWJlLTk1
MTAtNzI1ZmU2OWMxYjE2IHVucmVnaXN0ZXJlZA0KLi4uDQpbODI4NjYuMDk5MjE4XSBzY3NpIDE6
MDoyOjA6IERpcmVjdC1BY2Nlc3MgICAgIEFUQSAgICAgIElOVEVMIFNTRFNDMktCNDggMDExMCBQ
UTogMCBBTlNJOiA2DQpbODI4NjYuMDk5MjI5XSBzY3NpIDE6MDoyOjA6IFNBVEE6IGhhbmRsZSgw
eDAwMGIpLCBzYXNfYWRkcigweDQ0MzMyMjExMDMwMDAwMDApLCBwaHkoMyksIGRldmljZV9uYW1l
KDB4NTVjZDJlNDE1MjEyOGRhNCkNCls4Mjg2Ni4wOTkyMzJdIHNjc2kgMTowOjI6MDogZW5jbG9z
dXJlIGxvZ2ljYWwgaWQgKDB4NTZjOTJiZjAwMDJiOTEwNSksIHNsb3QoMSkgDQpbODI4NjYuMDk5
MjM0XSBzY3NpIDE6MDoyOjA6IGVuY2xvc3VyZSBsZXZlbCgweDAwMDApLCBjb25uZWN0b3IgbmFt
ZSggICAgICkNCls4Mjg2Ni4wOTkyOThdIHNjc2kgMTowOjI6MDogYXRhcGkobiksIG5jcSh5KSwg
YXN5bl9ub3RpZnkobiksIHNtYXJ0KHkpLCBmdWEoeSksIHN3X3ByZXNlcnZlKHkpDQpbODI4NjYu
MTAwMDcyXSBzZCAxOjA6MjowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2czIHR5cGUgMA0KWzgy
ODY2LjEwMTEyMV0gc2QgMTowOjI6MDogW3NkZ10gOTM3NzAzMDg4IDUxMi1ieXRlIGxvZ2ljYWwg
YmxvY2tzOiAoNDgwIEdCLzQ0NyBHaUIpDQpbODI4NjYuMTAxMTI1XSBzZCAxOjA6MjowOiBbc2Rn
XSA0MDk2LWJ5dGUgcGh5c2ljYWwgYmxvY2tzDQpbODI4NjYuMTAxMzY2XSBzZCAxOjA6MjowOiBb
c2RnXSBXcml0ZSBQcm90ZWN0IGlzIG9mZg0KWzgyODY2LjEwMTM2OV0gc2QgMTowOjI6MDogW3Nk
Z10gTW9kZSBTZW5zZTogOWIgMDAgMTAgMDgNCls4Mjg2Ni4xMDE2NDZdIHNkIDE6MDoyOjA6IFtz
ZGddIFdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVkLCBzdXBwb3J0cyBE
UE8gYW5kIEZVQQ0KWzgyODY2LjExODIzNF0gIHNkZzogc2RnMSBzZGcyDQpbODI4NjYuMTIxMTAx
XSBzZCAxOjA6MjowOiBbc2RnXSBBdHRhY2hlZCBTQ1NJIGRpc2sNCls4Mjg2Ni40MzIzODNdIGJj
YWNoZTogYmNoX2pvdXJuYWxfcmVwbGF5KCkgam91cm5hbCByZXBsYXkgZG9uZSwgNzU0MDgga2V5
cyBpbiAzNzYgZW50cmllcywgc2VxIDQ0ODMNCls4Mjg2Ni40MzI2NTVdIGJjYWNoZTogcmVnaXN0
ZXJfY2FjaGUoKSByZWdpc3RlcmVkIGNhY2hlIGRldmljZSBzZGcxDQouLi4NCg0KIyBiY2FjaGUt
c3VwZXItc2hvdyAvZGV2L3NkZA0Kc2IubWFnaWMJCW9rDQpzYi5maXJzdF9zZWN0b3IJCTggW21h
dGNoXQ0Kc2IuY3N1bQkJCTU5QzZCNDAxNDk0RUFCMkYgW21hdGNoXQ0Kc2IudmVyc2lvbgkJMSBb
YmFja2luZyBkZXZpY2VdDQoNCmRldi5sYWJlbAkJKGVtcHR5KQ0KZGV2LnV1aWQJCTgzMDdkYzEx
LTRkZmYtNDI4Ni1hNGM1LTc2YTc5ZjUxOGIyNw0KZGV2LnNlY3RvcnNfcGVyX2Jsb2NrCTENCmRl
di5zZWN0b3JzX3Blcl9idWNrZXQJMTAyNA0KZGV2LmRhdGEuZmlyc3Rfc2VjdG9yCTE2DQpkZXYu
ZGF0YS5jYWNoZV9tb2RlCTEgW3dyaXRlYmFja10NCmRldi5kYXRhLmNhY2hlX3N0YXRlCTAgW2Rl
dGFjaGVkXQ0KDQpjc2V0LnV1aWQJCTAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAw
MA0KIyBiY2FjaGUtc3VwZXItc2hvdyAvZGV2L3NkYg0Kc2IubWFnaWMJCW9rDQpzYi5maXJzdF9z
ZWN0b3IJCTggW21hdGNoXQ0Kc2IuY3N1bQkJCTRCREQ1RDU0NkVBMzVEOUUgW21hdGNoXQ0Kc2Iu
dmVyc2lvbgkJMSBbYmFja2luZyBkZXZpY2VdDQoNCmRldi5sYWJlbAkJKGVtcHR5KQ0KZGV2LnV1
aWQJCTA5OTZiODZlLWE0NjctNGRkYS05ZmEzLThmMmYzZGE4NTY3YQ0KZGV2LnNlY3RvcnNfcGVy
X2Jsb2NrCTENCmRldi5zZWN0b3JzX3Blcl9idWNrZXQJMTAyNA0KZGV2LmRhdGEuZmlyc3Rfc2Vj
dG9yCTE2DQpkZXYuZGF0YS5jYWNoZV9tb2RlCTEgW3dyaXRlYmFja10NCmRldi5kYXRhLmNhY2hl
X3N0YXRlCTAgW2RldGFjaGVkXQ0KDQpjc2V0LnV1aWQJCTAwMDAwMDAwLTAwMDAtMDAwMC0wMDAw
LTAwMDAwMDAwMDAwMA0KDQojIGJjYWNoZS1zdXBlci1zaG93IC9kZXYvc2RnMQ0Kc2IubWFnaWMJ
CW9rDQpzYi5maXJzdF9zZWN0b3IJCTggW21hdGNoXQ0Kc2IuY3N1bQkJCTlENjdGQzgyRTlGODk1
MkEgW21hdGNoXQ0Kc2IudmVyc2lvbgkJMyBbY2FjaGUgZGV2aWNlXQ0KDQpkZXYubGFiZWwJCShl
bXB0eSkNCmRldi51dWlkCQkwMjFjMjA2NC1jYTU1LTQyMjgtOTdlMS1lOTVhZjRkZDkxMTMNCmRl
di5zZWN0b3JzX3Blcl9ibG9jawkxDQpkZXYuc2VjdG9yc19wZXJfYnVja2V0CTEwMjQNCmRldi5j
YWNoZS5maXJzdF9zZWN0b3IJMTAyNA0KZGV2LmNhY2hlLmNhY2hlX3NlY3RvcnMJNDE5NDI5Mzc2
DQpkZXYuY2FjaGUudG90YWxfc2VjdG9ycwk0MTk0MzA0MDANCmRldi5jYWNoZS5vcmRlcmVkCXll
cw0KZGV2LmNhY2hlLmRpc2NhcmQJbm8NCmRldi5jYWNoZS5wb3MJCTANCmRldi5jYWNoZS5yZXBs
YWNlbWVudAkwIFtscnVdDQoNCmNzZXQudXVpZAkJZjRlOGI0ZDYtYzM1NC00NWJlLTk1MTAtNzI1
ZmU2OWMxYjE2DQoNCmJjYWNoZTEgZmFpbGVkLiBJIGZpbmQgdGhhdCAvc3lzL2Jsb2NrL3NkZC9i
Y2FjaGUgZGlzYXBwZWFyZWQsIGFuZCBJIGRvIG5vdCBrbm93IHdoeS4NCiMgZWNobyBmNGU4YjRk
Ni1jMzU0LTQ1YmUtOTUxMC03MjVmZTY5YzFiMTYgPiAvc3lzL2Jsb2NrL2JjYWNoZTAvYmNhY2hl
L2F0dGFjaA0KLWJhc2g6IC9zeXMvYmxvY2svYmNhY2hlMC9iY2FjaGUvYXR0YWNoOiBObyBzdWNo
IGZpbGUgb3IgZGlyZWN0b3J5DQoNCkkgdHJpZWQgdG8gbWFudWFsbHkgcmVnaXN0ZXIgdGhlIGJh
Y2tlbmQgYW5kIGl0IGZhaWxlZC4gSG93IGNhbiBJIHJlc3RvcmUgdGhlIGJhY2tlbmQncyBiY2Fj
aGUgZGlyZWN0b3J5LCBpZiBJIGRvbid0IHJlc3RhcnQgdGhlIG1hY2hpbmUuDQojIGVjaG8gL2Rl
di9zZGQgPiAvc3lzL2ZzL2JjYWNoZS9yZWdpc3Rlcg0KLWJhc2g6IGVjaG86IHdyaXRlIGVycm9y
OiBJbnZhbGlkIGFyZ3VtZW50DQpbMTMyNzY3LjE3NDYzOF0gYmNhY2hlOiByZWdpc3Rlcl9iY2Fj
aGUoKSBlcnJvciA6IGRldmljZSBhbHJlYWR5IHJlZ2lzdGVyZWQNCg0KYmNhY2hlMCBTdWNjZWVk
Lg0KIyBlY2hvIGY0ZThiNGQ2LWMzNTQtNDViZS05NTEwLTcyNWZlNjljMWIxNiA+IC9zeXMvYmxv
Y2svYmNhY2hlMS9iY2FjaGUvYXR0YWNoDQo=
