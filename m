Return-Path: <linux-bcache+bounces-606-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 560139057CA
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Jun 2024 17:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 719121C22860
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Jun 2024 15:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D3518132A;
	Wed, 12 Jun 2024 15:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="V7cG6Ag/"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1E9181327
	for <linux-bcache@vger.kernel.org>; Wed, 12 Jun 2024 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718207781; cv=none; b=egCW1qX1G1TnaQWDIczJ8o0YEYwjT9sCj0UK5U3nAK8ZJ+MuTqzJyhAdp2uvvpaaa+4fkV3w4GCmEH+Xnn5xTzaAQR9iS4E3ime5asbM2AEzrkF3b4uh9/UdlX10LPFtNisvHfRYCjEL+kMI9gACL4rog4EU7OTjVCjbsiMrtJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718207781; c=relaxed/simple;
	bh=WxiyGuZAC7bj+QrxGa2lDi15MZrXhgJnJEV+bRK2uiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeuVgcfArlO5oWRiBE2ZEbsnkQa4rOUCms8k7eXTErFadkqsdecCnxI4Gbr9H4ZoSJ6fvxgCS04sNvZhYBImQ2u7LdvASFPZJwmmiWILP8jyyMGL3ZMY8frf+n+1XY0RHwjfUJ3OJglLxYWkx3AVjFlA0JAzHzNjuooAWDnIwa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=V7cG6Ag/; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6b08d661dbaso10317586d6.0
        for <linux-bcache@vger.kernel.org>; Wed, 12 Jun 2024 08:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1718207778; x=1718812578; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0JAgWI6yypeQvJHtBsLjxy9EsiTAtsBZFfQkPH4VMNc=;
        b=V7cG6Ag/z6iCUMnCyee02CpPpVNNKq0aFi2gbS3Dd7usN46ko1fDHLZJlYgCyUyzgM
         PkWsxqJiUKaH93GKZqh+J6Tx9GmEzvjLAPs83YmL2Gkt9gUBj/Q88Lr7e+uzv1URoIzD
         VKiz75cG3gC5YRvgiukyfUkbgvM5OnMGUnJzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718207778; x=1718812578;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0JAgWI6yypeQvJHtBsLjxy9EsiTAtsBZFfQkPH4VMNc=;
        b=xQrKBqlPpgJTGkPqId+a/xPfP0UH8IN6yHEbgy5fO3CI4VUVS248xe/0FQ/E/5gAWg
         9sffST+ZFfmop10B3t4YM7CZVfDpqscXTuIExEyySRiDDYDzUz/t9DLV4lgSWh7JpWSZ
         CjrAsMWmYMyzNfxpBcbDak8y9Kz5zB4Sf3wgRxFgVyz+THlm6PnJmZ65Se8D3Sk9yjfh
         QIPH+YR+TJ1XT5TUCyhzrri/pTyoayhWPP8C2urM5vj6Jm63VMQnjYSr+nVkOyBcLSza
         Xfld7VaNH4WhaOSG49s6i4ORHn1ZsIjaRzBv7HQVVEtP1RMitmE63DbRFI6haq0ny6Ds
         uaVw==
X-Forwarded-Encrypted: i=1; AJvYcCVXmNLvvKeAXqchcsQ9nxmZBsOuV6hj6V67IV3jZCiMsGFG2wDiCl8oL8Xuy14NtFkCW+vnTA0p6t213F19gYkUbZqaWeSf1b7Goofp
X-Gm-Message-State: AOJu0YwEsnIgNxWLeg6UoUzgz7CqWKrT5+6WwExKX8FH9N7G3b6093DW
	JmXPUVYO7aSwOPvTOBc0ttDVPYyu+7OptF4/yX3X1VX62qB1wCFjCt0eEZ5Tbxo=
X-Google-Smtp-Source: AGHT+IH3vJ/Cfk8LzYoeLv9cXT/SgN6Pt3X56xC7VVYFazmjn8i4deMSmAqg4iM25NKqjeo5TBvU1g==
X-Received: by 2002:a05:6214:2a47:b0:6b0:7365:dde0 with SMTP id 6a1803df08f44-6b2a33de160mr1306776d6.18.1718207777691;
        Wed, 12 Jun 2024 08:56:17 -0700 (PDT)
Received: from localhost ([213.195.124.163])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b0884337e9sm22877866d6.16.2024.06.12.08.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 08:56:17 -0700 (PDT)
Date: Wed, 12 Jun 2024 17:56:15 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?utf-8?Q?B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
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
Subject: Re: [PATCH 10/26] xen-blkfront: don't disable cache flushes when
 they fail
Message-ID: <ZmnFH17bTV2Ot_iR@macbook>
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-11-hch@lst.de>
 <ZmlVziizbaboaBSn@macbook>
 <20240612150030.GA29188@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240612150030.GA29188@lst.de>

On Wed, Jun 12, 2024 at 05:00:30PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 12, 2024 at 10:01:18AM +0200, Roger Pau Monné wrote:
> > On Tue, Jun 11, 2024 at 07:19:10AM +0200, Christoph Hellwig wrote:
> > > blkfront always had a robust negotiation protocol for detecting a write
> > > cache.  Stop simply disabling cache flushes when they fail as that is
> > > a grave error.
> > 
> > It's my understanding the current code attempts to cover up for the
> > lack of guarantees the feature itself provides:
> 
> > So even when the feature is exposed, the backend might return
> > EOPNOTSUPP for the flush/barrier operations.
> 
> How is this supposed to work?  I mean in the worst case we could
> just immediately complete the flush requests in the driver, but
> we're really lying to any upper layer.

Right.  AFAICT advertising "feature-barrier" and/or
"feature-flush-cache" could be done based on whether blkback
understand those commands, not on whether the underlying storage
supports the equivalent of them.

Worst case we can print a warning message once about the underlying
storage failing to complete flush/barrier requests, and that data
integrity might not be guaranteed going forward, and not propagate the
error to the upper layer?

What would be the consequence of propagating a flush error to the
upper layers?

> > Such failure is tied on whether the underlying blkback storage
> > supports REQ_OP_WRITE with REQ_PREFLUSH operation.  blkback will
> > expose "feature-barrier" and/or "feature-flush-cache" without knowing
> > whether the underlying backend supports those operations, hence the
> > weird fallback in blkfront.
> 
> If we are just talking about the Linux blkback driver (I know there
> probably are a few other implementations) it won't every do that.
> I see it has code to do so, but the Linux block layer doesn't
> allow the flush operation to randomly fail if it was previously
> advertised.  Note that even blkfront conforms to this as it fixes
> up the return value when it gets this notsupp error to ok.

Yes, I'm afraid it's impossible to know what the multiple incarnations
of all the scattered blkback implementations possibly do (FreeBSD,
NetBSD, QEMU and blktap at least I know of).

> > Overall blkback should ensure that REQ_PREFLUSH is supported before
> > exposing "feature-barrier" or "feature-flush-cache", as then the
> > exposed features would really match what the underlying backend
> > supports (rather than the commands blkback knows about).
> 
> Yes.  The in-tree xen-blkback does that, but even without that the
> Linux block layer actually makes sure flushes sent by upper layers
> always succeed even when not supported.

Given the description of the feature in the blkif header, I'm afraid
we cannot guarantee that seeing the feature exposed implies barrier or
flush support, since the request could fail at any time (or even from
the start of the disk attachment) and it would still sadly be a correct
implementation given the description of the options.

Thanks, Roger.

