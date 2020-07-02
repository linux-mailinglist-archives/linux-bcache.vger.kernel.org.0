Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83ED211B99
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Jul 2020 07:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgGBFg1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Jul 2020 01:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgGBFg1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Jul 2020 01:36:27 -0400
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B51120724;
        Thu,  2 Jul 2020 05:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593668186;
        bh=w80HNCQd43j8lsfGDknlfMWRCtxh8+ZfOTuzLjUb+Tg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CiLGW4fQE83/yPSoaLNjNXxWdQztSEnfSUvobWj5SL08wFtpj7ITwNpTCpr8fXJG6
         v6LQ82S6Iopo0IEnBC03ZMkH1MPLHvkJL0OmNAg4PDKmTLqsnglMl5I7VLK6hBNzY0
         Hln49f0USlhkO3bp1JcuqHNbQ5T9o97V4VbFqjxw=
Received: by mail-lj1-f181.google.com with SMTP id 9so30093459ljv.5;
        Wed, 01 Jul 2020 22:36:26 -0700 (PDT)
X-Gm-Message-State: AOAM5302EguksHGyx96McGzP+vV2RAVmZBDx1EaWZ+TwumcXBHDsn2h5
        R3h7HgXRHajHkaz9f7jIRk/c+HS3t9Ql2rUoykU=
X-Google-Smtp-Source: ABdhPJymqO+8A/ON6cgRlyAmaadzhb/A3ETkgEahkbFx3Wp1rU/jFwtY3MDkzrSEOGWene4L2hOwuUlW51s/XrqmVQI=
X-Received: by 2002:a2e:7f06:: with SMTP id a6mr4621445ljd.446.1593668184748;
 Wed, 01 Jul 2020 22:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200701090622.3354860-1-hch@lst.de> <20200701090622.3354860-5-hch@lst.de>
In-Reply-To: <20200701090622.3354860-5-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Jul 2020 22:36:13 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7QShNMnbCK-OrKkE8F5XyH45-ML-w5qKLVrO=VTt6npw@mail.gmail.com>
Message-ID: <CAPhsuW7QShNMnbCK-OrKkE8F5XyH45-ML-w5qKLVrO=VTt6npw@mail.gmail.com>
Subject: Re: [PATCH 4/4] writeback: remove bdi->congested_fn
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        dm-devel@redhat.com, cgroups@vger.kernel.org,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jul 1, 2020 at 2:06 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Except for pktdvd, the only places setting congested bits are file
> systems that allocate their own backing_dev_info structures.  And
> pktdvd is a deprecated driver that isn't useful in stack setup
> either.  So remove the dead congested_fn stacking infrastructure.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For md bits:

Acked-by: Song Liu <song@kernel.org>
