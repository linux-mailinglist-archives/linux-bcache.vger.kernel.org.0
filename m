Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BD6725ADB
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Jun 2023 11:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbjFGJmz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Jun 2023 05:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbjFGJmy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Jun 2023 05:42:54 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7DE10DE
        for <linux-bcache@vger.kernel.org>; Wed,  7 Jun 2023 02:42:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5149390b20aso1159361a12.3
        for <linux-bcache@vger.kernel.org>; Wed, 07 Jun 2023 02:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1686130971; x=1688722971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iTSJC08M16dk7ac+qC1NLiFtaB9M/5yyS+Z15P92ssA=;
        b=T8ER5TNAg8z1wij3zxfOUWFCDItlghCiuUXhsaqzc4ZwLofamB8RtpTyQLSVJ9h2UJ
         K5p37hopSMXQsov3IbM/+pXTCPYzGIBfMzkaAwZATA27zGzqc2RsatdEeeSYzb8OJe7S
         EtKjbCR7ypq1BPl33V5iDYjnSNzEbZ8SSmlT2bsu8chvDUII0Eyuhqg1weJGkPNF54UA
         at62NLYWJFIfELcet832L35oN/vTBLLRmhbv4E6euKkZT5GIkiCfz/SvQVjjr0TSQFn4
         eMDgRORV7ULS7YCAm2XXby1mXqhN+JgUeFWJ6iq0dvTYt+w3IowjHJDt6ezXaXQ0V0f7
         BdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686130971; x=1688722971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iTSJC08M16dk7ac+qC1NLiFtaB9M/5yyS+Z15P92ssA=;
        b=R6iQYskbRhV9jA40ttUiXeRgJSXysSSjfU1MDUPa3PYpH23sChr8WwRR7ip6DgpisO
         7tAB1r85kFglh86GlmRblYPyU5HkthWOkrnTnnu12v+xprjlLPUHzDg3LgvmUPLMNBCf
         ieUMJvz4YOLMhTE0qqH5sEeOu1FdSUqXxBZXvEcIP6PT81dbASiFJHeYEjHthbSp1G77
         24TJQI9YTiFArnq1FDsanQLNRR6EVB/9MgSiK+pNODX4kM3P55D3gwH6qiw8cRSvPqWx
         79xXoJhJsBBsnF2TOoN85cVAYzfSje6mwBovmDnLo1KkaF9ReIzR3SENts8UNrCY5f+d
         bguA==
X-Gm-Message-State: AC+VfDzrxvohMKOxfgdimuLL2EWqJTEHlWA0ub/0Vjddu//cFzYRmVVL
        lzW8fVvjWNnfcbAPxL5xLg/cfnQWIio4stCHz8txcA==
X-Google-Smtp-Source: ACHHUZ5i8f5AUVXLioiA4Msh4foVuVuox1MKnFKi4fucw3rKEDDzkk1m6bVkvWRpki6Lz1RgGXGnv70bM2LGvyL4BxY=
X-Received: by 2002:aa7:cd55:0:b0:514:8e6f:7113 with SMTP id
 v21-20020aa7cd55000000b005148e6f7113mr3506396edw.22.1686130971195; Wed, 07
 Jun 2023 02:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230606073950.225178-1-hch@lst.de> <20230606073950.225178-10-hch@lst.de>
In-Reply-To: <20230606073950.225178-10-hch@lst.de>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 7 Jun 2023 11:42:40 +0200
Message-ID: <CAMGffEkKpHzatfeJhKtJQMTNckJGc7sJQ_LWFg-KvazvOD4DWw@mail.gmail.com>
Subject: Re: [PATCH 09/31] block: pass a gendisk to ->open
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
> ->open is only called on the whole device.  Make that explicit by
> passing a gendisk instead of the block_device.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/um/drivers/ubd_kern.c          |  5 ++---
>  arch/xtensa/platforms/iss/simdisk.c |  4 ++--
>  block/bdev.c                        |  2 +-
>  drivers/block/amiflop.c             |  8 ++++----
>  drivers/block/aoe/aoeblk.c          |  4 ++--
>  drivers/block/ataflop.c             | 16 +++++++--------
>  drivers/block/drbd/drbd_main.c      |  6 +++---
>  drivers/block/floppy.c              | 30 +++++++++++++++--------------
>  drivers/block/nbd.c                 |  8 ++++----
>  drivers/block/pktcdvd.c             |  6 +++---
>  drivers/block/rbd.c                 |  4 ++--
>  drivers/block/rnbd/rnbd-clt.c       |  4 ++--
Acked-by: Jack Wang <jinpu.wang@ionos.com> # for rnbd
