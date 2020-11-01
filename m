Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EA52A1FA1
	for <lists+linux-bcache@lfdr.de>; Sun,  1 Nov 2020 17:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgKAQqY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 1 Nov 2020 11:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgKAQqY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 1 Nov 2020 11:46:24 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2D1C061A48
        for <linux-bcache@vger.kernel.org>; Sun,  1 Nov 2020 08:46:24 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o3so8716476pgr.11
        for <linux-bcache@vger.kernel.org>; Sun, 01 Nov 2020 08:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZnX97cZi6Tq1d5eR74IXiOWMCb5Il9NZ1Se/Vo5HW5E=;
        b=1fh8hw1b4PtM43PjPjUPsgwnC03eOzq1D/OIFg9Z2RLVbDo9D2nclogiTHPlZ9q9gq
         rrmC+XRj9jIExjEAIOBmizVgp08ZK+1BOrKNPSsqt6PXuv87piwipBy0tmkGDLci20YZ
         JR2v8tDBzCXLzUsRIF3SNeDwpgOyDiUoBmGT/dKyCVInbDNsH3XW6LdeawRrzdGSBvi3
         mi2Zd1b281L8/5BerY1o0iDfhGaz4v1tgb6OR3HUy1joR3/yNIFriK7SN7QateperW5W
         2nQPknP0sHnoa1Z7dhknzTXPvkZP1QGclC+Qpgjo7CRH5NKu46KBXTrYpjYhzZx1X2si
         M+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZnX97cZi6Tq1d5eR74IXiOWMCb5Il9NZ1Se/Vo5HW5E=;
        b=SieVZHjDd1c9t0FjVOC6oTaxE2lSeZC56kZrNFEeifCEdrSqI9bFpg56mGJ7TnK9Y9
         kosTMlY7pa4KySyjeZmx6AYmqyFNfZOidBnO0/W7tPB8/fGxjgBO5qISHevVlJDB+RAt
         QC7feqXyr0r0zdnEe1xzK0OeTQXNETAAfNND5wOzcHVjPVGrCYc6kkViYb00pScnYLYJ
         CxJHWG5vv8chqK4K7ofGDtNnyRNg4u8iKKs+2qr7na3G+lyspkf3vpems5kA4Xk7NHhd
         OJuX83lPq814QwrJskigjdtIohkLqo6XOw/3d5YDAv4FUVNhMhHaGuHqpZClRzKYeQGx
         tr0Q==
X-Gm-Message-State: AOAM532o5fLDX5cP4xmbnUFLvpnDU5Yeir4RGg8aeG7mhy7/eHkdPJzJ
        RDFXRsubc0iME0JzQfWUfH4fpw==
X-Google-Smtp-Source: ABdhPJxTQE4+lDH2ha7od50bGb6ipTN3YldzqLbuO9m9iCrZbUFUOoR3Y6ocz+rikoLtjR5mdUiVNw==
X-Received: by 2002:a63:d74b:: with SMTP id w11mr10225608pgi.147.1604249183766;
        Sun, 01 Nov 2020 08:46:23 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t74sm1926656pfc.47.2020.11.01.08.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 08:46:23 -0800 (PST)
Subject: Re: block ioctl cleanups
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
References: <20201031085810.450489-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <877901e6-6cdb-42e9-3b32-cb8b93bfff4e@kernel.dk>
Date:   Sun, 1 Nov 2020 09:46:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201031085810.450489-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/31/20 2:57 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series has a bunch of cleanups for the block layer ioctl code.
> 
> Diffstat:
>  block/genhd.c                     |    7 ----
>  block/ioctl.c                     |   62 ++++++--------------------------------
>  drivers/block/loop.c              |    2 -
>  drivers/block/mtip32xx/mtip32xx.c |   11 +-----
>  drivers/block/pktcdvd.c           |    6 ++-
>  drivers/block/rbd.c               |   41 ++-----------------------
>  drivers/md/bcache/request.c       |    5 +--
>  drivers/md/dm.c                   |    5 ++-
>  drivers/md/md.c                   |   62 +++++++++++++++++++-------------------
>  drivers/mtd/mtd_blkdevs.c         |   28 -----------------
>  drivers/s390/block/dasd.c         |    1 
>  drivers/s390/block/dasd_int.h     |    3 +
>  drivers/s390/block/dasd_ioctl.c   |   27 +++++-----------
>  include/linux/blkdev.h            |    3 -
>  include/linux/genhd.h             |    1 
>  15 files changed, 73 insertions(+), 191 deletions(-)

Series looks good to me, apart from the mentioned mtip32xx change. If you
repost this, can you look through commit messages and titles for typos,
I spotted quite a few. If not I'll do it when applying.

-- 
Jens Axboe

