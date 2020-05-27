Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD351E3826
	for <lists+linux-bcache@lfdr.de>; Wed, 27 May 2020 07:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgE0F0C (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 May 2020 01:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbgE0FYa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 01:24:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E78C061A0F;
        Tue, 26 May 2020 22:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=dJGZntVcW6cIG2lSncQfYFsGYe54mFNTI2kksX7wjkw=; b=Gx+Qc/daipt8RPO+r8id9gztxi
        Vteb8LMs4zXEDORmD+fyEMjSsBt6uIsIbBcQcQMCHQfx5ZPk130XPqxuL5xoG7ulKVYOEhpHkYHuv
        5hl1LMsAij9x/e5CnfRgBhxh/kO5GfiHa4AYylNh6rKP/x0SsOQf1sWZn/gOaO6QLBgkTG+JXvCfX
        8nUyJBg0eUXIjVyli3n2Lq0k1k22bkKOiap1xPNR5nAGhYxfB8RkqLZa43VhL6ewW5QDaIztVrsop
        rLrrKolV0WGsf2AaRGcZxXm3hNXXjPDL9E+Z8Q4wFj54mCUj31zq4i/8zwKN5vBJiM6dpmRG4CNGA
        ZYjXVKcQ==;
Received: from [2001:4bb8:18c:5da7:8164:affc:3c20:853d] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdoY9-0000me-A3; Wed, 27 May 2020 05:24:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: block I/O accounting improvements v2
Date:   Wed, 27 May 2020 07:24:03 +0200
Message-Id: <20200527052419.403583-1-hch@lst.de>
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


Changes since v1:
 - add an ifdef CONFIG_BLOCK to work around the sad state of our headers
 - add reviewed-by tags to all patches
