Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82590ED686
	for <lists+linux-bcache@lfdr.de>; Mon,  4 Nov 2019 01:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbfKDABg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 3 Nov 2019 19:01:36 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46628 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbfKDABg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 3 Nov 2019 19:01:36 -0500
Received: by mail-wr1-f66.google.com with SMTP id b3so9299584wrs.13;
        Sun, 03 Nov 2019 16:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ibFoZeifJUQ7lgAv28G3F1HlvVxda0K2Z+MbSSClwCQ=;
        b=jtXa7BIRxUpQQtVOXU3mZrjTh2kCbxNjEBA6xltbDf9yx8g2cuEPI/qaNuXcY6gbkk
         Bt4efoK/wxNnQv/SVYCEHkO3zB5E9Rx1uJ/4g0RzHja0gn6oECQfIa446lJPdPxaFvei
         JvoNmEaoaHk3JldIg5shYe6+Gnn3vsGTLLfvEGaTIufu8fZt9/3E43Y0WUyeLDlcIU6C
         VmimdOj3SesbF86R5YeugqvxmoAB9l4I6GZANv+d6eM2oHNfKrRYjOeRi+vAPc2eE4gq
         NnyI5Nz4kG5hdTuFnLhpXfMdIB0eBZN/bC3O27Pz+IUYfNOYPdYKyVJnpBe9EMyLrL6U
         bh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ibFoZeifJUQ7lgAv28G3F1HlvVxda0K2Z+MbSSClwCQ=;
        b=q8fGQkeBJMMjtTiq8k0UJVsp/hYzhu2BeFWegiLOUlR5ArdYbcTPr4rD2DUwqaT00x
         oh2ITUtUcWcj1pZaa6g4sRmFcJLPBLILXeozsXHn4J7Nj68oXqH2Ec4K2uPfpJMFMlJp
         YdK4T80MXk6DqqO8yYIuKhLwK9UQgkQNUpB84ZPNKe3ksZMXlonruQbzQ+Yx3TQ0zdIC
         3cUGEt8eCoZ1xFi7aSzGz15yYuiOzv2pTs10VnGrkHD5lN09wsxq3gdRNi/iZ6i8I+P4
         D7e4sDXJKTWqzzDnX4o0X8lxenqtvlgv+GlcTBlHrLMn5XLPwvqB4cQdJyP8WPk/BmFF
         zhHg==
X-Gm-Message-State: APjAAAXDxV3qeVDGpatMitGFJD/saui+RK/2+0dPvJvF5lFKsZzygGZQ
        oZ8reJvchnm2UQQaTlO2hGofTES/W4rtO68ang0=
X-Google-Smtp-Source: APXvYqyJZIfaDQqAm1R+H/IHhZ7D2kay3Yg1kX0rGsqjDo1xNrt9QeTFZfTc4/jVmj4hsYsK6XWTZi2+WUlkHcBrqMA=
X-Received: by 2002:a5d:4c83:: with SMTP id z3mr20937416wrs.92.1572825694157;
 Sun, 03 Nov 2019 16:01:34 -0800 (PST)
MIME-Version: 1.0
References: <20191102072911.24817-1-ming.lei@redhat.com> <606b9117-1fb6-780b-8fb1-001c06768a2e@kernel.dk>
 <36786e85-fd19-0631-4acf-c9bf9468d4e1@kernel.dk>
In-Reply-To: <36786e85-fd19-0631-4acf-c9bf9468d4e1@kernel.dk>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Mon, 4 Nov 2019 08:01:22 +0800
Message-ID: <CACVXFVNc8Prck1Bq+wgUb5OmAzPc6+q8V+kGL=vEgcAehqw3vw@mail.gmail.com>
Subject: Re: [PATCH V4] block: optimize for small block size IO
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>,
        linux-block <linux-block@vger.kernel.org>,
        Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <kbusch@kernel.org>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Nov 2, 2019 at 11:58 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/2/19 8:03 AM, Jens Axboe wrote:
> > On 11/2/19 1:29 AM, Ming Lei wrote:
> >> __blk_queue_split() may be a bit heavy for small block size(such as
> >> 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
> >> multiple page. And only consider to try splitting this bio in case
> >> that the multiple page flag is set.
> >>
> >> ~3% - 5% IOPS improvement can be observed on io_uring test over
> >> null_blk(MQ), and the io_uring test code is from fio/t/io_uring.c
> >>
> >> bch_bio_map() should be the only one which doesn't use bio_add_page(),
> >> so force to mark bio built via bch_bio_map() as MULTI_PAGE.
> >>
> >> RAID5 has similar usage too, however the bio is really single-page bio,
> >> so not necessary to handle it.
> >
> > Thanks Ming, applied.
>
> Actually, I took a closer look at this. I thought the BIO_MAP_USER
> overload would be ok, but that seems potentially fragile and so does
> the fact that we need to now maintain an extra state for multipage.
> Any serious objections to just doing the somewhat hacky bio->bi_vcnt
> check? With a comment I think that's more acceptable, and it doesn't
> rely on maintaining extra state. Particularly the latter is a big
> win, imho.

I am fine with checking bio->bi_vcnt with comment.

Thanks,
Ming Lei
