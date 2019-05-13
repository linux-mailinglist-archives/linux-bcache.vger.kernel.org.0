Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16F71BA30
	for <lists+linux-bcache@lfdr.de>; Mon, 13 May 2019 17:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbfEMPgw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 May 2019 11:36:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:49838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728053AbfEMPgw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 May 2019 11:36:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AA615AC4E;
        Mon, 13 May 2019 15:36:50 +0000 (UTC)
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
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <21269f9e-194a-b86c-1940-c63450c1ac55@suse.de>
Date:   Mon, 13 May 2019 23:36:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3ac24c5b-05f5-560d-12d5-57acdb96e50a@suse.de>
Content-Type: multipart/mixed;
 boundary="------------49AA7B823012F96B9D851349"
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------49AA7B823012F96B9D851349
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2019/5/9 3:43 上午, Coly Li wrote:
> On 2019/5/8 11:58 下午, Thorsten Knabe wrote:
[snipped]

>> Hi Cody.
>>
>>> I cannot do this. Because this is real I/O issued to backing device, if
>>> it failed, it means something really wrong on backing device.
>>
>> I have not found a definitive answer or documentation what the
>> REQ_RAHEAD flag is actually used for. However in my understanding, after
>> reading a lot of kernel source, it is used as an indication, that the
>> bio read request is unimportant for proper operation and may be failed
>> by the block device driver returning BLK_STS_IOERR, if it is too
>> expensive or requires too many additional resources.
>>
>> At least the BTRFS and DRBD code do not take bio request IO errors that
>> are marked with the REQ_RAHEAD flag into account in their error
>> counters. Thus it is probably okay if such IO errors with the REQ_RAHEAD
>> flags set are not counted as errors by bcache too.
>>
>>>
>>> Hmm, If raid6 may returns different error code in bio->bi_status, then
>>> we can identify this is a failure caused by raid degrade, not a read
>>> hardware or link failure. But now I am not familiar with raid456 code,
>>> no idea how to change the md raid code (I assume you meant md raid6)...
>>
>> I my assumptions above regarding the REQ_RAHEAD flag are correct, then
>> the RAID code is correct, because restoring data from the parity
>> information is a relatively expensive operation for read-ahead data,
>> that is possibly never actually needed.
> 
> 
> Hi Thorsten,
> 
> Thank you for the informative hint. I agree with your idea, it seems
> ignoring I/O error of REQ_RAHEAD bios does not hurt. Let me think how to
> fix it by your suggestion.
> 

Hi Thorsten,

Could you please to test the attached patch ?
Thanks in advance.

-- 

Coly Li

--------------49AA7B823012F96B9D851349
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-bcache-ignore-read-ahead-request-failure-on-backing-.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-bcache-ignore-read-ahead-request-failure-on-backing-.pa";
 filename*1="tch"

