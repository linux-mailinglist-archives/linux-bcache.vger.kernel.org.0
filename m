Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F9D5B2E7
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Jul 2019 04:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfGACYH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 30 Jun 2019 22:24:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:34094 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726787AbfGACYH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 30 Jun 2019 22:24:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 091FAAD14;
        Mon,  1 Jul 2019 02:24:06 +0000 (UTC)
Subject: Re: I/O Reordering: Cache -> Backing Device
To:     Don Doerner <Don.Doerner@Quantum.Com>
References: <BYAPR14MB27766E20D92C2A07217C2DF9FCFC0@BYAPR14MB2776.namprd14.prod.outlook.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Message-ID: <d06e4a83-c314-46b7-72ea-97e455acd69f@suse.de>
Date:   Mon, 1 Jul 2019 10:23:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <BYAPR14MB27766E20D92C2A07217C2DF9FCFC0@BYAPR14MB2776.namprd14.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/29 5:56 上午, Don Doerner wrote:
> Hello,
> I'm also interested in using bcache to facilitate stripe re-ass'y for the backing device.  I've done some experiments that dovetail with some of the traffic on this mailing list.  Specifically, in this message (https://www.spinics.net/lists/linux-bcache/msg07590.html), Eric suggested "...turning up /sys/block/bcache0/bcache/writeback_percent..." to increase the contiguous data in the cache.
> My RAID-6 has a stripe size of 2.5MiB, and its bcache'ed with a few hundred GB of NVMe storage.  Here's my experiment:
> * I made the cache a write back cache: echo writeback > /sys/block/bcache0/bcache/cache_mode
> * I plugged the cache: echo 0 > /sys/block/bcache0/bcache/writeback_running
> * I use a pathological I/O pattern, generated with 'fio': fio --bs=128K --direct=1 --rw=randwrite --ioengine=libaio --iodepth=1 --numjobs=1 --size=40G --name=/dev/bcache0.  I let it run to completion, at which point I believe I should have 40 GiB of sequential dirty data in cache, but not put there sequentially.  In essence, I should have ~16K complete stripes sitting in the cache, waiting to be written.
> * I set stuff up to go like a bat: echo 0 > /sys/block/bcache0/bcache/writeback_percent; echo 0 > /sys/block/bcache0/bcache/writeback_delay; echo 2097152 > /sys/block/bcache0/bcache/writeback_rate
> * And I unplugged the cache: echo 1 > /sys/block/bcache0/bcache/writeback_running
> I then watched 'iostat', and saw that there were lots of read operations (statistically, after merging, about 1 read for every 7 writes) - more than I had expected... that's enough that I concluded it wasn't building full stripes.  It kinda looks like it's playing back a journal sorted in time then LBA, or something like that...
> Any suggestions for improving (reducing) the ratio of reads to writes will be gratefully accepted!

Hi Don,

If the backing device has expensive stripe cost, the upper layer should
issue I/Os with stripe size alignment, otherwise bcache cannot to too
much to make the I/O to be stripe optimized.

And you are right that bcache does not writeback in restrict LBA order,
this is because the internal btree is trend to be appended only. The LBA
ordering writeback happens in a reasonable small range, not in whole
cached data, see commit 6e6ccc67b9c7 ("bcache: writeback: properly order
backing device IO").

And I agree with you again that "improving (reducing) the ratio of reads
to writes will be gratefully accepted". Indeed not only reducing reads
to writes ratio, but also increase the reads to writes throughput. This
is something I want to improve, after I understand why the problem
exists in bcache writeback code ...

Thanks.

-- 

Coly Li
