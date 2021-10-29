Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E23143F6F5
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Oct 2021 08:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhJ2GMD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Oct 2021 02:12:03 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:38796 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhJ2GMC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Oct 2021 02:12:02 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1C33321968;
        Fri, 29 Oct 2021 06:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635487774; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=WhzDd96nzOHiE2906ADz7sOy5TbCepmSxuDcsXYmAyQ=;
        b=Zqfly7K/SloZrOfelxrE399AEwZP8gCpCBUJIJqGHnIq2bjViY5UfZFIwdpqUkkQ7CV9hE
        qsJ1sdqIoLzLpdbZnv8mhFeJ49anWnGBECjdZ7Wqzbw/cp0+Su+jUTQ1VQ6Ias7g/+E0Yq
        xaTNCjkKiZUGiy8Zl7tYx3CDEXq815g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635487774;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=WhzDd96nzOHiE2906ADz7sOy5TbCepmSxuDcsXYmAyQ=;
        b=EkHZp1y1EjnnMnPdPAo0AFwIaaMl3zotI14C8sG/9AMqXScCLwrXv8W3JxZxPQwnT+tBX7
        Mf3F8CIEoUFvmsAw==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id A7689A3B83;
        Fri, 29 Oct 2021 06:09:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/2] bcache paches for Linux v5.16 (2nd wave)
Date:   Fri, 29 Oct 2021 14:09:28 +0800
Message-Id: <20211029060930.119923-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This is the second wave of bcache patches for Linux v5.16.

The first patch is suggested by Arnd Bergmann and Christoph
Hellwig that the bcache.h should not belong to include/uapi/
directory, and I compose the change.

The second patch is code cleanup to remove coccicheck warning
which suggests to use scnprintf to replace snprintf(), Qing
Wang posts the change to remove the warning by using sysfs_emit().

Please take them for Linux v5.16 and thanks in advance.

Coly Li 
---

Coly Li (1):
  bcache: move uapi header bcache.h to bcache code directory

Qing Wang (1):
  bcache: replace snprintf in show functions with sysfs_emit

 drivers/md/bcache/bcache.h                     |  2 +-
 .../md/bcache/bcache_ondisk.h                  |  0
 drivers/md/bcache/bset.h                       |  2 +-
 drivers/md/bcache/features.c                   |  2 +-
 drivers/md/bcache/features.h                   |  3 ++-
 drivers/md/bcache/sysfs.h                      | 18 ++++++++++++++++--
 drivers/md/bcache/util.h                       | 17 -----------------
 7 files changed, 21 insertions(+), 23 deletions(-)
 rename include/uapi/linux/bcache.h => drivers/md/bcache/bcache_ondisk.h (100%)

-- 
2.31.1

