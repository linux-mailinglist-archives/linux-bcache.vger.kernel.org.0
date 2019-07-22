Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EA9701F7
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Jul 2019 16:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbfGVOMs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 22 Jul 2019 10:12:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:55636 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729326AbfGVOMs (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 Jul 2019 10:12:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 70D99AEFD;
        Mon, 22 Jul 2019 14:12:47 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/1] bcache fix for Linux v5.3-rc2 
Date:   Mon, 22 Jul 2019 22:12:35 +0800
Message-Id: <20190722141236.103967-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Up to now we have one fix from Wei Yongjun for the patches merged in
Linux v5.3-rc1, which is for a possible memory leak when running a
cached device.

Thank you in advance, for taking it in v5.3-rc2.

Coly Li
---

Wei Yongjun (1):
  bcache: fix possible memory leak in bch_cached_dev_run()

 drivers/md/bcache/super.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
2.16.4

