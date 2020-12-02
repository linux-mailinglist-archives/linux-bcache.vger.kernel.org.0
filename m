Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121432CCA4D
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 00:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgLBXKK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 18:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729059AbgLBXKK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 18:10:10 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E53C0613D6;
        Wed,  2 Dec 2020 15:09:24 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id z188so428013qke.9;
        Wed, 02 Dec 2020 15:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UrdtiO/QrBY20Yi4TmEbqEfbQLVKUAJywZnSXTzypgw=;
        b=UYdiNR8na4RvenpR2Mn1pCHS9jYgwpJstcT/qZ5NaTUerG3IB55Hq4xLNgZ9sH3iQ1
         broGAb0oswPjiMLWgPYjBT76qcMsOOhupxTCUdBbAvlIG7tcLR1JUdVLiZtXFgdrpIk4
         rYPBf5BC9nRQZftAS4IdeOShqvXZnsCFXaKoNLXocYUa7RLS55MUBkZiEBspNkJk/h6Y
         vjvLxYt90R6lzEFxw1KoFzyTj/idh7LkqX07aKjTr332smwT80pnaQ/17JlVpHSH++zO
         PqN2TqczEy48JKPRo7OIriCWqRvo7pDYU5fSis6fkGzM2Vn5OnOQyEK65JBiAigKINc8
         XEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=UrdtiO/QrBY20Yi4TmEbqEfbQLVKUAJywZnSXTzypgw=;
        b=AOVTd0Z4AIbgITkVwiQ/3UMUfnCAGfsw1tkRpk2LHKOrpzOMmK4MeuMBmy67ybUbnG
         MG9zbjJg11G0Q8Suu+vjuIhoAcHav2QvQJTRot43D5JiDd3I8G3KrnnUsC7wh3cgoyOs
         /eOJyY7NVlYYsryADwNvOaGpIR2c4ubFlC7gr2mIXAMWQwUyFB1f/Q2WEl+DKij8jGP+
         RS7pGggqxezH6ZeeIf+ljwcYk6XyH+9s0Co7zSBWT7HzLp2O0tdXjkbhjERCgIJjhfxI
         xEIBiYehIbg9Yt6qSnKbK+AS9vpGBvRlZbjs276Mhfw8GR6tjh7r9V0WzxD/3zIep11Z
         2bEA==
X-Gm-Message-State: AOAM5319pEPHnkzjP4h0T7xHfKF4MP5WhOi7+kdPMkEshb9rCn4kuo2w
        6ze15KaQlkraO8anoV5dn9OH5VF7uU44Og==
X-Google-Smtp-Source: ABdhPJzqmlQiVDw6RKd2+jPOUsHCqhHzIKWhKxr7ZTfOl1seoWS7W/a/BZr7JZODJGPZBbBxPoV4zw==
X-Received: by 2002:ae9:de03:: with SMTP id s3mr134212qkf.218.1606950563515;
        Wed, 02 Dec 2020 15:09:23 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id v204sm155597qka.4.2020.12.02.15.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 15:09:22 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 18:08:54 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 7/9] block: add a disk_uevent helper
Message-ID: <X8gehr+JRCz8w4xt@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-8-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:22PM +0100, Christoph Hellwig wrote:
> Add a helper to call kobject_uevent for the disk and all partitions, and
> unexport the disk_part_iter_* helpers that are now only used in the core
> block code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
