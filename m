Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6A82872B7
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Oct 2020 12:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgJHKqJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 8 Oct 2020 06:46:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:33204 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgJHKqJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Oct 2020 06:46:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 413E9AC4D;
        Thu,  8 Oct 2020 10:46:06 +0000 (UTC)
Subject: Re: [PATCH 1/3] bcache: introduce bcache sysfs entries for
 ioprio-based bypass/writeback hints
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Kai Krakow <kai@kaishome.de>, Nix <nix@esperi.org.uk>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
References: <20201003111056.14635-1-kai@kaishome.de>
 <20201003111056.14635-2-kai@kaishome.de> <87362ucen3.fsf@esperi.org.uk>
 <CAC2ZOYt+ZMep=PT5FbQKiqZ0EE1f4+JJn=oTJUtQjLwGvy=KfQ@mail.gmail.com>
 <alpine.LRH.2.11.2010051923330.2180@pop.dreamhost.com>
 <alpine.LRH.2.11.2010072022130.27518@pop.dreamhost.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <5c5dfd1d-55f3-e9cf-0c71-d69036cb3ded@suse.de>
Date:   Thu, 8 Oct 2020 18:45:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.2010072022130.27518@pop.dreamhost.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/10/8 04:35, Eric Wheeler wrote:
> [+cc coly]
> 
> On Mon, 5 Oct 2020, Eric Wheeler wrote:
>> On Sun, 4 Oct 2020, Kai Krakow wrote:
>>
>>> Hey Nix!
>>>
>>> Apparently, `git send-email` probably swallowed the patch 0/3 message for you.
>>>
>>> It was about adding one additional patch which reduced boot time for
>>> me with idle mode active by a factor of 2.
>>>
>>> You can look at it here:
>>> https://github.com/kakra/linux/pull/4
>>>
>>> It's "bcache: Only skip data request in io_prio bypass mode" just if
>>> you're curious.
>>>
>>> Regards,
>>> Kai
>>>
>>> Am So., 4. Okt. 2020 um 15:19 Uhr schrieb Nix <nix@esperi.org.uk>:
>>>>
>>>> On 3 Oct 2020, Kai Krakow spake thusly:
>>>>
>>>>> Having idle IOs bypass the cache can increase performance elsewhere
>>>>> since you probably don't care about their performance.  In addition,
>>>>> this prevents idle IOs from promoting into (polluting) your cache and
>>>>> evicting blocks that are more important elsewhere.
>>>>
>>>> FYI, stats from 20 days of uptime with this patch live in a stack with
>>>> XFS above it and md/RAID-6 below (20 days being the time since the last
>>>> reboot: I've been running this patch for years with older kernels
>>>> without incident):
>>>>
>>>> stats_total/bypassed: 282.2G
>>>> stats_total/cache_bypass_hits: 123808
>>>> stats_total/cache_bypass_misses: 400813
>>>> stats_total/cache_hit_ratio: 53
>>>> stats_total/cache_hits: 9284282
>>>> stats_total/cache_miss_collisions: 51582
>>>> stats_total/cache_misses: 8183822
>>>> stats_total/cache_readaheads: 0
>>>> written: 168.6G
>>>>
>>>> ... so it's still saving a lot of seeking. This is despite having
>>>> backups running every three hours (in idle mode), and the usual updatedb
>>>> runs, etc, plus, well, actual work which sometimes involves huge greps
>>>> etc: I also tend to do big cp -al's of transient stuff like build dirs
>>>> in idle mode to suppress caching, because the build dir will be deleted
>>>> long before it expires from the page cache.
>>>>
>>>> The SSD, which is an Intel DC S3510 and is thus read-biased rather than
>>>> write-biased (not ideal for this use-case: whoops, I misread the
>>>> datasheet), says
>>>>
>>>> EnduranceAnalyzer : 506.90 years
>>>>
>>>> despite also housing all the XFS journals. I am... not worried about the
>>>> SSD wearing out. It'll outlast everything else at this rate. It'll
>>>> probably outlast the machine's case and the floor the machine sits on.
>>>> It'll certainly outlast me (or at least last long enough to be discarded
>>>> by reason of being totally obsolete). Given that I really really don't
>>>> want to ever have to replace it (and no doubt screw up replacing it and
>>>> wreck the machine), this is excellent.
>>>>
>>>> (When I had to run without the ioprio patch, the expected SSD lifetime
>>>> and cache hit rate both plunged. It was still years, but enough years
>>>> that it could potentially have worn out before the rest of the machine
>>>> did. Using ioprio for this might be a bit of an abuse of ioprio, and
>>>> really some other mechanism might be better, but in the absence of such
>>>> a mechanism, ioprio *is*, at least for me, fairly tightly correlated
>>>> with whether I'm going to want to wait for I/O from the same block in
>>>> future.)
>>>
>> From Nix on 10/03 at 5:39 AM PST
>>> I suppose. I'm not sure we don't want to skip even that for truly
>>> idle-time I/Os, though: booting is one thing, but do you want all the
>>> metadata associated with random deep directory trees you access once a
>>> year to be stored in your SSD's limited space, pushing out data you
>>> might actually use, because the idle-time backup traversed those trees?
>>> I know I don't. The whole point of idle-time I/O is that you don't care
>>> how fast it returns. If backing it up is speeding things up, I'd be
>>> interested in knowing why... what this is really saying is that metadata
>>> should be considered important even if the user says it isn't!
>>>
>>> (I guess this is helping because of metadata that is read by idle I/Os
>>> first, but then non-idle ones later, in which case for anyone who runs
>>> backups this is just priming the cache with all metadata on the disk.
>>> Why not just run a non-idle-time cronjob to do that in the middle of the
>>> night if it's beneficial?)
>>
>> (It did not look like this was being CC'd to the list so I have pasted the 
>> relevant bits of conversation. Kai, please resend your patch set and CC 
>> the list linux-bcache@vger.kernel.org)
>>
>> I am glad that people are still making effective use of this patch!
>>
>> It works great unless you are using mq-scsi (or perhaps mq-dm). For the 
>> multi-queue systems out there, ioprio does not seem to pass down through 
>> the stack into bcache, probably because it is passed through a worker 
>> thread for the submission or some other detail that I have not researched. 
>>
>> Long ago others had concerns using ioprio as the mechanism for cache 
>> hinting, so what does everyone think about implementing cgroup inside of 
>> bcache? From what I can tell, cgroups have a stronger binding to an IO 
>> than ioprio hints. 
>>
>> I think there are several per-cgroup tunables that could be useful. Here 
>> are the ones that I can think of, please chime in if anyone can think of 
>> others: 
>>  - should_bypass_write
>>  - should_bypass_read
>>  - should_bypass_meta
>>  - should_bypass_read_ahead
>>  - should_writeback
>>  - should_writeback_meta
>>  - should_cache_read
>>  - sequential_cutoff
>>
>> Indeed, some of these could be combined into a single multi-valued cgroup 
>> option such as:
>>  - should_bypass = read,write,meta
> 
> 
> Hi Coly,
> 
> Do you have any comments on the best cgroup implementation for bcache?
> 
> What other per-process cgroup parameters might be useful for tuning 
> bcache behavior to various workloads?

Hi Eric,

This is much better than the magic numbers to control io prio.

I am not familiar with cgroup configuration and implementation, I just
wondering because most of I/Os in bcache are done by kworker or kthread,
is it possible to do per-process control.

Anyway, we may start from the bypass stuffs in your example. If you may
help to compose patches and maintain them in long term, I am glad to
take them in.

Thanks.

Coly Li

Thanks.

Coly Li
