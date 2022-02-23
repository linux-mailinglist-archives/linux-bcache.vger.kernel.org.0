Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0484C12B4
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Feb 2022 13:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiBWM1C (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Feb 2022 07:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237504AbiBWM1C (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Feb 2022 07:27:02 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF2310B9
        for <linux-bcache@vger.kernel.org>; Wed, 23 Feb 2022 04:26:32 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so2590318pjb.0
        for <linux-bcache@vger.kernel.org>; Wed, 23 Feb 2022 04:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:in-reply-to;
        bh=68u2FnuyL4eXHJtnhZZxRBE18GbRmk1wtYNf3Dg6wzU=;
        b=niepKqESgVZNcfJRkdj2ejn1uT5at9r5FiQFq0zECPUynlBNrFy+9h9BEh40H6vMWp
         skPrCeYLd7Xt2bN6LyQFim/HZNdNcOFwsFU/VPCIUNTiQ8EgUennWAMmVVEv1ThvlzUS
         O2p9F9ZYeuXStD+6yp8ns04XMbuDfR3hG2jRu/DFcqeRScKe/hcOlUGcsqK59d/WUmUY
         D0Ibc+EIOh+qGE5AY+qIohCbmqGqxam/pXxfefTlLXmg0JIQJvjnfgWsj1fHw4XnWSG6
         A1MXt4cgqVt5lgyoCpa/zdUExvqtF8OV7dVcOkjUzolYGK0berkKu9jF+FvFAwORcMmI
         eQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:in-reply-to;
        bh=68u2FnuyL4eXHJtnhZZxRBE18GbRmk1wtYNf3Dg6wzU=;
        b=73xtNnXZAJRvqYy3c5Ow1xAzug4Lt2TLQjV+IZih07HQbkP7XiLKykyf246w9/V3Km
         HNauQOlMu8nam5ahx+PH2WHPbzWldoIxt/YJyNoB6c/MV1smiGUAiB3nIPdg/cbejhdr
         WXy/oC97PUUh8aJ/RfNV1/6q0/w05dsjtcC+KWeRiz+rwRChlNtrDo4v+qx+RUTMeO94
         79LMpK4gx/p+RZ4ZKg7zHJSjH3Lz/a0KtmTF7PsMOxBBpGx79JqeFdCUKUXe9ZUyHa8y
         XyrHJjyKFV2sFhuOnbRSa7hC7EIfNArY/CeIVgcNFDcRXfYCt5a5dmdGxYZlFzr3Hehb
         eNzw==
X-Gm-Message-State: AOAM5326yMxu93XJpWrtk9RsFzcwXjM7yu8UVmcyZHcF8cWQsV09X2+b
        e4dmmT2ubuJMnbZjrU+xqYwZQp2mzGhr7ln7e9M=
X-Google-Smtp-Source: ABdhPJym9aftkEsLM1to1OZRvxQxJ0ErnbxKdto/zlMQtU8RzTdsEJ01Ulc28rPMmAQugCj80IBYfQ==
X-Received: by 2002:a17:90a:aa0a:b0:1b4:e1e3:9651 with SMTP id k10-20020a17090aaa0a00b001b4e1e39651mr8871908pjq.235.1645619191980;
        Wed, 23 Feb 2022 04:26:31 -0800 (PST)
Received: from [172.20.104.30] ([162.219.34.248])
        by smtp.gmail.com with ESMTPSA id k22sm15423533pgi.52.2022.02.23.04.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 04:26:31 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------mzmPuzsdpSWXutxJxcfFSxkB"
Message-ID: <252588da-1e44-71d9-95a0-39a70c5d3f42@gmail.com>
Date:   Wed, 23 Feb 2022 20:26:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
From:   Zhang Zhen <zhangzhen.email@gmail.com>
Subject: Re: bcache detach lead to xfs force shutdown
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, jianchao.wan9@gmail.com
References: <e6c45b07-769c-575b-0d9c-929aba6ab21a@gmail.com>
 <da192278-8d05-2cce-0301-abafeff3c2fb@suse.de>
In-Reply-To: <da192278-8d05-2cce-0301-abafeff3c2fb@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------mzmPuzsdpSWXutxJxcfFSxkB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2022/2/23 下午5:03, Coly Li 写道:
> On 2/21/22 5:33 PM, Zhang Zhen wrote:
>> Hi coly，
>>
>> We encounted a bcache detach problem, during the io process，the cache 
>> device become missing.
>>
>> The io error status returned to xfs， and in some case， the xfs do 
>> force shutdown.
>>
>> The dmesg as follows:
>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
>> error on writing btree.
>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p44: IO 
>> error on writing btree.
>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p44: IO 
>> error on writing btree.
>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: IO 
>> error on writing btree.
>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
>> error on writing btree.
>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: IO 
>> error on writing btree.
>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
>> error on writing btree.
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
>> "xfs_buf_iodone_callback_error" at daddr 0x80034658 len 32 error 12
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() bcache: error 
>> on 004f8aa7-561a-4ba7-bf7b-292e461d3f18:
>> Feb  2 20:59:23  kernel: journal io error
>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() , disabling 
>> caching
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: bcache: conditional_stop_bcache_device() 
>> stop_when_cache_set_failed of bcache43 is "auto" and cache is clean, 
>> keep it alive.
>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
>> "xlog_iodone" at daddr 0x400123e60 len 64 error 12
>> Feb  2 20:59:23  kernel: XFS (bcache43): xfs_do_force_shutdown(0x2) 
>> called from line 1298 of file fs/xfs/xfs_log.c. Return address = 
>> 00000000c1c8077f
>> Feb  2 20:59:23  kernel: XFS (bcache43): Log I/O Error Detected. 
>> Shutting down filesystem
>> Feb  2 20:59:23  kernel: XFS (bcache43): Please unmount the filesystem 
>> and rectify the problem(s)
>>
>>
>> We checked the code, the error status is returned in 
>> cached_dev_make_request and closure_bio_submit function.
>>
>> 1180 static blk_qc_t cached_dev_make_request(struct request_queue *q,
>> 1181                     struct bio *bio)
>> 1182 {
>> 1183     struct search *s;
>> 1184     struct bcache_device *d = bio->bi_disk->private_data;
>> 1185     struct cached_dev *dc = container_of(d, struct cached_dev, 
>> disk);
>> 1186     int rw = bio_data_dir(bio);
>> 1187
>> 1188     if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
>> &d->c->flags)) ||
>> 1189              dc->io_disable)) {
>> 1190         bio->bi_status = BLK_STS_IOERR;
>> 1191         bio_endio(bio);
>> 1192         return BLK_QC_T_NONE;
>> 1193     }
>>
>>  901 static inline void closure_bio_submit(struct cache_set *c,
>>  902                       struct bio *bio,
>>  903                       struct closure *cl)
>>  904 {
>>  905     closure_get(cl);
>>  906     if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
>>  907         bio->bi_status = BLK_STS_IOERR;
>>  908         bio_endio(bio);
>>  909         return;
>>  910     }
>>  911     generic_make_request(bio);
>>  912 }
>>
>> Can the cache set detached and don't return error status to fs?
> 
> 
> Hi Zhang,
> 
> 
> What is your kernel version and where do you get the kernel?
> My kernel version is 4.18 of Centos.
The code of this part is same with upstream kernel.
> It seems like an as designed behavior, could you please describe more 
> detail about the operation sequence?
> 
Yes, i think so too.
The reproduce opreation as follows:
1. mount a bcache disk with xfs

