Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E666A114FB4
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 12:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfLFLXF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 06:23:05 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:46927 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfLFLXF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 06:23:05 -0500
Received: by mail-qv1-f66.google.com with SMTP id t9so2490054qvh.13;
        Fri, 06 Dec 2019 03:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pOhKmAov83NEpUrSVxB3iFgGYBsUzEH1/Lh5GTALM+8=;
        b=KkHILgWEHIIY8JOjsTg5lfQAXMDItQdflJm/kpm8HYPJPinza5UphWlqljLveS0E7U
         dDDebIjlm/SE5RU97IvLEXPcwiFv/PJOfE8HVLfA8EIY5N2Z1Gz6ECTaz/usfX3kt6yr
         VT1KyNeZUtMoXaZXmtDz9GCuePoi///ZBvBSF1vTlY8mIkhDASH0fm8hE3AvFE8JkVPn
         rAWbeiPfEsEFWI02QHKVr1cvnCHxrtPu9hOscowFnUhFi9k+odQYGEyWk/qDxNOLDHGP
         Ra7t9JCjVrBewMs1L/DbZdbWBmD1nR6H/quVPMChZQeRS4H5Z76G72ytskWusliPrrN4
         vqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pOhKmAov83NEpUrSVxB3iFgGYBsUzEH1/Lh5GTALM+8=;
        b=VxeXbCFPvaLiHPykmIjNmN2zke6YuRXwwrgquxuZ8Qu6KdgaQdJmXBJpRERWKmzzWb
         KElpTvNaicpW58Xw+1bSegyxi8zT0h88DR1epzSDzLvcDido6iW/fM60qly1dOQclxIY
         FU2Vu/8BAd2GoHVTQ2SEDHMmT4qNVaRE34t6rB0CITs01PAt3PQGBdVEdSxmqG3/rTgW
         j3NDjof3gl22pikq7dtKltdjkTMSxIosrXiDFq60bs0Dj+NkqphLlRLWNp3EkIYR2IkD
         j4hXh8e4owx0+kAyMdXvvCX339GgH7yNCpMIHHrA9IWMhPPhFDhUkHmCjkYPIt6/Ld4w
         whtQ==
X-Gm-Message-State: APjAAAW3RVvbUI6eDPa/KXzpJ7Ikh/LjYUmNvwFaPudLa0ZPBhuHlkhX
        j58L/oVmqrAk9lI4Ash1g3cUY5G1PzotaYpGBW0=
X-Google-Smtp-Source: APXvYqz+Cktvq5GfTyOtslWy2Az/k+VBSl45XPo0+ngZlbdrIsCsquMUB4m+F0mwMPYUuf4hz5rZ6SYtrQ7y6BFf0zE=
X-Received: by 2002:a0c:f8c7:: with SMTP id h7mr11748652qvo.209.1575631384003;
 Fri, 06 Dec 2019 03:23:04 -0800 (PST)
MIME-Version: 1.0
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com> <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
In-Reply-To: <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
From:   Liang C <liangchen.linux@gmail.com>
Date:   Fri, 6 Dec 2019 19:22:52 +0800
Message-ID: <CAKhg4tLfZ8Gud7zFxkkVzn6uDwLYNZerxjGsdB=N9qDj4mwKFg@mail.gmail.com>
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Sure. will do in a follow up patch.

On Fri, Dec 6, 2019 at 5:44 PM Coly Li <colyli@suse.de> wrote:
>
> On 2019/12/6 4:55 =E4=B8=8B=E5=8D=88, Liang Chen wrote:
> > __write_super assumes super block data starts at offset 0 of the page
> > read in with __bread from read_super, which is not true when page size
> > is not 4k. We encountered the issue on system with 64K page size - comm=
only
> >  seen on aarch64 architecture.
> >
> > Instead of making any assumption on the offset of the data within the p=
age,
> > this patch calls __bread again to locate the data. That should not intr=
oduce
> > an extra io since the page has been held when it's read in from read_su=
per,
> > and __write_super is not on performance critical code path.
> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
>
> In general the patch is good for me. Just two minor requests I add them
> in line the email.
>
> Thanks.
>
> > ---
> >  drivers/md/bcache/super.c | 32 +++++++++++++++++++++++++++-----
> >  1 file changed, 27 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index a573ce1d85aa..a39450c9bc34 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -207,15 +207,27 @@ static void write_bdev_super_endio(struct bio *bi=
o)
> >       closure_put(&dc->sb_write);
> >  }
> >
> > -static void __write_super(struct cache_sb *sb, struct bio *bio)
> > +static int __write_super(struct cache_sb *sb, struct bio *bio,
> > +                      struct block_device *bdev)
> >  {
> > -     struct cache_sb *out =3D page_address(bio_first_page_all(bio));
> > +     struct cache_sb *out;
> >       unsigned int i;
> > +     struct buffer_head *bh;
> > +
> > +     /*
> > +      * The page is held since read_super, this __bread * should not
> > +      * cause an extra io read.
> > +      */
> > +     bh =3D __bread(bdev, 1, SB_SIZE);
> > +     if (!bh)
> > +             goto out_bh;
> > +
> > +     out =3D (struct cache_sb *) bh->b_data;
>
> This is quite tricky here. Could you please to move this code piece into
> an inline function and add code comments to explain why a read is
> necessary for a write.
>
>
> >
> >       bio->bi_iter.bi_sector  =3D SB_SECTOR;
> >       bio->bi_iter.bi_size    =3D SB_SIZE;
> >       bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC|REQ_META);
> > -     bch_bio_map(bio, NULL);
> > +     bch_bio_map(bio, bh->b_data);
> >
> >       out->offset             =3D cpu_to_le64(sb->offset);
> >       out->version            =3D cpu_to_le64(sb->version);
> > @@ -239,7 +251,14 @@ static void __write_super(struct cache_sb *sb, str=
uct bio *bio)
> >       pr_debug("ver %llu, flags %llu, seq %llu",
> >                sb->version, sb->flags, sb->seq);
> >
> > +     /* The page will still be held without this bh.*/
> > +     put_bh(bh);
> >       submit_bio(bio);
> > +     return 0;
> > +
> > +out_bh:
> > +     pr_err("Couldn't read super block, __write_super failed");
> > +     return -1;
> >  }
> >
> >  static void bch_write_bdev_super_unlock(struct closure *cl)
> > @@ -264,7 +283,8 @@ void bch_write_bdev_super(struct cached_dev *dc, st=
ruct closure *parent)
> >
> >       closure_get(cl);
> >       /* I/O request sent to backing device */
> > -     __write_super(&dc->sb, bio);
> > +     if(__write_super(&dc->sb, bio, dc->bdev))
> > +             closure_put(cl);
> >
> >       closure_return_with_destructor(cl, bch_write_bdev_super_unlock);
> >  }
> > @@ -312,7 +332,9 @@ void bcache_write_super(struct cache_set *c)
> >               bio->bi_private =3D ca;
> >
> >               closure_get(cl);
> > -             __write_super(&ca->sb, bio);
> > +             if(__write_super(&ca->sb, bio, ca->bdev))
>
> And here, please add code comments for why closure_put() is necessary her=
e.
>
> > +                     closure_put(cl);
> > +
> >       }
> >
> >       closure_return_with_destructor(cl, bcache_write_super_unlock);
> >
>
>
> --
>
> Coly Li
