Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD68211BD8
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Jul 2020 08:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgGBGOq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Jul 2020 02:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgGBGOo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Jul 2020 02:14:44 -0400
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34D4D208FE;
        Thu,  2 Jul 2020 06:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593670483;
        bh=TRjOq0ioBsI/lLgnqh3WHyq3NuAIqhAPdkGT9KrgKH8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yItMbcctXfs5o3K3a0Uwam0VmikvvsUcR4rDa/JwGQwZB8Uz/Yhp2jGzCMiYmIUEm
         4zPuCUnKKcbVFIxEfBWBqPKPHn5qsYIgU9hyGcq8vCgJNY75/6RU7God1Ttp8qeL9G
         H4psw2naqAuo1p/prO5iO6oUyZzGm17MB9ZSYIN4=
Received: by mail-lj1-f172.google.com with SMTP id z24so5336428ljn.8;
        Wed, 01 Jul 2020 23:14:43 -0700 (PDT)
X-Gm-Message-State: AOAM533BEREcPKSfi48xecrvT/Dya6EQ7p4zEefhyRSfUPpQv1T7ksCH
        EJpOShR3ahD0H1YRmuKv+I9vZycBr0zsCrJg+/M=
X-Google-Smtp-Source: ABdhPJyW7ZQG/gxodV+UBsSp8muv8lWxec/bTY9tvW0qqCeZQo8oSQL9G2bg+h67AMeeX8NyXrYP1bqMgId6X08X7/E=
X-Received: by 2002:a2e:88c6:: with SMTP id a6mr11256607ljk.27.1593670481513;
 Wed, 01 Jul 2020 23:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200701085947.3354405-1-hch@lst.de> <20200701085947.3354405-13-hch@lst.de>
In-Reply-To: <20200701085947.3354405-13-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Jul 2020 23:14:30 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5=055Eo-b3fjC_b-nJz-fg1FGwy_aqrNNtHm-U8vut-A@mail.gmail.com>
Message-ID: <CAPhsuW5=055Eo-b3fjC_b-nJz-fg1FGwy_aqrNNtHm-U8vut-A@mail.gmail.com>
Subject: Re: [PATCH 12/20] block: remove the request_queue argument from blk_queue_split
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        open list <linux-kernel@vger.kernel.org>,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jul 1, 2020 at 2:02 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The queue can be trivially derived from the bio, so pass one less
> argument.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
[...]
>  drivers/md/md.c               |  2 +-

For md.c:
Acked-by: Song Liu <song@kernel.org>
