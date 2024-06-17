Return-Path: <linux-bcache+bounces-662-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A555190AC01
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 12:48:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAA111C20ECD
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 10:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E80194AFB;
	Mon, 17 Jun 2024 10:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cHdgn9W4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="j6x1ql3o";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cHdgn9W4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="j6x1ql3o"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9372194ADF;
	Mon, 17 Jun 2024 10:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718621137; cv=none; b=DmRa6DYRphfOC1bPqMpHaCTw9jpA5a8ZjE37uEYTregB1LYwpcDPHV8cqPzcyhU+RaPAakiQxARC0VNa9+Qh7qRZbRLfYcp+RR/IyEU+FJBCcKnkr62+aQCePmeDdMA2fbs538Bh1y5C4SO0MeQsjFpjk3MvYbeWuhuspDhQcVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718621137; c=relaxed/simple;
	bh=eRoBK5/4xu/plFLs53OdfVIJexRh8oeq7oJw1sSkyF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QAWe4uvyxI3PJHrHYceLEi8bn6wd5xcDshcc/a3TMtdFizYVbrY7INIkfiosUfPEvE4inFp9N4cC6PHxlsMty4d+mP3DPd41eWFTBeIu/p1248x2ZuPXoTd9Mf6sgYTjRU/y9HLNr0QFKmtzvC2PW7B84shuXe4G2CKqvvlR0XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cHdgn9W4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=j6x1ql3o; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cHdgn9W4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=j6x1ql3o; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CCF9C3804B;
	Mon, 17 Jun 2024 10:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718621133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slP8wzcVm+UAH6cgQCtZYK/eQ7AbIkDnYf3KLR9axr8=;
	b=cHdgn9W4G9J0bE9J3jdrIA5h9r80guqMNBb5W5GdFASLapAtRmAO+S/TDk3J9mxlXYKQ3p
	XeyPNYiHIsartGEh8VHnpDVPl9PlSbixXhfd1N8WS6mi9euOFHAttCLDL2I6PiAjR9dt4c
	b8iVdUv2vEMMALrToXYEjc2bLtRNGCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718621133;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slP8wzcVm+UAH6cgQCtZYK/eQ7AbIkDnYf3KLR9axr8=;
	b=j6x1ql3oipn4My7hzsZomUyOPKAHtZ3GuatVGjA1bA/HdSpLPFhhpg/i+I1E4ZCYoxxHNa
	kb4ijVWkbYZKZPAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718621133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slP8wzcVm+UAH6cgQCtZYK/eQ7AbIkDnYf3KLR9axr8=;
	b=cHdgn9W4G9J0bE9J3jdrIA5h9r80guqMNBb5W5GdFASLapAtRmAO+S/TDk3J9mxlXYKQ3p
	XeyPNYiHIsartGEh8VHnpDVPl9PlSbixXhfd1N8WS6mi9euOFHAttCLDL2I6PiAjR9dt4c
	b8iVdUv2vEMMALrToXYEjc2bLtRNGCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718621133;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slP8wzcVm+UAH6cgQCtZYK/eQ7AbIkDnYf3KLR9axr8=;
	b=j6x1ql3oipn4My7hzsZomUyOPKAHtZ3GuatVGjA1bA/HdSpLPFhhpg/i+I1E4ZCYoxxHNa
	kb4ijVWkbYZKZPAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C97B13AAA;
	Mon, 17 Jun 2024 10:45:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xJQVGs0TcGYTDwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 17 Jun 2024 10:45:33 +0000
Message-ID: <94db71a8-75ef-4490-a28a-aea26f6dd945@suse.de>
Date: Mon, 17 Jun 2024 12:45:33 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/26] block: move the bounce flag into the features field
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
 <20240617060532.127975-27-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240617060532.127975-27-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-8.29 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[38];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLex1noz7jcsrkfdtgx8bqesde)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -8.29
X-Spam-Level: 

On 6/17/24 08:04, Christoph Hellwig wrote:
> Move the bounce flag into the features field to reclaim a little bit of
> space.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-settings.c    | 1 -
>   block/blk.h             | 2 +-
>   drivers/scsi/scsi_lib.c | 2 +-
>   include/linux/blkdev.h  | 6 ++++--
>   4 files changed, 6 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


