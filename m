Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BDF687FCE
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 15:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjBBOVh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 09:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjBBOVe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 09:21:34 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E231B564;
        Thu,  2 Feb 2023 06:21:33 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id t17so1316910pfj.0;
        Thu, 02 Feb 2023 06:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKTuaQu5eHPlA4r4M3F6u9lJ48zhiYGpNgM+tV6NbxM=;
        b=keLWah48/S8EwdP6z7z2XWYER9T0WVtKHoMhOMVAO6u3qw7aC9c8+enzVLdD/mkI9t
         vQtgsOTRghk1kwFB/vWOShIe0MexKRW+z04bPtsKyUv2ROrams30CQkPYag+XtIALoxx
         NbyRlPRmAUvXL6Afnyhh4FLbjtimVfqDM5Qsmz11+xeGQemGghgVZpHxb4XftpW1g+QN
         8oC4O3p8SR6MVbhvgsCW8UdgZ5yQhfHtHrJNe6dBQLn2LcmxJQ+jEMwH28P2bmYRjexs
         nLT7rbt/NJnl1nEyzUAgZbsCJbovKeLQjbKVzvA6FD2ZaduD1/3ohaRZ8fPHCqvskGDd
         8L0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aKTuaQu5eHPlA4r4M3F6u9lJ48zhiYGpNgM+tV6NbxM=;
        b=ji/k7iI5kGu8ZsdgyIV5Xy8/UqEFr8hAByWgj9/LuQLauYjUu1NztIMkbrIt63eL/p
         HPOfMfp7Z04kA9n7+bsnunUIEOjtZifwE1Ioe8DFU0BY63LcG80LaoUF026XyjWwotXm
         Abj5BjkWiY5+z9PSCjBX8X/YJ/MEgJTgV5NuBWaIIAlCPnL6nwjSLMIjmHegYBV2szXk
         8cfIpgwtcIO16ACR7V0p+L7+aZP8rl9yLfFgnxVILvrALOEK8ibuyirtEGeiSNBZME2Z
         h8wA7EV8rFcApYEuOVqz4JKr5jmRva0TQJfvg0sEjWv6gUPKVjXoLvFKbr8U+/hT856b
         8f1A==
X-Gm-Message-State: AO0yUKU97F3SDEpapXNYkQ/oyjBeRh6YONQRLIzbmx2Edtog+6wVm2vd
        yfUYROoKxCOh/eedCB7wae3TV5NON7+9sFUWo/Q=
X-Google-Smtp-Source: AK7set/sA7U0nzO2q0zJmqfe9E+0wWViyoo5n+J6y3Hwycn1iKNkFKBtJ5mIM8Yl3TP9/j/9UCkDVJDQSBpbf55KyUg=
X-Received: by 2002:a05:6a00:997:b0:583:402e:b5d0 with SMTP id
 u23-20020a056a00099700b00583402eb5d0mr1437798pfg.35.1675347692993; Thu, 02
 Feb 2023 06:21:32 -0800 (PST)
MIME-Version: 1.0
References: <20230202110543.27548-1-zyytlz.wz@163.com> <50656A90-E0D4-4800-880C-406EBDD784FC@suse.de>
 <CAJedcCxWcyvzTWG2sZquGXO92qH=yV_wjaU0WtXpVT=SC13wbw@mail.gmail.com> <CEE564CA-A779-437D-B38B-FAF9F6957771@suse.de>
In-Reply-To: <CEE564CA-A779-437D-B38B-FAF9F6957771@suse.de>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Thu, 2 Feb 2023 22:21:19 +0800
Message-ID: <CAJedcCwRqTtw53vM4G91xbOq-QOyW7g_2=zmCocbz1o1f_uj-w@mail.gmail.com>
Subject: Re: [PATCH] bcache: Fix a NULL or wild pointer dereference in btree_split
To:     Coly Li <colyli@suse.de>
Cc:     Zheng Wang <zyytlz.wz@163.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Coly Li <colyli@suse.de> =E4=BA=8E2023=E5=B9=B42=E6=9C=882=E6=97=A5=E5=91=
=A8=E5=9B=9B 22:18=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> > 2023=E5=B9=B42=E6=9C=882=E6=97=A5 22:11=EF=BC=8CZheng Hacker <hackerzhe=
ng666@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Coly Li <colyli@suse.de> =E4=BA=8E2023=E5=B9=B42=E6=9C=882=E6=97=A5=E5=
=91=A8=E5=9B=9B 20:22=E5=86=99=E9=81=93=EF=BC=9A
> >
> >> Hmm, there should be something to be fixed, but not the non-exist NULL=
 dereference.
