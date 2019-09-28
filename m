Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD15C0FF8
	for <lists+linux-bcache@lfdr.de>; Sat, 28 Sep 2019 08:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbfI1Gdc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 Sep 2019 02:33:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:45954 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbfI1Gdc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 Sep 2019 02:33:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7BD64B1AB;
        Sat, 28 Sep 2019 06:33:29 +0000 (UTC)
Subject: Re: [bug report] bcache: A block layer cache
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     koverstreet@google.com, linux-bcache@vger.kernel.org
References: <20190925123252.GA5926@mwanda>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <c4d1a622-ad16-9db9-b47e-689c7b802cf0@suse.de>
Date:   Sat, 28 Sep 2019 14:33:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190925123252.GA5926@mwanda>
Content-Type: multipart/mixed;
 boundary="------------B23FF23819609ADE8AE4B148"
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------B23FF23819609ADE8AE4B148
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2019/9/25 8:32 下午, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch cafe56359144: "bcache: A block layer cache" from Mar 23,
> 2013, leads to the following static checker warning:
> 
> 	./drivers/md/bcache/super.c:770 bcache_device_free()
> 	warn: variable dereferenced before check 'd->disk' (see line 766)
> 
> drivers/md/bcache/super.c
>    762  static void bcache_device_free(struct bcache_device *d)
>    763  {
>    764          lockdep_assert_held(&bch_register_lock);
>    765  
>    766          pr_info("%s stopped", d->disk->disk_name);
>                                       ^^^^^^^^^
> Unchecked dereference.
> 
>    767  
>    768          if (d->c)
>    769                  bcache_device_detach(d);
>    770          if (d->disk && d->disk->flags & GENHD_FL_UP)
>                     ^^^^^^^
> Check too late.
> 
>    771                  del_gendisk(d->disk);
>    772          if (d->disk && d->disk->queue)
>    773                  blk_cleanup_queue(d->disk->queue);
>    774          if (d->disk) {
>    775                  ida_simple_remove(&bcache_device_idx,
>    776                                    first_minor_to_idx(d->disk->first_minor));
>    777                  put_disk(d->disk);
>    778          }
>    779  
> 
> regards,
> dan carpenter
> 

Hi Dan,

Could you please help to check whether the attached patch makes things a
little better ?

Thanks.

Coly Li

-- 

Coly Li

--------------B23FF23819609ADE8AE4B148
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-bcache-fix-static-checker-warning-in-bcache_device_f.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-bcache-fix-static-checker-warning-in-bcache_device_f.pa";
 filename*1="tch"

RnJvbSA2OTQ4MDExYzlhNmNkOWZjODgzMmFiZjczNjI3MjRiYjFlMDUxN2M3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KRGF0ZTog
U2F0LCAyOCBTZXAgMjAxOSAxNDoyMToyMyArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGJjYWNo
ZTogZml4IHN0YXRpYyBjaGVja2VyIHdhcm5pbmcgaW4gYmNhY2hlX2RldmljZV9mcmVlKCkK
CkNvbW1pdCBjYWZlNTYzNTkxNDQgKCJiY2FjaGU6IEEgYmxvY2sgbGF5ZXIgY2FjaGUiKSBs
ZWFkcyB0byB0aGUKZm9sbG93aW5nIHN0YXRpYyBjaGVja2VyIHdhcm5pbmc6CgogICAgLi9k
cml2ZXJzL21kL2JjYWNoZS9zdXBlci5jOjc3MCBiY2FjaGVfZGV2aWNlX2ZyZWUoKQogICAg
d2FybjogdmFyaWFibGUgZGVyZWZlcmVuY2VkIGJlZm9yZSBjaGVjayAnZC0+ZGlzaycgKHNl
ZSBsaW5lIDc2NikKCmRyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMKICAgNzYyICBzdGF0aWMg
dm9pZCBiY2FjaGVfZGV2aWNlX2ZyZWUoc3RydWN0IGJjYWNoZV9kZXZpY2UgKmQpCiAgIDc2
MyAgewogICA3NjQgICAgICAgICAgbG9ja2RlcF9hc3NlcnRfaGVsZCgmYmNoX3JlZ2lzdGVy
X2xvY2spOwogICA3NjUKICAgNzY2ICAgICAgICAgIHByX2luZm8oIiVzIHN0b3BwZWQiLCBk
LT5kaXNrLT5kaXNrX25hbWUpOwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIF5eXl5eXl5eXgpVbmNoZWNrZWQgZGVyZWZlcmVuY2UuCgogICA3NjcKICAgNzY4ICAg
ICAgICAgIGlmIChkLT5jKQogICA3NjkgICAgICAgICAgICAgICAgICBiY2FjaGVfZGV2aWNl
X2RldGFjaChkKTsKICAgNzcwICAgICAgICAgIGlmIChkLT5kaXNrICYmIGQtPmRpc2stPmZs
YWdzICYgR0VOSERfRkxfVVApCiAgICAgICAgICAgICAgICAgICAgXl5eXl5eXgpDaGVjayB0
b28gbGF0ZS4KCiAgIDc3MSAgICAgICAgICAgICAgICAgIGRlbF9nZW5kaXNrKGQtPmRpc2sp
OwogICA3NzIgICAgICAgICAgaWYgKGQtPmRpc2sgJiYgZC0+ZGlzay0+cXVldWUpCiAgIDc3
MyAgICAgICAgICAgICAgICAgIGJsa19jbGVhbnVwX3F1ZXVlKGQtPmRpc2stPnF1ZXVlKTsK
ICAgNzc0ICAgICAgICAgIGlmIChkLT5kaXNrKSB7CiAgIDc3NSAgICAgICAgICAgICAgICAg
IGlkYV9zaW1wbGVfcmVtb3ZlKCZiY2FjaGVfZGV2aWNlX2lkeCwKICAgNzc2ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgZmlyc3RfbWlub3JfdG9faWR4KGQtPmRpc2st
PmZpcnN0X21pbm9yKSk7CiAgIDc3NyAgICAgICAgICAgICAgICAgIHB1dF9kaXNrKGQtPmRp
c2spOwogICA3NzggICAgICAgICAgfQogICA3NzkKCkl0IGlzIG5vdCAxMDAlIHN1cmUgdGhh
dCB0aGUgZ2VuZGlzayBzdHJ1Y3Qgb2YgYmNhY2hlIGRldmljZSB3aWxsIGFsd2F5cwpiZSB0
aGVyZSwgdGhlIHdhcm5pbmcgbWFrZXMgc2Vuc2Ugd2hlbiB0aGVyZSBpcyBwcm9ibGVtIGlu
IGJsb2NrIGNvcmUuCgpUaGlzIHBhdGNoIHRyaWVzIHRvIHJlbW92ZSB0aGUgc3RhdGljIGNo
ZWNraW5nIHdhcm5pbmcgYnkgY2hlY2tpbmcKZC0+ZGlzayB0byBhdm9pZCBOVUxMIHBvaW50
ZXIgZGVmZXJlbmNlcy4KClJlcG9ydGVkLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVu
dGVyQG9yYWNsZS5jb20+ClNpZ25lZC1vZmYtYnk6IENvbHkgTGkgPGNvbHlsaUBzdXNlLmRl
PgotLS0KIGRyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgfCAyNCArKysrKysrKysrKysrKysr
LS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgYi9kcml2ZXJz
L21kL2JjYWNoZS9zdXBlci5jCmluZGV4IGViYjg1NGVkMDVhNC4uN2JlY2NlZGU1MzYwIDEw
MDY0NAotLS0gYS9kcml2ZXJzL21kL2JjYWNoZS9zdXBlci5jCisrKyBiL2RyaXZlcnMvbWQv
YmNhY2hlL3N1cGVyLmMKQEAgLTc2MSwyMCArNzYxLDI4IEBAIHN0YXRpYyBpbmxpbmUgaW50
IGlkeF90b19maXJzdF9taW5vcihpbnQgaWR4KQogCiBzdGF0aWMgdm9pZCBiY2FjaGVfZGV2
aWNlX2ZyZWUoc3RydWN0IGJjYWNoZV9kZXZpY2UgKmQpCiB7CisJc3RydWN0IGdlbmRpc2sg
KmRpc2sgPSBkLT5kaXNrOworCiAJbG9ja2RlcF9hc3NlcnRfaGVsZCgmYmNoX3JlZ2lzdGVy
X2xvY2spOwogCi0JcHJfaW5mbygiJXMgc3RvcHBlZCIsIGQtPmRpc2stPmRpc2tfbmFtZSk7
CisJaWYgKGRpc2spCisJCXByX2luZm8oIiVzIHN0b3BwZWQiLCBkaXNrLT5kaXNrX25hbWUp
OworCWVsc2UKKwkJcHJfZXJyKCJiY2FjaGUgZGV2aWNlIChOVUxMIGdlbmRpc2spIHN0b3Bw
ZWQiKTsKIAogCWlmIChkLT5jKQogCQliY2FjaGVfZGV2aWNlX2RldGFjaChkKTsKLQlpZiAo
ZC0+ZGlzayAmJiBkLT5kaXNrLT5mbGFncyAmIEdFTkhEX0ZMX1VQKQotCQlkZWxfZ2VuZGlz
ayhkLT5kaXNrKTsKLQlpZiAoZC0+ZGlzayAmJiBkLT5kaXNrLT5xdWV1ZSkKLQkJYmxrX2Ns
ZWFudXBfcXVldWUoZC0+ZGlzay0+cXVldWUpOwotCWlmIChkLT5kaXNrKSB7CisKKwlpZiAo
ZGlzaykgeworCQlpZiAoZGlzay0+ZmxhZ3MgJiBHRU5IRF9GTF9VUCkKKwkJCWRlbF9nZW5k
aXNrKGRpc2spOworCisJCWlmIChkaXNrLT5xdWV1ZSkKKwkJCWJsa19jbGVhbnVwX3F1ZXVl
KGRpc2stPnF1ZXVlKTsKKwogCQlpZGFfc2ltcGxlX3JlbW92ZSgmYmNhY2hlX2RldmljZV9p
ZHgsCi0JCQkJICBmaXJzdF9taW5vcl90b19pZHgoZC0+ZGlzay0+Zmlyc3RfbWlub3IpKTsK
LQkJcHV0X2Rpc2soZC0+ZGlzayk7CisJCQkJICBmaXJzdF9taW5vcl90b19pZHgoZGlzay0+
Zmlyc3RfbWlub3IpKTsKKwkJcHV0X2Rpc2soZGlzayk7CiAJfQogCiAJYmlvc2V0X2V4aXQo
JmQtPmJpb19zcGxpdCk7Ci0tIAoyLjE2LjQKCg==
--------------B23FF23819609ADE8AE4B148--
