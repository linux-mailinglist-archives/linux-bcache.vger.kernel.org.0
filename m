Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5F4F59ED
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Apr 2022 11:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345860AbiDFJay (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 Apr 2022 05:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579179AbiDFJUU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Apr 2022 05:20:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861CB493CE3;
        Tue,  5 Apr 2022 23:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=3yxxX62Zo/mR0Xi79MnBUJxnWH3rNCgddJGJ/Fluyic=; b=xPwhKOzKRifzeLf33Ougm7j3R2
        9OOZnWBIUW9ywRPXYzADpSxAOJd+lc7Nw7PFDUE6dLbDnqAbJxYbqHABvtJLLVue+sw0/BD7jLpON
        W1PzcvOTfGWKPcyWyiJoa8fKNjy8rHR6OcLI6ZFYu12/xuetEqKA/rpKsNxdu9lQHQeOr5ydVzOgP
        Fr2RmExYOtvEtC783BVBrdtMNJLUMzEAMvbjwEGB3Vvz1513LvLpfZ5YHpp06ZknvjB+H6bXsW8d7
        XHKUN342G7HYiwT3OxHnACoiLWGPpO9UWWSV0Px73qlxnLWFAMaudqzlG4JJxazpkO+xYsHCirA9E
        Frp+ZxqA==;
Received: from 213-225-3-188.nat.highway.a1.net ([213.225.3.188] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nbyu6-003zG4-UT; Wed, 06 Apr 2022 06:12:31 +0000
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
Subject: cleanup bio_kmalloc v3
Date:   Wed,  6 Apr 2022 08:12:23 +0200
Message-Id: <20220406061228.410163-1-hch@lst.de>
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

Changes since v2:
 - rebased to 5.18-rc1
 - fix bio freeing in squashfs

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
