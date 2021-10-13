Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC7242B67B
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Oct 2021 08:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237901AbhJMGMQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Oct 2021 02:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237875AbhJMGMO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Oct 2021 02:12:14 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA62C061749
        for <linux-bcache@vger.kernel.org>; Tue, 12 Oct 2021 23:10:12 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so1470977pjb.0
        for <linux-bcache@vger.kernel.org>; Tue, 12 Oct 2021 23:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HKDYpp4YSVsNULamooLUjhsr3ltG6/c66elTMRrkKgQ=;
        b=NoF0hG29o29DKsntYKpCXV92mD6h6EMom48z8tQzSN8FHu905ky+Xz3bE0nNtk4PY1
         0HNqwx/qtRzx7vXjuatnB9t9z2CQvezADG+ChrPjw5Rsdx9XyUR9gAFLAQnuxS6pqLaj
         euLxlv/sHfBVUNSEFnk9jxaM9RIcQ1jZpnz4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HKDYpp4YSVsNULamooLUjhsr3ltG6/c66elTMRrkKgQ=;
        b=dOVDPximxXWNHgADahZ4ZtLoMz6xALDSryxGlQsm75p56ODCx1dX6uKSDm66RZ+ta/
         5mS6eaXGTC33pRZnS7Y8EHEV7VT3Yrod0cChVfS0teGOPgXYH1i9L+JgU9q0CjpQcgQp
         MpbaURpnIbf0AIUq12xv3rwKSZTWg45VZMin0krmisz3GCPj7r9x967qG4QNG47gPluw
         frIQBUR9tq3nlT7oXPAkVSqcsb6qFDSu9oSH6+ILbKhNLaF0xvXsTNMe3l+A9245pWel
         DypQfugq0KFmty5x138673upnhY93shagbiQjQAGTkx8fA5oYAN7YcqS3uG/jl600Am3
         wUeQ==
X-Gm-Message-State: AOAM533NKRMwJ5v6fmrBzWFylsYaWgHHnqLSm4/MATe0GdnHQ2BgKVxk
        qsTBC0ETA4LExXD6ROB4cxmUow==
X-Google-Smtp-Source: ABdhPJyI6aPzBzGRPPEaJuKfUq0XfZkLrckDtvce+rfY8Gu3TkNHDTrcv1RgahLv6GETviOJpuuK3w==
X-Received: by 2002:a17:902:f691:b0:13f:2034:7613 with SMTP id l17-20020a170902f69100b0013f20347613mr24197069plg.81.1634105411698;
        Tue, 12 Oct 2021 23:10:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z24sm5259621pfr.141.2021.10.12.23.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:10:11 -0700 (PDT)
Date:   Tue, 12 Oct 2021 23:10:10 -0700
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
Subject: Re: [PATCH 03/29] dm: use bdev_nr_sectors instead of open coding it
Message-ID: <202110122310.36F4C08@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Oct 13, 2021 at 07:10:16AM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
