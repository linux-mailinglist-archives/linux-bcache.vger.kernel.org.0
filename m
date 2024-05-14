Return-Path: <linux-bcache+bounces-459-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E248C5E1F
	for <lists+linux-bcache@lfdr.de>; Wed, 15 May 2024 01:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02FE8B21433
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 23:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C335D182C98;
	Tue, 14 May 2024 23:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Uql4f86z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9veoz4FI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Uql4f86z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9veoz4FI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7CA13D619
	for <linux-bcache@vger.kernel.org>; Tue, 14 May 2024 23:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715729956; cv=none; b=VaI6EEkPsht/m5LSBBsOjTLkRmvhZMjMO1d8xDhQka/KMh3go1/UBqpPRcqJ9ugEjr9WsPB0aC4DEIwYeBgKfKp3gWJOiLuBrnm4yoIyHjT9VKgYwPRztajCR0DklMoaU6w9q48UvBBlNGf4qFEdbjdJlCAbUub3UwQwKU5D1nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715729956; c=relaxed/simple;
	bh=HXu5mkePMtyKDTkaeH0MXghmkFOwMxR+fPgWt1OW7d8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmeUhXxflotKOq8P782S/QgDbQXlkv2BeI8eqBHyiAv/1ZQVeAE/9Vvz8tLyWU1j2XnqZ8iYxLPR2/vSTMDmGajM0Kkb6BdLv4hEUc9wi8M7HzYb7OfA64H0FVfncM4wXB0OXxhDRXjprscoSVJSRKGbYTb1lLeVNnuc8qashFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Uql4f86z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9veoz4FI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Uql4f86z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9veoz4FI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5806922C69;
	Tue, 14 May 2024 23:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715729952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9aYX1C/lW06o/IpG880hEZ3DwQOBpF6+/qK000XWvZs=;
	b=Uql4f86zdl3yVsVvlLxr9+lpdfys8ftmexeiAOMlp3K+N0WhEJgGgcsyx3ZJll+S/xsW6Q
	EOlJhjzhBSFPYhCvHLcyBz0jfpCjHrAxDhQ5HpoZkoaNZDJ1wwXX7OuiJhCrHdsgiAVyoR
	y8so1Rk+tyQ51YVQGvyn/Syp257OF68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715729952;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9aYX1C/lW06o/IpG880hEZ3DwQOBpF6+/qK000XWvZs=;
	b=9veoz4FIHszeEBnT85YwonOLwd5HSBd/D1Zz4wCpgl3NOFAPXWC3Wv4TQdHzruvjOsz3lb
	y0m6ywnLOuuj7tBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Uql4f86z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9veoz4FI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715729952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9aYX1C/lW06o/IpG880hEZ3DwQOBpF6+/qK000XWvZs=;
	b=Uql4f86zdl3yVsVvlLxr9+lpdfys8ftmexeiAOMlp3K+N0WhEJgGgcsyx3ZJll+S/xsW6Q
	EOlJhjzhBSFPYhCvHLcyBz0jfpCjHrAxDhQ5HpoZkoaNZDJ1wwXX7OuiJhCrHdsgiAVyoR
	y8so1Rk+tyQ51YVQGvyn/Syp257OF68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715729952;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9aYX1C/lW06o/IpG880hEZ3DwQOBpF6+/qK000XWvZs=;
	b=9veoz4FIHszeEBnT85YwonOLwd5HSBd/D1Zz4wCpgl3NOFAPXWC3Wv4TQdHzruvjOsz3lb
	y0m6ywnLOuuj7tBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 77781137C3;
	Tue, 14 May 2024 23:39:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RM/gCh72Q2ZjTAAAD6G6ig
	(envelope-from <colyli@suse.de>); Tue, 14 May 2024 23:39:10 +0000
Date: Wed, 15 May 2024 07:39:07 +0800
From: Coly Li <colyli@suse.de>
To: Robert Pang <robertpang@google.com>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>, 
	=?utf-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>, Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
