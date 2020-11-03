Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AC12A411A
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Nov 2020 11:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgKCKCo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Nov 2020 05:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbgKCKCn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Nov 2020 05:02:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2A6C0613D1;
        Tue,  3 Nov 2020 02:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=S/Jxk7MFf2zbVP/damMG5Y193FQbU20LLKNaS6lR0JA=; b=pt2TkrYFBvf569C8qUtEMmCObo
        S6uiERBt8/clyVA7CszFdSsP5FrpXEE+LecQyWkyAqOCoRq3m5neRKOw5CpcmoO8AmlaHhC09YzC2
        ZZvFYYl64sy59qEDwR7KC/xXWTnw92UFtcFLK6lQL3RBYaCoPZzaj6xjrDVbofVRG2owy09SUgiYX
        iw9Xg28CmpxtMtjxsafQU4w0iCAJFNkD9Cnhy4iUHJeFzcUaVJFdyTFCFsFOLPhZi6ByO73fignEr
        +ZPF6HUj7JxMoLgURZG78H5TJw/R3rShZU8/iHg4zo4MOKX8CiEVEAxw8Znfl1GPw9bJV6NF7Vum0
        2tEivDNA==;
Received: from 089144208145.atnat0017.highway.a1.net ([89.144.208.145] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZt92-0008U5-OU; Tue, 03 Nov 2020 10:02:29 +0000
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
Subject: block ioctl cleanups v2
Date:   Tue,  3 Nov 2020 11:00:08 +0100
Message-Id: <20201103100018.683694-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

this series has a bunch of cleanups for the block layer ioctl code.

Changes since v1:
 - drop the patch to return the correct error for unknown ioctls in mtip
 - add back an empty line in rbd
 - various spelling fixes
