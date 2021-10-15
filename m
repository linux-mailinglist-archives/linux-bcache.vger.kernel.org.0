Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB442FED4
	for <lists+linux-bcache@lfdr.de>; Sat, 16 Oct 2021 01:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243533AbhJOXdD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 19:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243501AbhJOXdC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 19:33:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51855C061762;
        Fri, 15 Oct 2021 16:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=0/vUy76aoPqtosIeLCeI7X3UUbEJbC7MDQlzKX9/imU=; b=Qu5GFvduvjpL/149x5vJFhyA9d
        OHeXqOlyZYRjWN9OS2cCc07oQgdMYKnZtAKIhxuxO+HOF4yeuDfBrl9hts78YInLDdv4S1rButLnj
        ZW99/qMPGJ5nMZJ9n3SQjUlAws+mYXHbdvkvNeipgadm4ZCSQRzlOb/WRTd+64VXK3M5e5LsEEnb2
        H5xrHiyIX3qjAzKgsMAOhSEUf9hGBzS4i09QsHZ8LWqrneE0BVQm8yNdYbNWIfbGaMgIn4ks0Mer/
        aFrzChQyVK9ZQPEijiEBdBivuALzv2afyXywT/Z3bOHrCprGl8US5syTuD2h/pFd2RAHvysZ7I7mJ
        OJ+4BK4Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbWej-0095ur-55; Fri, 15 Oct 2021 23:30:29 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        agk@redhat.com, snitzer@redhat.com, colyli@suse.de,
        kent.overstreet@gmail.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, roger.pau@citrix.com,
        geert@linux-m68k.org, ulf.hansson@linaro.org, tj@kernel.org,
        hare@suse.de, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes.berg@intel.com,
        krisman@collabora.com, chris.obbard@collabora.com,
        thehajime@gmail.com, zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, miquel.raynal@bootlin.com, vigneshr@ti.com,
        linux-mtd@lists.infradead.org
Cc:     linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/9] block: reviewed add_disk() error handling set
Date:   Fri, 15 Oct 2021 16:30:19 -0700
Message-Id: <20211015233028.2167651-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Jens,

I had last split up patches into 7 groups, but at this point now
most changes are merged except a few more drivers. Instead of creating
a new patch set for each of the 7 groups I'm creating 3 new groups of
patches now:

  * This set, for which we already have an Acked-by or Reviewed-by tag,
    it would be nice to get clarification of driver maintainers want
    these to go through you or if a the maintainers want to pick these
    changes up themselves.

  * A second set will deal with patches which have no reviews done for
    them yet 

  * The last set deals with the __register_blkdev() change and the
    __must_check change which ensures we don't let in new drivers
    which don't deal with error handling.

If you're a maintainer of any of the below patches and wish for them to
go through Jens' tree directly now would be a good time to say so or
you can just pick the patch up yourself.

Luis Chamberlain (9):
  scsi/sd: add error handling support for add_disk()
  scsi/sr: add error handling support for add_disk()
  dm: add add_disk() error handling
  bcache: add error handling support for add_disk()
  xen-blkfront: add error handling support for add_disk()
  m68k/emu/nfblock: add error handling support for add_disk()
  um/drivers/ubd_kern: add error handling support for add_disk()
  rnbd: add error handling support for add_disk()
  mtd: add add_disk() error handling

 arch/m68k/emu/nfblock.c       |  9 +++++++--
 arch/um/drivers/ubd_kern.c    | 13 +++++++++----
 drivers/block/rnbd/rnbd-clt.c | 13 +++++++++----
 drivers/block/xen-blkfront.c  |  8 +++++++-
 drivers/md/bcache/super.c     | 17 ++++++++++++-----
 drivers/md/dm.c               |  4 +++-
 drivers/mtd/mtd_blkdevs.c     |  6 +++++-
 drivers/scsi/sd.c             |  8 +++++++-
 drivers/scsi/sr.c             |  7 ++++++-
 9 files changed, 65 insertions(+), 20 deletions(-)

-- 
2.30.2

