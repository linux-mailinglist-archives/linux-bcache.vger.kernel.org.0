Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDCB37079C
	for <lists+linux-bcache@lfdr.de>; Sat,  1 May 2021 17:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhEAPDD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 1 May 2021 11:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhEAPDD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 1 May 2021 11:03:03 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BDDC06174A
        for <linux-bcache@vger.kernel.org>; Sat,  1 May 2021 08:02:13 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id zg3so1411457ejb.8
        for <linux-bcache@vger.kernel.org>; Sat, 01 May 2021 08:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/4lx3vhI9OPNy4xU/NAiptZbcoUovt4hmA6Osh/CdG4=;
        b=DydsQEQpklve9eivXOOYacU0q94TgGwvfHjlLMeRJr3FKva7BHHXIOURQN5gKM0PwS
         syTfTiJEFAGiwx9752cq3O6xzXnWiQ1bpOefxcVMkkdZPN1BZDPnAUpOyNyRY9psKyXb
         iusmJTEQTCQ5pQyj2qrRRPipaWpi15Ubeya14HM8jS1fd6XOXQAxMHFKiuA+Ae1X96zl
         gf6ACODoszg28rupK7ROHHb/SDr9REsqXOTrZR/fj68jUhYYlDaxsW4mY6akM/ub5VXi
         fskjUpZmLh0fzoeNxDSSYKfrvpWNVwPSE6JiTv5tlugvKTSUoC/k2mpYGTrxB0OV6BO9
         jfkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/4lx3vhI9OPNy4xU/NAiptZbcoUovt4hmA6Osh/CdG4=;
        b=PXdUy9pg02p/PNCv/+4hfbXCJ8eDIRK/4y9/+l5gAVD/TAFVe67+d8m7nLIAFxyl4p
         aT/qnV8u9a1C3MUDlV7SAzbRPv7MBWa8CkRJOPWmF3eDkUyxh14vylwkWLUNIXhUgxyU
         Ycl/8C2nr9bvIAZyRFhZzUoEAEGVJokIYrSXqgkR7Kq7lbi76yvScbGS9rRpODwHlspQ
         1jYwiMAb2/YmwOl415Abt7ghNdLwSfbINDx727VCDOcwE4ea9iBBpMzrjKGtz6ZP797F
         37eOacNcMp4ZORVqPWmzURYrr6rIHV2xBRZZDOkngWuhTwA8zJn5IIDrYja2benJQooK
         CeZg==
X-Gm-Message-State: AOAM532jYVT8tmQkJqKw2n56EzRgu1B6cZzgoltSfhkSoPG7m/b8wfuj
        qWc1j0ZpJFD6F/79gCz6PwUjqj79Rqs=
X-Google-Smtp-Source: ABdhPJzk/UUcAQVOX884R6LQ4yPhUoGNFH8yAtQDkggAhVS3el4ZePuOlCxnAaOWzykgDGLhTsOkSA==
X-Received: by 2002:a17:906:3e89:: with SMTP id a9mr8927050ejj.405.1619881331446;
        Sat, 01 May 2021 08:02:11 -0700 (PDT)
Received: from exnet.gdb.it (mob-5-90-161-227.net.vodafone.it. [5.90.161.227])
        by smtp.gmail.com with ESMTPSA id f7sm5724879ejz.95.2021.05.01.08.02.10
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 May 2021 08:02:11 -0700 (PDT)
From:   Giuseppe Della Bianca <giusdbg@gmail.com>
To:     linux-bcache@vger.kernel.org
Subject: [BACKING DEVICE] Resize
Date:   Sat, 01 May 2021 17:01:54 +0200
Message-ID: <2068977.irdbgypaU6@exnet.gdb.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi.

This is the procedure I used for resize one backing device with btrfs filesystem from 1 to 10 GB.

The technique used is
- Move the start of the partition forward (offset 8192) and set the partition type.
- Perform the resize.
- Move back the beginning of the partition and reset the partition type.


Backup data!!


The backing device /dev/sdc7 is a last logical partition with btrfs filesystem.

Stopping bcacheX device and/or unregister /dev/sdc7 backing device.
With bcache show verify that the device is no longer in use.


parted /dev/sdc unit B print
7		574412029952B	575491014655B   logical 


bd	0	574412029952B	575491014655B   logical
fs	8192	574412038144B	575491014655B   logical   btrfs
		
		
parted /dev/sdc
unit B
print
rm 7
mkpart logical btrfs 574412038144B 575491014655B
quit


reboot


gparted resize partition


parted /dev/sdc unit B print
7      		574412038144B	585151545343B   logical   btrfs


fs	8192	574412038144B	585151545343B   logical   btrfs
bd	0	574412029952B	585151545343B   logical


parted /dev/sdc
unit B
print
rm 7
mkpart logical 574412029952B 585151545343B
quit

gdb


