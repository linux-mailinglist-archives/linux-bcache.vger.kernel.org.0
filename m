Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AD8D7AC3
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Oct 2019 18:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387697AbfJOQEP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 15 Oct 2019 12:04:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37172 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387630AbfJOQEP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Oct 2019 12:04:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FPH/RslDrB24iPPXAov8XCsMkgux/OZRPQ7rBf1jk+4=; b=f7SCrn5D2kFZJaU3VAVb5Knt3
        jDkkudEBSKO1A9q6KJxdXqwwjT1Cql1+L5lTmx5nE/gabscNq0nkLwXxf/sbN4Ig+8qUWWdfc0Unj
        Pl7Xl4B+7jcyjedMFr818Cu2yqjA59Ar+OACaIFfulnyv76jLaYc0BmvrS60LEan7/4r8zOC30UEf
        c3pCuBdfIpxPBXdIFLzR+8UpuC+d5YF7cqPWoF91gPybmBC50Kt5ZFtW+8mJerYs04zkwqPykJN5x
        n78X4HFaTeFPilfSd31nmxjcD1GEQDWSBlXhtxu97o2V/ZFm8c/UfpND2G6rbL4/Itzoab6wik5U8
        5hLYPp60A==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKPJ0-0002ay-9R; Tue, 15 Oct 2019 16:04:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: bcache kbuild cleanups
Date:   Tue, 15 Oct 2019 18:04:07 +0200
Message-Id: <20191015160409.14250-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

this series removes a pointless cflags override and unused exports
from bcache.
