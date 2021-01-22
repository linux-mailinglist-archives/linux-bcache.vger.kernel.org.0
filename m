Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D68B3009A4
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Jan 2021 18:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbhAVRYH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 22 Jan 2021 12:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729629AbhAVRPi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 22 Jan 2021 12:15:38 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08ECC06174A
        for <linux-bcache@vger.kernel.org>; Fri, 22 Jan 2021 09:14:57 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c6so7432813ede.0
        for <linux-bcache@vger.kernel.org>; Fri, 22 Jan 2021 09:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=1DQthhav8xNOL15t5ljxFFEen0OxXM121blVcOTuwoE=;
        b=DRVuRm4zJJlP4T8L4kZapdiGz5vP9VODwLyRxMLfe41n488Bz92a59l8JE6FO2x8Oc
         8bR3hkdstgU7LykD66k3BAZ26QaRMnw068cE1KsxzhgEsc4BfT6SZ/WloVpER2617MAb
         9SnNRA1JfP7mNbX+fiRBhemaSTQfjDVT4nI1vjdeN+x1lQYGw4Bs7AEctL/mi2RrQZku
         xM7RKsSwf5Rc5SDFqLUD1oNUxHzYz4bCVX9W7J4QE8+5QsSLlk/MjpVOx675xWI9zKSc
         WSw8hh/pgpSH9LhQ/fpgD+BrSgTZ1aZHHb190qjESciblH129Ze4fPhExWuJxsh9fus3
         61mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=1DQthhav8xNOL15t5ljxFFEen0OxXM121blVcOTuwoE=;
        b=nhE4ZyV+ml+AeBEujS1s8J86gGdvvBGuPLen36CL1XG3F89RrbRcpOcMP8+BT9JZOM
         Dysk+FVxvQlkVps53OxFjfc4Q1BO8QU5c12xAYfRcPtybV5cUktedgnolQS29IGwTRkB
         49ZPp7P5848i/K/gtKvWV1ryFZ4Z5otZpHH6hzo+f6wRTVq7Ewb/cOo3RVYumXtCtzLK
         kva0XyPNayuSzGOvJcmQupeFeaUGKzTxNpkHma1ST85H/PzPaJW4N8iJn4dCm4DfT9d5
         dAxoqompRZF4qAh04HyJWYB9uF5hl05GeKi1BVIkzqcao/XUmJs1hs0JaNgsOe3Fwahs
         Ijqw==
X-Gm-Message-State: AOAM533bxEsP/tJqMNYlFDQa7i7D+tKJkwC/qn4TJ7ki4VEQkcL4QRYP
        S/okHRrN27zNYDh7R/SUJUT4OY9A/UPHS6yM3P2989HodqnuSQ==
X-Google-Smtp-Source: ABdhPJzB03C3CuKzO+6Y96d3zpby3PmsbgDzWLarqu2TrtdRTnMGbdKHcKxp3De80BIjRi5+CWfuY39lOu34/nuCFuI=
X-Received: by 2002:a50:d80c:: with SMTP id o12mr3854783edj.338.1611335696212;
 Fri, 22 Jan 2021 09:14:56 -0800 (PST)
MIME-Version: 1.0
References: <CAKkfZL06PzvN6M+A+RC6C-eTL9uNReQTDbqHGRFbmRA9BzVUtQ@mail.gmail.com>
In-Reply-To: <CAKkfZL06PzvN6M+A+RC6C-eTL9uNReQTDbqHGRFbmRA9BzVUtQ@mail.gmail.com>
From:   Brendan Boerner <bboerner.biz@gmail.com>
Date:   Fri, 22 Jan 2021 11:14:44 -0600
Message-ID: <CAKkfZL1s_uLkcL=0-HSEtdV3XsC0UGGcM8c7hYdH7pFqcN6YcQ@mail.gmail.com>
Subject: Re: How to release backing device from bcache?
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Nm, user error.

Should have been using 'losetup -o 8192 /dev/loop0 /dev/dm-1'.

Thanks,
Brendan

On Fri, Jan 22, 2021 at 10:52 AM Brendan Boerner <bboerner.biz@gmail.com> wrote:
>
> How do I get bcache to completely give up access to a backing device
> so I can mount it using losetup?
>
> My backing device is an lvm logical volume which I expanded in size.
>
> I want to mount it using losetup to use xfs_growfs however I can't
> access the backing device:
>
> root@timber4:/var/log# umount /mnt/archives/ ; echo 1 >
> /sys/block/bcache1/bcache/stop ; echo 1 > /sys/block/dm-1/bcache/stop
> ; losetup -o 8192 /dev/loop0 /dev/vg-bfd02/archives_bc
> -bash: /sys/block/dm-1/bcache/stop: No such file or directory
> losetup: /dev/vg-bfd02/archives_bc: failed to set up loop device:
> Device or resource busy
>
> I know in some cases udev is scurrying in and causing the cache to be
> recreated but even immediately after the stop and before udev can get
> in the backing device is still locked:
>
> Jan 22 11:48:33 timber4 kernel: [370093.820204] XFS (bcache1):
> Unmounting Filesystem
> Jan 22 11:48:33 timber4 kernel: [370093.830609] bcache:
> bcache_device_free() bcache1 stopped
> Jan 22 11:48:33 timber4 systemd[1]: Stopped File System Check on
> /dev/disk/by-uuid/cb9c1149-73b8-4929-bcc6-d1599d41da73.
> Jan 22 11:48:33 timber4 kernel: [370093.904348] bcache:
> register_bcache() error /dev/dm-1: device busy
>
> I was able to do this in the past when I first started learning to use
> bcache which is why this is especially perplexing.
>
> Suggestions?
>
> Thanks,
> Brendan
