Return-Path: <linux-bcache+bounces-1090-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95DACAC36B4
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 22:05:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18ADC1892C5D
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 20:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE3119CC3D;
	Sun, 25 May 2025 20:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OKkev1Dt"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D962B2CF
	for <linux-bcache@vger.kernel.org>; Sun, 25 May 2025 20:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748203507; cv=none; b=obCCK/8gKsRNc6dBhIkJYuNgqkzZ6KCQha7heEYo18jzJspd5dRW7Y8I1EXsHwgvpcuIWHZbQclZEQgDCzBXbW1fv6fbpcf641/kMa8/aMO6lz0/Y4JmaGEGCTCSSpaZu/W9dm075/JpIQvWNZ0MQZz1jsIbHqYtpZQ4DJ92feU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748203507; c=relaxed/simple;
	bh=h/adAkyvTMHCRUtOmvPIGpulvOnDhZqX8BHvZD9McVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2y97Mor+4hykKZIqU0uCYTzKaXQIxiMi8jPW7XLWAak3cg08g6SBFz6w2kaWwFSCGdl+2XkXAiIYLmTN+x+SDumllDsiZnp8qYfd/SoOhjg3aXRJHSPnNDZnLMW8pkUU9yaCnp/gCApIMM5wJ4RJyaPrTvnjJfxyKee7Cwh8o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OKkev1Dt; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 25 May 2025 16:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748203492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2CB8jA/xXUsWi8lcPOVKNwDBtUDTUgtyorEjglqv6bE=;
	b=OKkev1DtwD1+97EA3Jsx9OzAi1+lKPDEtpLVQglAoQOcMffXIdTW91FSgBSZJi+AyhQHfI
	MnOFB5AM9kUIWVzoDBHtz9jD850mp6f/VSPqtwKyfRDe+C8YEBnuXL8zpxMO94t4pRun+/
	SaA8IzdxGUDWikHUkL6syyHPwf8/AGI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Laight <david.laight.linux@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Naresh Kamboju <naresh.kamboju@linaro.org>, 
	linux-bcache@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Subject: Re: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is
 larger than 2048 bytes [-Werror=frame-larger-than=]
Message-ID: <bsvrygs6lzmwarionkbrxzeorkmf62pig2h7hobqlmtlftzrpt@kg4cs5h7qq5s>
References: <6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
 <CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
 <6247de76-d1f5-4357-83bd-4dd9268f44aa@app.fastmail.com>
 <7tsvzu2mubrpclr75yezqj7ncuzebpsgqskbehhjy6gll73rez@5cj7griclubx>
 <566aefc9-7cad-4eb8-8eb0-8640d745efa2@app.fastmail.com>
 <hplrd5gufo2feylgs4ieufticwemeteaaoilo2jllgauclua2c@o4erpizekm5y>
 <692e313d-ea31-45c0-8c66-36b25c9d955d@app.fastmail.com>
 <20250525181842.2e2c47fd@pumpkin>
 <zbifzd2fa3epywbhfznfr24mmacsndkwlengq3cqcgply5it5v@33zajtzvjetj>
 <20250525152502.224f8a99@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250525152502.224f8a99@gandalf.local.home>
X-Migadu-Flow: FLOW_OUT

On Sun, May 25, 2025 at 03:25:02PM -0400, Steven Rostedt wrote:
> On Sun, 25 May 2025 13:36:16 -0400
> Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > We already have "trace max stack", but that only checks at process exit,
> > so it doesn't tell you much.
> 
> Nope, it traces the stack at every function call, but it misses the leaf
> functions and also doesn't check interrupts as they may use a different
> stack.

I was thinking of DEBUG_STACK_USAGE :)