RnJvbSAzNTVkZTZhMzY0Mzk1OTI1MWJkOTBiMDY4OGRmMDkzZjNjM2Q0NWIzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KRGF0ZTog
TW9uLCAxMyBNYXkgMjAxOSAyMjo0ODowOSArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGJjYWNo
ZTogaWdub3JlIHJlYWQtYWhlYWQgcmVxdWVzdCBmYWlsdXJlIG9uIGJhY2tpbmcgZGV2aWNl
CgpXaGVuIG1kIHJhaWQgZGV2aWNlIChlLmcuIHJhaWQ0NTYpIGlzIHVzZWQgYXMgYmFja2lu
ZyBkZXZpY2UsIHJlYWQtYWhlYWQKcmVxdWVzdHMgb24gYSBkZWdyYWRpbmcgYW5kIHJlY292
ZXJpbmcgbWQgcmFpZCBkZXZpY2UgbWlnaHQgYmUgZmFpbHVyZWQKaW1tZWRpYXRlbHkgYnkg
bWQgcmFpZCBjb2RlLCBidXQgaW5kZWVkIHRoaXMgbWQgcmFpZCBhcnJheSBjYW4gc3RpbGwg
YmUKcmVhZCBvciB3cml0ZSBmb3Igbm9ybWFsIEkvTyByZXF1ZXN0cy4gVGhlcmVmb3JlIHN1
Y2ggZmFpbGVkIHJlYWQtYWhlYWQKcmVxdWVzdCBhcmUgbm90IHJlYWwgaGFyZHdhcmUgZmFp
bHVyZS4gRnVydGhlciBtb3JlLCBhZnRlciBkZWdyYWRpbmcgYW5kCnJlY292ZXJpbmcgYWNj
b21wbGlzaGVkLCByZWFkLWFoZWFkIHJlcXVlc3RzIHdpbGwgYmUgaGFuZGxlZCBieSBtZCBy
YWlkCmFycmF5IGFnYWluLgoKRm9yIHN1Y2ggY29uZGl0aW9uLCBJL08gZmFpbHVyZXMgb2Yg
cmVhZC1haGVhZCByZXF1ZXN0cyBkb24ndCBpbmRpY2F0ZQpyZWFsIGhlYWx0aCBzdGF0dXMg
KGJlY2F1c2Ugbm9ybWFsIEkvTyBzdGlsbCBiZSBzZXJ2ZWQpLCB0aGV5IHNob3VsZCBub3QK
YmUgY291bnRlZCBpbnRvIEkvTyBlcnJvciBjb3VudGVyIGRjLT5pb19lcnJvcnMuCgpTaW5j
ZSB0aGVyZSBpcyBubyBzaW1wbGUgd2F5IHRvIGRldGVjdCB3aGV0aGVyIHRoZSBiYWNraW5n
IGRpdmljZSBpcyBhCm1kIHJhaWQgZGV2aWNlLCB0aGlzIHBhdGNoIHNpbXBseSBpZ25vcmVz
IEkvTyBmYWlsdXJlcyBmb3IgcmVhZC1haGVhZApiaW9zIG9uIGJhY2tpbmcgZGV2aWNlLCB0
byBhdm9pZCBib2d1cyBiYWNraW5nIGRldmljZSBmYWlsdXJlIG9uIGEKZGVncmFkaW5nIG1k
IHJhaWQgYXJyYXkuCgpTdWdnZXN0ZWQtYnk6IFRob3JzdGVuIEtuYWJlIDxsaW51eEB0aG9y
c3Rlbi1rbmFiZS5kZT4KU2lnbmVkLW9mZi1ieTogQ29seSBMaSA8Y29seWxpQHN1c2UuZGU+
Ci0tLQogZHJpdmVycy9tZC9iY2FjaGUvaW8uYyB8IDEyICsrKysrKysrKysrKwogMSBmaWxl
IGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2Jj
YWNoZS9pby5jIGIvZHJpdmVycy9tZC9iY2FjaGUvaW8uYwppbmRleCBjMjUwOTc5NjgzMTku
LmQzMmUxNjgxMzEwYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvaW8uYworKysg
Yi9kcml2ZXJzL21kL2JjYWNoZS9pby5jCkBAIC01OCw2ICs1OCwxOCBAQCB2b2lkIGJjaF9j
b3VudF9iYWNraW5nX2lvX2Vycm9ycyhzdHJ1Y3QgY2FjaGVkX2RldiAqZGMsIHN0cnVjdCBi
aW8gKmJpbykKIAogCVdBUk5fT05DRSghZGMsICJOVUxMIHBvaW50ZXIgb2Ygc3RydWN0IGNh
Y2hlZF9kZXYiKTsKIAorCS8qCisJICogUmVhZC1haGVhZCByZXF1ZXN0cyBvbiBhIGRlZ3Jh
ZGluZyBhbmQgcmVjb3ZlcmluZyBtZCByYWlkCisJICogKGUuZy4gcmFpZDYpIGRldmljZSBt
aWdodCBiZSBmYWlsdXJlZCBpbW1lZGlhdGVseSBieSBtZAorCSAqIHJhaWQgY29kZSwgd2hp
Y2ggaXMgbm90IGEgcmVhbCBoYXJkd2FyZSBtZWRpYSBmYWlsdXJlLiBTbworCSAqIHdlIHNo
b3VsZG4ndCBjb3VudCBmYWlsZWQgUkVRX1JBSEVBRCBiaW8gdG8gZGMtPmlvX2Vycm9ycy4K
KwkgKi8KKwlpZiAoYmlvLT5iaV9vcGYgJiBSRVFfUkFIRUFEKSB7CisJCXByX3dhcm4oIiVz
OiBSZWFkLWFoZWFkIEkvTyBmYWlsZWQgb24gYmFja2luZyBkZXZpY2UsIGlnbm9yZSIsCisJ
CQlkYy0+YmFja2luZ19kZXZfbmFtZSk7CisJCXJldHVybjsKKwl9CisKIAllcnJvcnMgPSBh
dG9taWNfYWRkX3JldHVybigxLCAmZGMtPmlvX2Vycm9ycyk7CiAJaWYgKGVycm9ycyA8IGRj
LT5lcnJvcl9saW1pdCkKIAkJcHJfZXJyKCIlczogSU8gZXJyb3Igb24gYmFja2luZyBkZXZp
Y2UsIHVucmVjb3ZlcmFibGUiLAotLSAKMi4xNi40Cgo=
--------------49AA7B823012F96B9D851349--
