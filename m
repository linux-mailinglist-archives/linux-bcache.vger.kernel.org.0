Return-Path: <linux-bcache+bounces-223-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83166825DA9
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Jan 2024 02:33:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9D16B22B0A
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Jan 2024 01:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E548410E6;
	Sat,  6 Jan 2024 01:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IwnowARm"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC2B15A0
	for <linux-bcache@vger.kernel.org>; Sat,  6 Jan 2024 01:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-36066190a99so1016425ab.3
        for <linux-bcache@vger.kernel.org>; Fri, 05 Jan 2024 17:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1704504780; x=1705109580; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qT3oZQlZSl6Q++CcuktscPeZvw2bExX2KYu8x/389yU=;
        b=IwnowARmTt45mA/6L6GI6k5HX4s9Oqwiv9lk2v45fuES1vcmHHyNJeA11IizwQJIHg
         fW8P+lHgiJmu6PCEIpX/KdrZk6I0mg5Io12tEYwk4SJVrHU1bjqQEo1LNht/chEBCcsn
         YloIoGEyzchX+I095hsVKk7wjjWN2D9JbmVw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704504780; x=1705109580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qT3oZQlZSl6Q++CcuktscPeZvw2bExX2KYu8x/389yU=;
        b=ElD5/qIkkWD3ZmTtxAuumH/8raF/rqz+n2XahISk/TCje3orYxg9751kfA2HJAAeL9
         TjnQGGlOksRHtFPZhj7D32u3h4Vl/Hs7Gp/sxuMPwflo/wk9/yIx01SKflt8ZoExwwKu
         p1qyUUl98auOceEbzIbBFVESITJQASlxS9rAQjw6RewWZ5GsaKyyBPvi762Q3brkYcn0
         IgRMprjQiEeBLemI2lsGXRceR2bsZWEGQuv0EMLSdFH/S4KLnPXGjJWRWpAnf+sFnJY7
         5vCjWU45XmSt+urG43kcoMiDlhbUPjw6kRj+XrVYG4og8ykxqNeTZZSbc/m81eKaGtUw
         Dl2g==
X-Gm-Message-State: AOJu0YyQAi1/hQvTy/x5wbzOOpXxfgz0jF1OaZcBMmpWD6jOViVXmqO5
	vMXMrOdK0cTEYyfA0fccFxYOoencqg8A
X-Google-Smtp-Source: AGHT+IGbdqkCX01n0F2LxOJc20c51ndSlx6/hfXSdI3NKdAsCGkhvdsG05i+OtNt2Y/UCPH6C9phNg==
X-Received: by 2002:a05:6e02:1c0b:b0:35d:62f2:1f45 with SMTP id l11-20020a056e021c0b00b0035d62f21f45mr533250ilh.20.1704504780792;
        Fri, 05 Jan 2024 17:33:00 -0800 (PST)
Received: from google.com (KD124209171220.ppp-bb.dion.ne.jp. [124.209.171.220])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902b49100b001cf511aa772sm2017224plr.145.2024.01.05.17.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 17:33:00 -0800 (PST)
Date: Sat, 6 Jan 2024 10:32:54 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, linux-um@lists.infradead.org,
	linux-block@vger.kernel.org, nbd@other.debian.org,
	linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 7/9] zram: use the default discard granularity
Message-ID: <20240106013254.GC123449@google.com>
References: <20231228075545.362768-1-hch@lst.de>
 <20231228075545.362768-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231228075545.362768-8-hch@lst.de>

On (23/12/28 07:55), Christoph Hellwig wrote:
> 
> The discard granularity now defaults to a single sector, so don't set
> that value explicitly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

FWIW,
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

