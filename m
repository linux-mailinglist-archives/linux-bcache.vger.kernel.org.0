Return-Path: <linux-bcache+bounces-197-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C815F822491
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jan 2024 23:12:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B4D81F230EB
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jan 2024 22:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6120C16417;
	Tue,  2 Jan 2024 22:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tx9hJG3m"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B32171AE
	for <linux-bcache@vger.kernel.org>; Tue,  2 Jan 2024 22:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704233518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBOv2jm2vjkJK88t9NbUPVCUIzSLH16o/dGCZ37tOWs=;
	b=Tx9hJG3mZktLh9g2RKUU7RXpOsDllfXZYaR6l65OKvN+d9kLuRV5rZ1CNkefmPfP1+g/f/
	eb1sgBmnnt8ZXcQ3reihgJLjN1X6bPqzXcIoqqBCP2qkDhPYCVullJcliT5vJNcw0SquU+
	qpDlm9CORFpR6OAuaTnFXMEctBgLXcQ=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-es4-CshCMVaxohO_ZEyq6A-1; Tue, 02 Jan 2024 17:11:56 -0500
X-MC-Unique: es4-CshCMVaxohO_ZEyq6A-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5e9de9795dfso166195577b3.0
        for <linux-bcache@vger.kernel.org>; Tue, 02 Jan 2024 14:11:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704233516; x=1704838316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lBOv2jm2vjkJK88t9NbUPVCUIzSLH16o/dGCZ37tOWs=;
        b=bzCq58N74pFglY0cqCzu70xhMkqclclsTduyzl2u/jeFiHgogOR1uTpn+VCN19lzcJ
         PLuQvCDF1DBiHATfwebCsnYfSzfYFKJ0uTPyEo7l3Xg5lm/kzevExeSwetNuRmlWaME7
         IjGOreeiJk4oA6noOIWLCux+Zc4El3S24turxtOJbTLA7OzEZCQTNWevlS6tgHP/qkaL
         F86TIHerjk0d4B5R0xxO2vsKJP/GtFWbE6Zr8qUuqlZxweZ7D3G71zJkARuBwIBV6zMh
         tSpxMJkfGq85HS+GwBGfsRLiV5rgF57jBtkEOOpZwelQpGj5WiY26jo3iB5+Uuyb4ig7
         fDbQ==
X-Gm-Message-State: AOJu0YyHJ2dK+v59c8bwD1dnduNTIW8fo6B8r6rnU8rFRj14fanegSas
	qnczydVgX9I33sXxHEiAZDoKcpmGVzUGqQ3LNdB9vM9cYO+tzM5qP6m3Xz1zBUt+lDMaMB19Lv4
	1UrBCHnjy52syDEcaoMha4QdeehoL+S8OqtytyzdEXfpYsCt1
X-Received: by 2002:a0d:e615:0:b0:5e7:5246:8f7b with SMTP id p21-20020a0de615000000b005e752468f7bmr10650778ywe.79.1704233516169;
        Tue, 02 Jan 2024 14:11:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnz4shpbyeonHylop6FDEDEEVcbaCqR7iBp2aclsXjzz7g8rllaGLNWxCJxvlxS1qvAvVXIZDM72VDn9UiZCA=
X-Received: by 2002:a0d:e615:0:b0:5e7:5246:8f7b with SMTP id
 p21-20020a0de615000000b005e752468f7bmr10650769ywe.79.1704233515934; Tue, 02
 Jan 2024 14:11:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231228075545.362768-1-hch@lst.de> <20231228075545.362768-4-hch@lst.de>
In-Reply-To: <20231228075545.362768-4-hch@lst.de>
From: John Pittman <jpittman@redhat.com>
Date: Tue, 2 Jan 2024 17:11:19 -0500
Message-ID: <CA+RJvhwg3YXAzSk81nMGw=_3OMo6P=XcXBUFUAXSBcyXH6gkDg@mail.gmail.com>
Subject: Re: [PATCH 3/9] block: default the discard granularity to sector size
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Josef Bacik <josef@toxicpanda.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Coly Li <colyli@suse.de>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	linux-um@lists.infradead.org, linux-block@vger.kernel.org, 
	nbd@other.debian.org, linux-bcache@vger.kernel.org, 
	linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Christoph, is there a reason you used 512 instead of SECTOR_SIZE
from include/linux/blk_types.h?  Thanks!

On Thu, Dec 28, 2023 at 2:56=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Current the discard granularity defaults to 0 and must be initialized by
> any driver that wants to support discard.  Default to the sector size
> instead, which is the smallest possible value, and a very useful default.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-settings.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index ba6e0e97118c08..d993d20dab3c6d 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -48,7 +48,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>         lim->max_discard_sectors =3D 0;
>         lim->max_hw_discard_sectors =3D 0;
>         lim->max_secure_erase_sectors =3D 0;
> -       lim->discard_granularity =3D 0;
> +       lim->discard_granularity =3D 512;
>         lim->discard_alignment =3D 0;
>         lim->discard_misaligned =3D 0;
>         lim->logical_block_size =3D lim->physical_block_size =3D lim->io_=
min =3D 512;
> @@ -309,6 +309,9 @@ void blk_queue_logical_block_size(struct request_queu=
e *q, unsigned int size)
>
>         limits->logical_block_size =3D size;
>
> +       if (limits->discard_granularity < limits->logical_block_size)
> +               limits->discard_granularity =3D limits->logical_block_siz=
e;
> +
>         if (limits->physical_block_size < size)
>                 limits->physical_block_size =3D size;
>
> --
> 2.39.2
>
>


