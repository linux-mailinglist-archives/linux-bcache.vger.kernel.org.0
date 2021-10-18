Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A5B432478
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 19:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhJRRSX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 13:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhJRRSW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 13:18:22 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D9DC06161C
        for <linux-bcache@vger.kernel.org>; Mon, 18 Oct 2021 10:16:11 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id i189so17202188ioa.1
        for <linux-bcache@vger.kernel.org>; Mon, 18 Oct 2021 10:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TVetvWb4+B/byEt0HFTw7Li/1VctyD/QgsPHbsid4H8=;
        b=rkRLnHg1S4u8HX11jOSUsmgOu279172YT/qIHLznH/jwI1IdjUhSA0m6I5uyrdNBJQ
         GZpTrNqHq3BbgsfYzCH0RiwOG+GG3HdSbaxtt1+taUjeE/o2nf0qjkZ23LPZL14mgyVx
         r5QceDW/MeG8za7F5qhNzSKPR2x7wRt1a8B5T995CSTZ1u9OS6Ch+FzWEBtUbHpcq9AQ
         KUlG6PBJnMhvawvbI3ONNOa5vJZRKzg+iSpti1pyNyehN+8MHnCAxM/sIrViilbzyvRG
         Q5nXCXvu4cEFPGfCltmsbNSsOl86kwWVB1XaqYHb9cyqB+54s92TMxyv7jKS0YWyf0KL
         kSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TVetvWb4+B/byEt0HFTw7Li/1VctyD/QgsPHbsid4H8=;
        b=fcWi81dKGfJUJNpl4X0TdFpjbWFNbG3nBjyTcx5PODBTwytE8gdQvB9+OfmOSvt6Oz
         elbJm/AmAmiK/nfncWWwn36ORQ5lK4j5R5Ohns3iRDW5PZvrfeNx6ghWp/7hhz8CwSr3
         3Z/+SUsT6rR9wD2qkfCMiIvGh4PPZ4x7As10RQymElhKas/06SBEldaCeo5H/aX36Z/x
         zT2y/GHVlVTkp5sfIwLeToNU1TeUEVbZK2q6inZA/mtR+wCInmfe0y6/vOpo1jiiUqk4
         MWhwLQVwnbzV+CU8oiYpBxDuHK2KjN8sxzXTrSy6Awf0+jQr1msOkC39cJh36SyWZHFT
         b/2g==
X-Gm-Message-State: AOAM532PTbCpmN6lXm7qAnl+M+mD907/E76WyJ0XsC8BTgewSn5Op7Nq
        3A7t/L9eNlLlQ3KR90wl5RmEUw==
X-Google-Smtp-Source: ABdhPJz+RKspHd19wACUssDbTNQ6NJRkN4g7OdL6jX2ni5qwlHyFbIbt1tgTl8EVs5WghyoBxus9iA==
X-Received: by 2002:a02:ac8a:: with SMTP id x10mr745552jan.43.1634577370548;
        Mon, 18 Oct 2021 10:16:10 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u12sm7081225ioc.33.2021.10.18.10.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 10:16:09 -0700 (PDT)
Subject: Re: don't use ->bd_inode to access the block device size v3
To:     Christoph Hellwig <hch@lst.de>
Cc:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Theodore Ts'o <tytso@mit.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Kees Cook <keescook@chromium.org>,
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
References: <20211018101130.1838532-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4a8c3a39-9cd3-5b2f-6d0f-a16e689755e6@kernel.dk>
Date:   Mon, 18 Oct 2021 11:16:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211018101130.1838532-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/18/21 4:11 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> various drivers currently poke directy at the block device inode, which
> is a bit of a mess.  This series cleans up the places that read the
> block device size to use the proper helpers.  I have separate patches
> for many of the other bd_inode uses, but this series is already big
> enough as-is,

This looks good to me. Followup question, as it's related - I've got a
hacky patch that caches the inode size in the bdev:

https://git.kernel.dk/cgit/linux-block/commit/?h=perf-wip&id=c754951eb7193258c35a574bd1ccccb7c4946ee4

so we don't have to dip into the inode itself for the fast path. While
it's obviously not something being proposed for inclusion right now, is
there a world in which we can make something like that work?

-- 
Jens Axboe

