Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671E9323910
	for <lists+linux-bcache@lfdr.de>; Wed, 24 Feb 2021 09:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhBXIxO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 24 Feb 2021 03:53:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:55146 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234605AbhBXIwz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Feb 2021 03:52:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 90F84AF3E;
        Wed, 24 Feb 2021 08:52:05 +0000 (UTC)
Subject: Re: Large latency with bcache for Ceph OSD
To:     "Norman.Kern" <norman.kern@gmx.com>
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk,
        linux-bcache@vger.kernel.org
References: <3f3e20a3-c165-1de1-7fdd-f0bd4da598fe@gmx.com>
 <632258f7-b138-3fba-456b-9da37c1de710@gmx.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <5867daf1-0960-39aa-1843-1a76c1e9a28d@suse.de>
Date:   Wed, 24 Feb 2021 16:52:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <632258f7-b138-3fba-456b-9da37c1de710@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/22/21 7:48 AM, Norman.Kern wrote:
> Ping.
> 
> I'm confused on the SYNC I/O on bcache. why SYNC I/O must be writen back
> for persistent cache?  It can cause some latency.
> 
> @Coly, can you give help me to explain why bcache handle O_SYNC like this.?
> 
> 

Hmm, normally we won't observe the application issuing I/Os on backing
device except for,
- I/O bypass by SSD congestion
- Sequential I/O request
- Dirty buckets exceeds the cutoff threshold
- Write through mode

Do you set the write/read congestion threshold to 0 ?

Coly Li

> On 2021/2/18 下午3:56, Norman.Kern wrote:
>> Hi guys,
>>
>> I am testing ceph with bcache, I found some I/O with O_SYNC writeback
>> to HDD, which caused large latency on HDD, I trace the I/O with iosnoop:
>>
>> ./iosnoop  -Q -ts -d '8,192
>>
>> Tracing block I/O for 1 seconds (buffered)...
>> STARTs          ENDs            COMM         PID    TYPE DEV
>> BLOCK        BYTES     LATms
>>
>> 1809296.292350  1809296.319052  tp_osd_tp    22191  R    8,192
>> 4578940240   16384     26.70
>> 1809296.292330  1809296.320974  tp_osd_tp    22191  R    8,192
>> 4577938704   16384     28.64
>> 1809296.292614  1809296.323292  tp_osd_tp    22191  R    8,192
>> 4600404304   16384     30.68
>> 1809296.292353  1809296.325300  tp_osd_tp    22191  R    8,192
>> 4578343088   16384     32.95
>> 1809296.292340  1809296.328013  tp_osd_tp    22191  R    8,192
>> 4578055472   16384     35.67
>> 1809296.292606  1809296.330518  tp_osd_tp    22191  R    8,192
>> 4578581648   16384     37.91
>> 1809295.169266  1809296.334041  bstore_kv_fi 17266  WS   8,192
>> 4244996360   4096    1164.78
>> 1809296.292618  1809296.336349  tp_osd_tp    22191  R    8,192
>> 4602631760   16384     43.73
>> 1809296.292618  1809296.338812  tp_osd_tp    22191  R    8,192
>> 4602632976   16384     46.19
>> 1809296.030103  1809296.342780  tp_osd_tp    22180  WS   8,192
>> 4741276048   131072   312.68
>> 1809296.292347  1809296.345045  tp_osd_tp    22191  R    8,192
>> 4609037872   16384     52.70
>> 1809296.292620  1809296.345109  tp_osd_tp    22191  R    8,192
>> 4609037904   16384     52.49
>> 1809296.292612  1809296.347251  tp_osd_tp    22191  R    8,192
>> 4578937616   16384     54.64
>> 1809296.292621  1809296.351136  tp_osd_tp    22191  R    8,192
>> 4612654992   16384     58.51
>> 1809296.292341  1809296.353428  tp_osd_tp    22191  R    8,192
>> 4578220656   16384     61.09
>> 1809296.292342  1809296.353864  tp_osd_tp    22191  R    8,192
>> 4578220880   16384     61.52
>> 1809295.167650  1809296.358510  bstore_kv_fi 17266  WS   8,192
>> 4923695960   4096    1190.86
>> 1809296.292347  1809296.361885  tp_osd_tp    22191  R    8,192
>> 4607437136   16384     69.54
>> 1809296.029363  1809296.367313  tp_osd_tp    22180  WS   8,192
>> 4739824400   98304    337.95
>> 1809296.292349  1809296.370245  tp_osd_tp    22191  R    8,192
>> 4591379888   16384     77.90
>> 1809296.292348  1809296.376273  tp_osd_tp    22191  R    8,192
>> 4591289552   16384     83.92
>> 1809296.292353  1809296.378659  tp_osd_tp    22191  R    8,192
>> 4578248656   16384     86.31
>> 1809296.292619  1809296.384835  tp_osd_tp    22191  R    8,192
>> 4617494160   65536     92.22
>> 1809295.165451  1809296.393715  bstore_kv_fi 17266  WS   8,192
>> 1355703120   4096    1228.26
>> 1809295.168595  1809296.401560  bstore_kv_fi 17266  WS   8,192
>> 1122200      4096    1232.96
>> 1809295.165221  1809296.408018  bstore_kv_fi 17266  WS   8,192
>> 960656       4096    1242.80
>> 1809295.166737  1809296.411505  bstore_kv_fi 17266  WS   8,192
>> 57682504     4096    1244.77
>> 1809296.292352  1809296.418123  tp_osd_tp    22191  R    8,192
>> 4579459056   32768    125.77
>>
>> I'm confused why write with O_SYNC must writeback on the backend
>> storage device?  And when I used bcache for a time,
>>
>> the latency increased a lot.(The SSD is not very busy), There's some
>> best practices on configuration?
>>

