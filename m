Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5895D43102F
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 08:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhJRGLu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 02:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhJRGLt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 02:11:49 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FE8C06161C
        for <linux-bcache@vger.kernel.org>; Sun, 17 Oct 2021 23:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=gfPpXnuGqk1/zp0HLTC5jgQo8Asr/jPMstXk2yOaB6o=; b=Te3h3mgX9WKVvY2jP3At+Q1btP
        xX6vS4FQ26WPJyDJbbhBt4K4GiCTful7//Kqs5mYt36tg+6Jx1jC05BMSa9++Cw/s7aqas8bJZoBl
        /j836Ccp3NYmW7GrZtwDBhnuLUbEoAw2QgydyuHY0+rI/Ao5/KXrXYVKg/IIpOgaSJHgNWjyu/vfw
        P0kZEP/KIWZHsLnoCEM05Erof+JftRv6KAb4j9sIF3gh9iPeVg8lXAuyfoJjuUWHqckvcwztubXvP
        sqvbauAgNxEkEFtuMsR+vWtSY7qLHvM0rf+4nriTSADSYKMl0EIEgnOdL0il7HeRpMnd+4DMaN0EW
        2U/330hg==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcLq5-00EHj4-J2; Mon, 18 Oct 2021 06:09:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: misc bcache cleanups
Date:   Mon, 18 Oct 2021 08:09:30 +0200
Message-Id: <20211018060934.1816088-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

this series has a bunch of misc cleanups for bcache by using better kernel
interfaces.

Diffstat:
 bcache.h  |    4 ----
 btree.c   |    2 +-
 debug.c   |   15 +++++++--------
 io.c      |   16 ++++++++--------
 request.c |    6 +++---
 super.c   |   55 +++++++++++++++++++++++--------------------------------
 sysfs.c   |    2 +-
 util.h    |    8 --------
 8 files changed, 43 insertions(+), 65 deletions(-)
