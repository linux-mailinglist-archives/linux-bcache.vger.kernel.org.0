Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35273210795
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 11:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgGAJG6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 05:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgGAJG3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 05:06:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED599C03E979;
        Wed,  1 Jul 2020 02:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=dEDCWXfjhVQGOOrCUmr0J53WrGJ1BtJhis14QIiQIQk=; b=AhI5YsV13Iv7q6tUnnLzpio3XP
        uAnzpDzGCx6Ne6ojt9Q+KH1At6DZKdynwMnkdI7IGyo995agZAB2NSOTiBd+k3DHKYC8B4CLEtNKE
        TtveQ2NbJsuJBjtkhUCvdfcJHAfgI2c/EtuxG/XKf8oPBGJwkkW5zSkOe/ljCB8bu2JfgRYUCFnIe
        rydsCUFaIKQYUGqxkAEPTNu7R8xCBYr5/7/x0U6Sua8CbuGNZu7da7vhukC4ljxsIpqvwi+UcNaYv
        tJJ6g6Avyvsz13KgZDujJKiTYSeikkjJhpUn+t/sqWC6SJT1aq3a15v82WckDhWs2sK8ooGi2mECN
        62jUTcnA==;
Received: from [2001:4bb8:184:76e3:ea38:596b:3e9e:422a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYhF-0000hb-3M; Wed, 01 Jul 2020 09:06:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, dm-devel@redhat.com,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drbd: remove a bogus bdi_rw_congested call
Date:   Wed,  1 Jul 2020 11:06:19 +0200
Message-Id: <20200701090622.3354860-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701090622.3354860-1-hch@lst.de>
References: <20200701090622.3354860-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

bdi_rw_congested returns congestion state, so calling it without
looking at the return value doesn't make much sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_proc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 1c41cd9982a257..3c0193de249830 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -265,7 +265,6 @@ int drbd_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, "%2d: cs:Unconfigured\n", i);
 		} else {
 			/* reset device->congestion_reason */
-			bdi_rw_congested(device->rq_queue->backing_dev_info);
 
 			nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 			wp = nc ? nc->wire_protocol - DRBD_PROT_A + 'A' : ' ';
-- 
2.26.2

