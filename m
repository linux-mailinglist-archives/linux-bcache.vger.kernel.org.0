Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5653034C6E
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Jun 2019 17:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfFDPlv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Jun 2019 11:41:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:53058 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728115AbfFDPlv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Jun 2019 11:41:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2F140AE8A;
        Tue,  4 Jun 2019 15:41:49 +0000 (UTC)
Subject: Re: bcache: oops when writing to writeback_percent without a cache
 device
From:   Coly Li <colyli@suse.de>
To:     =?UTF-8?Q?Bj=c3=b8rn_Forsman?= <bjorn.forsman@gmail.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <CAEYzJUH1L5qyWKN3_s4Sz81frho6nKB9bkyDoGxXCvLNO484ew@mail.gmail.com>
 <6823d3ab-5f93-da74-0dbc-19bdb7be6907@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <3399cad5-4387-dd23-77f1-a70e551fb531@suse.de>
Date:   Tue, 4 Jun 2019 23:41:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6823d3ab-5f93-da74-0dbc-19bdb7be6907@suse.de>
Content-Type: multipart/mixed;
 boundary="------------102620AF45697B91F3AE3BB5"
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------102620AF45697B91F3AE3BB5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2019/6/4 10:59 下午, Coly Li wrote:
> On 2019/6/4 7:00 下午, Bjørn Forsman wrote:
>> Hi all,
>>
>> I get a kernel oops from bcache when writing to
>> /sys/block/bcache0/bcache/writeback_percent and there is no attached
>> cache device. See the oops itself below my signature.
>>
>> This is on Linux 4.19.46. I looked in git and see many commits to
>> bcache lately, but none seem to address this particular issue.
>>
>> Background: I'm writing to .../writeback_percent with
>> systemd-tmpfiles. I'd rather not replace it with a script that figures
>> out whether or not the kernel will oops if writing to the sysfs file
>> -- the kernel should not oops in the first place.
> 
> Hi Bjorn,
> 
> Thank you for the reporting. I believe this is a case we missed in
> testings. When a bcache device is not attached, it does not make sense
> to update the writeback rate in period by the changing of writeback_percent.
> 
> I will post a patch for your testing soon.

Hi Bjorn,

Could you please to try this patch ? Hope it may help a bit.

Thanks.

Coly Li


