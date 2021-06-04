Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F5439BC65
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jun 2021 17:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhFDP7z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Jun 2021 11:59:55 -0400
Received: from mail-qv1-f41.google.com ([209.85.219.41]:45821 "EHLO
        mail-qv1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhFDP7y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Jun 2021 11:59:54 -0400
Received: by mail-qv1-f41.google.com with SMTP id g12so5154103qvx.12
        for <linux-bcache@vger.kernel.org>; Fri, 04 Jun 2021 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nKYtnWa3pGjQEPCZWnVUzTwysNuGoKS7rDpdZ+HlVuk=;
        b=Wsnr+y+A2XIAHClb68R2+29NIYM41MhpRzxApagCm147knJWomsw2Y2gmSCIUdQOTR
         DL7edlRfqEzc0kkRlK66VcrY0ErYJ+GOLWAYD9t3yYtwtnBQ0M1vCvoqjnC9IlrauXNE
         EF1LGCnoApsvnG67jhKlZ5f46GTks0Pqtr2no=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nKYtnWa3pGjQEPCZWnVUzTwysNuGoKS7rDpdZ+HlVuk=;
        b=UpgMji63xE+8XOCuOKoYvYrgIG8adET+PWY0duG9ayivmV2HjA0seoupUQL1+5KWrX
         i65DK1ZoBMv3XH+HVjqKTCvZEzXpYbLZlw2yZhbl9x2uKoR0LdfADGBp5tQOnbPGp+yt
         fII8J/LM/IdWlXNBhuTrhpR4folg6EQhxuT2Ait7+8XeCiRNRDpg7B3MuvP95vdBC/8h
         6NSVNSs8ilY6uefeq6QVTl/azVYjJqew4u3f6mNvYnuqovv6T2vaH+8RSrm8Xa9FyXkg
         p9eQEedNbrHAqEdWQ8uOgIcIZZD3tZGkiIl4cYsVggf05H8zVyUeXe02B72fW6oX6hOM
         mosw==
X-Gm-Message-State: AOAM532PKsosBQZ/a8BFDYuxMO/92jIcUslD4a/p3D7qq4oCSwgTDQit
        qszrR7Hsj3dhbFsNjMG1qxIsXr6Wch/eWgF07CMG7dB34LiW1g==
X-Google-Smtp-Source: ABdhPJy4eJQxoUPU9KNQNs/pvpCFu+O09sXrEy/btLY/dgafXpUxBLAmUA1/v1U/yi5LzDMML+KWxK0Pa2ksY3iVKH8=
X-Received: by 2002:a05:6214:1248:: with SMTP id q8mr5425992qvv.47.1622822215575;
 Fri, 04 Jun 2021 08:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <5b01087b-6e56-0396-774a-1c1a71fe50df@aragon.es>
 <4cc064bc-36f3-cb15-0240-610a45e49300@suse.de> <62f20c57-d502-c362-da84-61a47c891e6d@aragon.es>
In-Reply-To: <62f20c57-d502-c362-da84-61a47c891e6d@aragon.es>
From:   Kai Krakow <kai@kaishome.de>
Date:   Fri, 4 Jun 2021 17:56:44 +0200
Message-ID: <CAC2ZOYuUbrRgHjFqERMQ8N2NUuDnySbcpvtaCzHGWGTnnZU7_w@mail.gmail.com>
Subject: Re: Low hit ratio and cache usage
To:     Santiago Castillo Oli <scastillo@aragon.es>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello!

Am Fr., 4. Juni 2021 um 14:36 Uhr schrieb Santiago Castillo Oli
<scastillo@aragon.es>:
>
> Hi Coli!
>
>
> El 04/06/2021 a las 14:05, Coly Li escribi=C3=B3:
> > What is the kernel version and where do you have the kernel ?  And what
> > is the workload on your machine ?
>
> I'm using debian 10 with default debian kernel (4.19.0-16-amd64) in host
> and guests.
>
> For virtualization I'm using KVM.
>
>
> There is a host, where bcache is running. The filesystem over bcache
> device is ext4. In that filesystem there is only 9 qcow2 files user by
> three VM guests. Two VM are running small nextcloud instances, another
> one is running transmission (bittorrent) for feeding debian and other
> distro iso files (30 files - 60 GiB approx.)

Besides Coly recommending to use a newer kernel, I think there may be
some misunderstanding of how bcache works:

* bcache is mostly about reducing latency so it skips sequential
access, you should measure block access latency instead of throughput
or fill rate

* thus, it probably fills your cache very slowly if a lot of patterns
are sequential

* ext4 has a write journal which turns many random write patterns into
sequential write patterns, YMMV if you disable ordered data mode or
journalling

* qcow2 is copy-on-write: new blocks are appended, resulting in
possible write amplification in bcache, it also creates sequential
write patterns

* kvm/qemu probably use directio / uncached IO by default which may
bypass bcache or caching completely, you should try a different IO
mode in kvm (e.g. unsafe cached)


Regards,
Kai