/dev/bcache1 on /media/disk1 type xfs

2. run ls in background
#!/bin/bash

while true
do
   echo 2 > /proc/sys/vm/drop_caches
   ls -R /media/disk1 > /dev/null
done


3. remove cache disk sdc
echo 1 >/sys/block/sdc/device/delete

4. dmesg should get xfs error

I write a patch to improve，please help to review it, thanks.
> 
> Thanks.
> 
> 
> Coly Li
> 
--------------mzmPuzsdpSWXutxJxcfFSxkB
Content-Type: text/plain; charset=UTF-8;
 name="0001-Bcache-don-t-return-BLK_STS_IOERR-during-cache-detac.patch"
Content-Disposition: attachment;
 filename*0="0001-Bcache-don-t-return-BLK_STS_IOERR-during-cache-detac.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBjYjRkZmYzMDkyNzA3YTMxMDE3Y2IzNzM2YmUzOTAzOWVjZTBlNjQ2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBaaGVuIFpoYW5nIDx6aGFuZ3poZW4uZW1haWxAZ21h
aWwuY29tPgpEYXRlOiBXZWQsIDIzIEZlYiAyMDIyIDAzOjQwOjI5IC0wODAwClN1YmplY3Q6
IFtQQVRDSF0gQmNhY2hlOiBkb24ndCByZXR1cm4gQkxLX1NUU19JT0VSUiBkdXJpbmcgY2Fj
aGUgZGV0YWNoCgpCZWZvcmUgdGhpcyBwYXRjaCwgaWYgY2FjaGUgZGV2aWNlIG1pc3Npbmcs
IGNhY2hlZF9kZXZfc3VibWl0X2JpbyByZXR1cm4gaW8gZXJyCnRvIGZzIGR1cmluZyBjYWNo
ZSBkZXRhY2gsIHJhbmRvbWx5IGxlYWQgdG8geGZzIGRvIGZvcmNlIHNodXRkb3duLgoKVGhp
cyBwYXRjaCBkZWxheSB0aGUgY2FjaGUgaW8gc3VibWl0IGluIGNhY2hlZF9kZXZfc3VibWl0
X2JpbwphbmQgd2FpdCBmb3IgY2FjaGUgc2V0IGRldGFjaCBmaW5pc2guClNvIGlmIHRoZSBj
YWNoZSBkZXZpY2UgYmVjb21lIG1pc3NpbmcsIGJjYWNoZSBkZXRhY2ggY2FjaGUgc2V0IGF1
dG9tYXRpY2FsbHksCmFuZCB0aGUgaW8gd2lsbCBzdW1iaXQgbm9ybWFsbHkuCgpGZWIgIDIg
MjA6NTk6MjMgIGtlcm5lbDogYmNhY2hlOiBiY2hfY291bnRfaW9fZXJyb3JzKCkgbnZtZTBu
MXA1NjogSU8gZXJyb3Igb24gd3JpdGluZyBidHJlZS4KRmViICAyIDIwOjU5OjIzICBrZXJu
ZWw6IGJjYWNoZTogYmNoX2NvdW50X2lvX2Vycm9ycygpIG52bWUwbjFwNTc6IElPIGVycm9y
IG9uIHdyaXRpbmcgYnRyZWUuCkZlYiAgMiAyMDo1OToyMyAga2VybmVsOiBiY2FjaGU6IGJj
aF9jb3VudF9pb19lcnJvcnMoKSBudm1lMG4xcDU2OiBJTyBlcnJvciBvbiB3cml0aW5nIGJ0
cmVlLgpGZWIgIDIgMjA6NTk6MjMgIGtlcm5lbDogYmNhY2hlOiBiY2hfYnRyZWVfaW5zZXJ0
KCkgZXJyb3IgLTUKRmViICAyIDIwOjU5OjIzICBrZXJuZWw6IFhGUyAoYmNhY2hlNDMpOiBt
ZXRhZGF0YSBJL08gZXJyb3IgaW4gInhmc19idWZfaW9kb25lX2NhbGxiYWNrX2Vycm9yIiBh
dCBkYWRkciAweDgwMDM0NjU4IGxlbiAzMiBlcnJvciAxMgpGZWIgIDIgMjA6NTk6MjMgIGtl
cm5lbDogYmNhY2hlOiBiY2hfYnRyZWVfaW5zZXJ0KCkgZXJyb3IgLTUKRmViICAyIDIwOjU5
OjIzICBrZXJuZWw6IGJjYWNoZTogYmNoX2J0cmVlX2luc2VydCgpIGVycm9yIC01CkZlYiAg
MiAyMDo1OToyMyAga2VybmVsOiBiY2FjaGU6IGJjaF9idHJlZV9pbnNlcnQoKSBlcnJvciAt
NQpGZWIgIDIgMjA6NTk6MjMgIGtlcm5lbDogYmNhY2hlOiBiY2hfYnRyZWVfaW5zZXJ0KCkg
ZXJyb3IgLTUKRmViICAyIDIwOjU5OjIzICBrZXJuZWw6IGJjYWNoZTogYmNoX2NhY2hlX3Nl
dF9lcnJvcigpIGJjYWNoZTogZXJyb3Igb24gMDA0ZjhhYTctNTYxYS00YmE3LWJmN2ItMjky
ZTQ2MWQzZjE4OgpGZWIgIDIgMjA6NTk6MjMgIGtlcm5lbDogam91cm5hbCBpbyBlcnJvcgpG
ZWIgIDIgMjA6NTk6MjMgIGtlcm5lbDogYmNhY2hlOiBiY2hfY2FjaGVfc2V0X2Vycm9yKCkg
LCBkaXNhYmxpbmcgY2FjaGluZwpGZWIgIDIgMjA6NTk6MjMgIGtlcm5lbDogYmNhY2hlOiBi
Y2hfYnRyZWVfaW5zZXJ0KCkgZXJyb3IgLTUKRmViICAyIDIwOjU5OjIzICBrZXJuZWw6IGJj
YWNoZTogY29uZGl0aW9uYWxfc3RvcF9iY2FjaGVfZGV2aWNlKCkgc3RvcF93aGVuX2NhY2hl
X3NldF9mYWlsZWQgb2YgYmNhY2hlNDMgaXMgImF1dG8iIGFuZCBjYWNoZSBpcyBjbGVhbiwg
a2VlcCBpdCBhbGl2ZS4KRmViICAyIDIwOjU5OjIzICBrZXJuZWw6IFhGUyAoYmNhY2hlNDMp
OiBtZXRhZGF0YSBJL08gZXJyb3IgaW4gInhsb2dfaW9kb25lIiBhdCBkYWRkciAweDQwMDEy
M2U2MCBsZW4gNjQgZXJyb3IgMTIKRmViICAyIDIwOjU5OjIzICBrZXJuZWw6IFhGUyAoYmNh
Y2hlNDMpOiB4ZnNfZG9fZm9yY2Vfc2h1dGRvd24oMHgyKSBjYWxsZWQgZnJvbSBsaW5lIDEy
OTggb2YgZmlsZSBmcy94ZnMveGZzX2xvZy5jLiBSZXR1cm4gYWRkcmVzcyA9IDAwMDAwMDAw
YzFjODA3N2YKRmViICAyIDIwOjU5OjIzICBrZXJuZWw6IFhGUyAoYmNhY2hlNDMpOiBMb2cg
SS9PIEVycm9yIERldGVjdGVkLiBTaHV0dGluZyBkb3duIGZpbGVzeXN0ZW0KRmViICAyIDIw
OjU5OjIzICBrZXJuZWw6IFhGUyAoYmNhY2hlNDMpOiBQbGVhc2UgdW5tb3VudCB0aGUgZmls
ZXN5c3RlbSBhbmQgcmVjdGlmeSB0aGUgcHJvYmxlbShzKQoKU2lnbmVkLW9mZi1ieTogWmhl
biBaaGFuZyA8emhhbmd6aGVuLmVtYWlsQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL21kL2Jj
YWNoZS9iY2FjaGUuaCAgfCA1IC0tLS0tCiBkcml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmMg
fCA4ICsrKystLS0tCiBkcml2ZXJzL21kL2JjYWNoZS9zdXBlci5jICAgfCAzICsrLQogMyBm
aWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL2JjYWNoZS5oIGIvZHJpdmVycy9tZC9iY2FjaGUv
YmNhY2hlLmgKaW5kZXggOWVkOWM5NTVhZGQ3Li5lNTIyN2RkMDhlM2EgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbWQvYmNhY2hlL2JjYWNoZS5oCisrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL2Jj
YWNoZS5oCkBAIC05MjgsMTEgKzkyOCw2IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBjbG9zdXJl
X2Jpb19zdWJtaXQoc3RydWN0IGNhY2hlX3NldCAqYywKIAkJCQkgICAgICBzdHJ1Y3QgY2xv
c3VyZSAqY2wpCiB7CiAJY2xvc3VyZV9nZXQoY2wpOwotCWlmICh1bmxpa2VseSh0ZXN0X2Jp
dChDQUNIRV9TRVRfSU9fRElTQUJMRSwgJmMtPmZsYWdzKSkpIHsKLQkJYmlvLT5iaV9zdGF0
dXMgPSBCTEtfU1RTX0lPRVJSOwotCQliaW9fZW5kaW8oYmlvKTsKLQkJcmV0dXJuOwotCX0K
IAlzdWJtaXRfYmlvX25vYWNjdChiaW8pOwogfQogCmRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2JjYWNoZS9yZXF1ZXN0LmMgYi9kcml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmMKaW5kZXgg
ZDE1YWFlNmM1MWMxLi4zNmYwZWU5NWI1MWYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvYmNh
Y2hlL3JlcXVlc3QuYworKysgYi9kcml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmMKQEAgLTEz
LDYgKzEzLDcgQEAKICNpbmNsdWRlICJyZXF1ZXN0LmgiCiAjaW5jbHVkZSAid3JpdGViYWNr
LmgiCiAKKyNpbmNsdWRlIDxsaW51eC9kZWxheS5oPgogI2luY2x1ZGUgPGxpbnV4L21vZHVs
ZS5oPgogI2luY2x1ZGUgPGxpbnV4L2hhc2guaD4KICNpbmNsdWRlIDxsaW51eC9yYW5kb20u
aD4KQEAgLTExNzIsMTEgKzExNzMsMTAgQEAgdm9pZCBjYWNoZWRfZGV2X3N1Ym1pdF9iaW8o
c3RydWN0IGJpbyAqYmlvKQogCXVuc2lnbmVkIGxvbmcgc3RhcnRfdGltZTsKIAlpbnQgcncg
PSBiaW9fZGF0YV9kaXIoYmlvKTsKIAotCWlmICh1bmxpa2VseSgoZC0+YyAmJiB0ZXN0X2Jp
dChDQUNIRV9TRVRfSU9fRElTQUJMRSwgJmQtPmMtPmZsYWdzKSkgfHwKKwl3aGlsZSAodW5s
aWtlbHkoKGQtPmMgJiYgdGVzdF9iaXQoQ0FDSEVfU0VUX0lPX0RJU0FCTEUsICZkLT5jLT5m
bGFncykpIHx8CiAJCSAgICAgZGMtPmlvX2Rpc2FibGUpKSB7Ci0JCWJpby0+Ymlfc3RhdHVz
ID0gQkxLX1NUU19JT0VSUjsKLQkJYmlvX2VuZGlvKGJpbyk7Ci0JCXJldHVybjsKKwkJLyog
d2FpdCBmb3IgZGV0YWNoIGZpbmlzaCBhbmQgZC0+YyA9PSBOVUxMLiAqLworCQltc2xlZXAo
Mik7CiAJfQogCiAJaWYgKGxpa2VseShkLT5jKSkgewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZC9iY2FjaGUvc3VwZXIuYyBiL2RyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMKaW5kZXggMTQw
ZjM1ZGMwYzQ1Li44ZDlhNWU5MzdiYzggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvYmNhY2hl
L3N1cGVyLmMKKysrIGIvZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYwpAQCAtNjYxLDcgKzY2
MSw4IEBAIGludCBiY2hfcHJpb193cml0ZShzdHJ1Y3QgY2FjaGUgKmNhLCBib29sIHdhaXQp
CiAJCXAtPmNzdW0JCT0gYmNoX2NyYzY0KCZwLT5tYWdpYywgbWV0YV9idWNrZXRfYnl0ZXMo
JmNhLT5zYikgLSA4KTsKIAogCQlidWNrZXQgPSBiY2hfYnVja2V0X2FsbG9jKGNhLCBSRVNF
UlZFX1BSSU8sIHdhaXQpOwotCQlCVUdfT04oYnVja2V0ID09IC0xKTsKKwkJaWYgKGJ1Y2tl
dCA9PSAtMSkKKwkJCXJldHVybiAtMTsKIAogCQltdXRleF91bmxvY2soJmNhLT5zZXQtPmJ1
Y2tldF9sb2NrKTsKIAkJcHJpb19pbyhjYSwgYnVja2V0LCBSRVFfT1BfV1JJVEUsIDApOwot
LSAKMi4yNS4xCgo=

--------------mzmPuzsdpSWXutxJxcfFSxkB--
