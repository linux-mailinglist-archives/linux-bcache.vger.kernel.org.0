Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5674E41A1DF
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Sep 2021 00:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbhI0WCp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Sep 2021 18:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237805AbhI0WCc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Sep 2021 18:02:32 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698EEC06177D;
        Mon, 27 Sep 2021 15:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=f1z5HgkOwmjFBk4lUYxpkBwDgNqINDcFoZThfyywwx8=; b=eQhJDUwgI2a4kvwwC1LW4Grcbe
        Afldl7Y/5P+CtLt6Bf7Y9ytxFLTlAL7DQ1mrwOtj6+6Pnddn8Wp4NkxVuxqvoNw0Tyz5tv3XvMzt/
        95ad2a+T3zdPfY1HqSNzUwK9FALGPXQfHChw080YZLrustezGq9sWxl4CDGODiD+GUg6c3Ya2VpOL
        Lz+0XMYtVA7Q3XN0iSeVnjb/6bCKu9f0aIxF7V2Oxq68qH0zcltU5tGD/tQ+xGADbb+jbit4yqFIv
        EQ6Wyv4G24Wl6sIzPggmISuK4WSugRZrguNrS2KSbhhqFI7oFTnyVJEEiHe4GjAGQLWYlZNDx3Kcq
        wpi9PwkQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyfw-004SuN-7t; Mon, 27 Sep 2021 22:00:40 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
        kbusch@kernel.org, sagi@grimberg.me, vishal.l.verma@intel.com,
        dan.j.williams@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, konrad.wilk@oracle.com, roger.pau@citrix.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, minchan@kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Cc:     xen-devel@lists.xenproject.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 00/10] block: second batch of add_disk() error handling conversions
Date:   Mon, 27 Sep 2021 15:00:29 -0700
Message-Id: <20210927220039.1064193-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is the second series of driver conversions for add_disk()
error handling. You can find this set and the rest of the 7th set of
driver conversions on my 20210927-for-axboe-add-disk-error-handling
branch [0].

Changes on this v2 since the last first version of this
patch series:

  - rebased onto linux-next tag 20210927
  - nvme-multipath: used test_and_set_bit() as suggested by Keith Busch,         
    and justified this in the code with a comment as this race was not
    obvious
  - Added reviewed-by / Acked-by tags where one was provided 

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210927-for-axboe-add-disk-error-handling

Luis Chamberlain (10):
  block/brd: add error handling support for add_disk()
  bcache: add error handling support for add_disk()
  nvme-multipath: add error handling support for add_disk()
  nvdimm/btt: do not call del_gendisk() if not needed
  nvdimm/btt: use goto error labels on btt_blk_init()
  nvdimm/btt: add error handling support for add_disk()
  nvdimm/blk: avoid calling del_gendisk() on early failures
  nvdimm/blk: add error handling support for add_disk()
  xen-blkfront: add error handling support for add_disk()
  zram: add error handling support for add_disk()

 drivers/block/brd.c           | 10 ++++++++--
 drivers/block/xen-blkfront.c  |  8 +++++++-
 drivers/block/zram/zram_drv.c |  6 +++++-
 drivers/md/bcache/super.c     | 17 ++++++++++++-----
 drivers/nvdimm/blk.c          | 21 +++++++++++++++------
 drivers/nvdimm/btt.c          | 24 +++++++++++++++---------
 drivers/nvme/host/multipath.c | 13 +++++++++++--
 7 files changed, 73 insertions(+), 26 deletions(-)

-- 
2.30.2

