Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA2E6EDA88
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Apr 2023 05:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbjDYDOr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 23:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjDYDOZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 23:14:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72535A5F1
        for <linux-bcache@vger.kernel.org>; Mon, 24 Apr 2023 20:14:13 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1a814fe0ddeso57223635ad.2
        for <linux-bcache@vger.kernel.org>; Mon, 24 Apr 2023 20:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682392453; x=1684984453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KhNVYkLTzmbXjoyFBzocC/TOpuMyPoYNLjO0Vj2mibo=;
        b=disMM9XtLkiGCKZtd2OSxWABWw9EzU1/6D/IwdYByqFDWPUhm4xLI9xCnruU6GXByv
         lGfXjKJ/vPERVeRzbhxU/9YPp6HQoHLSsnwu4eszbZzg7xTp0v+lXC+MgYgjcW6csnZw
         RTQutquC9W2lPi7kSqusMCclIliGGDy8BjKOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682392453; x=1684984453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KhNVYkLTzmbXjoyFBzocC/TOpuMyPoYNLjO0Vj2mibo=;
        b=IzRyhrKS9Va/D2dAy1LRW1mxef6Ida7TZHtYOt/JpQI/yncxlg/hanIbbIawBLbp1K
         RtfkO4zbsGgaVvIEH0C7KlaPmT79yZR5m15p/3RxwGSOiv5dOX7aMF3BdXzX1dalSPKd
         5X57pWFkXRZ1FWQ8IOmFM84+eaZNiQeVBM0l4w4+HYEEHWo7ZX7fbgpXxq8SLb91Ri9W
         3uRlCcngRSJZ9DBFMbmgsmSIwz8cxwY2hjh3Vr5xPk7n1f2xooVHxR2gmCwMkdc2h7Nz
         ZRpLhl0IbrE11a1sRcbY5Hnff75ZRF3z/t9lnAaOh5erqZUDml37kGYn09hSYylplR+E
         NAjw==
X-Gm-Message-State: AAQBX9ealYd3FaXGpgpVDlnVuEbDj4nEpObtMfGb2C58EdjtA2+Fe0F0
        dnNjEBLMio05YzidV+jPzp2SWw==
X-Google-Smtp-Source: AKy350ZRcs6vQaV2vbvFGrwyeov6O4WMuCeSbDK3CDrpizjg9yr8PKdiVHOflM1xqHZ8CUGlvZPBhg==
X-Received: by 2002:a17:903:32c1:b0:1a9:5093:a604 with SMTP id i1-20020a17090332c100b001a95093a604mr14818577plr.18.1682392452979;
        Mon, 24 Apr 2023 20:14:12 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm7173351pll.77.2023.04.24.20.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 20:14:12 -0700 (PDT)
Date:   Tue, 25 Apr 2023 12:14:06 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Chaitanya Kulkarni <kch@nvidia.com>
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        axboe@kernel.dk, josef@toxicpanda.com, minchan@kernel.org,
        senozhatsky@chromium.org, colyli@suse.de,
        kent.overstreet@gmail.com, dlemoal@kernel.org,
        johannes.thumshirn@wdc.com, bvanassche@acm.org,
        vincent.fu@samsung.com, akinobu.mita@gmail.com,
        shinichiro.kawasaki@wdc.com, nbd@other.debian.org
Subject: Re: [PATCH V2 1/1] block/drivers: remove dead clear of random flag
Message-ID: <20230425031406.GA1496720@google.com>
References: <20230424234628.45544-1-kch@nvidia.com>
 <20230424234628.45544-2-kch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424234628.45544-2-kch@nvidia.com>
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On (23/04/24 16:46), Chaitanya Kulkarni wrote:
> QUEUE_FLAG_ADD_RANDOM is not set before we clear it for "null_blk",
> "brd", "nbd", "zram", and "bcache" since by default we don't set
> "QUEUE_FLAG_ADD_RANDOM" to MQ ops.
> 
> Remove dead clear of QUEUE_FLAG_ADD_RANDOM in above listed drivers.
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org> #zram
