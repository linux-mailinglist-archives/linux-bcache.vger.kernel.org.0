Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7401687F98
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 15:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjBBOLQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 09:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbjBBOLP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 09:11:15 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA65689F84;
        Thu,  2 Feb 2023 06:11:14 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c10-20020a17090a1d0a00b0022e63a94799so5671051pjd.2;
        Thu, 02 Feb 2023 06:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zmn9aG+g2MgvvZdKGq0cOCKAqQNwYCChOTwo43AoVjo=;
        b=p03eVzC7layVFGq+/E+REGWDF7B3L1JL2txOEMT2Y/tVilUB3QRsnzQjLneoox17K+
         ydt+AQguPgfOZDT+1t3rmzNSJ/Em1wjQvdRDyTETue2oCXZR/IDN/nAMWQXJCJxEn/uU
         M6WGTBdqQqmBEu5TefQEuZqG1OB3E8m7NYQOcOKWljsOgzw8xkVq7MfEkZh6j7KpNbrb
         yxNL1MsCCUY/MskCjpDQ188MVbimWrSpvvZM5XmrGaD+YK5Rsgu0Jynd/ioP7xLPMFjm
         xS3FpDpdTmib+61hmRrseYZWgCzC1QElYTmh51FQhjGNcGLeK0EFXtCg/Gqgk3vnMuOr
         4z0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zmn9aG+g2MgvvZdKGq0cOCKAqQNwYCChOTwo43AoVjo=;
        b=GpHmUsJQxONie5Z2cWCWQIhBkS0M8vxIquu/TunQ4vDZQCt9OJM4dOweBCwChc6Gg/
         yvtba0cWOSABf3/rBLJ3gv1qHTSsBvPjN3d0cmq16ouFh0QcP4BOgJh9J9QEkM6I7v3U
         jToe8hhG5z6q0rjAucgUughWn4vIxh+fcCeSckwEnKA2bpMDIru75uRXjxzbDjHc/phg
         etoyp5JkC4Cckzk9gZb5+01yChwP52p+rW/YWARWg5EPPD4x/fEQ6NXlragt1H36ND7n
         pD3DCpU6u6Mh3qSTY2ChCbfY2HGp+As5EeqEvmi1C2Ax+u2F+hIacQ+wjB6rGwOUB2vm
         y3Gg==
X-Gm-Message-State: AO0yUKXBOMeS0PNB5N9pFLPuK3TrzhBHCUoo42efm7jdzSlGYFJiJkYJ
        Bpe7qHBjOnYnoCOLe/UGNl7aC8eeoRCQdgzPB7Q=
X-Google-Smtp-Source: AK7set8fbD5gow+pRV8G/ely3X4hQzCHM7o0gEbg6InNFHalbse0fwW+sn9GPJzU7eJaI8hR97ushTua+oN3zYL5DAs=
X-Received: by 2002:a17:90a:a592:b0:22c:2281:5a5a with SMTP id
 b18-20020a17090aa59200b0022c22815a5amr550910pjq.108.1675347073882; Thu, 02
 Feb 2023 06:11:13 -0800 (PST)
MIME-Version: 1.0
References: <20230202110543.27548-1-zyytlz.wz@163.com> <50656A90-E0D4-4800-880C-406EBDD784FC@suse.de>
In-Reply-To: <50656A90-E0D4-4800-880C-406EBDD784FC@suse.de>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Thu, 2 Feb 2023 22:11:01 +0800
Message-ID: <CAJedcCxWcyvzTWG2sZquGXO92qH=yV_wjaU0WtXpVT=SC13wbw@mail.gmail.com>
Subject: Re: [PATCH] bcache: Fix a NULL or wild pointer dereference in btree_split
To:     Coly Li <colyli@suse.de>
Cc:     Zheng Wang <zyytlz.wz@163.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        security@kernel.org, alex000young@gmail.com
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
=A8=E5=9B=9B 20:22=E5=86=99=E9=81=93=EF=BC=9A

> Hmm, there should be something to be fixed, but not the non-exist NULL de=
reference.
>
> If you look inside btree_node_alloc_replacement(), you may find __bch_btr=
ee_node_alloc() which does the real work indeed. And yes, I would suggest y=
ou to improve a bit inside __bch_btree_node_alloc().
>
> 1088 struct btree *__bch_btree_node_alloc(struct cache_set *c, struct btr=
ee_op *op,
> [snipped]
> 1093         struct btree *b =3D ERR_PTR(-EAGAIN);
> 1094
> 1095         mutex_lock(&c->bucket_lock);
> 1096 retry:
> 1097         if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, wait))
> 1098                 goto err;
> [snipped]
> 1102
> 1103         b =3D mca_alloc(c, op, &k.key, level);
> 1104         if (IS_ERR(b))
> 1105                 goto err_free;
> 1106
> 1107         if (!b) {
> 1108                 cache_bug(c,
> 1109                         "Tried to allocate bucket that was in btree =
cache");
> 1110                 goto retry;
> 1111         }
> 1112
>
> From the above code, at line 1097 if __bch_bucket_alloc_set() returns non=
-zero value, the code will jump to label err: and returns ERR_PTR(-EAGAIN).=
 But if the code fails at line 1103 and b is set to NULL, at line 1110 the =
code will jump back to label retry: and calls __bch_bucket_alloc_set() agai=
n. If the second time __bch_bucket_alloc_set() returns non-zero value and t=
he code jumps to label err:, a NULL pointer other than ERR_PTR(-EAGAIN) wil=
l be returned. This inconsistent return value on same location at line 1097=
 seems incorrect, where ERR_PTR(-EAGAIN) should be returned IMHO.
>
> Therefore I feel that =E2=80=9Cb =3D ERR_PTR(-EAGAIN)=E2=80=9D should be =
moved to the location after label retry:, then btree_node_alloc_replacement=
() will only return error code, and no NULL pointer returned.
>
> After this change, all following IS_ERR_OR_NULL() checks to btree_node_al=
loc_replacement() are unnecessary and IS_ERR() just enough, because no NULL=
 will be returned.
>
> This is a nice catch. I=E2=80=99d like to have it to be fixed. I do appre=
ciate if you want to compose two patches for the fix. Otherwise I can handl=
e it myself.
>
Hi Coly,

Thanks for your reply and detailed explaination! As you explain, I
found __bch_btree_node_alloc may return NULL in some situation. So I
add some more check in upper code.
Your suggestion is more constructive. It'll make the function more
clear for other developer. I'd like to help with the patch. And you
have kindly pointed the right way to fix.
 May I merge fix it in one patch with the commit msg "refactor
__bch_btree_node_alloc to avoid poential NULL dereference"? Because I
think if __bch_btree_node_alloc returns
NULL to bch_btree_node_alloc, the function
btree_node_alloc_replacement will strill return NULL to n1 in
btree_split. I think the possibility is low, if it's not proper,
please feel free
to let me know.

Best regards,
Zheng Wang
