Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953983E4053
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Aug 2021 08:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhHIGmu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Aug 2021 02:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbhHIGmt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Aug 2021 02:42:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639E3C0613CF;
        Sun,  8 Aug 2021 23:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=gu/wdO3pWcEV2DnoEvj5RVwNNwRwRD9cxQPKa/ARsu8=; b=mYVZtFcPQ4+E3YBX+sTHOUPIrO
        J2Bmm0o9TrUkEYjnnOoWqM+nxwMfA7G1aakmWt0bftItoCGMg7h/ssgKVMBDxZu/BaoylRTvgnMfR
        fhDTXTSYc2+kErta8SH6dFjBhtjzsz2cXsilz0MMeqHi3uGYO+oayBPgp5YykjqCIlc3zZByQpbvu
        VHTnwLHi1CnPz9ExfGgCWcpaHZFE7y4OUL2Jci7lYjTpjxrbObXMiJttFrqy0v0IyBeAxelCUxMir
        gQ4ZJE3NgEI13hQHqKPBSkPMooG9toraV08VDFjqLQXUTWMmjFfB3tsCA7oxWIDMHKaDieyXinM+4
        a4TE0ONQ==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCyxZ-00AiWj-9Y; Mon, 09 Aug 2021 06:40:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: remove GENHD_FL_UP
Date:   Mon,  9 Aug 2021 08:40:20 +0200
Message-Id: <20210809064028.1198327-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

this series first cleans up various drivers to not rely on the
internal GENHD_FL_UP to decided if they need to call del_gendisk
and then removes the flag entirely.

Diffstat:
 block/genhd.c                 |    6 -
 block/partitions/core.c       |    4 -
 drivers/block/sx8.c           |    2 
 drivers/md/bcache/super.c     |   26 ++++---
 drivers/md/md.h               |    4 -
 drivers/mmc/core/block.c      |  143 +++++++++++++++++-------------------------
 drivers/nvme/host/core.c      |   16 ++--
 drivers/nvme/host/multipath.c |    2 
 fs/block_dev.c                |    2 
 include/linux/genhd.h         |    9 +-
 10 files changed, 93 insertions(+), 121 deletions(-)
