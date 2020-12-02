Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A202CCA45
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 00:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgLBXGb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 18:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgLBXGb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 18:06:31 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EDEC0617A6;
        Wed,  2 Dec 2020 15:05:51 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id u4so413670qkk.10;
        Wed, 02 Dec 2020 15:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NHfol06cSqlCCrl5YsPDHdTrQXLbo8wKJWGeGJlSsmE=;
        b=iSSRK2q3Pvd1F5lqJeQ7hyd0kV7Sn11M84d0rzQ/CdliWC4y68pC30Bbd3FxUg5Foj
         Ss3br/XUNv+2eaDVMKAcAgvXp2UiDVXY43+WXvzfyK91itPfKLEX7Igwox5YYMmkrvoX
         yrO8jG08QA3USxnSUc56chGjCYnVU8FVvJ9+mNMvmnHBvCpauC5ul9ocaX/4VDRICbNs
         9J3yJ6IFoLGABMGUkQyBXRBWXyhTDkR3Q3ZgEhgppo/jlHiwugdxQee6SpSNmwj3QvJw
         3G+bFXmIMb/yIDPI5/sJdfBQHQuWLIVgkBR7oHVO7qjYEsIMM4om1ep8LUh6++YNkEGY
         p4WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=NHfol06cSqlCCrl5YsPDHdTrQXLbo8wKJWGeGJlSsmE=;
        b=DZMCXJkhWYyiJQ/AxiGc7MY1PwdUbu3GIe+UUr7q63FvISyEu94Jpw0I658E8vspNd
         LDYIcniMsRAJnBPzsXc2p6S0qhGEOmYClkDo4r+CtCn9BOPgBOmTLIrh4cQ5l61NYOc0
         71fzk26HrC7YbeAFSnE+Tfk1yNPYaZbq0NpjL0VJxkx9OY8sIF3oCrC4FhjxVJDiS/pB
         SdKjk5F4LQ83TXuheeIJqbzCoyMsW/NWax+othxHMLUXpL2MwWrWtWY+9vlZDSOUYXjv
         PQZdDXKhLF5NHlKTAdATEK1qxe4nTXYe49Ek1YiDqmGGZ9rZp2hgiUoGVTcFLjXILZ3e
         8G2A==
X-Gm-Message-State: AOAM533GVuQjvV90IAkG/Ce5YskMggIoVgvMOCe4l+ktwnmW/LYU4HjG
        a8wxeXA40070RJQyhDQ8TTk=
X-Google-Smtp-Source: ABdhPJylOQn1ChoyZHml9j4uxp+LB+QzMjhGewJQojxlvSyi/AQikfiEJcPaQK9vpNDOdB/iqObIXg==
X-Received: by 2002:a37:64f:: with SMTP id 76mr114596qkg.260.1606950350503;
        Wed, 02 Dec 2020 15:05:50 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id w31sm433235qth.60.2020.12.02.15.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 15:05:49 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 18:05:21 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 5/9] block: use ->bi_bdev for bio based I/O accounting
Message-ID: <X8gdscx01GT9vJyp@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:20PM +0100, Christoph Hellwig wrote:
> Rework the I/O accounting for bio based drivers to use ->bi_bdev.  This
> means all drivers can now simply use bio_start_io_acct to start
> accounting, and it will take partitions into account automatically.  To
> end I/O account either bio_end_io_acct can be used if the driver never
> remaps I/O to a different device, or bio_end_io_acct_remapped if the
> driver did remap the I/O.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
