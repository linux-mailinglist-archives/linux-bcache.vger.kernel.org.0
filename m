Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD630287CC6
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Oct 2020 22:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgJHUDg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 8 Oct 2020 16:03:36 -0400
Received: from mx.ewheeler.net ([173.205.220.69]:56899 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729822AbgJHUDg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Oct 2020 16:03:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.ewheeler.net (Postfix) with ESMTP id 4E3C4A0633;
        Thu,  8 Oct 2020 20:03:36 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mail.ewheeler.net ([127.0.0.1])
        by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id fILmHGiYJO7I; Thu,  8 Oct 2020 20:03:30 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.ewheeler.net (Postfix) with ESMTPSA id B4435A0612;
        Thu,  8 Oct 2020 20:03:30 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ewheeler.net B4435A0612
Date:   Thu, 8 Oct 2020 20:03:30 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@pop.dreamhost.com
To:     linux-bcache@vger.kernel.org
cc:     Kai Krakow <kai@kaishome.de>, Nix <nix@esperi.org.uk>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: bcache cgroups for per-process tuning
Message-ID: <alpine.LRH.2.11.2010081953490.27518@pop.dreamhost.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, 8 Oct 2020, Coly Li wrote:

> On 2020/10/8 04:35, Eric Wheeler wrote:
> > [+cc coly]
> > 
> > On Mon, 5 Oct 2020, Eric Wheeler wrote:
> >> On Sun, 4 Oct 2020, Kai Krakow wrote:
> >>
> >>> Hey Nix!
> >>>
> >>> Apparently, `git send-email` probably swallowed the patch 0/3 message for you.
> >>>
> >>> It was about adding one additional patch which reduced boot time for
> >>> me with idle mode active by a factor of 2.
> >>>
> >>> You can look at it here:
> >>> https://github.com/kakra/linux/pull/4
> >>>
> >>> It's "bcache: Only skip data request in io_prio bypass mode" just if
> >>> you're curious.
> >>>
> >>> Regards,
> >>> Kai
> >>>
> >>> Am So., 4. Okt. 2020 um 15:19 Uhr schrieb Nix <nix@esperi.org.uk>:
> >>>>
> >>>> On 3 Oct 2020, Kai Krakow spake thusly:
> >>>>
> >>>>> Having idle IOs bypass the cache can increase performance elsewhere
> >>>>> since you probably don't care about their performance.  In addition,
> >>>>> this prevents idle IOs from promoting into (polluting) your cache and
> >>>>> evicting blocks that are more important elsewhere.
> >>>>
> >>>> FYI, stats from 20 days of uptime with this patch live in a stack with
> >>>> XFS above it and md/RAID-6 below (20 days being the time since the last
> >>>> reboot: I've been running this patch for years with older kernels
> >>>> without incident):
> >>>>
> >>>> stats_total/bypassed: 282.2G
> >>>> stats_total/cache_bypass_hits: 123808
> >>>> stats_total/cache_bypass_misses: 400813
> >>>> stats_total/cache_hit_ratio: 53
> >>>> stats_total/cache_hits: 9284282
> >>>> stats_total/cache_miss_collisions: 51582
> >>>> stats_total/cache_misses: 8183822
> >>>> stats_total/cache_readaheads: 0
> >>>> written: 168.6G
> >>>>
> >>>> ... so it's still saving a lot of seeking. This is despite having
> >>>> backups running every three hours (in idle mode), and the usual updatedb
> >>>> runs, etc, plus, well, actual work which sometimes involves huge greps
> >>>> etc: I also tend to do big cp -al's of transient stuff like build dirs
> >>>> in idle mode to suppress caching, because the build dir will be deleted
> >>>> long before it expires from the page cache.
> >>>>
> >>>> The SSD, which is an Intel DC S3510 and is thus read-biased rather than
> >>>> write-biased (not ideal for this use-case: whoops, I misread the
> >>>> datasheet), says
> >>>>
> >>>> EnduranceAnalyzer : 506.90 years
> >>>>
> >>>> despite also housing all the XFS journals. I am... not worried about the
> >>>> SSD wearing out. It'll outlast everything else at this rate. It'll
> >>>> probably outlast the machine's case and the floor the machine sits on.
> >>>> It'll certainly outlast me (or at least last long enough to be discarded
> >>>> by reason of being totally obsolete). Given that I really really don't
> >>>> want to ever have to replace it (and no doubt screw up replacing it and
> >>>> wreck the machine), this is excellent.
> >>>>
> >>>> (When I had to run without the ioprio patch, the expected SSD lifetime
> >>>> and cache hit rate both plunged. It was still years, but enough years
> >>>> that it could potentially have worn out before the rest of the machine
> >>>> did. Using ioprio for this might be a bit of an abuse of ioprio, and
> >>>> really some other mechanism might be better, but in the absence of such
> >>>> a mechanism, ioprio *is*, at least for me, fairly tightly correlated
> >>>> with whether I'm going to want to wait for I/O from the same block in
> >>>> future.)
> >>>
> >> From Nix on 10/03 at 5:39 AM PST
> >>> I suppose. I'm not sure we don't want to skip even that for truly
> >>> idle-time I/Os, though: booting is one thing, but do you want all the
> >>> metadata associated with random deep directory trees you access once a
> >>> year to be stored in your SSD's limited space, pushing out data you
> >>> might actually use, because the idle-time backup traversed those trees?
> >>> I know I don't. The whole point of idle-time I/O is that you don't care
> >>> how fast it returns. If backing it up is speeding things up, I'd be
> >>> interested in knowing why... what this is really saying is that metadata
> >>> should be considered important even if the user says it isn't!
> >>>
> >>> (I guess this is helping because of metadata that is read by idle I/Os
> >>> first, but then non-idle ones later, in which case for anyone who runs
> >>> backups this is just priming the cache with all metadata on the disk.
> >>> Why not just run a non-idle-time cronjob to do that in the middle of the
> >>> night if it's beneficial?)
> >>
> >> (It did not look like this was being CC'd to the list so I have pasted the 
> >> relevant bits of conversation. Kai, please resend your patch set and CC 
> >> the list linux-bcache@vger.kernel.org)
> >>
> >> I am glad that people are still making effective use of this patch!
> >>
> >> It works great unless you are using mq-scsi (or perhaps mq-dm). For the 
> >> multi-queue systems out there, ioprio does not seem to pass down through 
> >> the stack into bcache, probably because it is passed through a worker 
> >> thread for the submission or some other detail that I have not researched. 
> >>
> >> Long ago others had concerns using ioprio as the mechanism for cache 
> >> hinting, so what does everyone think about implementing cgroup inside of 
> >> bcache? From what I can tell, cgroups have a stronger binding to an IO 
> >> than ioprio hints. 
> >>
> >> I think there are several per-cgroup tunables that could be useful. Here 
> >> are the ones that I can think of, please chime in if anyone can think of 
> >> others: 
> >>  - should_bypass_write
> >>  - should_bypass_read
> >>  - should_bypass_meta
> >>  - should_bypass_read_ahead
> >>  - should_writeback
> >>  - should_writeback_meta
> >>  - should_cache_read
> >>  - sequential_cutoff
> >>
> >> Indeed, some of these could be combined into a single multi-valued cgroup 
> >> option such as:
> >>  - should_bypass = read,write,meta
> > 
> > 
> > Hi Coly,
> > 
> > Do you have any comments on the best cgroup implementation for bcache?
> > 
> > What other per-process cgroup parameters might be useful for tuning 
> > bcache behavior to various workloads?
> 
> Hi Eric,
> 
> This is much better than the magic numbers to control io prio.
> 
> I am not familiar with cgroup configuration and implementation, I just
> wondering because most of I/Os in bcache are done by kworker or kthread,
> is it possible to do per-process control.

It should, bio's get associated with processes tied to a cgroup IIRC.  
Maybe someone can fill in the details here.

> Anyway, we may start from the bypass stuffs in your example. If you may
> help to compose patches and maintain them in long term, I am glad to
> take them in.

That sounds like a plan.

Nix, Kai, anyone:

Are you up for writing a first draft?

-Eric
