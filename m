Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2C9146F76
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Jan 2020 18:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgAWRUc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 23 Jan 2020 12:20:32 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41042 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgAWRUc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:20:32 -0500
Received: by mail-ed1-f68.google.com with SMTP id c26so4080505eds.8
        for <linux-bcache@vger.kernel.org>; Thu, 23 Jan 2020 09:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lyle-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6+vNbb4B/0sSFyFJSC8qTaKMeb1MRUXRnISXV/exbkE=;
        b=R+Rg4suNYIxYpIipdm4HoY9YSJHHPquogFhVnX+Gs01z4f3zumINx+eV5JZADGcwSt
         EygB778MYN6jVX/NBUWZxo5UXuOL7wcE2URInuZrssI3q2DQcQNQoHtUO7jr+XfCmnOI
         sOcCJVrqg7sQ4Fpd8L+xljtbL4uz/MxoXizeh3pNfDg8YJGyvnVP2vcPACgZ3rWDj4Ix
         QAEKWJgJEFfbPy2zt9OBBposLV6alsIQRqjzDqrTphq1KJevsp6qZuZjay759Yyf4P9k
         2QLyrUe+0ZvWsTrHOFhiwOGP2Ty1zATeV5rxZvv1V9k4BtQj8xodFY/7TJZbcv6t2OXO
         fZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6+vNbb4B/0sSFyFJSC8qTaKMeb1MRUXRnISXV/exbkE=;
        b=Z9DZmXhyKFB6ovFtPh+MijKf/XFTkZEvJ2bZKLYMniPJUnWQRV3WCX6Skh94UauX01
         g8z34Q7LUbMucjCqdvZSbFDzFFtVd/ypOkAAjc1sRvd4H4iW1+wilr8LiB1S6sa43eh2
         358D4yxlKD2nVcm9517Z5MwPtu/9XRjQdk+kO8iRDUz0yRfQJhFaXKvczjYsere72Xbr
         9xn/81EkwRcJpVwGHB92fETia2V/+bI5q4onVW8/iCBUEJ5W5NazReBz8YJDbMGr1k2M
         M1PXTTY7iovx7F70Lu1xvhX3+AhkHpHmUAFJGF5rtQVLvPSlcmwXJiJeDLaxkGUFytQT
         3rcQ==
X-Gm-Message-State: APjAAAXbFowpAN4GhzfaJwShCmj18gMA25wOJVhAJt8yoDFE+z31UMZx
        4uuViRihgHAnmHVtm9YTpgoBS0MsEF+GT3qPdaUIJA==
X-Google-Smtp-Source: APXvYqyFEP6AIOMjEXh1ED3DZy0t2JdN8FSZhBcCwGil9FkQFDEEb+kxCC+mAT44TIbR5MvnkAkKXLjDFBXTd80juRI=
X-Received: by 2002:aa7:ce87:: with SMTP id y7mr7969076edv.82.1579800029952;
 Thu, 23 Jan 2020 09:20:29 -0800 (PST)
MIME-Version: 1.0
References: <20200123170142.98974-1-colyli@suse.de> <20200123170142.98974-15-colyli@suse.de>
In-Reply-To: <20200123170142.98974-15-colyli@suse.de>
From:   Michael Lyle <mlyle@lyle.org>
Date:   Thu, 23 Jan 2020 09:19:50 -0800
Message-ID: <CAJ+L6qckUd+Kw8_jKov0dNnSiGxxvXSgc=2dPai+1ANaEdfWPQ@mail.gmail.com>
Subject: Re: [PATCH 14/17] bcache: back to cache all readahead I/Os
To:     Coly Li <colyli@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        linux-block@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly and Jens--

One concern I have with this is that it's going to wear out
limited-lifetime SSDs a -lot- faster.  Was any thought given to making
this a tunable instead of just changing the behavior?  Even if we have
an anecdote or two that it seems to have increased performance for
some workloads, I don't expect it will have increased performance in
general and it may even be costly for some workloads (it all comes
down to what is more useful in the cache-- somewhat-recently readahead
data, or the data that it is displacing).

Regards,

Mike


On Thu, Jan 23, 2020 at 9:03 AM <colyli@suse.de> wrote:
>
> From: Coly Li <colyli@suse.de>
>
> In year 2007 high performance SSD was still expensive, in order to
> save more space for real workload or meta data, the readahead I/Os
> for non-meta data was bypassed and not cached on SSD.
>
> In now days, SSD price drops a lot and people can find larger size
> SSD with more comfortable price. It is unncessary to bypass normal
> readahead I/Os to save SSD space for now.
>
> This patch removes the code which checks REQ_RAHEAD tag of bio in
> check_should_bypass(), then all readahead I/Os will be cached on SSD.
>
> NOTE: this patch still keeps the checking of "REQ_META|REQ_PRIO" in
> should_writeback(), because we still want to cache meta data I/Os
> even they are asynchronized.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Coly Li <colyli@suse.de>
> Acked-by: Eric Wheeler <bcache@linux.ewheeler.net>
> ---
>  drivers/md/bcache/request.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 73478a91a342..acc07c4f27ae 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -378,15 +378,6 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>              op_is_write(bio_op(bio))))
>                 goto skip;
>
> -       /*
> -        * Flag for bypass if the IO is for read-ahead or background,
> -        * unless the read-ahead request is for metadata
> -        * (eg, for gfs2 or xfs).
> -        */
> -       if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
> -           !(bio->bi_opf & (REQ_META|REQ_PRIO)))
> -               goto skip;
> -
>         if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
>             bio_sectors(bio) & (c->sb.block_size - 1)) {
>                 pr_debug("skipping unaligned io");
> --
> 2.16.4
>
