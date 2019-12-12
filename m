Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78AB11D121
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Dec 2019 16:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbfLLPgJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Dec 2019 10:36:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50000 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729139AbfLLPgI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Dec 2019 10:36:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+J2KdwAbR0JzJlhSve69wL9VcrE5IBy/HaBtPEsqCPk=; b=Df/c4412CxjhwQHqH/U1sWE9N
        G5t/iTs2FYuzLgWwmo585PU6nPPvJxF2PygiMBmD2aVh7avILaEsatkS+/jUEKke1/FJ2rsvwpX3w
        VtK81xMBbdSUtBYMdSYN+DuHv9kvq53qqt4uY2jUDymVT1Sty6RK0BA18cpJ+cnlyC09pcbpdGIkI
        Di4Q/aDmkMUtmBiqj/BbVX92FqwrRjyTlV+DSKyf2Q5ydFdbGjcWwoYIFKPyiqkIAOvn8eSZt0I0Y
        obfOja0aZEvdAx8Tt935GKVeBAWazggVRZKqlJRPQ5nEpDwZUxGI1YDulZVwxsV0JdB2GSeGcEWz+
        CRk//6GvQ==;
Received: from [2001:4bb8:188:2b00:20e6:8b5a:ed96:f9da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifQVa-0007IN-PY; Thu, 12 Dec 2019 15:36:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, liangchen.linux@gmail.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: bcache superblock reading / writing v2
Date:   Thu, 12 Dec 2019 16:35:57 +0100
Message-Id: <20191212153604.19540-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly and Liang,

can you review this series to sort out the bcache superblock reading for
larger page sizes?  I don't have bcache test setup so this is compile
tested only.

Changes since v1:
 - actually assing ->sb_disk
 - fix the cover letter subject line
