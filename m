Return-Path: <linux-bcache+bounces-655-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3041690AB88
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 12:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FBB1285BCC
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 10:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3D91946BC;
	Mon, 17 Jun 2024 10:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IeFJAWsH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uBuChXRm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tk56hY7X";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uAuSy9hb"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936F2181BBB;
	Mon, 17 Jun 2024 10:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718620888; cv=none; b=HkkhfvXyFTatu7MmBLpV8DYk8wwuMaWBVg5GLBus+Y6dU0/6+Kzc8quHid1KsCEWtbNoQT1c40T9Hdc6MWF7D8wbDMIYeVAK7hnqCGBIYHl1H1BuyvByjA0whtvA0f4BxaC9AbJdl13wgUf87XIBFYezkBrr2yTIZjjLvxy3gBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718620888; c=relaxed/simple;
	bh=AhwK+yKsTemWGuM0+yGtqqZD8Aj8it07SwFGwJcsNqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QKbuJapdwVqmnGuShlbkmXkl5ijHNv98StX4Y3w4xel6NSBKt4S9/vgITZjNJLeq0sRclOt3nn4evB018t3zN2uuq41pPwt1+F58U3ACdbYPp0CEawXtwvljLBUs0FepZDHtyU9gqXt5xvZ+x0vB2B+fS35enmJU8j+Y04Sh7Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IeFJAWsH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uBuChXRm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tk56hY7X; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uAuSy9hb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EDEFF3803D;
	Mon, 17 Jun 2024 10:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718620885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgtG6m+m1FRqVquXEHPrn3wmZaPvf3OoaYY0kuxzjZY=;
	b=IeFJAWsH75KCYIyv8/qhBGrl5836YIwBOLXQ3jGs9AGu4tCLccHXdaOiEmZNwYilYVnXvA
	SRmfeAJG/mJlmng7doCTF2JrMj/j1v1AtSvyaeFMA6zC9Uo8Apn9VwECptdlpKPI1o/2oN
	26YOZad+Gw/DJeftHbAa4kTM/y28MNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718620885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgtG6m+m1FRqVquXEHPrn3wmZaPvf3OoaYY0kuxzjZY=;
	b=uBuChXRm9UIyUB63kLl7vU6i6aEesxd1N6Ygk5vJm28e2KE/5WoIJeYPC8888eXD55Tt/v
	dimXmhyYdWeO0iCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718620884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgtG6m+m1FRqVquXEHPrn3wmZaPvf3OoaYY0kuxzjZY=;
	b=tk56hY7XbD+wgCVvAVC5TAAMNdWYTqZxaVADpw5mpu/Frmc+Y8zzf8x9gaIUWi7pHO5rjZ
	Tm01WQr3GPaAKNEgrckaVdo8Qm+/hXaj53GmO1gpM2xNwupMPVgSsIQq7PJCLZa0lbR+XN
	ddtS7T4F7YuLIEsh0v7LCAvj96Hq13s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718620884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgtG6m+m1FRqVquXEHPrn3wmZaPvf3OoaYY0kuxzjZY=;
	b=uAuSy9hbCb4YbUBJdXvIQbCOSketcC7FumfbAwU1hmYHwd+Jx1h140JOgS5gMLtaFdjOqr
	qYR/OoHcbBQkZAAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B5A113AAA;
	Mon, 17 Jun 2024 10:41:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5susHdQScGauDQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 17 Jun 2024 10:41:24 +0000
Message-ID: <24322288-fd9f-4f49-9a94-e2aaf97bb700@suse.de>
Date: Mon, 17 Jun 2024 12:41:24 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/26] block: move the nowait flag to queue_limits
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
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-20-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240617060532.127975-20-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
	RCPT_COUNT_TWELVE(0.00)[37];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLex1noz7jcsrkfdtgx8bqesde)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email]
X-Spam-Flag: NO
X-Spam-Score: -8.29
X-Spam-Level: 

On 6/17/24 08:04, Christoph Hellwig wrote:
> Move the nowait flag into the queue_limits feature field so that it can
> be set atomically with the queue frozen.
> 
> Stacking drivers are simplified in that they now can simply set the
> flag, and blk_stack_limits will clear it when the features is not
> supported by any of the underlying devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-mq-debugfs.c        |  1 -
>   block/blk-mq.c                |  2 +-
>   block/blk-settings.c          |  9 +++++++++
>   drivers/block/brd.c           |  4 ++--
>   drivers/md/dm-table.c         | 18 +++---------------
>   drivers/md/md.c               | 18 +-----------------
>   drivers/nvme/host/multipath.c |  3 +--
>   include/linux/blkdev.h        |  9 +++++----
>   8 files changed, 22 insertions(+), 42 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


