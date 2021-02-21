Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB97320E99
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Feb 2021 00:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhBUXuH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 21 Feb 2021 18:50:07 -0500
Received: from mout.gmx.net ([212.227.17.20]:41407 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233542AbhBUXuH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 21 Feb 2021 18:50:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1613951313;
        bh=sy/4ZK6e+wK0pfnWJiV8oy7oRYRxnRRDB0F29+9QC2E=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=kyaC8xOnB1UpCkAqn1gAkNWC1lQPHmp3yY9T4BEcKtDTF4KJ1h5lMBn2rkmcB7fFM
         AYlDkbMysKWHDHrIPjLfy6Jc0D9pluSjvk6cmj0gwFg435TgfNEIiR3MKq3taJoaDl
         It5XG/onkI+AcEMNRBHIYZfclb0U87Lwj8izH940=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.104] ([183.193.120.187]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MV63q-1lNE7q2nmI-00S3jr; Mon, 22
 Feb 2021 00:48:33 +0100
Subject: Re: Large latency with bcache for Ceph OSD
From:   "Norman.Kern" <norman.kern@gmx.com>
To:     linux-bcache@vger.kernel.org, colyli@suse.de
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk
References: <3f3e20a3-c165-1de1-7fdd-f0bd4da598fe@gmx.com>
Message-ID: <632258f7-b138-3fba-456b-9da37c1de710@gmx.com>
Date:   Mon, 22 Feb 2021 07:48:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <3f3e20a3-c165-1de1-7fdd-f0bd4da598fe@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: base64
Content-Language: en-US
X-Provags-ID: V03:K1:VFjuWDb0m2pZ1NgS9X1KnMdau4Z7RPs1G4B2RCKRCDny7ZafsqQ
 PtBXrpYnKdtYGJyRyyls1Zeb2UAAJrBEq/DK8lijQQJfn4Lcj+Tjk4+ds8NfyY66d9M7kvF
 AHK6cbvbCV/3jefPk+ut2lKJAWBzTtbKMLXvrvgsRYtZBidolgQT9dDcXK3zWseSmTMNagV
 sHINGKMvcU9Uwwvk51qfw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:U3JUJJF6Ei4=:/ldazRUdhgn+zoFL+53L8j
 wLY3KU3j17i/SA0WU56236SxCzEp3W9ZkZjG9wFd66vHJuZzOUOrvPXh15UBiHIPFzi2E5u4D
 hQZqk7WU7spYMjASxNQjhHB3n/iDu/YUffnDo3KAhIObJHzB4AghPnzJKbsdPQfxtKKQ+6kxt
 4fK9SbZ7ukGwESNym3Uh7n8n4dseaX8zAUdtUeh7qOOjCkY45Run4BDmbFBcT/F6RRwjn45xh
 sDrk8VTI0fS38XMhXITB3xub/BLEFyyBpUb2TY9njkw264zqaOB+OMGEb/sVe3mXMmmsnQ8LK
 rQImUxoyCwpwsfXocg4e3Vyz+e0ILKTfu4JTKmQrxsxADKmeur7fcvSKYUGnLjiWr824iap3i
 yM/8p1wJYAhi9U7fI7Ich8ZftWKEkLc1enf5OWrVK9zuRgAzJlMzq/yzK1wDnFgvu5DnjYxK5
 riGV13Q5ZA3M4WLMPthvsZ34kb86/gL03I3A/YTQ6g+SP8xB+rruk2M4nGyUUuWhpzczQsd08
 Z5B1uyENLf2XWjZugfPoZxcmocdvUkAgj+T1laRwOkNLzJ6IUu+WP/ZN/Ys2ZvqB/o/d8P0BU
 +L5zZfVO01qNNVGyLd84BPiWA/+U9Cj6MZL8nVniuO+EG/Xw/IyDF/7/dvQ8HYAtULgi4zN9k
 BcxOUXPjlt/BkYWMDTGXhLLChyrrLTNDBTQ/ZsKQ34X2s7QEpcbTEjfQARzhmGkMA0jV8XFvk
 u/0TIqM2OVMFYRkppCm/ydNi9QF2u2WMh+eIZL3UgMo38EIUHQg9hQ8fTy0kngx56KZ8aCsqK
 bE46paUAaRjAPIBuvEt3gqpizkwCPxUFkaNa2zm/q1d/Q4y0d0ANOIwEG8lII9hiMhpweSzu8
 vmAQzGQVvSjDZpMU1VuQ==
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

UGluZy4NCg0KSSdtIGNvbmZ1c2VkIG9uIHRoZSBTWU5DIEkvTyBvbiBiY2FjaGUuIHdoeSBTWU5D
IEkvTyBtdXN0IGJlIHdyaXRlbiBiYWNrIA0KZm9yIHBlcnNpc3RlbnQgY2FjaGU/wqAgSXQgY2Fu
IGNhdXNlIHNvbWUgbGF0ZW5jeS4NCg0KQENvbHksIGNhbiB5b3UgZ2l2ZSBoZWxwIG1lIHRvIGV4
cGxhaW4gd2h5IGJjYWNoZSBoYW5kbGUgT19TWU5DIGxpa2UgdGhpcy4/DQoNCg0KT24gMjAyMS8y
LzE4IOS4i+WNiDM6NTYsIE5vcm1hbi5LZXJuIHdyb3RlOg0KPiBIaSBndXlzLA0KPg0KPiBJIGFt
IHRlc3RpbmcgY2VwaCB3aXRoIGJjYWNoZSwgSSBmb3VuZCBzb21lIEkvTyB3aXRoIE9fU1lOQyB3
cml0ZWJhY2sgDQo+IHRvIEhERCwgd2hpY2ggY2F1c2VkIGxhcmdlIGxhdGVuY3kgb24gSERELCBJ
IHRyYWNlIHRoZSBJL08gd2l0aCBpb3Nub29wOg0KPg0KPiAuL2lvc25vb3DCoCAtUSAtdHMgLWQg
JzgsMTkyDQo+DQo+IFRyYWNpbmcgYmxvY2sgSS9PIGZvciAxIHNlY29uZHMgKGJ1ZmZlcmVkKS4u
Lg0KPiBTVEFSVHPCoMKgwqDCoMKgwqDCoMKgwqAgRU5Ec8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Q09NTcKgwqDCoMKgwqDCoMKgwqAgUElEwqDCoMKgIFRZUEUgREVWIA0KPiBCTE9DS8KgwqDCoMKg
wqDCoMKgIEJZVEVTwqDCoMKgwqAgTEFUbXMNCj4NCj4gMTgwOTI5Ni4yOTIzNTDCoCAxODA5Mjk2
LjMxOTA1MsKgIHRwX29zZF90cMKgwqDCoCAyMjE5McKgIFLCoMKgwqAgOCwxOTIgDQo+IDQ1Nzg5
NDAyNDDCoMKgIDE2Mzg0wqDCoMKgwqAgMjYuNzANCj4gMTgwOTI5Ni4yOTIzMzDCoCAxODA5Mjk2
LjMyMDk3NMKgIHRwX29zZF90cMKgwqDCoCAyMjE5McKgIFLCoMKgwqAgOCwxOTIgDQo+IDQ1Nzc5
Mzg3MDTCoMKgIDE2Mzg0wqDCoMKgwqAgMjguNjQNCj4gMTgwOTI5Ni4yOTI2MTTCoCAxODA5Mjk2
LjMyMzI5MsKgIHRwX29zZF90cMKgwqDCoCAyMjE5McKgIFLCoMKgwqAgOCwxOTIgDQo+IDQ2MDA0
MDQzMDTCoMKgIDE2Mzg0wqDCoMKgwqAgMzAuNjgNCj4gMTgwOTI5Ni4yOTIzNTPCoCAxODA5Mjk2
LjMyNTMwMMKgIHRwX29zZF90cMKgwqDCoCAyMjE5McKgIFLCoMKgwqAgOCwxOTIgDQo+IDQ1Nzgz
NDMwODjCoMKgIDE2Mzg0wqDCoMKgwqAgMzIuOTUNCj4gMTgwOTI5Ni4yOTIzNDDCoCAxODA5Mjk2
LjMyODAxM8KgIHRwX29zZF90cMKgwqDCoCAyMjE5McKgIFLCoMKgwqAgOCwxOTIgDQo+IDQ1Nzgw
NTU0NzLCoMKgIDE2Mzg0wqDCoMKgwqAgMzUuNjcNCj4gMTgwOTI5Ni4yOTI2MDbCoCAxODA5Mjk2
LjMzMDUxOMKgIHRwX29zZF90cMKgwqDCoCAyMjE5McKgIFLCoMKgwqAgOCwxOTIgDQo+IDQ1Nzg1
ODE2NDjCoMKgIDE2Mzg0wqDCoMKgwqAgMzcuOTENCj4gMTgwOTI5NS4xNjkyNjbCoCAxODA5Mjk2
LjMzNDA0McKgIGJzdG9yZV9rdl9maSAxNzI2NsKgIFdTwqDCoCA4LDE5MiANCj4gNDI0NDk5NjM2
MMKgwqAgNDA5NsKgwqDCoCAxMTY0Ljc4DQo+IDE4MDkyOTYuMjkyNjE4wqAgMTgwOTI5Ni4zMzYz
NDnCoCB0cF9vc2RfdHDCoMKgwqAgMjIxOTHCoCBSwqDCoMKgIDgsMTkyIA0KPiA0NjAyNjMxNzYw
wqDCoCAxNjM4NMKgwqDCoMKgIDQzLjczDQo+IDE4MDkyOTYuMjkyNjE4wqAgMTgwOTI5Ni4zMzg4
MTLCoCB0cF9vc2RfdHDCoMKgwqAgMjIxOTHCoCBSwqDCoMKgIDgsMTkyIA0KPiA0NjAyNjMyOTc2
wqDCoCAxNjM4NMKgwqDCoMKgIDQ2LjE5DQo+IDE4MDkyOTYuMDMwMTAzwqAgMTgwOTI5Ni4zNDI3
ODDCoCB0cF9vc2RfdHDCoMKgwqAgMjIxODDCoCBXU8KgwqAgOCwxOTIgDQo+IDQ3NDEyNzYwNDjC
oMKgIDEzMTA3MsKgwqAgMzEyLjY4DQo+IDE4MDkyOTYuMjkyMzQ3wqAgMTgwOTI5Ni4zNDUwNDXC
oCB0cF9vc2RfdHDCoMKgwqAgMjIxOTHCoCBSwqDCoMKgIDgsMTkyIA0KPiA0NjA5MDM3ODcywqDC
oCAxNjM4NMKgwqDCoMKgIDUyLjcwDQo+IDE4MDkyOTYuMjkyNjIwwqAgMTgwOTI5Ni4zNDUxMDnC
oCB0cF9vc2RfdHDCoMKgwqAgMjIxOTHCoCBSwqDCoMKgIDgsMTkyIA0KPiA0NjA5MDM3OTA0wqDC
oCAxNjM4NMKgwqDCoMKgIDUyLjQ5DQo+IDE4MDkyOTYuMjkyNjEywqAgMTgwOTI5Ni4zNDcyNTHC
oCB0cF9vc2RfdHDCoMKgwqAgMjIxOTHCoCBSwqDCoMKgIDgsMTkyIA0KPiA0NTc4OTM3NjE2wqDC
oCAxNjM4NMKgwqDCoMKgIDU0LjY0DQo+IDE4MDkyOTYuMjkyNjIxwqAgMTgwOTI5Ni4zNTExMzbC
oCB0cF9vc2RfdHDCoMKgwqAgMjIxOTHCoCBSwqDCoMKgIDgsMTkyIA0KPiA0NjEyNjU0OTkywqDC
oCAxNjM4NMKgwqDCoMKgIDU4LjUxDQo+IDE4MDkyOTYuMjkyMzQxwqAgMTgwOTI5Ni4zNTM0MjjC
oCB0cF9vc2RfdHDCoMKgwqAgMjIxOTHCoCBSwqDCoMKgIDgsMTkyIA0KPiA0NTc4MjIwNjU2wqDC
oCAxNjM4NMKgwqDCoMKgIDYxLjA5DQo+IDE4MDkyOTYuMjkyMzQywqAgMTgwOTI5Ni4zNTM4NjTC
oCB0cF9vc2RfdHDCoMKgwqAgMjIxOTHCoCBSwqDCoMKgIDgsMTkyIA0KPiA0NTc4MjIwODgwwqDC
oCAxNjM4NMKgwqDCoMKgIDYxLjUyDQo+IDE4MDkyOTUuMTY3NjUwwqAgMTgwOTI5Ni4zNTg1MTDC
oCBic3RvcmVfa3ZfZmkgMTcyNjbCoCBXU8KgwqAgOCwxOTIgDQo+IDQ5MjM2OTU5NjDCoMKgIDQw
OTbCoMKgwqAgMTE5MC44Ng0KPiAxODA5Mjk2LjI5MjM0N8KgIDE4MDkyOTYuMzYxODg1wqAgdHBf
b3NkX3RwwqDCoMKgIDIyMTkxwqAgUsKgwqDCoCA4LDE5MiANCj4gNDYwNzQzNzEzNsKgwqAgMTYz
ODTCoMKgwqDCoCA2OS41NA0KPiAxODA5Mjk2LjAyOTM2M8KgIDE4MDkyOTYuMzY3MzEzwqAgdHBf
b3NkX3RwwqDCoMKgIDIyMTgwwqAgV1PCoMKgIDgsMTkyIA0KPiA0NzM5ODI0NDAwwqDCoCA5ODMw
NMKgwqDCoCAzMzcuOTUNCj4gMTgwOTI5Ni4yOTIzNDnCoCAxODA5Mjk2LjM3MDI0NcKgIHRwX29z
ZF90cMKgwqDCoCAyMjE5McKgIFLCoMKgwqAgOCwxOTIgDQo+IDQ1OTEzNzk4ODjCoMKgIDE2Mzg0
wqDCoMKgwqAgNzcuOTANCj4gMTgwOTI5Ni4yOTIzNDjCoCAxODA5Mjk2LjM3NjI3M8KgIHRwX29z
ZF90cMKgwqDCoCAyMjE5McKgIFLCoMKgwqAgOCwxOTIgDQo+IDQ1OTEyODk1NTLCoMKgIDE2Mzg0
wqDCoMKgwqAgODMuOTINCj4gMTgwOTI5Ni4yOTIzNTPCoCAxODA5Mjk2LjM3ODY1OcKgIHRwX29z
ZF90cMKgwqDCoCAyMjE5McKgIFLCoMKgwqAgOCwxOTIgDQo+IDQ1NzgyNDg2NTbCoMKgIDE2Mzg0
wqDCoMKgwqAgODYuMzENCj4gMTgwOTI5Ni4yOTI2MTnCoCAxODA5Mjk2LjM4NDgzNcKgIHRwX29z
ZF90cMKgwqDCoCAyMjE5McKgIFLCoMKgwqAgOCwxOTIgDQo+IDQ2MTc0OTQxNjDCoMKgIDY1NTM2
wqDCoMKgwqAgOTIuMjINCj4gMTgwOTI5NS4xNjU0NTHCoCAxODA5Mjk2LjM5MzcxNcKgIGJzdG9y
ZV9rdl9maSAxNzI2NsKgIFdTwqDCoCA4LDE5MiANCj4gMTM1NTcwMzEyMMKgwqAgNDA5NsKgwqDC
oCAxMjI4LjI2DQo+IDE4MDkyOTUuMTY4NTk1wqAgMTgwOTI5Ni40MDE1NjDCoCBic3RvcmVfa3Zf
ZmkgMTcyNjbCoCBXU8KgwqAgOCwxOTIgDQo+IDExMjIyMDDCoMKgwqDCoMKgIDQwOTbCoMKgwqAg
MTIzMi45Ng0KPiAxODA5Mjk1LjE2NTIyMcKgIDE4MDkyOTYuNDA4MDE4wqAgYnN0b3JlX2t2X2Zp
IDE3MjY2wqAgV1PCoMKgIDgsMTkyIA0KPiA5NjA2NTbCoMKgwqDCoMKgwqAgNDA5NsKgwqDCoCAx
MjQyLjgwDQo+IDE4MDkyOTUuMTY2NzM3wqAgMTgwOTI5Ni40MTE1MDXCoCBic3RvcmVfa3ZfZmkg
MTcyNjbCoCBXU8KgwqAgOCwxOTIgDQo+IDU3NjgyNTA0wqDCoMKgwqAgNDA5NsKgwqDCoCAxMjQ0
Ljc3DQo+IDE4MDkyOTYuMjkyMzUywqAgMTgwOTI5Ni40MTgxMjPCoCB0cF9vc2RfdHDCoMKgwqAg
MjIxOTHCoCBSwqDCoMKgIDgsMTkyIA0KPiA0NTc5NDU5MDU2wqDCoCAzMjc2OMKgwqDCoCAxMjUu
NzcNCj4NCj4gSSdtIGNvbmZ1c2VkIHdoeSB3cml0ZSB3aXRoIE9fU1lOQyBtdXN0IHdyaXRlYmFj
ayBvbiB0aGUgYmFja2VuZCANCj4gc3RvcmFnZSBkZXZpY2U/wqAgQW5kIHdoZW4gSSB1c2VkIGJj
YWNoZSBmb3IgYSB0aW1lLA0KPg0KPiB0aGUgbGF0ZW5jeSBpbmNyZWFzZWQgYSBsb3QuKFRoZSBT
U0QgaXMgbm90IHZlcnkgYnVzeSksIFRoZXJlJ3Mgc29tZSANCj4gYmVzdCBwcmFjdGljZXMgb24g
Y29uZmlndXJhdGlvbj8NCj4NCg==
