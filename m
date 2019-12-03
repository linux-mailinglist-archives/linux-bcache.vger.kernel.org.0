Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB78510FF9F
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Dec 2019 15:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfLCOJz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Dec 2019 09:09:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:43782 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbfLCOJz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Dec 2019 09:09:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 85C8BAC9D;
        Tue,  3 Dec 2019 14:09:50 +0000 (UTC)
Subject: Re: [PATCH] bcache: add REQ_FUA to avoid data lost in writeback mode
To:     kungf <wings.wyang@gmail.com>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191202102409.3980-1-wings.wyang@gmail.com>
 <785fe04f-f841-3083-66db-53fab7bc0577@suse.de>
 <CAMo46+q-usqgwHWhk2mcKMvK9yMY2kfN-t10wyqm+pv8L0HqYA@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <74b8fcf6-b5e0-7cae-d860-0ed894bfe938@suse.de>
Date:   Tue, 3 Dec 2019 22:09:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAMo46+q-usqgwHWhk2mcKMvK9yMY2kfN-t10wyqm+pv8L0HqYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/3 3:16 下午, kungf wrote:
> 
> 
> On Mon, 2 Dec 2019 at 19:09, Coly Li <colyli@suse.de
> <mailto:colyli@suse.de>> wrote:
>>
>> On 2019/12/2 6:24 下午, kungf wrote:
>> > data may lost when in the follow scene of writeback mode:
>> > 1. client write data1 to bcache
>> > 2. client fdatasync
>> > 3. bcache flush cache set and backing device
>> > if now data1 was not writed back to backing, it was only guaranteed
> safe in cache.
>> > 4.then cache writeback data1 to backing with only REQ_OP_WRITE
>> > So data1 was not guaranteed in non-volatile storage,  it may lost if
>  power interruption
>> >
>>
>> Hi,
>>
>> Do you encounter such problem in real work load ? With bcache journal, I
>> don't see the possibility of data lost with your description.
>>
>> Correct me if I am wrong.
>>
>> Coly Li
>>
> Hi Coly,
> 
> Sorry to confuse you.  As i known now, write_dirty function write dirty
> to backing without FUA，and write_dirty_finish make dirty key clean,
> it means the data indexed by the key will not be writeback again, am i
> wrong?

Yes, you are right. This is the behavior as design. We don't guarantee
the data will be on always on platter, this is what most storage systems do.

> I only find that the backing device will be flushed when bcache get an
> PREFLUSH bio, any other place  it will be flushed in journal?
> 

Storage system flushes its buffer when upper layer requires, that means
if the application wants to make its writing data flushed on platter, it
should explicitly issue a flush request.

What you observe and test are all as designed IMHO. The I/O stack does
not guarantee any data persistent on storage media unless an explicit
flush request received from upper layer and returned to upper layer.

Coly Li

