Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E343754DF8D
	for <lists+linux-bcache@lfdr.de>; Thu, 16 Jun 2022 12:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiFPKyc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jun 2022 06:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiFPKyb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jun 2022 06:54:31 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534AD5DE50
        for <linux-bcache@vger.kernel.org>; Thu, 16 Jun 2022 03:54:30 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id d18so1071465ljc.4
        for <linux-bcache@vger.kernel.org>; Thu, 16 Jun 2022 03:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mwsxV93OonNjERqsl3fzXC9tFsn9bn1urFMxcyd0co8=;
        b=YXpzGiSRfWki0RUAUtZfD9X6cGOCPxfqcshQ9ZTSgLVMa7QBP3wH7xEfi2H+MczkAc
         cgM8Tm/1m3Py4Blko8C2pwwJTgtRC/kbi8i2iQE/L/i9/GbK/p2Q9i0LrfZ3zueghvF4
         O6mZlXtbOlbK+3PKfuYrNe/yc0yNQOq1l8YSWNODyYzxb+nYslQVLiTDDAjEHxxpQa73
         IkSK0w1f8uEmtwTgqJwGPP9cB5zH8zW8fyEyaVPntg/1EsvlkR5LKLIqtkubnAM16mlh
         N5qy8UX6+pZSgDJ6fStLdMSvNybSZ0pHRrDhUkXsQ0E8B24Ys1vuGOfVi1PP/tv+fIMi
         pMlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mwsxV93OonNjERqsl3fzXC9tFsn9bn1urFMxcyd0co8=;
        b=AZ3QbyeLr8KqzUnLxULNSCH35/l7Rw10zY2JeTmH7MZW8JCohfbM8HXB+WEpEMl0BT
         HxTylLZEVlcRLpZPuM1mWLfNL0NtdiL7fFY5qbRkki3RQiXQ5sd8VqC8K3+vSEeKYZUK
         CZFeqXki+NY0FQN+EXSWIDUHR4C9PzKjlfSAHJvgO35jIiCTFf+Wfl0ZMvnjidZaZF1w
         2eXXmyEXwYoQ2WOAeueP2K+xBqt0M+pgf1lbzt01X4T+gNHvi6Vwr3irlOjY9MUDeLR4
         88eFaVQIdJdf+YGXTQEQ3gOapCjd8cVPgUWrFUbgTrhqLB2EuKP8HOAznNG5XIjAm9zg
         FPXA==
X-Gm-Message-State: AJIora85OpKoiuA7M1ProoZlj7YYUw/4JzncyQAfAJmEbB9BZoTQtOJI
        3QkxVrjqpNtJt1svKUKFInO3A4G58Q6hX/t+/t8N1FycJvJovA==
X-Google-Smtp-Source: AGRyM1sajVUU288QHTXl/EthMn8zlyqlIfUxRcr1qbs18F05BRllqUrO+CVQ8dh2zKEvrBry5PdFDa4PSMNMHVf9gDI=
X-Received: by 2002:a2e:8e98:0:b0:255:9d3d:bac3 with SMTP id
 z24-20020a2e8e98000000b002559d3dbac3mr2110683ljk.103.1655376868318; Thu, 16
 Jun 2022 03:54:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv0CQ8QQn9z5=nAyh80z05j3vxBGBz3HmYFbn2Dj3cfO9A@mail.gmail.com>
In-Reply-To: <CAC6jXv0CQ8QQn9z5=nAyh80z05j3vxBGBz3HmYFbn2Dj3cfO9A@mail.gmail.com>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Thu, 16 Jun 2022 16:24:16 +0530
Message-ID: <CAC6jXv0ZvnVuzW_nmjQXu+V13CWPP-hFFFbRS22z=YQ5oXVWyw@mail.gmail.com>
Subject: Re: backport 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 to 4.15.0-176.185
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello all!

As mentioned in the earlier email, I am trying to backport
32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 to kernel 4.15.0-176_185

This is the diff that built the kernel successfully -
https://pastebin.com/Ce41Hqaa , and I had to apply it manually since
the cherry-pick did not apply cleanly and there were many conflicts.
The main issue seems to be that struct cache_set does not contain
multiple cache devices in the upstream code, but in 4.15 it did.

Since I am not aware of the internals of the bcache code, I am not
sure if it might cause unintended side effects, so I would appreciate
any input about this backport, and if it is a correct backport.

Regards,
Nikhil.

On Tue, 14 Jun 2022 at 08:46, Nikhil Kshirsagar <nkshirsagar@gmail.com> wrote:
>
> Hello all,
>
> I am trying to backport 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6
> (https://www.spinics.net/lists/kernel/msg4386275.html) onto
> 4.15.0-176.185 , please could someone help me understand which other
> patches I need? The cherry-pick needs manual resolution, which I did,
> but this is the issue I run into - https://pastebin.com/nBxdpHdJ
>
> I'd be very grateful for some help with this.
>
> Regards,
> Nikhil.
