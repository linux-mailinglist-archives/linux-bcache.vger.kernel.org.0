Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4956D2110D4
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 18:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732449AbgGAQiR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 12:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgGAQiQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 12:38:16 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CA3C08C5C1;
        Wed,  1 Jul 2020 09:38:16 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id t11so9223826qvk.1;
        Wed, 01 Jul 2020 09:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tnWfjqu9qwTdD4KnQK/3+SjWTBx9SJibvmRRCZ2MKpw=;
        b=U026WByv7++7/w1+Nu+RBzmT42CWmL089oP2jZPE4GfX8trhuMpatdvHRasGwxl1tp
         esIRMJhHnW5uCzGbrrP5CE9k4nW7c65rE4KRI9NkWii4E6mEPbKGBXdTFeEP0b5/X8j1
         RKDZhhs7eEWkZ9yrTYjSzyRQuzgfxSGkKewuCj72VWynBsVS+2Ska24TaCYNSUtYNx0h
         tkr380dMygtpbEq4afb+a4dCf6bAwClROx8TUXDVt1XYAVILF8ZQdXine5RK1wrhdCLx
         lurHJt08cKi6hQMnrm0IC1VIZZ5Da6Y0NgMH3p1I2KbSxRTE3WPzEilFi6RtD7avMeW2
         +K0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tnWfjqu9qwTdD4KnQK/3+SjWTBx9SJibvmRRCZ2MKpw=;
        b=K3fSWa0Ce8fQw1eYj9WLiAfw3wULKCQ2gMPbsZhEHwtd29+I/qJTqjBqbIW1nIaepe
         cSubrkYY+bDbXMdxQxYD4dh09KJLuE8LVz4hr9ZxzwC9M2vc3Qr8IQommNO5bzMIXUMm
         qXbZOc3toByQalPEs8XRBITHtctNJYWfH1bC4uSZGztnCrW5jiS3p5JNOl1JL/MmhC90
         t8qtBiPPjzpq4XtopI0dmgnaX0vTOrNVjWnLCU0jTbevetynrbtjP84di2y6RgU4krBg
         Us0ZgXH+XkPbEOUC14aAzA+/mwb6zNSdB97HjI8qLPVIA+yTxVvJ0JkNHFqBUgYsd9Vp
         aiwA==
X-Gm-Message-State: AOAM532fmwerP9g6efsS8ZAopd3HdJExAtAkFi0cztnEAekytZe1/CZl
        oLfxqX+30B1m9mVKCwpdig3k+GzgEh4=
X-Google-Smtp-Source: ABdhPJzfqJE8PIES5DnR2PTCVTamwJmruYSeMWZpKr4HJeNZUuy5RzchyjxSpfzGXXbaj1X8ONNd6g==
X-Received: by 2002:a05:6214:10e1:: with SMTP id q1mr24708355qvt.78.1593621495518;
        Wed, 01 Jul 2020 09:38:15 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:f839])
        by smtp.gmail.com with ESMTPSA id u1sm5792798qkf.49.2020.07.01.09.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:38:14 -0700 (PDT)
Date:   Wed, 1 Jul 2020 12:38:13 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: remove dead bdi congestion leftovers
Message-ID: <20200701163813.GA5046@mtj.thefacebook.com>
References: <20200701090622.3354860-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701090622.3354860-1-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jul 01, 2020 at 11:06:18AM +0200, Christoph Hellwig wrote:
> Hi Jens,
> 
> we have a lot of bdi congestion related code that is left around without
> any use.  This series removes it in preparation of sorting out the bdi
> lifetime rules properly.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks a lot for killing the dead code.

-- 
tejun
