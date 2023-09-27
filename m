Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF0D7B0451
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Sep 2023 14:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjI0Mhi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Sep 2023 08:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjI0Mhh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2023 08:37:37 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DB8C0
        for <linux-bcache@vger.kernel.org>; Wed, 27 Sep 2023 05:37:35 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id 006d021491bc7-57bc2c2f13dso3103381eaf.2
        for <linux-bcache@vger.kernel.org>; Wed, 27 Sep 2023 05:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google; t=1695818255; x=1696423055; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B4aD1pEOXUFA+S6At0ObuizL8nGqT8u92FgMA+0lQPk=;
        b=WBUSbZZwvRipUUC5FI+kDnsCO3X2hTODHaiNBTfIy7rs1mgiReMaWcCLSYNjKJJa8x
         Lpbs02Se4+wH8PLHqTofRfrEbg9qg5x3cpfFaXWltSrdDV5WUd4ykVufxLvvrIXq5IHg
         nW/xiTDGwPmS+Vd4ClNFa8Af4HRokqy5+zzNxRcmveuMGJcrIpmzwFpGj2xFhffI8lCS
         g8wVJ/Ao4IuGzNGeI4wPUz4572JsMhKqfYL1koDkaBLLVSw5YjCrsN9Gz+dxDkFw/dg8
         abaqEBO2S8+D3KTMXLmZrtBKncF0w8hogApiLQ5qIZA+56JQIgm+oxaQNJ1i2An6aJGJ
         +E2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695818255; x=1696423055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B4aD1pEOXUFA+S6At0ObuizL8nGqT8u92FgMA+0lQPk=;
        b=B0IrjCsAhVt7iJAZ+jQpD6/rbDfCHEID2Y/l4jabs7mgSe1Y1APmvYGrUn//EZZf3j
         crEzP7ZLpMErDfx9/WBadqxkM31gj0q7dv42zB42bMtTyu4/YD03+Mkz1wizqnQs4MIW
         JK25oJrOAAp4iqJYfUqVrsjbDvkcooPal24KzA8KiG1wqghnB/pLNiCPOwAVlfHskK5l
         NvzbsQZxAuA6ITyV2XjXL69Yvs4opVt5F/xiAarq6+ObW7lEPA9K5WmXkoFydmpDk5G9
         hNrUSVNmWp+RgF80cDlkqoMinQWj/LnHORQ8saQOlJapMt/r2sdICu3Yz2zYjdTWalP+
         JfrQ==
X-Gm-Message-State: AOJu0YyNhmHIGJqvYvJNsufnHf9Nu2D3O63AMnAT0+9u6rkMVkm5KyF9
        17Fcr7cFrK7SWsuv+3Bqudtt+jePTgeRUqVWdJtAmw==
X-Google-Smtp-Source: AGHT+IFiKzL/Z3yD2ijiG3AEASIE5uaxALyug9nquOhVJ5UiFi+tkL2ALW5c7diUHMG/HBe4kafGLN0I+NV2W5y52Yw=
X-Received: by 2002:a4a:6f0b:0:b0:57b:38f1:7f69 with SMTP id
 h11-20020a4a6f0b000000b0057b38f17f69mr1799777ooc.4.1695818255152; Wed, 27 Sep
 2023 05:37:35 -0700 (PDT)
MIME-Version: 1.0
References: <4fd61b55-195f-8dc5-598e-835bd03a00ec@devo.com>
 <iymfluasxp5webd4hbgxqsuzq6jbeojti7lfue5e4wd3xcdn4x@fcpmy7uxgsie>
 <f3bbd0b9-1783-e924-4b8c-c825d8eb2ede@devo.com> <7BFB15E2-7FC6-40F8-8E26-8F23D12F2CD2@suse.de>
 <C02D29AF-02FB-4814-A387-E78E2CB52872@suse.de> <cfaa794e-e1b4-b014-c018-4e72457f554f@ewheeler.net>
In-Reply-To: <cfaa794e-e1b4-b014-c018-4e72457f554f@ewheeler.net>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Wed, 27 Sep 2023 14:37:23 +0200
Message-ID: <CAHykVA73jKsgd6AfyGDtAK_oYJLYvUPfiao_yZCdreKvJVr3_A@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: Unusual value of optimal_io_size prevents bcache initialization
To:     Coly Li <colyli@suse.de>
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Eric Wheeler <bcache@lists.ewheeler.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,
thank you for the patch, it worked:

NAME       SIZE MIN-IO OPT-IO SCHED RQ-SIZE
nvme15n1   3.9T   4096   4096 none       63
=E2=94=94=E2=94=80bcache3  3.9T    512   4096           128

$ cat /sys/block/nvme15n1/queue/optimal_io_size
4096

$ cat /sys/block/nvme15n1/bcache/stripe_size
4.0M

But I kind of agree with what Eric said:

On Tue, Sep 26, 2023 at 10:53=E2=80=AFPM Eric Wheeler <bcache@lists.ewheele=
r.net> wrote:
[snipped]
>
> This will create expensive unaligned writes on RAID5/6 arrays for most
> cases.  For example, if the stripe size of 6 disks with 64 k chunks has
> a size of 384 k, then when you round up to an even value of 4MB
> you will introduce a read-copy-write behavior since 384KB
> does not divide evenly into 4MB (4MB/384KB =3D~ 10.667).
>
> The best way to handle this would be to Use 4 megabytes as a minimum,
> but round up to a multiple of the value in limits.io_opt.
>
> Here is a real-world example of a non-power-of-2 io_opt value:
>
>         ]# cat /sys/block/sdc/queue/optimal_io_size
>         196608
>
> More below:
[snipped]

Waiting for your feedback,
Andrea
