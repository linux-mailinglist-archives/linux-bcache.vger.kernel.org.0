Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597C31C8DD
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2019 14:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfENMfF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 May 2019 08:35:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:38936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbfENMfF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 May 2019 08:35:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A53E6AC61;
        Tue, 14 May 2019 12:35:03 +0000 (UTC)
Subject: Re: BUG: bcache failing on top of degraded RAID-6
From:   Coly Li <colyli@suse.de>
To:     Thorsten Knabe <linux@thorsten-knabe.de>
Cc:     linux-bcache@vger.kernel.org
References: <557659ec-3f41-d463-aa42-df33cb8d18b8@thorsten-knabe.de>
 <c11201ba-094a-db5b-4962-1dbafd377c85@suse.de>
 <0df416df-7cb7-05a4-e7ff-76da1d128560@thorsten-knabe.de>
 <efd60c92-e2f7-c07d-dc03-557eeee1ae3a@suse.de>
 <d8473b88-1f3c-145c-0ca8-e8c207f47d38@thorsten-knabe.de>
 <29b5552f-39b5-b0b9-80ec-cc4a32bcba78@suse.de>
 <3a5e949b-c51c-01ab-578c-ed4883522937@thorsten-knabe.de>
 <56663d65-02d3-2d55-9e90-d02987f61f7d@suse.de>
 <3153278c-0203-3ce5-5de3-40f08d409173@thorsten-knabe.de>
 <61323026-f168-b472-41f8-57c42a7fd0cc@suse.de>
 <63fc8271-f5a5-7fc3-9f4b-d8a610cf70b0@thorsten-knabe.de>
 <2515e3b2-1626-2206-add1-550a9dd34dee@suse.de>
 <2a444578-1828-763b-88ca-e1cda46864d2@thorsten-knabe.de>
 <3ac24c5b-05f5-560d-12d5-57acdb96e50a@suse.de>
 <21269f9e-194a-b86c-1940-c63450c1ac55@suse.de>
 <6b7b7611-4fa8-5980-8d90-4adb1e2016ee@thorsten-knabe.de>
 <e734bbc2-0f64-8fbb-8b7b-c9d8764b6788@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <f4088180-57cb-d02b-3156-ec91653faeba@suse.de>
Date:   Tue, 14 May 2019 20:34:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e734bbc2-0f64-8fbb-8b7b-c9d8764b6788@suse.de>
Content-Type: multipart/mixed;
 boundary="------------73BB5920C981E2DA74AED6F2"
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------73BB5920C981E2DA74AED6F2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2019/5/14 5:19 下午, Coly Li wrote:
> On 2019/5/14 4:55 下午, Thorsten Knabe wrote:
>> On 5/13/19 5:36 PM, Coly Li wrote:
>>> On 2019/5/9 3:43 上午, Coly Li wrote:
>>>> On 2019/5/8 11:58 下午, Thorsten Knabe wrote:
>>> [snipped]
>>>
>>>>> Hi Cody.
>>>>>
>>>>>> I cannot do this. Because this is real I/O issued to backing device, if
>>>>>> it failed, it means something really wrong on backing device.
>>>>>
>>>>> I have not found a definitive answer or documentation what the
>>>>> REQ_RAHEAD flag is actually used for. However in my understanding, after
>>>>> reading a lot of kernel source, it is used as an indication, that the
>>>>> bio read request is unimportant for proper operation and may be failed
>>>>> by the block device driver returning BLK_STS_IOERR, if it is too
>>>>> expensive or requires too many additional resources.
>>>>>
>>>>> At least the BTRFS and DRBD code do not take bio request IO errors that
>>>>> are marked with the REQ_RAHEAD flag into account in their error
>>>>> counters. Thus it is probably okay if such IO errors with the REQ_RAHEAD
>>>>> flags set are not counted as errors by bcache too.
>>>>>
>>>>>>
>>>>>> Hmm, If raid6 may returns different error code in bio->bi_status, then
>>>>>> we can identify this is a failure caused by raid degrade, not a read
>>>>>> hardware or link failure. But now I am not familiar with raid456 code,
>>>>>> no idea how to change the md raid code (I assume you meant md raid6)...
>>>>>
>>>>> I my assumptions above regarding the REQ_RAHEAD flag are correct, then
>>>>> the RAID code is correct, because restoring data from the parity
>>>>> information is a relatively expensive operation for read-ahead data,
>>>>> that is possibly never actually needed.
>>>>
>>>>
>>>> Hi Thorsten,
>>>>
>>>> Thank you for the informative hint. I agree with your idea, it seems
>>>> ignoring I/O error of REQ_RAHEAD bios does not hurt. Let me think how to
>>>> fix it by your suggestion.
>>>>
>>>
>>> Hi Thorsten,
>>>
>>> Could you please to test the attached patch ?
>>> Thanks in advance.
>>>
>>
>> Hi Cody.
>>
>> I have applied your patch to a 3 systems running Linux 5.1.1 yesterday
>> evening, on one of them I removed a disk from the RAID6 array.
>>
>> The patch works as expected. The system with the removed disk has logged
>> more than 1300 of the messages added by your patch. Most of them have
>> been logged shortly after boot up and a few shorter burst evenly spread
>> over the runtime of the system.
>>
>> Probably it would be a good idea to apply some sort of rate limit to the
>> log message. I could imagine that a different file system or I/O pattern
>> could cause a lot more of these message.
>>
> 
> Hi Thorsten,
> 
> Nice suggestion, I will add ratelimit to pr_XXX routines in other patch.
> Will post it out later for your testing.
> 

