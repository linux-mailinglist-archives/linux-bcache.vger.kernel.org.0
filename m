Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92B34D0FDE
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Mar 2022 07:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344393AbiCHGRI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 8 Mar 2022 01:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244567AbiCHGRG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Mar 2022 01:17:06 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790472E6BE;
        Mon,  7 Mar 2022 22:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=9tb4TIpuLITxxgZ/5zuJDTRYiPC0WStlucP3wP8AsAg=; b=kAZwwzrVV8MatkfAj1oNP7pxT4
        Ffr2eKt6CrpedeoZBJZ4LHavIqKry6c4hMXlUI5GeZkr73kZDW9xJHD+XtpP1r2IeKfTgRr38S6GA
        uTR9RDbQ7/mTQmmy4+ZxGY898ogr5EgfFsq6/mVPHwGq25IwMe7mrDkxX4rlj51AIcZlzYsSN5pBX
        6eeuigLJL1a48af6gUUArPm8Hogopt/sA5YhfWjpOe8FmUY5XCHPxouwJwMzkiamlvmhMx3slopdL
        iMu42zFH8d8gw5QVon9OJHqrt7aFhbsZFRrrt7Gjmv2EG8zUiS/Ij6PJIqkLtIc2EKIXHK3T513PT
        jdvBNUfg==;
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRT8T-002lVK-RU; Tue, 08 Mar 2022 06:15:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: cleanup bio_kmalloc v2
Date:   Tue,  8 Mar 2022 07:15:46 +0100
Message-Id: <20220308061551.737853-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

this series finishes off the bio allocation interface cleanups by dealing
with the weirdest member of the famility.  bio_kmalloc combines a kmalloc
for the bio and bio_vecs with a hidden bio_init call and magic cleanup
semantics.

This series moves a few callers away from bio_kmalloc and then turns
bio_kmalloc into a simple wrapper for a slab allocation of a bio and the
inline biovecs.  The callers need to manually call bio_init instead with
all that entails and the magic that turns bio_put into a kfree goes away
as well, allowing for a proper debug check in bio_put that catches
accidental use on a bio_init()ed bio.

Changes since v1:
 - update a pre-existing comment per maintainer suggestion

Diffstat:
 block/bio.c                        |   47 ++++++++++++++-----------------------
 block/blk-crypto-fallback.c        |   14 ++++++-----
 block/blk-map.c                    |   42 +++++++++++++++++++++------------
 drivers/block/pktcdvd.c            |   34 +++++++++++---------------
 drivers/md/bcache/debug.c          |   10 ++++---
 drivers/md/dm-bufio.c              |    9 +++----
 drivers/md/raid1.c                 |   12 ++++++---
 drivers/md/raid10.c                |   21 +++++++++++-----
 drivers/target/target_core_pscsi.c |   36 ++++------------------------
 fs/btrfs/disk-io.c                 |    8 +++---
 fs/btrfs/volumes.c                 |   11 --------
 fs/btrfs/volumes.h                 |    2 -
 fs/squashfs/block.c                |   14 +++--------
 include/linux/bio.h                |    2 -
 14 files changed, 116 insertions(+), 146 deletions(-)
