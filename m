Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DC942F910
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Oct 2021 18:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241788AbhJOQ5D (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 12:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbhJOQ5D (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 12:57:03 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BAAC061762
        for <linux-bcache@vger.kernel.org>; Fri, 15 Oct 2021 09:54:56 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o133so8850176pfg.7
        for <linux-bcache@vger.kernel.org>; Fri, 15 Oct 2021 09:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SGOpzYQsZVxiJYbDiHH5De0/7WPNstxhmFZjyDhxXSM=;
        b=fs2nTqRo7F1ZHnAQpHrc4ABoCfv10ucgSRl5XyF5Dl0EU+kq5CLj40RrhqmGKfYBdE
         srWd8WSfQrAgtx4IytED1edJOCHp8619TxpM3AEsBF+FDwK3nXgnkT7wtVpp+hLrbcJ8
         Rg3NqIIsXlTg4ynBFyVvaBOq2w7XptVlu38kk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SGOpzYQsZVxiJYbDiHH5De0/7WPNstxhmFZjyDhxXSM=;
        b=aEp1cGDIouQqrRUHgn2hNKvBpF4t6xOOiObXR8xZTzI6BuuoCqK2BRrKVSfz+uGXKN
         AdSK2s3XCrqro60J1DeSX9mZUu5koMMopWeQ/bSB2YM4uSbfgS4IeSIkm8xq79rLEfwb
         LjjUEu+nkBD/3MquVDuuDEldZ89bKrEM0UwFpQiTUjPqY2xbxzTGxlOm9thge15AhVmF
         nRXhrTJyy5FZqYfxQY/T4IYQKiw5cQdO6K6nCLKBpYjPkm654CLW0V2O/HEJU/afbKSx
         hC2U8egdMTvfc4fWhhj3rxIdMiXOM42S03qIu4GmZKolUPv7mh6WC2i+CjtTm2QVmmdH
         Cq8A==
X-Gm-Message-State: AOAM530TEReOJOSU7wB/H+d6YiIfCJ/kqfOcBI04kau7wmzN95X7cZQ3
        Pg+QBHc1vADl19OJq/BKNPHyGA==
X-Google-Smtp-Source: ABdhPJyWeQQaxN3OVR9dpjDI7bcixMoFds0uTAEJpzN0+vwQj4qrWqnY4m/W/UbgYRyhJ3miirXMyQ==
X-Received: by 2002:a62:1596:0:b0:44c:f7b3:df74 with SMTP id 144-20020a621596000000b0044cf7b3df74mr12889236pfv.60.1634316896184;
        Fri, 15 Oct 2021 09:54:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h3sm6042497pfv.166.2021.10.15.09.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:54:55 -0700 (PDT)
Date:   Fri, 15 Oct 2021 09:54:55 -0700
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
        ntfs3@lists.linux.dev, reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 20/30] ntfs3: use bdev_nr_bytes instead of open coding it
Message-ID: <202110150954.FE37F8CF00@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-21-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015132643.1621913-21-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Oct 15, 2021 at 03:26:33PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
