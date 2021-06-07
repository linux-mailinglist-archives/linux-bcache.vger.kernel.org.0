Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7F739DCF1
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Jun 2021 14:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhFGMxN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Jun 2021 08:53:13 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44188 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhFGMxM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Jun 2021 08:53:12 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BEDCB21A90;
        Mon,  7 Jun 2021 12:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623070280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=AUw8vTiZNp6Gp9lNUc7R/ThVbtOHMDFQizRv+/53Q+k=;
        b=gSEvcX6UHtmzQg+uCr326ew5hWBiuQetPf3UaVmNMg36f4PliehK+iTy3SpkGzMH6ZThTF
        aepXlY3zLJ46WRgKSI1rq5UHv7PHqiEPL2bNG9jQxHM8EHEigDy5LtCSnqign8uJkb2VqM
        +y0wi0L48XeYLFLFCbQhEOvcFjOH6co=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623070280;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=AUw8vTiZNp6Gp9lNUc7R/ThVbtOHMDFQizRv+/53Q+k=;
        b=v6qH/br3XIbyy/Pc35b9ShWDl3NQl5XLCuocbNKQvcRifKF234PJKzDumaotaDPsBtlj9k
        BapFRLVXFUetWSDg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 4A07AA3B8A;
        Mon,  7 Jun 2021 12:51:02 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@lst.de, Coly Li <colyli@suse.de>
Subject: [PATCH v2 0/2] bcache fixes for Linux v5.13-rc6 
Date:   Mon,  7 Jun 2021 20:50:50 +0800
Message-Id: <20210607125052.21277-1-colyli@suse.de>
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
Series changelog:
v2, update with comments from Christoph Hellwig.
v1, initial submission for v5.13-rc6.
Coly Li (2):
  bcache: remove bcache device self-defined readahead
  bcache: avoid oversized read request in cache missing code path

 drivers/md/bcache/bcache.h  |  1 -
 drivers/md/bcache/request.c | 20 +++++++-------------
 drivers/md/bcache/stats.c   | 14 --------------
 drivers/md/bcache/stats.h   |  1 -
 drivers/md/bcache/sysfs.c   |  4 ----
 5 files changed, 7 insertions(+), 33 deletions(-)

-- 
2.26.2

