Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A442A1445
	for <lists+linux-bcache@lfdr.de>; Sat, 31 Oct 2020 10:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgJaJAm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 31 Oct 2020 05:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgJaJAm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 31 Oct 2020 05:00:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66EFC0613D5;
        Sat, 31 Oct 2020 02:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=m3FemkF6DNOHQ5D48308QA5xeoyXDyaeiceI36E77rM=; b=P8zIXf0ClaVZSlArFCi1K9v3vC
        gkxA94Uro1RF/+GgDyh9vEPwj3Y72/9SSEANZP02i5TvMe10LymbYkPYG6DMc5IDnGBjgQTalEvkc
        7TXnyFUT/j8iHkPcOXM8bZe6ReIb5uXby+YJuLwffRMuoJeVVR4je0nhesz/osz/s3vHOrEWnHbJg
        bhdDx2zoZWldSKltR8JTd7fM6O5mYbGvdN2dy0IKqcHTIM0OnVwHhznWyotA9VltkfkHOEYK1UAzy
        7nL8Sv4tjRi5d0AaEOTRMJmaYjKsZ84BKBO1I6yshpTLLvLz/fqIiFFddRo3CEr/BUnU26g1h076k
        j9lwYORg==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYmkI-0006r3-1O; Sat, 31 Oct 2020 09:00:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: block ioctl cleanups
Date:   Sat, 31 Oct 2020 09:57:59 +0100
Message-Id: <20201031085810.450489-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

this series has a bunch of cleanups for the block layer ioctl code.

Diffstat:
 block/genhd.c                     |    7 ----
 block/ioctl.c                     |   62 ++++++--------------------------------
 drivers/block/loop.c              |    2 -
 drivers/block/mtip32xx/mtip32xx.c |   11 +-----
 drivers/block/pktcdvd.c           |    6 ++-
 drivers/block/rbd.c               |   41 ++-----------------------
 drivers/md/bcache/request.c       |    5 +--
 drivers/md/dm.c                   |    5 ++-
 drivers/md/md.c                   |   62 +++++++++++++++++++-------------------
 drivers/mtd/mtd_blkdevs.c         |   28 -----------------
 drivers/s390/block/dasd.c         |    1 
 drivers/s390/block/dasd_int.h     |    3 +
 drivers/s390/block/dasd_ioctl.c   |   27 +++++-----------
 include/linux/blkdev.h            |    3 -
 include/linux/genhd.h             |    1 
 15 files changed, 73 insertions(+), 191 deletions(-)
