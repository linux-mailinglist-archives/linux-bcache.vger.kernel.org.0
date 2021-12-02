Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE9C4666CB
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Dec 2021 16:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbhLBPkv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Dec 2021 10:40:51 -0500
Received: from mailbackend.panix.com ([166.84.1.89]:60364 "EHLO
        mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbhLBPkv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Dec 2021 10:40:51 -0500
Received: from xps-7390.lan (50-233-66-25-static.hfc.comcastbusiness.net [50.233.66.25])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4J4g7W0QqVz2jCv;
        Thu,  2 Dec 2021 10:37:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1638459447; bh=dbKm0N0V3+vmx7loDcn20Anbh9JDyOpiRkOKnYCaoPo=;
        h=Date:From:Reply-To:To:cc:Subject:In-Reply-To:References;
        b=A7kKY5Je6s5F+dwDSFtlTMCWbUVWbq9JEsNVRFpg6ZFGq6fmQ1UUeLeXnMbRDBhsn
         BtdVL5OPgxJ0b3FT8zipfDsiS5pO5uhkVwXWUeevTkneiIemJaYBXpyzJ1kqRR0PI7
         /e7O8ej/mv7oXZUrp+gru9VOcZ3QJYW+ge2XFneY=
Date:   Thu, 2 Dec 2021 07:37:26 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     Jens Axboe <axboe@kernel.dk>
cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        shinichiro.kawasaki@wdc.com
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
In-Reply-To: <4429eed8-b9b9-6943-f76-6ea38d695248@panix.com>
Message-ID: <a2eb227a-a4dc-e4e7-d3ea-567778bfc9c0@panix.com>
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com> <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk> <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com> <4429eed8-b9b9-6943-f76-6ea38d695248@panix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Thu, 2 Dec 2021, Kenneth R. Crudup wrote:

>   $ egrep -r . $(sudo find /sys/block/*/ -name inflight )
>
> ... but they were all zeros.

... and similarly:

----
$ sudo egrep -r . $(sudo find /sys/kernel/debug/block/ -name inflight)
/sys/kernel/debug/block/mmcblk0/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/mmcblk0/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/mmcblk0/rqos/wbt/inflight:2: inflight 0
/sys/kernel/debug/block/sda/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/sda/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/sda/rqos/wbt/inflight:2: inflight 0
/sys/kernel/debug/block/nvme0n1/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/nvme0n1/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/nvme0n1/rqos/wbt/inflight:2: inflight 0
/sys/kernel/debug/block/loop7/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/loop7/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/loop7/rqos/wbt/inflight:2: inflight 0
/sys/kernel/debug/block/loop6/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/loop6/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/loop6/rqos/wbt/inflight:2: inflight 0
/sys/kernel/debug/block/loop5/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/loop5/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/loop5/rqos/wbt/inflight:2: inflight 0
/sys/kernel/debug/block/loop4/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/loop4/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/loop4/rqos/wbt/inflight:2: inflight 0
/sys/kernel/debug/block/loop3/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/loop3/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/loop3/rqos/wbt/inflight:2: inflight 0
/sys/kernel/debug/block/loop2/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/loop2/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/loop2/rqos/wbt/inflight:2: inflight 0
/sys/kernel/debug/block/loop1/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/loop1/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/loop1/rqos/wbt/inflight:2: inflight 0
/sys/kernel/debug/block/loop0/rqos/wbt/inflight:0: inflight 0
/sys/kernel/debug/block/loop0/rqos/wbt/inflight:1: inflight 0
/sys/kernel/debug/block/loop0/rqos/wbt/inflight:2: inflight 0
----

(... but just now, I got a delayed popup from my UI, which then went back to
being unresponsive again)

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
