Return-Path: <linux-bcache+bounces-1089-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76185AC3660
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 21:24:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67E4D7A8526
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 19:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B172778F5D;
	Sun, 25 May 2025 19:24:11 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916E33FE7;
	Sun, 25 May 2025 19:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748201051; cv=none; b=QNPahNLv2mNVTSPxpA1+Igm4qlwqLxSRlL0XcBtWM6JPyoWGpHgJrgk/ww5hFZKdqnbQcK3lxhp6PcUopO1jtjrUhjwAMnjPEAzvrveul/8Mr+gnPYiNtZ976LK3FCKQf/6ZI4vxI/BEoEXoC15LMuT7H4zI0J5CYIT949OeATs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748201051; c=relaxed/simple;
	bh=uO2WHAn2a2Pn5PVFMaAo43EEmj8uaQ+n0S+Z7LEZ/Xw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZQPiTkjmTcjAoJtVudDHoLYxPw+S1+Glu3cvG5ZYsj0hG4Ohbqqx5ayjJ+Spb4fCeojBIxr1dQf+EVFmzTpeQdWuIc0q2MkgKt9FTzfATS8Gdg63FD6QCa5kaym6aOUEt6lx5NPYy9AbfWZxfG3z7yDNpZmaDD1AU1Joox3R0jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E76C4CEEA;
	Sun, 25 May 2025 19:24:09 +0000 (UTC)
Date: Sun, 25 May 2025 15:25:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: David Laight <david.laight.linux@gmail.com>, Arnd Bergmann
 <arnd@arndb.de>, Naresh Kamboju <naresh.kamboju@linaro.org>,
 linux-bcache@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
 lkft-triage@lists.linaro.org, Linux Regressions
 <regressions@lists.linux.dev>, Dan Carpenter <dan.carpenter@linaro.org>,
 Anders Roxell <anders.roxell@linaro.org>
Subject: Re: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is
 larger than 2048 bytes [-Werror=frame-larger-than=]
Message-ID: <20250525152502.224f8a99@gandalf.local.home>
In-Reply-To: <zbifzd2fa3epywbhfznfr24mmacsndkwlengq3cqcgply5it5v@33zajtzvjetj>
References: <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
	<6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
	<CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
	<6247de76-d1f5-4357-83bd-4dd9268f44aa@app.fastmail.com>
	<7tsvzu2mubrpclr75yezqj7ncuzebpsgqskbehhjy6gll73rez@5cj7griclubx>
	<566aefc9-7cad-4eb8-8eb0-8640d745efa2@app.fastmail.com>
	<hplrd5gufo2feylgs4ieufticwemeteaaoilo2jllgauclua2c@o4erpizekm5y>
	<692e313d-ea31-45c0-8c66-36b25c9d955d@app.fastmail.com>
	<20250525181842.2e2c47fd@pumpkin>
	<zbifzd2fa3epywbhfznfr24mmacsndkwlengq3cqcgply5it5v@33zajtzvjetj>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 25 May 2025 13:36:16 -0400
Kent Overstreet <kent.overstreet@linux.dev> wrote:

> We already have "trace max stack", but that only checks at process exit,
> so it doesn't tell you much.

Nope, it traces the stack at every function call, but it misses the leaf
functions and also doesn't check interrupts as they may use a different
stack.

> 
> We could do better with tracing - just inject a trampoline that checks
> the current stack usage against the maximum stack usage we've seen, and
> emits a trace event with a stack trace if it's greater.
> 
> (and now Steve's going to tell us he's already done this :)

Close ;-)

# echo 1 > /proc/sys/kernel/stack_tracer_enabled

Wait.

# cat /sys/kernel/tracing/stack_trace
        Depth    Size   Location    (33 entries)
        -----    ----   --------
  0)     8360      48   __msecs_to_jiffies+0x9/0x30
  1)     8312     104   update_group_capacity+0x95/0x970
  2)     8208     520   update_sd_lb_stats.constprop.0+0x278/0x2f40
  3)     7688     416   sched_balance_find_src_group+0x96/0xe30
  4)     7272     512   sched_balance_rq+0x53f/0x2fe0
  5)     6760     344   sched_balance_newidle+0x6c1/0x1310
  6)     6416      80   pick_next_task_fair+0x55/0xe60
  7)     6336     328   __schedule+0x8a5/0x33d0
  8)     6008      32   schedule+0xe2/0x3b0
  9)     5976      32   io_schedule+0x8f/0xf0
 10)     5944     264   rq_qos_wait+0x12a/0x200
 11)     5680     144   wbt_wait+0x159/0x260
 12)     5536      40   __rq_qos_throttle+0x50/0x90
 13)     5496     320   blk_mq_submit_bio+0x70b/0x1ff0
 14)     5176     240   __submit_bio+0x1b3/0x600
 15)     4936     248   submit_bio_noacct_nocheck+0x546/0xca0
 16)     4688     144   ext4_bio_write_folio+0x69d/0x1870
 17)     4544      64   mpage_submit_folio+0x14c/0x2b0
 18)     4480      96   mpage_process_page_bufs+0x392/0x7a0
 19)     4384     632   mpage_prepare_extent_to_map+0xa5b/0x1080
 20)     3752     496   ext4_do_writepages+0x8af/0x2ee0
 21)     3256     304   ext4_writepages+0x26f/0x5c0
 22)     2952     344   do_writepages+0x183/0x7c0
 23)     2608     152   __writeback_single_inode+0x114/0xb00
 24)     2456     744   writeback_sb_inodes+0x52b/0xdf0
 25)     1712     168   __writeback_inodes_wb+0xf4/0x270
 26)     1544     312   wb_writeback+0x547/0x800
 27)     1232     328   wb_workfn+0x7b1/0xbc0
 28)      904     352   process_one_work+0x85a/0x1450
 29)      552     176   worker_thread+0x5b7/0xf80
 30)      376     168   kthread+0x371/0x720
 31)      208      32   ret_from_fork+0x34/0x70
 32)      176     176   ret_from_fork_asm+0x1a/0x30


The code that does this is in kernel/trace/trace_stack.c

It simply attaches to the function tracer and at ever function checks the
current stack size.

Hmm, I need to update this because today we even pass the stack pointer via
the ftrace_regs if the arch supports it. Using that would allow me to get
rid of the hack:


static void check_stack(unsigned long ip, unsigned long *stack)
{
	[..]
	this_size = ((unsigned long)stack) & (THREAD_SIZE-1);
	this_size = THREAD_SIZE - this_size;


	unsigned long stack;

[..]

static void
stack_trace_call(unsigned long ip, unsigned long parent_ip,
		 struct ftrace_ops *op, struct ftrace_regs *fregs)
{
	unsigned long stack;
	[..]

	check_stack(ip, &stack);


-- Steve

