Return-Path: <linux-bcache+bounces-658-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BE490ABC8
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 12:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AAEF1F273E0
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 10:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091C8194ACA;
	Mon, 17 Jun 2024 10:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cmmSBPs2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="B92gbOLV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TiRVzeY4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t5CaYJdw"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50631940B3;
	Mon, 17 Jun 2024 10:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718620992; cv=none; b=A1XzDhlmRabmaIG1CWrKgqx/y6C2CvgxkSqT8Stbx2+dS5f1JhvkV6oYTCy0W9dCEDDFmw8lx1xSI3rhv/4n/pA/br/fS06vzJEc9vHFt/I1rrXJttKIoF8YshvyLX+ybojoQTOeIcptkNR+xcHCTfKm7Kowd/uZr3eUpHmQKWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718620992; c=relaxed/simple;
	bh=D2USjn0sOgGcC9i5PiMBYYlAXPQ76BC1uNtE2/KTXjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gjz76II+pL8pxtOr4bt7MTY/BjwGpnB+lhFpxJHAjCKRbPraYghzIm0MS99yqxYhcWp/jJckoogXsQuKfaQyeDWUs+JAG6MtdqLGYaN01Gm1TytM9yhYHzTZxN7YXedVbkWTjy+AwADP3Isz5bG9Ko+nCZADsVT/Fmf8ws0kifM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cmmSBPs2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=B92gbOLV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TiRVzeY4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t5CaYJdw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D41D35FEE9;
	Mon, 17 Jun 2024 10:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718620989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eS6cZAP8PrCUOUN3SU0P3EiUgWRFs6k3X4SwgCCySaI=;
	b=cmmSBPs25p4H4sEPwGAIYUiX2uwegnyNhIlwPRzQIpdoOZGj4JzaP3T8DaODLiPWw9mUSz
	s5RMqwmmPfI36ETol7BRoAzdTd/vWZnvteESUa9wQj/IFwaYT5ru7oXBeGITPuMeg/aVw4
	ZM+TU4wok4o8O2S9lA/KuJze2r5v9p0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718620989;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eS6cZAP8PrCUOUN3SU0P3EiUgWRFs6k3X4SwgCCySaI=;
	b=B92gbOLVQD6eAgdjn6Bzl4NFN7iNb0ySX50WmsPod9PQCFGJEWc7mxy6VV5cJV6T7cKH+y
	aEdGgm/8XNL9s8Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718620988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eS6cZAP8PrCUOUN3SU0P3EiUgWRFs6k3X4SwgCCySaI=;
	b=TiRVzeY4b8BgXR1AVgVsNj7xraN6gx3lVPXLO5ki0L3pyeW2PafUroYNXEvKyBSl6Ggs44
	O8c3ELPSkDfeSso6KRmUefFHpezgWAKZGNzsEQ4v1MvPsuF7iSYFfz+y7Q05o2mR/FYIfg
	IE68WQfGWmDYf2Hn74jpq+bs83fGxNo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718620988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eS6cZAP8PrCUOUN3SU0P3EiUgWRFs6k3X4SwgCCySaI=;
	b=t5CaYJdw/5jN1yYQGG3K3dgg+uYjoVndVeOMh4ZeKdHOePhVDEm+C37+u16j5art4bCLkv
	h7mou1Tr9IUL9RCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23BEA13AAA;
	Mon, 17 Jun 2024 10:43:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HfgcCDwTcGYwDgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 17 Jun 2024 10:43:08 +0000
Message-ID: <23e0aac6-9af5-468f-a7d1-a331fe06c3a3@suse.de>
Date: Mon, 17 Jun 2024 12:43:07 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/26] block: move the zoned flag into the features field
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
 <20240617060532.127975-23-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240617060532.127975-23-hch@lst.de>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[38];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLex1noz7jcsrkfdtgx8bqesde)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email]

On 6/17/24 08:04, Christoph Hellwig wrote:
> Move the zoned flags into the features field to reclaim a little
> bit of space.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-settings.c           |  5 ++---
>   drivers/block/null_blk/zoned.c |  2 +-
>   drivers/block/ublk_drv.c       |  2 +-
>   drivers/block/virtio_blk.c     |  5 +++--
>   drivers/md/dm-table.c          | 11 ++++++-----
>   drivers/md/dm-zone.c           |  2 +-
>   drivers/md/dm-zoned-target.c   |  2 +-
>   drivers/nvme/host/zns.c        |  2 +-
>   drivers/scsi/sd_zbc.c          |  2 +-
>   include/linux/blkdev.h         |  9 ++++++---
>   10 files changed, 23 insertions(+), 19 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


