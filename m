Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D2310DFA2
	for <lists+linux-bcache@lfdr.de>; Sat, 30 Nov 2019 23:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfK3Weo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 30 Nov 2019 17:34:44 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:39097 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbfK3Weo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Nov 2019 17:34:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id DD0B4A0633;
        Sat, 30 Nov 2019 22:34:43 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id tCfLa0HEUJD6; Sat, 30 Nov 2019 22:34:13 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 47114A0440;
        Sat, 30 Nov 2019 22:34:13 +0000 (UTC)
Date:   Sat, 30 Nov 2019 22:34:10 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     linux-bcache@vger.kernel.org
Subject: Backport bcache v5.4 to v4.19
Message-ID: <alpine.LRH.2.11.1911302229090.31846@mx.ewheeler.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

We use 4.19.y and there have been many performance and stability changes 
since then.  I'm considering backporting the 5.4 version into 4.19 and 
wondered:

Are there any changes in bcache between 4.19 and 5.4 that depend on new 
features elsewhere in the kernel, or should I basically be able to copy 
the tree from 5.4 to 4.19 and fix minor compilation issues?

Can you think of any issues that would arise from such a backport?

--
Eric Wheeler
