Return-Path: <linux-bcache+bounces-653-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4243B90AB6A
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 12:40:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B564328374C
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 10:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D431946C6;
	Mon, 17 Jun 2024 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oOv3IjDD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ot8p2izY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qm6g/5pL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="I5XoAx51"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F1A1940B2;
	Mon, 17 Jun 2024 10:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718620806; cv=none; b=AwRfd03jOCwfCh9I5CG8c+aIvVnRUh12hL4q0X27B55j1lQxxfZzyGPFhCL3bqgoJu757K1zpaZCSbWR4mURtdta+XG58lS9bmCfDqp0cGeKNQGCc7OaI0/Lv1Ux4Su9RAGEYxzT+KQW9P6SjxHBwrlXnpbuuZOUwyW5TaY8Kjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718620806; c=relaxed/simple;
	bh=4Ix3mv4gnzFEuKeYlq8JMux7xGkuXi0BrwRHwTQv+us=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T4fR8QORP+qNdmiBRhcTXFTRXw0wiRxcQ3TRGvSXO/UHfMCy2kM1KR/VlNbuYP5XojMjpJyYkPbj/2mJeTayYFZNL53nGsXxtcs37AlKREprSxvQtTg4pq6Zz5lCe7VD+r7SCjZIv2oirZZdDfozeq0h4+X6ftK4APzpHhkT2tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oOv3IjDD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ot8p2izY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qm6g/5pL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=I5XoAx51; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9E7663803B;
	Mon, 17 Jun 2024 10:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718620802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Udw7UxW9RD3hNhptJltcmuBZ5/E3Nt3KJ3oFtf1o28Y=;
	b=oOv3IjDDx2wwA/r3rxn0NrWSiorUlzu/LZiijLg8zoFMNTIfIM4KACkJhGKNr5tgCgDFN2
	swyfAOkUz04diI4ZMqo8O9CfOPpwu5I9Mbz5BfhGU7kk82GiUoe9lOYe/FmJo0YDcXy45h
	p6sRFsU8MYD8T30FAykkFiDl4pSJT1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718620802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Udw7UxW9RD3hNhptJltcmuBZ5/E3Nt3KJ3oFtf1o28Y=;
	b=Ot8p2izY0JtiMVs7/UuRj91DhFSpICfcz8ETan8iR+o2zqUCceOag3Og+ELTgEFRWMxfbJ
	H8kXANgn0V48g2BA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718620801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Udw7UxW9RD3hNhptJltcmuBZ5/E3Nt3KJ3oFtf1o28Y=;
	b=Qm6g/5pLH7+rQF9CQcnhh4VfHY9JM1VLyrzusyShCKdjoL8ke6Y5p2a8ZvdRK9QO5njFgF
	YkCNGSzlCWSjguEvmCBuyak35LtQXw/NkOXCaYD3xb3wZfhtp026a65y7DMmmBLXFaq8EC
	tC3POtul8QOovRe401BsrfyBEimwH3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718620801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Udw7UxW9RD3hNhptJltcmuBZ5/E3Nt3KJ3oFtf1o28Y=;
	b=I5XoAx519a0gdMtOMGCbku8aSmfojCQpJBFdmrQf3R2hUK40sd4Fa4cUr6ieELRADq/qgE
	4hoN05xE6nA/YkBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1B20313AAA;
	Mon, 17 Jun 2024 10:40:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qgSdBYEScGZBDQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 17 Jun 2024 10:40:01 +0000
Message-ID: <293c79ef-43fe-4a08-8e2d-54aa61d04d43@suse.de>
Date: Mon, 17 Jun 2024 12:40:00 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/26] block: move the stable_writes flag to queue_limits
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
 <20240617060532.127975-18-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240617060532.127975-18-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[38];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLex1noz7jcsrkfdtgx8bqesde)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo,lst.de:email]

On 6/17/24 08:04, Christoph Hellwig wrote:
> Move the stable_writes flag into the queue_limits feature field so that
> it can be set atomically with the queue frozen.
> 
> The flag is now inherited by blk_stack_limits, which greatly simplifies
> the code in dm, and fixed md which previously did not pass on the flag
> set on lower devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq-debugfs.c         |  1 -
>   block/blk-sysfs.c              | 29 +----------------------------
>   drivers/block/drbd/drbd_main.c |  5 ++---
>   drivers/block/rbd.c            |  9 +++------
>   drivers/block/zram/zram_drv.c  |  2 +-
>   drivers/md/dm-table.c          | 19 -------------------
>   drivers/md/raid5.c             |  6 ++++--
>   drivers/mmc/core/queue.c       |  5 +++--
>   drivers/nvme/host/core.c       |  9 +++++----
>   drivers/nvme/host/multipath.c  |  4 ----
>   drivers/scsi/iscsi_tcp.c       |  8 ++++----
>   include/linux/blkdev.h         |  9 ++++++---
>   12 files changed, 29 insertions(+), 77 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


