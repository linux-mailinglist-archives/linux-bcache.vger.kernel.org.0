Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EA31B844C
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Apr 2020 09:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgDYHxl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Apr 2020 03:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgDYHxl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Apr 2020 03:53:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B90C09B049;
        Sat, 25 Apr 2020 00:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=qEn0IVVatMU5PSDXEa1uFzf1UtuhZxKLDIHyNqbL3+o=; b=CDIwbgkLBMTtGUB0vNRGAO3wZr
        yV/DBmIZdkudJ045Jcy5bxXqTa5bG6g1QRA3ixbeA0JZ6P1QVmFYWIpcQ5EWh2y0WURj5Xm2spF8b
        slX4lWqbDvEB3GN2ROSU1YuLkygkISO44j4ogBH+xYGRHqH/cGef2IWolXEapO9tCT1oRrZ63fk5G
        PxspZvq8BAnJ0Rcy63HEJiAhFL0OFO/p4Xdg+1qmbILC9bTeQwuOwiWAMFySCalza9fcwQPYlbFF2
        83hSeUdYDB3nu+qcGsSYQuBQeYrMxPlwyoZ4ZUhfqOOxLaZMHRQkBXVbKae66sgCs0Qv5i1ApkSRG
        5hnIMY3A==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSFd4-0007cs-S0; Sat, 25 Apr 2020 07:53:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: avoid the ->make_request_fn indirect for blk-mq drivers
Date:   Sat, 25 Apr 2020 09:53:33 +0200
Message-Id: <20200425075336.721021-1-hch@lst.de>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

this small series avoids an indirect call for every submitted bio that
eventually ends up being handled by blk-mq drivers.  Let me know what
you think.