> I made a test that write bcache with dd，and then detach it, blktrace
> the cache and backing device at the same time.
> 1. close writeback
> # echo 0 > /sys/block/bcache0/bcache/writeback_running
> 2. write data with a fdatasync
> #dd if=/dev/zero of=/dev/bcache0 bs=16k count=1 oflag=direct
> 3. detach and trigger writeback
> #echo b1f40ca5-37a3-4852-9abf-6abed96d71db >/sys/block/bcache0/bcache/detach
> 
> the blow text is blkparse result.
> from cache blktrace blow, we can see 16k data write to cache set, and
> then flush with op FWFSM (PREFLUSH| WRITE| FUA|SYNC|META )
> ```
>   8,160 33        1     0.000000000 222844  A   W 630609920 + 32 <-
> (8,167) 1464320
>   8,167 33        2     0.000000478 222844  Q   W 630609920 + 32 [dd]
>   8,167 33        3     0.000006167 222844  G   W 630609920 + 32 [dd]
>   8,167 33        5     0.000011385 222844  I   W 630609920 + 32 [dd]
>   8,167 33        6     0.000023890   948  D   W 630609920 + 32
> [kworker/33:1H]
>   8,167 33        7     0.000111203     0  C   W 630609920 + 32 [0]
>   8,160 34        1     0.000167029 215616  A FWFSM 629153808 + 8 <-
> (8,167) 8208
>   8,167 34        2     0.000167490 215616  Q FWFSM 629153808 + 8
> [kworker/34:2]
>   8,167 34        3     0.000169061 215616  G FWFSM 629153808 + 8
> [kworker/34:2]
>   8,167 34        4     0.000301308   949  D WFSM 629153808 + 8
> [kworker/34:1H]
>   8,167 34        5     0.000348832     0  C WFSM 629153808 + 8 [0]
>   8,167 34        6     0.000349612     0  C WFSM 629153808 [0]
> ```
> 
> from backing blktrace blow, the backing device first get flush op FWS
> (PERFLUSH|WRITE|SYNC)  because of we stop writeback, then get W op after
> detach,
> the 16k data was writeback to backing device, and after this, the
> backing device never get flush op, */it means that the 16k data we write
> it's not safe in backing/*
> */device, even we dd write with fdatasync./*
> ```
>   8,144 33        1     0.000000000 222844  Q WSM 8 + 8 [dd]
>   8,144 33        2     0.000016609 222844  G WSM 8 + 8 [dd]
>   8,144 33        5     0.000020710 222844  I WSM 8 + 8 [dd]
>   8,144 33        6     0.000031967   948  D WSM 8 + 8 [kworker/33:1H]
>   8,144 33        7     0.000152945 88631  C  WS 16 + 32 [0]
>   8,144 34        1     0.000186127 215616  Q FWS [kworker/34:2]
>   8,144 34        2     0.000187006 215616  G FWS [kworker/34:2]
>   8,144 33        8     0.000326761     0  C WSM 8 + 8 [0]
>   8,144 34        3     0.020195027     0  C  WS 16 [0]
>   8,144 34        4     0.020195904     0  C FWS 16 [0]
>   8,144 23        1    19.415130395 215884  Q   W 16 + 32 [kworker/23:2]
>   8,144 23        2    19.415132072 215884  G   W 16 + 32 [kworker/23:2]
>   8,144 23        3    19.415133134 215884  I   W 16 + 32 [kworker/23:2]
>   8,144 23        4    19.415137776  1215  D   W 16 + 32 [kworker/23:1H]
>   8,144 23        5    19.416607260     0  C   W 16 + 32 [0]
>   8,144 24        1    19.416640754 222593  Q WSM 8 + 8 [bcache_writebac]
>   8,144 24        2    19.416642698 222593  G WSM 8 + 8 [bcache_writebac]
>   8,144 24        3    19.416643505 222593  I WSM 8 + 8 [bcache_writebac]
>   8,144 24        4    19.416650589  1107  D WSM 8 + 8 [kworker/24:1H]
>   8,144 24        5    19.416865258     0  C WSM 8 + 8 [0]
>   8,144 24        6    19.416871350 221889  Q WSM 8 + 8 [kworker/24:1]
>   8,144 24        7    19.416872201 221889  G WSM 8 + 8 [kworker/24:1]
>   8,144 24        8    19.416872542 221889  I WSM 8 + 8 [kworker/24:1]
>   8,144 24        9    19.416875458  1107  D WSM 8 + 8 [kworker/24:1H]
>   8,144 24       10    19.417076935     0  C WSM 8 + 8 [0]
> ```
> 
> 
> 
> On Mon, 2 Dec 2019 at 19:09, Coly Li <colyli@suse.de
> <mailto:colyli@suse.de>> wrote:
> 
>     On 2019/12/2 6:24 下午, kungf wrote:
>     > data may lost when in the follow scene of writeback mode:
>     > 1. client write data1 to bcache
>     > 2. client fdatasync
>     > 3. bcache flush cache set and backing device
>     > if now data1 was not writed back to backing, it was only
>     guaranteed safe in cache.
>     > 4.then cache writeback data1 to backing with only REQ_OP_WRITE
>     > So data1 was not guaranteed in non-volatile storage,  it may lost
>     if  power interruption 
>     >
> 
>     Hi,
> 
>     Do you encounter such problem in real work load ? With bcache journal, I
>     don't see the possibility of data lost with your description.
> 
>     Correct me if I am wrong.
> 
>     Coly Li
> 
>     > Signed-off-by: kungf <wings.wyang@gmail.com
>     <mailto:wings.wyang@gmail.com>>
>     > ---
>     >  drivers/md/bcache/writeback.c | 2 +-
>     >  1 file changed, 1 insertion(+), 1 deletion(-)
>     >
>     > diff --git a/drivers/md/bcache/writeback.c
>     b/drivers/md/bcache/writeback.c
>     > index 4a40f9eadeaf..e5cecb60569e 100644
>     > --- a/drivers/md/bcache/writeback.c
>     > +++ b/drivers/md/bcache/writeback.c
>     > @@ -357,7 +357,7 @@ static void write_dirty(struct closure *cl)
>     >        */
>     >       if (KEY_DIRTY(&w->key)) {
>     >               dirty_init(w);
>     > -             bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
>     > +             bio_set_op_attrs(&io->bio, REQ_OP_WRITE | REQ_FUA, 0);
>     >               io->bio.bi_iter.bi_sector = KEY_START(&w->key);
>     >               bio_set_dev(&io->bio, io->dc->bdev);
>     >               io->bio.bi_end_io       = dirty_endio;
>     >
> 
