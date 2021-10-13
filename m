Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E923042C6A1
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Oct 2021 18:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhJMQpY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Oct 2021 12:45:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234362AbhJMQpT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Oct 2021 12:45:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634143396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DvE9A+LL2XADoLsMv/QT6HGglilUC7cXAXtJNsfa8lA=;
        b=NAAmVX5xZ/MTBoX3T366suuX7U6AMsUkZlm62t2Euqx5I3UirGU1N07GQz1grT+Bbj+Pq2
        niCIGm1dZF2Qw94nhUd/rljT+i9U1Wqqj0IIIOhtU4IRVhjYqzH92joKN4RVxaMw4Q/Wss
        ODHzfUEHYYRmJigUY5WCl2lnsHuj4Tc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-1wZisTb3O_i-Ru5DPpesqA-1; Wed, 13 Oct 2021 12:43:14 -0400
X-MC-Unique: 1wZisTb3O_i-Ru5DPpesqA-1
Received: by mail-qt1-f199.google.com with SMTP id y25-20020ac87059000000b002a71d24c242so2575968qtm.0
        for <linux-bcache@vger.kernel.org>; Wed, 13 Oct 2021 09:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DvE9A+LL2XADoLsMv/QT6HGglilUC7cXAXtJNsfa8lA=;
        b=PgqRDCif5Bnm2vEm4ZEYilIf0dHcD3nrKBTXuB8VdMdQtI1r1KkU7J/jYjZSC0wjiA
         +pykdBhbimny6WpJJY4EJJmtN9czfpLQ6jsaNhZX47/5rNm7iAwEzXM0cUQwF5byuGAb
         UkkkmYsBrmwAMsfraidiFtW6PbZISdWuqgAdnRy1pFKz/o2ePhjR6m2ANYftgzckGUxQ
         yUwO/OKcosi34d4QbCd6gmtYWRHONUU77+LgGbweM5bum0cItN/SBX2Bt7dLH67yvzE2
         KGrrEiwuYAl6EH3LgIz9NWncugPyqEAOOlOHXgRANhbGI2vWsYwlsBNDfRj2HYRysOTS
         Kb6w==
X-Gm-Message-State: AOAM533WCdgjlBxs3+fu8e11kTwxN7TmCdg0tpv/nlSpVHgGs0w4a/o1
        d8uvrMXzNvWalIXdNgfMA/JoOf4DoJR2msW/J3dMZPWm+vQ23Y7rS/s7oX9upuN/1llXL8J63dm
        r9IXmhu26kROSLrDgzMcrzS0=
X-Received: by 2002:ac8:7d02:: with SMTP id g2mr450214qtb.66.1634143393834;
        Wed, 13 Oct 2021 09:43:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4uQGBl82DdkygPL4oygkwPDtljuRYBV8+ESqW4tKnOahM7pZ+SYljUTQ3BKpa4FdVi33PjA==
X-Received: by 2002:ac8:7d02:: with SMTP id g2mr450159qtb.66.1634143393507;
        Wed, 13 Oct 2021 09:43:13 -0700 (PDT)
Received: from localhost ([45.130.83.141])
        by smtp.gmail.com with ESMTPSA id q14sm77870qtl.73.2021.10.13.09.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:43:13 -0700 (PDT)
Date:   Wed, 13 Oct 2021 12:43:12 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Theodore Ts'o <tytso@mit.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Kees Cook <keescook@chromium.org>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev,
        reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 03/29] dm: use bdev_nr_sectors instead of open coding it
Message-ID: <YWcMoCZxfpUzKZQ+@redhat.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Oct 13 2021 at  1:10P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>

