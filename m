Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E5942B741
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Oct 2021 08:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbhJMGdL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Oct 2021 02:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbhJMGdI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Oct 2021 02:33:08 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D336C061764
        for <linux-bcache@vger.kernel.org>; Tue, 12 Oct 2021 23:31:04 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y4so1151420plb.0
        for <linux-bcache@vger.kernel.org>; Tue, 12 Oct 2021 23:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IqFCee932yXff3g8S22IMIonv/32fuT5szLU0pggDNY=;
        b=a1xXRGShMNUcH1NESAktZXUgL3mFc7wQIYKmmv8/Y/ALepXHOWmmTvT8XSj6vOg/M+
         MbhM/ene3FaZLDFtmRSFfGBcWZN2IWLJwqUk7lw7SQibDKaQXujif5Kg826b1uwy92rp
         BE9pd9q6ethHDDGyjRig6Cy//vFmfRqzEgWkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IqFCee932yXff3g8S22IMIonv/32fuT5szLU0pggDNY=;
        b=wskE4VRpKJFJsnfR3IvQks/QIPRZnPLOf5niybpljRnqnFfUPf+JGh7YG3CXPwRD8T
         GAbl8AwLkKCnVAwckqbDCDSQ+oXOkDKdMdH/C1U8vWp9dbHMAQqIrVGLbJcI30owcghr
         q7Pubc8Xvu7w98fg5tC6rtiWA+V4nlv7IIwk1gyXrseiVqY1rqKHhDk61LBORd90hvEU
         pU7NWz4T1oHTtTKtYGTkEO8OhBPFHbXtzde8opaCvAOq+JwkG3pPjNnD2tapYaD8pQtN
         /xG8hIZ++MFZjX4FTu2v1CuIxkLLoN4ohDvwhp09nZOCQ4VnZWTZ4w8FBrmLDcxNnlaD
         C2DQ==
X-Gm-Message-State: AOAM531pzwOOaZfZwNX++6kNxiP8zx0wJZ4AMvk5JUMtcgmUkhybI/vK
        fvzl1HuRN4Aku4SwvQPpAKkHJw==
X-Google-Smtp-Source: ABdhPJzPpkxK9ZnBKhTayH/eUQdncp8qkTzuStqH3wv1NooRt0u8SlJ26bmKBvTPalBAv9kwTDH0GQ==
X-Received: by 2002:a17:902:f683:b0:13f:a79:52de with SMTP id l3-20020a170902f68300b0013f0a7952demr32121054plg.43.1634106664061;
        Tue, 12 Oct 2021 23:31:04 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k6sm13945349pfg.18.2021.10.12.23.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:31:03 -0700 (PDT)
Date:   Tue, 12 Oct 2021 23:31:03 -0700
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
Subject: Re: [PATCH 26/29] jfs: use sb_bdev_nr_blocks
Message-ID: <202110122331.C020EA7@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-27-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-27-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Oct 13, 2021 at 07:10:39AM +0200, Christoph Hellwig wrote:
> Use the sb_bdev_nr_blocks helper instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
