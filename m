Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 984FF225A6
	for <lists+linux-bcache@lfdr.de>; Sun, 19 May 2019 03:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfESBft (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 18 May 2019 21:35:49 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:59702 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727305AbfESBft (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 18 May 2019 21:35:49 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 May 2019 21:35:49 EDT
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 066C1A0692;
        Sun, 19 May 2019 01:30:23 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id aOdPknI5BKAS; Sun, 19 May 2019 01:30:22 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 2431BA067D;
        Sun, 19 May 2019 01:30:22 +0000 (UTC)
Date:   Sun, 19 May 2019 01:30:18 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     linux-bcache@vger.kernel.org
cc:     Coly Li <colyli@suse.de>
Subject: modify stripe_size while running
Message-ID: <alpine.LRH.2.11.1905190127420.27699@mx.ewheeler.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

What would it take to enable live modification of stripe_size in sysfs?

It auto-detects for md-raid[56], but for hardware controllers it would be 
nice to set the expensive stripe size to get the performance benefit 
there, too.

What do you think?


--
Eric Wheeler
