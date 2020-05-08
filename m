Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4551CB486
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 18:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgEHQPi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 12:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbgEHQPg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0866C061A0C;
        Fri,  8 May 2020 09:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Es4eIMqxlcHTpRumUrbJ++gZhpS818l1WN5FHjjMEjU=; b=bPwC4QVd0Eqoqu/0a+YLSeqq6G
        y3Ac6OeS7pyYIvXRuJ1Q1r8hldlCe1EyFxndwC6/UraMbV3XVZvIqbPYeCd5sGITrXAIxDNXAGQUW
        yZp4CytLymAXVg8Itk+HF3vSnQYDL2aEs5HHWvuQT/9u8WcWUgP3a6UsxHxFUCSXefc0ZOB92ORqu
        p2J+yQbrrAa18myCM+1A5S2RAbMs1QtGw3SppGzhKmy3I7wNMrzkeLRctZpWN3/RDMn+XM88t1UK7
        d9WLPbt4BVV7ADYNKYz+1OpEtXJFhYJsMyjG9PKK6MKBcvwLmtY5ZPUUd3vITVwYSJiyK9m0mJk6z
        xYopxSug==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5eh-0004MH-Mi; Fri, 08 May 2020 16:15:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org
Subject: remove a few uses of ->queuedata
Date:   Fri,  8 May 2020 18:15:02 +0200
Message-Id: <20200508161517.252308-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi all,

various bio based drivers use queue->queuedata despite already having
set up disk->private_data, which can be used just as easily.  This
series cleans them up to only use a single private data pointer.

blk-mq based drivers that have code pathes that can't easily get at
the gendisk are unaffected by this series.
