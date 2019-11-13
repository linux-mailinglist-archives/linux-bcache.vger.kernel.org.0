Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D926FA77E
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2019 04:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfKMDpB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Nov 2019 22:45:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:59006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727352AbfKMDpB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Nov 2019 22:45:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 724E0AC1C;
        Wed, 13 Nov 2019 03:44:58 +0000 (UTC)
Subject: Re: Several bugs/flaws in the current(?) bcache implementation
To:     Christian Balzer <chibi@gol.com>
Cc:     linux-bcache@vger.kernel.org
References: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp>
 <a138b451-0a3e-2646-111e-cd095699ab0e@suse.de>
 <20191112101739.1c2517a4@batzmaru.gol.ad.jp>
 <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
 <20191112153947.7acdc5a2@batzmaru.gol.ad.jp>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <3016280c-58c8-77f3-f938-4e835ab8d6c2@suse.de>
Date:   Wed, 13 Nov 2019 11:44:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191112153947.7acdc5a2@batzmaru.gol.ad.jp>
Content-Type: multipart/mixed;
 boundary="------------4A6CB70E7CF5DAFA7B6EEA49"
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------4A6CB70E7CF5DAFA7B6EEA49
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2019/11/12 2:39 下午, Christian Balzer wrote:
> On Tue, 12 Nov 2019 13:00:14 +0800 Coly Li wrote:
> 
>> On 2019/11/12 9:17 上午, Christian Balzer wrote:
>>> On Mon, 11 Nov 2019 23:56:04 +0800 Coly Li wrote:
>>>   
>>>> On 2019/11/11 10:10 上午, Christian Balzer wrote:  
>>>>>
>>>>>
>>>>> Hello,
>>>>>
>>>>> When researching the issues below and finding out about the PDC changes
>>>>> since 4.9 this also provided a good explanation for the load spikes we see
>>>>> with 4.9, as the default writeback is way too slow to empty the dirty
>>>>> pages and thus there is never much of a buffer for sudden write spikes,
>>>>> causing the PDC to overshoot when trying to flush things out to the
>>>>> backing device.
>>>>>
>>>>> With Debian Buster things obviously changed and the current kernel
>>>>> ---
>>>>> Linux version 4.19.0-6-amd64 (debian-kernel@lists.debian.org) (gcc version
>>>>> 8.3.0 (Debian 8.3.0-6)) #1 SMP Debian 4.19.67-2+deb10u1 (2019-09-20) ---
>>>>> we get writeback_rate_minimum (undocumented, value in 512Byte blocks).
>>>>> That looked promising and indeed it helps, but there are major gotchas.
>>>>> For the tests below I did set this to 8192 aka 4MB/s, which is something
>>>>> the backing Areca RAID (4GB cache, 16 handles at 0% utilization.
>>>>>
>>>>> 1. Quiescent insanity
>>>>>
>>>>> When running fio (see full command line and results below) all looks/seems
>>>>> fine, aside from issue #2 of course.
>>>>> However if one stops fio and the system is fully quiescent (no writes)
>>>>> then the new PDC goes berserk, most likely a division by zero type bug.
>>>>>
>>>>> writeback_rate_debug goes from (just after stopping fio):
>>>>> ---
>>>>> rate:           4.0M/sec
>>>>> dirty:          954.7M
>>>>> target:         36.7G
>>>>> proportional:   -920.7M
>>>>> integral:       -17.1M
>>>>> change:         0.0k/sec
>>>>> next io:        -7969ms
>>>>> ---
>>>>>
>>>>> to:
>>>>> ---
>>>>> rate:           0.9T/sec
>>>>> dirty:          496.4M
>>>>> target:         36.7G
>>>>> proportional:   0.0k
>>>>> integral:       0.0k
>>>>> change:         0.0k/sec
>>>>> next io:        -2000ms
>>>>> ---
>>>>> completely overwhelming the backing device and causing (again) massive
>>>>> load spikes. Very unintuitive and unexpected.
>>>>>
>>>>> Any IO (like a fio with 1 IOPS target) will prevent this and the preset
>>>>> writeback_rate_minimum will be honored until the cache is clean.
>>>>>
>>>>>     
>>>>
>>>> This is a feature indeed.. When there is no I/O for a reasonable long
>>>> time, the writeback rate limit will be set to 1TB/s, to permit the
>>>> writeback I/O to perform as fastly as possible.
>>>>
>>>> And as you observed, once there is new I/O coming, the maximized
>>>> writeback I/O will canceled and back to be controlled by PDC code.
>>>>
>>>> Is there any inconvenience for such behavior in your environment ?
>>>>  
>>> Yes, unwanted load spikes, as I wrote.
>>> Utilization of the backing RAID AND caching SSDs yo-yo'ing up to 100%.
>>>   
>>
>> Copied.
>>
>> The maximum writeback rate feature is required by users indeed, from 
>> workloads like desktop I/O acceleration, data base and distributed
>> storage. People want to make the writeback thread to accomplish dirty
>> data flushing as faster as possible in I/O idle time, then,
>> - For desktop the hard drive may go to sleep and safe energy.
>> - For other online workload less dirty data in cache means more writing
>> can be served in busy hours.
>> - Previous code will wake up hard drive every second for writeback at
>> 4KB/s, so the hard drives are not able to have a rest even in I/O idle
>> hours.
>>
> No arguments here and in my use case the _minimum_ rate set to 4MB/s aka
> 8192 achieves all that.
> 
>> Therefore the maximum writeback rate is added, to maximum the writeback
>> rate limit (1TB for now), then in I/O idle hours the dirty data can be
>> flushed as faster as possible by writeback thread. From internal
>> customers and external users, the feedback of maximum writeback rate is
>> quite positive. This is the first time I realize not everyone wants it.
>>
> 
> The full speed (1TB/s) rate will result in initially high speeds (up to
> 280MBs) in most tests, but degrade (and cause load spikes -> alarms) later
> on, often resulting in it taking LONGER than if it had stuck with the
> 4MB/s minimum rate set.
> So yes, in my case something like a 32MB/s maximum rate would probably be
> perfect.
>

Hi Christian,

Could you please try the attached patch in your environment ? Let's see
whether it makes things better on your side.

Thanks.
-- 

Coly Li

--------------4A6CB70E7CF5DAFA7B6EEA49
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-bcache-add-idle_max_writeback_rate-sysfs-interface.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-bcache-add-idle_max_writeback_rate-sysfs-interface.patc";
 filename*1="h"

RnJvbSA3ZDc3YjFjZjQxZDI4MTUzZTAxODE4NTE2OGFlNTQ4MDRmMjZlNmY1IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KRGF0ZTog
VHVlLCAxMiBOb3YgMjAxOSAxODoyNDozNiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGJjYWNo
ZTogYWRkIGlkbGVfbWF4X3dyaXRlYmFja19yYXRlIHN5c2ZzIGludGVyZmFjZQoKRm9yIHdy
aXRlYmFjayBtb2RlLCBpZiB0aGVyZSBpcyBubyByZWd1bGFyIEkvTyByZXF1ZXN0IGZvciBh
IHdoaWxlLAp0aGUgd3JpdGViYWNrIHJhdGUgd2lsbCBiZSBzZXQgdG8gdGhlIG1heGltdW0g
dmFsdWUgKDFUQi9zIGZvciBub3cpLgpUaGlzIGlzIGdvb2QgZm9yIG1vc3Qgb2YgdGhlIHN0
b3JhZ2Ugd29ya2xvYWQsIGJ1dCB0aGVyZSBhcmUgc3RpbGwKcGVvcGxlIGRvbid0IHdoYXQg
dGhlIG1heGltdW0gd3JpdGViYWNrIHJhdGUgaW4gSS9PIGlkbGUgdGltZS4KClRoaXMgcGF0
Y2ggYWRkcyBhIHN5c2ZzIGludGVyZmFjZSBmaWxlIGlkbGVfbWF4X3dyaXRlYmFja19yYXRl
IHRvCnBlcm1pdCBwZW9wbGUgdG8gZGlzYWJsZSBtYXhpbXVtIHdyaXRlYmFjayByYXRlLiBU
aGVuIHRoZSBtaW5pbXVtCndyaXRlYmFjayByYXRlIGNhbiBiZSBhZHZpc2VkIGJ5IHdyaXRl
YmFja19yYXRlX21pbmltdW0gaW4gdGhlCmJjYWNoZSBkZXZpY2UncyBzeXNmcyBpbnRlcmZh
Y2UuCgpSZXBvcnRlZC1ieTogQ2hyaXN0aWFuIEJhbHplciA8Y2hpYmlAZ29sLmNvbT4KU2ln
bmVkLW9mZi1ieTogQ29seSBMaSA8Y29seWxpQHN1c2UuZGU+Ci0tLQogZHJpdmVycy9tZC9i
Y2FjaGUvYmNhY2hlLmggICAgfCAxICsKIGRyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgICAg
IHwgMSArCiBkcml2ZXJzL21kL2JjYWNoZS9zeXNmcy5jICAgICB8IDcgKysrKysrKwogZHJp
dmVycy9tZC9iY2FjaGUvd3JpdGViYWNrLmMgfCA0ICsrKysKIDQgZmlsZXMgY2hhbmdlZCwg
MTMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL2JjYWNo
ZS5oIGIvZHJpdmVycy9tZC9iY2FjaGUvYmNhY2hlLmgKaW5kZXggNTAyNDFlMDQ1YzcwLi45
MTk4YzFiNDgwZDkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvYmNhY2hlL2JjYWNoZS5oCisr
KyBiL2RyaXZlcnMvbWQvYmNhY2hlL2JjYWNoZS5oCkBAIC03MjQsNiArNzI0LDcgQEAgc3Ry
dWN0IGNhY2hlX3NldCB7CiAJdW5zaWduZWQgaW50CQlnY19hbHdheXNfcmV3cml0ZToxOwog
CXVuc2lnbmVkIGludAkJc2hyaW5rZXJfZGlzYWJsZWQ6MTsKIAl1bnNpZ25lZCBpbnQJCWNv
cHlfZ2NfZW5hYmxlZDoxOworCXVuc2lnbmVkIGludAkJaWRsZV9tYXhfd3JpdGViYWNrX3Jh
dGVfZW5hYmxlZDoxOwogCiAjZGVmaW5lIEJVQ0tFVF9IQVNIX0JJVFMJMTIKIAlzdHJ1Y3Qg
aGxpc3RfaGVhZAlidWNrZXRfaGFzaFsxIDw8IEJVQ0tFVF9IQVNIX0JJVFNdOwpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYyBiL2RyaXZlcnMvbWQvYmNhY2hlL3N1
cGVyLmMKaW5kZXggZDEzNTJmY2M2ZmYyLi43N2U5ODY5MzQ1ZTcgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMKKysrIGIvZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIu
YwpAQCAtMTgzNCw2ICsxODM0LDcgQEAgc3RydWN0IGNhY2hlX3NldCAqYmNoX2NhY2hlX3Nl
dF9hbGxvYyhzdHJ1Y3QgY2FjaGVfc2IgKnNiKQogCWMtPmNvbmdlc3RlZF9yZWFkX3RocmVz
aG9sZF91cwk9IDIwMDA7CiAJYy0+Y29uZ2VzdGVkX3dyaXRlX3RocmVzaG9sZF91cwk9IDIw
MDAwOwogCWMtPmVycm9yX2xpbWl0CT0gREVGQVVMVF9JT19FUlJPUl9MSU1JVDsKKwljLT5p
ZGxlX21heF93cml0ZWJhY2tfcmF0ZV9lbmFibGVkID0gMTsKIAlXQVJOX09OKHRlc3RfYW5k
X2NsZWFyX2JpdChDQUNIRV9TRVRfSU9fRElTQUJMRSwgJmMtPmZsYWdzKSk7CiAKIAlyZXR1
cm4gYzsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL3N5c2ZzLmMgYi9kcml2ZXJz
L21kL2JjYWNoZS9zeXNmcy5jCmluZGV4IDYyN2RjZWEwZjViNi4uNzMzZTJkZGYzYzc4IDEw
MDY0NAotLS0gYS9kcml2ZXJzL21kL2JjYWNoZS9zeXNmcy5jCisrKyBiL2RyaXZlcnMvbWQv
YmNhY2hlL3N5c2ZzLmMKQEAgLTEzNCw2ICsxMzQsNyBAQCByd19hdHRyaWJ1dGUoZXhwZW5z
aXZlX2RlYnVnX2NoZWNrcyk7CiByd19hdHRyaWJ1dGUoY2FjaGVfcmVwbGFjZW1lbnRfcG9s
aWN5KTsKIHJ3X2F0dHJpYnV0ZShidHJlZV9zaHJpbmtlcl9kaXNhYmxlZCk7CiByd19hdHRy
aWJ1dGUoY29weV9nY19lbmFibGVkKTsKK3J3X2F0dHJpYnV0ZShpZGxlX21heF93cml0ZWJh
Y2tfcmF0ZSk7CiByd19hdHRyaWJ1dGUoZ2NfYWZ0ZXJfd3JpdGViYWNrKTsKIHJ3X2F0dHJp
YnV0ZShzaXplKTsKIApAQCAtNzQ3LDYgKzc0OCw4IEBAIFNIT1coX19iY2hfY2FjaGVfc2V0
KQogCXN5c2ZzX3ByaW50ZihnY19hbHdheXNfcmV3cml0ZSwJCSIlaSIsIGMtPmdjX2Fsd2F5
c19yZXdyaXRlKTsKIAlzeXNmc19wcmludGYoYnRyZWVfc2hyaW5rZXJfZGlzYWJsZWQsCSIl
aSIsIGMtPnNocmlua2VyX2Rpc2FibGVkKTsKIAlzeXNmc19wcmludGYoY29weV9nY19lbmFi
bGVkLAkJIiVpIiwgYy0+Y29weV9nY19lbmFibGVkKTsKKwlzeXNmc19wcmludGYoaWRsZV9t
YXhfd3JpdGViYWNrX3JhdGUsCSIlaSIsCisJCSAgICAgYy0+aWRsZV9tYXhfd3JpdGViYWNr
X3JhdGVfZW5hYmxlZCk7CiAJc3lzZnNfcHJpbnRmKGdjX2FmdGVyX3dyaXRlYmFjaywJIiVp
IiwgYy0+Z2NfYWZ0ZXJfd3JpdGViYWNrKTsKIAlzeXNmc19wcmludGYoaW9fZGlzYWJsZSwJ
CSIlaSIsCiAJCSAgICAgdGVzdF9iaXQoQ0FDSEVfU0VUX0lPX0RJU0FCTEUsICZjLT5mbGFn
cykpOwpAQCAtODY0LDYgKzg2Nyw5IEBAIFNUT1JFKF9fYmNoX2NhY2hlX3NldCkKIAlzeXNm
c19zdHJ0b3VsX2Jvb2woZ2NfYWx3YXlzX3Jld3JpdGUsCWMtPmdjX2Fsd2F5c19yZXdyaXRl
KTsKIAlzeXNmc19zdHJ0b3VsX2Jvb2woYnRyZWVfc2hyaW5rZXJfZGlzYWJsZWQsIGMtPnNo
cmlua2VyX2Rpc2FibGVkKTsKIAlzeXNmc19zdHJ0b3VsX2Jvb2woY29weV9nY19lbmFibGVk
LAljLT5jb3B5X2djX2VuYWJsZWQpOworCXN5c2ZzX3N0cnRvdWxfYm9vbChpZGxlX21heF93
cml0ZWJhY2tfcmF0ZSwKKwkJCSAgIGMtPmlkbGVfbWF4X3dyaXRlYmFja19yYXRlX2VuYWJs
ZWQpOworCiAJLyoKIAkgKiB3cml0ZSBnY19hZnRlcl93cml0ZWJhY2sgaGVyZSBtYXkgb3Zl
cndyaXRlIGFuIGFscmVhZHkgc2V0CiAJICogQkNIX0RPX0FVVE9fR0MsIGl0IGRvZXNuJ3Qg
bWF0dGVyIGJlY2F1c2UgdGhpcyBmbGFnIHdpbGwgYmUKQEAgLTk1NCw2ICs5NjAsNyBAQCBz
dGF0aWMgc3RydWN0IGF0dHJpYnV0ZSAqYmNoX2NhY2hlX3NldF9pbnRlcm5hbF9maWxlc1td
ID0gewogCSZzeXNmc19nY19hbHdheXNfcmV3cml0ZSwKIAkmc3lzZnNfYnRyZWVfc2hyaW5r
ZXJfZGlzYWJsZWQsCiAJJnN5c2ZzX2NvcHlfZ2NfZW5hYmxlZCwKKwkmc3lzZnNfaWRsZV9t
YXhfd3JpdGViYWNrX3JhdGUsCiAJJnN5c2ZzX2djX2FmdGVyX3dyaXRlYmFjaywKIAkmc3lz
ZnNfaW9fZGlzYWJsZSwKIAkmc3lzZnNfY3V0b2ZmX3dyaXRlYmFjaywKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbWQvYmNhY2hlL3dyaXRlYmFjay5jIGIvZHJpdmVycy9tZC9iY2FjaGUvd3Jp
dGViYWNrLmMKaW5kZXggZDYwMjY4ZmU0OWUxLi40YTQwZjllYWRlYWYgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbWQvYmNhY2hlL3dyaXRlYmFjay5jCisrKyBiL2RyaXZlcnMvbWQvYmNhY2hl
L3dyaXRlYmFjay5jCkBAIC0xMjIsNiArMTIyLDEwIEBAIHN0YXRpYyB2b2lkIF9fdXBkYXRl
X3dyaXRlYmFja19yYXRlKHN0cnVjdCBjYWNoZWRfZGV2ICpkYykKIHN0YXRpYyBib29sIHNl
dF9hdF9tYXhfd3JpdGViYWNrX3JhdGUoc3RydWN0IGNhY2hlX3NldCAqYywKIAkJCQkgICAg
ICAgc3RydWN0IGNhY2hlZF9kZXYgKmRjKQogeworCS8qIERvbid0IHNzdCBtYXggd3JpdGVi
YWNrIHJhdGUgaWYgaXQgaXMgZGlzYWJsZWQgKi8KKwlpZiAoIWMtPmlkbGVfbWF4X3dyaXRl
YmFja19yYXRlX2VuYWJsZWQpCisJCXJldHVybiBmYWxzZTsKKwogCS8qIERvbid0IHNldCBt
YXggd3JpdGViYWNrIHJhdGUgaWYgZ2MgaXMgcnVubmluZyAqLwogCWlmICghYy0+Z2NfbWFy
a192YWxpZCkKIAkJcmV0dXJuIGZhbHNlOwotLSAKMi4xNi40Cgo=
--------------4A6CB70E7CF5DAFA7B6EEA49--