> >>
> >> If you look inside btree_node_alloc_replacement(), you may find __bch_=
btree_node_alloc() which does the real work indeed. And yes, I would sugges=
t you to improve a bit inside __bch_btree_node_alloc().
> >>
> >> 1088 struct btree *__bch_btree_node_alloc(struct cache_set *c, struct =
btree_op *op,
> >> [snipped]
> >> 1093         struct btree *b =3D ERR_PTR(-EAGAIN);
> >> 1094
> >> 1095         mutex_lock(&c->bucket_lock);
> >> 1096 retry:
> >> 1097         if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, wait=
))
> >> 1098                 goto err;
> >> [snipped]
> >> 1102
> >> 1103         b =3D mca_alloc(c, op, &k.key, level);
> >> 1104         if (IS_ERR(b))
> >> 1105                 goto err_free;
> >> 1106
> >> 1107         if (!b) {
> >> 1108                 cache_bug(c,
> >> 1109                         "Tried to allocate bucket that was in btr=
ee cache");
> >> 1110                 goto retry;
> >> 1111         }
> >> 1112
> >>
> >> From the above code, at line 1097 if __bch_bucket_alloc_set() returns =
non-zero value, the code will jump to label err: and returns ERR_PTR(-EAGAI=
N). But if the code fails at line 1103 and b is set to NULL, at line 1110 t=
he code will jump back to label retry: and calls __bch_bucket_alloc_set() a=
gain. If the second time __bch_bucket_alloc_set() returns non-zero value an=
d the code jumps to label err:, a NULL pointer other than ERR_PTR(-EAGAIN) =
will be returned. This inconsistent return value on same location at line 1=
097 seems incorrect, where ERR_PTR(-EAGAIN) should be returned IMHO.
> >>
> >> Therefore I feel that =E2=80=9Cb =3D ERR_PTR(-EAGAIN)=E2=80=9D should =
be moved to the location after label retry:, then btree_node_alloc_replacem=
ent() will only return error code, and no NULL pointer returned.
> >>
> >> After this change, all following IS_ERR_OR_NULL() checks to btree_node=
_alloc_replacement() are unnecessary and IS_ERR() just enough, because no N=
ULL will be returned.
> >>
> >> This is a nice catch. I=E2=80=99d like to have it to be fixed. I do ap=
preciate if you want to compose two patches for the fix. Otherwise I can ha=
ndle it myself.
> >>
> > Hi Coly,
> >
> > Thanks for your reply and detailed explaination! As you explain, I
> > found __bch_btree_node_alloc may return NULL in some situation. So I
> > add some more check in upper code.
> > Your suggestion is more constructive. It'll make the function more
> > clear for other developer. I'd like to help with the patch. And you
> > have kindly pointed the right way to fix.
> > May I merge fix it in one patch with the commit msg "refactor
> > __bch_btree_node_alloc to avoid poential NULL dereference"? Because I
> > think if __bch_btree_node_alloc returns
> > NULL to bch_btree_node_alloc, the function
> > btree_node_alloc_replacement will strill return NULL to n1 in
> > btree_split. I think the possibility is low, if it's not proper,
> > please feel free
> > to let me know.
>
> This is not a refactor indeed, just a simple fix to __bch_btree_node_allo=
c() to make the failure behavior of calling __bch_bucket_alloc_set() at lin=
e 1097 to be consistent. A.K.A always returning ERR_PTR(-EAGAIN) when it re=
turns failure.
>
> Another optional patch is to change the unnecessary IS_ERR_OR_NULL() to I=
S_ERR() in proper locations, because after the first fix, NULL won=E2=80=99=
t be returned indeed. And extra code comments on why IS_ERR() is sufficient=
 might be preferred IMHO.
>

Got it! Will do right now. Thanks agagin for your clear description
about the fix.

Thanks,
Zheng Wang
