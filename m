Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F33212C1F
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Jul 2020 20:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgGBSW1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Jul 2020 14:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgGBSW0 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Jul 2020 14:22:26 -0400
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5280A21473;
        Thu,  2 Jul 2020 18:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593714145;
        bh=2Ob+guxRY0fDcRz+P555VDdl6+UEf5NKd/ZEgEjmyqA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OoegUq2L0uxSt3rrR3lcoqsDAOAxdO0rE6tlewRsGb9eiQzLEa9GcLv3f53+JJtIq
         Tu4dmdJlB98mXwT/7grCGi1Eg4sXkxKx8O4HxETnxcls0gt5Kok143rso1DF1RnUs7
         J+0BQhidD4fUWOWUJ491VzOjYlY2TbrXcU05LAhg=
Received: by mail-lj1-f171.google.com with SMTP id f8so21170603ljc.2;
        Thu, 02 Jul 2020 11:22:25 -0700 (PDT)
X-Gm-Message-State: AOAM530umYGL16nenEUbYt5S5AYMR50NE5dhOo45ROlTrCafZgivQgbY
        oVUU0XFnImABXBQ6U37cDYOvRM3bvKNf1U9gJY0=
X-Google-Smtp-Source: ABdhPJwzHQSAgDG5LZKrrq4sCwOryNIpxeUx+J+pLZvaBWcsyRJefETEyU+mlLl9hUoA9U/QBDPE51PBpf0COAdEZgQ=
X-Received: by 2002:a2e:9901:: with SMTP id v1mr17432874lji.41.1593714143665;
 Thu, 02 Jul 2020 11:22:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200701085947.3354405-1-hch@lst.de> <20200701085947.3354405-18-hch@lst.de>
In-Reply-To: <20200701085947.3354405-18-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 2 Jul 2020 11:22:12 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4=eiN2-_cy5vCn_RGwmYRf37jOX4DWTvUCDWAqRzU+pw@mail.gmail.com>
Message-ID: <CAPhsuW4=eiN2-_cy5vCn_RGwmYRf37jOX4DWTvUCDWAqRzU+pw@mail.gmail.com>
Subject: Re: [PATCH 17/20] block: rename generic_make_request to submit_bio_noacct
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

On Wed, Jul 1, 2020 at 2:01 AM Christoph Hellwig <hch@lst.de> wrote:
>
> generic_make_request has always been very confusingly misnamed, so rename
> it to submit_bio_noacct to make it clear that it is submit_bio minus
> accounting and a few checks.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
[...]

>  drivers/md/md-faulty.c                        |  4 +--
>  drivers/md/md-linear.c                        |  4 +--
>  drivers/md/md-multipath.c                     |  4 +--
>  drivers/md/raid0.c                            |  8 ++---
>  drivers/md/raid1.c                            | 14 ++++----
>  drivers/md/raid10.c                           | 28 ++++++++--------
>  drivers/md/raid5.c                            | 10 +++---

For md part:

Acked-by: Song Liu <song@kernel.org>