>>
>> Jun 04 12:35:42 kernel: BUG: unable to handle kernel NULL pointer
>> dereference at 0000000000000340
>> Jun 04 12:35:42 kernel: PGD 0 P4D 0
>> Jun 04 12:35:42 kernel: Oops: 0000 [#1] SMP PTI
>> Jun 04 12:35:42 kernel: CPU: 6 PID: 20266 Comm: kworker/6:220 Not
>> tainted 4.19.46 #1-NixOS
>> Jun 04 12:35:42 kernel: Hardware name: To Be Filled By O.E.M. To Be
>> Filled By O.E.M./X99 Extreme4/3.1, BIOS P3.60 04/06/2018
>> Jun 04 12:35:42 kernel: Workqueue: events update_writeback_rate [bcache]
>> Jun 04 12:35:42 kernel: RIP: 0010:update_writeback_rate+0x2f/0x2e0 [bcache]
[snipped]

--------------102620AF45697B91F3AE3BB5
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-bcache-only-set-BCACHE_DEV_WB_RUNNING-when-cached-de.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-bcache-only-set-BCACHE_DEV_WB_RUNNING-when-cached-de.pa";
 filename*1="tch"

RnJvbSA5ZGVhMWU2YWQwZTZjNDBlM2JjNmVlNmNmNGFkMjQzYzA3Y2E2Y2E5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KRGF0ZTog
VHVlLCA0IEp1biAyMDE5IDIzOjI0OjA5ICswODAwClN1YmplY3Q6IFtQQVRDSF0gYmNhY2hl
OiBvbmx5IHNldCBCQ0FDSEVfREVWX1dCX1JVTk5JTkcgd2hlbiBjYWNoZWQgZGV2aWNlCiBh
dHRhY2hlZAoKV2hlbiBwZW9wbGUgc2V0IGEgd3JpdGViYWNrIHBlcmNlbnQgdmlhIHN5c2Zz
IGZpbGUsCiAgL3N5cy9ibG9jay9iY2FjaGU8Tj4vYmNhY2hlL3dyaXRlYmFja19wZXJjZW50
CmN1cnJlbnQgY29kZSBkaXJlY3RseSBzZXRzIEJDQUNIRV9ERVZfV0JfUlVOTklORyB0byBk
Yy0+ZGlzay5mbGFncwphbmQgc2NoZWR1bGVzIGt3b3JrZXIgZGMtPndyaXRlYmFja19yYXRl
X3VwZGF0ZS4KCklmIHRoZXJlIGlzIG5vIGNhY2hlIHNldCBhdHRhY2hlZCB0bywgdGhlIHdy
aXRlYmFjIGtlcm5lbCB0aHJlYWQgaXMKbm90IHJ1bm5pbmcgaW5kZWVkLCBydW5uaW5nIGRj
LT53cml0ZWJhY2tfcmF0ZV91cGRhdGUgZG9lcyBub3QgbWFrZQpzZW5zZSBhbmQgbWF5IGNh
dXNlIE5VTEwgcG9pbnRlciBkZWZlcmVuY2Ugd2hlbiByZWZlcmVuY2UgY2FjaGUgc2V0CnBv
aW50ZXIgaW5zaWRlIHVwZGF0ZV93cml0ZWJhY2tfcmF0ZSgpLgoKVGhpcyBwYXRjaCBjaGVj
a3Mgd2hldGhlciB0aGUgY2FjaGUgc2V0IHBvaW50IChkYy0+ZGlzay5jKSBpcyBOVUxMIGlu
CnN5c2ZzIGludGVyZmFjZSBoYW5kbGVyLCBhbmQgb25seSBzZXQgQkNBQ0hFX0RFVl9XQl9S
VU5OSU5HIGFuZApzY2hlZHVsZSBkYy0+d3JpdGViYWNrX3JhdGVfdXBkYXRlIHdoZW4gZGMt
PmRpc2suYyBpcyBub3QgTlVMTCAoaXQKbWVhbnMgdGhlIGNhY2hlIGRldmljZSBpcyBhdHRh
Y2hlZCB0byBhIGNhY2hlIHNldCkuCgpSZXBvcnRlZC1ieTogQmrDuHJuIEZvcnNtYW4gPGJq
b3JuLmZvcnNtYW5AZ21haWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBDb2x5IExpIDxjb2x5bGlA
c3VzZS5kZT4KLS0tCiBkcml2ZXJzL21kL2JjYWNoZS9zeXNmcy5jIHwgNyArKysrKystCiAx
IGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9tZC9iY2FjaGUvc3lzZnMuYyBiL2RyaXZlcnMvbWQvYmNhY2hlL3N5
c2ZzLmMKaW5kZXggMTI5MDMxNjYzY2M4Li5lYjY3OGU0M2FjMDAgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvbWQvYmNhY2hlL3N5c2ZzLmMKKysrIGIvZHJpdmVycy9tZC9iY2FjaGUvc3lzZnMu
YwpAQCAtNDMwLDggKzQzMCwxMyBAQCBTVE9SRShiY2hfY2FjaGVkX2RldikKIAkJCWJjaF93
cml0ZWJhY2tfcXVldWUoZGMpOwogCX0KIAorCS8qCisJICogT25seSBzZXQgQkNBQ0hFX0RF
Vl9XQl9SVU5OSU5HIHdoZW4gY2FjaGVkIGRldmljZSBhdHRhY2hlZCB0bworCSAqIGEgY2Fj
aGUgc2V0LCBvdGhlcndpc2UgaXQgZG9lc24ndCBtYWtlIHNlbnNlLgorCSAqLwogCWlmIChh
dHRyID09ICZzeXNmc193cml0ZWJhY2tfcGVyY2VudCkKLQkJaWYgKCF0ZXN0X2FuZF9zZXRf
Yml0KEJDQUNIRV9ERVZfV0JfUlVOTklORywgJmRjLT5kaXNrLmZsYWdzKSkKKwkJaWYgKChk
Yy0+ZGlzay5jICE9IE5VTEwpICYmCisJCSAgICAoIXRlc3RfYW5kX3NldF9iaXQoQkNBQ0hF
X0RFVl9XQl9SVU5OSU5HLCAmZGMtPmRpc2suZmxhZ3MpKSkKIAkJCXNjaGVkdWxlX2RlbGF5
ZWRfd29yaygmZGMtPndyaXRlYmFja19yYXRlX3VwZGF0ZSwKIAkJCQkgICAgICBkYy0+d3Jp
dGViYWNrX3JhdGVfdXBkYXRlX3NlY29uZHMgKiBIWik7CiAKLS0gCjIuMTYuNAoK
--------------102620AF45697B91F3AE3BB5--
