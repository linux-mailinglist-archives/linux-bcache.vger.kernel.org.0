Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7103DFE81
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 11:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbhHDJ7Q (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 05:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbhHDJ7M (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 05:59:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE59CC0613D5;
        Wed,  4 Aug 2021 02:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=iCTES/jGTKt1OfjMrhlawZMqwAYC0jLr5onZbcA+m34=; b=MDee0jbdda1PrONJpVeGXBHuy2
        LiDExJ1f33ybqwNU2QnJ/zuXxPMiScGpo40hRx6L4ii8AUAzsuebyiUWtS9zvLF7q+Ka5kMVTDPh9
        GcqOhcoXzHpVJ+dojfU8bSR3PX0eP54r+VDeH1/tOCEmdw6dAQl8OEBaZTEuHkJnXx6jJm5kLbPO4
        IVqrFUlh+79JwZstyhZObANnUAWrLsC2zqzgIT9gSEEWEajGiCV6n5zEByE225A3OuRC9YJoaOlyn
        VgMpMPa2NomKilnlgfwNo3r/5Rf0MeeVqrrcgekL/QJNSydK2F0Ww0wJ4ImIooU5q76l6VltgmP8Y
        K5ofBj+g==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDdb-005eoq-AF; Wed, 04 Aug 2021 09:56:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Coly Li <colyli@suse.de>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: add a bvec_virt helper
Date:   Wed,  4 Aug 2021 11:56:19 +0200
Message-Id: <20210804095634.460779-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

this series adds a bvec_virt helper to return the virtual address of the
data in bvec to replace the open coded calculation, and as a reminder
that generall bio/bvec data can be in high memory unless it is caller
controller or in an architecture specific driver where highmem is
impossible.
