Return-Path: <linux-bcache+bounces-654-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1125690AB78
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 12:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DE44285A92
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 10:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900841946C5;
	Mon, 17 Jun 2024 10:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g6i+HE7U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DC8Hya9o";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g6i+HE7U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DC8Hya9o"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05B21940A1;
	Mon, 17 Jun 2024 10:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718620851; cv=none; b=ZPQhpzXHBLl3W8AmMgxlRSXnVIgfilijOOlc9SV1ZCh2H2o0qt6gch5fNRf7Pion/xwjIMOUvJXmXJgws8+/p/Q9MXTofcr7RZ9ChR+MnBtHRwHjLobzu4zvTGe+evCVMx7tIKkTbm+HoBy5aGEVy9LIrShrwUUyt9IcWQaGluU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718620851; c=relaxed/simple;
	bh=ntqH+2sCkAKbLWTivV7+JR5RzkyYEmLTet6ElsW3Aq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uGqYf94hQAPhPNzr4ntJ9bLcVnF/2YtFezsNTSZ+yr2B83WThxY763u3vo6sQcrdjbSbu7LP5UvJQo2hUJ5Xj1OaRRj/CtesbBn7frXdhVHt6e1xb+X+0BcdjfzPuxCEthNiJnXkIUXtgjuyXpOmq8TxnGDB0lHoxOATbISFwIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g6i+HE7U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DC8Hya9o; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g6i+HE7U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DC8Hya9o; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 502A33803D;
	Mon, 17 Jun 2024 10:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718620848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YRZ+MD2RD7DoqN1zKcgy+HFLwesZ3pPlf+aKbLWxjwU=;
	b=g6i+HE7UdDx9sU/po4lLP5ccgANLhcybh16BiI+67VqBuwRwDVonJPFzOMCDdBfpbCNKBC
	MD1s1VKGcMU3aCdrY17XV1IfskxdUXEg0QjRAJZi8F4DBktSipA264j6zDbr9/7MInSii3
	xnuF2R+5yQTsAoOY/MXu1e+Bwa+aCec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718620848;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YRZ+MD2RD7DoqN1zKcgy+HFLwesZ3pPlf+aKbLWxjwU=;
	b=DC8Hya9o4RrY68KluA6Q1U2drYPRvGd5eOn0Qpqja/t1DhzewBZPUwXN8T5m7vch3lMroJ
	rOjFgOFCF0RfD+BA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718620848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YRZ+MD2RD7DoqN1zKcgy+HFLwesZ3pPlf+aKbLWxjwU=;
	b=g6i+HE7UdDx9sU/po4lLP5ccgANLhcybh16BiI+67VqBuwRwDVonJPFzOMCDdBfpbCNKBC
	MD1s1VKGcMU3aCdrY17XV1IfskxdUXEg0QjRAJZi8F4DBktSipA264j6zDbr9/7MInSii3
	xnuF2R+5yQTsAoOY/MXu1e+Bwa+aCec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718620848;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YRZ+MD2RD7DoqN1zKcgy+HFLwesZ3pPlf+aKbLWxjwU=;
	b=DC8Hya9o4RrY68KluA6Q1U2drYPRvGd5eOn0Qpqja/t1DhzewBZPUwXN8T5m7vch3lMroJ
	rOjFgOFCF0RfD+BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74D3713AAA;
	Mon, 17 Jun 2024 10:40:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TLFtGK8ScGaFDQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 17 Jun 2024 10:40:47 +0000
Message-ID: <82e013f1-9029-460d-8a71-a64fd8ee58d0@suse.de>
Date: Mon, 17 Jun 2024 12:40:47 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/26] block: move the synchronous flag to queue_limits
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
 drbd-dev@lists.linbit.com, nbd@other.debian.org,
 linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-19-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240617060532.127975-19-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -8.29
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-8.29 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[38];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLex1noz7jcsrkfdtgx8bqesde)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email]

On 6/17/24 08:04, Christoph Hellwig wrote:
> Move the synchronous flag into the queue_limits feature field so that it
> can be set atomically with the queue frozen.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq-debugfs.c        | 1 -
>   drivers/block/brd.c           | 2 +-
>   drivers/block/zram/zram_drv.c | 4 ++--
>   drivers/nvdimm/btt.c          | 3 +--
>   drivers/nvdimm/pmem.c         | 4 ++--
>   include/linux/blkdev.h        | 7 ++++---
>   6 files changed, 10 insertions(+), 11 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


