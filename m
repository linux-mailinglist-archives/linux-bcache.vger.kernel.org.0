Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372EA67C9EC
	for <lists+linux-bcache@lfdr.de>; Thu, 26 Jan 2023 12:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbjAZLa4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 26 Jan 2023 06:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbjAZLaz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 Jan 2023 06:30:55 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0625A80A
        for <linux-bcache@vger.kernel.org>; Thu, 26 Jan 2023 03:30:54 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id bm8so1172544oib.0
        for <linux-bcache@vger.kernel.org>; Thu, 26 Jan 2023 03:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3FEmAzu7znoIHaI+nQkzYP9e0Ox/qFflESLYOQND9Fs=;
        b=if8mgGu61UkCSnEB62hgbOhgTBg0k3+bciLp3GJa8I2VPNTAf5sBVH3OLohbwflJ6W
         ldUJcUTVyitaTLLLMU2HvvHQw20u8OrhaWj3FEObVjVAk3TUNzg7W/Z5J6XmHE2M08ga
         NDB+yBdAm7S0T4di/ca43cWAbjPCPcXuQeMFAJi+90H5pAh1L2eGgiPQmOKgO51xjJtE
         ra5LsuPpfDa9pjiUlV9M8JijyUAJ4sl/9Uh71UdPl4Lwtp4uXnadb+LQhFuDCcoB0497
         CMhsedhZUIjW90le60M2XzjSiZrzcnSdfRzc7sv1JdaNSkJ15qc94NQIzwUC9Uv3mSpV
         ggDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3FEmAzu7znoIHaI+nQkzYP9e0Ox/qFflESLYOQND9Fs=;
        b=MQ0TJ5SWcgCRVN5xHDIymXOsJO/UZVWbv1b851YctHAB+RVom3OD+jzUrAYG9eEJQ8
         8pS6kYynbS8H5sF+H0UB/mgZ5WFASCBH2pXj+Y+cKvqLrfpZZIrCtVDzz5gd3hS+gi0/
         vDzGVVVPuvcNJJQA4jzgz6SV9xfx91B9qJI/qrKXSyiLbotiUpwk+VXoaST+UCpxOQJU
         w4BwD5XL3UKmaU0k+heNU5LgW044X5z0POSIpkl/cZsEV1Ey6JQNtdH7LTnajn77vjAR
         1E7MPsMobtAy+1Jzw7a9pFdVGOjNvaUdEzcqCevq4KaD0S2cmKfwHyrQbgm1lFbLRIwC
         sVog==
X-Gm-Message-State: AFqh2kojcX89xKTaJ7M/Pf77s/c+0B66AUfJQZL61WSK8fphHzLFmngo
        4K8tOJayyS6JNYq1mC9obsvUP0DqLrcEGiaVEUWvHQ==
X-Google-Smtp-Source: AMrXdXvvl6zszSrkM5iT1mxo4iFzeRt8575emiNBKqsDOTcIv9MR8XU4w6Wx4B4qVcxIolBRYLDpmH+4BEtunu33T6Y=
X-Received: by 2002:a05:6808:4097:b0:35e:2720:e5e1 with SMTP id
 db23-20020a056808409700b0035e2720e5e1mr1426064oib.230.1674732653600; Thu, 26
 Jan 2023 03:30:53 -0800 (PST)
MIME-Version: 1.0
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Thu, 26 Jan 2023 12:30:42 +0100
Message-ID: <CAHykVA6L3bQkGJ11N3jG_QSgPbyr40zc8rBNPPwBN9a5RHwC6Q@mail.gmail.com>
Subject: Multi-Level Caching
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,
I know that bcache doesn't natively support multi-level caching but I
was playing with it and found this interesting "workaround":
  make-bcache -B /dev/vdb -C /dev/vdc
the above command will generate a /dev/bcache0 device that we can now
use as backing (or cached) device:
  make-bcache -B /dev/bcache0 -C /dev/vdd
This will make the kernel panic because the driver is trying to create
a duplicated "bcache" folder under /sys/block/bcache0/ .
So, simply patching the code inside register_bdev to create a folder
"bcache2" if "bcache" already exists does the trick.
Now I have:
vdb                       252:16   0    5G  0 disk
=E2=94=94=E2=94=80bcache0                 251:0    0    5G  0 disk
  =E2=94=94=E2=94=80bcache1               251:128  0    5G  0 disk /mnt/bca=
che1
vdc                       252:32   0   10G  0 disk
=E2=94=94=E2=94=80bcache0                 251:0    0    5G  0 disk
  =E2=94=94=E2=94=80bcache1               251:128  0    5G  0 disk /mnt/bca=
che1
vdd                       252:48   0    5G  0 disk
=E2=94=94=E2=94=80bcache1                 251:128  0    5G  0 disk /mnt/bca=
che1

Is anyone using this functionality? I assume not, because by default
it doesn't work.
Is there any good reason why this doesn't work by default?

I tried to understand how data will be read out of /dev/bcache1: will
the /dev/vdd cache, secondly created cache device, be interrogated
first and then will it be the turn of /dev/vdc ?
Meaning: can we consider that now the layer structure is

vdd
=E2=94=94=E2=94=80vdc
       =E2=94=94=E2=94=80bcache0
             =E2=94=94=E2=94=80bcache1
?
