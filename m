Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B202CC9C3
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Dec 2020 23:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgLBWlA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 17:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgLBWk7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 17:40:59 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBDFC061A47;
        Wed,  2 Dec 2020 14:40:19 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id k4so3796qtj.10;
        Wed, 02 Dec 2020 14:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5VWMK8riaN21ed1mnCTXtrML+Qu3sFGPDoSWLxZbmqc=;
        b=h+cpgcTsjnqc/pRgTT1PYrIde++MZVC/TGfVR6bjNH377TUwRGIl0rLAsL0EagNkYe
         j+qSqQSTfMn7g1kGrSDYnWTY8oPicruqwa2msKzOO7xTQ6oza8ZFC/FHG0jBlLvECcL4
         G6uNrjpX3GuCiGK/ROGb8lTio98c254aUGoCmc+o5/Mlr26gzGZJPBsO+XzvupCSasKG
         A8RV1VBmOWvv8a6mx9EizIFD3F8z7T1Z7BvboXUa8KAt7hrZHnmMfzvhUkr3K1ytXcl8
         4s5dGaXadjLqBtxH33g2KQLA4/JCWJnb5kfZnF7KZyKqL6WVc5j0c7NdS+RduTU6e5H3
         7taw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5VWMK8riaN21ed1mnCTXtrML+Qu3sFGPDoSWLxZbmqc=;
        b=XcEHqtOVwRj+H6G/qyPJe4z87hLgDDQJXicWcDqEM1Nwd+t0zK4GsQ0o7XtPrM+eOt
         lD1V6j5nsTBJ9smHeUedJ2S/LivDKWFO2YlMrtgsFrHaDfnEXiInFHUln5zp6G0SUICw
         N1gvUST+Q+6cevsMZsodoqybAfkQSJmoazQ0c1MrHrMRo9UzZcrtvWS+cWQtcTCUJjTd
         f4IZqOu9y4FY43FqlDsKEEixi02NeZOlFkBkOAno4D6nwkoOSqEPSobvAYxcCL1WmmLs
         dAkxV2yygWoh1pPwnnuKQFi2fXCk47rICCw4kubTMqvdpFXOoxMj7/aYl6riggYIuBzJ
         U9QA==
X-Gm-Message-State: AOAM533wgisIbAwJo1m6IN4a1z3FRUhhk2bZKHQqjPQNrovCfRHbvHFr
        4YwOL8RlMC8DEgdVN0ier0A=
X-Google-Smtp-Source: ABdhPJyoCrR3r2+acO4knNjPoALcWJhpUyJ+Mg39+EUGpGq4eXtk9K7kIBllhBrw6AWtpTUnu8G/Fw==
X-Received: by 2002:a05:622a:208:: with SMTP id b8mr441919qtx.124.1606948818638;
        Wed, 02 Dec 2020 14:40:18 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id b64sm56207qkg.19.2020.12.02.14.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:40:18 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 17:39:50 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 2/9] dcssblk: remove the end of device check in
 brd_do_bvec
Message-ID: <X8gXtv4ULMBfVc2p@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:17PM +0100, Christoph Hellwig wrote:
> The block layer already checks for this conditions in bio_check_eod
> before calling the driver.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
