Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87233688CE7
	for <lists+linux-bcache@lfdr.de>; Fri,  3 Feb 2023 03:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjBCCI2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 21:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjBCCI2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 21:08:28 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABC865F21;
        Thu,  2 Feb 2023 18:08:27 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id hv11-20020a17090ae40b00b002307b580d7eso32716pjb.3;
        Thu, 02 Feb 2023 18:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+FZzMh4CM5HXgWYsbGwbRy2l8Xxkl0aIgZqSN7Hay4=;
        b=UFwGQMo+yxIQv5kCo4nSVKWMnlRx1K+ZTCq4uj0xz6byFc/9+RCku/kY3//6kRUafF
         0vsd1cUxf65GT7PWrB4FZNRitrxBCNBueIuDT96GjD4JQgXCiuv4fEQzLof1cDle/+ly
         vXkvjYpYuKjEMGjT2JOHNrkwCWRopRpAR8I+ZGjQr+PBZiFkITKfNlpMpQzKLn2Es3jP
         3oyU/50eba6ZS2h+CGdQ1Kg7jK4eagNGQbFGnRD9lPnicSZCeuqvXZUiQ4ACeg65IBig
         ejW0dMKShiTONK0suE1zGp92uwN374wYwtbjonqwf5HoqcCLjA75n1EHMRBTkXx2Lidr
         4DOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o+FZzMh4CM5HXgWYsbGwbRy2l8Xxkl0aIgZqSN7Hay4=;
        b=vcBsqUAXsMUhXWfc0ULWp30tSPRY+R+lbbZtMUUtRUbgptV/EUDw53M9N9duv0+KFh
         zMvI8ZOE1OIvs0R+N7bFOrbTLVTcIdnL+66JJ8VHd6t7qIJP9LyLf9RjGAio0YfjnoYC
         XSaObEfaIni3qwU4eCgwTkO6iPvq5nanXOu195bMpyAQMuszPuimerrE/EMuGVH7/0g+
         PBJU2Qy/SRom873gpD33T7mchtaOljIuhReJ5biJWZBT077l+l4z/XfS9jbVGcUkERhA
         rmcG84BcBulNuM9Scn+Wl9DSNWWGBzBQjRUEu/APdoNOWFxRdd+H86FDKlcMI9tKNT85
         qSZQ==
X-Gm-Message-State: AO0yUKULKfxqVFYGy5a7HYNMuM4zzG9uliEiOeoHPLwLSeTQLJOuoxBZ
        FelZNR2zLN7ULM8MQhlbo83/+FgKl+vCiMkJWwQ=
X-Google-Smtp-Source: AK7set8ERp13+2aYbZ1N6KQe0VNAgY4xkxkiAnLctjSv7DwyUNTfkWJe0wg6KGyrdTHU3k5yb2D7iUdzaUcqsFq+4X8=
X-Received: by 2002:a17:90a:9b02:b0:22c:a57f:a90f with SMTP id
 f2-20020a17090a9b0200b0022ca57fa90fmr1046557pjp.103.1675390106940; Thu, 02
 Feb 2023 18:08:26 -0800 (PST)
MIME-Version: 1.0
References: <20230202151504.542958-1-zyytlz.wz@163.com> <85540cd-91fd-9aa7-23c4-2fb529d43fc2@ewheeler.net>
In-Reply-To: <85540cd-91fd-9aa7-23c4-2fb529d43fc2@ewheeler.net>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Fri, 3 Feb 2023 10:08:13 +0800
Message-ID: <CAJedcCxpj+MgiMTLXOgUFuK1aW9H7BXdB3nQnu8KH2LCKpPA_Q@mail.gmail.com>
Subject: Re: [PATCH] bcache: Fix __bch_btree_node_alloc to make the failure
 behavior consistent
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Zheng Wang <zyytlz.wz@163.com>, colyli@suse.de,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex000young@gmail.com
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

Eric Wheeler <bcache@lists.ewheeler.net> =E4=BA=8E2023=E5=B9=B42=E6=9C=883=
=E6=97=A5=E5=91=A8=E4=BA=94 04:37=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, 2 Feb 2023, Zheng Wang wrote:
>
> > In some specific situation, the return value of __bch_btree_node_alloc =
may
> > be NULL. This may lead to poential NULL pointer dereference in caller
> >  function like a calling chaion :
> >  btree_split->bch_btree_node_alloc->__bch_btree_node_alloc.
> >
> > Fix it by initialize return value in __bch_btree_node_alloc before retu=
rn.
> >
> > Fixes: cafe56359144 ("bcache: A block layer cache")
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
>
> Be sure to add `Cc: stable@vger.kernel.org`
>
> -Eric
>

Thanks for your kind reminding. Will do in the next patch.

Best regards,
Zheng Wang