Message-ID: <xbm4drbn7hdxedptocnc77m53kce3jdaedsvxh7dcwts7yivjx@jbvhh43wd3tp>
References: <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
 <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de>
 <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
 <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de>
 <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
 <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com>
 <1B20E890-F136-496B-AF1F-C09DB0B45BE8@suse.de>
 <CAJhEC06FQPw3p7PHJpjN13CVjibbBVv-ZhwBb_6ducJP+XJ3gg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJhEC06FQPw3p7PHJpjN13CVjibbBVv-ZhwBb_6ducJP+XJ3gg@mail.gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -6.01
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5806922C69
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim]

On Mon, May 13, 2024 at 10:15:00PM -0700, Robert Pang wrote:
> Dear Coly,
>

Hi Robert,

Thanks for the email. Let me explain inline.
 
> Thank you for your dedication in reviewing this patch. I understand my
> previous message may have come across as urgent, but I want to
> emphasize the significance of this bcache operational issue as it has
> been reported by multiple users.
> 

What I concerned was still the testing itself. First of all, from the
following information, I see quite a lot of testings are done. I do
appreciate for the effort, which makes me confident for the quality of
this patch.

> We understand the importance of thoroughness, To that end, we have
> conducted extensive, repeated testing on this patch across a range of
> cache sizes (375G/750G/1.5T/3T/6T/9TB) and CPU cores
> (2/4/8/16/32/48/64/80/96/128) for an hour-long run. We tested various
> workloads (read-only, read-write, and write-only) with 8kB I/O size.
> In addition, we did a series of 16-hour runs with 750GB cache and 16
> CPU cores. Our tests, primarily in writethrough mode, haven't revealed
> any issues or deadlocks.
>

An hour-long run is not enough for bcache. Normally for stability prupose
at least 12-36 hours continue I/O pressure is necessary. Before Linux
v5.3 bcache will run into out-of-memory after 10 ~ 12 hours heavy randome
write workload on the server hardware Lenovo sponsored me.

This patch tends to offer high priority to allocator than gc thread, I'd
like to see what will happen if most of the cache space are allocated.

In my testing, still on the Lenovo SR650. The cache device is 512G Intel
optane memory by pmem driver, the backing device is a 4TB nvme SSD,
there are 2-way Intel Xeon processors with 48 cores and 160G DRAM on the
system. An XFS with default configuration created on the writeback mode
bcache device, and following fio job file is used,
[global]
direct=1
thread=1
lockmem=1
ioengine=libaio
random_generator=tausworthe64
group_reporting=1

[job0]
directory=/mnt/xfs/
readwrite=randwrite
numjobs=20
blocksize=4K/50:8K/30:16K/10:32K/10
iodepth=128
nrfiles=50
size=80G
time_based=1
runtime=36h

After around 10~12 hours, the cache space is almost exhuasted, and all
I/Os go bypass the cache and directly into the backing device. On this
moment, cache in used is around 96% (85% is dirty data, rested might be
journal and btree nodes). This is as expected.

Then stop the fio task, wait for writeback thread flush all dirty data
into the backing device. Now the cache space is occupied by clean data
and betree nodes. Now restart the fio writing task, an unexpected
behavior can be observed: all I/Os still go bypass the cache device and
into the backing device directly, even the cache only contains clean
data.

The above behavior turns out to be a bug from existed bcache code. When
cache space is used more than 95%, all write I/Os will go bypass the
cache. So there won't be chance to decrease the sectors counter to be
negative value to trigger garbage collection. The result is clean data
occupies all cache space but cannot be collected and re-allocate again.

Before this patch, the above issue was a bit harder to produce. Since
this patch trends to offer more priority to allocator threads than gc
threads, with very high write workload for quite long time, it is more
easier to observe the above no-space issue.

Now I fixed it and the first 8 hours run looks fine. I just continue
another 12 hours run on the same hardware configuration at this moment.
 
> We hope this additional testing data proves helpful. Please let us
> know if there are any other specific tests or configurations you would
> like us to consider.

The above testing information is very helpful. And bcache now is widely
deployed on business critical workload, I/O pressure testing with long
time is necessary, otherwise such regression will escape from our eyes.

Thanks. 

[snipped]

-- 
Coly Li