> > We could do better with tracing - just inject a trampoline that checks
> > the current stack usage against the maximum stack usage we've seen, and
> > emits a trace event with a stack trace if it's greater.
> > 
> > (and now Steve's going to tell us he's already done this :)
> 
> Close ;-)
> 
> # echo 1 > /proc/sys/kernel/stack_tracer_enabled
> 
> Wait.
> 
> # cat /sys/kernel/tracing/stack_trace
>         Depth    Size   Location    (33 entries)
>         -----    ----   --------
>   0)     8360      48   __msecs_to_jiffies+0x9/0x30
>   1)     8312     104   update_group_capacity+0x95/0x970
>   2)     8208     520   update_sd_lb_stats.constprop.0+0x278/0x2f40
>   3)     7688     416   sched_balance_find_src_group+0x96/0xe30
>   4)     7272     512   sched_balance_rq+0x53f/0x2fe0
>   5)     6760     344   sched_balance_newidle+0x6c1/0x1310
>   6)     6416      80   pick_next_task_fair+0x55/0xe60
>   7)     6336     328   __schedule+0x8a5/0x33d0
>   8)     6008      32   schedule+0xe2/0x3b0
>   9)     5976      32   io_schedule+0x8f/0xf0
>  10)     5944     264   rq_qos_wait+0x12a/0x200
>  11)     5680     144   wbt_wait+0x159/0x260
>  12)     5536      40   __rq_qos_throttle+0x50/0x90
>  13)     5496     320   blk_mq_submit_bio+0x70b/0x1ff0
>  14)     5176     240   __submit_bio+0x1b3/0x600
>  15)     4936     248   submit_bio_noacct_nocheck+0x546/0xca0
>  16)     4688     144   ext4_bio_write_folio+0x69d/0x1870
>  17)     4544      64   mpage_submit_folio+0x14c/0x2b0
>  18)     4480      96   mpage_process_page_bufs+0x392/0x7a0
>  19)     4384     632   mpage_prepare_extent_to_map+0xa5b/0x1080
>  20)     3752     496   ext4_do_writepages+0x8af/0x2ee0
>  21)     3256     304   ext4_writepages+0x26f/0x5c0
>  22)     2952     344   do_writepages+0x183/0x7c0
>  23)     2608     152   __writeback_single_inode+0x114/0xb00
>  24)     2456     744   writeback_sb_inodes+0x52b/0xdf0
>  25)     1712     168   __writeback_inodes_wb+0xf4/0x270
>  26)     1544     312   wb_writeback+0x547/0x800
>  27)     1232     328   wb_workfn+0x7b1/0xbc0
>  28)      904     352   process_one_work+0x85a/0x1450
>  29)      552     176   worker_thread+0x5b7/0xf80
>  30)      376     168   kthread+0x371/0x720
>  31)      208      32   ret_from_fork+0x34/0x70
>  32)      176     176   ret_from_fork_asm+0x1a/0x30

Nice! This is exactly what I was looking for :)

        Depth    Size   Location    (48 entries)
        -----    ----   --------
  0)     7728      48   __update_load_avg_se+0x9/0x440
  1)     7680      80   update_load_avg+0x25f/0x2b0
  2)     7600      56   set_next_task_fair+0x232/0x290
  3)     7544      48   pick_next_task_fair+0xcf/0x1a0
  4)     7496     120   __schedule+0x284/0xe80
  5)     7376      16   preempt_schedule_irq+0x33/0x50
  6)     7360     136   asm_common_interrupt+0x26/0x40
  7)     7224      48   get_symbol_offset+0x43/0x70
  8)     7176      56   kallsyms_lookup_buildid+0x55/0xf0
  9)     7120      88   __sprint_symbol.isra.0+0x48/0xf0
 10)     7032     720   symbol_string+0xf1/0x120
 11)     6312     120   vsnprintf+0x3dc/0x5d0
 12)     6192     128   bch2_prt_printf+0x57/0x140
 13)     6064      64   bch2_prt_task_backtrace+0x71/0xc0
 14)     6000      40   print_cycle+0x71/0xa0
 15)     5960     104   trace_would_deadlock+0xb6/0x150
 16)     5856     128   break_cycle+0xfe/0x260
 17)     5728     368   bch2_check_for_deadlock+0x35f/0x5f0
 18)     5360      96   six_lock_slowpath.isra.0+0x204/0x4c0
 19)     5264      96   __bch2_btree_node_get+0x384/0x5b0
 20)     5168     336   bch2_btree_path_traverse_one+0x7a5/0xd60
 21)     4832     232   bch2_btree_iter_peek_slot+0x104/0x7f0
 22)     4600     216   btree_key_cache_fill+0xcf/0x1a0
 23)     4384      72   bch2_btree_path_traverse_cached+0x2bd/0x310
 24)     4312     336   bch2_btree_path_traverse_one+0x705/0xd60
 25)     3976     232   bch2_btree_iter_peek_slot+0x104/0x7f0
 26)     3744     424   bch2_check_discard_freespace_key+0x172/0x5e0
 27)     3320     224   bch2_bucket_alloc_freelist+0x422/0x610
 28)     3096      88   bch2_bucket_alloc_trans+0x1f3/0x3a0
 29)     3008     168   bch2_bucket_alloc_set_trans+0xf1/0x360
 30)     2840     184   __open_bucket_add_buckets+0x40b/0x660
 31)     2656      40   open_bucket_add_buckets+0x72/0xf0
 32)     2616     280   bch2_alloc_sectors_start_trans+0x76d/0xd00
 33)     2336     424   __bch2_write+0x1d1/0x11d0
 34)     1912     168   __bch2_writepage+0x3b2/0x790
 35)     1744      72   write_cache_pages+0x5c/0xa0
 36)     1672     176   bch2_writepages+0x67/0xc0
 37)     1496     184   do_writepages+0xcc/0x240
 38)     1312      64   __writeback_single_inode+0x41/0x320
 39)     1248     456   writeback_sb_inodes+0x216/0x4e0
 40)      792      64   __writeback_inodes_wb+0x4c/0xe0
 41)      728     168   wb_writeback+0x19c/0x310
 42)      560     136   wb_workfn+0x2a4/0x400
 43)      424      64   process_one_work+0x18c/0x330
 44)      360      72   worker_thread+0x252/0x3a0
 45)      288      80   kthread+0xf9/0x210
 46)      208      32   ret_from_fork+0x31/0x50
 47)      176     176   ret_from_fork_asm+0x11/0x20

