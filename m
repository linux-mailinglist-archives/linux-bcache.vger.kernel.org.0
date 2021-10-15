Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D922242F788
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Oct 2021 18:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbhJOQCY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 12:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhJOQCX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 12:02:23 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335CDC061762
        for <linux-bcache@vger.kernel.org>; Fri, 15 Oct 2021 09:00:17 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w14so6674960pll.2
        for <linux-bcache@vger.kernel.org>; Fri, 15 Oct 2021 09:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oA+XtrVpatY111qi9rW+eMi2Ccu5JD4bZ/9KhM3WrlE=;
        b=XqIRk8njJo5f/smXtBnMnpa5uhREVTwoyHge7bthfJu3PV1eAY0raWnd7H8TUnbAlP
         6QJTXqryNMqTNsEzDWj/azKOg0JWIJXEUmyPhlYenUOsueW8KFdrQGT7L/i4Eg4OiZnx
         gS2Q2/7koaDEtdkJVEfY5BHTSx0EojKPtQeUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oA+XtrVpatY111qi9rW+eMi2Ccu5JD4bZ/9KhM3WrlE=;
        b=NG2m/bxGUFnJ3yhpwO6i1yHgn1AA9hO6GnP2VYZ46IEyjsn4tsXNrgBZiwzko5e3tH
         WLL55RmXR+BiLFgIOeiZopcFm0hu81/4fcRI10d73UZ51RuR9SQD2K29DGXSiJDnPvgn
         v8MI44mccICJInIBCeE1KydDvy5B5hQO+Sfa5yy9lIP6Q7tkU+nxrJyZC/AuYHkREi/K
         9ap3GU8PpOtJpg8YM9dNNv52JdwCHKjHRUBuWhO8yz4nfncWF21dWVCmnDdt+wxG/wLH
         OdOWRa1V0XhEA0ARVzHt6Cc2SaJ8nQfQCO9R6cypiAlzQSXQyg9m+o2cazB2c5MC9IxL
         p8UA==
X-Gm-Message-State: AOAM532G8OX5PszPTd+Eys0G4IpkrY2m+z5z2tTNJqvunI+8dZpjsY/D
        GPj8jfrZHfnJBNAPAigHMPTb9g==
X-Google-Smtp-Source: ABdhPJzKtqYe4vRxUad2HzrB2swbKAK83Cb9s6XXYIsx2Jq5whQZG4n13YyVL1QUtSJ6rA0qtwQqhQ==
X-Received: by 2002:a17:90a:a386:: with SMTP id x6mr14380761pjp.56.1634313616631;
        Fri, 15 Oct 2021 09:00:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id nn14sm5397718pjb.27.2021.10.15.09.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:00:16 -0700 (PDT)
Date:   Fri, 15 Oct 2021 09:00:15 -0700
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
        Jan Kara <jack@suse.cz>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH 09/30] fs: use bdev_nr_bytes instead of open coding it in
 blkdev_max_block
Message-ID: <202110150900.71DDE55E1B@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015132643.1621913-10-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Oct 15, 2021 at 03:26:22PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
