Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC2842BF8
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Jun 2019 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbfFLQUH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 12 Jun 2019 12:20:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:41496 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730745AbfFLQUH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 12 Jun 2019 12:20:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 53B7EAF90;
        Wed, 12 Jun 2019 16:20:06 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 0/4] Fixes for potential deadlock during reboot
Date:   Thu, 13 Jun 2019 00:19:54 +0800
Message-Id: <20190612161958.2082-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

Recently during my for-4.3 testing, I observe some lockdep warnings for
potential deadlock during reboot the kernel. Such potential deadlocks
are very hard to trigger in real life, but fix them and make lockdep
happy is still worthy IMHO.

This series is an effort to fix the potential deadlock issues, since
they are not critical stability fixes, they won't be CCed to stable
mailing list.

Thanks in advance for any commnet or review.

Coly Li
---

Coly Li (4):
  bcache: avoid a deadlock in bcache_reboot()
  bcache: acquire bch_register_lock later in cached_dev_detach_finish()
  bcache: acquire bch_register_lock later in cached_dev_free()
  bcache: fix potential deadlock in cached_def_free()

 drivers/md/bcache/super.c     | 49 +++++++++++++++++++++++++++++++++++++------
 drivers/md/bcache/sysfs.c     | 26 +++++++++++++++++++++++
 drivers/md/bcache/writeback.c |  4 ++++
 3 files changed, 73 insertions(+), 6 deletions(-)

-- 
2.16.4

