Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578DE6A504F
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Feb 2023 01:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjB1A4I (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Feb 2023 19:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjB1A4I (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Feb 2023 19:56:08 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65F12940A
        for <linux-bcache@vger.kernel.org>; Mon, 27 Feb 2023 16:56:03 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 63C3985;
        Mon, 27 Feb 2023 16:56:03 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id YjmNdhkB6u4u; Mon, 27 Feb 2023 16:56:02 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 1ACBD40;
        Mon, 27 Feb 2023 16:56:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 1ACBD40
Date:   Mon, 27 Feb 2023 16:56:02 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     linux-bcache@vger.kernel.org
Subject: bugfix commits since 5.15 not marked with Cc: stable
Message-ID: <577d7e59-33ff-77bb-5a31-a18d7ca9834a@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Coly,

I was looking through the commits between 5.15 and the latest kernel 
release. It looks like the following commits may benefit from being marked 
for inclusion in the stable kernel trees.

Is there any reason that any of these should be excluded from the stable 
release kernels?

	d55f7cb2e5c0 bcache: fix error info in register_bcache()
	7b1002f7cfe5 bcache: fixup bcache_dev_sectors_dirty_add() multithreaded CPU false sharing
	a1a2d8f0162b bcache: avoid unnecessary soft lockup in kworker update_writeback_rate()

	# These two depend on each other, so apply both or neither:
	0259d4498ba4 bcache: move calc_cached_dev_sectors to proper place on backing device detach
	aa97f6cdb7e9 bcache: fix NULL pointer reference in cached_dev_detach_finish

If they look good to you then I will write an email to the stable list.

Thanks!

--
Eric Wheeler