Could you please to test the attached v2 patch ? Thanks in advance.


-- 

Coly Li

--------------73BB5920C981E2DA74AED6F2
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-bcache-ignore-read-ahead-request-failure-on-backing-.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-bcache-ignore-read-ahead-request-failure-on-backing-.pa";
 filename*1="tch"

RnJvbSAzMWRjNjg1ZDc4YjZmNzdkZGQzZDRmZmE5NzQ3ODQzMWE2NjAyZWQ5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KRGF0ZTog
TW9uLCAxMyBNYXkgMjAxOSAyMjo0ODowOSArMDgwMApTdWJqZWN0OiBbUEFUQ0ggdjJdIGJj
YWNoZTogaWdub3JlIHJlYWQtYWhlYWQgcmVxdWVzdCBmYWlsdXJlIG9uIGJhY2tpbmcgZGV2
aWNlCgpXaGVuIG1kIHJhaWQgZGV2aWNlIChlLmcuIHJhaWQ0NTYpIGlzIHVzZWQgYXMgYmFj
a2luZyBkZXZpY2UsIHJlYWQtYWhlYWQKcmVxdWVzdHMgb24gYSBkZWdyYWRpbmcgYW5kIHJl
Y292ZXJpbmcgbWQgcmFpZCBkZXZpY2UgbWlnaHQgYmUgZmFpbHVyZWQKaW1tZWRpYXRlbHkg
YnkgbWQgcmFpZCBjb2RlLCBidXQgaW5kZWVkIHRoaXMgbWQgcmFpZCBhcnJheSBjYW4gc3Rp
bGwgYmUKcmVhZCBvciB3cml0ZSBmb3Igbm9ybWFsIEkvTyByZXF1ZXN0cy4gVGhlcmVmb3Jl
IHN1Y2ggZmFpbGVkIHJlYWQtYWhlYWQKcmVxdWVzdCBhcmUgbm90IHJlYWwgaGFyZHdhcmUg
ZmFpbHVyZS4gRnVydGhlciBtb3JlLCBhZnRlciBkZWdyYWRpbmcgYW5kCnJlY292ZXJpbmcg
YWNjb21wbGlzaGVkLCByZWFkLWFoZWFkIHJlcXVlc3RzIHdpbGwgYmUgaGFuZGxlZCBieSBt
ZCByYWlkCmFycmF5IGFnYWluLgoKRm9yIHN1Y2ggY29uZGl0aW9uLCBJL08gZmFpbHVyZXMg
b2YgcmVhZC1haGVhZCByZXF1ZXN0cyBkb24ndCBpbmRpY2F0ZQpyZWFsIGhlYWx0aCBzdGF0
dXMgKGJlY2F1c2Ugbm9ybWFsIEkvTyBzdGlsbCBiZSBzZXJ2ZWQpLCB0aGV5IHNob3VsZCBu
b3QKYmUgY291bnRlZCBpbnRvIEkvTyBlcnJvciBjb3VudGVyIGRjLT5pb19lcnJvcnMuCgpT
aW5jZSB0aGVyZSBpcyBubyBzaW1wbGUgd2F5IHRvIGRldGVjdCB3aGV0aGVyIHRoZSBiYWNr
aW5nIGRpdmljZSBpcyBhCm1kIHJhaWQgZGV2aWNlLCB0aGlzIHBhdGNoIHNpbXBseSBpZ25v
cmVzIEkvTyBmYWlsdXJlcyBmb3IgcmVhZC1haGVhZApiaW9zIG9uIGJhY2tpbmcgZGV2aWNl
LCB0byBhdm9pZCBib2d1cyBiYWNraW5nIGRldmljZSBmYWlsdXJlIG9uIGEKZGVncmFkaW5n
IG1kIHJhaWQgYXJyYXkuCgpTdWdnZXN0ZWQtYnk6IFRob3JzdGVuIEtuYWJlIDxsaW51eEB0
aG9yc3Rlbi1rbmFiZS5kZT4KU2lnbmVkLW9mZi1ieTogQ29seSBMaSA8Y29seWxpQHN1c2Uu
ZGU+Ci0tLQogZHJpdmVycy9tZC9iY2FjaGUvaW8uYyB8IDEyICsrKysrKysrKysrKwogMSBm
aWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2JjYWNoZS9pby5jIGIvZHJpdmVycy9tZC9iY2FjaGUvaW8uYwppbmRleCBjMjUwOTc5Njgz
MTkuLjRkOTNmMDdmNjNlNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvaW8uYwor
KysgYi9kcml2ZXJzL21kL2JjYWNoZS9pby5jCkBAIC01OCw2ICs1OCwxOCBAQCB2b2lkIGJj
aF9jb3VudF9iYWNraW5nX2lvX2Vycm9ycyhzdHJ1Y3QgY2FjaGVkX2RldiAqZGMsIHN0cnVj
dCBiaW8gKmJpbykKIAogCVdBUk5fT05DRSghZGMsICJOVUxMIHBvaW50ZXIgb2Ygc3RydWN0
IGNhY2hlZF9kZXYiKTsKIAorCS8qCisJICogUmVhZC1haGVhZCByZXF1ZXN0cyBvbiBhIGRl
Z3JhZGluZyBhbmQgcmVjb3ZlcmluZyBtZCByYWlkCisJICogKGUuZy4gcmFpZDYpIGRldmlj
ZSBtaWdodCBiZSBmYWlsdXJlZCBpbW1lZGlhdGVseSBieSBtZAorCSAqIHJhaWQgY29kZSwg
d2hpY2ggaXMgbm90IGEgcmVhbCBoYXJkd2FyZSBtZWRpYSBmYWlsdXJlLiBTbworCSAqIHdl
IHNob3VsZG4ndCBjb3VudCBmYWlsZWQgUkVRX1JBSEVBRCBiaW8gdG8gZGMtPmlvX2Vycm9y
cy4KKwkgKi8KKwlpZiAoYmlvLT5iaV9vcGYgJiBSRVFfUkFIRUFEKSB7CisJCXByX3dhcm5f
cmF0ZWxpbWl0ZWQoIiVzOiBSZWFkLWFoZWFkIEkvTyBmYWlsZWQgb24gYmFja2luZyBkZXZp
Y2UsIGlnbm9yZSIsCisJCQkJICAgIGRjLT5iYWNraW5nX2Rldl9uYW1lKTsKKwkJcmV0dXJu
OworCX0KKwogCWVycm9ycyA9IGF0b21pY19hZGRfcmV0dXJuKDEsICZkYy0+aW9fZXJyb3Jz
KTsKIAlpZiAoZXJyb3JzIDwgZGMtPmVycm9yX2xpbWl0KQogCQlwcl9lcnIoIiVzOiBJTyBl
cnJvciBvbiBiYWNraW5nIGRldmljZSwgdW5yZWNvdmVyYWJsZSIsCi0tIAoyLjE2LjQKCg==
--------------73BB5920C981E2DA74AED6F2--
