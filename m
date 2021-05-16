Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06CA381F51
	for <lists+linux-bcache@lfdr.de>; Sun, 16 May 2021 16:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhEPOox (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 May 2021 10:44:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:44170 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230324AbhEPOox (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 May 2021 10:44:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5082AB07B;
        Sun, 16 May 2021 14:43:37 +0000 (UTC)
Subject: Re: PROBLEM: bcache related kernel BUG() since Linux 5.12
To:     Matthias Ferdinand <bcache@mfedv.net>,
        Thorsten Knabe <linux@thorsten-knabe.de>
Cc:     linux-bcache@vger.kernel.org
References: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
 <YKDa9IOPsDJ0Wa8i@xoff>
From:   Coly Li <colyli@suse.de>
Message-ID: <1f1c49d2-6291-f8b5-3627-08ed88114e88@suse.de>
Date:   Sun, 16 May 2021 22:43:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKDa9IOPsDJ0Wa8i@xoff>
Content-Type: multipart/mixed;
 boundary="------------2FA4DE397A0807C8B37B1358"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------2FA4DE397A0807C8B37B1358
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 5/16/21 4:42 PM, Matthias Ferdinand wrote:
> On Sat, May 15, 2021 at 09:06:07PM +0200, Thorsten Knabe wrote:
>> Hello.
>>
>> Starting with Linux 5.12 bcache triggers a BUG() after a few minutes of
>> usage.
>>
>> Linux up to 5.11.x is not affected by this bug.
>>
>> Environment:
>> - Debian 10 AMD 64
>> - Kernel 5.12 - 5.12.4
>> - Filesystem ext4
>> - Backing device: degraded software RAID-6 (MD) with 3 of 4 disks active
>>   (unsure if the degraded RAID-6 has an effect or not)
>> - Cache device: Single SSD
> 
> Sorry I can't immediately help with bcache, but for DRBD, there was a
> similar problem with DRBD on degraded md-raid fixed just recently:
> 
>     https://lists.linbit.com/pipermail/drbd-user/2021-May/025904.html
> 
> Although they had silent data corruption AFAICT, not a loud BUG(), and
> they stated problems started with kernel 4.3.
> 
> For DRBD it had to do with split BIOs and readahead, which degraded
> md-raid may or may not fail, and missing a fail on parts of a split-up
> readahead BIO.
> 
> Matthias
> 


This is caused by a hidden issue which is triggered by the bio code
change in v5.12.

The attached patch can help to avoid the panic, and the finally fixes
are under testing and will be posted very soon.

Coly Li

--------------2FA4DE397A0807C8B37B1358
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-bcache-avoid-oversized-bio_alloc_bioset-call-in-cach.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-bcache-avoid-oversized-bio_alloc_bioset-call-in-cach.pa";
 filename*1="tch"

RnJvbSA2ZjJlZGVlNzEwMGVmYWJmMmNjY2NiODRlNGE5MmNjYmZiZGRkOGM1IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KRGF0ZTog
VGh1LCA2IE1heSAyMDIxIDEwOjM4OjQxICswODAwClN1YmplY3Q6IFtQQVRDSF0gYmNhY2hl
OiBhdm9pZCBvdmVyc2l6ZWQgYmlvX2FsbG9jX2Jpb3NldCgpIGNhbGwgaW4KIGNhY2hlZF9k
ZXZfY2FjaGVfbWlzcygpCgpTaW5jZSBMaW51eCB2NS4xMiwgY2FsbGluZyBiaW9fYWxsb2Nf
Ymlvc2V0KCkgd2l0aCBvdmVyc2l6ZWQgYmlvIHZlY3RvcnMKbnVtYmVyIHdpbGwgY2F1c2Ug
YSBCVUcoKSBwYW5pYyBpbiBiaW92ZWNfc2xhYigpLiBUaGVyZSBhcmUgMiBsb2NhdGlvbnMK
aW4gYmNhY2hlIGNvZGUgY2FsbGluZyBiaW9fYWxsb2NfYmlvc2V0KCksIGFuZCBvbmx5IHRo
ZSBsb2NhdGlvbiBpbgpjYWNoZWRfZGV2X2NhY2hlX21pc3MoKSBoYXMgc3VjaCBwb3RlbnRp
YWwgb3ZlcnNpemVkIHJpc2suCgpJbiBjYWNoZWRfZGV2X2NhY2hlX21pc3MoKSB0aGUgYmlv
IHZlY3RvcnMgbnVtYmVyIGlzIGNhbGN1bGF0ZWQgYnkKRElWX1JPVU5EX1VQKHMtPmluc2Vy
dF9iaW9fc2VjdG9ycywgUEFHRV9TRUNUT1JTKSwgdGhpcyBwYXRjaCBjaGVja3MgdGhlCmNh
bGN1bGF0ZWQgcmVzdWx0LCBpZiBpdCBpcyBsYXJnZXIgdGhhbiBCSU9fTUFYX1ZFQ1MsIHRo
ZW4gZ2l2ZSB1cCB0aGUKYWxsb2NhdGlvbiBvZiBjYWNoZV9iaW8gYW5kIHNlbmRpbmcgcmVx
dWVzdCB0byBiYWNraW5nIGRldmljZSBkaXJlY3RseS4KCkJ5IHRoaXMgcmVzdHJpY3Rpb24s
IHRoZSBwb3RlbnRpYWwgQlVHKCkgcGFuaWMgY2FuIGJlIGF2b2lkZWQgZnJvbSB0aGUKY2Fj
aGUgbWlzc2luZyBjb2RlIHBhdGguCgpTaWduZWQtb2ZmLWJ5OiBDb2x5IExpIDxjb2x5bGlA
c3VzZS5kZT4KLS0tCiBkcml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmMgfCAxMyArKysrKysr
KystLS0tCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL3JlcXVlc3QuYyBiL2RyaXZlcnMv
bWQvYmNhY2hlL3JlcXVlc3QuYwppbmRleCAyOWMyMzE3NTgyOTMuLmE2NTdkM2EyYjYyNCAx
MDA2NDQKLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvcmVxdWVzdC5jCisrKyBiL2RyaXZlcnMv
bWQvYmNhY2hlL3JlcXVlc3QuYwpAQCAtODc5LDcgKzg3OSw3IEBAIHN0YXRpYyB2b2lkIGNh
Y2hlZF9kZXZfcmVhZF9kb25lX2JoKHN0cnVjdCBjbG9zdXJlICpjbCkKIHN0YXRpYyBpbnQg
Y2FjaGVkX2Rldl9jYWNoZV9taXNzKHN0cnVjdCBidHJlZSAqYiwgc3RydWN0IHNlYXJjaCAq
cywKIAkJCQkgc3RydWN0IGJpbyAqYmlvLCB1bnNpZ25lZCBpbnQgc2VjdG9ycykKIHsKLQlp
bnQgcmV0ID0gTUFQX0NPTlRJTlVFOworCWludCByZXQgPSBNQVBfQ09OVElOVUUsIG5yX2lv
dmVjcyA9IDA7CiAJdW5zaWduZWQgaW50IHJlYWRhID0gMDsKIAlzdHJ1Y3QgY2FjaGVkX2Rl
diAqZGMgPSBjb250YWluZXJfb2Yocy0+ZCwgc3RydWN0IGNhY2hlZF9kZXYsIGRpc2spOwog
CXN0cnVjdCBiaW8gKm1pc3MsICpjYWNoZV9iaW87CkBAIC05MTYsOSArOTE2LDE0IEBAIHN0
YXRpYyBpbnQgY2FjaGVkX2Rldl9jYWNoZV9taXNzKHN0cnVjdCBidHJlZSAqYiwgc3RydWN0
IHNlYXJjaCAqcywKIAkvKiBidHJlZV9zZWFyY2hfcmVjdXJzZSgpJ3MgYnRyZWUgaXRlcmF0
b3IgaXMgbm8gZ29vZCBhbnltb3JlICovCiAJcmV0ID0gbWlzcyA9PSBiaW8gPyBNQVBfRE9O
RSA6IC1FSU5UUjsKIAotCWNhY2hlX2JpbyA9IGJpb19hbGxvY19iaW9zZXQoR0ZQX05PV0FJ
VCwKLQkJCURJVl9ST1VORF9VUChzLT5pbnNlcnRfYmlvX3NlY3RvcnMsIFBBR0VfU0VDVE9S
UyksCi0JCQkmZGMtPmRpc2suYmlvX3NwbGl0KTsKKwlucl9pb3ZlY3MgPSBESVZfUk9VTkRf
VVAocy0+aW5zZXJ0X2Jpb19zZWN0b3JzLCBQQUdFX1NFQ1RPUlMpOworCWlmIChucl9pb3Zl
Y3MgPiBCSU9fTUFYX1ZFQ1MpIHsKKwkJcHJfd2FybigiaW5zZXJ0aW5nIGJpbyBpcyB0b28g
bGFyZ2U6ICVkIGlvdmVjcywgbm90IGludHNlcnQuXG4iLAorCQkJbnJfaW92ZWNzKTsKKwkJ
Z290byBvdXRfc3VibWl0OworCX0KKwljYWNoZV9iaW8gPSBiaW9fYWxsb2NfYmlvc2V0KEdG
UF9OT1dBSVQsIG5yX2lvdmVjcywKKwkJCQkgICAgICZkYy0+ZGlzay5iaW9fc3BsaXQpOwog
CWlmICghY2FjaGVfYmlvKQogCQlnb3RvIG91dF9zdWJtaXQ7CiAKLS0gCjIuMjYuMgoK
--------------2FA4DE397A0807C8B37B1358--
