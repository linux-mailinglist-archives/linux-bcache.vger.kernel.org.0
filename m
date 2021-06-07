Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB9739D9CF
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Jun 2021 12:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFGKiA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Jun 2021 06:38:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59282 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbhFGKh7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Jun 2021 06:37:59 -0400
Received: from relay2.suse.de (unknown [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AD51A21A89;
        Mon,  7 Jun 2021 10:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623062167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=7KRZzIp9SBa+avBj89zyiHunlitU12DocrNCTKIlu3I=;
        b=PrIkOJZPLdIQ0JNb77pAXCvd+tyCjiZqQ/ItJxknYRs4R/EcTxvDd4+ZOBVwREVpqlZXJN
        +pFdXemvUFKO6FGANTmJsVFARGQ2Bfvo8kIHfR071ato7XUBQUm4uGek28ZoKR/DZQCOYe
        a9/dpJunTjQhFKM1deqJTY5xJJK7VGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623062167;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=7KRZzIp9SBa+avBj89zyiHunlitU12DocrNCTKIlu3I=;
        b=Z8/i0DHbr/GVdpHhUkFHEwLvcXjmWx5qL8MXeRGBTXyRDRkV0U58eLHeK1KZsga3k1C0o7
        S0sgmC+pFGXlpPAQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 1D824A3B87;
        Mon,  7 Jun 2021 10:36:05 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 0/2] bcache fixes for Linux v5.13-rc6
Date:   Mon,  7 Jun 2021 18:35:37 +0800
Message-Id: <20210607103539.12823-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This series is important for recent reported bcache panic partially
triggered by recent bio changes since Linux v5.12.

Current fix is 5th version since the first effort, it might not be
perfect yet, but it survives from different workloads from Rolf,
Thorsten and me for more than 1 week in total.

Considering many people are waiting for a stable enough fix and it is
kind of such fix. Please take them for Linux v5.13-rc6.

Thank you in advance for taking care of them.

Coly Li
---

Coly Li (2):
  bcache: remove bcache device self-defined readahead
  bcache: avoid oversized read request in cache missing code path

 drivers/md/bcache/bcache.h  |  1 -
 drivers/md/bcache/request.c | 19 ++++++-------------
 drivers/md/bcache/stats.c   | 14 --------------
 drivers/md/bcache/stats.h   |  1 -
 drivers/md/bcache/sysfs.c   |  4 ----
 5 files changed, 6 insertions(+), 33 deletions(-)

-- 
2.26.2

