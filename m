Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B277F44E195
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Nov 2021 06:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhKLFjn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 Nov 2021 00:39:43 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:49760 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhKLFjm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Nov 2021 00:39:42 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A54B421B1F;
        Fri, 12 Nov 2021 05:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636695411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=IgwoP4se1EeuPE1ZS5s5+ZWw9h7jBOX88CJGXnKPtN8=;
        b=u0SQQiVnMSVUAapqjZvzfYyPYvRvGAoxsOwIF0jAVkRttn54vfXe9LB4AiiSUnMfsQh1SA
        ezyhk+yuMeI3Jig8/KzG/SNMh+qgguiC4UD0/fpKhCJJkwfqMl+9HVD7zG/uAyfv2sriCC
        19jX6urQNFDMjrIOV5kCna+8CuHoGCY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636695411;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=IgwoP4se1EeuPE1ZS5s5+ZWw9h7jBOX88CJGXnKPtN8=;
        b=EvCFiWXEqaG8EmKiXKpce+7E60GQmVwVPvLMAZJU3V1pNqsS9V2R8fHZmEyd5sst3nPGpV
        dNZmaaii0VepeXBQ==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 1F5BAA3B81;
        Fri, 12 Nov 2021 05:36:49 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/1] bcache patche for Linux v5.16-rc1 
Date:   Fri, 12 Nov 2021 13:36:28 +0800
Message-Id: <20211112053629.3437-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Here we have 1 patch from Lin Feng, which is a fix for his previous
patch which already picked in Linux v5.16 merge window.

Please take it, and thank you in advance.

Coly Li
---

Lin Feng (1):
  bcache: fix NULL pointer reference in cached_dev_detach_finish

 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.31.1

