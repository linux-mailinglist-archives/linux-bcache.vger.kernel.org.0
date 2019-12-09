Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA37116ADE
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Dec 2019 11:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLIKVU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 05:21:20 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39052 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfLIKVU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 05:21:20 -0500
Received: by mail-qk1-f194.google.com with SMTP id c16so4132805qko.6;
        Mon, 09 Dec 2019 02:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5wpZqct9zId1JMwIvIkTx98tJap0IvMG3KRrK6bEBDM=;
        b=IEzijxr3E1MusXczAG2YYKgDDebdtwecdNChK8m0OZEuPTczGvG/jF8TIAj6eRHJbn
         zGKRwTp/VOf6TQ4y52WYJZaFpC2mXgQTNWw/cQEdlOdzNkkuG3OkrE/taG3vtua5mPQx
         vzXPMmV9ks6Nu8rrxwjMFew9TrRekYdQyaS5uz9nvWnjyt0lNHOImUh5uWPYcCKqYr6O
         Ftvijxlneg7V9vTHmu3cGwn5idi4FUap9nZnjbartbHGqUgkBWWCm5lfdPe5mBZSolt2
         KYajD2UnoEgw+wCTLOUGik1/3aob3g4MwpOJIbC76wuF/ZlEKrd+bhwdWVoIucJu+RK3
         M8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5wpZqct9zId1JMwIvIkTx98tJap0IvMG3KRrK6bEBDM=;
        b=VMyvf86C8yJG+xn7gWOOdzghPOXXf2mQK68UzoBFQFugfCHM7VVXVka1+3+gnhr4gN
         LjBoNNVfO0VUPgBL4X2RA0q1kWCrJpxX8SOHVuQJEw+Rmt/MHtdhVhOlKz2qnfU6tGqh
         XhdEyEEhMgCl7SRdjxfzLvTyR8BSNahiuluxZc/LLd2Bz3+bwcEMLo8ILaObiIrDWUrh
         oXP3dppHw6kMcd4uSidZz9sMKnQMAVkLKvtzepxbv/R/WK1Y12YK7XSRE8VggLteblAT
         pmxifBVhSzBBlAWHRNX1iT6wIkJ4fyXJnqulfvqKR0FQfIVbHJTbzkHSN46iS6PMF4zx
         J8kw==
X-Gm-Message-State: APjAAAWUDsh12UFZWCB8705dCu2h7f25tduqg6xyFWVvh1dZXq+0HsgM
        HVWxj1rSm528lQ143QQtyxI4oVH0ubHXook9QWI=
X-Google-Smtp-Source: APXvYqyiNlRqsKmdsEqcVQgML3WflGAH6cHuImDpuJGUsALxjPRXGR5VclsRP4zcDT20/Ag5ILjgKv74utoPsvlBGKg=
X-Received: by 2002:ae9:e30e:: with SMTP id v14mr25857560qkf.344.1575886878939;
 Mon, 09 Dec 2019 02:21:18 -0800 (PST)
MIME-Version: 1.0
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com>
 <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de> <20191209073744.GB3852@infradead.org>
 <dc01bf2c-4457-9658-c0a3-cbd4b7eff82b@suse.de>
In-Reply-To: <dc01bf2c-4457-9658-c0a3-cbd4b7eff82b@suse.de>
From:   Liang C <liangchen.linux@gmail.com>
Date:   Mon, 9 Dec 2019 18:21:07 +0800
Message-ID: <CAKhg4tL+A0aPMFxQt43EvzW4vH1p4T8XGMH5eKuT5_-ZvK5H5A@mail.gmail.com>
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

No problem. I will change the patch to remove this extra read. Thanks.

On Mon, Dec 9, 2019 at 5:52 PM Coly Li <colyli@suse.de> wrote:
>
> On 2019/12/9 3:37 =E4=B8=8B=E5=8D=88, Christoph Hellwig wrote:
> > On Fri, Dec 06, 2019 at 05:44:38PM +0800, Coly Li wrote:
> >>>  {
> >>> -   struct cache_sb *out =3D page_address(bio_first_page_all(bio));
> >>> +   struct cache_sb *out;
> >>>     unsigned int i;
> >>> +   struct buffer_head *bh;
> >>> +
> >>> +   /*
> >>> +    * The page is held since read_super, this __bread * should not
> >>> +    * cause an extra io read.
> >>> +    */
> >>> +   bh =3D __bread(bdev, 1, SB_SIZE);
> >>> +   if (!bh)
> >>> +           goto out_bh;
> >>> +
> >>> +   out =3D (struct cache_sb *) bh->b_data;
> >>
> >> This is quite tricky here. Could you please to move this code piece in=
to
> >> an inline function and add code comments to explain why a read is
> >> necessary for a write.
> >
> > A read is not nessecary.  He only added it because he was too fearful
> > of calculating the data offset directly.  But calculating it directly
> > is almost trivial and should just be done here.  Alternatively if that
> > is still to hard just keep a pointer to the cache_sb around, which is
> > how most file systems do it.
> >
> Copied, if Liang does not have time to handle this as your suggestion, I
> will handle it.
>
> Thanks for the hint.
>
> --
>
> Coly Li
