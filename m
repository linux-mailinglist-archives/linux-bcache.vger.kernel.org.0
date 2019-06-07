Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0305B38496
	for <lists+linux-bcache@lfdr.de>; Fri,  7 Jun 2019 08:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfFGGse (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 Jun 2019 02:48:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39386 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbfFGGse (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 Jun 2019 02:48:34 -0400
Received: by mail-lj1-f193.google.com with SMTP id v18so744057ljh.6
        for <linux-bcache@vger.kernel.org>; Thu, 06 Jun 2019 23:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=upBEEx7NbeguSYtJ5/7poipX6uZqA4sAsIhL/rHbbNE=;
        b=kwO+UChpxGVjtmYLf5E5cLgWa7/0DKE22kKNuv7HoKXs7uWoGNMA81tp76MkOliJIf
         gnoMKzzhPajVdEjvNi/7glL5/15ChEXRrxXa/bkb7Roummp0YX2VhDBICTIJTETqiHw4
         rkKXVQvKPynqeVUt/SbkIIhbv8hd8fUHC7RVPLBGeVNus51VrVYUN5cJT6KXRv8AHSeo
         /CNrlOVVICwT9Mc2Oq/laVDluhofAcjTip3ZU3Ydn4UfbQhArC8fz6A9CvfOXD4ICA1Q
         jDq/buJ/4NUJl48CRSfFnch4d9EkKK8E3haPcgdNHAnYf4CdSdRSTaC9r5gbB132T4Yi
         5HHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=upBEEx7NbeguSYtJ5/7poipX6uZqA4sAsIhL/rHbbNE=;
        b=k+wOCLu8P7rBafDGVMdwoeTdqLT4TmoXygegmHlNWhwF2fR1BnBbuDQTR5d5w4muUW
         xhrDEmIQXdShwI09HGLIXbKazhdWBAGcY4nEb3GB0BjGjqCI3RS3eCItXYF1w9wyabut
         8U2uY01pujpMe+LEdmvbIXccGxVj6TqnfttiTiW7uxSeUnAC8jKErfZNhTSxhO5XNRKO
         MlXdiHkGCf+Zs3QO60B/Turt0icXis6vxjuVp/jEofTZPDPvEvLNd8lJz0Pv9He+kBm0
         PcT66x5S0+PtcZmwSrycHsbjzOrD/um+KNEDZ1jEqaZDYFp9crS9VhlKwY0zhUOibVm4
         ppaw==
X-Gm-Message-State: APjAAAVCLsugpmxWCA2WYx8odYvZ2Q07k+hHYa6BsZ5yKDZw+XSVjw92
        C7ycL8/WHvCbEEM7zZXVXT+jgFYJRXs71C8CMYfj/v6A
X-Google-Smtp-Source: APXvYqxHChZWXN4nbLLdaIlwsS3l3AhiHVyrRzQOE2nszW0bIN3bnjnOIGyENY1W1NGvYPdWDDcV6nkhWqjoAolKjoY=
X-Received: by 2002:a2e:9158:: with SMTP id q24mr750517ljg.119.1559890112131;
 Thu, 06 Jun 2019 23:48:32 -0700 (PDT)
MIME-Version: 1.0
References: <114c3049bf90d8e469e49edb307b27218166bcc8.1559729340.git.xinweiwei90@gmail.com>
 <d0952414-2818-8f13-2362-be18aa511a3e@suse.de>
In-Reply-To: <d0952414-2818-8f13-2362-be18aa511a3e@suse.de>
From:   =?UTF-8?B?6Z+m5paw5Lyf?= <xinweiwei90@gmail.com>
Date:   Fri, 7 Jun 2019 14:48:21 +0800
Message-ID: <CAPiHUS4KCRMtZd0ju_kARrrB4++EBs8EAw35qhOC2FxeHc=neA@mail.gmail.com>
Subject: Re: [PATCH 1/1] bcache-tools:Add blkdiscard for cache dev
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

bcache-tools:Do a entire discard when 'bcache make' for cache devices.
If discard successfully, it will be prompted, or do nothing.

Thanks for appreciation.


Coly Li <colyli@suse.de> =E4=BA=8E2019=E5=B9=B46=E6=9C=886=E6=97=A5=E5=91=
=A8=E5=9B=9B =E4=B8=8B=E5=8D=887:42=E5=86=99=E9=81=93=EF=BC=9A
>
> On 2019/6/6 10:06 =E4=B8=8A=E5=8D=88, Xinwei Wei wrote:
> > Signed-off-by: Xinwei Wei <xinweiwei90@gmail.com>
> > ---
>
> The code looks good to me. Could you please to offer a detailed commit lo=
g ?
>
> Thanks.
>
> Coly Li
>
> >  make.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 47 insertions(+), 1 deletion(-)
> >
> > diff --git a/make.c b/make.c
> > index e5e7464..4244866 100644
> > --- a/make.c
> > +++ b/make.c
> > @@ -179,6 +179,48 @@ const char * const cache_replacement_policies[] =
=3D {
> >       NULL
> >  };
> >
> > +int blkdiscard_all(char *path, int fd)
> > +{
> > +     printf("%s blkdiscard beginning...", path);
> > +     fflush(stdout);
> > +
> > +     uint64_t end, blksize, secsize, range[2];
> > +     struct stat sb;
> > +
> > +     range[0] =3D 0;
> > +     range[1] =3D ULLONG_MAX;
> > +
> > +     if (fstat(fd, &sb) =3D=3D -1)
> > +             goto err;
> > +
> > +     if (!S_ISBLK(sb.st_mode))
> > +             goto err;
> > +
> > +     if (ioctl(fd, BLKGETSIZE64, &blksize))
> > +             goto err;
> > +
> > +     if (ioctl(fd, BLKSSZGET, &secsize))
> > +             goto err;
> > +
> > +     /* align range to the sector size */
> > +     range[0] =3D (range[0] + secsize - 1) & ~(secsize - 1);
> > +     range[1] &=3D ~(secsize - 1);
> > +
> > +     /* is the range end behind the end of the device ?*/
> > +     end =3D range[0] + range[1];
> > +     if (end < range[0] || end > blksize)
> > +             range[1] =3D blksize - range[0];
> > +
> > +     if (ioctl(fd, BLKDISCARD, &range))
> > +             goto err;
> > +
> > +     printf("done\n");
> > +     return 0;
> > +err:
> > +     printf("\r                                ");
> > +     return -1;
> > +}
> > +
> >  static void write_sb(char *dev, unsigned int block_size,
> >                       unsigned int bucket_size,
> >                       bool writeback, bool discard, bool wipe_bcache,
> > @@ -354,6 +396,10 @@ static void write_sb(char *dev, unsigned int block=
_size,
> >                      sb.nr_in_set,
> >                      sb.nr_this_dev,
> >                      sb.first_bucket);
> > +
> > +             /* Attempting to discard cache device
> > +              */
> > +             blkdiscard_all(dev, fd);
> >               putchar('\n');
> >       }
> >
> > @@ -429,7 +475,7 @@ int make_bcache(int argc, char **argv)
> >       unsigned int i, ncache_devices =3D 0, nbacking_devices =3D 0;
> >       char *cache_devices[argc];
> >       char *backing_devices[argc];
> > -     char label[SB_LABEL_SIZE];
> > +     char label[SB_LABEL_SIZE] =3D { 0 };
> >       unsigned int block_size =3D 0, bucket_size =3D 1024;
> >       int writeback =3D 0, discard =3D 0, wipe_bcache =3D 0, force =3D =
0;
> >       unsigned int cache_replacement_policy =3D 0;
> >
