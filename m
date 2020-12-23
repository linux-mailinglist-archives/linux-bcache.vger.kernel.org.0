Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AAF2E1DB7
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 16:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbgLWPGM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 10:06:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:58138 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgLWPGL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 10:06:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 912A3AD11;
        Wed, 23 Dec 2020 15:05:30 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/2] bcache second wave patches for Linux v5.11 
Date:   Wed, 23 Dec 2020 23:04:20 +0800
Message-Id: <20201223150422.3966-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Here are the second wave patches for Linux v5.11. Especially the patch
from Yi Li is a fix of a regression in this merge window.

Please take them, and thank you in advance.

Coly Li
---

Yi Li (1):
  bcache:remove a superfluous check in register_bcache

Zheng Yongjun (1):
  md/bcache: convert comma to semicolon

 drivers/md/bcache/super.c | 2 --
 drivers/md/bcache/sysfs.c | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

-- 
2.26.2

