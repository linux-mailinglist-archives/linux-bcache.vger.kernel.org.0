Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA0342F75E
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Oct 2021 17:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbhJOPxZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 11:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241033AbhJOPxX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 11:53:23 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05646C06176A
        for <linux-bcache@vger.kernel.org>; Fri, 15 Oct 2021 08:51:16 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oa4so7488823pjb.2
        for <linux-bcache@vger.kernel.org>; Fri, 15 Oct 2021 08:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DZnDLe/hPV82nGDaQ9SybgeRvq4v8194pDCOmq4WnGI=;
        b=MrTzmpi6tPkZEscjT0HSiUnzPC0e0Zm+HdRKo1GnmGF9YjiSBut+2I9RhysvFrlXle
         xZfF/EyK1YxGO+4XkAzcR5rkYfkBT8c0FO8fgSH63rqxjWSjB317HZNHZiI7+NPsyO40
         1HghhomhvrKYKMicBAPPc0DZU1RkPhHGeNsOk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DZnDLe/hPV82nGDaQ9SybgeRvq4v8194pDCOmq4WnGI=;
        b=v5e8pB0IUGoxGMEm3Vv6Q64Iq1EsWP3t3aFzERRnQ5WtBWNXdJis375Xyc1HChBRJT
         fPGkgifyZ7Uo/8KEOS1xglec3k2nT+f3/cGYZ2Rx4+84NYthOyzXYN2IThXYTX6CzPy3
         3qhwpkZTwXuDS10jviXGu4GyNLm3DsSfqO4a7JqkSQAVbDENfCJzai+rqptmeRIqg6bq
         SL0cyd0dOrQRi+fJKbqyfcrmkouVx6rrhkk4X0AaFCqZkoP9PvSi3YqTFXia5A1getIy
         AHBA7NvPgWGu42DuY8OGyqPRR4h1YeeZ9aa/1ZTv7IpSETV5xHs3kDUY8p3EE35AmGIN
         GRWQ==
X-Gm-Message-State: AOAM530hsLhgUSPg3SIEmRFFAq03sMkwCCJFFrnfVQJckbhfW+8UQ3Ou
        PWCgq9X2VseVuQVCuGD/63iYJA==
X-Google-Smtp-Source: ABdhPJxDmKDta0sIDCKxrBjrXvbcujsYquDk3gV7yUWEsTdaAg5jq62C+ng3dE34jL0hht2zFj2KNw==
X-Received: by 2002:a17:90b:224e:: with SMTP id hk14mr14307733pjb.224.1634313076478;
        Fri, 15 Oct 2021 08:51:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k17sm5446139pfk.16.2021.10.15.08.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 08:51:16 -0700 (PDT)
Date:   Fri, 15 Oct 2021 08:51:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Theodore Ts'o <tytso@mit.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ntfs3@lists.linux.dev, reiserfs-devel@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH 07/30] nvmet: use bdev_nr_bytes instead of open coding it
Message-ID: <202110150851.0021855B14@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015132643.1621913-8-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Oct 15, 2021 at 03:26:20PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
