Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F29A87205
	for <lists+linux-bcache@lfdr.de>; Fri,  9 Aug 2019 08:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405189AbfHIGOO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 9 Aug 2019 02:14:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:58674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725989AbfHIGOO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Aug 2019 02:14:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E5F14AC67;
        Fri,  9 Aug 2019 06:14:12 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH v2 0/1] bcache fixes for Linux v5.3-rc4
Date:   Fri,  9 Aug 2019 14:14:04 +0800
Message-Id: <20190809061405.73653-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

I have a bug report that is frequent happens in product environment,
the problem was introduced in Linux v5.2, we should have the fix in
in Linux v5.3.

I add the missing 'Fixes:' field for the patch in v2.

Thanks in advance for taking this.

Coly Li 
---

Coly Li (1):
  bcache: Revert "bcache: use sysfs_match_string() instead of
    __sysfs_match_string()"

 drivers/md/bcache/sysfs.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

-- 
2.16.4

