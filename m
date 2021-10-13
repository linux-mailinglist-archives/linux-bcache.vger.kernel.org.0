Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEE742B6E0
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Oct 2021 08:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbhJMGS5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Oct 2021 02:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbhJMGS4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Oct 2021 02:18:56 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF109C061762
        for <linux-bcache@vger.kernel.org>; Tue, 12 Oct 2021 23:16:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so3602082pjb.5
        for <linux-bcache@vger.kernel.org>; Tue, 12 Oct 2021 23:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vr2Ti0XXPw/GzVjOiY0OfTomtbZYRULNYJUDEzmrzO4=;
        b=K4nvDpNl1g5m539wsQDBpCbf3zo170v/GW6ZnHLXNDrULUU4yYZgBZyGAb+wBnnkpe
         Kw4TilugsMOouo/bETIRMTNNbwFs2By6YycSQiwP6WhM+z5A0iE/rlwHD7YheTZVwxWg
         UujJ8p17bj864LNgI93in3n9RRNxotwxYx6iE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vr2Ti0XXPw/GzVjOiY0OfTomtbZYRULNYJUDEzmrzO4=;
        b=U8/4zL20eNXlsbuMAUC68nm40ehKMnJ4Crx4ozN8LESfvraOq0+oa7rCdrf8bR187l
         mieMG54w8fdI04A8GBtTVb418Co6eWcXDq+PCrGS0ew+YlK3OXKd6a9PiSYpkfvZEQex
         IGNVBK0Gh3Q3OjO85zG9PxEn+tm26NkWLxFJqRk5UjxSutNzhLARecNJ0R1xOu6z2wdf
         iSus9nd+iBpJNyT5WtDd+eOrjJnn4A4NfwGFjo5+aZFwk6h+5s4LqrFSWTsXpPv6vFcH
         pOHieaZKm2V3KLWVTD1tKXksR+yF54dLdGLrOKGl5FCOA3gUOzyqsty6AMwhbdqa3+qm
         ImxQ==
X-Gm-Message-State: AOAM531RXLFEDqsq33aSI8Kb7ATAF/12L2ac9MrSkeNHIC4W4YRp5UI5
        ZS6dcS4r4jL2/9GyoTw4Qv4pZA==
X-Google-Smtp-Source: ABdhPJyviIqYDhsPW2xustTPT0ttTkhiIBbQskiTA4bVnp1eNaDrTHxU5FKFz1farm1RVUHRoFmswQ==
X-Received: by 2002:a17:90b:1c8f:: with SMTP id oo15mr11110082pjb.169.1634105812260;
        Tue, 12 Oct 2021 23:16:52 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c64sm7486893pga.40.2021.10.12.23.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:16:51 -0700 (PDT)
Date:   Tue, 12 Oct 2021 23:16:51 -0700
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
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev,
        reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 15/29] hfsplus: use bdev_nr_sectors instead of open
 coding it
Message-ID: <202110122316.9C54C2F@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-16-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Oct 13, 2021 at 07:10:28AM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
