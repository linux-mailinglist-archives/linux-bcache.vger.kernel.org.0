Return-Path: <linux-bcache+bounces-570-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 440359035A8
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B294285EA5
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1772174EFF;
	Tue, 11 Jun 2024 08:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Mz5UZyRu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q1OceNt6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Mz5UZyRu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q1OceNt6"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3746117334F;
	Tue, 11 Jun 2024 08:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718093970; cv=none; b=btqx9kQfNKpXKfm1CTJ4V+qR+RXNDmt6Ja5cJjr+PANs7444DntxcNixr5hvjS/P+zm6LvhWgHS27E//Fdu0VlKbbvLy/IUL5jmBwQ2obUC0X2i4iLnAuZ8Gz4N3MktKDPH3r3DSII/3rTBeJ+WOMJAFx+lszZRKFEmL4rOhBcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718093970; c=relaxed/simple;
	bh=yBeNdoD88yfDobcwnDihbaCso0dpjGUG/oRyVNNaoY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QRyDbaqg7E1cgWzpPuJEJR3WsXalwb9DaxMl3/MJqJf3zM5u3dGR2S6X9nb7amVHmTdboEh0LKxAeMAoA+nHnxmSa5Sjk1josTgCAS+8Hwqx716iWYuvAHyV3OL0jANjcDczN30gvsCwF+ctBWuImi8lKO8Uj/9vQ/4aZfz3mnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Mz5UZyRu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q1OceNt6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Mz5UZyRu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q1OceNt6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4AADB22D13;
	Tue, 11 Jun 2024 08:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718093967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GGJw6dDkRs6k2mZvFIE+UpGETGYtBieUVHqbMn2Gy0w=;
	b=Mz5UZyRupBOC5OyhaduIbHV4wlYjNn2j7sCWgFf6vyQPQnjkDPAfZ6Q/JsN5Cmj6BSiYUF
	xwezQUEPyxhygG9mxrG/r7jSoy12gHEp2VD+DxfzLjw84R1R+ikRm3duxRjgQt2dRc+rR/
	zySz8BDz3RCb9rOF3+/OqcxNzULWgh8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718093967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GGJw6dDkRs6k2mZvFIE+UpGETGYtBieUVHqbMn2Gy0w=;
	b=q1OceNt62q6MVmBZro11IIzTmhALV7YjKRa+RmhhyhFm32XqJpB3kE67x0ShtykE6k333v
	IXaAxWMTn07ACfBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718093967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GGJw6dDkRs6k2mZvFIE+UpGETGYtBieUVHqbMn2Gy0w=;
	b=Mz5UZyRupBOC5OyhaduIbHV4wlYjNn2j7sCWgFf6vyQPQnjkDPAfZ6Q/JsN5Cmj6BSiYUF
	xwezQUEPyxhygG9mxrG/r7jSoy12gHEp2VD+DxfzLjw84R1R+ikRm3duxRjgQt2dRc+rR/
	zySz8BDz3RCb9rOF3+/OqcxNzULWgh8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718093967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GGJw6dDkRs6k2mZvFIE+UpGETGYtBieUVHqbMn2Gy0w=;
	b=q1OceNt62q6MVmBZro11IIzTmhALV7YjKRa+RmhhyhFm32XqJpB3kE67x0ShtykE6k333v
	IXaAxWMTn07ACfBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 20BA0137DF;
	Tue, 11 Jun 2024 08:19:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8CuOB44IaGZWXAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 11 Jun 2024 08:19:26 +0000
Message-ID: <1208a68f-bac4-4f10-8f67-58eabf5ba89e@suse.de>
Date: Tue, 11 Jun 2024 10:19:25 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/26] virtio_blk: remove virtblk_update_cache_mode
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
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-9-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240611051929.513387-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,lst.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -8.29
X-Spam-Flag: NO

On 6/11/24 07:19, Christoph Hellwig wrote:
> virtblk_update_cache_mode boils down to a single call to
> blk_queue_write_cache.  Remove it in preparation for moving the cache
> control flags into the queue_limits.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/block/virtio_blk.c | 13 +++----------
>   1 file changed, 3 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


