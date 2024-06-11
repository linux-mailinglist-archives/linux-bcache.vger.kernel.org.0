Return-Path: <linux-bcache+bounces-571-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C69439035B6
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:20:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FB1A288BB9
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B3D17332C;
	Tue, 11 Jun 2024 08:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CeZPcfC1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rbO1KscB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ru97uNsY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JCo1uwRL"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA6616F908;
	Tue, 11 Jun 2024 08:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718094029; cv=none; b=UEnXGS/c/0lhsP0/h8kw582tF4U+4urfkOlrCLZZ79Ooh5ExAmxfDojX6OBwNQ9yZxyamXz4BQhhoIh2o9spxQXEA75VsEXyIrl+PZGv8k9MFnVit3yR0ILjvGfV3rYFg4dGevNHyhY+sVS2fbEVxQzjxv3z0mfMdlFFl1b9iK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718094029; c=relaxed/simple;
	bh=jHmT0Dd9K4n/mabIUZgL9qijoIPINdBaGMd4Qrm9MGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S/okQA+ui5DVAsr3hvbGsTJunwFgm7hv6DfzhIjQrPkr+2mVzZHvJUyfhueewAL8acXhz0VbEJLnAzctty1FnANIWbnusBTCWB6YtaRCWX9zBJUdxkb/AFOBxT3UDBIQE40zMVmnzG7y0CJhYxAnzwJKDrSTsOcAJeFdnkvVWv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CeZPcfC1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rbO1KscB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ru97uNsY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JCo1uwRL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E4DDB2056A;
	Tue, 11 Jun 2024 08:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718094026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jGomuCAp2pz/1uNBu4SRDVlzjHuYKTuVW/cC7GVoJ+s=;
	b=CeZPcfC1tei4Yoyik+tGn3KMUx0tYad+9QT86YWgmWIoMwD8SG6Olr8/OpQgGmSlpFOFrV
	1QMhq17GV3KTHtbekRcFjW6L+u5akZQinRuMUbw96XHeekDnFkAcnzJHDSMFcVSc1JTgCf
	PIvex34kEKn8lkXWIw8YlQLqvIZdM4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718094026;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jGomuCAp2pz/1uNBu4SRDVlzjHuYKTuVW/cC7GVoJ+s=;
	b=rbO1KscBBDGwI875BWEKNiUKvkGWpIHf7GXnAoTtDPKgnWXQVIXWhgCl2vWo6uzLSeZXs1
	kBnIZBFi8VbrEHDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718094025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jGomuCAp2pz/1uNBu4SRDVlzjHuYKTuVW/cC7GVoJ+s=;
	b=ru97uNsYchlahhQRdCUMGWhruNOUhzwEthEA7N1gdGL1zKHNbQZPYXDbsm29DX8BaibMfU
	TpmRKmq6nzdpHbPVCOGOBsSVgCWvYVMacGcYa+dNJn5XRlpn58CiIVsix1vUeqAKLDkIDY
	khUgAadqtH4P4RSYCuTBRHzcjnQ3m7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718094025;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jGomuCAp2pz/1uNBu4SRDVlzjHuYKTuVW/cC7GVoJ+s=;
	b=JCo1uwRLDQmHCULWVwq4uscwDUMV84vAByFfE7YcJRHJ+TMx+QhsTnZckChZRP2tohL5Do
	JYyX/2Jy2/atV/DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 812E7137DF;
	Tue, 11 Jun 2024 08:20:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id io/THskIaGa0XAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 11 Jun 2024 08:20:25 +0000
Message-ID: <161db500-6d5e-4dcc-8e44-f75c0f777a0c@suse.de>
Date: Tue, 11 Jun 2024 10:20:25 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/26] nbd: move setting the cache control flags to
 __nbd_set_size
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
 <20240611051929.513387-10-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240611051929.513387-10-hch@lst.de>
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
> Move setting the cache control flags in nbd in preparation for moving
> these flags into the queue_limits structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/block/nbd.c | 17 +++++++----------
>   1 file changed, 7 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


