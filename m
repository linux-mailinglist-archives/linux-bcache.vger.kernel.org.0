Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACCD64A37
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Jul 2019 17:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfGJP5l (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Jul 2019 11:57:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:44332 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725832AbfGJP5k (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Jul 2019 11:57:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DE320AEEC;
        Wed, 10 Jul 2019 15:57:38 +0000 (UTC)
Subject: Re: [PATCH] bcache: fix deadlock in bcache_allocator()
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190710093117.GA2792@xps-13>
 <82f1c5a9-9da4-3529-1ca5-af724d280580@suse.de> <20190710154656.GA7572@xps-13>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <fbe27731-240b-7ad1-806c-612cca1269b9@suse.de>
Date:   Wed, 10 Jul 2019 23:57:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710154656.GA7572@xps-13>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/7/10 11:46 下午, Andrea Righi wrote:
> On Wed, Jul 10, 2019 at 11:11:37PM +0800, Coly Li wrote:
>> On 2019/7/10 5:31 下午, Andrea Righi wrote:
>>> bcache_allocator() can call the following:
>>>
>>>  bch_allocator_thread()
>>>   -> bch_prio_write()
>>>      -> bch_bucket_alloc()
>>>         -> wait on &ca->set->bucket_wait
>>>
>>> But the wake up event on bucket_wait is supposed to come from
>>> bch_allocator_thread() itself => deadlock:
>>>
>>>  [ 242.888435] INFO: task bcache_allocato:9015 blocked for more than 120 seconds.
>>>  [ 242.893786] Not tainted 4.20.0-042000rc3-generic #201811182231
>>>  [ 242.896669] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>  [ 242.900428] bcache_allocato D 0 9015 2 0x80000000
>>>  [ 242.900434] Call Trace:
>>>  [ 242.900448] __schedule+0x2a2/0x880
>>>  [ 242.900455] ? __schedule+0x2aa/0x880
>>>  [ 242.900462] schedule+0x2c/0x80
>>>  [ 242.900480] bch_bucket_alloc+0x19d/0x380 [bcache]
>>>  [ 242.900503] ? wait_woken+0x80/0x80
>>>  [ 242.900519] bch_prio_write+0x190/0x340 [bcache]
>>>  [ 242.900530] bch_allocator_thread+0x482/0xd10 [bcache]
>>>  [ 242.900535] kthread+0x120/0x140
>>>  [ 242.900546] ? bch_invalidate_one_bucket+0x80/0x80 [bcache]
>>>  [ 242.900549] ? kthread_park+0x90/0x90
>>>  [ 242.900554] ret_from_fork+0x35/0x40
>>>
>>> Fix by making the call to bch_prio_write() non-blocking, so that
>>> bch_allocator_thread() never waits on itself.
>>>
>>> Moreover, make sure to wake up the garbage collector thread when
>>> bch_prio_write() is failing to allocate buckets.
>>>
>>> BugLink: https://bugs.launchpad.net/bugs/1784665
>>> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
>>
>> Hi Andrea,
>>
> 
> Hi Coly,
> 

Hi Andrea,

>> >From the BugLink, it seems several critical bcache fixes are missing.
>> Could you please to try current 5.3-rc kernel, and try whether such
>> problem exists or not ?
> 
> Sure, I'll do a test with the latest 5.3-rc kernel. I just wanna mention
> that I've been able to reproduce this problem after backporting all the
> fixes (even those from linux-next), but I agree that testing 5.3-rc is a
> better idea (I may have introduced bugs while backporting stuff).
> 

Do you also back port the patches which are just merged into 5.3-rc ?
There are some fixes for deadlocking problems.

>>
>> For this patch itself, it looks good except that I am not sure whether
>> invoking garbage collection is a proper method. Because bch_prio_write()
>> is called right after garbage collection gets done, jump back to
>> retry_invalidate: again may just hide a non-space long time waiting
>> condition.
> 
> Honestly I was thinking the same, but if I don't call the garbage
> collector bch_allocator_thread() gets stuck forever (or for a very very
> long time) in the retry_invalidate loop...
> 
>>
>> Could you please give me some hint, on how to reproduce such hang
>> timeout situation. If I am lucky to reproduce such problem on 5.3-rc
>> kernel, it may be very helpful to understand what exact problem your
>> patch fixes.
> 
> Fortunately I have a reproducer, here's the script that I'm using:
> 

Great! Let me try this script, thank you very much :-)

Coly Li



> ---
> #!/bin/bash -x
> 
> BACKING=/sys/class/block/bcache0
> CACHE=/sys/fs/bcache/*-*-*
> while true; do
>     echo "1" | tee ${BACKING}/bcache/stop
>     echo "1" | tee ${CACHE}/stop
>     udevadm settle
>     [ ! -e "${BACKING}" -a ! -e "${CACHE}" ] && break
>     sleep 1
> done
> wipefs --all --force /dev/vdc2
> wipefs --all --force /dev/vdc1
> wipefs --all --force /dev/vdc
> wipefs --all --force /dev/vdd
> blockdev --rereadpt /dev/vdc
> blockdev --rereadpt /dev/vdd
> udevadm settle
> 
> # create ext4 fs over bcache
> parted /dev/vdc --script mklabel msdos || exit 1
> udevadm settle --exit-if-exists=/dev/vdc
> parted /dev/vdc --script mkpart primary 2048s 2047999s || exit 1
> udevadm settle --exit-if-exists=/dev/vdc1
> parted /dev/vdc --script mkpart primary 2048000s 20922367s || exit 1
> udevadm settle --exit-if-exists=/dev/vdc2
> make-bcache -C /dev/vdd || exit 1
> while true; do
>     udevadm settle
>     CSET=`ls /sys/fs/bcache | grep -- -`
>     [ -n "$CSET" ] && break;
>     sleep 1
> done
> make-bcache -B /dev/vdc2 || exit 1
> while true; do
>     udevadm settle
>     [ -e "${BACKING}" ] && break
>     sleep 1;
> done
> echo $CSET | tee ${BACKING}/bcache/attach
> udevadm settle --exit-if-exists=/dev/bcache0
> bcache-super-show /dev/vdc2
> udevadm settle
> mkfs.ext4 -F -L boot-fs -U e9f00d20-95a0-11e8-82a2-525400123401 /dev/vdc1
> udevadm settle
> mkfs.ext4 -F -L root-fs -U e9f00d21-95a0-11e8-82a2-525400123401 /dev/bcache0 || exit 1
> blkid
> ---
> 
> I just run this as root in a busy loop (something like
> `while :; do ./test.sh; done`) on a kvm instance with two extra disks
> (in addition to the root disk).
> 
> The extra disks are created as following:
> 
>  qemu-img create -f qcow2 disk1.qcow 10G
>  qemu-img create -f qcow2 disk2.qcow 2G
> 
> I'm using these particular sizes, but I think we can reproduce the same
> problem also using different sizes.
> 
> Thanks,
> -Andrea
> 


-- 

Coly Li
