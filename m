Return-Path: <linux-bcache+bounces-279-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9173185A2CF
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Feb 2024 13:04:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C33421C20DCB
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Feb 2024 12:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B7182D052;
	Mon, 19 Feb 2024 12:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="R7qtCaZN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B8B2D045
	for <linux-bcache@vger.kernel.org>; Mon, 19 Feb 2024 12:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708344288; cv=none; b=dhywwn6lVc+ub+jOKs+nlkSZ/12B1P9mxMU2AWcvzMybSa6JlXxJx9LHIfuMw2rd85ZwKJfNi1xSTNAByoejI02phJ/oNfwhccj2sD5ddrvQNXXnF9JZ/RtP1eJG59UM38YdvP7IVjiKkjmE4evtLwkz6Fp68/HZ7SPyhsFzMwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708344288; c=relaxed/simple;
	bh=zDbj09vXhQ9a99MHLCKO+w+Rwn+2vxV620SpE5+aZl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivI8o/Nnd/PVp3MeitT8QU1oGMuccHStKHRPOD/UMWasWcwQa7wnoNNK9pFm/CXPQyRtL1VnCQyUxwHRiXd6ayeo6xN3VxkEdfS7xE+QBafZYfIx91qX138HqkRMJByDR9AzKFGegYTxwZ8ZwXeF40M0dqcdrQdRm7G0GZxcjpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=R7qtCaZN; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-296d667e9b3so2197454a91.3
        for <linux-bcache@vger.kernel.org>; Mon, 19 Feb 2024 04:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708344286; x=1708949086; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UD0Q+YuM0aYncw1zT/Ixj8YCSgfiS1s5vMLj9q2v0Ag=;
        b=R7qtCaZNUKh5QFooyHccPMDt4FajVt9G2m7Ve7QRuTVd2EtTdRLdDjGT8N/wifzIDb
         ZSCvr+irs1Y25nQ4kZUmTWsk1fzVY/O7j+9KsK8gBEwe/ilk9H139A8fwi9fkW9mp3lw
         nb6BGzhypxsptP/RiawM9y/LEiWQbntszHmpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708344286; x=1708949086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UD0Q+YuM0aYncw1zT/Ixj8YCSgfiS1s5vMLj9q2v0Ag=;
        b=POnz5NhvjvHwkxV5eBXafSKceFPX4O80WN/xUW3PJMGrz0tiBFR1ThENkkTVTBNnOz
         7UnIfkOtuzMuZbWlbZTMD0RoCqZwkN5pz7AxKbSlLBXBqnRkyy18yMEtghaVxU01rFu/
         vxzsu0S/SoLfUpMGhwuh8v49rl1zaTiF3UIUOKi/oAJkO+vdNd9Ir4LsBN0d75Rh5aku
         1da/vL9ErlSXg6b+PGkxflP6JDGMH5xDZVop4nJ3KhIOJ7sr6rZCCJXrKt1hXyUH7LJt
         Fg53SToV5Qbc6v0w34r+R+j8mQPNRPot/F0671n3F7YoCMtqEcjRiJTC6Gboh2E1SXHz
         QSmw==
X-Forwarded-Encrypted: i=1; AJvYcCXOaOmpAvAS1cX3/zjLeqURNuNb3xevAfVWfL1qJzZjIV5IXsAkR0eGR6SQ5kTA1YQr1maRDFECTfVq7GhBE4PVO7tw/aVl/DGRMkqQ
X-Gm-Message-State: AOJu0YwL5hF1cO+ZBhhxFgkt5LyApCX+TQMjLaifwGrl0UrucSxspI1A
	kjDZWkg2mFe65PgPYxKyR4z4on94Yy4lqrx4xoHL3fS/1uGYu0k2T+BZWjT28w==
X-Google-Smtp-Source: AGHT+IGI3q8seWzsit4w49RmDdpR7qXA23sSQ+6AKRh25Sx/UF2Jg2gSUuWiILezaNCe3BsJyRg1Qg==
X-Received: by 2002:a17:90b:607:b0:299:69c9:da3b with SMTP id gb7-20020a17090b060700b0029969c9da3bmr2641050pjb.38.1708344286161;
        Mon, 19 Feb 2024 04:04:46 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:8998:e92c:64ca:f09f])
        by smtp.gmail.com with ESMTPSA id sl14-20020a17090b2e0e00b00296d9c4d5f0sm5125314pjb.10.2024.02.19.04.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 04:04:45 -0800 (PST)
Date: Mon, 19 Feb 2024 21:04:40 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Coly Li <colyli@suse.de>, Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	linux-m68k@lists.linux-m68k.org, linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: [PATCH 5/9] zram: pass queue_limits to blk_mq_alloc_disk
Message-ID: <20240219120440.GA11472@google.com>
References: <20240215071055.2201424-1-hch@lst.de>
 <20240215071055.2201424-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215071055.2201424-6-hch@lst.de>

On (24/02/15 08:10), Christoph Hellwig wrote:
> 
> Pass the queue limits directly to blk_alloc_disk instead of setting them
> one at a time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

