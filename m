Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027067DD27D
	for <lists+linux-bcache@lfdr.de>; Tue, 31 Oct 2023 17:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346584AbjJaQpO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 31 Oct 2023 12:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346515AbjJaQo5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 Oct 2023 12:44:57 -0400
X-Greylist: delayed 508 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 Oct 2023 09:33:34 PDT
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6981630E1
        for <linux-bcache@vger.kernel.org>; Tue, 31 Oct 2023 09:33:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698769503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2/WqVk2ZLmZJ6bgdjF1aGMs2a9ubs62YR4GPwL+7LDI=;
        b=Pm0ogUfAr1KunimWLPdFW+wIyni6jlMAfmX2xekYUo2NrYptSIi+SqiGgvUuzeqZ6L/eQC
        EWpXSR3DIR0CWH+SSPTYkcCyBRKX+AE3tgoLZN2Mi4avD9d9/YU1CA18Nq0ZE0DfkmbJkw
        q8Fgez5OCtEcFfBHxr8RCgsAV4JOGjI=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/2] Two small closures patches
Date:   Tue, 31 Oct 2023 12:24:50 -0400
Message-ID: <20231031162454.3761482-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I'll be sending these to Linus in my next pull request, sending them to
linux-bcache so Coly gets a chance to see them.

Kent Overstreet (2):
  closures: Better memory barriers
  closures: Fix race in closure_sync()

 fs/bcachefs/fs-io-direct.c |  1 +
 include/linux/closure.h    | 12 +++++++++---
 lib/closure.c              |  9 +++++++--
 3 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.42.0

