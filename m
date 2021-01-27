Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE36305FA1
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Jan 2021 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343879AbhA0Pan (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Jan 2021 10:30:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:35370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235800AbhA0P2c (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Jan 2021 10:28:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BEA3FB72C;
        Wed, 27 Jan 2021 15:27:50 +0000 (UTC)
Subject: Re: Fix degraded system performance due to workqueue overload
To:     Kai Krakow <kai@kaishome.de>
References: <20210127132350.557935-1-kai@kaishome.de>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <3f252d42-e057-54b7-d54e-cced88659ff7@suse.de>
Date:   Wed, 27 Jan 2021 23:27:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127132350.557935-1-kai@kaishome.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/27/21 9:23 PM, Kai Krakow wrote:
> In the past months (and looking back, even years), I was seeing system
> performance and latency degrading vastly when bcache is active.
> 
> Finally, with kernel 5.10, I was able to locate the problem:
> 
> [250336.887598] BUG: workqueue lockup - pool cpus=2 node=0 flags=0x0 nice=0 stuck for 72s!
> [250336.887606] Showing busy workqueues and worker pools:
> [250336.887607] workqueue events: flags=0x0
> [250336.887608]   pwq 10: cpus=5 node=0 flags=0x0 nice=0 active=3/256 refcnt=4
> [250336.887611]     pending: psi_avgs_work, psi_avgs_work, psi_avgs_work
> [250336.887619]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=15/256 refcnt=16
> [250336.887621]     in-flight: 3760137:psi_avgs_work
> [250336.887624]     pending: psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work
> [250336.887637]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
> [250336.887639]     pending: psi_avgs_work
> [250336.887643] workqueue events_power_efficient: flags=0x80
> [250336.887644]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
> [250336.887646]     pending: do_cache_clean
> [250336.887651] workqueue mm_percpu_wq: flags=0x8
> [250336.887651]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=2/256 refcnt=4
> [250336.887653]     pending: lru_add_drain_per_cpu BAR(60), vmstat_update
> [250336.887666] workqueue bcache: flags=0x8
> [250336.887667]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
> [250336.887668]     pending: cached_dev_nodata
> [250336.887681] pool 4: cpus=2 node=0 flags=0x0 nice=0 hung=72s workers=2 idle: 3760136
> 
> I was able to track that back to the following commit:
> 56b30770b27d54d68ad51eccc6d888282b568cee ("bcache: Kill btree_io_wq")
> 
> Reverting that commit (with some adjustments due to later code changes)
> improved my desktop latency a lot, I mean really a lot. The system was
> finally able to handle somewhat higher loads without stalling for
> several seconds and without spiking load into the hundreds while doing a
> lot of write IO.
> 
> So I dug a little deeper and found that the assumption of this old
> commit may no longer be true and bcache simply overwhelms the system_wq
> with too many or too long running workers. This should really only be
> used for workers that can do their work almost instantly, and it should
> not be spammed with a lot of workers which bcache seems to do (look at
> how many kthreads it creates from workers):
> 
> # ps aux | grep 'kworker/.*bc' | wc -l
> 131
> 
> And this is with a mostly idle system, it may easily reach 700+. Also,
> with my patches in place, that number seems to be overall lower.
> 
> So I added another commit (patch 2) to move another worker queue over
> to a dedicated worker queue ("bcache: Move journal work to new
> background wq").
> 
> I tested this by overloading my desktop system with the following
> parallel load:
> 
>   * A big download at 1 Gbit/s, resulting in 60+ MB/s write
>   * Active IPFS daemon
>   * Watching a YouTube video
>   * Fully syncing 4 IMAP accounts with MailSpring
>   * Running a Gentoo system update (compiling packages)
>   * Browsing the web
>   * Running a Windows VM (Qemu) with Outlook and defragmentation
>   * Starting and closing several applications and clicking in them
> 
> IO setup: 4x HDD (2+2+4+4 TB) btrfs RAID-0 with 850 GB SSD bcache
> Kernel 5.10.10
> 
> Without the patches, the system would have come to a stop, probably not
> recovering from it (last time I tried, a clean shutdown took 1+ hour).
> With the patches, the system easily survives and feels overall smooth
> with only a small perceivable lag.
> 
> Boot times are more consistent, too, and faster when bcache is mostly
> cold due to a previous system update.
> 
> Write rates of the system are more smooth now, and can easily sustain a
> constant load of 200-300 MB/s while previously I would see long stalls
> followed by vastly reduces write performance (down to 5-20 MB/s).
> 
> I'm not sure if there are side-effects of my patches that I cannot know
> of but it works great for me: All write-related desktop stalling is
> gone.
> 


Hi Kai,

Overall I am OK with this series, it makes sense IMHO. Let's wait for
response from Kent, if there is no comment from him, I will add these
two patches in my v5.12 for-next series.

Thanks for the fix up.

Coly Li
