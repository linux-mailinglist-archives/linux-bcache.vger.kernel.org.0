Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5869179C5F
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Mar 2020 00:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388412AbgCDXZS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Mar 2020 18:25:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50338 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388553AbgCDXZR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 18:25:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583364316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p8juafuY9nBxbQdXTOkQQGLh3mRvbcDsJuPyMUd6LN0=;
        b=DRLwErAqe8D1fUBfiuE7tvDYJTQtlvPk9Sldr4Ftw1/402+lIxM9AerPWDWnmGU88J87wI
        +A5EmwwCbcs791gyFsj/jWmzejZG8afUVO7n3sEmBPZZkheCEg/wuTze/bp7N1f73zF2q7
        UkhZl8Hovr3+bff3H4ogPzVXYnNmrSg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-q3BXJlp4MWKBXkrRz9VdHA-1; Wed, 04 Mar 2020 18:25:13 -0500
X-MC-Unique: q3BXJlp4MWKBXkrRz9VdHA-1
Received: by mail-ed1-f71.google.com with SMTP id u12so2825221edb.20
        for <linux-bcache@vger.kernel.org>; Wed, 04 Mar 2020 15:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p8juafuY9nBxbQdXTOkQQGLh3mRvbcDsJuPyMUd6LN0=;
        b=GItQafCLMFQfDLLseuBQg4dFT/9wofnc+pfxVpaEHzQe/D+umvzTtRJS1k23AuJVBz
         KxHJ/rJZ2s2rxCvc1/V8AuysOG/TWEhKA5yAs33yCgFp4If2Emtf/Iz8eoTV3Hi/hDFf
         J6pFBe0lM/8dczvtF35MiG7K+4bSYLiH79Lz2FnsBENR5zR0JbH3Tn4KeyGutYmUwYoT
         +OsfGPUYf1MHzODapLq625j8VDQ8rRVskKnxi1ghH7Es3FfA+IJ2wBlwAuAC7DGHdC1f
         UyKBi0fqFYbM/OAj2rb0IeaRSPHcGxs/RJllkK90h7ukMKBOiV6s5gPBvOyjo1MFjf6p
         YNQA==
X-Gm-Message-State: ANhLgQ2ZsLqRqh3IGm7AWSRdroC1h7x8of2O/zBCt4KafHwkrZRagDkI
        8H53W72/Hrn0JfjvJi6IyMrO/rJnn+j+qlA3Zzn1LWzCvsdqyLGLaxRrOnAvUdzRk0+tHkr/Cs6
        L46OaeJxz2iF/taM9YknNWsuGck1Jx+VotJwB/Hey
X-Received: by 2002:aa7:cac4:: with SMTP id l4mr5308677edt.367.1583364311868;
        Wed, 04 Mar 2020 15:25:11 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtRn9VC83shY8XHTDzRhsN1U3qcWCfB7uMojQH5bbSmIYgKzcRcKNB9bk5ZyS5m8JegYhUQLyH/6undXUq6ODg=
X-Received: by 2002:aa7:cac4:: with SMTP id l4mr5308663edt.367.1583364311594;
 Wed, 04 Mar 2020 15:25:11 -0800 (PST)
MIME-Version: 1.0
References: <20200223165724.23816-1-mcroce@redhat.com> <CAPcyv4ijKqVhHixsp42kZL4p7uReJ67p3XoPyw5ojM-ZsOOUOg@mail.gmail.com>
In-Reply-To: <CAPcyv4ijKqVhHixsp42kZL4p7uReJ67p3XoPyw5ojM-ZsOOUOg@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Thu, 5 Mar 2020 00:24:35 +0100
Message-ID: <CAGnkfhxAHctB9MHD0LzSk8uh4tEoF-hw+iwYAEdfeY_=g3NT2A@mail.gmail.com>
Subject: Re: [PATCH] block: refactor duplicated macros
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-block@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-mmc@vger.kernel.org,
        xen-devel <xen-devel@lists.xenproject.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Anna Schumaker <anna.schumaker@netapp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Mar 4, 2020 at 9:57 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Sun, Feb 23, 2020 at 9:04 AM Matteo Croce <mcroce@redhat.com> wrote:
> >
> > The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are defined
> > several times in different flavours across the whole tree.
> > Define them just once in a common header.
> >
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > ---
> >  block/blk-lib.c                  |  2 +-
> >  drivers/block/brd.c              |  3 ---
> >  drivers/block/null_blk_main.c    |  4 ----
> >  drivers/block/zram/zram_drv.c    |  8 ++++----
> >  drivers/block/zram/zram_drv.h    |  2 --
> >  drivers/dax/super.c              |  2 +-
>
> For the dax change:
>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
>
> However...
>
> [..]
> >  include/linux/blkdev.h           |  4 ++++
> [..]
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 053ea4b51988..b3c9be6906a0 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -910,6 +910,10 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
> >  #define SECTOR_SIZE (1 << SECTOR_SHIFT)
> >  #endif
> >
> > +#define PAGE_SECTORS_SHIFT     (PAGE_SHIFT - SECTOR_SHIFT)
> > +#define PAGE_SECTORS           (1 << PAGE_SECTORS_SHIFT)
> > +#define SECTOR_MASK            (PAGE_SECTORS - 1)
> > +
>
> ...I think SECTOR_MASK is misnamed given it considers pages, and
> should probably match the polarity of PAGE_MASK, i.e.
>
> #define PAGE_SECTORS_MASK            (~(PAGE_SECTORS - 1))
>

Makes sense. I just kept the same value as in drivers/block/null_blk_main.c

-- 
Matteo Croce
per aspera ad upstream

