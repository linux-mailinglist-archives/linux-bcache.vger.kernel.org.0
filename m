Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665531E0CF8
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 13:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388696AbgEYLaX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 May 2020 07:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388136AbgEYLaX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 07:30:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E91FC061A0E;
        Mon, 25 May 2020 04:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=UF+mJ0+Cs0Lv3KwU8N/ssVHfdhiaXBBwzKToK1lfStc=; b=hwt9IINn+c7e0TQ5Vb7r4OAtsU
        QAlEQo2N7mTXfUby/97+fvfgsSnerxieE5v2HBe+1xqKCNsTHi8/0yMU6L/9Mj2LC3OshM6eRlbsB
        dlstA2Wlfh5mzl8WV5AxDHFVu9q0SXtqDbXBOvlZXPo1pQUssuScT3hL9mgbXLsR4lM8nM5NVFez0
        vSYqjmxcyRZjwKCdkoxDRM3FslVaTFpg9hgJpqGJkaoOveydcJNCxVcJC1PAXB4KI0ZrAAYjPcKUM
        e/Z4IIK/4EvJZOohJQm6sV/1dERY0rxhq9t1hkeGFLR2kYD1LoXorhdJXBCv65YuXq+xsm1YyTdQQ
        OkDNcpQQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdBJB-0002Mu-BA; Mon, 25 May 2020 11:30:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: block I/O accounting improvements
Date:   Mon, 25 May 2020 13:29:58 +0200
Message-Id: <20200525113014.345997-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

they series contains various improvement for block I/O accounting.  The
first bunch of patches switch the bio based drivers to better accounting
helpers compared to the current mess.  The end contains a fix and various
performanc improvements.  Most of this comes from a series Konstantin
sent a few weeks ago, rebased on changes that landed in your tree since
and my change to always use the percpu version of the disk stats.
