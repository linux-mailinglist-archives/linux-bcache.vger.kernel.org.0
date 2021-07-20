Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CEB3CF168
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jul 2021 03:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbhGTAy7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Jul 2021 20:54:59 -0400
Received: from mx.ewheeler.net ([173.205.220.69]:46544 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233852AbhGTAyo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Jul 2021 20:54:44 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jul 2021 20:54:37 EDT
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.ewheeler.net (Postfix) with ESMTPSA id 7D8BD1A;
        Tue, 20 Jul 2021 01:28:36 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ewheeler.net 7D8BD1A
Authentication-Results: mail.ewheeler.net; dkim=none
Date:   Tue, 20 Jul 2021 01:28:33 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@pop.dreamhost.com
To:     kent.overstreet@gmail.com
cc:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: bcachefs snapshots
Message-ID: <alpine.LRH.2.21.2107200122520.27704@pop.dreamhost.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Kent,

I read your bcachefs snapshots doc recently, it looks like you've put a 
lot of thought into it.  Is it ready for testing?  

We use a lot of btrfs snapshots of VM images but the performance is pretty 
poor and I'm looking forward to trying out bcachefs snapshots when it is 
ready to try out.

We also have many dm-thin deployments backed by /dev/bcache0 volumes that 
work quite well, but dm-thin meta is always an ongoing maintenance issue.
(Don't run out of dm-thin meta space or *boom*!)

If bcachefs can replace dm-thin with loopback files (or even better, 
native bcachefs devices!) then I look forward to getting beyond
dm-thin into something more scalable.

Cheers,

-Eric


--
Eric Wheeler
