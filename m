Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49BB63732D
	for <lists+linux-bcache@lfdr.de>; Thu, 24 Nov 2022 08:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiKXH5w (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Nov 2022 02:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKXH5v (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Nov 2022 02:57:51 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EAF24967
        for <linux-bcache@vger.kernel.org>; Wed, 23 Nov 2022 23:57:50 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id d185so864870vsd.0
        for <linux-bcache@vger.kernel.org>; Wed, 23 Nov 2022 23:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YN923+FF4L0K3je15EIDXGie6Cn6n7nLArNRpU07/B0=;
        b=Qz7xMXZhpqqZ7hmB1JTL5RjflzVC/wOqePULARlrRjpzwvwQX1ZoXfSIuyJ5ZwS41Y
         A9beCobZGyer1emfJvR8Q7qiqid3GMrcrJluUpEv0S4yZy+XOeRnnANEfUAOe8FYb2ec
         SVtxHyX6bhQvcS5Fv6xxLU6+Gqguhy86GLyk0i9kEZwWTaPOBIY9nWml//M+k5Z+4Ve1
         uSWJ4/x7yzfPWDFt7KBp4m/YjACSshtLlT7kdTTII2YSUsJOo4CgZgzhNlRKVe/Qxjjc
         hU/JMjFsa5vPXdPDpAb3IwW2h1RD+GOWaOn+wuLtKoQ6S99ViQNVcOeJbIaOk94syduG
         tEUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YN923+FF4L0K3je15EIDXGie6Cn6n7nLArNRpU07/B0=;
        b=uK9jEIc0selNCoN9SpOmP8TazPRkcSHGuaxmjoh7MzpSdnbUmelNjg/0iuVWQvtaY4
         m8PyciUGW+w4T6cyJOpAecVPhumljbrCPh0f7A1fa5y0ed5pxMLdIHQ12a4LfYfSW+ez
         Pdquwt+H/FH+v54GJERLm8yjTi+Nkdi8URMD9BWn/QnvJTApmiYBfpGIdOkOQhhDycyQ
         M6yeof9uu8ro8b/14GXV7bq5dRLSw9XeCTeOxSbM+yfrCuCyUZpkKlRVcz+lF88ulffD
         XewNcr0pseNOIyD0P7jUnEU/+Z/29hJ4L0DJjiQbDHPwbiC0hUR3UiK5IUH1eKdI+Mrk
         0Jvg==
X-Gm-Message-State: ANoB5pkoOGinXW434tLYyn23NUn6cTxxMzxLIu0xTTcLfEI8FgenPXYZ
        w7zdahDiQz01deqgcWF4BhHrZedppkyrnUjqxhAIwufQnmA=
X-Google-Smtp-Source: AA0mqf56LFAk+kREHoFpUPNRgxW7hZPBjOV3mcjXI6RyVGtdJkNdBUeZ0MJrc1K2P0Y+mAy3BociPVdoITPH4mDXJc4=
X-Received: by 2002:a05:6102:2459:b0:3ac:70f4:6ecd with SMTP id
 g25-20020a056102245900b003ac70f46ecdmr7551084vss.69.1669276669203; Wed, 23
 Nov 2022 23:57:49 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?6Kix6ICA5a6X?= <yaozhonghsu@gmail.com>
Date:   Thu, 24 Nov 2022 15:57:38 +0800
Message-ID: <CABeQj8kYqMFVZ3OOAT9svsXg-GHTJC+N6G4_gtGmBwoC0=xseg@mail.gmail.com>
Subject: bcache: Data is inconsistent when the cache device failed in
 writearound mode
To:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com
Cc:     everest@synology.com, norrishsu@synology.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi linux-bcache,

I was evaluating the performance and stability of bcache.
In my test environment, I was using bcache as a read cache in
writearound cache mode running on OS ubuntu 20.04 with linux kernel
5.15.
However, I found that sometimes the data was inconsistent, and here is
how to reproduce:

1. Set up bcache with 1 hard drive and 1 read cache

    $ make-bcache -B /dev/sdb -C /dev/sdc

2. Set as writearound mode

    $ echo "writearound" > /sys/block/bcache0/bcache/cache_mode

3. Create XFS on /dev/bcache0

    $ mkfs.xfs -m reflink=0 -f /dev/bcache0

4. Mount the file system

    $ mkdir /srv/node/ -p
    $ mount -t xfs /dev/bcache0 /srv/node -o
rw,nofail,noexec,nodev,noatime,nodiratime,inode64,logbsize=256k

5. Prepare a 50G file with random content

    $ head -c 50G < /dev/urandom > 50G

6. Get md5sum of this 50G file

    $ md5sum 50G
    99c91956af4eec68707b329902062bfd

7. Copy the 50G file to the mount point

    $ cp 50G /srv/node/

8. During the copy operation, remove the cache device manually

    $ echo 1 > /sys/block/sdc/device/delete

9. Wait for the copy operation done, then calculate md5sum of 50G file
in the destination

    $ md5sum /srv/node/50G
    bb178bbb9c0ca07c202580e3ea9e62c5

The result shows the md5sum of two 50G file are not the same.
As far as I know, no data is written to cache device in writearound
mode. Therefore a failed cache device should not cause any data
inconsistency.

There are some further observations,
1. I can reproduce it with kernel 5.04 / 5.14.
2. I can reproduce it with ubuntu 22.04.
3. I cannot reproduce if the file is not large enough, like 10G and 20G.

Please advise me how to fix it. Thank you.

Sincerely,
Norris Hsu
