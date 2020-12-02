Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728692CCA1A
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Dec 2020 23:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgLBW5A (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 17:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgLBW5A (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 17:57:00 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275B3C0613D6;
        Wed,  2 Dec 2020 14:56:20 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id es6so67768qvb.7;
        Wed, 02 Dec 2020 14:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IBFDTpo6HCPZ58+V0bzhRqACm4PvOWR/Et5h/3XwaU8=;
        b=TvWJEJnUJXkGMOnX7Dz1P7yeuQgJ1YxF/HGwdmJgn5aWVXw2iJYs/WoINnhJCLLomM
         BHuAC/cg9xdRxnyG2ZYHgFc/VZPO/i1Vr0bl63/bw1Qwc10Im7/CdPamN42BGX5Pyrkm
         2QTIrpKFl5CvbUQp8oHAxzOgdOwUt5YDruTWmpPEgRg3c+q6F/WzHqA9MsQzEr/9l1bb
         p+cI6kRoEELTHzqHnOHUQ7YtYkSmMtpVbhUOIzF4gqrmYxODwA/KKTDJts55frFt0/QE
         3GS3pxjUYuOWopqR97VaLOVKtcAMsRmVIFvGYgVxIlmnKVRkRo1a3EY7/K54ktz9Mekr
         cXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IBFDTpo6HCPZ58+V0bzhRqACm4PvOWR/Et5h/3XwaU8=;
        b=GyG/axJt0sU49zvHCHRIlM4n79xl/B/Km4COSk+Lgoac9jPyNFwBIvVgUrL6IhrZZG
         uYABYFAHIq8PDN5ImKmfPYFGRXEpj9i2KnKxPOahTeP+0PGJOV6dQYnlhu8VyuDlWkX/
         IsA245td1g4EHOY+qA275LkpNUW9oWPI7EX+lfoJeIPuGYITwC/O3pjn8hAI1v2I2N45
         eGytkgIUYZqIY4CIWEcnTXZGe7PuJ2/qbh2pVbC3PPszX5BPyjKLavd+uGWAUPVGwMRD
         7urLR75Rk3pWtxSFn4ri24Q3xvwbWjGvDOrRR+7aPUKphQUEwepW2I8HtnEzHyfaHEhZ
         J1GQ==
X-Gm-Message-State: AOAM531i/N68uO4GxJWIx4xSb9EgtbKTiUkhL3idssKnqmnFi/3ugoMp
        JIeXRZpnGX22Iw8j34Ifz90=
X-Google-Smtp-Source: ABdhPJwJibtRzDad60HT36HN6FnIXnXcdBaU9HV0uJhnDSuilp3rwyjJsTTbCkE48vAEqp+9FbP8ZA==
X-Received: by 2002:ad4:4ee7:: with SMTP id dv7mr420732qvb.43.1606949779283;
        Wed, 02 Dec 2020 14:56:19 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id q123sm100474qke.28.2020.12.02.14.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:56:18 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 17:55:50 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 4/9] block: simplify submit_bio_checks a bit
Message-ID: <X8gbdmOWK46JTUwX@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:19PM +0100, Christoph Hellwig wrote:
> Merge a few checks for whole devices vs partitions to streamline the
> sanity checks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
