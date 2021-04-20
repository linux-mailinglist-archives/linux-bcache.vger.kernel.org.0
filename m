Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536AC365192
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Apr 2021 06:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhDTEpu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Apr 2021 00:45:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:40724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhDTEpu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Apr 2021 00:45:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 99111B15E;
        Tue, 20 Apr 2021 04:45:18 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/2] bcache patches for Linux v5.13 - 3rd wave 
Date:   Tue, 20 Apr 2021 12:44:50 +0800
Message-Id: <20210420044452.88267-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

HI Jens,

Here are the current bcache fixes for already merged patches in
linux-next for Linux v5.13. 

Thank you in advance for taking them.

Coly Li
---

Colin Ian King (1):
  bcache: Set error return err to -ENOMEM on allocation failure

Coly Li (1):
  bcache: Kconfig dependence fix for NVDIMM support

 drivers/md/bcache/Kconfig     | 4 ++--
 drivers/md/bcache/nvm-pages.c | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.26.2

