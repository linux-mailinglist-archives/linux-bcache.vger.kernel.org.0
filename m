Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E4E1E1D96
	for <lists+linux-bcache@lfdr.de>; Tue, 26 May 2020 10:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgEZIqb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 May 2020 04:46:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:41886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbgEZIqb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 May 2020 04:46:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5FD8AAEF9
        for <linux-bcache@vger.kernel.org>; Tue, 26 May 2020 08:46:33 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 0/2] bcache: asynchronous devices registration
Date:   Tue, 26 May 2020 16:46:23 +0800
Message-Id: <20200526084625.24989-1-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This simple series is to add an asynchronous devices registration
interface for experiment. The async registration may help the bcache
register udev task to return without wait, and avoid to be killed
due to the udevd timeout.

For common users this async interface is unnecessary. For users who
has extream large cached data set and encounters the boot time bcache
registration failure may have a try on this series. This asynchronous
registration behavior will be set to default in future.

Thanks in advance for your comments and feedback.

Coly Li
---

Coly Li (2):
  bcache: asynchronous devices registration
  bcache: configure the asynchronous registertion to be experimental

 drivers/md/bcache/Kconfig |   9 ++++
 drivers/md/bcache/super.c | 102 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+)

-- 
2.25.0

