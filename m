Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D8830407C
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 15:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404343AbhAZOf5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Jan 2021 09:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404955AbhAZOfp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Jan 2021 09:35:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62062C0611C2;
        Tue, 26 Jan 2021 06:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=CDsuXNtf148roxef2LTAJvqAu83Q2Loacfr+PFBx5qQ=; b=FaR44Cb7bsArbnhcXbbrOzXn9U
        G+rikagp4OzeWRReSxP+8EhOk97Lg483MX5j4pfl0sLcaZNVvPsBBr5Hw2zP1seA3Uf1/LGf+jMT1
        cukyn8X8t3uHhNAfEomKgPAN1gTffYW5q2ISokxbb6m1xf6y0qmnEt8MJFRZH2fAQqqL3lY9X4Mm4
        LaZwEpTJAPK6ZEJAzJ+pLyJWEXVxssnPcrOdHS6qEE6THa9itb/xnbWhgWsMOvxOMMJCpgT4k5jyP
        Lv561ACi05HLCnbERchd3R207k7P2XQuuexfp0rZCOE+39lxWBsMarPux4NJ2KsDc53Ii6RF2JWWO
        UC10gElg==;
Received: from [2001:4bb8:191:e347:5918:ac86:61cb:8801] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l4PP4-005kB7-Eq; Tue, 26 Jan 2021 14:34:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-bcache@vger.kernel.org
Subject: additional ->bi_bdev fixups
Date:   Tue, 26 Jan 2021 15:33:05 +0100
Message-Id: <20210126143308.1960860-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

more fixes for the (so far theoretical) fallout from the ->bi_bdev
conversion.
