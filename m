Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A876E3650D7
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Apr 2021 05:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhDTDXx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Apr 2021 23:23:53 -0400
Received: from fzex.ruijie.com.cn ([120.35.11.201]:7485 "EHLO
        FZEX3.ruijie.com.cn" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234073AbhDTDXw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Apr 2021 23:23:52 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2021 23:23:52 EDT
Received: from FZEX6.ruijie.com.cn (192.168.158.99) by FZEX3.ruijie.com.cn
 (192.168.58.98) with Microsoft SMTP Server (TLS) id 14.3.123.3; Tue, 20 Apr
 2021 11:17:43 +0800
Received: from FZEX5.ruijie.com.cn ([fe80::f133:c96b:b8b4:690f]) by
 FZEX6.ruijie.com.cn ([fe80::81ab:68a2:5882:ab67%20]) with mapi id
 14.03.0123.003; Tue, 20 Apr 2021 11:17:43 +0800
From:   =?gb2312?B?zuKxvsfkKNTG18DD5iC4o9bdKQ==?= <wubenqing@ruijie.com.cn>
To:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Dirty data loss after cache disk error recovery
Thread-Topic: Dirty data loss after cache disk error recovery
Thread-Index: Adc1kUlD6DPXmyEwQFK9Esisj5rYDw==
Date:   Tue, 20 Apr 2021 03:17:42 +0000
Message-ID: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
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

SGksIFJlY2VudGx5IEkgZm91bmQgYSBwcm9ibGVtIGluIHRoZSBwcm9jZXNzIG9mIHVzaW5nIGJj
YWNoZS4gTXkgY2FjaGUgZGlzayB3YXMgb2ZmbGluZSBmb3Igc29tZSByZWFzb25zLiBXaGVuIHRo
ZSBjYWNoZSBkaXNrIHdhcyBiYWNrIG9ubGluZSwgSSBmb3VuZCB0aGF0IHRoZSBiYWNrZW5kIGlu
IHRoZSBkZXRhY2hlZCBzdGF0ZS4gSSB0cmllZCB0byBhdHRhY2ggdGhlIGJhY2tlbmQgdG8gdGhl
IGJjYWNoZSBhZ2FpbiwgYW5kIGZvdW5kIHRoYXQgdGhlIGRpcnR5IGRhdGEgd2FzIGxvc3QuIFRo
ZSBtZDUgdmFsdWUgb2YgdGhlIHNhbWUgZmlsZSBvbiBiYWNrZW5kJ3MgZmlsZXN5c3RlbSBpcyBk
aWZmZXJlbnQgYmVjYXVzZSBkaXJ0eSBkYXRhIGxvc3MuDQoNCkkgY2hlY2tlZCB0aGUgbG9nIGFu
ZCBmb3VuZCB0aGF0IGxvZ3M6DQpbMTIyMjguNjQyNjMwXSBiY2FjaGU6IGNvbmRpdGlvbmFsX3N0
b3BfYmNhY2hlX2RldmljZSgpIHN0b3Bfd2hlbl9jYWNoZV9zZXRfZmFpbGVkIG9mIGJjYWNoZTAg
aXMgImF1dG8iIGFuZCBjYWNoZSBpcyBkaXJ0eSwgc3RvcCBpdCB0byBhdm9pZCBwb3RlbnRpYWwg
ZGF0YSBjb3JydXB0aW9uLg0KWzEyMjI4LjY0NDA3Ml0gYmNhY2hlOiBjYWNoZWRfZGV2X2RldGFj
aF9maW5pc2goKSBDYWNoaW5nIGRpc2FibGVkIGZvciBzZGINClsxMjIyOC42NDQzNTJdIGJjYWNo
ZTogY2FjaGVfc2V0X2ZyZWUoKSBDYWNoZSBzZXQgNTViOTExMmQtZDUyYi00ZTE1LWFhOTMtZTdk
NWNjZmNhYzM3IHVucmVnaXN0ZXJlZA0KDQpJIGNoZWNrZWQgdGhlIGNvZGUgb2YgYmNhY2hlIGFu
ZCBmb3VuZCB0aGF0IGEgY2FjaGUgZGlzayBJTyBlcnJvciB3aWxsIHRyaWdnZXIgX19jYWNoZV9z
ZXRfdW5yZWdpc3Rlciwgd2hpY2ggd2lsbCBjYXVzZSB0aGUgYmFja2VuZCB0byBiZSBkYXRhY2gs
IHdoaWNoIGFsc28gY2F1c2VzIHRoZSBsb3NzIG9mIGRpcnR5IGRhdGEuIEJlY2F1c2UgYWZ0ZXIg
dGhlIGJhY2tlbmQgaXMgcmVhdHRhY2hlZCwgdGhlIGFsbG9jYXRlZCBiY2FjaGVfZGV2aWNlLT5p
ZCBpcyBpbmNyZW1lbnRlZCwgYW5kIHRoZSBia2V5IHRoYXQgcG9pbnRzIHRvIHRoZSBkaXJ0eSBk
YXRhIHN0b3JlcyB0aGUgb2xkIGlkLg0KDQpJcyB0aGVyZSBhIHdheSB0byBhdm9pZCB0aGlzIHBy
b2JsZW0sIHN1Y2ggYXMgcHJvdmlkaW5nIHVzZXJzIHdpdGggb3B0aW9ucywgaWYgYSBjYWNoZSBk
aXNrIGVycm9yIG9jY3VycywgZXhlY3V0ZSB0aGUgc3RvcCBwcm9jZXNzIGluc3RlYWQgb2YgZGV0
YWNoLg0KSSB0cmllZCB0byBpbmNyZWFzZSBjYWNoZV9zZXQtPmlvX2Vycm9yX2xpbWl0LCBpbiBv
cmRlciB0byB3aW4gdGhlIHRpbWUgdG8gZXhlY3V0ZSBzdG9wIGNhY2hlX3NldC4NCmVjaG8gNDI5
NDk2NzI5NSA+IC9zeXMvZnMvYmNhY2hlLzU1YjkxMTJkLWQ1MmItNGUxNS1hYTkzLWU3ZDVjY2Zj
YWMzNy9pb19lcnJvcl9saW1pdA0KDQpJdCBkaWQgbm90IHdvcmsgYXQgdGhhdCB0aW1lLCBiZWNh
dXNlIGluIGFkZGl0aW9uIHRvIGJjaF9jb3VudF9pb19lcnJvcnMsIHdoaWNoIGNhbGxzIGJjaF9j
YWNoZV9zZXRfZXJyb3IsIHRoZXJlIGFyZSBvdGhlciBjb2RlIHBhdGhzIHRoYXQgYWxzbyBjYWxs
IGJjaF9jYWNoZV9zZXRfZXJyb3IuIEZvciBleGFtcGxlLCBhbiBpbyBlcnJvciBvY2N1cnMgaW4g
dGhlIGpvdXJuYWw6DQpBcHIgMTkgMDU6NTA6MTggbG9jYWxob3N0LmxvY2FsZG9tYWluIGtlcm5l
bDogYmNhY2hlOiBiY2hfY2FjaGVfc2V0X2Vycm9yKCkgYmNhY2hlOiBlcnJvciBvbiA1NWI5MTEy
ZC1kNTJiLTRlMTUtYWE5My1lN2Q1Y2NmY2FjMzc6IA0KQXByIDE5IDA1OjUwOjE4IGxvY2FsaG9z
dC5sb2NhbGRvbWFpbiBrZXJuZWw6IGpvdXJuYWwgaW8gZXJyb3INCkFwciAxOSAwNTo1MDoxOCBs
b2NhbGhvc3QubG9jYWxkb21haW4ga2VybmVsOiBiY2FjaGU6IGJjaF9jYWNoZV9zZXRfZXJyb3Io
KSAsIGRpc2FibGluZyBjYWNoaW5nDQpBcHIgMTkgMDU6NTA6MTggbG9jYWxob3N0LmxvY2FsZG9t
YWluIGtlcm5lbDogYmNhY2hlOiBjb25kaXRpb25hbF9zdG9wX2JjYWNoZV9kZXZpY2UoKSBzdG9w
X3doZW5fY2FjaGVfc2V0X2ZhaWxlZCBvZiBiY2FjaGUwIGlzICJhdXRvIiBhbmQgY2FjaGUgaXMg
ZGlydHksIHN0b3AgaXQgdG8gYXZvaWQgcG90ZW50aWFsIGRhdGEgY29ycnVwdGlvbi4NCg0KV2hl
biBhbiBlcnJvciBvY2N1cnMgaW4gdGhlIGNhY2hlIGRldmljZSwgd2h5IGlzIGl0IGRlc2lnbmVk
IHRvIHVucmVnaXN0ZXIgdGhlIGNhY2hlX3NldD8gV2hhdCBpcyB0aGUgb3JpZ2luYWwgaW50ZW50
aW9uPyBUaGUgdW5yZWdpc3RlciBvcGVyYXRpb24gbWVhbnMgdGhhdCBhbGwgYmFja2VuZCByZWxh
dGlvbnNoaXBzIGFyZSBkZWxldGVkLCB3aGljaCB3aWxsIHJlc3VsdCBpbiB0aGUgbG9zcyBvZiBk
aXJ0eSBkYXRhLg0KSXMgaXQgcG9zc2libGUgdG8gcHJvdmlkZSB1c2VycyB3aXRoIGEgY2hvaWNl
IHRvIHN0b3AgdGhlIGNhY2hlX3NldCBpbnN0ZWFkIG9mIHVucmVnaXN0ZXJpbmcgaXQuDQo=
