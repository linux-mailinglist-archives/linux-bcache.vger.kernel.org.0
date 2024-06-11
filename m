Return-Path: <linux-bcache+bounces-564-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6277903545
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E44B28513C
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162F3172BCC;
	Tue, 11 Jun 2024 08:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Msni/WWt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jzzrLP1Z";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qr6H2Vmm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9xNbjaTN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7041E7346F;
	Tue, 11 Jun 2024 08:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718093752; cv=none; b=O0UK8c6CsjJqyTv9bG68KF5IrdqoOC/YFEWtzf6QlDkp6sbv+K3h323ZFm0yzFx6mRH2+STn8asaRe3T2cndR07D6zOH5hHyrPJsTITLkTP67S3z+zdRkufz/WGu4AY4gyOni+a8YJWxr7HFCnwSE/O5GtuIw7FDFHLy2EVx244=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718093752; c=relaxed/simple;
	bh=Ohc4NHB/JVZYfRcRLZNk9CDpSlYDUjNWHuo3o5vgKIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YHOx6Mb9SRPzRVCsgEwHm98vfL6JQqDNqtR8gwbdF6GWbWO045c1v/6eei0d7+QDg1sp8h7BvsjZ8PeNFsPVNMDrjBQred7d1I1auUUhtCWqi2Gp+c3S/4ZSvStc0YRsD2MP+1d3FSGjs3ek+w7uD4/Jm3KoXmQ6OAN0t3xN1Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Msni/WWt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jzzrLP1Z; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qr6H2Vmm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9xNbjaTN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E567122D2B;
	Tue, 11 Jun 2024 08:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718093749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2r7MKAg6vOI9CQHj9QnmN2izcLv5sbG9WOrlm/Tmo8I=;
	b=Msni/WWtQLJC7aiHZZiIPHdLoVyj8dvs0ywS03oXyJvZOgwHsNbEtMFNNO/rKPPwIVlOTY
	c1E1VE43mVs+c82WXEHd5kGOw9r1nGpnTlv/8hcy40zaNCRaYIIWc1L4DQqC+daZ2ZJ4FO
	MR9U/2yYW0xdzUkr2wVwGOmAbopiS+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718093749;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2r7MKAg6vOI9CQHj9QnmN2izcLv5sbG9WOrlm/Tmo8I=;
	b=jzzrLP1ZySMJr/ZpnKFyGXiwELwFPv7+mdiJjZVwlAeIGClmXFhoxCoKqdvUasa9E9ZDL2
	k/hSZ7RUw5WKZYDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718093748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2r7MKAg6vOI9CQHj9QnmN2izcLv5sbG9WOrlm/Tmo8I=;
	b=Qr6H2VmmwLwr7pMkTPc1IokvvR4M2YocGyeffhfCeL+fAvcnsb5fEvomUeoLAXoe+JGH4e
	8M3jjuywd208xFOoLE6NVO6cmyBZFpxxulLERQX4AFhnF4GlsMoMZtCanQx148T9MG9Uqk
	uPc16jDnqAa/RN/AE7ZGr8tZbqoW/Oo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718093748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2r7MKAg6vOI9CQHj9QnmN2izcLv5sbG9WOrlm/Tmo8I=;
	b=9xNbjaTNKIkHrIWVNAWqobr8/55RzaflSr0XLs4aXDQe/ZVLfdWVr681lzwfO99s/69NMi
	1sxmXZD4BgTrA7Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9054B137DF;
	Tue, 11 Jun 2024 08:15:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OPB/IbQHaGbxWgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 11 Jun 2024 08:15:48 +0000
Message-ID: <b586980b-0a5a-4371-bcb7-e578633ed71c@suse.de>
Date: Tue, 11 Jun 2024 10:15:48 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/26] loop: always update discard settings in
 loop_reconfigure_limits
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
 <20240611051929.513387-5-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240611051929.513387-5-hch@lst.de>
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
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -8.29
X-Spam-Flag: NO

On 6/11/24 07:19, Christoph Hellwig wrote:
> Simplify loop_reconfigure_limits by always updating the discard limits.
> This adds a little more work to loop_set_block_size, but doesn't change
> the outcome as the discard flag won't change.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/block/loop.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


