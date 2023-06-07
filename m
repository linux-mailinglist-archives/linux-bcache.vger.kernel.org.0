Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2CD725ABB
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Jun 2023 11:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbjFGJio (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Jun 2023 05:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239864AbjFGJim (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Jun 2023 05:38:42 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F391984
        for <linux-bcache@vger.kernel.org>; Wed,  7 Jun 2023 02:38:40 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-970056276acso1068180966b.2
        for <linux-bcache@vger.kernel.org>; Wed, 07 Jun 2023 02:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1686130719; x=1688722719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gjKWGYzTLmxl6ndmaqY1vhf0MYCxKeiBaM5D6TZOn9k=;
        b=YXuPeKYHXY8x573VqT+WBt2/3c0ykgaHJuCFCznCBd9Wetpo4vgup6yqqURCu0byaA
         Z/WQU4wI1a6QCL47tLiZRI6KTt32VZU/qDKhKKJKLQFyY7AmMCGDwrGB1pizVTFQERU7
         t/x6PD6wstNl8G+Np+qAroVsRlq5DhK6VHOceLAS64dGk9Gj3fcvwZo0Y8lemLlMRb9N
         lmkimh7iJEnOSo+NJeMchGTnQhFoj8noYEGMLBj46T+S0Fm4jsdixCjB8sRTniHot4zo
         HY10z3v3++4U48Fj0kZDnrEgImtyRX0sgkHyTWWoWMiMmGGRFIMZm1Lm0qh585DtYYsI
         wCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686130719; x=1688722719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gjKWGYzTLmxl6ndmaqY1vhf0MYCxKeiBaM5D6TZOn9k=;
        b=GcbvHzs4swvI9w7L1+lKziag4wPP3hAvZphgxf3LHfTom+CDtJvrscLguG0y+iVmHN
         daU+fo5TN0OWeGQ+9fofu/TFlHYpG1y3Et4Gi0txFFgMGvfHkFuydoITT2civseLuP0V
         GAjPVdyIfkkt3h967XNiQZtXAqU/7kWaLcmK9rZpFc5QCQXnXAFAZNsDixyWGr2L/Yro
         qzaRUQSxr+rAo3C7eDyUdFG4qAq2/DAvwRIJmQ6La5vhmYb57A/yoIy+Yr0bodddCujt
         p4Eer8klhnHLVQH47Vq6q1o9R/iJPE6wiXcNezOEyLWyAhAcHL1zp+kJ99eI547zqPTC
         wZuA==
X-Gm-Message-State: AC+VfDyD0c37TYiD/vYmQbCnxEFiKY0K3LP3W43BqHYl8wu+33k8XuY7
        MjMZirrQOo4U1KQ+HN1qhMKe67Z1LoQ2ZuIa+HvU0w==
X-Google-Smtp-Source: ACHHUZ4JO4oLBtR+CLz1tcyt1M0aK5Az38dx3TKZ26TI2779MlmTOIaNGaUTpmyncHvDOVtnmf3szZ6EUx+OtsgHRJ4=
X-Received: by 2002:a17:907:3f22:b0:96b:1608:3563 with SMTP id
 hq34-20020a1709073f2200b0096b16083563mr5475281ejc.58.1686130718689; Wed, 07
 Jun 2023 02:38:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-15-hch@lst.de>
In-Reply-To: <20230606073950.225178-15-hch@lst.de>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 7 Jun 2023 11:38:27 +0200
Message-ID: <CAMGffEk8Zex5+u69YW9AXGQh-ch79mw7=Gn3L1M=qwvZCVa5VA@mail.gmail.com>
Subject: Re: [PATCH 14/31] rnbd-srv: don't pass a holder for non-exclusive blkdev_get_by_path
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>,
        Josef Bacik <josef@toxicpanda.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Coly Li <colyli@suse.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-um@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-btrfs@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Jun 6, 2023 at 9:40=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> Passing a holder to blkdev_get_by_path when FMODE_EXCL isn't set doesn't
> make sense, so pass NULL instead.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/block/rnbd/rnbd-srv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.=
c
> index cec22bbae2f9a5..ce505e552f4d50 100644
> --- a/drivers/block/rnbd/rnbd-srv.c
> +++ b/drivers/block/rnbd/rnbd-srv.c
> @@ -719,7 +719,7 @@ static int process_msg_open(struct rnbd_srv_session *=
srv_sess,
>                 goto reject;
>         }
>
> -       bdev =3D blkdev_get_by_path(full_path, open_flags, THIS_MODULE, N=
ULL);
> +       bdev =3D blkdev_get_by_path(full_path, open_flags, NULL, NULL);
>         if (IS_ERR(bdev)) {
>                 ret =3D PTR_ERR(bdev);
>                 pr_err("Opening device '%s' on session %s failed, failed =
to open the block device, err: %d\n",
> --
> 2.39.2
>
