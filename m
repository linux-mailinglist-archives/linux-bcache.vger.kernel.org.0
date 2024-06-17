Return-Path: <linux-bcache+bounces-660-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37AEF90ABE8
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 12:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACD721F27452
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 10:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4042B1957EB;
	Mon, 17 Jun 2024 10:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s7paDZZV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E5BZWKGR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s7paDZZV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E5BZWKGR"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AF51953A7;
	Mon, 17 Jun 2024 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718621053; cv=none; b=Ua6AlJmO0AEdwm1LtyHvI4Ha7gvI8vW/OuKe9qz4/hwjtkBFr4OFYjn78+Sf8ajx33oqjfoZIfsDAmuTkXUzDf5OLwJvqioTR0tg9ZJDaMuEhsO7fFnae8Geer0jI1RrWifA4QwWy2FGXJkxjzcBX3NQ7bOTCvlZ2FtLzBYIHis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718621053; c=relaxed/simple;
	bh=fRcZyumAaY69GFbEcDG8I5FFJllCOtSGg5lLuy3vCmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s1qiKXvPy47dIG2WbaWf5a4SQj5ayTI9jewMQa1Mg+4OJaYrLMbg5+XVqueRGF+j/ydwt2uMj7pb2AM0lNLmfyxR1lvssIId+wXDQJUboq5cNPRRQJJE1BI97zonoA0vMZao6vtSkPv6axShVnChBvFR69qv+Vex9TbsAa1/KIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s7paDZZV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E5BZWKGR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s7paDZZV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E5BZWKGR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 23BCE5FEF1;
	Mon, 17 Jun 2024 10:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718621050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=siM3UuCseWBh/CBe/7d9FrlzrcJvhVMSOhKdgRyXxso=;
	b=s7paDZZVBRNdcFAQ16oQKsSkpX+26Uxtw+kewokSLFpaj5yQFHpEN78Tv/osc/OrBycvE5
	RCiR/PIm1PLSmpFRynIYOOclrcytpyHDo4HXtMPeBL5e6qpUe4Ouce4OyAZL2ULaHETYqu
	NCBoB90PdZM66VpPn1emRpRri3j4i6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718621050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=siM3UuCseWBh/CBe/7d9FrlzrcJvhVMSOhKdgRyXxso=;
	b=E5BZWKGRbvowhF34WQLyeDkMaCHWluLJK85qeAVsoDqrwhv9wbmLzMQ4EfADgpjAT5kIr7
	7cDoWPqSUh7WLzDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718621050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=siM3UuCseWBh/CBe/7d9FrlzrcJvhVMSOhKdgRyXxso=;
	b=s7paDZZVBRNdcFAQ16oQKsSkpX+26Uxtw+kewokSLFpaj5yQFHpEN78Tv/osc/OrBycvE5
	RCiR/PIm1PLSmpFRynIYOOclrcytpyHDo4HXtMPeBL5e6qpUe4Ouce4OyAZL2ULaHETYqu
	NCBoB90PdZM66VpPn1emRpRri3j4i6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718621050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=siM3UuCseWBh/CBe/7d9FrlzrcJvhVMSOhKdgRyXxso=;
	b=E5BZWKGRbvowhF34WQLyeDkMaCHWluLJK85qeAVsoDqrwhv9wbmLzMQ4EfADgpjAT5kIr7
	7cDoWPqSUh7WLzDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5A2F13AAA;
	Mon, 17 Jun 2024 10:44:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 70jqK3kTcGZ+DgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 17 Jun 2024 10:44:09 +0000
Message-ID: <ee0a4868-93d1-4a58-9495-ddb4c63fba6e@suse.de>
Date: Mon, 17 Jun 2024 12:44:09 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 24/26] block: move the pci_p2pdma flag to queue_limits
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
 <20240617060532.127975-25-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240617060532.127975-25-hch@lst.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo,lst.de:email]

On 6/17/24 08:04, Christoph Hellwig wrote:
> Move the pci_p2pdma flag into the queue_limits feature field so that it
> can be set atomically with the queue frozen.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq-debugfs.c   | 1 -
>   drivers/nvme/host/core.c | 8 +++-----
>   include/linux/blkdev.h   | 7 ++++---
>   3 files changed, 7 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


